> ⚠️ **REFRAME BANNER — Git.aDNA genesis, 2026-06-19.** This is an original *Lighthouse.aDNA* seed-set document (authored 2026-06-11) carrying the **self-hosted-Forgejo-first** thesis: *"git.aDNA is canonical; GitHub is the harbor."* Git.aDNA **adopts it as source material**, but its top-level thesis is **reframed to provider-agnostic** per [[adr_001_seed_docs_reframe]]: GitHub / Codeberg / self-hosted Forgejo are all first-class profiles, and self-hosted **mesh-git is the strategic north star — not the mandated canonical home**. Read it for substance (architecture · requirements · repo-class P/I/R model · migration mechanics), **not** for the canonical-host stance. The *binding* version is authored at genesis **P2**. Live phase: `STATE.md`.

---
adna: Lighthouse.aDNA
type: requirements
version: 0.1.0
status: draft-for-ratification
date: 2026-06-11
depends_on: [00_CHARTER.md, 01_ARCHITECTURE.md]
---

# Lighthouse.aDNA — Requirements

**Format:** `REQ-<DOMAIN>-<NNN> · <Priority M/S/C> · <Tiers>` — statement, then **AC** (acceptance criterion).
Priorities: **M**ust, **S**hould, **C**ould. Tiers: L1/L2/L3 applicability.

## GOV — Governance & the Chart

- **REQ-GOV-001 · M · all** — The subnet registry SHALL be the repo `network/chart` on git.aDNA; each lighthouse is one signed entry file. **AC:** `pharos` entry merged; schema validated in CI.
- **REQ-GOV-002 · M · all** — A lighthouse SHALL join the subnet only by pull request to the Chart, reviewed by a Keeper of an existing lighthouse. **AC:** join runbook executed end-to-end at least once.
- **REQ-GOV-003 · M · all** — Architectural deviations SHALL be recorded as ADRs in `_meta/decisions/`. **AC:** ADR template exists; ≥1 ADR filed during genesis.
- **REQ-GOV-004 · S · all** — The Chart SHALL be machine-readable by the Lattice federation router (YAML frontmatter per entry). **AC:** parse script in CI passes.

## FRG — Forge (git.aDNA)

- **REQ-FRG-001 · M · all** — The forge SHALL be Forgejo, deployed via the `core` profile. **AC:** version pinned; healthcheck green.
- **REQ-FRG-002 · M · all** — Forgejo Actions SHALL be enabled with GitHub-compatible workflow syntax; ≥1 runner registered per lighthouse. **AC:** sample workflow ports from GitHub unmodified and passes.
- **REQ-FRG-003 · M · L2–L3** — The package registry SHALL be enabled for OCI, npm, PyPI, and generic packages; lighthouse images ship from `forge/` org. **AC:** `docker pull git.adna.network/forge/<image>` succeeds over mesh.
- **REQ-FRG-004 · M · all** — Git LFS SHALL be enabled; backend Garage (L2+) or local disk (L1). **AC:** 1 GB LFS object round-trips.
- **REQ-FRG-005 · M · all** — Org layout SHALL match Architecture §6 (`network`, `vaults`, `forge`, `wilhelm`, `sws`, `labs`, `public-mirrors`). **AC:** orgs exist with documented ACLs.
- **REQ-FRG-006 · M · all** — Protected default branches on `network/*` and `vaults/*` SHALL require signed commits. **AC:** unsigned push rejected in test.
- **REQ-FRG-007 · S · all** — Repository metadata migration from GitHub (issues, PRs, releases, wiki) SHALL use Forgejo's built-in migrator where metadata has value. **AC:** one repo migrated with issues intact.
- **REQ-FRG-008 · C · L2–L3** — Forge federation (ForgeFed) readiness SHALL be tracked; no production dependency until ratified by ADR. **AC:** watch-item note exists.

## MIG — GitHub Replacement

