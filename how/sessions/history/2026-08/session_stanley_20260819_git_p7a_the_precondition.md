---
type: session
session_id: session_stanley_20260819_git_p7a_the_precondition
created: 2026-08-19
updated: 2026-08-19
status: completed
operator: stanley
persona: hopper
executor_tier: fable
campaign_id: campaign_git_genesis
campaign_phase: 7a
token_budget_estimated: 120k
last_edited_by: agent_stanley
tags: [session, git, p7a, adr_015_rev3, egress, allow_private, name_allowlist, precondition, adr_014_a4, freshness_mode, f_a3_01, operation_free_harbor]
---

# Session — "The Precondition" (R3/P7a inbound discharge)

**Charter**: operator "please read the claude.md and let's continue the campaign" → 2-question plan
gate (scope = **The Precondition (P7a inbound discharge)** · ungated vaults = **record only**) →
ExitPlanMode (`please-read-the-claude-md-nested-crystal.md`) = plan approval, incl. gated memo delivery.

**Why this sitting exists.** Two memos were on the desk and neither had been acted on. One of them —
Hermes's, `ack_required` — **was committed without being read**: it landed 18:28 and was swept into
intake commit `0725d63`, the same commit that revised the clause it objects to. It says ADR-015 §D1.5
is **unsatisfiable as written**, with the code path and line numbers to prove it. Venus has not opened
a session since 17:11, so she has not yet read rev 2 — which means the window to correct §D1.5
*before* the joint gate ratifies it is open right now. That is [[../history/2026-08/session_stanley_20260819_git_p7a_flip_runbook|last session's own F-P7a-b]]
prescription — *correct and re-notify BEFORE the peer answers* — arriving for its first live test one
sitting after it was written.

**Scope (approved plan):**
1. Intake Pythia's A3 markup (untracked at open); register Hermes's memo (tracked-but-unread).
2. **ADR-015 → rev 3** (revise-in-place; unratified proposal): D1.5 restated **three-part-plus-one**
   — `allow_private = False` gated on the Exchange's name-allowlist exemption; lane-asymmetry fact;
   honest no-date bound; 404 negative control confirmed; Alternatives amended; revision log.
3. **Flip runbook** — precondition **P5**; §6 handoff split.
4. **ADR-014 Amendment A4** (`proposed`) — F-A3-01: the declared freshness mode must be a *field*.
5. Three memos → Hermes · Pythia · Venus, delivered peer-side (plan-gate authorized).
6. Findings **F-P7a-d** / **F-P7a-e**; ledger rows; STATE · CHANGELOG · p7a card · SITREP/AAR · push.

**NOT in scope**: closing P7a · `.adna/` edits · any forge/Caddy/DNS/Exchange mutation · installing
hooks into WGS/WilhelmAI or repointing `aDNA.aDNA`'s dead symlink (**record only**, operator ruling) ·
the fleet-wide realpath census · the tooling cascade · P7b obj 4–5 · intake backfill · F-W6-a.

## SITREP (close)

**All plan items delivered. P7a's gate is open on both limbs, and neither is mine to fire.** Commits:
`e9b88bc` (intake + open) · `b6a709e` (ADR-015 rev 3 + runbook P5) · `59534e0` (ADR-014 A4) ·
`82e27db` (ledger findings) · `9d54d3d` (3 memos) · `2c8b138` (delivery tracking) · close commit
(this file → history + STATE/CHANGELOG/card) · pushed to origin at close.

### What the ground-truth sweep found before any writing began

| | Fact | Consequence |
|---|---|---|
| 1 | **Venus had not read rev 2** — last write `494a322` @ 17:11:41; our memo delivered 19:08 | the window to correct the ADR *before* she concurs was still open |
| 2 | ⛔ **Hermes's `ack_required` memo (18:29) was already tracked** — swept into `0725d63`, *the commit that authored rev 2 of the clause it objects to*. Grep for "hermes" across the vault: **zero hits outside the file itself** | committed without being read; **F-P7a-d** |
| 3 | **Pythia's A3 markup (19:42) untracked**, carrying F-A3-01 | A3 contradicts A2 in the same ratified commit |
| 4 | *(off-scope, verified at source)* `aDNA.aDNA/.git/hooks/pre-push` → symlink → `216aaca2…`, the retired no-op | **F-P7a-e**; recorded only, per operator ruling |

### Delivered

- **ADR-015 → rev 3** — D1.5 restated **three-part-plus-one**; new **§D1.5a** carrying Hermes's
  check-order evidence; the process-global lane asymmetry restated (invisible from our side); the
  `404` negative control promoted to binding text; Alternatives narrowed to **piecewise-by-necessity**;
  Consequences record M08's retirement as *partial* and that the ADR binds a third vault's runtime.
  **D1.1–D1.4 untouched from rev 2; D2–D5 untouched from rev 1.**
- **flip_runbook** — **P5** added; the two `⛔` preconditions separated because they are `⛔` for
  opposite reasons; **§1b** tables the two lawful dispositions with costs; **§6 split** into §6a/§6b;
  §7 rollback corrected. Still `staged`; fires nothing.
- **ADR-014 A4 `proposed`** — `freshness_mode` as a field, on A2 §2's own reasoning; conf shape held
  as Berthier's pen; the A3 §4 attribution correction recorded against ourselves.
- **Ledger** — F-P7a-e + the ungated-vault liveness table (asymmetric; do not fire as one wave).
- **3 memos** delivered `9d54d3d`, `cmp` byte-identical, both sides non-empty.

### Verification

`ADR/runbook self-consistent (no surviving unconditional four-as-one-unit assertion)` ✓ ·
`Hermes asks 3/3, each traced to a named artifact line` ✓ · `dry-run harness 31/31 (untouched-lib
baseline)` ✓ · `peer vaults carry exactly our one copy each` ✓ (Exchange 1/1 · Inference 1/1 ·
Network 1 of 8 — the other 7 are a health daemon plus Ilmarinen's and Pythia's own deliveries) ·
`Forgejo / WGS / WilhelmAI / aDNA.aDNA untouched` ✓ · `no bare §5a refs remain` ✓.

### Not done, deliberately

P7a **not closed** · no remediation of `WGS` / `WilhelmAI` / `aDNA.aDNA` (operator: record only) ·
no fleet realpath census · no `.adna/` edits · no forge/Caddy/DNS/Exchange mutation · no host moves ·
tooling cascade, intake backfill, F-W6-a all carried unchanged.

## AAR

**Worked.** *Sweeping before writing.* The plan for this session did not survive the first ten minutes
of ground truth, and that was the session's whole value — the scope the operator approved was chosen
*after* the sweep, not before it. Three of the four facts above would have been invisible to a session
that opened by reading its own STATE and continuing.

**Didn't.** The vault committed an `ack_required` memo without reading it, then sent a concurrence ask
on the clause that memo refutes. `git add who/coordination/` is indistinguishable from intake at the
tooling level and materially different at the doctrine level. It cost nothing only because the peer
who would have been misled had already gone home.

**Finding — F-P7a-d.** *Intake-by-directory-add is not intake.* An inbound file entering a commit is
enumerated and dispositioned **in that commit's message**. Recorded in ADR-015's **revision log**
rather than here, because the revision log is where a reader asks *why did this change again* — a
finding filed only in a session file is the same failure class it describes. Pythia independently
filed the identical failure against herself this week, and rev 2's cause (F-P7a-b) was the same shape:
**an artifact moving between the read and the act.** Two consecutive ADR revisions, two vaults, one
week ⇒ a class.

**Finding — F-P7a-e.** *An honest number can have a dishonest denominator.* Last session's roster said
"coverage 8/10, never 10/10" and was scrupulous about it — while measuring the mesh-rd **enrollment
list**, not the ~40 vaults the gate claims. The first off-roster vault checked was the standard-bearer
and it fails. This is ADR-011 A3 §3's own principle (*an instrument that cannot represent the worst
state it looks for reports that state as health*) one level up: an instrument pointed at a subset
reports the subset's health as the fleet's. Naming the denominator is now part of stating coverage.

**Change.** Two, both structural rather than exhortative: (1) inbound files are named in commit
messages, so an unread memo cannot enter the history silently; (2) any coverage claim states its
denominator and how it was chosen.

**Follow-up.** Venus's concurrence against **rev 3** → operator §7.7 → P7a closes · §7.7 on ADR-011 A3
and ADR-014 A4 · the ungated-vault installs (`WGS` first, `WilhelmAI` in a quiet window,
`aDNA.aDNA`'s repoint) + the fleet realpath census, all as scoped gated acts · P7b obj 4–5 · the
tooling cascade.

**Standing note for the next sitting.** Hermes closed with *"if §D1.5 changes materially before
ratification we would like to see it."* That commitment is recorded in ADR-015, not only in the reply
memo — which is the point of this whole session in one line: **a commitment that lives only in a memo
is prose in a file nobody is required to read**, and this vault has now been bitten by that twice in
two days, in both directions.
