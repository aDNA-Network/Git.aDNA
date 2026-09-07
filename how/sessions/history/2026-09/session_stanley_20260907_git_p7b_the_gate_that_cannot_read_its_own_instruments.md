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

## §3 · Ledger

**ZERO** forge write-calls · **ZERO** PATCHes · **ZERO** visibility flips · **ZERO** `.adna/` edits ·
**ZERO** peer-tree writes. One memo out (Hermes). Push operator-gated.
