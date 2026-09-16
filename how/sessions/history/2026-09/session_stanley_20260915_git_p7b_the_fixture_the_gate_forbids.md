---
type: session
session_id: session_stanley_20260915_git_p7b_the_fixture_the_gate_forbids
date: 2026-09-15        # thirty-second sitting. Act timestamps UTC.
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — the fixture set froze on the day the gate started working"
door: "§1 open + lease + baseline md5 · §2 rule the FAIL-fixture question (R3+R5 together) · §3 author the R5 pair + R3 fixture, trap reproduced first · §4 demonstrate RED against the 4.0.1 predicate before trusting · §5 true the coverage table · §6 intake 3 inbound + correct the stale `.adna/` 4.0.1 facts · §7 rule Ilmarinen's A8 §6 breadth · §8 F-P7b-bg + route · §9 STATE + close"
plan: please-read-the-claude-md-enchanted-noodle
head_at_open: c38d46e
head_at_close: this close commit
outward_acts_planned: 0   # no memo staged at open; a push, if any, is its own gate
token_budget_estimated: ~160k

lease: "how/sessions/active/ held only .gitkeep at open — no peer writer. Checked BEFORE the first edit."

baseline_md5:
  how/standard/hooks/pre-push-sanitize.sh: 5f94765e79d4e857fc9726967f158b31
  how/standard/hooks/test_fixtures/README.md: fbbf826c623fd3145bc3c926b4e0c977
  how/tests/test_sanitize_content_gate.sh: dc6dd65cc7ba20483b66b6009b26d42e
  .gitignore: e4c422681acdf52f453f35f0c38193c5

last_edited_by: agent_stanley
tags: [session, git, p7b, fixtures, r3, r5, false_coverage, fail_rule, coverage_claim,
  adr_011_a8, f_p7b_bg, ilmarinen, rosetta, latent_thirty, source_of_record_inversion]
---

# The fixture the gate forbids

## §0 · Why this sitting exists

The 31st sitting repaired `pre-push-sanitize.sh` to **4.3.0**, removing an extension allowlist from
R5/R6 — *a disclosure gate keyed on `*.md`, failing OPEN* (**F-P7b-ay**). Rosetta shipped it fleet-wide
as governance **v8.10** on 2026-09-11.

Two memos landed while this vault was quiet and say the same thing from opposite directions: **the
repair shipped with no fixture that can demonstrate it.** Rosetta measured it in our tree — *"run
`--self-test` before and after your own repair and it prints the same thing both times"* — and found a
worse defect beside it: `test_fixtures/README.md:26` marks **R3 `✅`** against `dirty/config/.env`, a
file that has **never existed in any tree** and is matched by our own `.gitignore:41`.

## §1 · Opened — measured at the door, not carried from the plan (F-P7b-ae)

HEAD **`c38d46e`** · **0 unpushed** · tree clean but for **3 untracked inbound**.
Census `--meta` **5/5** · **OPEN 5 · CLOSED 13 · RETIRED_UNUSED 1 · INDETERMINATE 39**.

**⛔ Two load-bearing facts in our own handoff block were stale.**

| STATE.md + Next Session Prompt assert | measured 2026-09-15 |
|---|---|
| `.adna/` hook **4.0.1 — three versions behind** | **4.3.0** (v8.10 fired 09-11) |
| `.adna/` lacks the R5 repair | carries 4.3.0 **+ the R5 fixture pair + a corrected README** |

**⛩ Which inverts into a finding of our own.** Rosetta's §4 establishes `Git.aDNA` is the **source of
record** for these fixtures — `aDNA.aDNA` has no `test_fixtures/` directory at all. Yet `.adna/`'s R3 row
reads `⚠ not in the repo` while ours reads `✅`, and `.adna/` carries the R5 pair while we carry nothing.
*The public MIT image ships a more honest coverage table than the vault that authors it.*

## §2 · ⭐⭐ The cause, which is in neither memo

Rosetta found the symptom. Measuring *why* found the cause: **our own gate forbids the fixture.**

