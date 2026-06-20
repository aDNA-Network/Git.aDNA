---
campaign_id: campaign_git_genesis
type: campaign
title: "Operation Free Harbor — Git.aDNA Genesis & the Platform-Agnostic Git-Ops Paradigm"
owner: stanley
status: active
phase_count: 9
mission_count: 9
estimated_sessions: "9-16"
calibrated_sessions: "10-18"
estimation_class: infrastructure
priority: high
created: 2026-06-19
updated: 2026-06-20
last_edited_by: agent_stanley
tags: [campaign, git, genesis, provider_agnostic, operation_free_harbor]
---

# Campaign: Operation Free Harbor

## Goal

Make aDNA git-ops **platform-agnostic** — a repo and its operations run on **any host the operator chooses** (GitHub, Codeberg, or a self-hosted Forgejo lighthouse) with no lock-in, forever — and stand up the concrete default: **private/internal development on Codeberg** (`codeberg.org/aDNA-Network`), **public graphs/releases on GitHub** (`aDNA-Network`). Along the way, align the whole `.aDNA` fleet to the new paradigm and lay the first stone of the **strategic north star**: self-hosted **mesh-git** as a genuine decentralized competitor to centralized git. When complete, every code-home declares a host policy, the agnostic git-ops skills ship in `.adna/`, the fleet is split Codeberg-private/GitHub-public, and a lighthouse-run Forgejo prototype proves the mesh-git path.

## Context

Every `.aDNA` graph does git through **GitHub-hardcoded** tooling (`skill_git_remote_setup.md`/`skill_vault_publish.md` bake in `gh repo create` + `https://github.com/...`). `Git.aDNA` — chartered to own canonical git/git-ops/CI-CD context — sat un-genesis'd as a seed-staging dir holding the 2026-06-11 **Lighthouse.aDNA** seed set (a self-hosted-Forgejo-first design: *"git.aDNA canonical, GitHub harbor"*). On 2026-06-19 the operator set a new mandate (this campaign): **platform-agnostic** git-ops with **Codeberg as the immediate private home**, GitHub public, and self-hosted mesh-git as the *north star* — explicitly preserving user host-choice forever.

Builds on: the Lighthouse seed set (adopted-and-generalized — [[adr_001_seed_docs_reframe]]); the III Framework consumer-wrapper pattern; `aDNALabs.aDNA`'s Operation Homecoming (which populated GitHub `aDNA-Network`); `Network.aDNA`'s Tailscale+Nebula mesh. Genesis approach + decisions: the approved plan `~/.claude/plans/please-read-the-claude-md-buzzing-treehouse.md`. Framing: [[adr_000_project_identity]], [[adr_002_provider_abstraction]], [[adr_003_visibility_split_policy]].

## Scope

### In Scope

- The **provider abstraction** (git-ops contract over GitHub-API + Forgejo-API backends; Forgejo covers Codeberg + self-hosted).
- The **repo-class / visibility / host policy** (Codeberg-private / GitHub-public / release-mirror; generalized P/I/R).
- The **agnostic git-ops skills** (remote-setup · publish · provider-config · repo-migrate · release-mirror) — authored here, **upstreamed to `.adna/` via `aDNA.aDNA`**.
- **CI/CD parity** (`.github/` ↔ `.forgejo/` Actions) + the **dev-process git doctrine** (branch/commit/sign/PR + multi-graph change coordination).
- The **`git/` consumer-wrapper** pattern + a **fleet git-state ledger** + **fleet alignment** in gated waves.
- The **Codeberg beachhead** (org/teams, pilot migration, release-mirror).
- A **self-hosted mesh-git spike** (lighthouse-run Forgejo + ForgeFed) — north-star proof.

### Out of Scope

