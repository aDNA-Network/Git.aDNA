---
plan_id: p6_fleet_alignment
type: plan
title: "P6 — Fleet Alignment"
owner: stanley
status: in_progress
campaign_id: campaign_git_genesis
campaign_phase: 6
campaign_mission_number: 6
mission_class: implementation
created: 2026-06-19
updated: 2026-06-21
last_edited_by: agent_stanley
tags: [plan, campaign, git, genesis, fleet_alignment, waved, operation_free_harbor]
---

# Mission: P6 — Fleet Alignment

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 6 — Fleet Alignment · **Mission**: 6 of 8

## Goal
Bring the whole `.aDNA` fleet into the platform-agnostic paradigm — each graph declares a host policy, carries the doctrine block, and lands on the right host (Codeberg-private / GitHub-public) — in **gated waves, lowest-risk first**. This is the "update/align all other graphs" mandate.

## Exit Gate
Every wave operator-gated; `disposition_ledger.md` reconciles to **zero unaccounted graphs**; each graph carries a `git/` host declaration + the doctrine block + updated STATE/MANIFEST; the `Home.aDNA` **shim registry** (Rule 9) records every remote re-point with a rollback path.

## Objectives (sketch — expand when phase opens; one sub-mission per wave)
1. **Disposition ledger** — build `disposition_ledger.md` from `fleet_git_state.md` (every graph: current host → target host → class → wave). **✅ DONE 2026-06-21** → [[disposition_ledger]] (45 graphs + nested + external; **zero unaccounted**; re-mapped to the ADR-013 table; 5-wave sequence; gate-ready Wave 1 checklist authored).
2. **Wave 1 — low-risk internal** — vaults with no LFS / client data / live consumers → Codeberg.
3. **Wave 2 — daily-drivers** — active vaults.
4. **Wave 3 — code-as-WHAT nested repos** — `lattice-protocol`, `contextscope`, `harness`, … (handle their separate `.git` remotes).
5. **Wave 4 — client / sensitive** — history-scan mandatory before any host move (CakeHealth, sws/*, etc.).
6. **Per-graph touch** — host declaration + doctrine block + STATE/MANIFEST + shim-registry entry.
7. **Public set** — confirm public graphs stay on GitHub (optionally add a Codeberg dev-mirror).

## Campaign Context
- **Prev (M5)**: proven beachhead + agnostic skills + rollback drill.
- **Next (M8)**: a converged fleet feeds closeout + standing drift-detection.

## Notes
- **Coordinate every wave with `aDNALabs.aDNA`** (Operation Homecoming coexistence) and register re-points in the shim ledger. Public graphs are already correct — don't move them.

## Progress — 2026-06-21 (objective #1; non-outward)
Disposition ledger authored + a gate-ready Wave 1 checklist; mission opened (`planned → in_progress`). **No waves executed** — every move is DP5-gated. The load-bearing finding: **ADR-013 reverses the P1 plan** — the private/internal majority **stays GitHub-private-interim** (touch-only, no Codeberg); only the FOSS-in-dev subset → Codeberg-private; released-FOSS → GitHub-public. Pivotal open call surfaced for the operator: **released-vs-in-dev** per OSS-intended graph. Prereq folded same session: the **5 P5 beachhead lib fixes** (dry-run 23/23). Session: `session_stanley_20260621_git_p6_prep`.

### Progress AAR (objective #1 — disposition ledger)
- **Worked**: re-mapping straight off `fleet_git_state.md` + ADR-013's D1 table reconciled all 45 graphs to zero-unaccounted in one pass; the reconciliation table makes the exit-gate criterion checkable.
- **Didn't**: the released-vs-in-dev split can't be auto-decided — it's a genuine per-graph operator call, so the ledger proposes defaults + `(confirm)` rather than asserting.
- **Finding**: ADR-013 shrinks P6's outward scope dramatically vs the P1 "almost everything → Codeberg" estimate — most graphs don't move at all.
- **Change**: none.
- **Follow-up**: operator decision rows (released-vs-dev · name-drift · cross-org · unmapped) → resolve at the Wave 1/2 gates; Berthier coord for cross-org/name-drift.

## AAR (final — append before `status: completed`)
*Append at mission completion (after the waves converge).*