- **REQ-MIG-001 · M · all** — Every repository SHALL be classified P, I, or R per charter §4 before rehoming. **AC:** classification table reviewed and signed by Steward.
- **REQ-MIG-002 · M · all** — After flagship genesis (D+0), no new internal (Class I) repository SHALL be created on GitHub. **AC:** doctrine block present in every sibling vault's agent contract; spot-check passes.
- **REQ-MIG-003 · M · all** — Class I repos SHALL have `origin` on git.aDNA and **no** GitHub remote. **AC:** `git remote -v` audit script reports zero violations at campaign close.
- **REQ-MIG-004 · M · all** — Class R repos SHALL be canonical on git.aDNA with push-mirror to GitHub on tags/releases; GitHub remote named `harbor`. **AC:** tag push appears on GitHub ≤ 15 min.
- **REQ-MIG-005 · M · all** — Class P repos (e.g., `Wilhelm-Foundation/rare-archive`) SHALL remain GitHub-primary with a pull-mirror into `public-mirrors` (lag ≤ 24 h). **AC:** mirror current; community workflow undisturbed.
- **REQ-MIG-006 · M · all** — Client material (`sws/*`), secrets, and unpublished research SHALL never transit GitHub, including in git history. **AC:** pre-push scan hook installed on Class R; history audit clean on rehomed client repos.
- **REQ-MIG-007 · M · all** — Migration SHALL begin only after the flagship restore drill passes (REQ-BCK-003). **AC:** drill report precedes first rehome in the log.
- **REQ-MIG-008 · M · all** — A 90-day rollback window SHALL be maintained: GitHub originals retained read-only (push disabled by token scope) until campaign review. **AC:** rollback runbook exists; window dated.
- **REQ-MIG-009 · S · all** — LFS objects SHALL be fully fetched from GitHub (`git lfs fetch --all`) prior to rehoming any LFS-bearing repo. **AC:** object-count parity check per repo.

## NET — Network & Mesh

- **REQ-NET-001 · M · all** — All write-plane access (git SSH, admin UIs) SHALL be mesh-only. **AC:** external port scan shows :443 read-plane only.
- **REQ-NET-002 · M · all** — Mesh: Tailscale at genesis; migration path to Headscale documented. **AC:** ADR-ready Headscale runbook exists.
- **REQ-NET-003 · M · all** — Public TLS SHALL be automatic via Caddy. **AC:** A-grade TLS scan on flagship.
- **REQ-NET-004 · S · L2–L3** — Mesh ACLs SHALL scope each agent machine account to its function and site. **AC:** ACL file in vault; deny-by-default verified.

## IDN — Identity

- **REQ-IDN-001 · M · all** — One OIDC plane (Authentik + LLDAP) SHALL front all human-facing services. **AC:** Forgejo, Zulip, Grafana, HedgeDoc log in via OIDC.
- **REQ-IDN-002 · M · all** — Each agent SHALL have a dedicated machine account, fine-scoped token (≤ 90-day rotation), and SSH signing key. **AC:** token inventory note current; rotation runbook exists.
- **REQ-IDN-003 · M · all** — Agent commits SHALL be SSH-signed and carry an `Agent:` trailer distinguishing them from human commits. **AC:** `git log` audit on genesis commits passes.
- **REQ-IDN-004 · M · all** — Break-glass credentials per service SHALL exist, sops-sealed, tested annually. **AC:** seal verified; drill scheduled.

## DEP — Deployment & Packaging

- **REQ-DEP-001 · M · all** — v0.1 packaging SHALL be Docker Compose with profiles `core`/`collab`/`inference`/`ops`, driven by `make` (or `just`). **AC:** `make up core` from clean clone reaches healthy in ≤ 30 min on L1 hardware.
- **REQ-DEP-002 · M · all** — Site configuration SHALL be one `site.env` plus sops-encrypted secrets; no plaintext secrets anywhere in the vault. **AC:** secret scan in CI clean.
- **REQ-DEP-003 · M · all** — Seed bootstrap SHALL resolve the forge paradox per Architecture §8. **AC:** genesis runbook executes the four steps verbatim.
- **REQ-DEP-004 · S · L2–L3** — A FluxCD/k3s migration path SHALL be specified such that Compose service definitions translate without re-architecture. **AC:** mapping note exists per service.
- **REQ-DEP-005 · C · all** — A NixOS flake expression of the lighthouse SHALL be maintained as a study branch. **AC:** branch exists; not a release gate.
- **REQ-DEP-006 · M · all** — All images SHALL be version-pinned; `latest` is prohibited. **AC:** compose lint rule enforced in CI.

## AGT — Agent Operations

- **REQ-AGT-001 · M · all** — Every runbook SHALL be agent-executable markdown: numbered steps, explicit verification gate per step, declared risk level, declared executor (`human|agent|either`). **AC:** runbook schema validates in CI.
- **REQ-AGT-002 · M · all** — The vault SHALL carry a CLAUDE.md agent contract defining autonomous vs gated actions (gated: infra changes, remote changes, secrets, cross-vault writes). **AC:** contract present; mirrors 04 §7.
- **REQ-AGT-003 · M · all** — Cross-vault integration changes SHALL be delivered as reviewable patch sets, never applied silently. **AC:** patches staged under `OPS/patches/` during genesis.
- **REQ-AGT-004 · S · all** — Cmux command tree SHALL gain a `g` namespace bound to git.aDNA operations (status, sync, mirror, PR). **AC:** spec stub delivered to Cmux.aDNA.

