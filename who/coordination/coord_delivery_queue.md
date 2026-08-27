---
type: coordination
coord_id: coord_delivery_queue
title: "Cross-Vault Hand-Off Delivery Queue (staged memos)"
created: 2026-06-20
updated: 2026-08-27
status: active
last_edited_by: agent_stanley
tags: [coordination, delivery_queue, handoff, p6, wave1, wave2, operation_free_harbor]
---

# Cross-Vault Hand-Off Delivery Queue

The staged coord memos awaiting delivery to peer vaults. Per **Standing Rule 10**, Git.aDNA does not write into other vaults — these are **prepared + queued here**; delivery happens when the target vault is engaged or by the operator. This index makes the next session's hand-offs explicit.

| # | To (persona) | Memo | Trigger | Unblocks | Status |
|---|---|---|---|---|---|
| 1 | **aDNA.aDNA** (Rosetta) | [[coord_draft_adna_skill_upstreaming]] | **DECOUPLED at R1/P5** → fast-follow | the agnostic skills released into `.adna/` via `skill_template_release` | **DELIVERED + DECOUPLED 2026-06-20** — operator decoupled Gate #1; the beachhead **validated the skills live** on local copies first (*validate-then-release*). **🔧 The release MUST first fold 5 beachhead lib fixes** (GitHub push-auth · Forgejo `cut-release` target · `create-org` verb · rename-redirect · livesmoke private). Still awaits an outward Rosetta release gate. |
| 2 | **Home.aDNA** (Hestia) | [[coord_draft_home_credentials_shims]] | R1/P5 done → fast-follow | `CODEBERG_TOKEN` provisioned (ADR-007) + the remote-repoint shim registry (Rule 9) | **TOKEN PROVISIONED 2026-06-20** — operator minted the Codeberg PAT → stashed to Keychain + `~/.zshrc` (used live in the beachhead). **Fast-follow:** Hestia formalize the NAMES-ONLY `C58` inventory row + 1P backup-of-record. **Shim registry: 6 Wave-1 entries STAGED** 2026-06-21 in [[wave1_runbook]] (per-graph, with rollback paths) — apply at the Wave-1 gate. **Wave-1b Videos §C shim coord DELIVERED 2026-06-21** → `Home.aDNA/who/coordination/coord_2026_06_21_git_wave1b_videos_shim.md` (new **host-move / git-remote-rollback** shim class; uncommitted per the Wave-1a `origins` precedent → Hestia registers). **Oration/Spacemacs (2026-06-21) + Molecules (2026-06-22) §C shims also DELIVERED** → Home inbox. **[2026-06-22] Wave-2 Astro §C shim DELIVERED** → `Home.aDNA/who/coordination/coord_2026_06_22_git_wave2_astro_shim.md` — **NEW sub-class: native-transfer / redirect-based (no `rollback` remote; rollback = re-transfer)**. **Open fast-follows: Hestia registers all 5 §C shims (4× Wave-1b + Astro) + the NAMES-ONLY `C58` token row.** **[2026-08-21] NEW — `ack_required` ⛔ STAGED, SEND REFUSED BY THE LEASE PROBE** (Home quiet at 12:40, `session_..._p5_4_gate_ruling_and_intake` **`active`** at the copy; *the GO authorises the send, the probe governs the moment*) → [[coord_2026_08_21_hopper_to_hestia_adr015_d13_trust_anchor_assignment]]: **ADR-015 D1.3 assigns trust-anchor distribution to Home.aDNA's node-inventory channel, and it ratified 2026-08-21 without her ever seeing it.** Venus's catch (her rev-4 concurrence §E3 — *"we are declining to let a capability be assigned to a third vault by our silence"*); **the fourth capability this one ADR assigns by prose**, and the only one that reached ratification uncaught. **Ask = one ruling: is that channel hers to commit?** Not urgent (the clause binds only if the ACME DNS-01 primary fails, and the fallback sits behind a CA-custody gate that has been NO-GO ×13); **real** nonetheless. Deliberately raises **no** other Home-side item. ⏭ **NEXT ACTION IS OURS, not hers**: probe `Home.aDNA/how/sessions/active/`; when clear, stamp the three `null` delivery fields **at** the act (F-DEL-01), copy → `who/coordination/inbox/`, `cmp` both sides, **do not commit her tree**. Only then does her ruling become the pending item. |
| 3 | **aDNALabs.aDNA** (Berthier) | [[coord_draft_adnalabs_migration_coexistence]] | **before the R2/P6 Wave-1 gate** | Homecoming↔**ADR-013** visibility partition; name-drift (`Molecules`/`Oration`) + cross-org (`Spacemacs`→Codeberg, `Astro`→GitHub-public) reconciliation | **DELIVERED (file) 2026-06-21** → `aDNALabs.aDNA/who/coordination/coord_2026_06_21_inbound_from_hopper_git_wave1_homecoming.md` (Spacemacs FOSS-confirmed; Videos canary fired = FYI; Molecules/Oration/Spacemacs asks pending operator confirm). **aDNALabs-side commit DEFERRED to Berthier** — a concurrent `leg_a_iii_hardening` session appeared after my collision-check (files touched ~22:14); collision-avoid (Hestia-P5 discipline) ⇒ I did not commit their git state. **Awaiting Berthier ack + commit.** **[2026-06-22] Wave-2 Astro coord** → [[coord_2026_06_22_git_wave2_astro_cross_org]] **→ ✅ RESOLVED 2026-06-22:** operator BSL-1.1 posture = **keep private** ⇒ Astro reclassified **W2→W3 (class I)**; the cross-org **transfer + rename executed this session under operator ack** (= Berthier cross-persona ack), kept **private** (no public flip; `LatticeProtocol/SiteForge.aDNA` → `aDNA-Network/Astro.aDNA`; HEAD `0d0c315`; old paths redirect). **No GitHub org-admin action remains for Berthier** (transfer/rename/redirects in place — FYI only); coord → `resolved`. |
| 4 | **Network.aDNA** (Venus) | [[coord_draft_network_mesh_git]] | **R3 / P7a** (integration) | §8 forge-placement · Forgejo-as-context-sync (drill-#7) · identity bridge · DNS/TLS | **discharged 2026-08-08** by [[coord_2026_08_08_hopper_dp2_ruling_and_replies]] (trigger fired at the P7 charter; §8 resolved by Venus's scoped-R&D ruling; remaining content rides the P7a joint-ADR work) |
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

## 2026-08-27 (25th sitting) — 2 DELIVERED to Ilmarinen · 2 NEW STAGED under ADR-016 D6.5

**Delivered** (probe-gated, `--exec`, GO both times; fleet-wide `find` confirms placement in
`Forgejo.aDNA` only):

| memo | note |
|---|---|
| `coord_2026_08_26_hopper_to_ilmarinen_the_boundary_had_no_predicate` | held **one sitting** by a correct `writedir_dirty` BLOCK. Re-measured, not adopted from his §6 claim that his surface was quiet — it was. |
| `coord_2026_08_27_hopper_to_ilmarinen_you_were_right_and_the_population_was_wider_than_the_correction` | reply: his census correction sustained at source **and extended** |

⚠ **F-P7b-ad** — both copies in his vault carry **pre-stamp frontmatter** (`status: staged`). The
stamp runs after the `cp`; re-delivering the stamped version was attempted and **correctly REFUSED**
on `dest_collision` (no-overwrite). Drift recorded, **not forced**. Second limb: the redaction check
ran *after* the `cp` rather than before — clean by authorship, not by control. Ilmarinen's
`send_memo.sh` **STEP 3b** does exactly this before the `cp`; we have no send tool at all.

**Newly staged — NOT delivered.** Outward lane this sitting was **Ilmarinen only** (operator ruling);
these are owed under [[adr_016_publication_boundary|ADR-016]] **D6.5** (notify every carrying graph
with the measurement attached, so it can refute rather than accept):

| # | To (persona) | Memo | Why | Status |
|---|---|---|---|---|
| 6 | **aDNA.aDNA** (Rosetta) | `coord_2026_08_27_hopper_to_rosetta_your_public_repo_carries_our_forge_address_once` | `aDNA.aDNA` is public and carries the forge address **1×** on `main`, in `keystone_cohort_manifest.md` — the roster the whole Keystone cohort federates against | **staged**, `ack_required: true` |
| 7 | **Canvas.aDNA** (Mondrian) | `coord_2026_08_27_hopper_to_mondrian_canvas_is_public_and_carries_the_forge_address_twice` | `Canvas.aDNA` is public and carries it **2×** on `master`, one of them **inbound mail from Vulcan** — the clearest live instance of D2.4 | **staged**, `ack_required: true` |

⛔ **Berthier's Codeberg 19/19 remains unsent for a FOURTH sitting** — offered at this sitting's gate
and declined again. It is the oldest open delivery on this desk and is named here so the age is
visible rather than inferred.

---

## 2026-08-27 (26th sitting) — ✅ **ALL FIVE DELIVERED, through a send path that did not exist this morning**

**The queue is empty for the first time since it was opened.** Every row above is discharged.

| # | To | Memo | Route | Verified |
|---|---|---|---|---|
| — | **aDNALabs.aDNA** (Berthier) | `…_codeberg_lane_re_derived_19_of_19` | direct | ⭐ **the oldest open delivery — five sittings owed, four gate declines** |
| 6 | **aDNA.aDNA** (Rosetta) | `…_your_public_repo_carries_our_forge_address_once` | direct | D6.5 discharged |
| 7 | **Canvas.aDNA** (Mondrian) | `…_canvas_is_public_and_carries_the_forge_address_twice` | direct | D6.5 discharged |
| — | **Forgejo.aDNA** (Ilmarinen) | `…_your_66_20_reproduces_ours_was_wrong` | direct | census reconciled in his favour |
| — | **Exchange.aDNA** (Hermes) | `…_yes_carry_it_to_venus` | direct | his offer accepted at the gate |

**Per-delivery invariants, measured not assumed:** the recipient's copy reads `status: delivered`
(⭐ the exact inverse of the F-P7b-ad drift) · **0** `delivered_md5` in the field copy, **1** in the
retained (F-F35 — no copy states its own hash) · retained/delivered differ by **exactly one line** ·
fleet-wide `find` returns **exactly one vault** per memo · boundary **CLEAN** on all five against a
live control (`STATE.md` REFUSES, so "clean" is a measurement and not a default).

⛔ **The two drifted copies in `Forgejo.aDNA` stay as they are.** No re-delivery, no overwrite. Their
`dest_collision` refusal was correct and stays correct — recording the drift beats forcing it, and
under **D6.1** the repair is not ours to make in his tree.

⚠ **F-P7b-ak — the send path broke its own rule on first use, and is fixed.** `--dry-run` stamped the
retained memo *before* branching, so five memos briefly read `status: delivered` while nothing had
been copied. Repaired (the dry run stamps a copy), the five were restored to `staged`, and the arm
that was missing — *stamped nothing*, not merely *copied nothing* — now exists with its paired check.
