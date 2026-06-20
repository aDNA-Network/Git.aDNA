---
plan_id: p2_architecture_binding_adrs
type: plan
title: "P2 — Architecture & Binding ADRs"
owner: stanley
status: planned
campaign_id: campaign_git_genesis
campaign_phase: 2
campaign_mission_number: 2
mission_class: implementation
created: 2026-06-19
updated: 2026-06-19
last_edited_by: agent_stanley
tags: [plan, campaign, git, genesis, architecture, operation_free_harbor]
---

# Mission: P2 — Architecture & Binding ADRs

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 2 — Architecture & Binding ADRs · **Mission**: 2 of 8

## Goal
Turn P1's evidence into **binding** architecture. Promote the ADR-002 sketch to a ratified interface and author the remaining load-bearing decisions. Design-only — no code/skills written here.

## Exit Gate
All P2 ADRs `proposed → accepted` (two-cycle ratification). The provider contract, host policy, credential model, CI parity, dev-process doctrine, and mesh-git north-star architecture are locked; the Lighthouse-separate-vs-code-as-WHAT question is decided.

## Objectives (sketch — expand when phase opens)
1. **Provider-contract interface** (binding) — promote [[adr_002_provider_abstraction]]: the verb set, the GitHub-API + Forgejo-API backends, the per-graph declaration schema, the tool-of-record (`tea` vs REST, decided from P1).
2. **`(visibility × provider)` policy** (binding) — promote [[adr_003_visibility_split_policy]] with the P1 classification table.
3. **Remote-naming convention** — `origin` / `mirror` / `upstream` across providers.
4. **Multi-provider credential model** — Codeberg/Forgejo token via the `Home.aDNA` broker (Rule 6); non-TTY agentic UX.
5. **CI/CD parity** — `.github/workflows/` ↔ `.forgejo/workflows/`; what's portable vs provider-specific.
6. **Dev-process git doctrine** — branch/commit/sign/PR conventions + multi-graph change coordination (the "tracking/operations/process" mandate).
7. **Mesh-git north-star architecture** — lighthouse-run Forgejo + ForgeFed; how it plugs the same contract (coord Network.aDNA).
8. **Lighthouse disposition** — separate `Lighthouse.aDNA` vs `what/<forge>/` code-as-WHAT (Decision Point 7).

## Campaign Context
- **Prev (M1)**: fleet inventory + provider SOTA.
- **Next (M3)**: ratified ADRs become the spec basis for the agnostic skills + wrapper.

## AAR
*Append before `status: completed`.*
