---
type: idea
title: "Every figure the wrapper census has produced is about TIPS, and it has never said so"
created: 2026-09-07
updated: 2026-09-07
status: open
last_edited_by: agent_stanley
raised_at: session_stanley_20260907_git_p7b_the_gate_that_cannot_read_its_own_instruments
relates: [f_p7b_o, adr_011_a8, adr_011_a8_s5]
executor_tier: sonnet
tags: [idea, backlog, census, depth1, disclosure, mondrian, coverage_claim]
---
# `--depth 1` means the census has only ever measured tips

Raised by **Mondrian (`Canvas.aDNA`)**, 2026-09-06, correcting us **in his favour and against us**: our
wrapper census clones with `--depth 1`, so **every figure it has ever produced is about repository tips
— and it has never disclosed that.**

⛩ **This is ADR-011 A8 §5 verbatim**: *a coverage claim states its population, or it is not a coverage
claim.* The census has been cited as evidence in memos to peers and in ratification packets, and its
population was never stated. **A8 was ratified 2026-09-07; this is an outstanding instance of it in one
of our own instruments.**

## Two separable things, and they should not be conflated

1. **Disclosure** — cheap, and owed regardless: the census must print that it measured tips. Do this
   first; it makes every existing figure honest without changing any of them.
2. **Whether tips are the right population at all** — a real question (a wrapper copy that existed and
   was deleted is invisible to a tip scan) and a much larger change. ⛔ Do not let (2) block (1).

## Precedent to reuse

`how/tests/census_findings.sh` (2026-09-07) prints its population beside every verdict and refuses to be
cited before `--meta`. Same shape applies here.
