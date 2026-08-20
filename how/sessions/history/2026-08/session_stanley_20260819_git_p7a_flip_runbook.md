---
type: session
session_id: session_stanley_20260819_git_p7a_flip_runbook
created: 2026-08-19
updated: 2026-08-19
status: completed
operator: stanley
persona: hopper
executor_tier: fable
campaign_id: campaign_git_genesis
campaign_phase: 7a
last_edited_by: agent_stanley
tags: [session, git, p7a, flip_runbook, adr_015_rev2, root_url, no_reply_address, adr_011_a3, conformance, operation_free_harbor]
---

# Session — "The Flip Runbook" (R3/P7a follow-through)

**Charter**: operator "read the claude.md and let's continue the campaign" → 3-question plan gate
(scope = **Flip Runbook (P7a)** · ADR-015 correction recorded as **revise-in-place rev 2** ·
Berthier's `authored_send_held` memo **treated as received, rule on it**) → ExitPlanMode
(`please-read-the-claude-md-joyful-toucan.md`) = plan approval, incl. gated memo delivery.

**Why this sitting exists.** P7a's exit gate is joint (Venus concurrence + operator §7.7) and Venus has
not answered — her last writes predate our 17:31 memo. But the answer to the one question that blocked
the runbook *did* arrive: Ilmarinen's read-only instance audit of the D1.5 flip. It corrects the ADR
Venus is currently being asked to concur to, so the correction must precede her answer.

**Scope (approved plan):**
1. Intake Ilmarinen's D1.5 flip audit (untracked at open).
2. **ADR-015 → rev 2** (revise-in-place; unratified proposal): D1.5 four-key table + `NO_REPLY_ADDRESS`
   pin + runner correction + stored-payload consequence/do-not-rewrite + probe pre-state; D1.2 explicit
   Caddy binds + automatic-HTTPS hazard; D2.2 operator-created-OAuth note; revision log.
3. **Flip runbook** staged — `missions/p7a_flip_staging/flip_runbook.md`, §0–§8, three lane owners.
4. **ADR-011 Amendment A3** (`proposed`) — the conformance ruling Berthier asked for; corrects A2 §5.
5. Three memos → Venus · Ilmarinen · Berthier, delivered peer-side (plan-gate authorized).
6. Bookkeeping: STATE · CHANGELOG v0.35 · p7a card · ledger install roster · SITREP/AAR · push.

**NOT in scope**: closing P7a · `.adna/` edits · any forge/Caddy/DNS/Exchange mutation · installing
hooks into the two ungated vaults · the tooling cascade · P7b obj 4–5.

## SITREP (close)

**All plan items delivered. P7a's gate is still open — by fact, not by choice.** Commits: `a457033`
(intake + open) · `0725d63` (ADR-015 rev 2 + runbook + A3 + ledger roster) · `223de0f` (3 memos) ·
close commit (this file → history + STATE/CHANGELOG/card) · pushed to origin at close.

1. **ADR-015 → rev 2** — D1 corrected against Ilmarinen's live-instance audit. Four keys not three
   (`PROTOCOL`); **`NO_REPLY_ADDRESS` pin as a binding precondition** (the one flip item with no
   post-hoc repair); runner coupling struck as **inverted**; stored-payload consequence +
   do-not-rewrite; probe pre-state baselined with its 404 negative control; D1.2 bind discipline
   promoted assumption→requirement + the auto-HTTPS 301 hazard; D2.2 OAuth loopback-by-design.
   `## Revision log` added. **Concurrence + §7.7 now apply to rev 2.**
2. **Flip runbook staged** — §0–§8, four lanes, fires nothing; staged against an unratified ADR by
   design, so ratification knows what D1 costs to execute.
3. **ADR-011 A3 `proposed`** — Berthier's `ack_required` ruling discharged: behavioural conformance,
   realpath-then-adjudicate, A2 §5's install target corrected, coverage 8/10, F-S158-01 not closed.
4. **Ledger §Secret-gate install roster** — all 10 paths adjudicated at source; `WGS`/`WilhelmAI`
   have no gate at all; `aDNALabs` corrected to PASS(v2) — the fleet's only no-op is closed.
5. **3 memos delivered** (`223de0f`, cmp byte-identical, stamped-before-copy ⇒ zero delta).
6. Fixed two pre-existing broken wikilinks in the P7a mission card (wrong depth, prior session).

**Open at close (next-session queue):** Venus concurrence on **rev 2** → operator §7.7 → P7a closes ·
operator §7.7 on ADR-011 A3 · the two ungated vaults (scoped gated cross-vault act, Rule 10) ·
P7b obj 4–5 against the D3 shape · the tooling cascade · F-S158-01 limb 4 (Operations' pen).

## AAR (5-line)

- **Worked** — asking Ilmarinen one narrow question *before* writing the runbook. His audit named each
  probe's expected value before running it, which is what made two wrong expectations legible as
  findings instead of disappearing into a list of facts. A vaguer ask would have returned agreement.
- **Didn't** — rev 1 shipped to a concurring peer carrying an assumption ("bind discipline is
  inherited") and an inference ("the runner couples to `ROOT_URL`") that were never measured. Both
  were wrong. Neither was marked as unverified in the text, so nothing signalled they needed checking.
- **Finding F-P7a-b** — a `proposed` ADR awaiting a peer's concurrence is a **moving target**. Correct
  it and re-notify *before* the peer answers; otherwise the joint gate ratifies known-wrong text and
  the error is inside the ratified artifact rather than in front of it.
- **Finding F-P7a-c** — adjudicating the roster at source beat a 90-minute-old peer table on 1 of 10
  rows. F-W3-e generalises from held graphs to **any transcribed status**, including a peer's
  same-day measurement.
- **Change** — assumptions that a *peer's* lane must satisfy get marked as unverified in the ADR text,
  not asserted. Rev 2's D1.2 does this: the requirement is stated, and its verification method
  (listener enumeration, not reading the Caddyfile) is stated with it.
- **Follow-up** — Venus concurrence on rev 2 is the live blocker; the two ungated vaults are the
  highest-severity carried item and need their own gated block.
