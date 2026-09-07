---
type: finding
finding_id: F-P7b-av
status: closed
class: silent_truncation
opened: 2026-09-06
closed: 2026-09-07
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, silent_truncation, f_p7b_av]
---

# F-P7b-av — silent truncation

## Shape

The planning pass for A8 itself reported '9 files carry status: draft'. The command was `grep -rl … | head`; `head` truncated at 10 in silence. The number was plausible, so nothing questioned it, and it sized a decision.

## Status

Closed 2026-09-07: the true population is 23 (22 excluding R6's negative-control fixture), and A8 §5 now states the predicate rather than the integer.
