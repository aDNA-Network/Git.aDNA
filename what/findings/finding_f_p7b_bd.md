---
type: finding
finding_id: F-P7b-bd
status: closed
class: coverage_narrowed_while_repairing_coverage
opened: 2026-09-07
closed: 2026-09-07
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, coverage_narrowed_while_repairing_coverage, f_p7b_bd]
---

# F-P7b-bd — coverage narrowed while repairing coverage

## Shape

The first anchor written for F-P7b-az was a strict `NR==1`, which SILENTLY DROPPED four governance documents from R5/R6 coverage — they carry a documented reframe banner (Standing Order #12) before the fence.

## Status

⛩ A predicate that quietly stops examining things, introduced in the act of repairing a predicate that quietly stopped examining things — and it would have shipped as a fix. Caught by re-measuring the tree after the change and diffing populations, NEVER by re-reading the code. Closed at 4.3.0: the predicate now skips only blank and blockquote lines (the documented convention), measured tree-wide to recover exactly those 4 and admit nothing else, with a guard arm whose negative control is a purpose-built strict-anchor build — MEASURED RED, not assumed. ⚠ Closed as a CODE defect; the habit it came from is F-P7b-ae's business, which remains open.
