---
type: decision
adr_id: adr_010
title: "ADR-010 — Mesh-Git North-Star Architecture (+ Decision Point 7: Lighthouse disposition)"
status: accepted
created: 2026-06-20
updated: 2026-06-20
last_edited_by: agent_stanley
ratifies_at: "authored at genesis P2 (2026-06-20); ratified at the P2-exit gate; spiked at P7; deployable trigger at P7 go/no-go"
depends_on: [adr_004, adr_005]
resolves: decision_point_7
tags: [decision, adr, adr_010, git, mesh_git, north_star, lighthouse, forgejo, forgefed, nebula, decision_point_7, binding, accepted]
---

# ADR-010 — Mesh-Git North-Star Architecture (+ Decision Point 7)

**Status**: `accepted` (genesis **P2**, 2026-06-20; ratified at the P2-exit gate). Architects the north star (ADR-000 D5) and **resolves campaign Decision Point #7**. Depends on [[adr_004_provider_contract_interface|ADR-004]], [[adr_005_visibility_host_policy|ADR-005]]. Coordinated with **Network.aDNA** ([[coord_draft_network_mesh_git|coord memo]]).

> **⚠ AMENDED by [[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]]** (proposed, 2026-06-20) — **D1/D4 forge-placement** (Network `ADR-016 §8`: a forge is data-bearing → it runs on a **data-plane node the lighthouse coordinates**, *not* the lighthouse host) + **D5 timing** (`Lighthouse.aDNA` forked as a stub now; deployable build still gates on the integration mission + P7). The rest of this ADR stands; read ADR-012 for the amended stance + the git-as-context-sync thesis + the decentralized-git product objective.

## Context
The load-bearing thesis (ADR-000 D5): self-hosted **mesh-git is the strategic north star** — a decentralized competitor to centralized git. [[adr_001_seed_docs_reframe]] deferred the *deployable*; under Path B ([[adr_005_visibility_host_policy|ADR-005]]) self-hosted Forgejo is now the **destined private home**, so the north star is no longer just aspirational — it is the eventual answer to "where do private repos live." This ADR architects it (design, not deployment — P7 is a *spike*), fixes federation expectations to P1 reality, and decides the Lighthouse vault disposition.

## Decisions

### D1 — The architecture: lighthouse-run Forgejo on a Nebula node
A **Forgejo** instance runs on a **Nebula lighthouse node** (lighthouse is already a Nebula relay+authority role), serving git for its subnet over the mesh at **`git.<subnet>.adna.network`**. It is the **same Forgejo backend** as hosted Codeberg ([[adr_004_provider_contract_interface|ADR-004]] D2) — the provider contract, REST tool-of-record, mirror mechanics, and CI surface are **identical**; only the `host` field changes. **On-ramp:** a graph re-points `origin` to the lighthouse via a one-field declaration edit ([[adr_004_provider_contract_interface|ADR-004]] D4) + the [[adr_006_remote_naming|ADR-006]] D3 migration sequence. *Nothing in the abstraction is rewritten for the north star — that is the whole point.*

### D2 — Path B linkage: the spike gates the private migration (binding)
Self-hosted Forgejo is the **eventual private home** ([[adr_005_visibility_host_policy|ADR-005]] D7). Before **any** private repo migrates GitHub-interim → self-hosted, the **P7 spike MUST prove**:
- **backup/restore** — a `forgejo dump` + restore **drill passes** (seed §6 gate), and
- **uptime/reachability** over the mesh, and
- a **round-trip** of the agnostic skills against the lighthouse (dogfood — same skills as Codeberg).

Only then do the post-P7 private waves open (lowest-risk first; I-strict client repos last, history-scan-gated). The spike's success criteria *are* the decentralization gate — decentralization is **earned**, not rushed.

### D3 — Federation realism: mirroring now, ForgeFed later (P1-grounded)
P1 ([[context_provider_tooling_sota]]) found **ForgeFed experimental** — **federated repository *stars* only**; no federated issues/PRs/identities (roadmap; Forgejo reserves breaking federation changes). Therefore:
- The **near-term "mesh"** = **`configure-mirror` (push/pull mirrors) + REST**, *not* ForgeFed — decentralization value comes from **self-hosting + mirroring across subnet lighthouses**, not cross-instance federation.
- **ForgeFed is a directional bet / watch-item**, experimented at P7, tracked as it matures — never assumed as a 2026 substrate.

### D4 — Mesh substrate boundary (Network.aDNA / Venus owns the mesh)
Git.aDNA owns the **forge** — Forgejo config, the provider contract, org/repo layout, runner/CI surface. **Network.aDNA owns the mesh + identity** — the Nebula node, mesh ACLs (mesh-only forge writes), `git.<subnet>.adna.network` addressing/DNS over the mesh. The P7 spike is **jointly gated** (campaign Decision Point #6 + the Network coord memo). Identity/OIDC/SSH-CA, backup infra, observability, **audit-log retention (SEC-004; 180-day — provider-managed on hosted GitHub/Codeberg, self-hosted retention → `Lighthouse.aDNA`)** = the **deployable's** concern (D5), out of Git.aDNA scope (ADR-001).

### D5 — Decision Point 7 RESOLVED: a deployable forge spins a separate `Lighthouse.aDNA`
If/when a production self-hosted forge is built, it becomes a **separate `Lighthouse.aDNA` Platform** — **not** a `what/<forge>/` code-as-WHAT under Git.aDNA.
- **Why:** it keeps **Git.aDNA a clean Framework** (standard + skills + `git/` wrapper, *no runtime* — ADR-000 D2/D4). A deployable forge (compose/runbook/backup/observability — the seed 04/05 corpus) is a **Platform** artifact with a distinct deploy lifecycle, persona, and node topology.
- **Trigger:** the **P7 spike's go/no-go recommendation** (campaign DP7 timing = P2/P7 — the *disposition* is decided here; the *trigger* fires at P7). The seed deploy/infra/runbook content is `Lighthouse.aDNA`'s **reference corpus**.
- Until then, Git.aDNA carries only the **self-hosted-forge profile** (this ADR + the Forgejo-backend half of ADR-004) — design, not deployment.

## Consequences
- The north star is reachable through the *same* contract the fleet already uses — no second toolchain.
- Git.aDNA stays a Framework; the Platform dimension is cleanly carved to a future `Lighthouse.aDNA` (consistent with ADR-000's category reframe).
- P7 can run in parallel with P6 fleet alignment (it needs only the beachhead + abstraction, not full convergence — charter note).
- Network.aDNA gets a precise, bounded ask (host + mesh ACLs + DNS); Git.aDNA brings the forge contract.

## Open questions carried forward (→ P7 / Network.aDNA)
- Multi-lighthouse topology + cross-subnet mirroring (replication between subnet forges).
- Whether the Codeberg-FOSS set also keeps a lighthouse resilience mirror.
- ForgeFed maturation tracking — when (if) federated issues/PRs become production-usable.

## Alternatives considered
- **Code-as-WHAT forge under Git.aDNA** — rejected (D5): would make Git.aDNA a Platform-with-runtime, muddying the Framework identity.
- **Self-host now as the private home (Path A)** — rejected at the P2-entry gate ([[adr_005_visibility_host_policy|ADR-005]] alternatives): front-loads infra ahead of specs/credentials.
- **Bet on ForgeFed as the near-term mesh** — rejected (D3): experimental, breaking-change-prone; mirroring + REST is the real 2026 substrate.
