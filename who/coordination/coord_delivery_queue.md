---
type: coordination
coord_id: coord_delivery_queue
title: "Cross-Vault Hand-Off Delivery Queue (staged memos)"
created: 2026-06-20
updated: 2026-06-21
status: active
last_edited_by: agent_stanley
tags: [coordination, delivery_queue, handoff, p6, wave1, operation_free_harbor]
---

# Cross-Vault Hand-Off Delivery Queue

The staged coord memos awaiting delivery to peer vaults. Per **Standing Rule 10**, Git.aDNA does not write into other vaults — these are **prepared + queued here**; delivery happens when the target vault is engaged or by the operator. This index makes the next session's hand-offs explicit.

| # | To (persona) | Memo | Trigger | Unblocks | Status |
|---|---|---|---|---|---|
| 1 | **aDNA.aDNA** (Rosetta) | [[coord_draft_adna_skill_upstreaming]] | **DECOUPLED at R1/P5** → fast-follow | the agnostic skills released into `.adna/` via `skill_template_release` | **DELIVERED + DECOUPLED 2026-06-20** — operator decoupled Gate #1; the beachhead **validated the skills live** on local copies first (*validate-then-release*). **🔧 The release MUST first fold 5 beachhead lib fixes** (GitHub push-auth · Forgejo `cut-release` target · `create-org` verb · rename-redirect · livesmoke private). Still awaits an outward Rosetta release gate. |
| 2 | **Home.aDNA** (Hestia) | [[coord_draft_home_credentials_shims]] | R1/P5 done → fast-follow | `CODEBERG_TOKEN` provisioned (ADR-007) + the remote-repoint shim registry (Rule 9) | **TOKEN PROVISIONED 2026-06-20** — operator minted the Codeberg PAT → stashed to Keychain + `~/.zshrc` (used live in the beachhead). **Fast-follow:** Hestia formalize the NAMES-ONLY `C58` inventory row + 1P backup-of-record. **Shim registry: 6 Wave-1 entries STAGED** 2026-06-21 in [[wave1_runbook]] (per-graph, with rollback paths) — apply at the Wave-1 gate. **Wave-1b Videos §C shim coord DELIVERED 2026-06-21** → `Home.aDNA/who/coordination/coord_2026_06_21_git_wave1b_videos_shim.md` (new **host-move / git-remote-rollback** shim class; uncommitted per the Wave-1a `origins` precedent → Hestia registers). |
| 3 | **aDNALabs.aDNA** (Berthier) | [[coord_draft_adnalabs_migration_coexistence]] | **before the R2/P6 Wave-1 gate** | Homecoming↔**ADR-013** visibility partition; name-drift (`Molecules`/`Oration`) + cross-org (`Spacemacs`→Codeberg, `Astro`→GitHub-public) reconciliation | **DELIVERED (file) 2026-06-21** → `aDNALabs.aDNA/who/coordination/coord_2026_06_21_inbound_from_hopper_git_wave1_homecoming.md` (Spacemacs FOSS-confirmed; Videos canary fired = FYI; Molecules/Oration/Spacemacs asks pending operator confirm). **aDNALabs-side commit DEFERRED to Berthier** — a concurrent `leg_a_iii_hardening` session appeared after my collision-check (files touched ~22:14); collision-avoid (Hestia-P5 discipline) ⇒ I did not commit their git state. **Awaiting Berthier ack + commit.** **[2026-06-22] Wave-2 Astro coord STAGED** → [[coord_2026_06_22_git_wave2_astro_cross_org]]: cross-org transfer + rename `LatticeProtocol/SiteForge.aDNA` (private) → `aDNA-Network/Astro.aDNA`, **+ a new BSL-1.1 posture flag** (Astro is source-available BSL, status `active` — confirm public-vs-keep-private before any flip). Deliver from an aDNALabs session. |
| 4 | **Network.aDNA** (Venus) | [[coord_draft_network_mesh_git]] | **R3 / P7a** (integration) | §8 forge-placement · Forgejo-as-context-sync (drill-#7) · identity bridge · DNS/TLS | staged |
| 5 | **Lighthouse.aDNA** | [[coord_2026_06_20_git_lighthouse_handoff]] | **Lighthouse.aDNA P0** | the standard↔deployable handoff + seed-corpus quarry | staged |

## R1/P5 EXECUTED 2026-06-20 — host-role inversion ([[adr_013_host_role_inversion|ADR-013]])
The first outward phase ran. **DP4 authorized · `CODEBERG_TOKEN` minted · Gate #1 decoupled** (validate-then-release). Delivered under an operator **host-role inversion**: **Git.aDNA → GitHub-public** (predecessor archived → `Git.aDNA-legacy`) · **TypeScript.aDNA → Codeberg-private** (P-dev). Rollback drill PASS. See the STATE intake log + [[p5_codeberg_beachhead]] AAR. Remaining queue items are R2+/fast-follow.

> *(The dated prereq-drive note below is retained as history; its "gated/pending" framing is superseded by the execution above.)*

> **Update 2026-06-20 (non-outward prereq-drive — `session_stanley_20260620_git_p5_prereq_delivery`).** Both memos advanced to the operator/outward boundary:
> - **#1 DELIVERED** to Rosetta (decisions resolved). **Finding:** `skill_template_release` is **outward** (public-face push + standard version-bump) and there's no open release gate, so #1's green-flip is a *future operator-gated Rosetta release* — not achievable under a non-outward authorization. The ask is queued + turnkey.
> - **#2 READY-TO-DELIVER** (turnkey kit: mint steps + stash commands + ready-to-paste C58 row); **held** (Home active session). #2's green-flip needs the **operator to mint the Codeberg PAT** (a human-only action).
>
> **Net remaining for R1:** (a) a Rosetta release gate fires the skill batch [outward], (b) operator mints `CODEBERG_TOKEN` [human], (c) operator **DP4** + **SD-2** pilot pick [decision]. All three are inherently operator/outward — the non-outward runway is now fully consumed.

## Delivery discipline
Each delivery is itself a cross-vault action: when working in the target vault (or at operator direction), copy/adapt the staged memo into that vault's intake, record acceptance, and flip the row here to **DELIVERED + accepted**. Nothing in this queue is an outward (remote/push) action.
