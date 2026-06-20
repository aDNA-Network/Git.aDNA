> ⚠️ **REFRAME BANNER — Git.aDNA genesis, 2026-06-19.** This is an original *Lighthouse.aDNA* seed-set document (authored 2026-06-11) carrying the **self-hosted-Forgejo-first** thesis: *"git.aDNA is canonical; GitHub is the harbor."* Git.aDNA **adopts it as source material**, but its top-level thesis is **reframed to provider-agnostic** per [[adr_001_seed_docs_reframe]]: GitHub / Codeberg / self-hosted Forgejo are all first-class profiles, and self-hosted **mesh-git is the strategic north star — not the mandated canonical home**. Read it for substance (architecture · requirements · repo-class P/I/R model · migration mechanics), **not** for the canonical-host stance. The *binding* version is authored at genesis **P2**. Live phase: `STATE.md`.

---
adna: Lighthouse.aDNA
type: charter
version: 0.1.0
status: draft-for-ratification
date: 2026-06-11
steward: Stanley Bishop
campaign: FIRST LIGHT
mission: LIGHTHOUSE-GENESIS
---

# Lighthouse.aDNA — Charter

> The aDNA network runs on the Lattice Protocol.
> A lighthouse is the unit of presence on that network: **one site, one stack, one repo.**

## 1. Mission

Package the operational presence of an aDNA subnet node — forge, identity, collaboration, inference gateway, and operations — into a single deployable, agent-operable context graph. Replace GitHub as the canonical home for all internal aDNA work. Retain GitHub solely as the public harbor.

## 2. The Function

Lighthouse.aDNA delivers two inseparable things:

1. **git.aDNA** — the sovereign forge function (Forgejo) that becomes the canonical origin for every `*.aDNA` vault, internal repository, client engagement, and infrastructure definition across the network.
2. **The Lighthouse stack** — the packaged node (identity, mesh, collab, inference, ops) within which the forge lives, deployable at tier L1 (edge), L2 (organization), or L3 (datacenter).

The vault that specifies the system *is* the system: clone it, configure a site identity, deploy. The repo is the node.

## 3. Canonical Statements

These phrases propagate verbatim into all dependent documentation:

- *"The aDNA network runs on the Lattice Protocol."*
- *"A lighthouse is the unit of presence on the network: one site, one stack, one repo."*
- *"The repo is the node. The Chart is the subnet."*
- *"git.aDNA is canonical. GitHub is the harbor — public-facing surfaces only."*

## 4. Names and Terms

| Term | Definition |
|---|---|
| **Lighthouse** | A deployed node: hardware + stack + site identity, registered on the Chart. |
| **Keeper** | The human operator of record for a lighthouse site. |
| **Flagship** | The first lighthouse; hosts the network-canonical forge at `git.adna.network`. Site-id: `pharos`. |
| **The Chart** | The subnet registry: repo `network/chart` on git.aDNA. A lighthouse joins the subnet by pull request to the Chart. |
| **Harbor** | GitHub, in its residual role: public discovery, community contribution, release mirrors. Remote name `harbor`. |
| **Repo classes** | **P** (Public-primary, lives on GitHub), **R** (Release, canonical on git.aDNA, push-mirrored to GitHub), **I** (Internal, git.aDNA only — the default). |
| **Tiers** | L1 edge (clinic/individual), L2 organization, L3 datacenter — per Lattice federated deployment architecture. |
| **Profiles** | Composable service groups: `core`, `collab`, `inference`, `ops`. |

## 5. Scope

**In scope**

- Forge service (git.aDNA): hosting, mirroring, CI (Forgejo Actions), package/OCI registry, LFS.
- Identity plane (OIDC), mesh networking, reverse proxy/TLS.
- Collaboration services (threaded discussion, collaborative markdown).
- Inference gateway (single OpenAI-compatible endpoint per lighthouse).
- Operations: backup/restore doctrine, observability, secrets, upgrades — all as agent-executable runbooks.
- Vault specification, migration doctrine (GitHub → git.aDNA), Chart governance.
- Integration directives for every sibling `*.aDNA` vault.

**Out of scope**

- Model training and Lattice router internals (owned by Lattice core documentation).
- Public community governance of Class P repos (e.g., `Wilhelm-Foundation/rare-archive`) — these remain GitHub-native.
- Self-hosted email. Never. Per-lighthouse managed mail (e.g., Migadu) only.
- Replacement of TaskNotes/TaskForge as the task substrate — Forgejo Issues are scoped to code defects and external collaboration only.

## 6. Success Criteria

1. Flagship (`pharos`) live: core profile deployed, `git.adna.network` serving over mesh, restore drill **passed before** any migration begins.
2. Net-new freeze in effect: zero new internal repositories created on GitHub after flagship genesis (D+0).
3. Every `*.aDNA` vault's `origin` remote points to git.aDNA by the close of Campaign FIRST LIGHT; GitHub remotes renamed `harbor` or removed per class.
4. The Chart exists, contains `pharos`, and join-by-PR governance is documented and exercised at least once.
5. All sibling vaults carry the forge doctrine block in their agent contracts (CLAUDE.md or dialect equivalent).
6. Quarterly restore drill scheduled as a standing TaskForge mission.

## 7. Locked Defaults (override by ADR only)

| Decision | Default | Rationale |
|---|---|---|
| Forge | Forgejo | Single binary, Actions-compatible, package/OCI registry, nonprofit governance, federation roadmap. |
| Collab | Zulip | Threaded async suits research discourse; Matrix/Conduit documented as the federation-purist variant. |
| Mesh | Tailscale now → Headscale when full sovereignty is demanded | Velocity first; sovereignty path preserved. |
| Object store | Garage (L2/L3); local disk (L1) | Lightweight, S3-compatible, geo-replication fits federation. |
| Secrets | sops + age, in-repo | Repo-is-the-node coherence; OpenBao at L3 if/when warranted. |
| Packaging | Docker Compose profiles (v0.1) → FluxCD/k3s (scale) → NixOS flake (study) | One box, one afternoon; GitOps trajectory preserved. |
| Flagship site-id | `pharos` | The first lighthouse. |

## 8. Authority

Changes to this charter, the locked defaults, or repo-class doctrine require an ADR in `_meta/decisions/` and the Steward's sign-off. Agents may propose; the Keeper of `pharos` (Stanley) ratifies.

---
*Document 00 of 6 · Lighthouse.aDNA seed set · Mission LIGHTHOUSE-GENESIS*
