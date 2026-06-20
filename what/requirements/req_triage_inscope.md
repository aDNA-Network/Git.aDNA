---
type: requirements
created: 2026-06-19
updated: 2026-06-19
status: active
last_edited_by: agent_stanley
campaign: campaign_git_genesis
phase: P1
tags: [requirements, git, triage, scope, seed, p1]
---

# Seed-REQ Triage — In-Scope for Git.aDNA vs. Deferred Lighthouse Deployable

> P1 deliverable. The Lighthouse seed set (`requirements_forge_seed.md`) carries **56 REQs across 14 domains** written for the *whole node stack*. Git.aDNA's scope is **git / forge / CI-CD only** ([[adr_000_project_identity]] D4, [[adr_001_seed_docs_reframe]] D2/D3). This triages each domain: **IN** (Git.aDNA owns) · **DEFER** (a future `Lighthouse.aDNA` deployable / other graph). Domain-level (per-REQ refinement at P2).

| Domain | REQs | Disposition | Owner / rationale |
|---|---|---|---|
| **FRG** — Forge | 8 | ✅ **IN (core)** | Forgejo, Actions, package/OCI registry, LFS, org layout, signed commits, metadata migration, ForgeFed-readiness — the heart of the provider abstraction + CI parity. |
| **MIG** — Migration | 9 | ✅ **IN (core)** | Repo classification (P/I/R → visibility×provider), net-new policy, rehoming mechanics, secret-scanning, rollback window — the P6 fleet-alignment engine. |
| **GOV** — Governance | 4 | ◐ **IN (partial)** | Chart governance + machine-readable registry → reframe as the **`git/` consumer-wrapper declaration** + the fleet ledger. ADR discipline = standard (kept). |
| **AGT** — Agent | 4 | ◐ **IN (partial)** | Runbook schema + the **CLAUDE.md git-ops doctrine block** + cross-vault patch discipline = IN. The Cmux `g`-namespace → Terminal.aDNA (DEFER). |
| **SEC** — Security | 4 | ◐ **IN (partial)** | Zero-public-writes posture, secret-scan, audit retention = IN (git-relevant). sops-age **secret *storage*** → Home.aDNA broker (coordinate, not own). |
| **DOC** — Docs | 3 | ◐ **IN (partial)** | Vault conformance + canonical-statements grep = IN as the doctrine-block + wrapper checks. |
| **DEP** — Deploy | 6 | ⛔ **DEFER** | Docker Compose / FluxCD / k3s / NixOS — *deploying* a forge = the **Lighthouse deployable** (P7 spike → future `Lighthouse.aDNA`). |
| **NET** — Network | 4 | ⛔ **DEFER** | Mesh-only writes, Tailscale→Headscale, TLS, ACLs → **Network.aDNA** (Venus). Git.aDNA *consumes* the mesh for the self-hosted profile; doesn't own it. |
| **IDN** — Identity | 4 | ⛔ **DEFER** | OIDC plane, machine accounts, SSH-signing, break-glass → **Network.aDNA / Home.aDNA**. (SSH-signed *commits* = the AGT doctrine block, IN.) |
| **BCK** — Backup | 4 | ⛔ **DEFER** | forgejo-dump + Restic + restore-drill = **self-hosted-deployable** concern (P7); **N/A for hosted Codeberg/GitHub** (provider-managed). |
| **OBS** — Observability | 3 | ⛔ **DEFER** | Prometheus/Grafana/Loki/Beszel → Lighthouse deployable / node ops. |
| **INF** — Inference | 3 | ⛔ **DEFER** | LiteLLM endpoint — not git. Out of the git/forge/CI-CD scope entirely. |
| **COL** — Collaboration | 3 | ⛔ **DEFER** | Zulip/HedgeDoc/Matrix — not git. (Forgejo *Issues* scoping = a one-line FRG note.) |
| **AIR** — Airgap | 2 | ⛔ **DEFER** | git-bundle + OCI-archive sneakernet → RemoteControl.aDNA / Lighthouse deployable. |

## Summary
- **IN (own or partial):** FRG · MIG · GOV · AGT · SEC · DOC — i.e. the **forge function + migration + git-ops doctrine/CI**. ~28 of 56 REQs, fully or partially.
- **DEFER (node-stack / deployable):** DEP · NET · IDN · BCK · OBS · INF · COL · AIR — the broader Lighthouse node stack. ~28 REQs → a future `Lighthouse.aDNA` deployable or sibling graphs (Network/Home/RemoteControl).
- **Clean cut:** Git.aDNA = *the standard + tooling for git-ops on any host*; the *deployable forge node* (with identity/mesh/collab/inference/backup/observability) is a separate concern, surfaced at P7 and—if pursued—spun as `Lighthouse.aDNA`.

> The deferred REQs are **not lost** — they stay in the bannered `requirements_forge_seed.md` as the Lighthouse-deployable reference corpus ([[adr_001_seed_docs_reframe]] D3).
