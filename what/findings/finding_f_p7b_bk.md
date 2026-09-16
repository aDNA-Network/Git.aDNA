---
type: finding
finding_id: F-P7b-bk
status: open
class: remedy_performed_once_never_made_a_step
opened: 2026-09-16
closed: null
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, ours, carried_items, backlog, close_checklist, adr_011_a8,
  a8_s3, no_instrument, citation_is_not_enforcement, f_p7b_bk]
---

# F-P7b-bk — the fix for "carried items vanish" was performed once and never made a step, so it stopped

## Shape

The **31st sitting** (2026-09-07 winddown) found that five carried items had **zero files outside
`STATE.md` and session history**, and filed them as backlog *"so they survive a context clear"*.

Measured at the **32nd sitting's** winddown, one sitting later:

| carried item | file outside STATE at the winddown? |
|---|---|
| R7's fixture — the last `⏳ deferred` row | ⛔ none |
| the campaign charter phase table (declined **3×**) | ⛔ none |
| the intake-log backfill (29th–31st) | ⛔ none |
| the A9 decision-record gap | ⛔ none |

**Four carried, zero filed.** ⇒ ⛩ ***The remedy was performed as an act and never made a step in the
close, so it ran once and stopped.***

## Why it is this campaign's signature class, one level up

This is **[[finding_f_p7b_ay|F-P7b-ay]]'s and A8's shape turned on the remedy for that shape**: a
discipline that exists, is agreed with, was even *executed once* — and is not mechanised, so it decays.
ADR-011 **A8** was ratified because *"A4 §6 is quoted at the top of `send_memo.sh` and cited in three
instruments, and every one of the seven instances of the class landed after it."* ⛩ *Citation is not
enforcement — and neither is having done it once.*

⚠ **It is also invisible in the usual way.** Nothing goes red. STATE's `⏭ Next` block still lists every
carried item, so the sitting *looks* complete; the loss only appears at the next context clear, by
which time the item is gone and nobody knows it was ever carried.

## ⛔ No instrument enforces this, and saying so is part of the finding (A8 §3)

**The cure is a check that every carried item named in `STATE.md`'s `⏭ Next` block resolves to a file**
— a backlog node, a finding node, or a mission. ⛔ **That instrument does not exist.** It is named here
rather than built, because building it inside a winddown is the scope creep A8's own provenance warns
against, and because the shape needs thought:

- the `⏭ Next` block is **prose**, so the check needs a parseable convention to enumerate against — and
  ⭐ *"enumerate from the tree, never from a roster"* (A8 §1) cuts the other way here: the carried set
  exists only in prose, so the enumeration problem is real and is the actual work.
- ⚠ A check that can only ever report **zero** because its enumerator matches nothing would be
  **F-F97's shape** — *"has not" read as "cannot"* — the exact defect Ilmarinen filed against his own
  sweep. Its zero must be demonstrated non-vacuous before it is trusted.

**Interim disposition, taken at this winddown:** the four items are filed by hand, and **"file the
carried items" is added as an explicit step to the session close** in the Next Session Prompt. ⚠ *That
is a written convention with no mechanism — i.e. exactly what this finding is about* — and it is
recorded as an interim measure rather than presented as the fix.

## Closes when

The carried-item check exists, has been demonstrated able to report non-zero, and runs at close.
