---
type: session
session_id: session_stanley_20260906_git_p7b_the_ones_that_passed_were_not_scanned
date: 2026-09-06        # thirtieth sitting. Act timestamps UTC.
persona: hopper
executor_tier: opus
status: active
campaign: campaign_git_genesis
phase: "P7b — the ones that passed were not scanned"
door: "§1 open sweep + intake 4 inbound + 3 guest-pen commits · §2 ratify ADR-016 A1 · §3 ADR-011 A8 authored · §4 F-P7b-aw repaired in our copies · §5 three memos · §6 verify + close"
plan: please-give-your-advice-idempotent-wilkinson
head_at_open: 7a204dc
head_at_close: this close commit
outward_acts_planned: 3   # memos: Forgejo.aDNA (Ilmarinen) · Canvas.aDNA (Mondrian) · Network.aDNA (Venus)
token_budget_estimated: ~200k

plan_vs_measured: "⛔ THE PLAN WAS STALE ON EVERY LOAD-BEARING FACT, AND ONE OF THE ERRORS WAS OURS.
  HEAD `901aa56`→**`7a204dc`** (3 Venus guest-pen commits landed) · unpushed 28→**31** ·
  inbound 0→**4** · draft-status files **9→22**. The first three are the world moving under a
  two-day-old plan. ⛔ **The fourth is a measurement defect in the planning pass**: the count came
  from `grep -rl … | head`, and `head` truncated silently at 10, which was reported as a population
  of '9 + 1 fixture'. See F-P7b-av. The plan's own preamble said its facts were 'a starting
  hypothesis, not a finding', and re-measuring at the first act is what caught all four."

inbound_at_open: "4 untracked (`git ls-files --others --exclude-standard`, F-DF-145) **plus 3
  guest-pen commits already in the tree** — a channel the open sweep had no row for until now.
  (1) Ilmarinen → ADR-011 refused four Wave-2 landings; `PercySleep.aDNA`'s hook dies on `/dev/tty`.
  (2) Ilmarinen → **CORRECTION: the four were operator-triaged FALSE POSITIVES on 08-28; ask (1)
      withdrawn.** No exposure, no purge, no rotation, no routing decision owed.
  (3) Ilmarinen → **'the ones that passed were not scanned'** — the gate's coverage is a function of
      remote configuration, not content; four vaults scanned a 0-commit range and returned green.
  (4) Mondrian → ack, plus 'your floor was 4× low' — a second RFC1918 literal our published figure
      never named.
  (5–7) Venus/`Network.aDNA` guest-pen commits `88f41ce` · `da6fd2e` · `7a204dc` — a fleet notice, a
      delivery-stamp correction, and **an ask directed at us** (§5: GitHub mirrors as a real remote
      role for `WebForge.aDNA` + `TypeScript.aDNA` under ADR-006 D1)."

leases_at_open: "ours 0 (`how/sessions/active/` held only .gitkeep before this file). Peer leases
  NOT read at open — the probe measures at the act (F-P7b-i)."

outward: pending

crash_recovery: "The 29th sitting closed cleanly (`901aa56`); three guest-pen commits landed after it;
  `how/sessions/active/` held only `.gitkeep` at open; tree clean but for the 4 untracked inbound.
  TWELFTH consecutive sitting to open on a clean-or-crash check; this one is clean."

operator_rulings:
  - "SCOPE RE-GATED MID-SITTING after the intake: HOOK DEFECTS + A8 + THE A1 STAMP. Three declined:
    hook defects only; stay on the approved plan; add the full 22-file draft audit.
    DEFERRED by this ruling: `census_instrument_meta.sh`, the draft audit, the CI-template repairs
    (F-P7b-at/-au), and Venus's mirror ask."
  - "Ilmarinen's ask #2 = YES, AN INTERACTIVE PROMPT IN AN UNATTENDED-CAPABLE GATE IS AN ADR-011
    CONFORMANCE DEFECT, ruled in A8. Two declined: a separate amendment; not-a-defect/hook-quality."
  - "F-P7b-aw = FIX OUR COPIES, MEMO VENUS WITH THE MEASUREMENT. Two declined: memo only; sweep and
    fix fleet-wide (which ADR-016 D6.1 rules is not ours to do)."
  - "ADR-016 A1 = RATIFY AS WRITTEN (carried from the 2026-09-04 gate). Two declined: ratify without
    §2's allowlist prohibition; hold."

findings_opened: [f_p7b_at, f_p7b_au, f_p7b_av, f_p7b_aw, f_p7b_ax]
findings_closed: []
---

# Session — the ones that passed were not scanned

## §1 · Open sweep

| field | value | how measured |
|---|---|---|
| HEAD at open | `7a204dc` | `git rev-parse --short HEAD` — ⚠ **not** the plan's `901aa56` |
| tree | clean but for 4 untracked inbound | `git status --porcelain` |
| inbound | **4** untracked **+ 3 guest-pen commits** | `git ls-files --others --exclude-standard` (F-DF-145) |
| our leases | **0** | `how/sessions/active/` held only `.gitkeep` |
| peer leases | **not read** | deliberate — F-P7b-i, measured at each act |
| unpushed | **31** | `git rev-list --count @{u}..HEAD` |

**Twelfth consecutive clean-or-crash open; this one clean.**

⛩ **The open sweep had no row for a channel that was already in use.** Three of the seven inbound
items arrived as **guest-pen commits** — already committed into this tree by another graph's session,
so `git ls-files --others` could never have seen them, and the "inbound" count would have read **4**
while the true intake was **7**. Recorded as **F-P7b-ax**; the sweep's own predicate is now the
thing that was incomplete.

---

## ⛔ F-P7b-av — our own coverage claim, from a truncated read, in the planning pass for the clause that forbids it

The 2026-09-03 planning pass reported **"9 files carry `status: draft`"** and built a work item
around it. Measured at the first act: **22** (23 including a test fixture).

**Cause**: the command was `grep -rl '^status: draft' --include="*.md" . | head`. **`head`
truncated at 10 and said nothing.** The number that came back was plausible, so nothing questioned
it, and it was reported to the operator as a population and used to size a decision.

⛩ **It was made while planning ADR-011 A8 §5 — *"a coverage claim states its population, or it is
not a coverage claim."*** The clause was authored against seven instances of other people's version
of this mistake, in a pass that committed it.

⭐ **It is the third instance of the identical class in this one sitting's material**, from three
desks:

| # | instance | the shape |
|---|---|---|
| 1 | **Ilmarinen** — four vaults "landed clean"; their pre-push scanned a **0-commit range** | green over an empty population |
| 2 | **F-F97** (his, on record) — a hazard withdrawn on `waiting=0`, taken before the schedule was registered | zero over an empty population |
| 3 | **ours, F-P7b-av** — `head` truncated 22 → 10, reported as 9 | a count over a truncated population |

⇒ **A8 §5 is no longer an argument from other people's findings.** It is the clause this desk needed
two days ago and did not have.

## §2 · Running log

*(appended as acts complete)*