## INF — Inference Gateway

- **REQ-INF-001 · M · all** — Each lighthouse SHALL expose exactly one OpenAI-compatible endpoint via LiteLLM with per-key budgets and audit logs. **AC:** two keys, two budgets, usage visible.
- **REQ-INF-002 · M · all** — Backends: vLLM on CUDA tiers; llama.cpp/Ollama on Apple Silicon; RareHarness.aDNA configs load unchanged behind the gateway. **AC:** RareHarness smoke test passes through `llm.<site>`.
- **REQ-INF-003 · S · L3** — L3 lighthouses SHALL serve inference down-tier over mesh per Lattice routing. **AC:** L1 client resolves and completes against L3 pool.

## COL — Collaboration

- **REQ-COL-001 · M · L2–L3** — Threaded discussion (Zulip) and collaborative markdown (HedgeDoc) SHALL deploy in `collab`, OIDC-bound. **AC:** healthy; login via id plane.
- **REQ-COL-002 · S · L2–L3** — A Matrix/Conduit variant SHALL be documented for federation-purist sites. **AC:** variant compose override exists.
- **REQ-COL-003 · M · all** — Forgejo Issues SHALL be scoped to code defects and external collaboration; TaskNotes/TaskForge remains the task substrate; cross-links by URL. **AC:** doctrine note in 03 and in TaskForge patch.

## BCK — Backup & Recovery

- **REQ-BCK-001 · M · all** — Nightly `forgejo dump` + Postgres dumps + Garage snapshots via Restic to (a) a peer lighthouse and (b) one offsite target. **AC:** restic snapshots listed from both targets.
- **REQ-BCK-002 · M · all** — RPO ≤ 24 h for forge metadata; ~0 for git data (replication); RTO ≤ 4 h for flagship. **AC:** measured during drill.
- **REQ-BCK-003 · M · all** — A full restore drill SHALL pass on the flagship **before** migration Phase 3 and quarterly thereafter as a standing TaskForge mission. **AC:** drill report filed in `OPS/`.
- **REQ-BCK-004 · S · all** — Cross-lighthouse backup reciprocity SHALL be recorded in the Chart entry of each site. **AC:** field present and populated.

## SEC — Security

- **REQ-SEC-001 · M · all** — Zero public write surface (see REQ-NET-001); deny-by-default reverse proxy routes. **AC:** route inventory reviewed.
- **REQ-SEC-002 · M · all** — Secrets at rest only as sops-age ciphertext; age key custody documented. **AC:** custody note exists; CI secret scan clean.
- **REQ-SEC-003 · M · all** — Monthly patch session, agent-executed via upgrade runbook with changelog review gate. **AC:** standing mission in TaskForge patch.
- **REQ-SEC-004 · S · L2–L3** — 180-day audit retention (Forgejo audit + Loki). **AC:** retention config verified.

## OBS — Observability

- **REQ-OBS-001 · M · L2–L3** — Prometheus + Grafana + Loki with a lighthouse overview dashboard (forge, runners, gateway, backups). **AC:** dashboard renders with live data.
- **REQ-OBS-002 · M · L1** — Beszel (or equivalent single-binary monitor) + Uptime Kuma. **AC:** alerts reach Keeper channel.
- **REQ-OBS-003 · S · all** — Backup success/failure SHALL alert within 1 h of the nightly window. **AC:** induced failure alerts.

## AIR — Airgap

- **REQ-AIR-001 · M · where applicable** — Airlocked enclaves SHALL sync via signed `git bundle` and OCI archives per RemoteControl.aDNA airlock procedure. **AC:** round-trip bundle sync demonstrated.
- **REQ-AIR-002 · M · all** — `make up core` SHALL succeed with zero WAN given a pre-staged image archive. **AC:** offline genesis test passes.

## DOC — Documentation & Vault

- **REQ-DOC-001 · M · all** — The vault SHALL conform to 04_VAULT_SPEC.md, deferring to house dialect where they conflict (deviations logged as ADR). **AC:** conformance checklist in genesis report.
- **REQ-DOC-002 · M · all** — Canonical statements (charter §3) SHALL appear verbatim in README and propagated doctrine blocks. **AC:** grep audit passes.
- **REQ-DOC-003 · M · all** — Obsidian Bases SHALL exist for sites, repos (migration tracker), runbooks, and ADRs. **AC:** four bases render over seeded notes.

---
*Document 02 of 6 · Lighthouse.aDNA seed set · Mission LIGHTHOUSE-GENESIS*
