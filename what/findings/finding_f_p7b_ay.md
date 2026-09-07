---
type: finding
finding_id: F-P7b-ay
status: closed
class: extension_allowlist_in_publish_gate
opened: 2026-09-06
closed: 2026-09-07
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, extension_allowlist_in_publish_gate, f_p7b_ay]
---

# F-P7b-ay — extension allowlist in publish gate

## Shape

R5/R6 — the rule that FAILS a push carrying `confidential: true` or `private: true` — opened with `[[ "$f" == *.md ]] || continue`. A disclosure gate keyed on a filename extension, FAILING OPEN. Its success line printed the pushed count for a rule that read a subset. Measured: 489 of 665 read; in the outgoing push, 73 of 86 — and the 13 unread were every hook and every test instrument in this vault.

## Status

⛔ REPORTED INBOUND by Hermes (`Exchange.aDNA`) 2026-09-06; ours is the fix, not the discovery. Closed FOR THIS FORK at 4.3.0 (R2's `charset=binary` predicate at both sites). ⚠ NOT closed for `.adna/` — that is Rosetta's release. ⭐ It is ADR-011 A8 §5's first live instance, filed the day before A8 was ratified, against our own control.
