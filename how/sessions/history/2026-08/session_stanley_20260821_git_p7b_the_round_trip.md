---
type: session
session_id: session_stanley_20260821_git_p7b_the_round_trip
date: 2026-08-21
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — obj 4: fire the context-sync round-trip (shape A) + rule on an inbound that inverts a 68-repo verdict"
door: "§1 intake Galileo · §2 adjudicate at source (F-P7b-f) · §3 ADR-011 A5 · §4 repoint-runbook corrections · §5 deliver the two staged memos · §6 fire the round-trip · §7 close"
plan: please-read-the-claude-md-declarative-blum
head_at_open: 616c15c
head_at_close: pending_commit   # close commit; the three authored commits were bb28f61 (authoring) · aefcfb3 (delivery tracking) · f7a1b5c (round-trip results)
inbound_at_close: 2             # F-INTAKE-04 fired — opened at 1, closed at 2; both dispositioned by name
inbound_at_open: 1     # coord_2026_08_21_galileo_to_hopper_p7a_window_nomination (untracked)
leases_at_open: 0      # Home.aDNA 0 active · Network.aDNA 0 active — BOTH CLEARED since last sitting
operator_rulings:
  - "⭐ OUTWARD WINDOW OPEN — fire shape A (AskUserQuestion, this sitting)"
  - "Deliver BOTH staged memos — Hestia + Venus; NO third memo to Galileo (AskUserQuestion, this sitting)"
  - "Galileo's §3 + §5 carried as a NEW Amendment A5, not folded into A4 (AskUserQuestion, this sitting)"
declared_files:
  - who/coordination/                                        # §1 intake · §5 delivery stamps · §7 staged Galileo reply
  - what/inventory/galileo_inbound_adjudication.md           # §2 — new
  - what/decisions/adr_011_secret_scanning.md                # §3 — A5 appended; A2 §4 ratified text NOT edited
  - how/campaigns/campaign_git_genesis/missions/p7a_flip_staging/gate_repoint_runbook.md  # §4
  - how/campaigns/campaign_git_genesis/missions/p7b_staging/context_sync_runbook.md       # §6 — §2 rows trued up
  - how/campaigns/campaign_git_genesis/missions/p7_mesh_git_spike.md   # §6 §7 — obj 4 disposition
  - STATE.md
cross_vault:
  - Home.aDNA/who/coordination/       # §5 — memo delivery, peer copy left UNTRACKED (Rule 10/11)
  - Network.aDNA/who/coordination/    # §5 — memo delivery, peer copy left UNTRACKED (Rule 10/11)
outward:
  - "git push mesh-rd master (§6.3) — the first outward act of P7b"
  - "git clone rd-forge:aDNA-Network/Git.aDNA.git (§6.4)"
tags: [p7b, obj_4, context_sync, round_trip, shape_a, outward, adr_011_a5, f_p7b_f, galileo, memo_delivery]
---

# Session — P7b obj 4: fire the round-trip, and reject a measurement that would have moved 68 repos

## Standing laws this session must not break

- **⭐ Outward is OPEN, and it is open for exactly one thing.** The gate authorises the §6 round-trip
  and the §5 memo deliveries. It does **not** authorise hook installs, repo creation, wrapper repoints,
  or a `.adna/` edit (Rule 1). An open door is not a wide door.
- **⛔ Shape A licenses one sentence and not the other.** *"The git lane round-trips on the R&D forge"*
  — **never** *"carries subnet context."* P4 (a genuinely far side) is **unbuilt**; a same-node clone
  exercises no mesh routing, no second peer's credentials, no foreign filesystem layout. Obj 4's whole
  point is the far side, so reporting A in B's language would be the worst instance of the class this
  campaign has filed five times, not the sixth.
- **⛔ Never `--force`.** The replica is a peer-readable artifact. Provenance is sacred; it is git.
- **If the pre-push gate refuses, that is the gate working.** Do not bypass. Record and stop.
- **Every check states its failure condition at the point of definition** (ADR-015 §D1.5b, generalized).
- **The delivery probe governs the moment, not the GO.** Re-probe each peer lease immediately before
  the copy; stamp the delivery fields **at** the act, never ahead of it (**F-DEL-01**, our own defect
  from yesterday).

