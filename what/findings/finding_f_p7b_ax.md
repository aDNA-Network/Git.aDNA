---
type: finding
finding_id: F-P7b-ax
status: open
class: channel_bypasses_controls
opened: 2026-09-06
closed: null
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, channel_bypasses_controls, f_p7b_ax]
---

# F-P7b-ax — channel bypasses controls

## Shape

The guest-pen channel bypasses every control except the push gate: three of seven inbound memos were already committed when we first saw them, so `git ls-files --others` counted 4 against a true intake of 7.

## Status

⛔ OPEN. The intake count remains unmeasurable by the instrument that reports it. Not addressed 2026-09-07.
