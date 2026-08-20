---
type: session
session_id: session_stanley_20260819_git_p7a_the_precondition
created: 2026-08-19
updated: 2026-08-19
status: active
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

## Open state

*(SITREP + AAR appended at close.)*
