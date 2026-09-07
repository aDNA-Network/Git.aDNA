---
type: finding
finding_id: F-P7b-as
status: closed
class: guard_that_cannot_fire
opened: 2026-09-02
closed: 2026-09-02
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, guard_that_cannot_fire, f_p7b_as]
---

# F-P7b-as — guard that cannot fire

## Shape

The WARN path's no-tty guard read `[[ -t 0 ]] || [[ ! -e /dev/tty ]]`. Both arms are always false at push time, so it fell through to `read` and died on the device — THE RIGHT VERDICT FOR THE WRONG REASON, and the operator message it guarded had never once printed.

## Status

Closed at 4.2.0: the test is now the ACT (`if ! ( : < /dev/tty )`, in a subshell). Became A8 §6's reference cure and answered Ilmarinen's ack_required ask.
