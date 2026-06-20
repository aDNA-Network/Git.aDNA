> ⚠️ **REFRAME BANNER — Git.aDNA genesis, 2026-06-19.** This is an original *Lighthouse.aDNA* seed-set document (authored 2026-06-11) carrying the **self-hosted-Forgejo-first** thesis: *"git.aDNA is canonical; GitHub is the harbor."* Git.aDNA **adopts it as source material**, but its top-level thesis is **reframed to provider-agnostic** per [[adr_001_seed_docs_reframe]]: GitHub / Codeberg / self-hosted Forgejo are all first-class profiles, and self-hosted **mesh-git is the strategic north star — not the mandated canonical home**. Read it for substance (architecture · requirements · repo-class P/I/R model · migration mechanics), **not** for the canonical-host stance. The *binding* version is authored at genesis **P2**. Live phase: `STATE.md`.

---
adna: Lighthouse.aDNA
type: architecture
version: 0.1.0
status: draft-for-ratification
date: 2026-06-11
depends_on: [00_CHARTER.md]
---

# Lighthouse.aDNA — Architecture

## 1. Principles

1. **The repo is the node.** A lighthouse is fully described by its vault: `/docs` (WHO/WHAT/HOW), `/infra` (deployment), `/secrets` (sops-age encrypted). Clone → configure → deploy. No state lives outside the graph except runtime data, and runtime data is backed up by runbook.
2. **The Chart is the subnet.** `network/chart` on git.aDNA lists every lighthouse. Joining is a pull request; the federation router reads the Chart as its source of truth. Governance is code review.
3. **Agent-operable from boot.** Every runbook is agent-executable markdown with verification gates. LatticeAgent is the ops officer; the Keeper reviews, agents execute.
4. **Airgap-degradable.** Every flow has an offline mode: `git bundle` for repos, OCI image archives for containers, sneakernet sync runbooks for airlocked enclaves (RemoteControl.aDNA pattern). Hospital networks are assumed hostile.
5. **Identity-first.** One OIDC plane per lighthouse. Every service authenticates against it; no service-local accounts except break-glass.
6. **One-binary bias.** Prefer single-binary, low-dependency services (Forgejo, Garage, LLDAP, Caddy). Complexity is a maintenance tax paid monthly, forever.
7. **No public write surface.** Writes happen over the mesh. The public internet sees read-only mirrors and static sites.

## 2. Node Anatomy

```
                          ┌──────────────────────────────────────────────────────┐
   mesh (WireGuard) ────▶ │                   LIGHTHOUSE NODE                    │
   write plane            │                                                      │
                          │   Caddy (TLS) ─── Authentik (OIDC) ─── LLDAP (dir)   │
   public :443 ─────────▶ │     │                                                │
   read-only plane        │     ├──▶ Forgejo  ── LFS/registry ──▶ Garage (S3)    │
                          │     │      │ ▲                                       │
                          │     │      │ └── Forgejo Actions runner(s)           │
                          │     ├──▶ Zulip                                       │
                          │     ├──▶ HedgeDoc                                    │
                          │     └──▶ LiteLLM ──▶ vLLM (GPU) │ Ollama (Apple)     │
                          │                                                      │
                          │   Postgres (shared) · Restic ──▶ peer lighthouse     │
                          │   Prometheus/Grafana/Loki (L2+) · Beszel (L1)        │
                          └──────────────────────────────────────────────────────┘
```

## 3. Service Profiles

| Profile | Services | Tier | Notes |
|---|---|---|---|
| `core` | Forgejo, Caddy, Postgres, Authentik + LLDAP, mesh agent (Tailscale/Headscale), Garage (L2+) | L1–L3 | The minimum viable lighthouse. L1 may run Forgejo on SQLite and skip Garage (local-disk LFS). |
| `collab` | Zulip, HedgeDoc; *variant:* Conduit-class Matrix + Element; *optional:* Nextcloud **or** Radicale + Seafile if CalDAV/files groupware is required | L2–L3 | Zulip default per charter §7. |
| `inference` | LiteLLM gateway; vLLM (CUDA) or llama.cpp/Ollama (Apple Silicon) | L1–L3 | RareHarness.aDNA drops in unchanged behind LiteLLM. |
| `ops` | Forgejo Actions runner(s) or Woodpecker, Prometheus + Grafana + Loki (L2+), Beszel (L1), Uptime Kuma, Restic | L1–L3 | Runners are the only ops component mandatory at every tier. |

## 4. Naming, DNS, and Network

