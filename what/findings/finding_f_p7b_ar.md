---
type: finding
finding_id: F-P7b-ar
status: closed
class: install_without_provenance
opened: 2026-09-02
closed: 2026-09-02
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, install_without_provenance, f_p7b_ar]
---

# F-P7b-ar — install without provenance

## Shape

The live control had no tracked source: `.git/hooks/pre-push` was an untracked script whose own header named a 'Source of record (tracked)' that did not exist.

## Status

Closed in the same sitting: the dispatcher is tracked at `how/code/hooks/pre-push-dispatch.sh` and the installed copy matches it. Generalised into A8 §4 — installation is part of the control.
