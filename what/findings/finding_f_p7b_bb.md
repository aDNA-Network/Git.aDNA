---
type: finding
finding_id: F-P7b-bb
status: closed
class: crash_not_verdict
opened: 2026-09-07
closed: 2026-09-07
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, crash_not_verdict, f_p7b_bb]
---

# F-P7b-bb — crash not verdict

## Shape

`awk` exits 2 when it cannot open its input, and `fm=$(...)` propagated that under `set -euo pipefail`: exit 2, NO OUTPUT, before any Decision block. Fail-safe in direction, but a crash is not a verdict — the operator sees a bare `2` and no finding.

## Status

Closed at 4.3.0: unreadable files are reported as an R5/R6 finding and fail closed WITH A REASON. Previously unreachable because unreadable non-.md files never got to the awk.
