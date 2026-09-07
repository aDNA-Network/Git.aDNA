---
type: finding
finding_id: F-P7b-z
status: closed
class: instrument_never_driven
opened: 2026-08-26
closed: 2026-09-07
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, instrument_never_driven, f_p7b_z]
---

# F-P7b-z — instrument never driven

## Shape

R7 had shipped in `.adna/` and had never run: the hook's only exercise was `--self-test`, which REIMPLEMENTS R1–R6 rather than driving them.

## Status

Closed FOR THIS FORK at 4.3.0: `test_sanitize_content_gate.sh` drives R7 through the real entry point (3 arms), and the shared-predicate seam now exists. ⚠ NOT closed for `.adna/` — Rosetta measured her copy as defining ZERO functions, so there is nothing there for the two paths to share.