- `pushed_files` = `git diff --name-only remote..local` — the files changed *in this push*.
- **R3 iterates that list by `basename`, unfiltered.** A newly-added `dirty/config/.env` lands in
  `pushed_files`, matches `.env`, enters `fail_findings` ⇒ **push BLOCKED**.
- **R5 is likewise `FAIL`.** The `confidential: true` fixtures trip it identically.

Every tracked dirty fixture dates to **2026-06-19**, the vault's genesis day. The gate went live
**2026-09-02** (F-P7b-ag, *"the gate that never ran"*). Nothing has entered the fixture set since.

| rule | severity | fixture |
|---|---|---|
| R1 · R2 | FAIL | tracked — **predate the live gate** |
| R4 | WARN | tracked |
| **R6** | **WARN** | tracked — *the only dirty fixture a live gate would pass today* |
| **R5 · R7** | **FAIL** | **none** |
| **R3** | **FAIL** | **none, and the row says `✅`** |

⇒ ⛩ ***The fixture set's coverage is shaped by which rules are FAIL and which are WARN, not by what
anyone decided to cover.*** **A fixture for a FAIL rule is indistinguishable, to the rule, from the thing
the rule exists to stop.**

⚠ **The prior R3 ruling was made without this fact.** The 2026-09-09 template-release gate ruled *track
it via a path-scoped `.gitignore` negation*, rejecting a rename (correctly — R3 matches filenames). The
negation is verified **necessary and mechanically sound** (`git check-ignore`: only `.gitignore:41`
matches; no parent directory is excluded) but **not sufficient** — committing the result is what blocks.

---

## §3 · Operator ruling — GENERATE, do not exempt

Put as one question covering R3 and R5 together, with the dead options named. **Ruled (e): generate
the FAIL-rule fixtures at test time.** Declined: (c) one-time `--no-verify`, (d) a declared-fixture
predicate, and the split (e)+(c). Already dead before the ask: (a) rename, (b) path allowlist.

## §4 · Acts

**4.1 — Trap reproduced BEFORE any fixture was written.** Identical bytes ± one leading `#`:
parser returns `confidential: true`, then **empty**. ⇒ Rosetta's §4 is real; label goes below the
fence. *Reproduced, not believed.*

**4.2 — Hook 4.3.0 → 4.4.0.** `sanitize_gen_fixtures()` materializes `config/.env`,
`control_confidential.md`, `test_confidential.yaml` into a temp tree; `scan_dirty_root()` walks both
tracked and generated roots; `trap … EXIT` tears down. ⛔ A failed `mktemp` reports **UNMEASURED** and
exits non-zero — *a generator that cannot generate is never a pass* (A8 §3).

**4.3 — Demonstrated to fail (A4 §6 / A8 §7).** Counterfactual **built in the suite**, delta **one
line**:

| fixture | 4.0.1 predicate | 4.4.0 |
|---|---|---|
| `control_confidential.md` | ✅ caught | ✅ caught — *a miss is a harness bug* |
| `test_confidential.yaml` | ⛔ **MISSED** | ✅ caught |
| `config/.env` | ✅ caught | ✅ caught — R3 independent of the R5 predicate, as it should be |

⭐ **Exactly one assertion flips; the two files differ in nothing but extension.**

**4.4 — ⛔⛔ F-P7b-bj, ours, caught by running the counterfactual.** The first draft's **hardcoded**
coverage line printed `R5 exercised` **in the arm where R5 missed**. Repairing it exposed a second:
rule-level coverage **cannot express a per-fixture miss**, so the measured line still read identically
in both arms. ⇒ accumulate from findings · state the population (6 rules; R7/R8 **outside** it, not
inside at 0) · print a **fixture tally** beside it. A third slip in the same pass: `${#var}` is a
string length, not a count.