---

## §1 · Intake — one inbound, named

`coord_2026_08_21_galileo_to_hopper_p7a_window_nomination.md` — Galileo (`Jupyter.aDNA`,
`bright_sextant`), `ack_required: false`, delivered first-attempt into our flat `who/coordination/`.
Untracked at open; **enumerated and dispositioned in this session's authoring commit message**
(F-P7a-d — an inbound that enters a commit silently was never intaken).

It answers the one question our 08-20 memo asked (*"is there a window you would rather they fired
in?"*) — **now** — and adds four facts. Two are real defects in our own text. One is false in a way
that matters more than the true ones.

## §2 · The adjudication — measured at source, not transcribed

Every checkable claim was re-derived in this sitting rather than accepted from the memo. That is the
discipline this vault has applied to every peer document since the fourth sitting, and it has caught
drift every single time. It caught drift again.

→ `what/inventory/galileo_inbound_adjudication.md`

**The rejection is the headline.** §4(b) nominates `Jupyter.aDNA`'s vault repo as *"a seventh ungated
push path"* on the grounds that its hook (`f255e2a0…`) is *"v1 content class (two `--pre-commit`
sites)."* Measured: that hook has **8 `remote_sha`/`local_sha` sites**, reads the outgoing refs from
pre-push stdin, constructs a real `--log-opts` range, **fails closed** when the scanner is absent, and
ships a `--self-test` whose planted secret is a **synthetic `ghp_` token assembled at runtime so the
literal never appears contiguously in the file**. Its **one** `--pre-commit` occurrence is at line 13,
inside the comment block explaining what it fixed.

⇒ **A hook was adjudicated by grepping a string that appears in the hook's own documentation.** That is
**F-P7b-e**, which this vault filed **against itself last night**, when `preflight_context_sync.sh`'s
`lfs_rehydration` check false-BLOCKED on the only two files in the tree that *quote* the LFS pointer
signature — this script and the runbook documenting it. Same root error, *the check did not state
precisely what it measures*, in a peer's instrument, inside twenty-four hours, **on our own hook**.

`f255e2a0…` carries **68 of the fleet's 70 passing repos** (census §51). Taken at face value the
reading moves fleet coverage from 60% toward 2% on the strength of a comment.

⚠ **And §4(b)'s conclusion is right for the opposite reason.** They recommend *not* installing v2
there — correct, but not because the repo is ungated and the install is risky. Because the repo is
**already behaviourally gated**, and v2 is a version bump rather than a repair (A3 §1). The operator
gate they proposed is not needed at all. *A correct action reached through a false measurement is not
a correct measurement, and the next decision taken on that reading will not be lucky.*

## §3 · ADR-011 Amendment A5

A2 §4 is **ratified** — it is amended, never edited. Four clauses; the induced-positive defect is
Galileo's, credited by name and quotation.

## §4 · Repoint-runbook corrections

Row 9's premise inverts under the same measurement: all five `latlab` checkouts resolve to a
**regular-file v2 install**, so row 9 is already closed *for coverage* and its repoint is
tracked-wrapper hygiene. The runbook currently calls it *"the largest single win."*

## §5 · Delivery — two debts, both refused at their last attempt

Both leases cleared. Re-probe, copy, stamp at the act, `cmp`.

## §6 · The round-trip

Fires **after** §1–§5 are committed, so the push also cures **F-P7b-c**: our replica does not carry
ADR-015's ratification, and a peer reading `Git.aDNA` over the git lane today sees the P7a gate as
`proposed`.

## §7 · Close — SITREP

**⭐ Obj 4 closed on the round-trip; the campaign's own instruments failed three ways in 48 hours.**

| Door | Outcome |
|---|---|
| §1 intake | 2 inbound (1 at open, 1 mid-session), both dispositioned **by name** in a commit message |
| §2 adjudication | 4 accept · **1 REJECTED, measured false** → `galileo_inbound_adjudication.md`, **F-P7b-f** |
| §3 ADR-011 **A5** | `proposed` — 4 clauses; A2 §4 (ratified) amended, never edited |
| §4 repoint runbook | row 9 reclassified (claim **struck**), row 8 re-verified, `--git-common-dir`, pinned-checkout question, 3-part induced positive; exit arithmetic re-derived |
| §5 delivery | **2/2 delivered**, `cmp` identical, lease re-probed **at the act**; Hestia's on its **third** attempt |
| §6 round-trip | ✅ **PASS**, shape A — and it surfaced **F-P7b-g** + **F-P7b-h** in §4.5 |
| §7 close | mission card obj 4 `complete` + AAR · STATE tenth-sitting entry · Galileo reply **staged** |

**The one sentence this sitting earned:** *the git lane round-trips on the R&D forge.* **Not** *carries
subnet context* — P4 is unbuilt, shape B is owed at the D4 revisit, and obj 4's whole point is the far
side.

⚠ **The close commit puts the replica one behind again.** Expected, stated, not a defect.

⛔ **Two things are live in other people's trees because of a scoping choice made here:** Galileo's
records hold the §4(b) reading (68 repos, known-false to us), and Rosetta has adopted **A2 §4 as
written** — the clause A5 §1 shows is insufficient alone. Both are on the debt register; **the delay
is in the sending, not in the ruling.**

### Next Session Prompt

> Read `CLAUDE.md`, then `STATE.md` (tenth sitting). **P7b obj 4 is CLOSED on shape A.** Highest-value
> next moves, in order: **(a)** deliver the two staged memos — the **Galileo** reply
> (`coord_2026_08_22_hopper_to_galileo_the_grep_read_the_comment.md`, `severity: high`, a false reading
> about 68 repos sits in their tree) and an **A5 notice to Rosetta** (they are implementing A2 §4 as
> written) — probe each lease **at the act**; **(b)** obj 5 mirror-mesh federation, its own gate;
> **(c)** operator §7.7 on ADR-011 **A3 + A4 + A5** and ADR-014 A4; **(d)** shape B when a second mesh
> peer is reachable. **Do not report obj 4 as "context-sync proven"** — the mission card records
> exactly which sentence it licenses.

---

## Running log

### ⚠ F-INTAKE-04, fourth consecutive instance — a second inbound arrived mid-session

`inbound_at_open` was **1**. At the authoring commit's `git status` it was **2**:
`coord_2026_08_21_rosetta_to_hopper_template_gate_is_ours.md` (Rosetta, `campaign_haussmann`,
`ack_required: false`). *A clean sweep at open is not a clean sweep at close* — read and dispositioned
by name **before** the commit, not swept into it.

**Disposition: a carried debt discharges and nothing is owed back.** Operator ruled
`2026-08-21T23:51:27Z` that the `.adna/` pre-push gate is **aDNA.aDNA's to carry** via
`skill_template_release`; routed to their P4.4 as `F-k`. Our read of Standing Rule 1 was confirmed
correct — *"you were not blocked by the rule; you were correctly routed by it."* **⇒ `.adna/` template
gate leaves our debt register** (it is now Rosetta's, with **no date**, honestly pinned as such).

Three things worth keeping:
- ⭐ **The no-op is confirmed in live operation, not on an md5.** Their push at `45adf02` printed
  `pre-push: gitleaks clean ✓` having scanned nothing, while a hand-run `gitleaks detect` returned
  `leaks found: 1`. Our `216aaca2…` identification is now corroborated behaviourally by a second vault.
- They adopted **A2 §4** (no install recorded on an md5) and flagged **A4 §6** as standard-shaped —
  ⚠ **and both now need A5 attached**: their convention 14 says *"an instrument is not believed until
  it has been demonstrated to fail"*, which is precisely the clause A5 §1 shows is insufficient on its
  own. **A5 must reach them before they implement A2 §4 as written.** Added to the debt register.
- Their `pin_supersession` reads *"if Git.aDNA re-cuts the skeleton, YOUR batch is the source at fire
  time."* **A5 does not re-cut the skeleton** — `a1288f73…` is unchanged; A5 changes how an install is
  *validated*, not what is installed. Their pin stands.
