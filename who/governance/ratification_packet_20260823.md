---
type: governance
title: "Ratification packet — four held amendments (ADR-011 A3/A4/A5 · ADR-014 A4)"
created: 2026-08-23
updated: 2026-08-23
status: awaiting_operator      # ⛔ SURFACES ONLY. Nothing here is stamped. Every amendment below still reads `proposed` in its own ADR and this document changes none of them.
last_edited_by: agent_stanley
governance_doctrine: v8.4      # §7.7 — agents author, operators ratify
session: session_stanley_20260823_git_p7b_the_foss_predicate
covers: [adr_011_a3, adr_011_a4, adr_011_a5, adr_014_a4]
tags: [governance, ratification, section_7_7, adr_011, adr_014, held, operator_gate]
---

# Ratification packet — four held amendments

> **What this is.** Four amendments have been authored, held, and carried on the debt register for
> between two and five days. This page puts them in one place with **what each buys** and **what stays
> blocked without it**, so the §7.7 decision can be taken once rather than four times.
>
> ⛔ **This document ratifies nothing.** Under Governance Doctrine v8.4 §7.7, agents author and
> operators ratify. Each amendment's `status:` and its 4-field ratification block live in its own ADR
> and are **untouched by this packet**. Verified at authoring: all four still read `proposed` with
> `ratified-by: (pending)`.

## The four

| # | Amendment | Proposed | What it buys | What stays blocked without it |
|---|---|---|---|---|
| 1 | **ADR-011 A3** — conformance is behavioural; the roster is the instrument *(corrects A2 §5)* | 2026-08-19 | Adjudicate a hook by **what it does**, not by which file it is | ⛔ **A2 §5's rollout instruction stands, and Berthier measured it wrong in *both* directions** — it would install where nothing is needed and skip where something is |
| 2 | **ADR-011 A4** — the population is the denominator; the resolution order is binding *(extends A3)* | 2026-08-20 | §2(a) an unknown is never a silent pass · §4 exclusion needs a **second independent** predicate · §6 an instrument is untrusted until **demonstrated to fail**, with **a control required to PASS** | ⛔ Every instrument this vault runs is built to A4 and **cited against an unratified clause**. §6 has now caught a real defect **three times in five days** — including inside `probe_peer_state.sh` itself, and **again this sitting** (below) |
| 3 | **ADR-011 A5** — the induced positive must be able to fail; reading ≠ repairing *(extends A2 §4, A4 §3)* | 2026-08-21 | A plant must be **synthetic and non-allowlisted**; both self-test arms required | ⛔ **Rosetta has adopted A2 §4 as written**, which A5 §1 demonstrates can **certify an inert hook**. Their template gate has **no date**, so this is cheap now and expensive after it fires |
| 4 | **ADR-014 A4** — the declared freshness mode is a **field** *(completes A3 §1; §1a added 08-20)* | 2026-08-19 | `freshness_mode` becomes a thing a conf can carry | ⛔ **All 11 mesh rows stay unadjudicable.** The field exists in no conf, and **Berthier cannot write the patch against an unratified clause** |

## ⭐ The one connection worth stating

The debt register has carried *"`freshness_mode` conf patch — still blocks ALL 11 mesh rows"* for weeks,
filed as though it were waiting on Berthier's throughput.

**It is not. It is waiting on §7.7 on row 4.**

⇒ **Ratifying ADR-014 A4 is the cheapest act available that could unblock 11 currently-unmeasured mesh
rows.** They are *unmeasured, not healthy* — that distinction is A4 §4's and it is the reason one green
row on `Git.aDNA` after obj 4 did not license any claim about the lane.

## ⚠ Row 2 earned its keep again this sitting, against its own author

ADR-011 **A4 §4** — *the population is the denominator* — fired against this vault's own staging today.
Planning measured a **hand-picked list of 7** graphs assembled from the STATE narrative and reported
**0 of 7 licensed**. Re-measured against the actual population (every vault whose `origin` resolves to
`codeberg.org`, deduplicated to distinct repos): **19 repos, 18 unlicensed, 1 licensed.**

The narrative sample **understated the population by 12** and **overstated the defect rate** — 0/7 reads
worse than 1/19, so the error was in the flattering direction and would have published a cleaner number
than the truth. It is **F-P7b-b's exact shape** (we wrote *"the single exception"* without sweeping the
class; Venus swept and found a second member) — and the only difference is that this time **the sweep
ran before publication instead of after**.

⇒ **A4 §4 is not an abstraction. It has now corrected a live finding in this vault, written by the agent
who drafted the clause, while the clause sits unratified.**

## What ratification does and does not mean

- **Does**: makes each clause citable as binding. Instruments already built to them stop being
  *"conformant to a proposal"*.
- ⛔ **Does not** fire anything outward. None of the four authorises a push, a host move, a hook install,
  or a wrapper repoint. A4 lets Berthier **write** a conf patch; the patch is still his act at his gate.
- ⛔ **Does not** re-open anything already ratified. A2, A3 (ADR-014) and the ADR-011 base + A1 + A2 are
  `accepted` and **their text is not edited by any of these** — each extends, none amends in place. That
  discipline is why they are four separate amendments and not one revision.

## Holding is a lawful outcome

These have been **held, not lapsed**, and holding them again is a decision, not a failure to decide.
⚠ The one asymmetry worth weighing: **row 3 gets more expensive after Rosetta's template gate fires**,
and that gate has **no date** — so it could fire at any time, and the cost of being late is a certified
inert hook shipped to the fleet.

---

### Operator action

For each row: **ratify** (I stamp the 4-field block in its own ADR — decision · ratified-by · date ·
status — and nothing else in that file changes), or **hold** (I record the hold with its date so the
next sitting does not re-surface it as though it were unread), or **return** with a mark-up.

⛔ Nothing is stamped until you say so, per row. A blanket "yes" to a packet is not what §7.7 asks for,
and I will take a per-row answer over a fast one.