**4.5 — ⛔ F-P7b-bi.** `find . -name pre_push_hook_spec.md` → **0** here, **1** in `aDNA.aDNA`; never
at that path in this repo's history. Both our pointers repaired. ⭐⭐ Reading it: `:291` specifies
`config/.env` as a fixture; `:322` specifies *"awk pass over `.md` files"* ⇒ **both defects were
specified, not slipped.** ⛔ Her tree untouched (D6.1) — routed.

**4.6 — README trued.** R3 `✅ generated` · R5 `✅ generated` (the pair) · **R7 stays `⏳ deferred`**,
deliberately not upgraded. The FAIL/WARN section and Rosetta's asymmetry note carried forward.

**4.7 — 8 new arms** (36 → **44/44**), incl. the not-tracked guard whose **zero was demonstrated
non-vacuous** (same pathspec → **3** against a repo where the files are tracked).

**4.8 — Ride-alongs.** 3 inbound intaken · stale `.adna/` 4.0.1 corrected in STATE, the hook header,
and the 09-07 Next Session Prompt (**struck in place, not deleted**) · **F-P7b-bg** recorded and
**not adopted** · Ilmarinen's §4 ruled **WIDE**, memo **staged not sent**.

## §5 · Verification — run from the harness, never copied (F-P7b-be)

`test_sanitize_content_gate.sh` **44/44** · `test_prepush_dispatch.sh` **7/7** ·
`test_prepush_scan_range.sh` **5/5** · `dryrun_gitops.sh` **94/94** · `--self-test` **exit 0** ·
`census_findings.sh --meta` **5/5** → **OPEN 7 · CLOSED 15 · RETIRED_UNUSED 1 · INDETERMINATE 39**
(nodes 23 · prose ids 62; no orphans).

## §6 · AAR

- **Worked** — putting the FAIL-fixture question up as **one** ruling covering R3 and R5, with the
  dead options named. The two looked like separate chores and had a single cause.
- **Didn't** — the coverage line shipped **asserted** in its first draft. Reading it would never have
  caught it; only the counterfactual did.
- **Finding** — ⛩ ***a fixture set's coverage can be shaped by rule severity rather than by anyone's
  decision***, and nothing in the vault would have said so: R5 and R7 are uncovered and R3 was falsely
  covered **because all three are FAIL rules**, which is invisible from the coverage table itself.
- **Change** — FAIL-rule fixtures are generated, and the not-tracked arm is what keeps that true.
- **Follow-up** — `census_instrument_meta.sh` (A8 §7, still binding a non-existent instrument, and
  this sitting added three more instruments it would classify) · F-P7b-bf · **R7's fixture**, now the
  only `⏳ deferred` row left.

## §7 · Ledger (as at commit `9eac7fb` — superseded by §9)

**ZERO** pushes · **ZERO** forge write-calls · **ZERO** PATCHes · **ZERO** visibility flips ·
**ZERO** `.adna/` edits · **ZERO** peer-tree writes · **ZERO** `.gitignore` changes.
⚠ One memo **STAGED** (`outbound_ready`), **not sent** — outward act, Standing Order #2.

