---
type: idea
title: "R7 is the last uncovered rule, and A9 §1 already says how to fixture it"
created: 2026-09-16
updated: 2026-09-16
status: open
last_edited_by: agent_stanley
raised_at: session_stanley_20260915_git_p7b_the_fixture_the_gate_forbids
relates: [adr_011_secret_scanning, adr_011_a9, f_p7b_bh, f_p7b_z, pre_push_sanitize]
executor_tier: sonnet
tags: [idea, backlog, fixtures, r7, deferred, fail_rule, generated_fixtures, adr_011_a9]
---
# R7's fixture — the last `⏳ deferred` row

After the 32nd sitting, `how/standard/hooks/test_fixtures/README.md` has **exactly one** rule row that
is not covered: **R7 (operator deny list)**, marked `⏳ deferred`.

⭐ **It was left deferred deliberately, not overlooked.** R5's honest `⏳ deferred` is what made the
whole class findable — *a row that is honestly empty invites the question; a row that is wrongly full
closes it* — so R7 was **not** quietly upgraded while the table was being trued.

## Why it is now cheap

**R7 is a FAIL rule**, which is exactly why it had no fixture (F-P7b-bh: the set's coverage was shaped
by which rules are FAIL and which are WARN). **[[adr_011_secret_scanning|ADR-011]] A9 §1** now rules
that case: *a fixture for a FAIL rule is generated at test time, never committed.* The generator
already exists — `sanitize_gen_fixtures()` in `pre-push-sanitize.sh` 4.4.0 — so this is an extension of
a working mechanism, not new engineering.

## What it needs

- A generated fixture whose path matches an operator deny entry, plus the deny file to match it
  against — ⚠ **R7 reads `sanitize_deny_paths`, so the fixture and its deny rule must be generated as a
  pair**, or the arm is green because nothing was denied rather than because the rule fired.
- ⛔ **Demonstrated to fail before trusted** (A4 §6 / A8 §7): drive it against a build where R7's loop
  is stubbed, and show the arm goes RED. A9 §1.3 also requires the not-tracked arm cover it.
- ⛔ **F-P7b-z is the standing warning**: R7 *"has shipped in `.adna/` and has never run"*. A fixture
  that exercises a path no caller takes is not coverage. Check the push-time rule is reached, not only
  the self-test's reimplementation (which is `SELF_TEST_ONLY` under A8 §2).

## Not urgent

R7's row is **honest**. This closes a real gap but no live exposure — unlike R5, whose repair had
shipped fleet-wide unguarded.
