---
type: idea
title: "The campaign charter's phase table has been stale since 2026-08-19 and declined at three consecutive gates"
created: 2026-09-16
updated: 2026-09-16
status: open
last_edited_by: agent_stanley
raised_at: session_stanley_20260915_git_p7b_the_fixture_the_gate_forbids
relates: [campaign_git_genesis, f_p7b_ae, f_p7b_bk]
executor_tier: sonnet
tags: [idea, backlog, charter, stale_record, declined_three_times, phase_table]
---
# The charter's phase table still says "P7b obj 4–5 outstanding"

`how/campaigns/campaign_git_genesis/campaign_git_genesis.md` carries the campaign's phase table. It was
**last trued at the 2026-08-19 R3 pivot** and still reads *"P7b obj 4–5 outstanding"*, with **no mention
of the entire hook/gate arc** that has occupied every sitting since: the chained dispatcher, R8, the
gate going live, hook 4.1.0→4.4.0, ADR-015/016/017, A6–A9.

## ⚠ Record what this item actually is

**It has been declined at three consecutive gates** — the 31st sitting's winddown, the 32nd sitting's
plan gate, and the 32nd's winddown — each time as out-of-scope, each time recorded as *"declined and
carried, not forgotten"*.

⭐ **The decline count is the point, not the chore.** A task refused three times on scope is either (a)
genuinely lower-value than everything it loses to, in which case it should be **closed as won't-do**
rather than re-carried, or (b) load-bearing and being starved, in which case it needs a gate of its
own. ⛩ *Carrying it a fourth time without deciding which, is the same "held as intention rather than
mechanism" shape as [[finding_f_p7b_bk]].*

**Recommendation: rule (a) or (b) at the next gate, do not simply re-carry.**

## If it is done

The charter is a **record**, not a live instrument — STATE.md is the phase pointer and has been correct
throughout (`CLAUDE.md` says so explicitly: *"STATE.md is the live phase pointer — read it first"*).
⇒ this is a staleness defect in a secondary record, which is why it keeps losing. Scope: true the phase
table to P7b's actual arc, and add a pointer making the STATE-is-authoritative relationship explicit on
the charter's own face so a reader cannot take the table as current.
