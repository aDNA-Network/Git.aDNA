---
type: idea
title: "The intake log skips the 29th–31st sittings — an append-only log with a gap in the middle"
created: 2026-09-16
updated: 2026-09-16
status: open
last_edited_by: agent_stanley
raised_at: session_stanley_20260915_git_p7b_the_fixture_the_gate_forbids
relates: [f_p7b_bk, adr_011_a8, a8_s5]
executor_tier: sonnet
tags: [idea, backlog, intake_log, append_only, disclosed_gap, population]
---
# Three sittings are missing from `STATE.md` §Intake log

The log runs to **2026-08-23** and then jumps to **2026-09-15** (32nd sitting, appended at the act).
The **29th (2026-09-02), 30th (2026-09-06) and 31st (2026-09-07)** sittings are absent, including the
winddown that graduated 29 STATE entries and the sitting that ratified A8.

The backfill has been an owed item since **2026-09-02** and is still owed.

## ⭐ Why this is filed rather than quietly fixed

**The gap is now disclosed in the log itself** (the 32nd sitting's row says so in its own text) rather
than left for a reader to discover by noticing dates that do not follow each other. ⛩ *An append-only
log with undisclosed gaps asserts a population it does not have* — which is **A8 §5** applied to a
record instead of an instrument, and the same shape the 31st sitting's winddown found in the findings
backlog.

⚠ **Disclosure is not repair.** Stating the gap makes the log honest; it does not make it complete.

## What the backfill must not do

⛔ **Do not reconstruct rows from STATE's sitting entries alone.** The sitting entries are summaries
written at the close; the intake log records *what came in and what was ruled*, which is a different
fact. Each row should be derived from its **session file** (`how/sessions/history/2026-09/`), which
records the operator's actual words and the rulings taken.

⇒ Three rows, each read at its object. **A8 §3 applies**: a row that cannot be derived is marked as
such, not invented.
