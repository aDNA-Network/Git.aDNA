---
type: idea
title: "A8 §7 is ratified and binds an instrument that does not exist — `census_instrument_meta.sh`"
created: 2026-09-07
updated: 2026-09-07
status: open
last_edited_by: agent_stanley
raised_at: session_stanley_20260907_git_p7b_the_gate_that_cannot_read_its_own_instruments
relates: [adr_011_secret_scanning, adr_011_a8, f_p7b_z, f_p7b_ag, f_p7b_ar]
executor_tier: opus
tags: [idea, backlog, adr_011_a8, conformance_census, ratified_obligation, no_artifact]
---
# A ratified clause with no instrument

**ADR-011 A8 was ratified 2026-09-07.** §1 defines a population — *every executable in this vault whose
output is cited as evidence* — §2 gives it a total verdict set (`DRIVEN` · `SELF_TEST_ONLY` · `NO_META` ·
`NOT_INSTALLED` · `INDETERMINATE`), and §7 binds **"any instrument built to evaluate A8 itself, first of
all"**.

⛔ **That instrument does not exist.** `census_instrument_meta.sh` is named **only inside A8's own text**.
Until the winddown of 2026-09-07 it was tracked by nothing — not a backlog file, not a mission, not a
STATE row of its own.

⛩ *A rule you ratify and do not mechanise is indistinguishable from one you never wrote* — which is A8's
own thesis, now true of A8.

## What it must do

- **Enumerate from the tree** (§1) — `how/tests/*.sh`, `how/standard/hooks/*.sh`, `how/code/hooks/*.sh`,
  `how/skills/lib/*.sh`. ⛔ Never a roster. `census_findings.sh` (written 2026-09-07) is the working
  precedent for the shape and for `--meta`.
- **Land every instrument on exactly one verdict** (§2), totality binding.
- **Assert installation, never assume it** (§4) — tracked source of record, and the installed artifact
  must match it.
- **State its population with its verdict** (§5).
- **Report itself** (§7) — and be `NO_META` in its own output until its own `--meta` has run.

## Why it was deferred, and that this was deliberate

A8's provenance records it: *"No instrument is shipped with this amendment, deliberately… A8 is authored
first so the clause is not written to describe whatever the instrument happened to measure."* ⇒ **The
ordering was correct.** This file exists so the second half is not lost, which is the failure mode the
ordering creates.

## Known first-run inputs

`--self-test` is `SELF_TEST_ONLY` for R5/R6 (recorded in the hook at 4.3.0). `F-P7b-z`, `-ag` and `-ar`
are each an instance the census must be able to produce.
