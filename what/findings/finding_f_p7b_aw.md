---
type: finding
finding_id: F-P7b-aw
status: closed
class: scan_excluded_wrong_set
opened: 2026-09-06
closed: 2026-09-07
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, scan_excluded_wrong_set, f_p7b_aw]
---

# F-P7b-aw — scan excluded wrong set

## Shape

The pre-push scan used `--not --remotes` with no pattern, subtracting everything reachable from ANY remote-tracking ref — while ADR-013 deliberately runs mixed trust classes on one repo. A commit vetted for a private replica is not thereby vetted for a public origin. Measured: 3 commits in scope vs 31.

## Status

Closed both sides: repaired here 2026-09-06; Venus adopted, re-measured and fixed her own copy 2026-09-07. ⚠ Its own repair then caused F-P7b-bc.
