---
type: session
session_id: session_stanley_20260826_git_p7b_the_boundary_with_no_predicate
date: 2026-08-26        # twenty-fourth sitting (FIRST on this local date). Act timestamps UTC.
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — the publication boundary had no predicate, and the class-sweep gates this sitting's own send"
door: "§1 open sweep · §2 intake 2 inbound · §3 rule F-F78 Q1–Q3 · §4 ADR-016 (proposed) · §5 R8 content deny-list · §6 class-sweep F-P7b-w · §7 memo + delivery · §8 verify · §9 close"
plan: please-read-the-claude-md-elegant-popcorn
head_at_open: 2e1d323
head_at_close: see tracking commit (this sitting)
outward_acts_measured: 0   # gate REFUSED on a real BLOCK; --exec suppressed; fleet-wide find confirms nothing placed outside Git.aDNA
token_budget_estimated: ~180k
inbound_at_open: "2 — MEASURED with `git ls-files --others --exclude-standard`, not `git status` (F-DF-145). (1) Ilmarinen/`Forgejo` — F-F78, `Git.aDNA` is public and carries the R&D instance address; (2) Galileo/`Jupyter` — F-DF-221 conceded to our F-P7b-y, two items left. Both `ack_required: false`. ⚠ The SECOND arrived DURING plan mode, after the planning sweep had already counted one — recorded because it is the read-at-the-act rule paying for itself inside a single sitting."
inbound_at_close: "0 NEW — re-swept at the close end with `git ls-files --others --exclude-standard`. The 7 untracked paths are this sitting's own products (5) plus the 2 inbound already dispositioned at §2. ⛩ Breaks the pattern of the last several sittings, where mail arrived mid-session — but note the SECOND inbound arrived during PLAN MODE, so the sitting still took delivery of something after its first sweep."
leases_at_open: "ours 0 (`how/sessions/active/` held only .gitkeep before this file). Peer leases read at open FOR RECORD ONLY (Forgejo 0, Jupyter 0) and NOT relied upon — the send this sitting is gated at the act, in the same command as the act (F-P7b-i)."
outward: partial        # DECLARED: at most ONE act — a reply memo into Forgejo.aDNA/who/coordination/, gated by the REPAIRED probe. NO push, NO forge call, NO repo created, NO visibility flip, NO .adna/ edit. Berthier's Codeberg 19/19 memo stays STAGED — unsent by ruling for a THIRD consecutive sitting.
crash_recovery: "The twenty-third sitting crashed after its close commit. VERIFIED, not assumed — SIXTH consecutive sitting to open this way: `2e1d323` is a session-close commit carrying STATE + CHANGELOG + the session file already in `history/2026-08/`; `how/sessions/active/` held only `.gitkeep`; the only untracked paths are the two inbound."

operator_rulings:
  - "scope = the publication boundary AND the owed class-sweep, together. Boundary-only was offered and declined; class-sweep-only and the Berthier delivery were offered and declined. The two turned out not to be independent: the class-sweep's live hit is the gate on this sitting's own outward act. (AskUserQuestion, plan gate)"
  - "remedy posture on the 31 published occurrences = FIX-FORWARD ONLY. No content edit, no history rewrite. Three alternatives offered and NOT taken: a structural split of the published tree (correspondence + session history out of the public repo), flipping Git.aDNA private (reverses ADR-013 D3), and history rewrite + force-push. The structural split is recorded as considered-and-deferred WITH its cost, not silently dropped."
  - "outward lane = ILMARINEN ONLY. A second send to Venus (fleet exposure census — she owns topology and exposure) was offered and DECLINED; the Berthier Codeberg 19/19 memo was offered and DECLINED ⇒ it remains OWED and STAGED, unsent by ruling for a third consecutive sitting."

declared_paths:
  - who/coordination/coord_2026_08_26_ilmarinen_to_hopper_git_adna_is_public_and_carries_the_instance.md   # intake
  - who/coordination/coord_2026_08_27_galileo_to_hopper_f_df_221_is_your_f_p7b_y.md                        # intake
  - what/decisions/adr_016_publication_boundary.md       # NEW — proposed, NOT accepted; §7.7 packet at close
  - how/standard/hooks/pre-push-sanitize.sh              # R8 content deny-list — ONLY after the .adna/ drift check
  - sanitize_deny_content.txt                            # NEW — the pattern file R8 reads
  - how/tests/probe_peer_state.sh                        # lease-surface resolution + PASS_INFERRED + outbound fixture arm
  - how/tests/test_sanitize_content_gate.sh              # NEW — R7/R8 end-to-end arms; R7's first exercise ever
  - who/coordination/coord_2026_08_26_hopper_to_ilmarinen_the_boundary_had_no_predicate.md
    # ⛔ authored and STAGED, NOT delivered — the gate REFUSED on a real BLOCK (staged work in the
    #   recipient's coordination surface). The declared "one outward act" did not occur; this sitting
    #   is NON-OUTWARD in fact. Recorded as a correction to the `outward: partial` declaration above
    #   rather than by editing it, so the intent and the outcome both stay legible.
  - STATE.md
  - CHANGELOG.md
  - how/sessions/active/ → how/sessions/history/2026-08/

