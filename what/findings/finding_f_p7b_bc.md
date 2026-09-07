---
type: finding
finding_id: F-P7b-bc
status: closed
class: fix_reported_as_regression
opened: 2026-09-07
closed: 2026-09-07
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, fix_reported_as_regression, f_p7b_bc]
---

# F-P7b-bc — fix reported as regression

## Shape

The 30th sitting's F-P7b-aw repair changed `pre-push.gitleaks.sh`'s digest and no census row was added — so from commit `4f323a0` the census adjudicated the REPAIRED hook as UNCLASSIFIED (= FAIL under A4 §2(a)), live on `WGS.aDNA`, and the dryrun arm that says so had been RED for a day with nobody reading it.

## Status

Closed 2026-09-07 by adding the `89d4e211` row. ⛩ The instrument was calling a fix a regression, and the alarm was already ringing unheard.
