---
type: session
session_id: session_stanley_20260820_git_p7a_the_column_that_cannot_fail
created: 2026-08-20
updated: 2026-08-20
status: completed
operator: stanley
persona: hopper
executor_tier: fable
campaign_id: campaign_git_genesis
campaign_phase: 7a
token_budget_estimated: 130k
last_edited_by: agent_stanley
tags: [session, git, p7a, adr_015_rev4, f_f25, probe_contract, falsifiable, d1_3, ca, dns_01, venus_concurrence, staged_undelivered, operation_free_harbor]
---

# Session — "The Column That Cannot Fail" (R3/P7a, rev 4)

**Charter**: operator "please read the claude.md and let's continue the campaign" → ground-truth sweep
at open (2 read-only agents) → 3-question plan gate (**rev 4 scoped to two clauses** · Venus's
concurrence = **observed-at-source, not received** · scope stays **P7a**) → ExitPlanMode
(`please-read-the-claude-md-joyful-wilkes.md`) = plan approval, incl. gated peer-side memo delivery.

**Why this sitting exists.** Two memos arrived untracked, both *accepting* rev 3 — and the sweep that
read them found that **all three load-bearing facts about the P7a gate in our own `STATE.md` were
wrong**:

1. **Venus has concurred.** Affirmative, written 2026-08-20, verified by her against the ADR file at
   `revision: 3` (`7f4bd48`) rather than against any of our three memos. Her reply is `status: staged`
   under a **per-send operator GO in her vault**, carries no `delivered_*` fields, and has never reached
   our tree. **The gate is blocked on that GO, not on Venus.** Her own `F-S390-01` files this exact
   class; this is its fifth instance in eight days across four vaults.
2. **F-F25 is correct and it is in our binding text.** §D1.5a is the only place in ADR-015 that says what
   the flip probe *measures*, and it measures a column that cannot fail.
3. **Venus's D1.3 correction is right and independently verifiable** without her unsent prose.

**The finding, stated once.** The probe contract said *expect redirect chain: empty*. Under
`follow_redirects=False` — the Exchange fetcher's own setting, and the only honest way to run the probe
— the chain is **always** empty: httpx's `response.history` is `[]` by construction, curl's
`%{num_redirects}` is `0` without `-L`. A redirect does not appear as a chain. **It appears as a 3xx
status with a `Location` header.** So the column returns "empty" and *passes* on precisely the failure
it exists to catch. We wrote *"an instrument that cannot represent the worst state it looks for reports
that state as health"* into ADR-011 A3 five days ago, and then shipped one.

## Scope (from the plan gate)

**NON-OUTWARD except** peer-side memo copies and the self-repo `master` push at close. No `.adna/`
edits · no forge/Caddy/DNS/Exchange mutation · no host moves · no hook installs or symlink repoints ·
no probe run against the live instance · **nothing in `flip_runbook.md` fires**.

## Log

- **Open** — sweep (2 read-only agents): F-F25 blast radius traced to ADR line 62 + runbook §2/§5/§1-P4;
  Venus's concurrence located `staged`-undelivered in her tree; her CA / `service_class` / `fabric_id`
  claims re-verified at source here rather than transcribed.
- `479c359` **intake** — 2 inbound enumerated + dispositioned by name; the stale-pre-send-stamp fact recorded.
- `cd9843e` **ADR-015 rev 4 + runbook** — §D1.5b, positive control, anonymity check, D1.3, §1c, P6–P8.
- `4c4c3c9` + `3fd257e` **3 memos** → Venus (`ack_required`) · Ilmarinen · Hermes. Delivered, `cmp` clean.
- `93a5351` + `e9ca774` **ADR-014 A4 §1a** (F-A4-01) + ledger + STATE + CHANGELOG; memo → Pythia, cc Berthier.

## SITREP

**P7a's gate did not close, and for the first time this vault knows why.** Venus's concurrence exists,
is affirmative, and was made against the ADR file at `revision: 3` — the right way to concur. It is
`status: staged` under a **per-send operator GO in her vault**, so the blocker is a GO, not a peer. That
is now the first line of `STATE.md` and the first row of the ledger's gate table.

**ADR-015 is at rev 4** and is ratifiable in a way rev 3 was not: its only stated measurement can now
fail. **ADR-014 A4 gained §1a** and no longer makes every enrolled replica an error at its own
ratification instant.

**Four memos out, four peers, zero owed back except Venus's scoped extension.**

## AAR (Standing Order #5)

**Worked.** Reading peer trees at source rather than trusting our own STATE. Every one of the three
gate facts recorded here was wrong, and all three were wrong in ways that would have survived any
amount of internal review — Venus's concurrence, F-F25's true location, and the verifiability of her
D1.3 correction. The open-of-session sweep is now this vault's highest-yield habit.

**Didn't.** The open sweep was not enough. Pythia's memo arrived mid-session and was caught only by
re-running `git status` before the closing commit — her own **F-INTAKE-04**, confirmed live on the memo
that carries it. Hermes reported the identical catch two days earlier. Three vaults, one week, same
seam, every instance caught at the close-end check and none at the open-end one.

**Finding.** **F-P7a-f — a measurement that cannot fail is not a control.** The flip probe's only
measured column was empty by construction and passed on the failure it existed to catch. The audit
question generalizes: *can this column ever report the failure it exists to catch?* We authored
ADR-011 A3's version of this sentence on 2026-08-19 while already shipping a violation of it in
ADR-015, and a peer had to return it to us. **F-P7a-g** — the gate was blocked on a per-send GO in a
peer's vault and neither side could see it; fifth instance in eight days across four vaults.

**Change.** Both-ends intake sweep adopted (Pythia's rule). `git log -1 -- <file>` over a self-declared
`updated:` field adopted as doctrine — a self-declared currency field is a transcribed status wearing a
first-person pronoun, which this vault had missed while insisting on the point in every other form.
Every probe added to ADR-015's contract must now state its failure condition at the point of definition.

**Follow-up.** The operator's per-send GO in `Network.aDNA` → Venus's one-line extension over the two
moved clauses → operator §7.7 on rev 4 → **P7a closes**. Then §7.7 on ADR-011 A3 and ADR-014 A4; the
ungated-vault gate installs + `aDNA.aDNA` symlink repoint + fleet realpath census; P7b obj 4–5; the
tooling cascade.
