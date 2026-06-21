---
plan_id: p4_upstream_execution_charter
type: plan
title: "P4 — Upstream Coordination & Execution Charter"
owner: stanley
status: completed
campaign_id: campaign_git_genesis
campaign_phase: 4
campaign_mission_number: 4
mission_class: integration
created: 2026-06-19
updated: 2026-06-20
last_edited_by: agent_stanley
tags: [plan, campaign, git, genesis, upstream, execution_charter, operation_free_harbor]
---

# Mission: P4 — Upstream Coordination & Execution Charter

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 4 — Upstream Coordination & Execution Charter · **Mission**: 4 of 8

## Goal
Get the agnostic tooling onto the legal path into `.adna/` (via `aDNA.aDNA`), and **charter the execution sub-campaign** that does the outward work (Codeberg + fleet waves). This is the genesis→execution handoff.

## Exit Gate
`aDNA.aDNA` (Rosetta) accepts the skill-upstreaming plan + a `skill_template_release` sequence; `campaign_gitops_rollout` execution charter authored + ratified (two-cycle); this-node adoption plan drafted.

## Objectives (sketch — expand when phase opens)
1. **Deliver the aDNA.aDNA coord memo** — propose the agnostic skills as a template release; agree sequencing + back-compat for the GitHub-hardcoded originals.
2. **Release plan** — which skills ship in which `skill_template_release`; deprecation path for the hardcoded versions.
3. **Author `campaign_gitops_rollout`** — the execution charter: P5 Codeberg beachhead + P6 fleet-alignment waves as dependency-ordered mission cards.
4. **Adoption plan** — how new forks default Codeberg-private (updated `git/` declaration at fork time).

## Campaign Context
- **Prev (M3)**: the skill drafts + wrapper + doctrine block.
- **Next (M5/M6)**: the execution charter governs the Codeberg beachhead + fleet waves.

## Notes
- `.adna/` is do-not-modify — Git.aDNA proposes; `aDNA.aDNA` releases. This phase is the coordination, not the edit.

## As-built (P4 — 2026-06-20)
- **Rosetta upstreaming memo finalized + staged** ([[coord_draft_adna_skill_upstreaming]]) — the P3 agnostic skills + dispatch lib + doctrine block + `git/` wrapper + gitleaks hook + CI templates + the advisory layer, ready for delivery via `skill_template_release`; back-compat for the 2 hardcoded originals + the Path-B/lighthouse-operator default flagged. Kept **staged** (Rule 10).
- **Execution charter authored** ([[campaign_gitops_rollout]], `proposed`) — R1 Codeberg-FOSS beachhead · R2 fleet Path-B waves · R3 integration architecture (joint Network) · R4 integrated forge + context-sync spike · R5 adoption. Ratified two-cycle at the P4-exit gate.
- **Adoption plan** = the `git/` fork-hook (Path B + lighthouse-operator default) + the advisory layer ([[skill_git_provider_config]], [[context_gitops_options]], [[skill_gitops_advisor]]) — delivered at P3.
- **No outward actions / no `.adna/` edits** — coordination + charter only.

**Cross-vault exit item (pending):** `aDNA.aDNA` *acceptance* of the upstreaming plan is a coordination outcome (deliver when aDNA.aDNA is engaged / by operator) — not a Git.aDNA-side blocker.

## AAR
- **Worked**: P3's dry-run-verified artifacts made the upstreaming memo a concrete "ready" list, not a promise; the genesis/rollout split keeps the standard clean and the execution chartered separately.
- **Didn't**: the exit gate's "aDNA.aDNA accepts" is cross-vault — can't be closed unilaterally; recorded as pending-coordination.
- **Finding**: the re-elevation slots cleanly into the rollout (R3/R4 = integrated forge + context-sync; R5 = adoption) without disrupting the near-term hosted R1/R2.
- **Change**: author the execution charter as its own campaign (not buried in genesis phases) — clearer two-cycle ratification + handoff.
- **Follow-up**: P4-exit gate (ratify `campaign_gitops_rollout`; deliver Rosetta memo) → R1/P5 Codeberg beachhead (first outward).
