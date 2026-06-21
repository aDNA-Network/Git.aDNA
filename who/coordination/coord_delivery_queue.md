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
| 1 | **aDNA.aDNA** (Rosetta) | [[coord_draft_adna_skill_upstreaming]] | P4-exit → **before R1/P5** | the agnostic skills released into `.adna/` via `skill_template_release` | **DELIVERED 2026-06-20** — coord note in Rosetta's `who/coordination/`; 4 decisions resolved; **awaiting an (outward) Rosetta release gate** to actually flip green |
| 2 | **Home.aDNA** (Hestia) | [[coord_draft_home_credentials_shims]] | **before R1/P5** | `CODEBERG_TOKEN` provisioned (ADR-007) + the remote-repoint shim registry (Rule 9) | **READY-TO-DELIVER 2026-06-20** (turnkey provisioning kit attached) — **delivery HELD** (Home.aDNA active Hestia session); then **awaiting operator PAT-mint** to flip green |
| 3 | **aDNALabs.aDNA** (Berthier) | [[coord_draft_adnalabs_migration_coexistence]] | **before each R2 wave** | Homecoming↔Path-B visibility partition; name-drift + straggler reconciliation | staged |
| 4 | **Network.aDNA** (Venus) | [[coord_draft_network_mesh_git]] | **R3 / P7a** (integration) | §8 forge-placement · Forgejo-as-context-sync (drill-#7) · identity bridge · DNS/TLS | staged |
| 5 | **Lighthouse.aDNA** | [[coord_2026_06_20_git_lighthouse_handoff]] | **Lighthouse.aDNA P0** | the standard↔deployable handoff + seed-corpus quarry | staged |

## R1/P5 prerequisites (the critical path)
Before the **first outward phase** (R1 — Codeberg-FOSS beachhead) can execute, **#1 (Rosetta release)** and **#2 (Hestia `CODEBERG_TOKEN`)** must land — plus the operator's **Decision Point 4** authorization for outward actions (create the Codeberg org + first pushes). Git.aDNA will not start R1 without all three.

> **Update 2026-06-20 (non-outward prereq-drive — `session_stanley_20260620_git_p5_prereq_delivery`).** Both memos advanced to the operator/outward boundary:
> - **#1 DELIVERED** to Rosetta (decisions resolved). **Finding:** `skill_template_release` is **outward** (public-face push + standard version-bump) and there's no open release gate, so #1's green-flip is a *future operator-gated Rosetta release* — not achievable under a non-outward authorization. The ask is queued + turnkey.
> - **#2 READY-TO-DELIVER** (turnkey kit: mint steps + stash commands + ready-to-paste C58 row); **held** (Home active session). #2's green-flip needs the **operator to mint the Codeberg PAT** (a human-only action).
>
> **Net remaining for R1:** (a) a Rosetta release gate fires the skill batch [outward], (b) operator mints `CODEBERG_TOKEN` [human], (c) operator **DP4** + **SD-2** pilot pick [decision]. All three are inherently operator/outward — the non-outward runway is now fully consumed.

## Delivery discipline
Each delivery is itself a cross-vault action: when working in the target vault (or at operator direction), copy/adapt the staged memo into that vault's intake, record acceptance, and flip the row here to **DELIVERED + accepted**. Nothing in this queue is an outward (remote/push) action.
