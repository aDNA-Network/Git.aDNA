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
updated: 2026-08-22
last_edited_by: agent_stanley
tags: [plan, campaign, git, genesis, mesh_git, north_star, forgejo, context_sync, forgefed, operation_free_harbor, obj_4_complete_shape_a, obj_5_next, f_p7b_a, f_p7b_b, f_p7b_c, f_p7b_d, f_p7b_e, f_p7b_f, f_p7b_g, f_p7b_h]
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
   - ## ✅ **COMPLETE 2026-08-22T01:20Z — shape A. Read the next two lines together or not at all.**
     **What was proven:** *the git lane round-trips on the R&D forge.* Push `169eff4..aefcfb3` → clone →
     **HEAD equal · tree-hash `77926c93…` equal · clone `status` empty · 554 tracked files, 0 missing ·
     symlink resolves inside the clone · 0 line-anchored LFS pointers · replica tip == `$SRC`.** All
     three §D1.5b instrument controls re-fired first (`303`+`Location` @ `num_redirects=0` · `401` · `200`).
     Spike report: [[p7b_staging/context_sync_runbook#⭐ §6a · SPIKE REPORT — the trip ran, 2026-08-22T01:17–01:20Z|context_sync_runbook §6a]].
     **What was NOT proven:** *that the git lane carries subnet context.* **P4 — a genuinely far side —
     remains unbuilt**; shape A is a same-node scratch clone and exercises no mesh routing, no second
     peer's credentials, no foreign filesystem layout. **Shape B is owed at the D4 production revisit**,
     and obj 4's whole point is the far side. Recorded in these words on purpose: reporting A's result
     in B's language is the transcribed-status class this campaign has filed five times.
   - ~~⏳ IN PROGRESS 2026-08-21 — the reconciliation half is DONE, the round-trip is staged, not run.~~ *(superseded within the day; the reconciliation half stands and is recorded below.)*
   - ⛔ **This objective's premise was wrong and is corrected**: it reads as greenfield (*"point a graph's `git/` at…"*), but **the lane is already live** — **20 distinct vaults** on **3 mesh fabrics**, 11 on the R&D forge, **including `Git.aDNA` itself** (`mesh-rd`). Obj 4's real content is *prove the round-trip*, not *build the lane*. (**F-P7b-b**.)
   - **Reconciliation delivered** → [[../../../../what/inventory/context_sync_lane_assignment|context_sync_lane_assignment]] (`measured_at` 2026-08-21T23:49Z). **F-P7b-a**: D3 §2's convergence criterion retires an **empty set** — no git-homed vault rides the ceremony lane (all 9 payloads are node vaults; ADR-004 excludes `.git/`) and transmissions are **event-driven, not scheduled**. The adjacent non-empty set — ADR-020's consented `campaign_state/` slice — would be swept up by a loose reading, a **consent regression**. Memo to Venus **staged**; the amendment is her clause.
   - **F-P7b-c → CLOSED AS AN OBSERVATION, not as an adjudication.** The replica (7 commits behind by the time of the trip) now carries ADR-015's ratification, so a peer no longer reads our P7a gate as `proposed`. ⛔ **But whether the lag was a *defect* remains unanswerable**: `freshness_mode` exists in no conf (**A4 §1a**, Berthier's pen). The push turned **our** row green and left the other ten exactly as unadjudicable — **F-A4-01's cost, paid rather than argued.**
   - **Round-trip runbook** → [[p7b_staging/context_sync_runbook|context_sync_runbook]] (**`executed` — §4 fired once, shape A; §7 non-goals untouched, not a standing authorisation**). Preconditions at the window: P1 ✅ **8 PASS / 0 BLOCK** fresh · P2 ✅ · P3 ✅ · **P4 ⛔ STILL unbuilt** · P5 ✅ **opened** · P6 ⛔ conf patch.
   - ⛔ **F-P7b-g + F-P7b-h — the runbook's own §4.5 shipped two checks that would have FALSE-BLOCKED a passing trip**, found only by running it. `diff -r` compared a working tree against a fresh clone and returned 3 untracked-and-gitignored files (`.DS_Store`, two `.obsidian/*`) ⇒ **a check that could not succeed** — the exact mirror of the false-pass its own `--no-dereference` clause correctly guards, two clauses away. And the LFS grep was **un-anchored**: it matched the same two signature-*quoting* files F-P7b-e named the night before — **the fix landed in the script and the defect was copied into the runbook and left there.** ⚠ *A finding closed at its instance is not a finding closed* (**A4 §3**, on F-Astro), earned again by its author one day later. Both corrected; claims struck, not rewritten.
   - **Instrument** → `how/tests/preflight_context_sync.sh` (read-only; 7 sabotage fixtures + known-good control, ADR-011 A4 §6). **F-P7b-d**: its own meta-control was found adjudicating a counter discarded by a subshell — *every sabotage row passed by construction* — caught only because the known-good control existed.
5. **Federation** — mirror-mesh between the lighthouse forge and another forge; ForgeFed experiment + watch-item note.
6. **Spike report** — viability, gaps, and the **build-`Lighthouse.aDNA`-deployable** go/no-go.

## Campaign Context
- **Prev ([[p7a_integration_architecture|P7a]])**: the ratified integration architecture (forge-placement, context-sync protocol, identity bridge, addressing). Also needs M5 (the proven abstraction); runs parallel to M6.
- **Next (M8)**: the spike report feeds closeout + the `Lighthouse.aDNA` deployable build (its own genesis).

## Notes
- Reuses the seed deploy/runbook/backup corpus (now the `Lighthouse.aDNA` **quarry**). Identity/mesh belong to Network.aDNA — coordinate, don't absorb. The deployable build is `Lighthouse.aDNA`'s, not this spike's.

## AAR
*Append before `status: completed`. Mission stays `active` — obj 5–6 outstanding.*

### AAR — obj 4 (2026-08-22, shape A)

**Worked.** Staging the runbook a sitting *before* the window, with preconditions **measured** rather
than asserted, meant the outward gate was opened against a known cost — and meant the checks existed
in writing early enough that **running them could falsify them**. Re-firing the three §D1.5b controls
before the trip rather than inheriting the previous sitting's readings cost two minutes and is the
only reason the capture is trustworthy. Delivering the two memos *before* the push put both on the
replica in the same transfer.

**Didn't.** §4.5 shipped **two checks that could not pass** (F-P7b-g, F-P7b-h). One compared a working
tree to a fresh clone and so could never be empty; the other used the **un-anchored** LFS grep that
had been fixed in the script the night before and copied here unfixed. Both would have reported a
**false BLOCK on a round-trip that passed** — in the §4.5 that reasons, correctly and in writing,
about checks that cannot fail.

**Finding.** *The check must state precisely what it measures* — and it has now failed in **all three
directions inside 48 hours**: a check that could not **fail** (F-P7b-e), a check that matched
**documentation instead of the artifact** (F-P7b-f, in a peer's tree, against our own hook, and it
would have moved 68 repos), and a check that could not **succeed** (F-P7b-g). ⭐ **The generalisation
that survives: a check is not validated by the direction of its output. Two of these three printed the
answer we wanted.** And **F-P7b-h is the sharper half** — the fix was made and *not swept for*, which
is verbatim the F-Astro lesson this vault wrote into ADR-011 A4 §3 one day earlier.

**Change.** ADR-011 **A5 §4** binds the predicate-precision rule at standard level. `context_sync_runbook`
§4.5 rewritten with both defects **struck, not erased**. §6a states the shape that ran, **and** the
sentence it does not license. The `f255e2a0…` adjudication now has a **behavioural** corroboration — the
push named its scanned range where the retired no-op names none.

**Follow-up.** (a) **Obj 5 — mirror-mesh federation** (own gate). (b) **Shape B at the D4 revisit** —
obj 4 is closed on the weaker claim and that is written down. (c) `freshness_mode` conf patch —
**11 mesh rows stay unadjudicable** and one green row does not change that. (d) **A5 must reach
Rosetta**: they have adopted A2 §4 *as written*, which A5 §1 shows is insufficient alone. (e) The
Galileo reply, staged — until it lands, their records carry the §4(b) reading.
