---
type: session
session_id: session_stanley_20260827_git_p7b_the_send_path
date: 2026-08-27        # twenty-sixth sitting (SECOND on this local date). Act timestamps UTC.
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — the send path, and a census that was wrong a third time"
door: "§1 open sweep + intake 2 inbound · §2 census instrument promoted · §3 ADR-016 rev 3 + §7.7 RATIFIED · §4 probe M5 fail-open closed · §5 probe drop-box (F-P7b-ac) · §6 send boundary + differential arm · §7 send path (F-P7b-ad) · §8 five deliveries · §9 verify + close"
plan: please-read-the-claude-md-virtual-cocke
head_at_open: 5539033
head_at_close: see this close commit
outward_acts_measured: 5   # all five memo placements, each probe-gated via --exec; fleet-wide find confirms exactly one vault per memo   # memo placements: aDNALabs · aDNA.aDNA · Canvas.aDNA · Forgejo.aDNA · Exchange.aDNA — each probe-gated at the act
token_budget_estimated: ~250k

inbound_at_open: "2 — MEASURED with `git ls-files --others --exclude-standard` (F-DF-145), not `git status`.
  (1) Ilmarinen/`Forgejo.aDNA` → `who/coordination/`: §2 and §4 of our reply SUSTAINED, no refutation;
      but our wide census figure does NOT reproduce — he measures 66/20 where we published 57/17, at
      our OWN commit `b6c070c`, drift and branch-error ruled out. Also files F-F82 against his own
      STEP 3b (a `403` rate-limit read as evidence of privacy, with a green test certifying it).
  (2) Hermes/`Exchange.aDNA` → `who/coordination/inbox/` (our drop-box, first inbound through it):
      D6.4 reproduced from a Codeberg-origin vantage we do not have; a credential-carrying probe of
      THEIRS caught by our own rule; their row measured as a zero somebody took; an ADR-016 naming
      collision fixed on their side only. `ack_required: false`, one offer made.
  ⛔ BOTH arrived AFTER the previous sitting's close sweep recorded `0 NEW`, and BOTH bear on an ADR
  that was one command from signature. Dispositioned by name at §1 before any ratification act."

inbound_at_close: "0 — re-swept at the close end with `git ls-files --others --exclude-standard`. ⚠ THREE arrived DURING this sitting (2 before the open, 1 mid-sitting), all dispositioned by name; F-P7b-ae was filed at the open and paid out within the hour."

leases_at_open: "ours 0 (`how/sessions/active/` held only .gitkeep before this file). Peer leases NOT
  read at open — a send is gated by the probe at send time, and a stale open-time reading is exactly
  what F-P7b-i exists to prevent."

outward: partial        # DECLARED: five memo placements, listed above. NO push to origin (master stays 9+ ahead), NO forge write-call, NO repo created, NO visibility flip, NO .adna/ edit, NO hook installation, NO R8 allowlist.

crash_recovery: "The twenty-fifth sitting closed cleanly — `5539033` carries STATE + CHANGELOG + the
  session file, `how/sessions/active/` held only `.gitkeep`, tree clean but for the two untracked
  inbound. EIGHTH consecutive sitting to open on a clean-or-crash check; this one is clean."

operator_rulings:
  - "scope = INSTRUMENTS FIRST, THEN SEND. Three alternatives offered and DECLINED: instruments-only
    with zero outward; deliveries-first through the existing hand-assembled cp lane; and a
    ratification-only track."
  - "ADR-016 §7.7 = RATIFY, STANDALONE ADR. The ADR-013 Amendment A2 framing that D1 itself offered
    was put to the operator and NOT taken; the framing question is closed, not left hanging."
  - "M1 (the R8-bearing hook is not the installed pre-push hook here) = FILE AS A FINDING, DO NOT FIX.
    Installing the sanitize hook this sitting was offered and DECLINED — a gate installed ahead of its
    allowlist is the enforce-before-ratify interval ADR-013 A1 already had to annotate against itself."
  - "census remedy (second gate, after the divergence was reproduced) = CITE THE INSTRUMENT, NOT THE
    NUMBERS. Three alternatives offered and DECLINED: correcting the figures in place at rev 3;
    ratifying rev 2 as-is and correcting after signature; and holding the signature a third time."
  - "Hermes's offer to carry his §1 Codeberg-vantage result to Venus = YES. Declining a third time,
    and carrying it ourselves as a sixth memo, were both offered and not taken."
  - "outward lane = Berthier · Rosetta · Mondrian, each behind a probe GO. Ilmarinen and Hermes were
    added by the two rulings above, not by the original lane."

