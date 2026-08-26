---
type: session
session_id: session_stanley_20260825_git_p7b_the_check_that_measured_the_wrong_mailbox
date: 2026-08-25        # twenty-third sitting (FIRST on this local date). Act timestamps UTC.
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — a peer files a defect against our send gate, and verifying it finds a second one in the same check"
door: "§1 open sweep · §2 intake both inbound · §3 repair check_own_inbound · §4 extend --meta · §5 doctrine · §6 findings · §7 memo + delivery · §8 verify · §9 close"
plan: please-read-the-claude-md-stateless-salamander
head_at_open: 5acf73a
head_at_close: see tracking commit (this sitting)
inbound_at_open: "2 — MEASURED with `git ls-files --others --exclude-standard`, not `git status` (F-DF-145: the default form collapses an all-untracked directory to one line, and one of the two sits in the drop-box `who/coordination/inbox/`). (1) Galileo/Jupyter — F-DF-215 against `probe_peer_state.sh`; (2) Ilmarinen/Forgejo — M10 upgrade-window close report (cc). Both `ack_required: false`."
inbound_at_close: "0 NEW — re-swept with `git ls-files --others --exclude-standard` at the close end. The one untracked file in who/coordination/ is OUR OWN outbound memo, not inbound; ⚠ and the repaired check called it \"untracked inbound\" until F-P7b-y was filed against that wording at this very sweep. ⭐ Breaks a two-sitting streak of mid-sitting live delivery — recorded because a streak ending is as much a measurement as a streak continuing."
leases_at_open: "ours 0 (`how/sessions/active/` held only .gitkeep before this file). Peer leases deliberately UNPROBED at open — probing them here would produce exactly the stale reading F-P7b-i is about. The one delivery this sitting is gated at the act, in the same command as the act."
outward: partial        # DECLARED: exactly ONE act — the Galileo memo drop into Jupyter.aDNA/who/coordination/, gated by probe --exec. NO push, NO forge call, NO repo created, NO visibility flip, NO .adna/ edit. Berthier's Codeberg memo stays STAGED by last sitting's ruling.
crash_recovery: "The twenty-second sitting crashed after its close commit. VERIFIED, not assumed — FIFTH consecutive sitting to open this way, and the check stays ritual because it is cheap: `5acf73a` is a session-close commit carrying STATE + CHANGELOG + the session file already in `history/2026-08/`; `how/sessions/active/` held only `.gitkeep`; the only untracked paths are the two inbound. The crash cost the conversation, not the vault."

operator_rulings:
  - "fix shape for F-DF-215 = Galileo's shapes 2+3 COMBINED — refuse without `--self`, AND name the vault in the output. Shape 1 (default to $PWD's vault) was offered and DECLINED: it replaces one silent default with another, and a silent default is the fail-open class this vault has filed repeatedly. Shape 3 alone was offered and declined as insufficient — it makes a wrong reading visible without correcting it. (AskUserQuestion, plan gate)"
  - "disposition of the SECOND defect (ours, F-P7b-w) = RESOLVE THE SURFACE, and return UNKNOWN — never PASS — when no coordination surface is found. Two alternatives offered and not taken: resolve-but-PASS-if-none (preserves a fail-open for the one vault measured to have no surface), and file-without-patching (leaves WGS's undispositioned inbound invisible to the gate meanwhile)."
  - "outward lane = GALILEO ONLY. The Berthier Codeberg 19/19 memo was offered as a second drop and DECLINED ⇒ it remains OWED and STAGED, unsent by ruling for a second consecutive sitting, and is recorded that way rather than quietly dropped."

declared_paths:
  - how/tests/probe_peer_state.sh                        # check_own_inbound repaired (both fail-opens) + --meta extended with
                                                         #   FULL-PROCESS arms. The `ls-files --others --exclude-standard`
                                                         #   call is NOT touched — its header records that its F-DF-145
                                                         #   immunity is ACCIDENTAL and survives only until someone
                                                         #   refactors it to the obvious `git status` idiom.
  - how/sessions/AGENTS.md                               # the both-ends doctrine table hardcodes who/coordination/ — the SAME
                                                         #   defect one level up, in the doctrine binding every session.
  - who/coordination/inbox/                              # Galileo's memo intaken (tracked, not moved — the drop-box is where
                                                         #   he addressed it and provenance is the point)
  - who/coordination/coord_2026_08_24_ilmarinen_to_consumers_upgrade_window_close_report.md
  - who/coordination/coord_2026_08_25_hopper_to_galileo_the_second_defect_in_the_check_you_filed.md   # NEW — the one outward act
  - STATE.md
  - CHANGELOG.md
  - how/sessions/active/ → how/sessions/history/2026-08/

