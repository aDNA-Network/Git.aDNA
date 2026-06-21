---
campaign_id: campaign_gitops_rollout
type: campaign
title: "Operation Free Harbor — Git-Ops Rollout (execution charter)"
owner: stanley
status: accepted
phase_count: 5
mission_count: 5
priority: high
created: 2026-06-20
updated: 2026-06-20
last_edited_by: agent_stanley
depends_on: [campaign_git_genesis]
tags: [campaign, git, rollout, execution, codeberg, fleet_alignment, lighthouse, operation_free_harbor]
---

# Campaign: Git-Ops Rollout (execution charter)

**Status**: `accepted` — authored at genesis **P4** (2026-06-20); **ratified by operator 2026-06-20** (two-cycle). The **execution** companion to `campaign_git_genesis` (the planning/standard campaign). Genesis produced the standard (ADRs 004–012, the agnostic skills, the `git/` wrapper, the advisory layer); this campaign **deploys** it.

## Goal
Turn the Operation Free Harbor standard into deployed reality: stand up the **Codeberg-FOSS beachhead**, align the `.aDNA` fleet to **Path B** in gated waves, and prove the **integrated lighthouse forge + context-sync** — the first outward steps toward self-hosted, decentralized git for agentic context. **No outward action until each mission's gate fires** (Standing Order #1 carries over).

## Relationship to the genesis campaign
`campaign_git_genesis` phases **P5/P6/P7** are governed in detail here as missions R1–R4; R5 (adoption) is new. Genesis closeout (P8) follows once R1–R2 are underway. **Prerequisite:** P4 upstreaming — the agnostic skills must be available via `aDNA.aDNA` (`skill_template_release`) before R1 executes.

## Scope
**In**: Codeberg-FOSS beachhead; fleet Path-B waves; the integration architecture + integrated-forge/context-sync spike; new-fork adoption defaults.
**Out**: the standard itself (genesis); the **`Lighthouse.aDNA` deployable build** (its own genesis, post-R4 go/no-go); `.adna/` releases (aDNA.aDNA); the GitHub-org migration program (aDNALabs).

## Missions (dependency-ordered; each operator-gated)

| # | Mission | = genesis | Gate / exit |
|---|---|---|---|
| **R1** | **Codeberg-FOSS Beachhead** — stand up Codeberg `aDNA-Network` org/teams; migrate Git.aDNA + 1–2 FOSS pilots; verify the agnostic skills vs Forgejo (live, no longer dry-run); wire one release-mirror; rollback drill | P5 | **Decision Point 4** (first outward); pilot verified; drill passes |
| **R2** | **Fleet Alignment Waves** — roll Path B across the fleet, lowest-risk first; `git/` declaration + doctrine block per graph; **pre-move secret-scan gate** (ADR-011); shim registry (Home.aDNA) | P6 | **DP5** per wave; `disposition_ledger` → zero unaccounted |
| **R3** | **Integration Architecture** (joint Network.aDNA) — §8 forge-placement · Forgejo-as-context-sync (on drill-#7) · identity bridge · DNS/TLS | P7a | integration ADR ratified (co-authored w/ Venus) |
| **R4** | **Integrated Lighthouse Forge + Context-Sync Spike** — data-plane Forgejo on a Network subnet via the agnostic contract; vault context-sync round-trip; mirror-mesh federation experiment | P7b | spike report; **go/no-go on the `Lighthouse.aDNA` deployable build** |
| **R5** | **Adoption & Defaults** — new forks default via the `git/` fork-hook (Path B + lighthouse-operator default); the advisory layer (`context_gitops_options` + `skill_gitops_advisor`) in operator use | (new) | fork-hook live; advisory dogfooded |

## Decision points
| # | When | Decision |
|---|---|---|
| 1 | P4-exit | **Ratify this charter** — ✅ **done 2026-06-20** (`accepted`, two-cycle) |
| 2 | R1 | Authorize outward — Codeberg org + first pushes (genesis DP4) |
| 3 | R2 (per wave) | Authorize each fleet wave (genesis DP5) |
| 4 | R3/R4 | Authorize the integration spike on a Network node (genesis DP6/DP9) |
| 5 | post-R4 | Build the `Lighthouse.aDNA` deployable (genesis DP7 trigger) |

## Coordination
- **aDNA.aDNA** (Rosetta) — skills upstreamed (P4 prerequisite). **aDNALabs** (Berthier) — Homecoming coexistence; joint gate before each R2 wave. **Home.aDNA** (Hestia) — multi-provider credentials (R1) + shim registry (R2). **Network.aDNA** (Venus) — R3/R4 integration + spike.

## Risk register (carried from genesis)
Secret-leakage in history (→ ADR-011 hard gate, R2) · Homecoming collision (→ visibility partition, joint gate) · multi-host drift (→ disposition ledger + shim registry) · Forgejo/Codeberg parity gaps (→ P1 SOTA + CI templates) · credential UX (→ Home broker) · §8 forge-placement (→ R3).

## Verification
Each mission: AAR + operator gate + `git status` clean + no un-gated outward action. Campaign: fleet on Path B (every graph declares a host); release-mirror round-trips; the integrated-forge spike reports go/no-go; standing ops (mirror-health, drift, restore-drill) → Operations.aDNA.

## AAR
*Mandatory before `status: completed`.*
