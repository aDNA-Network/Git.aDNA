---
type: idea
title: "ADR-011 needs a non-normative consolidated reading — the operative rule now spans five layers"
created: 2026-08-23
updated: 2026-08-23
status: open
last_edited_by: agent_stanley
raised_at: session_stanley_20260823_git_ratification_packet
relates: [adr_011_secret_scanning, adr_011_a2, adr_011_a3, adr_011_a4, adr_011_a5, adr_015_d1_5b]
executor_tier: sonnet     # mechanical synthesis of already-ratified text; judgement was spent at ratification
tags: [idea, backlog, adr_011, consolidation, readability, governance, non_normative]
---

# ADR-011's operative rule is correct and unreadable in one place

## The condition

With A3, A4 and A5 ratified 2026-08-23, the answer to *"how do I adjudicate a hook?"* is assembled from
**five layers**:

| Layer | Contributes |
|---|---|
| **base ADR-011** | the scan/gate model |
| **A2** | mechanism (range scan · fail-closed · skeleton v2) + §4 the induced-positive standard |
| **A3** | behavioural conformance · the 4-row md5 table · install at realpath · roster enumerates the artifact |
| **A4** | the **population** · four more adjudication classes · **binding resolution order** · worktrees in-population · content ≠ execution |
| **A5** | the plant must be **synthetic** · both arms required · **repairs target `--git-common-dir`, not `--git-path`** · a predicate matching documentation is not a measurement |

Nothing here is wrong. The layering is **deliberate and correct** — ratified text is never edited, so a
correction arrives as an extension. That discipline is why the record is trustworthy.

## Why it is nevertheless a real debt

⭐ **This is the exact readability condition under which this vault's most-repeated defect appears.**
Every instance of it was visible **only** when two clauses were read *against each other*:

- **A2 §3 vs A2 §4** — §3 describes a three-arm self-test, §4 codifies a weaker standard **eleven lines
  later, in the same accepted text**. (A5 §2, recorded against ourselves.)
- **ADR-014 A3 §1 vs A2 §2** — §1 created a second state axis and left it as prose, violating §2's
  *"a field, not a comment"* **in the same ratified commit**. (ADR-014 A4.)
- **ADR-015 D3 §2 vs D3 §1** — §1 already assigns git-homed graphs to the git lane, so §2's retirement
  clause contradicts it one paragraph above. (ADR-015 A1 §3.)

⇒ **The pattern is the finding: our review reads clauses one at a time.** Five layers is more adjacent
pairs than anyone reads, and the defect class is *specifically* the one that hides between them.

## What to build

A **non-normative** "current operative rule" reading of ADR-011 — one page, the adjudication procedure
end to end, **each line citing the layer it comes from**. It is a **reading**, with the same standing as
a census: dated, re-derivable, and authoritative for nothing.

## ⛔ Constraints — the failure mode is obvious and must be stated

- ⛔ **Never an edit to ratified text.** The consolidation exists *because* the amendments are immutable.
- ⛔ **Never a substitute for the ADR.** If the reading and the ADR disagree, **the ADR wins and the
  reading is the defect.** Say so in the document itself.
- ⛔ **Not written inside a ratification sitting.** *A consolidation authored next to a stamp is how a
  consolidation quietly becomes an edit* — the reason this is a pointer and not a document today.
- ⚠ It goes stale the moment A6 exists. Carry a `derived_from` commit so staleness is **detectable**
  rather than assumed-absent — the same property `secret_gate_census.md` carries via its freshness banner.
