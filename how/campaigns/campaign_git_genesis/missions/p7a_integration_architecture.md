---
plan_id: p7a_integration_architecture
type: plan
title: "P7a — Integration Architecture (joint Network.aDNA)"
owner: stanley
status: planned
campaign_id: campaign_git_genesis
campaign_phase: 7
campaign_mission_number: "7a"
mission_class: architecture
created: 2026-06-20
updated: 2026-06-20
last_edited_by: agent_stanley
tags: [plan, campaign, git, integration, context_sync, network, lighthouse, operation_free_harbor]
---

# Mission: P7a — Integration Architecture (joint Network.aDNA)

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 7 — Integrated Lighthouse Forge + Context-Sync · **Mission**: 7a (precedes P7b)

## Goal
Design the seam between the self-hosted **Forgejo forge**, Network.aDNA's **mesh/identity substrate**, and **context-sync** — so the P7b spike + the eventual `Lighthouse.aDNA` deployable build on a ratified architecture. **Joint with Venus**; design only, no deployment, no infra.

## Objectives (sketch — expand when phase opens)
1. **§8 forge-placement** ([[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]] D3): forge on a dedicated **data-plane node** the lighthouse coordinates vs. a Network-blessed "forge hub" class. Co-decide with Venus (Network `ADR-016`).
2. **Forgejo-as-context-sync** (ADR-012 D2): design vault-as-repo sync over the mesh, building on Network's `adna-exchange` "drill #7"; reconcile with Network's tarball-transmission ceremony (converge or coexist).
3. **Identity bridge**: Forgejo user-auth ↔ Network node DIDs / federation-signing keys (Network owns *node* identity, not *user* auth).
4. **Addressing**: `git.<subnet>.adna.network` DNS + mesh-internal TLS policy.

## Exit Gate
An **integration ADR** (co-authored/ratified with Network.aDNA) fixing forge-placement, the context-sync protocol, the identity bridge, and addressing; the Network coord memo updated + delivered; inputs ready for P7b + the `Lighthouse.aDNA` deployable.

## Campaign Context
- **Prev**: P5 (beachhead proves the agnostic tooling vs Forgejo) — can run in parallel with P4–P6.
- **Next (P7b)**: the integrated forge + context-sync spike on Network's substrate.
- **Findings driving this**: Network `ADR-016 §8` (forge ≠ lighthouse host); Network's drill-#7 prototype (build on it). See [[context_north_star_vision]].

## AAR
*Append before `status: completed`.*
