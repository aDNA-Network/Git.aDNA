---
type: coordination
coord_id: coord_delivery_queue
title: "Cross-Vault Hand-Off Delivery Queue (staged memos)"
created: 2026-06-20
updated: 2026-06-20
status: active
last_edited_by: agent_stanley
tags: [coordination, delivery_queue, handoff, operation_free_harbor]
---

# Cross-Vault Hand-Off Delivery Queue

The staged coord memos awaiting delivery to peer vaults. Per **Standing Rule 10**, Git.aDNA does not write into other vaults — these are **prepared + queued here**; delivery happens when the target vault is engaged or by the operator. This index makes the next session's hand-offs explicit.

| # | To (persona) | Memo | Trigger | Unblocks | Status |
|---|---|---|---|---|---|
| 1 | **aDNA.aDNA** (Rosetta) | [[coord_draft_adna_skill_upstreaming]] | P4-exit → **before R1/P5** | the agnostic skills released into `.adna/` via `skill_template_release` | **QUEUED** |
| 2 | **Home.aDNA** (Hestia) | [[coord_draft_home_credentials_shims]] | **before R1/P5** | `CODEBERG_TOKEN` provisioned (ADR-007) + the remote-repoint shim registry (Rule 9) | **QUEUED** |
| 3 | **aDNALabs.aDNA** (Berthier) | [[coord_draft_adnalabs_migration_coexistence]] | **before each R2 wave** | Homecoming↔Path-B visibility partition; name-drift + straggler reconciliation | staged |
| 4 | **Network.aDNA** (Venus) | [[coord_draft_network_mesh_git]] | **R3 / P7a** (integration) | §8 forge-placement · Forgejo-as-context-sync (drill-#7) · identity bridge · DNS/TLS | staged |
| 5 | **Lighthouse.aDNA** | [[coord_2026_06_20_git_lighthouse_handoff]] | **Lighthouse.aDNA P0** | the standard↔deployable handoff + seed-corpus quarry | staged |

## R1/P5 prerequisites (the critical path)
Before the **first outward phase** (R1 — Codeberg-FOSS beachhead) can execute, **#1 (Rosetta release)** and **#2 (Hestia `CODEBERG_TOKEN`)** must land — plus the operator's **Decision Point 4** authorization for outward actions (create the Codeberg org + first pushes). Git.aDNA will not start R1 without all three.

## Delivery discipline
Each delivery is itself a cross-vault action: when working in the target vault (or at operator direction), copy/adapt the staged memo into that vault's intake, record acceptance, and flip the row here to **DELIVERED + accepted**. Nothing in this queue is an outward (remote/push) action.
