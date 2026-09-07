---
type: idea
title: "F-P7b-au — the shellcheck path list misses BOTH hook directories, so the hooks are unlinted"
created: 2026-09-07
updated: 2026-09-07
status: open
last_edited_by: agent_stanley
raised_at: session_stanley_20260907_git_p7b_the_gate_that_cannot_read_its_own_instruments
relates: [f_p7b_au, f_p7b_ay, adr_011_a8]
executor_tier: sonnet
tags: [idea, backlog, f_p7b_au, shellcheck, coverage_gap, allowlist]
---
# The lint list omits the two directories that most need linting

**F-P7b-au**, carried since 2026-09-06, untouched.

The shellcheck path list does not cover `how/standard/hooks/` or `how/code/hooks/`. ⇒ **the pre-push
gates — the most load-bearing scripts in this vault, the ones that decide whether anything may be
published — are unlinted.**

⛩ **This is F-P7b-ay's class exactly**, in a different instrument: *a coverage list that silently omits
the thing it most needs to cover, and reports success over what remains.* It should be fixed with the
same move — enumerate from the tree rather than list paths — and if a list is kept, it must state its
population (A8 §5).

## Live evidence that it matters

The 4.3.0 repair (2026-09-07) surfaced **F-P7b-bb**: `awk` exits 2 on an unreadable file and `set -e`
propagated it out of the hook — **exit 2, no output**. Shellcheck would not have caught that specific
one, but the class (unguarded exit-status propagation in a `set -e` script) is squarely what a linter is
for, and **nothing has ever run over these files**.

## Also unmeasured

Whether the `--meta`/test scripts under `how/tests/` are covered either.
