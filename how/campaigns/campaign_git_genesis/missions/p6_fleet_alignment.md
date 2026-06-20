---
plan_id: p6_fleet_alignment
type: plan
title: "P6 — Fleet Alignment"
owner: stanley
status: planned
campaign_id: campaign_git_genesis
campaign_phase: 6
campaign_mission_number: 6
mission_class: implementation
created: 2026-06-19
updated: 2026-06-19
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
1. **Disposition ledger** — build `disposition_ledger.md` from `fleet_git_state.md` (every graph: current host → target host → class → wave).
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

## AAR
*Append before `status: completed`.*