why_this_sitting: |
  A peer filed a defect against an instrument this vault ships and other vaults call as a send gate.
  That is the first time that has happened to `probe_peer_state.sh`, and the memo is careful in a way
  that makes it cheap to act on: Galileo routed rather than patched (Rule 10), wrote nothing into our
  tree, delivered on a corrected reading rather than the defective one, and stated in §4 that the fix
  shape is ours to choose.

  Verifying his claim at source — this vault does not adopt a peer's summary — confirmed it exactly,
  and turned up a SECOND fail-open in the same check that his memo does not name and his proposed
  fixes do not close. The check hardcodes `who/coordination/`, and F-P7b-n — documented in this very
  file, one check above — already established that fleet coordination surfaces differ. `WGS.aDNA`
  holds one of OUR memos undispositioned in `who/comms/` right now, and the check reports PASS for it.

  ⭐ The reason to run tonight is not that one peer's send gate misreported. It is that the defect
  Galileo found and the defect he did not are the same defect wearing two hats — an implicit argument
  nobody passes and an implicit path nobody checks — and both survived a meta-control that injects the
  very flag a real caller omits.

# ---------------------------------------------------------------------------
# §1 — Open sweep (recorded at open; provisional by construction)
# ---------------------------------------------------------------------------
open_sweep:
  head: 5acf73a
  tree: "clean apart from the 2 untracked inbound"
  active_leases_ours: 0
  probed_at: 2026-08-26T05:51:48Z

# ---------------------------------------------------------------------------
# §2 — Verified at source BEFORE planning (Galileo's claim)
# ---------------------------------------------------------------------------
verification_at_source:
  - "line 100  SELF_VAULT=\"$(cd \"$HERE/../..\" && pwd)\"  — defaults to the SCRIPT's repo — ✅ exact"
  - "line 343  check_own_inbound \"$SELF_VAULT\"  — the only check not taking --target — ✅ exact"
  - "line 110  --self exists but is silently defaulted — ✅ exact"
  - "fail-open mechanism: a caller with a dirty box reads PASS whenever OURS is clean — ✅ confirmed"
  - "lines 459/464: the two full-process --meta arms pass --self \"$d\" EXPLICITLY; every other arm calls the check function directly, bypassing argument parsing entirely ⇒ the default arm is NEVER exercised — ✅ confirmed"

# ---------------------------------------------------------------------------
# §3 — The second defect, measured live (ours, not Galileo's)
# ---------------------------------------------------------------------------
second_defect_measurement:
  method: "replicated check_own_inbound's exact command per candidate caller; read-only"
  probed_at: 2026-08-26T05:51:48Z
  rows:
    - "WGS.aDNA            who/coordination/ -> 0   |  who/comms/ -> 1 undispositioned inbound (OURS: coord_2026_08_24_hopper_to_wgs_you_wrote_my_repair_before_i_did.md)"
    - "operations_stanley.aDNA   no coordination surface at all -> would read 0 -> PASS"
    - "Jupyter.aDNA        who/coordination/ -> 0"
    - "Git.aDNA            who/coordination/ -> 2   (this sitting's own inbound — the check measures US correctly)"
  consequence: "the check reports PASS for WGS *even with --self passed correctly*. Galileo's shapes 1 and 2 do not close this; shape 3 makes it visible but not correct."
---

# Session — the check that measured the wrong mailbox, and then the wrong drawer

## SITREP

**Scope executed as gated.** A peer's finding against our shipped send gate, confirmed at source,
ruled, fixed — and the verification turned up a second fail-open in the same check, plus a third
wording defect found by running the repaired instrument on ourselves at the close sweep.

### What was done

| # | Act | Result |
|---|---|---|
| 1 | Intake 2 inbound by name | `bfb7155`. Galileo (F-DF-215) left in `inbox/` — the drop-box is where he addressed it and provenance is the point. Ilmarinen's close report filed; its Pandora/Venus content is other lanes' and NOT ruled on. |
| 2 | `check_own_inbound` repaired | `--self` mandatory (BLOCK if absent) · non-git `--self` refused (`-e` not `-d`) · surface RESOLVED (`who/coordination` → `who/comms`, both where both exist) · `UNKNOWN` never `PASS` when no surface · every row NAMES vault + surface. |
| 3 | `--meta` extended | **19 → 28 arms**, incl. 3 **full-process** arms that run the script through argument parsing. |
| 4 | Regression proved | **8 of 9 new arms RED** on pre-repair behaviour; 19 pre-existing arms unchanged and green. |
| 5 | Doctrine corrected | `how/sessions/AGENTS.md` — the both-ends table hardcoded the same path, one level up, in the text binding every session. |
| 6 | Memo delivered | 1 outward act, through the repaired probe, `--exec`, `cmp` IDENTICAL. |

