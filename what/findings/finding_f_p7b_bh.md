---
type: finding
finding_id: F-P7b-bh
status: closed
class: coverage_shaped_by_rule_severity
opened: 2026-09-15
closed: 2026-09-15
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, fixtures, r3, r5, r7, false_coverage, fail_rule, warn_rule,
  adr_011_a8, a8_s5, rosetta, generated_fixtures, f_p7b_bh]
---

# F-P7b-bh — the fixture set's coverage was shaped by rule severity, not by any decision

## Provenance

**Symptom inbound, cause self-found.** Rosetta (`aDNA.aDNA`),
`coord_2026_09_08_rosetta_to_hopper_your_fix_is_correct_and_your_self_test_cannot_see_it`,
measured it **in our tree** while writing her own README. The cause below was measured here.

## Shape — two defects, and the asymmetry between them is the point

| | |
|---|---|
| **R5** | marked `⏳ deferred` — **honestly uncovered**. ⇒ the 4.3.0 repair (F-P7b-ay) shipped **fleet-wide at v8.10 with no regression guard**: `--self-test` printed the same thing before and after it |
| **R3** | marked **`✅`** against `dirty/config/.env` — a file that **has never existed in any tree**, matched by our own `.gitignore:41`. ⇒ **no clone could exercise R3**, and the `Layout` block listed it as though present |

⭐ *A row that is honestly empty invites the question; a row that is wrongly full closes it.* R3's
false `✅` survived **2026-06-19 → 2026-09-08** and was found by a peer reading our file, not by any
instrument here.

## ⭐⭐ The cause, which was in neither memo

**Our own gate forbids the fixture.** Measured 2026-09-15:

- `pushed_files` = `git diff --name-only remote..local` — the files changed in the push.
- **R3 iterates it by `basename`, unfiltered** ⇒ a tracked `config/.env` matches `.env`, enters
  `fail_findings`, and **blocks the push that would add it**.
- **R5 is likewise FAIL** ⇒ the `confidential: true` fixtures trip it identically.

| rule | severity | fixture |
|---|---|---|
| R1 · R2 | FAIL | tracked — **all four date to 2026-06-19, the vault's genesis day** |
| R4 | WARN | tracked |
| **R6** | **WARN** | tracked — *the only dirty fixture a live gate would pass today* |
| **R5 · R7** | **FAIL** | **none** |
| **R3** | **FAIL** | **none, and the row said `✅`** |

The gate went live **2026-09-02** (F-P7b-ag, *"the gate that never ran"*). **Nothing has entered the
fixture set since.** ⇒ ⛩ ***The set's coverage is shaped by which rules are FAIL and which are WARN,
not by what anyone decided to cover.*** **A fixture for a FAIL rule is indistinguishable, to the rule,
from the thing the rule exists to stop.**

## Resolution — operator ruling 2026-09-15: GENERATE, do not exempt

Hook **4.4.0**. `sanitize_gen_fixtures()` materializes the FAIL-rule fixtures into a temp tree at
self-test time; nothing is tracked, so nothing reaches `pushed_files`, and **no exemption of any kind
is created.** A clone can genuinely *generate* R3's fixture — which is what the `✅` row was implicitly
promising all along.

**Ruled out, recorded so they are not re-proposed:**

- ⛔ **rename the fixture** — rejected at the 2026-09-09 template-release gate (R3 matches *filenames*,
  so a rename stops exercising the rule) and independently useless for R5, which is content-keyed.
- ⛔ **path allowlist for `test_fixtures/`** — the exemption shape **ADR-016 A1 §2 forbids**, refused
  three times before: a file-scoped exemption lets a *new* occurrence pass, the exact case the gate exists for.
- ⛔ **per-add `--no-verify`** (F-P7b-bf's precedent) — works, but recurs every time the set grows.
  **A bypass is not a mechanism.**

⚠ **The 2026-09-09 ruling was made without the cause above.** The `.gitignore` negation it prescribed
is **necessary and mechanically sound** (`git check-ignore`: only `.gitignore:41` matches; no parent
directory excluded) but **not sufficient** — committing the result is what blocks. Re-ruled;
**`.gitignore` is therefore left unchanged.**

## Demonstrated to fail before trusted (A4 §6 / A8 §7)

Counterfactual built **in the suite**, not described in a comment: the 4.0.1 `*.md` predicate
reinstated in the self-test's R5/R6 arm only. Delta = **exactly one line**.

| fixture | 4.0.1 | 4.4.0 |
|---|---|---|
| `control_confidential.md` (`.md`) | ✅ caught | ✅ caught — *a miss here is a **harness bug**, not a rule finding* |
| `test_confidential.yaml` (non-`.md`) | ⛔ **MISSED** | ✅ caught |

⭐ **Exactly one assertion changes state**, and the two files differ in nothing but extension ⇒ the
flip is attributable to the extension predicate and to nothing else.

**8 new arms** in `test_sanitize_content_gate.sh` (36 → **44/44**), including: the not-tracked guard
(the only thing keeping this ruling from reverting silently), the `[trap]` arm, and an `UNMEASURED`
arm driven by shimming `mktemp` to fail. ⭐ The not-tracked arm's **zero was itself demonstrated
non-vacuous** — the same pathspec returns **3** against a repo where the files *are* tracked, so it is
a measured zero rather than F-F97's *"has not"* read as *"cannot"*.

**R7 stays `⏳ deferred`** — honestly uncovered, deliberately not upgraded, for the reason this whole
finding is about.