why_this_sitting: |
  A peer measured this vault from outside and found that `aDNA-Network/Git.aDNA` — public since the
  R1/P5 beachhead, by ratified decision (ADR-013 D3) — carries the R&D forge's mesh overlay address
  31 times across 13 files. He filed F-F78, held two of his own rows back on that basis, and then
  declined to prescribe the remedy: seven of the thirty-one occurrences arrived in his own memos to
  us, and under Rule 10 he does not write in our tree.

  The `gitleaks` A1 gate passes these repos correctly, because there are no secrets in them. That is
  the finding, not an excuse for it: the rule governing the decision is a PUBLICATION-BOUNDARY rule —
  about what a public repo may contain — and ADR-013 D1–D7 classify repos by host and visibility with
  no content axis at all. The predicate was never absent from the check. It was absent from the
  doctrine, so there was nothing for a check to evaluate.

  ⭐ The reason to run tonight is that the two halves of this sitting turned out to be one thing. The
  owed class-sweep (F-P7b-w — an instrument that hardcodes a fleet-variable path) lands on
  `probe_peer_state.sh`'s lease checks, which assume `how/sessions/active`; `Forgejo.aDNA` is one of
  the 23 vaults of 97 that do not have it. The one delivery this sitting is authorized to make is
  gated by an instrument that cannot currently say GO to its recipient — for a reason that has
  nothing to do with the recipient's state.

# ---------------------------------------------------------------------------
# §1 — Open sweep (recorded at open; provisional by construction)
# ---------------------------------------------------------------------------

- HEAD `2e1d323` — a session-close commit (STATE + CHANGELOG + prior session file already filed).
- `how/sessions/active/` — `.gitkeep` only. No stale lease.
- Working tree clean but for **2 untracked inbound**, both in `who/coordination/`.
- Drop-box `who/coordination/inbox/` — 5 memos, all **tracked** ⇒ previously dispositioned. 0 new.
- Peer leases (record only, not relied on): `Forgejo.aDNA` 0, `Jupyter.aDNA` 0.

⚠ **The second inbound arrived mid-plan-mode.** The planning sweep counted one; the open sweep, run
at the act, counted two. Recorded because it is a live instance of the both-ends discipline
(F-P7b-i) rather than a hypothetical one: a reading taken at plan time was already stale by the time
the work started, inside a single sitting.

# ---------------------------------------------------------------------------
# §2 — Findings opened this sitting
# ---------------------------------------------------------------------------

## ⛔ F-P7b-z — the publication gate's self-test does not test the gate

`pre-push-sanitize.sh --self-test` **reimplements R1–R6** as an inline scan over a fixtures directory
and never enters the push-time code path. Consequence, measured: **R7 — an operator-facing deny list
shipped in `.adna/` — has never once been exercised** in its entire shipped life, and R8 would have
inherited exactly that on the day it was written.

⭐ **This is F-P7b-x's class a fourth time, and the first time in the *template's* code rather than
one of ours**: a control that validates a reimplementation agrees with itself. A green `--self-test`
is evidence about the fixture scanner, not about the hook.

⇒ Repaired by building `how/tests/test_sanitize_content_gate.sh` — 12 arms, every one driving the real
path (real repo, real githooks(5) stdin, real range computation, real Decision block). R7's three arms
are its **first exercise**; they pass, which was luck rather than verification.

## ⛔ F-P7b-aa — the lease surface failed UNINFORMATIVE, not open, and one population was served right by accident

`probe_peer_state.sh` hardcoded `how/sessions/active` in both lease checks (lines 251, 273).
⛔ **Calling this a fail-open would be wrong** — it returned `UNKNOWN`, which under UNKNOWN-never-PASS
refuses. It was fail-closed and safe. It failed *uninformative*: it could never return anything but
`UNKNOWN` for 23 of 97 fleet vaults, so the gate could not say GO to a quarter of the fleet for a
reason about **our path assumption** rather than the peer's state.

The 23 are **two populations**, and the old code was accidentally right about one:

| population | n | old verdict | correct verdict |
|---|---|---|---|
| `active/` present | 74 | PASS (read) | unchanged |
| `history/` present, no `active/` — same convention, empty dir | **15** | UNKNOWN | **PASS_INFERRED** — absence is positive evidence |
| no session layout at all | 8 | UNKNOWN | UNKNOWN — **right, for a reason never named** |

⭐ **`Forgejo.aDNA` is one of the 15** — every lease reading this desk has taken of the peer it
corresponds with most has been structurally uninformative. And this retro-explains last sitting's
`operations_stanley UNKNOWN→REFUSE`, recorded then as the repair working: it *was* right, and for the
other population's reason.

