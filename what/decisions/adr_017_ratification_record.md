---
type: decision
adr_id: adr_017
title: "ADR-017 — The ratification record is not ratified substance"
status: accepted   # authored 2026-08-29 at the operator's RCC gate, which ruled that a heading's status label is RECORD and that all six stale headings be corrected. ACCEPTED 2026-09-02 (plan gate), as written, D1–D5 unchanged. Two alternatives offered and DECLINED: ratify and wire the heading-vs-block agreement check now; hold. ⚠ The enforcement gap named in §Consequences therefore STAYS NAMED and unwired — a decision with a reason, not an assumed-working control. ⭐ This ADR's first act after its own stamp was to complete its own ratification record and ADR-014 A6's, under D1/D3/D4.
created: 2026-08-29
updated: 2026-09-02
last_edited_by: agent_stanley
ratifies_at: "operator RCC ruling 2026-08-29 (heading = record; correct all six) — the basis. Stamped in its own right at the 2026-09-02 plan gate; inline block written in the stamping act (it had none — its own D4 shape)."
depends_on: [adr_011, adr_014]
amends: []
tags: [decision, adr, adr_017, governance, ratification, record, append_only, section_7_7,
  stale_heading, f_p7b_ap, adr_011, adr_014, a5_precedent_narrowed, accepted]
---

# ADR-017 — The ratification record is not ratified substance

**Status**: `accepted` 2026-09-02.

*Ratification: **decision** = ADR-017 D1–D5 as written · **ratified-by** = operator · **date** =
2026-09-02 · **status** = `accepted`. Basis: the operator's 2026-08-29 RCC ruling — heading = record;
correct all six — formalized here and stamped at the 2026-09-02 plan gate. Two alternatives offered
and declined: ratify and wire the heading-vs-block check now; hold.*

> ⭐ **This ADR was authored without an inline ratification block — the one artifact shape its own
> D4 rules `INDETERMINATE`.** It is not corrected under D1 (D1 governs a *stamped* record whose
> label lags); the block above is written **in the stamping act**, with the operator present, which
> is precisely what §Consequences asks of every future ratification. ⛩ *The decision about
> completing records shipped with an incomplete one, and the rule it was written to install is what
> caught it.*

## Context

**Six ratified amendments in this vault carry section headings that read `proposed`.** Each is
contradicted by its own inline ratification block, which names a ratifier and a date.

| amendment | heading reads | its own inline block reads |
|---|---|---|
| ADR-011 **A3 · A4 · A5** | `proposed` 2026-08-19 / -20 / **-21** | `accepted` **2026-08-23** |
| ADR-011 **A6 · A7** | `proposed` 2026-08-23 / -24 | `accepted` **2026-08-24** |
| ADR-014 **A4** | `proposed` 2026-08-19 | `accepted` **2026-08-23** |

This was found once before. ADR-014 **A5's provenance** recorded it against A4 — *"the document
contradicts itself, and a reader who scans headings sees a ratified amendment as unratified"* — and
**deliberately declined to fix it**, on the principle that *"ratified A3 text is not edited"* and that
A5 would not be the amendment that quietly edits a ratified heading while claiming append-only
discipline. **That reasoning was right about append-only and wrong about scope**, and because it was
recorded as *provenance prose* rather than as a clause, it propagated as an absolute.

⛔ **Measured, it is not one instance but a class of six** — **F-P7b-ap** — and five are in
**ADR-011**, the ADR with the most consumers in the fleet. A reader scanning ADR-011's headings sees
**5 of 7 amendments as unratified.**

⭐ **The file's own convention already settles the correct form**, which is why this is a completed
record rather than a judgement call: **A1's heading reads `(accepted 2026-08-08)` and A2's reads
`accepted 2026-08-19`** — both carry the **ratification** date. A3–A7 froze at their **authoring**
date and were never revisited after their stamp. **The stamp happened; the record of it stopped one
line short.**

⛩ *This is the campaign's own recurring class — a stale row that reads as current — sitting in the
line a reader scans first, in the governance artifacts that define how staleness is caught.*

## Decisions

### D1 — What the ratification record is (binding)

A decision's **ratification record** is exactly three things:

1. the **section heading's status label** and its date;
2. the **frontmatter `status:`** line and its notes;
3. the **inline ratification block** (`decision · ratified-by · date · status`).

**Completing that record after an operator has stamped is finishing the ratification, not amending
the decision.** A record that lags its own stamp is an incomplete act, not a preserved one.

### D2 — Ratified substance is still never edited (binding)

**D1 is narrow and exhaustively enumerated.** It licenses the status label and its date, and nothing
else. **Any** change to a clause, an obligation, a definition, a figure, or the reasoning of a
ratified decision remains a **superseding amendment** — never an edit.

⛔ **D2 is the load-bearing half.** A rule permitting "record hygiene" edits to ratified documents is
one loose definition away from permitting substantive ones. If a proposed correction cannot be
performed by changing a status word and a date, **it is not a D1 correction** and D2 governs.

### D3 — A correction under D1 is dated and provenanced, never silent (binding)

Every D1 correction names, in the amending vault's record: each artifact touched, the **before** and
**after** value, and the ratification block it was derived from. Digests before and after; every
other byte proved unchanged. **A silent correction to a ratification record is indistinguishable from
a forged one**, which is the whole reason A5 was reluctant.

### D4 — Where the record disagrees with itself, the inline block governs (binding)

The inline ratification block is authoritative: it is the only one of the three that carries **who
ratified and when**. Heading and frontmatter conform **to it**, never the reverse, and never to each
other. An artifact whose inline block is absent or unreadable is **not** correctable under D1 — its
status is `INDETERMINATE` and it is resolved by asking the operator, not by inference.

### D5 — This ADR does not reach other vaults

D1–D4 govern **this vault's** decision records. Other graphs' ratification hygiene is their pen
(Rule 10). ⚠ The pattern is offered to `aDNA.aDNA` (Rosetta) as a candidate for the standard's §7.7
if it proves out here — **offered, not upstreamed by this act**.

## Consequences

- The six headings in the Context table are corrected under D1, in one dated act, per D3.
- ADR-014 **A5's provenance note stands unedited** — it correctly recorded the defect and correctly
  declined to fix it under the rule available at the time. **D1 is the rule that was missing**, and
  A5's paragraph is now the record of how the class was first seen. *(D2 forbids editing it, and it
  would be a poor start for this ADR if its first act were to tidy away the observation that
  motivated it.)*
- Future ratifications complete the record **in the stamping act**, so the class does not regenerate.
  ⚠ **Nothing enforces that today** — no check reads heading-vs-block agreement. That is a named gap,
  not an assumed-working control, and wiring one is deliberately **not** done here: shipping the check
  before the clause is ratified inverts the order §7.7 exists to impose (the reasoning ADR-011 A7 §5
  and ADR-004 A1 §5 both applied to themselves).

## Alternatives considered

- **Keep A5's precedent absolutely; add a status banner to each ADR.** Rejected: it creates a
  **second** place to go stale while leaving the first one wrong, which is the class being fixed.
- **Record only; change nothing.** Rejected: the defect is in the line a reader scans first, in the
  ADR with the most consumers, and it has already survived one recording.
- **Fix the headings without an ADR.** Rejected: a ruling that narrows a standing precedent needs a
  durable home, or the next amendment re-derives A5's reasoning and re-freezes the class. A5's own
  fate — a correct observation recorded in prose, then read as an absolute — is the argument.
