---
type: finding
finding_id: F-P7b-bj
status: closed
class: coverage_line_asserted_not_measured
opened: 2026-09-15
closed: 2026-09-15
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, ours, adr_011_a8, a8_s5, f_p7b_ay, f_p7b_bd, self_inflicted,
  counterfactual, decoration_reads_as_support, f_p7b_bj]
---

# F-P7b-bj — ours: the line written to report coverage asserted it instead, in the act of fixing that class

## Shape

4.4.0's first draft closed the self-test with a **hardcoded** line:

```
coverage: R1 R2 R3 R4 R5 R6 exercised — R3/R5 from generated fixtures, rest tracked.
```

Driven against the 4.0.1 counterfactual it printed **`R5 exercised` in the very arm where R5
MISSED** — the run that had just failed, with a `❌ test_confidential.yaml — NO findings` three lines
above it.

⛩ ***That is F-P7b-ay verbatim*** — *"the gate did not merely OMIT its coverage; it asserted a wrong
one"* — **reproduced inside the line written to report coverage, in the sitting convened to close
F-P7b-ay's fixture gap.** It is [[finding_f_p7b_bd]]'s shape as well: a defect of the class being
repaired, introduced **while** repairing it, which **would have shipped as a fix**.

⭐ **Caught by RUNNING the counterfactual, never by re-reading the code** — the same way F-P7b-bd was
caught by re-measuring the tree rather than re-reading the patch.

## Second defect, found repairing the first

Replacing the hardcode with an accumulation exposed a subtler one: **rule-level coverage cannot
express a per-fixture miss.** `control_confidential.md` reaches R5 even in the arm where its sibling is
missed, so the *measured* line still read **identically in the passing and the failing run**.

⛩ ***A number that reads the same whether the run passed or failed is decoration that reads as
support*** — this vault's own phrasing, from ADR-011 A7's Consequences, turned on its author.

## Resolution

- Coverage is **accumulated from findings actually produced**, never listed.
- The **population is stated** and is the 6 rules this arm *implements* — R7 and R8 have no branch in
  `check_fixture_file`, so they are declared **outside** the population rather than counted inside it
  at zero (A8 §5).
- A **fixture tally is printed beside it, always**: `fixtures: 7 scanned, 0 missed` vs
  `7 scanned, 1 missed ⛔`. ⇒ the two arms are now distinguishable **on the coverage block alone**.
- A third slip caught in the same pass: `${#self_test_rules}` is a **string length**, not a count — a
  wrong number inside a population statement. Replaced with `wc -w`.

## Why it is recorded rather than smoothed

Three of the four defects this sitting repaired were other desks'. **This one is ours**, it landed in
new code, and it was invisible to reading. The seven instances behind ADR-011 A8 are all this shape,
and A8 §7 binds *"any instrument built to evaluate A8 itself, **first of all**."*
