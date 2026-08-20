---
type: session
session_id: session_stanley_20260819_git_p7a_flip_runbook
created: 2026-08-19
updated: 2026-08-19
status: active
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

*Appended at close.*

## AAR (5-line)

*Appended before `status: completed`.*
