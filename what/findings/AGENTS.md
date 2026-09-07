---
type: directory_index
created: 2026-09-07
updated: 2026-09-07
last_edited_by: agent_stanley
tags: [directory_index, findings, p7b, adr_011_a8, enumerated_not_rostered]
---

# Findings — one node per finding, enumerated from the tree

## Why this directory exists

Until 2026-09-07 this vault's findings existed **only as prose in `STATE.md`**, and closure was recorded
by appending `_closed` to a **tag**. Fifty-five ids had accumulated (`F-P7b-a` … `F-P7b-be`) and the
question *"how many findings are open?"* **could not be answered**.

⛩ That is the campaign's signature class, applied to the campaign's own records: **a population with no
instrument** — the thing [[../decisions/adr_011_secret_scanning|ADR-011]] **A8** was ratified about, one
level down.

⭐ **And the sitting that built this directory had already proved the gap, against itself.** Two id
defects, neither noticed by anything: **`F-P7b-ay`** — the headline finding of that very sitting — was
in the tags, the hook, the tests, the memo and the ADR but **not once in `STATE.md`'s prose**; and
**`F-P7b-ba`** was planned, folded into the A8 §5 revision, and **never assigned**, leaving a silent hole
in the sequence. *Nothing in this vault could have told anyone either.*

## ⛔ Not a register

**A hand-maintained table was rejected.** A8 §1 is explicit — the population is **enumerated from the
tree, never rostered** — because *"a list of what we believe exists is not a population"*, and nothing
notices when a roster drifts from the thing it claims to describe.

⇒ **One file per finding.** The directory listing **is** the population. `census_findings.sh` reads the
tree; it does not read a list.

## Node shape

```
finding_f_p7b_<id>.md
---
type: finding
finding_id: F-P7b-<id>
status:    open | closed | retired_unused
class:     <short_kebab_shape>          # the failure class, not the artifact
opened:    YYYY-MM-DD
closed:    YYYY-MM-DD | null
---
## Shape     — what the defect was, and what was measured
## Status    — why it is open or closed, and what is NOT covered by that closure
```

- **`retired_unused`** — an id that was planned and never assigned. ⛩ Recorded rather than left silent:
  an unexplained hole in an id sequence is indistinguishable from a lost finding.
- ⚠ **Closure is scoped, and the scope is stated in the body.** Several findings are closed *for this
  fork* and remain open in `.adna/` — `F-P7b-ay` and `F-P7b-z` both. A bare `closed` that hides a live
  defect elsewhere would be the same failure this directory exists to prevent.

## ⛔ The backfill is partial ON PURPOSE, and the census says so

Only findings named in the **retained `STATE.md` window** or in the **carried-work list** have nodes —
**18 of 55**. The remaining 37 are recorded as **`INDETERMINATE`**, never as closed and never as absent.

**A8 §3**: *unmeasured is INDETERMINATE, never a green and never a zero.* Backfilling all 55 by reading
old prose would be **asserting** a population, which is the defect, not the fix. They are adjudicated
when a sitting touches them, at the object.

## Reading the population

```sh
bash how/tests/census_findings.sh          # OPEN · CLOSED · RETIRED · INDETERMINATE, with the population stated
bash how/tests/census_findings.sh --meta   # every failure path demonstrated to fail (A8 §7, run this first)
```

⛔ **`--meta` before the number is cited.** A8 §7 binds *"any instrument built to evaluate A8 itself,
first of all"* — a census that has not been demonstrated to fail is `NO_META` in its own report.