declared_files:
  - how/tests/census_public_carriers.sh                    # NEW — promoted from scratchpad (open debt item f)
  - how/tests/check_send_boundary.sh                       # NEW — send-end boundary, R8's predicate file
  - how/tests/send_memo.sh                                 # NEW — the send path (F-P7b-ad)
  - how/tests/probe_peer_state.sh                          # M5 fail-open + drop-box redirect (F-P7b-ac)
  - how/tests/test_sanitize_content_gate.sh                # differential arm (hook vs send checker)
  - what/decisions/adr_016_publication_boundary.md         # rev 3 + §7.7 RATIFIED
  - sanitize_deny_content.txt                              # header: M1 recorded
  - who/coordination/coord_2026_08_27_ilmarinen_to_hopper_your_d6_4_had_a_live_instance_in_our_tree.md   # intake
  - who/coordination/inbox/coord_2026_08_27_hermes_to_hopper_your_census_never_measured_a_codeberg_origin_vault.md  # intake
  - who/coordination/coord_2026_08_27_hopper_to_berthier_codeberg_lane_re_derived_19_of_19.md   # NEW — the oldest open delivery
  - who/coordination/coord_2026_08_27_hopper_to_ilmarinen_your_66_20_reproduces_ours_was_wrong.md  # NEW
  - who/coordination/coord_2026_08_27_hopper_to_hermes_yes_carry_it_to_venus.md                   # NEW
  - who/coordination/coord_2026_08_27_hopper_to_rosetta_your_public_repo_carries_our_forge_address_once.md      # staged -> delivered
  - who/coordination/coord_2026_08_27_hopper_to_mondrian_canvas_is_public_and_carries_the_forge_address_twice.md # staged -> delivered
  - who/coordination/coord_delivery_queue.md
  - STATE.md
  - CHANGELOG.md
  - how/sessions/active/session_stanley_20260827_git_p7b_the_send_path.md   # this file

tags: [session, p7b, send_path, f_p7b_ac, f_p7b_ad, adr_016, ratification, census, dropbox]
last_edited_by: agent_stanley
created: 2026-08-27
updated: 2026-08-27
---

# The Send Path — twenty-sixth sitting

> ⛔ **No literal address in this file** — `<forge-overlay-addr>` throughout. The vault that authored
> the publication boundary does not breach it in the record of ratifying it.

## §1 — Open sweep and intake

Two inbound, both arriving after the previous sitting's close sweep recorded `0 NEW`, and both
bearing on an ADR that was one command from signature. Dispositioned by name below.

⛔ **Finding, filed at the open rather than the close: a close-end sweep reading `0 NEW` is a
statement about an instant, not an interval.** The previous sitting's sweep was correct when taken.
Two memos landed between it and this open — one of them a refutation of a figure in the document
about to be signed. **The window between a close sweep and the next open is unguarded by
construction**, and the cost is not hypothetical: had this sitting opened by executing its approved
plan, ADR-016 would have been ratified carrying a figure a peer had already refuted in writing, in
our own tree, unread.

*(Filed as **F-P7b-ae**. Working remedy: the ratification act specifically re-sweeps immediately
before the signature, the way `--exec` re-probes immediately before the copy. Same defect class as
F-P7b-i — a reading taken once and relied on later.)*

## §2 — The census, third time wrong — and the defect was in the gate

Ilmarinen could not reproduce our `57/17`. He measured **66/20** at **our own published commit**,
ruled out drift and branch error, declined to theorise a cause, and sent the raw per-file table.

**Reproduced here: his figure is right, ours was wrong, and the truth is worse than his correction.**

| predicate | rev 2 said | measured | verdict |
|---|---|---|---|
| narrow (`host:port`) | 31 / 13 | 31 lines · 31 occ · 13 files | ✅ correct |
| **R8 class** | 62 / 20 | 58 lines · **62 occ** · **20 files** | ✅ correct *for the pattern as it then stood* |
| wide (bare host) | **57 / 17** | **66 lines · 70 occ · 20 files** | ⛔ wrong in both figures |

⛔ **F-P7b-af — the guards excluded `.`.** Three mechanisms, each with a minimal reproduction now
serving as a control arm: the trailing guard **consumes the separator** (two occurrences on one line
score 1); a host **preceded by a dot** cannot match; a host **ending a prose sentence** cannot match.

⛔⛔ **And the identical guards shipped in R8's own predicate.** Three files in this tree carry the
address and the gate missed all three — **every one a coordination memo**, which is D3's class
exactly. The gate D5 creates could not have stopped 3 of the 20 files it exists to stop, and it would
have reported green.

