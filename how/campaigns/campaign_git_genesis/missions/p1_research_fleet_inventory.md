---
plan_id: p1_research_fleet_inventory
type: plan
title: "P1 — Research & Fleet Git-State Inventory"
owner: stanley
status: planned
campaign_id: campaign_git_genesis
campaign_phase: 1
campaign_mission_number: 1
mission_class: reconnaissance
created: 2026-06-19
updated: 2026-06-19
last_edited_by: agent_stanley
tags: [plan, campaign, git, genesis, reconnaissance, operation_free_harbor]
---

# Mission: P1 — Research & Fleet Git-State Inventory

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 1 — Research & Fleet Git-State Inventory · **Mission**: 1 of 8

## Goal
Produce the two inputs P2 binds against: (a) a **state-of-the-art survey** of multi-provider git tooling, and (b) a **complete inventory** of the fleet's current git state. No architecture yet — gather ground truth.

## Exit Gate
`what/inventory/fleet_git_state.md` complete (every `.aDNA` graph **and** code-as-WHAT nested repo: host · org · visibility · class · LFS · CI · live consumers); provider-tooling SOTA filed in `what/context/`; draft provider/visibility classification per graph staged for the operator's P2-entry review; coexistence map vs `aDNALabs.aDNA`'s GitHub `aDNA-Network` population.

## Objectives (sketch — expand when phase opens)
1. **Provider-tooling SOTA** — Forgejo/Gitea REST + `tea` CLI (vs raw REST / `berg` / git-remote-helpers); `gh`; **ForgeFed** federation; Forgejo push-mirror; sops/age; LFS + package-registry + Actions parity GitHub↔Forgejo. Paraphrase, cite (SO#11). → `what/context/`.
2. **Fleet `git remote -v` walk** — every graph + nested code repo; capture host/org/visibility/class/LFS/CI/consumers. → `what/inventory/fleet_git_state.md` (feeds a future `repos` Base).
3. **Seed-REQ triage** — which of the 56 `requirements_forge_seed.md` REQs are in-scope for Git.aDNA vs the deferred Lighthouse deployable.
4. **Draft classification** — propose Codeberg-private / GitHub-public / Class-R per graph (operator ratifies at P2 entry).
5. **Homecoming coexistence** — map which repos `aDNALabs.aDNA` already placed on GitHub `aDNA-Network`; flag any collision risk for ADR-003 D5.

## Campaign Context
- **Prev (M0)**: ratified ADRs + the `STATE.md` "live git landscape" table (seed for objective 2).
- **Next (M2)**: the inventory + SOTA become the evidence base for the binding architecture ADRs.

## AAR
*Append before `status: completed`.* — Worked / Didn't / Finding / Change / Follow-up.