> ⛩ **SUPERSEDED by §9.** Both outward acts fired at the winddown. Struck rather than rewritten —
> the 2026-09-07 sitting recorded the identical trap (*"it said ZERO pushes and 'staged, not sent'
> minutes after both fired"*), so this is a **known repeating class**, not an oversight.

---

## §9 · WINDDOWN (2026-09-16 — the sitting crosses local dates)

**Two operator rulings at the winddown plan gate:** ADR-011 **A9, both sections** · **send, then push**.

**9.1 — Why send-before-push, which is not stylistic.** Our origin is **GitHub-public**, so the push
*publishes* the staged memo. Rosetta named this on 2026-09-09: *"'Not yet sent' describes your inbox,
not the world."* Push-first would have let Ilmarinen read his own ruling off a public repo before it
reached his tree.

**9.2 — Memo DELIVERED.** `--meta` **first** (the instrument is `NO_META` until demonstrated), then
dry-run, then the act. `SEND_OK`; probe **9 pass · 0 warn · 0 BLOCK · 0 UNKNOWN**. Verified
**independently of the tool's own report**: delta **exactly one line** (`delivered_md5`, retained only),
and ⭐ the retained copy's claimed md5 **matches the actual md5 of the destination file** — the hash is
not merely recorded, it is *correct about the thing it names*.
⚠ **The plan predicted the drop-box; the probe resolved `route=direct`.** Recorded because *the probe
decides the route and a plan's prediction is not a reading.*

**9.3 — ADR-011 A9 ratified.** §1 generated-not-committed (predicate = the **blocking relation**, never
a path) with the three dead options carried **with reasons**; **§1.1 supersedes the 2026-09-09
`.gitignore` ruling** and is why A9 exists — the superseded ruling survives verbatim in a peer memo now
committed in our own tree. §2 makes A8 §6's population predicate-keyed. **A8 byte-identical, `cmp` +
md5 verified after *both* edits.** Ordering disclosed per ADR-016 A1's precedent.

**9.4 — ⛔ The delivered memo now carries a sentence this winddown falsified.** Its §2 says *"No A9 is
authored here, deliberately"* — true when written and delivered, reversed hours later. **The delivered
copy is not edited** (F-P7b-ad). **A one-line follow-up to Ilmarinen is OWED and carried.**

**9.5 — F-P7b-bk + four carried items filed.** See §10.

**9.6 — Two defects in this winddown's own records, both self-caught, neither smoothed.**
(i) the route prediction above; (ii) **STATE was written reading "✅ PUSHED" before the push had run** —
a record written *ahead* of its act is the same defect as one stamped *after* it, and Rosetta's doctrine
§3 (*"stamped AFTER the act, never ahead"*) binds in both directions. Corrected at the write; the
two-commit close is this vault's own precedent.

## §10 · AAR addendum (winddown)

- **Worked** — putting the two gates up as an *ordered* pair rather than two independent yes/nos. The
  coupling (public origin ⇒ push publishes the staged memo) is invisible unless you ask about order.
- **Didn't** — four carried items were about to be lost for the second sitting running; only measuring
  the backlog caught it. And two records in this winddown asserted acts that had not happened.
- **Finding** — ⛩ ***a remedy performed once is not a mechanism*** (F-P7b-bk). The 31st sitting fixed
  "carried items vanish" by filing them; it never made filing a **step**, so it ran once and stopped.
  ⛔ Nothing goes red — STATE still lists every carried item, so the sitting *looks* complete.
- **Change** — "file the carried items" is now an explicit close step (§11). ⚠ **A written convention
  with no mechanism — i.e. exactly what the finding is about** — recorded as interim, not as the fix.
- **Follow-up** — the carried-item **checker** (its hard part is real: the carried set exists only in
  prose, so *"enumerate from the tree"* cuts the wrong way, and its zero must be demonstrated
  non-vacuous or it is F-F97's shape) · the one-line follow-up owed to Ilmarinen.

---

## §8 · NEXT SESSION PROMPT (cold start — read after `CLAUDE.md` and `STATE.md`)

**You are Grace Hopper, `Git.aDNA` — the platform-agnostic git-ops standard. Campaign
`campaign_git_genesis` ("Operation Free Harbor"), phase P7b.**

### Read in this order
1. `CLAUDE.md` · 2. `STATE.md` (top entry = this sitting) · 3. this block · 4. then, **before citing
any instrument's number**: `bash how/tests/census_findings.sh --meta && bash how/tests/census_findings.sh`

### ⛔ Measure these three at the door — all three were stale at this sitting's door
- **`.adna/`'s hook version.** It is **4.3.0** as of v8.10 (2026-09-11), **not** 4.0.1. Ours is
  **4.4.0** ⇒ the standing gap is **one** version. *Re-derive; do not quote this forward.*
- **Inbound count.** `git status --porcelain who/coordination/` — the guest-pen channel bypasses
  every control except the push gate (**F-P7b-ax**), so untracked ≠ the true intake.
- **Unpushed count** and HEAD.

### Where things stand
- **No `proposed` decisions in this vault.** ADR-011 **A8 and A9 are both ratified** (A9 accepted
  2026-09-16 at the winddown gate: §1 FAIL-rule fixtures are generated, **§1.1 supersedes the
  2026-09-09 `.gitignore` ruling**, §2 makes §6's population predicate-keyed).
- **Both outward acts of the 32nd sitting fired:** the Ilmarinen memo is **delivered**, and the work is
  **pushed to origin**. ⚠ **One debt from that delivery:** the delivered copy's §2 says *"No A9 is
  authored here"* and A9 was ratified hours later — his copy is **not** edited, a follow-up is owed.
- **`pre-push-sanitize.sh` is at 4.4.0.** R3/R5 fixtures are **generated, never tracked** — if they
  are ever committed, the FAIL rules block the push and the ruling reverts silently. The
  `generated fixtures are NOT tracked` arm is the only thing watching.
- **Suites** (⚠ from the harness, never from a STATE row — F-P7b-be): **44/44 · 7/7 · 5/5 · 94/94 ·
  `--meta` 5/5 · `--self-test` 0**.

### Open findings — `census_findings.sh` is authoritative, not this list
`F-P7b-ae` · `-at` · `-au` · `-ax` · `-bf` · `-bg` · `-bi`. ⛔ **39 INDETERMINATE — do not
bulk-backfill from prose** (A8 §3); adjudicate at the object when a sitting touches one.

### Strongest candidates, in order
1. **`census_instrument_meta.sh`** — A8 §7 has bound a non-existent instrument since 2026-09-07, and
   this sitting added **three more** instruments it would have to classify.
   `how/backlog/idea_census_instrument_meta.md`.
2. **F-P7b-bf** (R8 move-vs-add) — needs its own sitting **and** a negative control for the laundering
   attack (add to a scanned file, then "move" it). Recurs at every future graduation.
3. **The one-line follow-up owed to Ilmarinen** — the delivered memo's §2 says *"No A9 is authored
   here"*; A9 was ratified hours later. ⛔ His copy is **not** edited (F-P7b-ad); a follow-up is the
   only honest repair.
4. **R7's fixture** — the only `⏳ deferred` row left; a FAIL rule, so **A9 §1** already rules how.
   `how/backlog/idea_r7_fixture_generated.md`.
5. **The carried-item checker** — F-P7b-bk's cure. ⚠ Its hard part is real: the carried set exists only
   in prose, so *"enumerate from the tree, never a roster"* cuts the wrong way here.

⚠ **All carried items now have files** (that was F-P7b-bk): `idea_r7_fixture_generated.md` ·
`idea_campaign_charter_phase_table.md` · `idea_intake_log_backfill.md`. ⛔ The charter table has been
declined at **three** consecutive gates — **rule it won't-do or give it a gate; do not re-carry a fourth
time.**

---

### ⛔ CLOSE CHECKLIST — the step that decayed, written down (F-P7b-bk)

⚠ **This is a written convention with no mechanism, which is precisely what F-P7b-bk is about.** It is
an interim measure, not the fix. Run it by hand at every close until the checker exists.

1. **File every carried item.** Each entry in STATE's `⏭ Next` block must resolve to a **file** — a
   `how/backlog/idea_*.md`, a `what/findings/finding_*.md`, or a mission. *"It is in STATE"* is not
   filing: STATE is what a context clear takes away.
2. **Name every new finding id in STATE prose**, or the census reports it as an orphan.
3. **True the outward-act ledger to what actually fired.** ⛩ Failed on 2026-09-07 *and* attempted again
   here — the ledger reads "ZERO pushes" until someone changes it, and it reads as current.
4. **Never stamp a record ahead of its act** (nor after it — Rosetta's doctrine §3 binds both ways).
   The two-commit close is the precedent.
5. **Re-run every number from the harness.** Never copy a count out of a STATE row (F-P7b-be).
6. **Re-measure the push gate at the head you are actually pushing** (F-P7b-i).