- The broader "Lighthouse node stack" from the seed docs — **identity/mesh** (`Network.aDNA`), node **inventory/health/credentials** (`Home.aDNA`), **collab/inference**. Only the *forge* piece stays here.
- The `.adna` **standard mechanics** themselves (owned by `aDNA.aDNA` — we supply skill *content*, they release it).
- The **GitHub-org migration program** (owned by `aDNALabs.aDNA` — we supply patterns + coordinate).
- A **production self-hosted forge deployment** (P7 is a *spike*; a real deployable spins a separate `Lighthouse.aDNA`).
- **External upstreams** (`ggml-org/llama.cpp`, `Wilhelm-Foundation/rare-archive`) — never re-homed.

### Subsumes

| Plan/Mission | Status at Subsumption | Tasks Absorbed By |
|-------------|----------------------|-------------------|
| Lighthouse.aDNA seed set (00–05, 2026-06-11) | seed (un-executed) | Adopted-and-generalized; FIRST LIGHT campaign → reframed into this campaign ([[adr_001_seed_docs_reframe]]) |

## Phases & Missions

> One primary mission per phase at genesis; execution phases (P5–P7) may spawn sub-missions when chartered. Order is by **dependency**, not date. **Every phase boundary is an operator gate** (Standing Order #1).

### Phase 0: Meta-Planning & Charter

| Mission | Title | Sessions | Dependencies | Status |
|---------|-------|----------|-------------|--------|
| 0 | [[missions/mission_p0_meta_planning\|P0 — Meta-Planning & Charter]] | 1 | — | **✅ complete 2026-06-19 (ratified)** |

**Phase exit gate**: Operator **APPROVE/REVISE/HOLD** of the charter + ADRs 000–003. On APPROVE → ADRs `accepted`, router row inserts, P1 opens.

### Phase 1: Research & Fleet Git-State Inventory

| Mission | Title | Sessions | Dependencies | Status |
|---------|-------|----------|-------------|--------|
| 1 | [[missions/p1_research_fleet_inventory\|P1 — Research & Fleet Git-State Inventory]] | 1-2 | M0 | **✅ complete 2026-06-19** |

**Phase exit gate**: `fleet_git_state.md` complete (every graph + code-as-WHAT repo: host · visibility · class · LFS · consumers); provider-tooling SOTA filed; provider/visibility classifications drafted for operator review.

### Phase 2: Architecture & Binding ADRs

| Mission | Title | Sessions | Dependencies | Status |
|---------|-------|----------|-------------|--------|
| 2 | [[missions/p2_architecture_binding_adrs\|P2 — Architecture & Binding ADRs]] | 2-3 | M1 | **✅ complete — ratified 2026-06-20 (ADRs 004–011)** |

**Phase exit gate**: all P2 ADRs `proposed → accepted` (provider-contract · `(visibility×provider)` policy · remote-naming · multi-provider credentials · CI parity · dev-process git doctrine · mesh-git north-star architecture).

### Phase 3: Specs & Tooling Skeleton

| Mission | Title | Sessions | Dependencies | Status |
|---------|-------|----------|-------------|--------|
| 3 | [[missions/p3_specs_tooling_skeleton\|P3 — Specs & Tooling Skeleton]] | 1-2 | M2 | **✅ complete 2026-06-20 (dry-run-clean 19/19)** |

**Phase exit gate**: agnostic skill drafts + `git/` wrapper + doctrine block + CI templates authored; skill drafts pass `dry_run` against both a GitHub and a Codeberg/Forgejo target.

### Phase 4: Upstream Coordination & Execution Charter

| Mission | Title | Sessions | Dependencies | Status |
|---------|-------|----------|-------------|--------|
| 4 | [[missions/p4_upstream_execution_charter\|P4 — Upstream Coordination & Execution Charter]] | 1-2 | M3 | planned |

**Phase exit gate**: `aDNA.aDNA` accepts the skill-upstreaming plan (`skill_template_release`); `campaign_gitops_rollout` execution charter ratified (two-cycle).

### Phase 5: Codeberg Beachhead *(execution — outward, gated)*

| Mission | Title | Sessions | Dependencies | Status |
|---------|-------|----------|-------------|--------|
| 5 | [[missions/p5_codeberg_beachhead\|P5 — Codeberg Beachhead]] | 1-2 | M4 | planned |

**Phase exit gate**: Codeberg `aDNA-Network` org/teams stood up; pilot graphs (Git.aDNA + 1–2 low-risk internal) migrated + verified; agnostic skills proven vs Forgejo; one release-mirror Codeberg→GitHub round-trips; rollback drill passes.

### Phase 6: Fleet Alignment *(execution — waved)*

| Mission | Title | Sessions | Dependencies | Status |
|---------|-------|----------|-------------|--------|
| 6 | [[missions/p6_fleet_alignment\|P6 — Fleet Alignment]] | 3-5 | M5 | planned |

**Phase exit gate**: every wave operator-gated; `disposition_ledger.md` reconciles to zero unaccounted graphs; doctrine block + host declaration present per graph; shim registry (Home.aDNA) tracks every re-point.

### Phase 7: Mesh-Git North-Star Spike *(strategic — separate gate)*

| Mission | Title | Sessions | Dependencies | Status |
|---------|-------|----------|-------------|--------|
| 7 | [[missions/p7_mesh_git_spike\|P7 — Mesh-Git North-Star Spike]] | 1-2 | M5 (not M6) | planned |

**Phase exit gate**: a lighthouse-run Forgejo reachable on a Nebula node; ForgeFed federation experiment reported; recommendation on whether to spin a `Lighthouse.aDNA` deployable.

### Phase 8: Closeout & AAR

| Mission | Title | Sessions | Dependencies | Status |
|---------|-------|----------|-------------|--------|
| 8 | [[missions/p8_closeout_aar\|P8 — Closeout & AAR]] | 1 | M6, M7 | planned |

**Phase exit gate**: campaign AAR filed; standing missions (mirror-health, drift detection, quarterly drill) handed to `Operations.aDNA`; STATE trimmed; genesis `status: completed`.

## Decision Points

| # | When | Decision | Status |
|---|------|----------|--------|
| 1 | P0 gate (this session) | Approve charter + ADRs; confirm **Framework reframe**, **persona Hopper**, **codename** | ✅ done (APPROVE 2026-06-19) |
| 2 | P1 → P2 | Operator ratifies the fleet host/visibility classification table | ✅ done — approve-in-principle 2026-06-20 ([[what/decisions/adr_005_visibility_host_policy\|ADR-005]] D4; re-confirm per-wave) |
| 3 | P4 | `aDNA.aDNA` agrees to upstream the agnostic skills; release sequencing | pending |
| 4 | P5 | Authorize **outward** action — create Codeberg org structure + first pushes | pending |
| 5 | P6 (per wave) | Authorize each migration wave (lowest-risk → client/sensitive) | pending |
| 6 | P7 | Authorize a mesh node to host a forge spike (coord Network.aDNA) | pending |
| 7 | P2/P7 | Whether the self-hosted forge becomes a separate `Lighthouse.aDNA` | ✅ disposition decided 2026-06-20 — **separate `Lighthouse.aDNA`** ([[what/decisions/adr_010_mesh_git_north_star\|ADR-010]] D5); trigger = P7 go/no-go |

## Risk Register

| Risk | Severity | Mitigation |
|------|----------|------------|
| Codeberg split **collides** with `aDNALabs.aDNA`'s Operation Homecoming (just populated GitHub `aDNA-Network`) | High | ADR-003 D5 + a staged coord memo partition by visibility; operator + Berthier confirm before any wave |
| `.adna/` is **do-not-modify** — skills can't be edited directly | High | Author drafts here; ship via `aDNA.aDNA` `skill_template_release` (P4); never touch `.adna/` (SO#3) |
| **Secret leakage** in history during host migration (client repos) | High | Full-history scan before any host move (seed migration mechanics); client/sensitive = last wave; strict ACLs |
| **Multi-host fleet drift** / half-migrated limbo | Medium | Fleet git-state ledger + disposition ledger make drift visible; shim registry tracks re-points; per-wave gates |
| Code-as-WHAT **nested repos** have their own `.git` remotes (parent graph ≠ code remote) | Medium | P1 inventory captures both; P6 wave 3 handles nested repos explicitly |
| Forgejo/Codeberg **feature parity gaps** (LFS, packages, Actions, PR model) vs GitHub | Medium | P1 SOTA + parity notes; P3 CI templates for both backends; document provider-specific surfaces (SO#4) |
| **Credential UX** for a second provider in non-TTY agentic contexts | Medium | Reuse the Home.aDNA broker pattern (Rule 6); P2 credential ADR + Home coord memo |
| Persona/category/codename **churn** if operator disagrees at gate | Low | Presented as explicit gate decisions with named alternatives; cheap to revise pre-ratification |

## Verification Strategy

### Per-Mission
| Check | Method | Gate? |
|-------|--------|-------|
| SITREP + AAR filed | Session closure + 5-line AAR | Yes |
| Deliverables validated | AAR scorecard | Yes |
| Files committed (local) | `git status` clean | Yes |
| No un-gated outward action | `git remote -v` audit + push log | Yes (genesis phases) |

### Per-Phase
| Check | Method | Gate? |
|-------|--------|-------|
| Phase exit criteria met | This charter's per-phase gate | Yes — operator approval |
| ADRs ratified (P2) | `proposed → accepted` | Yes |
| Dry-run parity (P3) | skills pass against GitHub **and** Forgejo targets | Yes |
| Rollback drill (P5) | restore/repoint verified | Yes |
| Ledger reconciliation (P6) | `disposition_ledger.md` zero-unaccounted | Yes |

### Campaign Validation
| Check | Method |
|-------|--------|
| Agnostic skills shipped | present in `.adna/` via `aDNA.aDNA` release |
| Fleet converged | every graph carries a host declaration + doctrine block |
| North-star proven | P7 spike report + go/no-go on `Lighthouse.aDNA` |
| Standing ops handed off | mirror-health + drift + drill missions in `Operations.aDNA` |

## Timeline

| Phase | Missions | Sessions |
|-------|----------|----------|
| P0 Meta-Planning | 0 | 1 |
| P1 Research & Inventory | 1 | 1-2 |
| P2 Architecture & ADRs | 2 | 2-3 |
| P3 Specs & Skeleton | 3 | 1-2 |
| P4 Upstream & Exec Charter | 4 | 1-2 |
| P5 Codeberg Beachhead | 5 | 1-2 |
| P6 Fleet Alignment | 6 | 3-5 |
| P7 Mesh-Git Spike | 7 | 1-2 |
| P8 Closeout | 8 | 1 |
| **Total** | **9 missions** | **10-18 sessions** |

## Notes

- **Dogfooding is the design.** Git.aDNA's own first remote (P5) is the first live test of the agnostic tooling — the graph runs on what it ships.
- **P7 depends on M5, not M6** — the mesh-git spike can run in parallel with fleet alignment (both need only the beachhead + abstraction, not full fleet convergence).
- The seed set's deploy/infra/runbook content (04/05) is the **reference corpus** for a possible future `Lighthouse.aDNA` (Decision Point 7).

## Completion Summary

*Fill out when setting `status: completed`.*

### Deliverables
### Descoped
### Key Findings
### Scope Changes
### Follow-Up Campaigns

## Campaign AAR

*Mandatory before `status: completed`. See `how/templates/template_aar_lightweight.md`.*

- **Worked**:
- **Didn't**:
- **Finding**:
- **Change**:
- **Follow-up**:
