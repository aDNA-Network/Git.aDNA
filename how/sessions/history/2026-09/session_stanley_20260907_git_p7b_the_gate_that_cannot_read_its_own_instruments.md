---
type: session
session_id: session_stanley_20260907_git_p7b_the_gate_that_cannot_read_its_own_instruments
date: 2026-09-07        # thirty-first sitting. Act timestamps UTC.
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — A8 ratified, and the disclosure gate that cannot read its own instruments"
door: "§1 open + lease + baseline md5 · §2 A8 §5 predicate revised then RATIFIED · §3 pre-push-sanitize 4.3.0 (R5/R6 predicate + awk anchor + per-rule coverage) · §4 demonstrate-it-fails then drive the suites · §5 rule the 23-file draft class · §6 ack Hermes · §7 STATE + findings + close"
plan: please-give-your-rec-giggly-kahan
head_at_open: a2b00a6
head_at_close: this close commit
outward_acts_planned: 1   # one memo: Exchange.aDNA (Hermes), ack_required: true
token_budget_estimated: ~180k

lease: "how/sessions/active/ empty at open (only .gitkeep) — no peer writer. Checked BEFORE the first edit."

baseline_md5:
  what/decisions/adr_011_secret_scanning.md: 3d9d8dc8c905458c166465daf01047dd
  how/standard/hooks/pre-push-sanitize.sh: a5652df6a7ff564e84812377fb4f3518

last_edited_by: agent_stanley
tags: [session, git, p7b, adr_011_a8, ratified, extension_allowlist, fails_open,
  coverage_claim, f_p7b_ay, f_p7b_az, f_p7b_ba, hermes, draft_class, negative_control]
---

# The gate that cannot read its own instruments

## §0 · Why this sitting exists

Three desks, one class, and this time the join is a single artifact.

**ADR-011 A8** was authored at the 30th sitting and left `proposed`. Its spine is **§5** — *a coverage
claim states its population, or it is not a coverage claim* — written after **seven** instances of A4 §6's
class landed **after A4 §6 was ratified**.

**Hermes (`Exchange.aDNA`) filed a defect the same day**, on an artifact neither desk connected to the
other: `pre-push-sanitize.sh` **R5/R6** — the rule that FAILS a push carrying `confidential: true` or
`private: true` — opens its loop with `[[ "$f" == *.md ]] || continue`. ⇒ **a disclosure gate keyed on a
filename extension**, and the direction is the bad one: it ***fails OPEN***.

⭐ **The success line is the join.** `✓ pre-push-sanitize: clean (${#pushed_files[@]} files checked)`
reports the **pushed** count while R5/R6 read a **subset** of it. That is not an *omitted* coverage
number — it is a **wrong** one, and it is **A8 §5 verbatim, in our own live control**. A8 was written
against other desks' instances of this class, in a pass that committed one; Hermes then found it in the
hook we run, and neither knew.

⛔ **Hopper is a PRIMARY addressee, not a cc** (`ack_required: true`) — because this vault is one of the
three that run the hook **live**. Verified at the object, not inferred: it is **gate 2** of our chained
`.git/hooks/pre-push` dispatcher.

## §1 · Measured at open — the predicate stated, per A8 §5

Predicate: `git ls-files` at `a2b00a6`; "frontmatter" = **the hook's own `awk`**, not a proxy.

| | |
|---|---|
| tracked files | **665** · R5/R6 reads **489** · never reads **176** (26%) — 17 `.yaml`, 22 `.json`, 20 `.sh`, 1 `.tsv` |
| ⭐ in the **current outgoing push** (86 files) | reads **73** · never reads **13** |
| non-`.md` that would trip R5 **today** | **0** |

⛩ **The 13 the gate cannot read are every hook and every test instrument in this vault** —
`pre-push-sanitize.sh` **itself** among them — plus `sanitize_deny_content.txt` and the `.tsv` census
snapshot. *The disclosure gate cannot read its own conformance instruments.*

⚠ And the `.tsv` is the **exact extension** Venus's originating instance missed (her list had `.csv`).

***The class is real and the consequence here is currently nil.*** Both halves, in that order.

## §2 · Acts

