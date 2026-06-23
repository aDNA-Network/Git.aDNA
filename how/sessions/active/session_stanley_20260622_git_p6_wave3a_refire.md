---
type: session
session_id: session_stanley_20260622_git_p6_wave3a_refire
created: 2026-06-22
updated: 2026-06-22
status: active
last_edited_by: agent_stanley
campaign: campaign_git_genesis
phase: P6
mission: mission_p6_fleet_alignment
wave: 3a
persona: hopper
operator: Stanley
tags: [session, campaign, git, genesis, p6, wave3, wave3a, refire, outward, operation_free_harbor, dp5]
---

# Session — R2/P6: REFIRE Wave 3a held-2 (aDNALabs + ScienceStanley)

## Intent / Shape
Operator "continue the campaign" → AskUserQuestion **scope = Fire aDNALabs + SS** (hold Harness + zeta) → ExitPlanMode (`please-read-the-claude-md-pure-canyon.md`) = the **rollout DP5 gate** (scope-limited to the 2 now-clear held graphs). Wave 3a = the class-I internal/proprietary majority that **stays GitHub-private-interim** (ADR-013). Per graph: `git/` wrapper + `## Git-Ops` doctrine + gitleaks pre-push hook + STATE/MANIFEST host-fact → commit → **dogfood push to the EXISTING `github.com/aDNA-Network/<name>` origin** → verify (authed clone OK + anon REFUSED + `gh api .private=true`). **No host move · no Codeberg · no visibility flip · no `rollback` remote · no §C shim.**

## Held-4 live re-check (2026-06-22, after the 3a fire)
| Graph | Branch | Porcelain | Sessions | hooksPath | Disposition |
|---|---|---|---|---|---|
| **aDNALabs** | `main` | 0 (clean) | none | unset | **REFIRE** — staged `aDNALabs.gitleaks.toml` (13 FP); 36 ahead of stale origin |
| **ScienceStanley** | `dev` | 0 (clean) | none | **`how/governance/hooks` (F-W3-c)** | **REFIRE** — own root `.gitleaks.toml` (F-W3-a); place hook at hooksPath; surface `incident_20260528` |
| **Harness** | `master` | 0 (clean) | 68 active | unset | **HOLD** — P7 `s7_stable_go_live_close` `status:active`, touched ~60 min ago (flagship go-live) |
| **zeta** | `main` | **67 dirty** (CLAUDE/STATE/campaigns) | none | unset | **HOLD** — large mid-flight churn |

**Decision (operator):** refire aDNALabs + SS; re-check Harness + zeta next cycle (turnkey when porcelain-clean + sessionless / Harness s7 → `completed`).

## Phase 1 — non-outward prep (DONE)
- Gate prereqs: `gh auth token` → `gho_`/len 40 ✓; dry-run harness **31/31** (no new verb) ✓; Git.aDNA HEAD `e266cdd`.
- Folded **F-W3-c** (+ F-Astro + F-W3-a) into `skill_git_provider_config.md` step 5 — `core.hooksPath`-aware hook install (stale-absolute → unset+symlink; in-repo relative → place/chain at the dir; unset → standard symlink; never assume install-by-presence). Upstreamed via Rosetta later (no `.adna/` edit now).
- Marked `wave3_runbook.md` with the concrete SS as-refiring hook mechanic.
- Phase-1 commit = the wrapper `pinned_at_commit` for the 2 refired graphs.

## As-fired (Phase 2)
_(filled at close)_

## SITREP / Next Session Prompt
_(filled at close)_