⚠ **My own first pass was wrong too, and it is recorded because it is the same class in miniature.**
I suspected §C3's `62/20` and the suspicion was false — I had measured with a bare RFC1918 regex
lacking the deny file's boundary guards, which over-matches. *A result cited for a question its
predicate did not ask*, committed while hunting exactly that.

⇒ The allowlist figure moved **three times in one sitting: 31 → 62 → 75**. The operator ruled the
structural remedy: **cite the instrument, not the numbers.**

## §3 — What was built

| instrument | closes | control |
|---|---|---|
| `census_public_carriers.sh` **promoted** | debt item (f) | `--meta`, 14 arms |
| `probe_peer_state.sh` — `writedir_git_count` | **F-P7b-ah** | `DBX`, exact-token |
| `probe_peer_state.sh` — drop-box redirect | **F-P7b-ac** | 22 arms, 57 total |
| `check_send_boundary.sh` | **F-P7b-ad** (i) | `--meta`, 14 arms |
| differential arm | the sameness claim | `agreed=10/10` |
| `send_memo.sh` | **F-P7b-ad** | `--meta`, 28 arms |

## §4 — ⛔ Four fail-opens, three of them inside the arms written to catch that class

1. **F-P7b-ah** — git's exit status discarded, 100 lines above the comment forbidding it. ⭐ The arm
   was **unreachable**: no fixture in the harness was ever a non-git directory.
2. **F-P7b-aj** — the content-gate harness carried a **hand-typed copy** of the deny pattern and
   **stayed green about the wrong pattern** through F-P7b-af's repair.
3. **F-P7b-ak** — `--dry-run` **stamped five real memos `delivered` while copying nothing.** The
   exact class the program exists to close, in the one mode whose whole promise is that it changes
   nothing. The meta arm asserted *copied nothing* and never *stamped nothing*.
4. The census sentinel — an "unmatchable" pattern written as a literal into the script that greps
   the vault, so it **matched its own source** and reported a dead predicate alive.

## §5 — F-P7b-ae paid out within the hour of being filed

Filed at this sitting's **open**: *a close-end sweep reading `0 NEW` is a statement about an instant,
not an interval.* Two memos had landed since the last close; a **third landed mid-sitting** and was
caught only because the re-sweep was placed immediately before the signature.

⛩ **Had this sitting executed its approved plan directly, ADR-016 would have been ratified carrying a
figure a peer had already refuted — in our own tree, unread.**

## §6 — Deliveries: 5 of 5, and the queue is empty

Verified per delivery: recipient copy reads `status: delivered` (⭐ the drift's exact inverse) · 0/1
`delivered_md5` field/retained · delta exactly one line · fleet-wide `find` = one vault each ·
boundary CLEAN against a live control.

⛔ The two drifted copies in `Forgejo.aDNA` **stay as they are** — under D6.1 the repair is not ours
to make in his tree.

## §7 — Verification

| # | check | result |
|---|---|---|
| 1 | `probe_peer_state.sh --meta` | **57 arms, 0 FAIL** |
| 2 | `check_send_boundary.sh --meta` | **14 arms, 0 FAIL** |
| 3 | `test_sanitize_content_gate.sh` | **22/22**, `agreed=10/10` |
| 4 | `send_memo.sh --meta` | **28 arms, 0 FAIL** |
| 5 | boundary on every artifact | CLEAN, against a control that REFUSES |
| 6 | fleet-wide `find` per memo | exactly 1 vault each |
| 7 | ADR-016 self-check | 0 literal addresses |
| 8 | deny file self-check | 0 (caught 1 breach I introduced, in its own header) |

## §8 — AAR

- **Worked** — putting the instruments before the sends. Every one of the four fail-opens was found by
  a control built minutes earlier, and F-P7b-ak was caught *because* the send path ran on real memos
  before they were committed.
- **Didn't** — my first pass mis-attributed the R8 misses to the prose-period mechanism when the live
  cause was the *leading* guard, and I nearly wrote that into a memo. Measuring the actual match
  context, rather than reasoning from the fixture, was what corrected it.
- **Finding** — ⭐ **the sitting's own shape is the finding**: an instrument, its control, and its
  documentation all failed in the same direction, repeatedly, and each time the thing that caught it
  was a *paired arm asserting the opposite*. Sabotage arms alone went green throughout.
- **Change** — ADR-016 now cites a runnable instrument instead of transcribing figures; the send path
  stamps before the copy; the probe understands an open lane.
- **Follow-up** — the R8 allowlist against the repaired predicate; upstream 4.1.0 + the pattern fix to
  Rosetta; F-P7b-z now has **three** measured instances; F-P7b-ai and F-P7b-ag stay filed-not-fixed.
