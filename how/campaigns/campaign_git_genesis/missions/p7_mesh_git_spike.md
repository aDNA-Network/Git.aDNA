---
plan_id: p7_mesh_git_spike
type: plan
title: "P7b — Integrated Lighthouse Forge + Context-Sync Spike"
owner: stanley
status: active
chartered: 2026-08-07
campaign_id: campaign_git_genesis
campaign_phase: 7
campaign_mission_number: "7b"
mission_class: reconnaissance
created: 2026-06-19
updated: 2026-08-07
last_edited_by: agent_ilmarinen_lane
tags: [plan, campaign, git, genesis, mesh_git, north_star, forgejo, context_sync, forgefed, operation_free_harbor]
---

# Mission: P7b — Integrated Lighthouse Forge + Context-Sync Spike

> **⛩ CHARTERED 2026-08-07 — operator GO. The spike instance is named: the aDNA-Labs R&D Node** (the Ubuntu box in Network membership as `jake_l1`, retitled by operator ruling, colocated at the operator's lab). The brick is `Forgejo.aDNA`'s (`what/architecture/architecture_deployable_v1.md` + `what/deploy/` — compose 15.0.6 LTS, install/backup/seed runbooks, authored 2026-08-07); placement is Venus's scoped §8 R&D ruling; install prerequisites: box mesh-reachable · Jake's `ack` · secrets (Forgejo.aDNA M05 checklist). Objectives 3–5 (abstraction proof, context-sync round-trip, mirror-mesh) run against that instance once it is live. **The exit-gate go/no-go on the `Lighthouse.aDNA` deployable is this mission's to deliver — the R&D install alone does not discharge it.**

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 7 — Integrated Lighthouse Forge + Context-Sync · **Mission**: 7b (after [[p7a_integration_architecture|P7a]])

## Goal
Prove the **integrated lighthouse forge**: a self-hosted **Forgejo on a data-plane node a `Network.aDNA` lighthouse coordinates** (per the P7a integration ADR + Network `ADR-016 §8` — **not** on the lighthouse host), serving its subnet's git over the mesh **and acting as the context-sync fabric** (vaults-as-repos). The concrete proof that mesh-operated aDNA git is a serious **decentralized git for agentic context**. A spike, not production. Builds on Network's `adna-exchange` drill-#7.

## Exit Gate
Per the ratified P7a integration ADR: a data-plane Forgejo reachable on a `Network.aDNA` subnet through the **same** provider abstraction (Forgejo backend; host swap = one `git/` field); **a vault context-sync round-trip over the mesh** (push/clone a vault as the subnet's context); a **mirror-mesh federation** experiment between the lighthouse forge and Codeberg/another lighthouse (ForgeFed reported as a watch-item); a **go/no-go on building the `Lighthouse.aDNA` deployable**.

## Objectives (sketch — expand when phase opens)
1. **Coord + placement** — with Venus, stand the forge on the P7a-decided **data-plane node** (§8-compliant); mesh ACLs.
2. **Deploy** — Forgejo (the seed compose profile + the `Lighthouse.aDNA` quarry as reference); reach it mesh-only.
3. **Abstraction proof** — point a graph's `git/` at `git.<subnet>.adna.network` (one-field host swap); push/clone via the Forgejo backend.
4. **Context-sync proof** — sync a vault as the subnet's context over the mesh (the [[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]] D2 thesis); reconcile with Network's transmission ceremony.
5. **Federation** — mirror-mesh between the lighthouse forge and another forge; ForgeFed experiment + watch-item note.
6. **Spike report** — viability, gaps, and the **build-`Lighthouse.aDNA`-deployable** go/no-go.

## Campaign Context
- **Prev ([[p7a_integration_architecture|P7a]])**: the ratified integration architecture (forge-placement, context-sync protocol, identity bridge, addressing). Also needs M5 (the proven abstraction); runs parallel to M6.
- **Next (M8)**: the spike report feeds closeout + the `Lighthouse.aDNA` deployable build (its own genesis).

## Notes
- Reuses the seed deploy/runbook/backup corpus (now the `Lighthouse.aDNA` **quarry**). Identity/mesh belong to Network.aDNA — coordinate, don't absorb. The deployable build is `Lighthouse.aDNA`'s, not this spike's.

## AAR
*Append before `status: completed`.*
