---
type: test_report
report_id: drill_report_p5_beachhead_20260620
title: "Rollback Drill Report — P5 Beachhead (repoint-back mechanic)"
created: 2026-06-20
updated: 2026-06-20
status: pass
last_edited_by: agent_stanley
campaign_id: campaign_git_genesis
mission_id: p5_codeberg_beachhead
binds: [adr_006_remote_naming, spec_gitops_provider_abstraction]
tags: [test, drill, rollback, p5, beachhead, gates_r2, operation_free_harbor]
---

# Rollback Drill — P5 Beachhead

**Result: PASS.** Gates the [[campaign_gitops_rollout]] R2 fleet waves (a green repoint-back path is the R2 prerequisite).

## What was exercised
The migrate repoint-back mechanic (spec §4 / [[adr_006_remote_naming|ADR-006]] D3): during a host migration the old origin is preserved as `rollback`; if the migration must be undone, `rollback` is restored to `origin`. Run **locally** on `Git.aDNA` (remote-config only — no pushes, no outward calls).

## Steps & evidence
| # | Action | Result |
|---|---|---|
| 0 | baseline | `origin=https://github.com/aDNA-Network/Git.aDNA.git`, HEAD `495b6b3` |
| 1 | `git remote rename origin rollback` + add simulated new `origin` (codeberg URL, config only) | `origin=codeberg…`, `rollback=github…` (old preserved) |
| 2 | rollback: `git remote remove origin` + `git remote rename rollback origin` | `origin` restored to `github…`, HEAD `495b6b3` (unchanged), no `rollback` remote left |

**Assertions (all true):** restored origin == original · HEAD unchanged (history intact) · temp `rollback` remote removed.

## Notes
- Drill used `Git.aDNA` itself (GitHub-public origin under [[adr_013_host_role_inversion|ADR-013]]). The mechanic is host-agnostic — identical for a Codeberg-origin graph.
- Real fleet migrations (R2) additionally register each repoint in the **Home.aDNA shim registry** (Rule 9) with class · window · retire-condition · owner; this drill validates the local git mechanic only.
- Live verb auth was separately validated this session (Git.aDNA→GitHub push; TypeScript.aDNA→Codeberg push; `_smoke` round-trip) — see the session SITREP for the per-backend auth findings.
