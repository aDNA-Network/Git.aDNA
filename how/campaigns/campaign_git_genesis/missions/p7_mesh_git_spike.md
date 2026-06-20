---
plan_id: p7_mesh_git_spike
type: plan
title: "P7 — Mesh-Git North-Star Spike"
owner: stanley
status: planned
campaign_id: campaign_git_genesis
campaign_phase: 7
campaign_mission_number: 7
mission_class: reconnaissance
created: 2026-06-19
updated: 2026-06-19
last_edited_by: agent_stanley
tags: [plan, campaign, git, genesis, mesh_git, north_star, forgejo, forgefed, operation_free_harbor]
---

# Mission: P7 — Mesh-Git North-Star Spike

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 7 — Mesh-Git North-Star Spike · **Mission**: 7 of 8

## Goal
Lay the first stone of the **strategic north star**: prove a **lighthouse-run Forgejo** serving git for its subnet over the mesh, federated via **ForgeFed** — the concrete proof that mesh-operated aDNA git can be a serious decentralized competitor to centralized git. A spike, not production.

## Exit Gate
A Forgejo instance reachable on a `Network.aDNA` Nebula node (the "lighthouse"); a repo pushed/cloned over the mesh through the **same** provider abstraction (self-hosted profile = Forgejo backend); a ForgeFed federation experiment reported; a go/no-go recommendation on spinning a dedicated `Lighthouse.aDNA` deployable.

## Objectives (sketch — expand when phase opens)
1. **Node + coord** — with `Network.aDNA` (Venus), pick a Nebula node to host the spike; mesh ACLs.
2. **Deploy** — stand up Forgejo (the seed set's compose profile is the reference); reach it over mesh-only.
3. **Abstraction proof** — point a graph's `git/` declaration at `git.<subnet>...` (host swap = one field); push/clone via the Forgejo backend.
4. **ForgeFed** — experiment with federation between the lighthouse forge and Codeberg/another lighthouse.
5. **Spike report** — viability, gaps, and the `Lighthouse.aDNA`-vs-code-as-WHAT recommendation (Decision Point 7).

## Campaign Context
- **Prev (M5)**: the beachhead + the proven abstraction (this phase runs **parallel to M6**, depends on M5 not M6).
- **Next (M8)**: the spike report feeds closeout + any follow-up campaign.

## Notes
- Reuses the seed set's deploy/runbook/backup content (04/05, bannered) as the **reference corpus**. Out-of-scope pieces (identity/mesh) belong to Network.aDNA — coordinate, don't absorb.

## AAR
*Append before `status: completed`.*