**A1 — A8 revised, then ratified.** §5's F-P7b-av bullet read *"the true population is **22**"* — a
bare integer for a population, **inside the clause that forbids exactly that**. Predicate stated (23
tracked `*.md`; 22 excluding R6's negative-control fixture), then ratified: heading date, 4-field
block, frontmatter roll-up. ⛔ **Diff verified to 4 hunks; §§1–4, 6, 7 and the provenance block are
byte-unchanged** (A7's discipline — verified, not asserted).

**A2 — hook 4.3.0.** R2's `charset=binary` predicate adopted at **both** R5/R6 sites, via **one shared
function** rather than two inline copies (*two copies of a predicate are two predicates* — the reason
the self-test could agree with itself and disagree with the rule). Per-rule coverage replaced the
single count. Header drift paragraph rewritten, as its own 4.2.0 text requires.

**A3 — the allowlist was masking two defects, and we added a third.**

| finding | shape |
|---|---|
| **F-P7b-ay** (inbound, Hermes) | the extension allowlist itself — a disclosure rule that fails OPEN |
| **F-P7b-az** | frontmatter `awk` **unanchored** — broadening alone trades fail-OPEN for false-POSITIVE (1 phantom vs 8 genuine, measured) |
| **F-P7b-bb** | `awk` exits 2 on an unreadable file; `set -e` propagated it ⇒ **exit 2, no output, before any Decision block**. A crash is not a verdict |
| ⛔ **F-P7b-bd** | **ours** — the first anchor was strict `NR==1` and silently dropped 4 bannered governance docs from coverage |
| **F-P7b-bc** | inherited — the 30th sitting's repair changed a digest, no census row followed, so the census called the **fix** `UNCLASSIFIED` (=FAIL) for a day, live on `WGS.aDNA` |
| **F-P7b-be** | the spec's dry-run footer said `73/73` against a harness saying **94** — third staleness in the line whose own note records the previous two |

⛩ **F-P7b-bd is the one worth keeping.** *A predicate that quietly stops examining things, introduced
in the act of repairing a predicate that quietly stopped examining things.* It would have shipped as a
fix. **It was caught by re-measuring the tree after the change and diffing populations — never by
re-reading the code**, which is the whole argument for A8 §5 in one act.

**A4 — demonstrated to fail before trusted (A4 §6 / A8 §2).** The 3 predicate arms **MEASURED RED**
against the 4.2.0 build, and *the failure output is the finding printed verbatim*:
`clean (1 files checked)` beside a `private: true` file it never read. ⭐ **The two anchoring arms are
green against 4.2.0 for the WRONG REASON** — the `*.md` test masks them, so 4.2.0 is not their
counterfactual. Each was driven against a **purpose-built build** instead (un-anchored; strict-anchored),
both **MEASURED RED**. Without that step they would have been three green arms proving nothing — the
30th sitting's lesson, applied rather than cited. **36/36 · 7/7 · 5/5 · 94/94 · self-test.**

**A5 — draft class ruled.** 23, not 22; the *push* blocker was **1**, not 23. 11 cleared under *a node
cited as authoritative may not carry `status: draft`* (each cited by 7–24 files); 12 kept with stated
reasons. ⭐ **Reading caught one the predicate would have swept**: `doctrine_cross_node_mesh_mirror`
carries a named open review window held by Archimedes. ⛔⛔ **`test_fixtures/dirty/draft_post.md`
untouched, and verified untouched** — it is R6's negative control, and "fixing" it would have converted
a `DRIVEN` verdict to `NO_META` silently.

**A6 — Hermes reply STAGED, not sent.** Dry run `verdict=would_send`, boundary clean, 0 BLOCK. Held at
the operator gate (Standing Order #2).

## §2a · AAR (Standing Order #5)

- **Worked** — measuring the tree *after* each change and diffing populations. It caught F-P7b-bd, which
  no amount of reading the diff would have.
- **Didn't** — the first fix was one line and wrong twice over. An allowlist is load-bearing in ways its
  author never intended, and removing one is not a one-line change.
- **Finding** — ⛩ *removing a gate's allowlist exposes every defect the allowlist was accidentally
  protecting.* Three here, one of them ours.
- **Change** — the shared-predicate function, so the self-test cannot drift from the rule again.
- **Follow-up** — `census_instrument_meta.sh` (A8 §7 binds it before it exists); the send + push, both
  operator-gated.

## §2b · Winddown (same sitting) — three gaps found while preparing the handoff

**W1 — ⛔ this vault's `STATE.md` could not be read.** 333 KB against a 256 KB cap. ⛩ *The file whose
own heading says READ THIS FIRST*, and **this sitting opened by failing to read it** and working around
it with `head -c`. **That is A8 §6 — ratified this morning — arriving in the records rather than the
instruments.** ✅ 29 sitting entries + the already-superseded R2/P6 block graduated **verbatim** →
`STATE_history.md`; **333 KB → 92 KB**; `cmp` byte-identical, 32 markers = 3 kept + 29 moved.

**W2 — 55 findings, and no way to count the open ones.** Prose only; closure recorded by appending
`_closed` to a **tag**. ✅ `what/findings/` (one node per finding, **enumerated from the tree, never
rostered** — A8 §1; a register was *rejected* as the roster that clause distrusts) + a census with
`--meta` **5/5**. **OPEN 4 · CLOSED 13 · RETIRED 1 · INDETERMINATE 39**, population stated.

⛔ **The backfill is 18 of 55 on purpose.** The other 39 are `INDETERMINATE`, never closed — A8 §3.
Backfilling them from old prose would be **asserting** a population, which is the defect, not the fix.

**W3 — ⛔⛔ two id defects, committed by this sitting, that nothing could have reported.** `F-P7b-ay` —
*the headline finding of the day* — was in the tags, the hook, the tests, the memo and the ADR but **not
once in STATE's prose**. `F-P7b-ba` was planned, folded into the A8 §5 revision, and **never assigned** —
a silent hole in the sequence. ⭐ **The census reported both on its first run, against its own author.**
`ay` written into prose; `ba` ruled `retired_unused` — *an unexplained hole in an id sequence is
indistinguishable from a lost finding.*

✅ Also: **5 carried items filed as backlog** (they had **zero** files outside STATE + session history);
Next Session Prompt restored; MANIFEST refreshed.

## §2c · AAR addendum (winddown)

- **Worked** — treating the handoff as a measurement rather than a formality. Nothing in the vault said
  STATE was unreadable; `wc -c` did.
- **Didn't** — six consecutive sittings dropped the Next Session Prompt, including this one until the
  winddown. A convention with no instrument decays exactly like a rule with no mechanism.
- **Finding** — ⛩ ***the vault's own records had the same defect as its gates: a population nobody could
  count, and a claim nobody could check.*** A8 was written for the instruments; it convicts the records.
- **Change** — findings are now nodes, not prose; the census refuses to be cited before `--meta`.
- **Follow-up** — 39 `INDETERMINATE` findings, adjudicated when a sitting touches them, never in bulk;
  and `census_instrument_meta.sh`, which A8 §7 binds and which still does not exist.

## §3 · Ledger

**Two outward acts, both operator-gated and both fired.** ✅ Hermes reply **DELIVERED** to
`Exchange.aDNA` (`SEND_OK`; byte-identical at copy time; delta exactly one line — the retained hash;
probe 9 pass · 0 BLOCK). ✅ **PUSHED to origin** (GitHub-public) — ⭐ *the first push in this vault's
history whose gate stated its own populations*, reached **non-interactively** (A8 §6).
⛔ **ZERO** forge write-calls · **ZERO** PATCHes · **ZERO** visibility flips · **ZERO** `.adna/` edits ·
**ZERO** peer-tree writes. `mesh-rd` **not** pushed — origin only, by operator ruling.

---

## §4 · NEXT SESSION PROMPT (cold start — read this after `CLAUDE.md` and `STATE.md`)

> ⚠ **This block was restored at the 2026-09-07 winddown.** The convention was last honoured
> **2026-08-24** and had been dropped for six sittings, including the one that wrote this.
> *A convention with no instrument decays exactly like a rule with no mechanism.*

**You are Grace Hopper, `Git.aDNA` — the platform-agnostic git-ops standard. Campaign
`campaign_git_genesis` ("Operation Free Harbor"), phase P7b.** Tree clean at close; nothing in flight.

### Read in this order

1. `CLAUDE.md` — governance, Standing Orders, the persona.
2. `STATE.md` — ⭐ **now 92 KB and readable in one call.** The top three sitting entries are the live
   arc (winddown · 31st · 30th); everything older is a dated pointer row → `STATE_history.md`.
3. This block.
4. Then, **before citing any instrument's number**:
   ```sh
   bash how/tests/census_findings.sh --meta && bash how/tests/census_findings.sh
   ```

### Where things stand

- **ADR-011 A8 is RATIFIED** (2026-09-07) — population · total verdict set · installation is part of the
  control · **a coverage claim states its population** (§5) · **runnable in its required context** (§6) ·
  **reflexive** (§7). ⛔ **There are no `proposed` decisions left in this vault.**
- **`pre-push-sanitize.sh` is at 4.3.0**, live as gate 2 of the chained dispatcher. `.adna/` is at
  **4.0.1 — three versions behind**, and the template fix is **Rosetta's**, not ours.
- **Suites, taken from the harness** (⚠ never copied from a STATE row — that was F-P7b-be):
  `test_sanitize_content_gate.sh` **36/36** · `test_prepush_dispatch.sh` **7/7** ·
  `test_prepush_scan_range.sh` **5/5** · `dryrun_gitops.sh` **94/94** · `census_findings.sh --meta` **5/5**.

### The four open findings — `bash how/tests/census_findings.sh` is authoritative, not this list

| id | why it is open |
|---|---|
| **F-P7b-ae** | the plan's opening sweep goes stale by the first act. Three consecutive sittings; the 31st *avoided* it by habit. **No mechanism would notice** — which is what A8 was ratified about |
| **F-P7b-at** | the canonical CI template uses a marketplace action **its own header forbids** (also an ADR-008 portability defect) |
| **F-P7b-au** | shellcheck covers neither hook dir ⇒ **the publication gates are unlinted**. ⛩ F-P7b-ay's class in another instrument |
| **F-P7b-ax** | the guest-pen channel bypasses every control except the push gate; the intake count is unmeasurable by the instrument that reports it |
| **F-P7b-bf** | ⭐ **R8 cannot tell a within-repo MOVE from an addition** — it refused this winddown's own graduation push at measured **zero** new disclosure. Will recur at every future graduation, because SO-6 makes the remedy always a verbatim move. Bypassed once, operator-authorized, recorded before use. **The fix needs its own sitting** and a negative control for the laundering attack (add to a scanned file, then "move" it) |

⛔ **39 findings are `INDETERMINATE`** — named in prose, never adjudicated. **Do not bulk-backfill them
from prose.** Adjudicate at the object, when a sitting touches one. A8 §3.

### Carried work — now filed, so it survives a context clear

`how/backlog/`: **`idea_census_instrument_meta.md`** ⛔ *A8 §7 is ratified and binds an instrument that
does not exist* — the strongest candidate for the next sitting · `idea_ci_template_marketplace_action.md`
(F-P7b-at) · `idea_shellcheck_misses_hook_dirs.md` (F-P7b-au) · `idea_venus_mirror_ask_and_freshness.md`
· `idea_census_depth1_disclosure.md` (Mondrian: every census figure is about **tips**, undisclosed —
an outstanding A8 §5 instance in one of our own instruments).

⛔ **Declined at the winddown gate and carried, not forgotten:** the **campaign charter's phase table**
(`how/campaigns/campaign_git_genesis/campaign_git_genesis.md`), last trued at the 08-19 R3 pivot, still
reading *"P7b obj 4–5 outstanding"* with no mention of the entire hook/gate arc since.

### Correspondence

Inbox is discharged. Mercury + Vulcan (09-06), Venus (09-07), Rosetta (09-07), Mondrian (09-07) are all
`ack_required: false` — **carried, nothing owed**. Our Hermes reply is delivered; his `ack_scope` asked
for nothing back.

### ⚠ Standing traps this vault keeps re-learning

- **Read the inbox at the object before the first edit** — `who/coordination/inbox/` *and*
  `who/coordination/`. Two memos landed mid-sitting on 09-07 and changed load-bearing facts.
- **Take every number from the harness**, never from a STATE row (F-P7b-be, three times).
- **Demonstrate an instrument fails before trusting it** (A4 §6 / A8 §2). ⭐ And check the negative
  control is the *right* one: on 09-07 two arms were green against the prior version **for the wrong
  reason**, and needed purpose-built counterfactuals instead.
- ⛔ **`how/standard/hooks/test_fixtures/dirty/draft_post.md` must stay `status: draft`** — it is R6's
  negative control. "Fixing" it silently converts a `DRIVEN` verdict to `NO_META`.
- **Never edit `.adna/`** (Standing Rule 1). Our hook is a **declared fork**; the template is Rosetta's.