### ⭐⭐ The finding that is the actual finding

Re-run against pre-repair behaviour, **all eight failing arms returned the identical row**:

```
  PASS    own_inbound    no undispositioned inbound here
```

No `--self` · `--self` at a nonexistent path · `--self` at a non-git directory · inbound in
`who/comms/` · no coordination surface at all. **Eight distinct wrong states, one reassuring answer.**
⛩ The defect was never that the check answered *wrongly* — it is that it answered **identically
regardless of what it was pointed at**, which from outside is indistinguishable from working.

⚠ **The one new arm that stayed green on the broken code** is `--self` given, surface
`who/coordination/`, box clean → `PASS`. That is the correct-caller-correct-shape case — **precisely
the configuration Galileo's §3 caught the two arms agreeing on.** The only case that cannot
discriminate is the one everybody tests.

### ⛔ Findings filed

- **F-P7b-w** — the hardcoded-surface fail-open. `WGS.aDNA` was holding **one of our own memos**
  undispositioned in `who/comms/` and the check read `PASS` **even with `--self` passed correctly**.
  ⭐ **F-P7b-n, ~130 lines above the defect IN THE SAME FILE**, had already established that surfaces
  differ; it was fixed at its instance and never swept to its class. **Third time this desk has earned
  its own sentence** — *a finding closed at its instance is not a finding closed* (cf. F-Astro,
  F-P7b-b). The sweep is one command. We keep not running it.
- **F-P7b-x** — the meta-control gap. Every arm either called the check as a **function** with the
  vault passed by hand, or invoked the script with `--self "$d"` **explicitly** (lines 459/464). ⇒ the
  harness supplied, in every arm, **the argument a real caller omits**; `SELF_VAULT`'s default was
  never once exercised by the instrument built to exercise this script. ⭐ **This is Galileo's own §5
  clause (F-DF-178 — *a validation is incomplete without the paired arm*) landing on our instrument**
  rather than on the hook he wrote it about.
- **F-P7b-y** — found at our OWN close sweep, by running the repaired instrument on ourselves: the row
  said *"untracked inbound"* while counting **this desk's own queued outbound**. Gates nothing (WARN).
  ⛩ But it is the exact class this sitting is about — a row asserting more than its measurement
  supports — **found in the row rewritten to fix that class, minutes after the memo arguing it went out.**

### ⚠ Instrument misreports by this desk tonight (~~2~~ **3**, all caught by reading the output)

> ⛩ **Corrected after this section was first written, and struck rather than rewritten.** It said
> **2**. The third arrived at the verification pass, *after* the SITREP had been drafted — which is
> itself the point: **a count of one's own errors is a measurement with a shelf life too**, and this
> one expired inside the same sitting that took it.

1. `printf 'exit: %s' $?` **after a pipe to `tail`** — measured `tail`'s status, reported the probe
   exiting **0** on a REFUSE. Re-measured by capturing first: **3**, correct. ⛩ This is *verbatim* the
   defect this desk filed on 2026-08-24 and wrote a comment about **inside the function repaired
   tonight** — committed again, in the same sitting, while quoting it.
2. `find -newermt "2026-08-26 05:50"` for the outward-acts sweep — `find` parses **local** time and the
   string was **UTC**, so the query asked for the future and returned **nothing**. ⭐ A zero that meant
   *"no files placed outside this vault"* and actually meant *"the question was malformed"* — an empty
   result read as a clean result, the reassuring direction again (cf. F-P7b-v). Re-run in local time:
   exactly **1** file, the memo, by name.
3. ⛔ **A −6 CENSUS REGRESSION THAT DOES NOT EXIST.** `census_secret_gate` was counted with
   `grep -c 'aDNA'` on the **summary** format and compared against a baseline taken from **TSV** —
   two different output shapes, and the pattern is **case-sensitive**, so `.adna`, the `adna-lab-*`
   worktrees, the `latlab-*` repos and `llama.cpp` were all invisible to it. It read **121** against
   a baseline of **127** and I was one step from reporting a fleet regression. ⭐ **Settled by the
   remedy built for exactly this last sitting (F-P7b-u): population diffed as a SET BY NAME —
   127 = 127, 0 added, 0 removed.** ⛩ Same family as last sitting's *"129 repos REMOVED"*
   (`--format=tsv` vs `--format tsv`): **both times the instrument was fine and the harness reading
   it was not.** ⚠ And `census_wrapper_copy`'s **61** was counted the same wrong way and happened to
   be **right** — every wrapper-carrying vault is a `.aDNA`. **Re-derived properly before being
   believed**, because a number that is right by luck is not a measurement.

### ⭐ Concurrency observed, recorded not acted on