- **Zone:** `adna.network`. Flagship services: `git.adna.network`, `id.adna.network`, `chat.adna.network`, `docs.adna.network`, `llm.adna.network`.
- **Sites:** `<svc>.<site>.adna.network` (e.g., `git.ucla.adna.network`). Mesh-internal names via MagicDNS; public DNS only for read-only surfaces.
- **Write plane:** SSH (git) and admin UIs reachable **only** over the mesh. Mesh ACLs scope agents and Keepers to their sites.
- **Read plane:** Caddy serves public read-only content (Class R mirrors' web view, SiteForge static sites) on :443 with automatic TLS.
- **Airlocked enclaves:** no mesh. Sync via signed `git bundle` + OCI `docker save` archives through the RemoteControl.aDNA airlock procedure.

## 5. Identity Plane

- **Authentik** is the OIDC provider; **LLDAP** the directory beneath it. Forgejo, Zulip, Grafana, HedgeDoc, LiteLLM admin all consume OIDC.
- **Humans:** one identity per person, per network — not per service.
- **Machine accounts:** one per agent function (`agent-lattice`, `agent-cmux`, `agent-siteforge`, …) with fine-scoped Forgejo tokens (90-day rotation) and dedicated SSH signing keys. Agent commits are SSH-signed and carry an `Agent:` trailer.
- **Break-glass:** one local admin per service, credentials sops-sealed, used only when the identity plane itself is down.

## 6. Forge Service Specification — git.aDNA

**Engine:** Forgejo. Actions enabled (GitHub-compatible workflow syntax), package registry enabled (OCI, npm, PyPI, generic), LFS backed by Garage (L2+) or local disk (L1).

**Organization layout (flagship):**

| Org | Contents |
|---|---|
| `network` | `chart` (the subnet registry), `lighthouse` (this vault), protocol documentation |
| `vaults` | Every `*.aDNA` context graph: TaskForge, Cmux, Canvas, LatticeAgent, RareHarness, SiteForge, VideoForge, RemoteControl, … |
| `forge` | Infrastructure: runner images, Caddy configs, shared Actions workflows |
| `wilhelm` | Wilhelm Foundation internal repositories |
| `sws` | Smarter with Science engagements; one sub-prefix per client (`sws/superleague-*`) — strictest ACLs on the forge |
| `labs` | Experiments and spikes |
| `public-mirrors` | Read-only pull-mirrors of Class P GitHub repos (e.g., `rare-archive`) for sovereignty and backup |

**Policies:** protected default branches on `network/*` and `vaults/*` require signed commits; mirror intervals — pull-mirrors ≤ 24 h, push-mirrors on tag/release; repository deletion restricted to Keeper role.

## 7. Replication Topology

```
                       GitHub (harbor)
                 Class P primary ▲   ▲ Class R push-mirror (tags/releases)
                 pull-mirror ────┘   │
                                     │
   ┌──────────────────── FLAGSHIP: pharos ── git.adna.network ───────────────────┐
   │                     canonical origin for all Class I and R                  │
   └───────┬───────────────────────┬────────────────────────────┬────────────────┘
           │ pull-mirror (≤24h)    │ pull-mirror                │ signed bundles
           ▼                       ▼                            ▼
     Site lighthouse A       Site lighthouse B          Airlocked enclave
     (local forge, local     (local forge)              (RemoteControl airlock,
      writes; PR upstream)                               sneakernet sync)
```

- **Canonical origin** for the network lives on the flagship. Site forges pull-mirror the orgs they need and host their own site-local repos; contributions upstream travel as PRs or direct pushes per ACL.
- **Git data is self-replicating by nature** (every clone is a backup). Forge **metadata is not** — issues, wiki, releases require `forgejo dump` (see backup doctrine, 03 §6).
- **Degradation:** WAN loss → mesh-local operation continues; flagship loss → site forges keep read-write locally and reconcile by merge on recovery (issue divergence accepted; issues are site-local by doctrine).

## 8. The GitOps Loop and the Bootstrap Paradox

Target state: each lighthouse's vault lives on its own forge, and the node reconciles itself from that repo — at v0.1 via `make`-driven Compose, at scale via FluxCD watching the repo on k3s. **The forge operates the fleet.**

The paradox — the forge hosts the repo that deploys the forge — resolves by **seed bootstrap**:

1. Genesis boot runs from a local clone of the vault (USB/laptop).
2. `make up core` brings up the forge.
3. The vault is pushed to the newborn forge, which becomes `origin`.
4. From that commit forward, the loop is closed: changes land in the repo; the node reconciles.

## 9. Tier Reference Architectures

| Tier | Hardware envelope | Profiles | Forge backing | Notes |
|---|---|---|---|---|
| **L1 edge** | Mac mini (M-series) / N100-class, 16 GB | `core` (lean) + `inference` (Ollama) + runner | SQLite, local LFS | Clinic / individual researcher. Core profile idle budget ≤ 4 GB RAM. |
| **L2 org** | 1× 64–128 GB server or 3-node k3s | all profiles | Postgres + Garage | Foundation / lab / accelerator. |
| **L3 datacenter** | GPU racks (Dell alliance class) | all + vLLM pools | Postgres HA + Garage multi-node | Serves inference down-tier; FluxCD GitOps mandatory. |

## 10. Security Model

- Zero public write surface; SSH and admin over mesh only.
- sops-age secrets committed encrypted; age keys held by Keeper + flagship break-glass escrow.
- Signed commits on protected branches; agent identity always distinguishable from human identity in history.
- Pre-push secret scanning hook mandatory on all Class R repos (nothing unpublished transits the harbor, including in history).
- Audit: Forgejo audit log + Loki retention 180 days (L2+).
- Patch cadence: monthly maintenance session, agent-executed via upgrade runbook, pinned versions, changelog review gate.

## 11. Failure Modes

| Failure | Behavior | Recovery |
|---|---|---|
| WAN loss at site | Mesh-local + airgap modes continue | Automatic on restore |
| Flagship loss | Sites operate locally; harbor mirrors still serve public reads | Restore runbook, RTO ≤ 4 h, RPO ≤ 24 h (metadata), ~0 (git data) |
| Identity plane down | Break-glass local admin per service | Runbook `restore-identity` |
| Site loss | Chart marks site dark; peers hold its Restic backups | Re-provision from vault + restore |

---
*Document 01 of 6 · Lighthouse.aDNA seed set · Mission LIGHTHOUSE-GENESIS*
