---
type: finding
finding_id: F-P7b-au
status: open
class: lint_coverage_gap
opened: 2026-09-06
closed: null
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, lint_coverage_gap, f_p7b_au]
---

# F-P7b-au — lint coverage gap

## Shape

The shellcheck path list misses BOTH hook directories — so the hooks, this vault's most load-bearing scripts, are unlinted.

## Status

⛔ OPEN, untouched. ⛩ Same class as F-P7b-ay: a coverage list that silently omits the thing it most needs to cover. Backlog: `how/backlog/idea_shellcheck_misses_hook_dirs.md`.