`Jupyter.aDNA/STATE.md` was modified **22:55:37 PDT**; our probe read it **22:58:33 PDT** with
`0 file(s), 0 live` leases. Galileo closed a sitting ~3 minutes before our delivery landed. The probe's
reading was correct **at the act**, which is the whole design. ⛩ Third consecutive sitting where a peer's
state changed within minutes of ours — the shelf life of a fleet reading keeps measuring in minutes.

⭐ **And after delivery `Jupyter.aDNA` reads `WARN 1`** — that is our own memo, now untracked in his
box. The instrument reporting our own act back to us.

### Verification

- `--meta` **28/28 green**, exit 0 · every check reached its failure state · controls passed ·
  `--exec` gates both ways · **the new no-`--self` arm BLOCKs and suppresses `--exec`**.
- **Regression**: 8/9 new arms RED against pre-repair; 19 pre-existing green. Green proved nothing
  until it was made red.
- **Live re-measure**: `WGS` `WARN 1 (who/comms/)` where it read `PASS` · `operations_stanley`
  `UNKNOWN → REFUSE` · `Jupyter` `PASS` pre-delivery, `WARN 1` post · `Git.aDNA` its true count.
- Real exit codes measured **by capture, never through a pipe**: no-`--self` **3**, UNKNOWN **3**.
- **Close-end sweep: 0 new inbound.** The 1 untracked is our own outbound (F-P7b-y).
- **Outward acts, BY NAME: exactly 1** — `coord_2026_08_25_hopper_to_galileo_…` → `Jupyter.aDNA/who/coordination/`,
  `cmp` IDENTICAL, stamped before the copy. Fleet-wide `find` confirms no other file placed by this
  desk outside `Git.aDNA`. **Zero pushes · zero forge calls · zero repos created · zero visibility
  flips · zero `.adna/` edits · Berthier's Codeberg memo still STAGED by ruling.**

## AAR (Standing Order #5)

| | |
|---|---|
| **Worked** | Verifying a peer's finding at source rather than adopting the summary — it confirmed his claim *and* exposed a second defect he could not have seen from his vantage. Proving the new control red before trusting it green; the 8-identical-rows result is the sitting's whole thesis and only the regression could produce it. |
| **Didn't** | Two of this desk's own measurements misreported — a pipeline exit code and a timezone-malformed `find` — **both returning reassuring values**, and one of them is the exact defect documented inside the function being repaired. Neither was caught by design; both were caught by reading output that looked wrong. |
| **Finding** | ⭐ **F-P7b-w's real lesson is not the fail-open, it is the geography**: the assumption sat **130 lines below the comment describing why it was wrong**, in the same file, for a month. A finding fixed at its instance does not propagate by proximity. **F-P7b-x is the second half**: the control could not catch it because the control passed the argument callers omit — a harness that constructs its own inputs will construct the ones that work. |
| **Change** | `--self` mandatory + surface resolved + UNKNOWN-never-PASS; `--meta` 19→28 with full-process arms; doctrine corrected at `AGENTS.md`. **Rule taken: an arm that calls a check as a function cannot test the argument block, and the argument block is a defect surface.** |
| **Follow-up** | Sweep F-P7b-w's class properly rather than at its instance — `census_wrapper_copy.sh` / `census_secret_gate.sh` / `preflight_context_sync` should each be checked for a hardcoded `who/coordination`. Galileo's F-DF-178 clauses for A2 §4 remain **open and carried**, ruled to their own §7.7 gate rather than ridden in on this sitting. Berthier's Codeberg 19/19 memo **still owed, still staged**, unsent by ruling a second consecutive sitting. |

## Next Session Prompt

> Read the CLAUDE.md and continue `campaign_git_genesis` P7b. **Debts, ranked:** (a) ⛔ the Codeberg
> 19/19 result is **owed to Berthier** and has now been unsent-by-ruling for two sittings — it is the
> oldest open delivery; (b) **sweep F-P7b-w's class** across the other instruments (`census_wrapper_copy`,
> `census_secret_gate`, `preflight_context_sync`) rather than at its instance — this sitting's own
> follow-up, and the third time the class-sweep has been the finding; (c) §8.5 token-scope — a fleet
> census must state its enumeration's SOURCE OF TRUTH and its VISIBILITY SCOPE; (d) the drop-box as a
> FLEET ruling (III's 11 unintaken memos); (e) the `census_secret_gate.sh` mechanism port deferred by
> A7 §5; (f) ⭐ the P7a flip remains the critical path and every open precondition is another lane's;
> (g) the ADR-011 consolidation reading — eight layers; (h) shape B at the D4 revisit; (i) obj 5;
> (j) the fleet host-move wave; (k) the 9-row repoint runbook; (l) intake-log + CHANGELOG backfills.