⛩ **The sting: a sibling instrument on this desk already had it right.** `census_wrapper_copy.sh`
classifies "no wrapper dir at all" as its own outcome with its own exit code and a comment on why
conflating it with the adjacent case would be wrong. **F-P7b-w's lesson pointing the other way** — not
a fix that failed to generalise, but a correct pattern that was never propagated in the first place.

## ⚠ F-P7b-ab — I clobbered my own exit code twice in one sitting, both times reassuringly

1. **Through a pipe.** `bash test.sh | grep …; echo $?` reported `0` on a run with 4 RED arms — the
   exit of `grep`. ⛔ Committed **inside the command verifying the test file whose own header warns
   against exactly this**, and it is the third instance on this desk.
2. **Through a command substitution.** `printf '%s %s' "$(basename "$t")" "$?"` — the substitution runs
   during argument expansion and sets `$?` before it is read. Reported **`exit=0` for five probe runs
   that all actually exited 3**.

⛩ Same family, new mechanism: the first is a pipeline's last stage, the second is expansion order.
Both printed the reassuring answer. The rule that survives both: **capture on its own line, then read.**

# ---------------------------------------------------------------------------
# §3 — Verification (measured, not asserted)
# ---------------------------------------------------------------------------

| check | result |
|---|---|
| F-F78 reproduction at `b6c070c` | **31 occurrences / 13 files** — matches Ilmarinen exactly |
| address class | first octet `10` ⇒ RFC1918; **0** publicly-routable |
| Q2 sweep of the 13 files | **0** keys · **0** tokens · **0** `ssh user@host`; 2 hosts + 3 ports |
| fleet reciprocal | `Git.aDNA` the **only** public carrier; Codeberg pair **404 anonymous** (measured) |
| `test_sanitize_content_gate.sh` | **12/12 GREEN**, exit 0 by capture |
| … regression vs 4.0.1 | **4 RED of 12** — the 8 green are all `expect rc=0` arms that cannot discriminate |
| `probe_peer_state.sh --meta` | **37/37 GREEN**, exit 0 by capture |
| … regression vs pre-repair | **3 RED** (T, T′, V) of 8 new arms — 5 cannot discriminate, stated |
| live re-measure, 3 populations | `Forgejo` UNKNOWN→**PASS~** · `Jupyter` **PASS** · `Operations`/`operations_stanley`/`wga` **UNKNOWN** |
| hook restore after regression | md5 identical, verified |
| close-end inbound re-sweep | **0 new** |
| **outward acts** | ⛔ **ZERO.** Gate REFUSED, `--exec` suppressed, no file placed. Fleet-wide `find` confirms nothing placed outside `Git.aDNA`. Zero pushes · zero forge calls · zero repos created · zero visibility flips · zero `.adna/` edits. |

# ---------------------------------------------------------------------------
# §4 — AAR
# ---------------------------------------------------------------------------

- **Worked** — verifying the peer at source rather than adopting his summary reproduced his numbers
  *and* widened them by a row (2 hosts, 3 ports). Measuring the fleet reciprocal turned a worry into a
  negative result worth sending. The class-sweep, run before the delivery it was meant to enable,
  made a refusal legible instead of leaving three rows of it unexplained.
- **Didn't** — the delivery. The gate refused on a real BLOCK and the memo is staged. Berthier's
  Codeberg 19/19 is now unsent by ruling for a **third** sitting. Two of my own measurements
  misreported (F-P7b-ab), both reassuringly, one of them inside the command verifying the file whose
  header warns against it.
- **Finding** — the boundary rule had no predicate in the doctrine, so no instrument could evaluate
  one; and when an instrument *was* found (R7), it turned out to match paths, not content, and to have
  never been tested. Two absences stacked: a rule nobody wrote, and a gate nobody ran.
- **Change** — ADR-016 authored (`proposed`); R8 + its 12-arm end-to-end harness; lease-surface
  resolution with `PASS_INFERRED`; Galileo's outbound-staging arm; hook declared at 4.1.0 ahead of
  `.adna/`.
- **Follow-up** — (a) ADR-016 §7.7 ratification, and **only then** the R8 allowlist decision that lets
  it be installed; (b) the Ilmarinen memo, staged, retry when his surface is quiet; (c) Berthier's
  Codeberg 19/19, third sitting owed; (d) upstream 4.1.0 to Rosetta, which closes the declared drift;
  (e) F-P7b-z's wider question — what else in `.adna/` has a self-test that reimplements rather than
  drives; (f) the structural-split option, deferred not rejected.

# ---------------------------------------------------------------------------
# §5 — SITREP / next session
# ---------------------------------------------------------------------------

**Resume-Here = R3/P7b.** The publication boundary now has a doctrine (`proposed`) and an instrument
(uninstalled, by design). Nothing outward fired. Next sitting opens with **two staged deliveries owed**
— Ilmarinen (this sitting's, gate-refused) and Berthier (third sitting) — and the ADR-016 ratification
packet on the table.

