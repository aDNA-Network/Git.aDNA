---
plan_id: mission_p0_meta_planning
type: plan
title: "P0 — Meta-Planning & Charter"
owner: stanley
status: completed
campaign_id: campaign_git_genesis
campaign_phase: 0
campaign_mission_number: 0
mission_class: meta_planning
created: 2026-06-19
updated: 2026-06-19
last_edited_by: agent_stanley
tags: [plan, campaign, git, genesis, meta_planning, operation_free_harbor]
---

# Mission: P0 — Meta-Planning & Charter

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 0 — Meta-Planning & Charter
**Mission**: 0 of 8

## Goal

Genesis `Git.aDNA` from `.adna/` and author the complete P0 package — identity/framing ADRs, the extended-campaign charter, and the P1–P8 mission decomposition — **plan-first / gated-execution**: produce the proposals and the decomposed "multiple sessions," then stop at an operator charter gate. No outward or irreversible action (no remotes, no pushes, no `.adna/` edits). This is the "planning session that builds out multiple sessions" the operator chartered.

## Exit Gate

Operator **APPROVE / REVISE / HOLD** of the charter + ADRs 000–003. All of: graph genesis'd (legs · STATE · CLAUDE · MANIFEST · local git); 4 framing ADRs authored (`proposed`); `campaign_git_genesis.md` + P0 mission + P1–P8 stubs present with exit gates + dependencies; 4 coord memos staged; router row staged; AAR appended; **`git remote -v` empty + `.adna/` untouched**. On APPROVE → ADRs flip `accepted`, router row inserts, P1 opens.

## Objectives

### 1. Genesis the graph + triage the seed-staging dir
- **Status**: completed
- **Session**: session_stanley_20260619_git_genesis_p0
- **Description**: Fork `.adna/` structure into the existing `Git.aDNA/` (preserve seed); clean template artifacts; `git init`. Triage the mislabeled `AGENTS.md` (a **zip blob**, byte-redundant with `files.zip`) + `files.zip` → preserve as intake provenance at `_seed_intake/`.
- **Files**: `who/ what/ how/` legs · `.git` · `_seed_intake/{seed_set_files.zip, agents_md_zip_blob.bin}`
- **Depends on**: none

### 2. Fold seed docs into canonical homes (bannered)
- **Status**: completed
- **Session**: session_stanley_20260619_git_genesis_p0
- **Description**: Relocate + lowercase-rename the 6 seed docs; prepend agnostic-reframe banners to the 4 canonical-home docs; keep 04/05 in `_seed/`. Archive inherited template ADRs.
- **Files**: `what/architecture/architecture_forge_seed.md` · `what/requirements/requirements_forge_seed.md` · `what/doctrine/{charter,migration_doctrine}_*_seed.md` · `what/architecture/_seed/{vault_spec,build_prompt}_seed.md` · `what/decisions/_archive/*`
- **Depends on**: 1

### 3. Author the operational trio (STATE · CLAUDE · MANIFEST)
- **Status**: completed
- **Session**: session_stanley_20260619_git_genesis_p0
- **Description**: STATE (phase ladder · carried facts · live git landscape · intake log), CLAUDE (Hopper identity · Standing Orders · genesis pointer), MANIFEST (Framework identity · architecture).
- **Files**: `STATE.md` · `CLAUDE.md` · `MANIFEST.md`
- **Depends on**: 1

### 4. Author the 4 framing ADRs (proposed)
- **Status**: completed
- **Session**: session_stanley_20260619_git_genesis_p0
- **Description**: ADR-000 identity (name · **Framework reframe** · **Hopper** · scope · codename) · ADR-001 seed reframe (adopt-and-generalize; clause table) · ADR-002 provider abstraction (contract over GitHub-API + Forgejo-API) · ADR-003 visibility split (Codeberg-private / GitHub-public).
- **Files**: `what/decisions/adr_000..003_*.md`
- **Depends on**: 1

### 5. Author the campaign charter + P1–P8 mission stubs
- **Status**: completed
- **Session**: session_stanley_20260619_git_genesis_p0
- **Description**: `campaign_git_genesis.md` (P0–P8 ladder · risk register · verification) + this P0 mission + the 8 stubs (each: goal · exit gate · objectives sketch · dependencies · AAR placeholder) — the "multiple sessions."
- **Files**: `campaign_git_genesis.md` · `missions/mission_p0_meta_planning.md` · `missions/p1_*..p8_*.md`
- **Depends on**: 4

### 6. Stage coordination memos + router row
- **Status**: completed
- **Session**: session_stanley_20260619_git_genesis_p0
- **Description**: Draft (not deliver) 4 coord memos — aDNA.aDNA (skill upstreaming), aDNALabs.aDNA (migration-program coexistence), Network.aDNA (mesh-git), Home.aDNA (credentials + shim registry). Stage the root-CLAUDE.md router-row text (incl. Platform→Framework reframe).
- **Files**: `coordination_drafts/*.md` · `who/coordination/coord_2026_06_19_fork_provenance.md`
- **Depends on**: 4

### 7. Local first commit + no-outward-action proof
- **Status**: completed
- **Session**: session_stanley_20260619_git_genesis_p0
- **Description**: `git add` + first commit (local only). Verify `git remote -v` empty; `.adna/` untouched (`git -C .adna status` clean); nothing pushed.
- **Files**: (commit)
- **Depends on**: 1,2,3,4,5,6

### 8. AAR + present the charter gate
- **Status**: completed
- **Session**: session_stanley_20260619_git_genesis_p0
- **Description**: Append the AAR; present charter + ADRs for operator APPROVE/REVISE/HOLD, surfacing the 3 named decisions (Framework reframe · Hopper · codename).
- **Files**: this file · operator gate
- **Depends on**: 7

## Campaign Context

### Previous Mission Outputs
- The approved plan `~/.claude/plans/please-read-the-claude-md-buzzing-treehouse.md` (genesis approach + locked Q1–Q3 decisions) + the 3 parallel exploration reports (Git.aDNA state · cross-fleet git-ops · campaign/dialect patterns).

### Next Mission Inputs
- **P1** needs: the ratified ADRs (host/visibility model), the campaign charter, and the `STATE.md` "live git landscape" table as the seed for the fleet inventory + the provider-tooling SOTA queue.

## Notes

- Genesis + P0 were performed in **one session** (per the approved plan's "plan-first/gated execution"), unlike Warp's fork-then-separate-P0 split — so ADRs are authored `proposed` this session and ratified at the closing gate, not carried from a prior fork.
- The Lighthouse seed set is **adopted-and-generalized**, not superseded — its Forgejo bet is *validated* by Codeberg (hosted Forgejo). See [[adr_001_seed_docs_reframe]].

## Completion Summary

*Fill out when setting `status: completed`.*

### Deliverables
- Genesis graph (legs · STATE · CLAUDE · MANIFEST · local git) · 4 framing ADRs · campaign charter · P0 mission · 8 P1–P8 stubs · 4 coord memos · staged router row.

### Descoped
- (none — all P0 objectives in scope)

### Key Findings
- The pre-genesis `AGENTS.md` was a mislabeled zip blob; the seed set's Forgejo bet is the reconciliation key (Codeberg = hosted Forgejo).

### Scope Changes
- Proposed **category reframe** Platform→Framework (operator ratifies at gate) — beyond the router's provisional ruling.

## AAR

*Session AAR (2026-06-19). Mission `completed` at the P0 charter gate — operator APPROVE 2026-06-19.*

- **Worked**: Genesis + the full P0 package (4 ADRs · charter · P0 mission · 8 stubs · 4 coord memos · staged router row) authored in one session; the same-day `Warp.aDNA` twin gave an exact dialect template; the **Codeberg-runs-Forgejo** reconciliation collapsed the agnostic problem to **2 backends** and *validated* (not invalidated) the seed set's Forgejo bet.
- **Didn't**: The pre-genesis dir carried a **mislabeled zip blob** (`AGENTS.md`) byte-redundant with `files.zip` (triaged → intake provenance); the seed set **over-scoped** to a whole node stack (forge+identity+mesh+collab+inference) and had to be narrowed to git/forge/CI-CD before authoring could be clean.
- **Finding**: The seed set's "self-hosted canonical" thesis and the operator's "agnostic" mandate are **not opposed** — the provider abstraction is simultaneously the *freedom layer* (host-choice forever) **and** the *north-star on-ramp* (a subnet re-points Codeberg→lighthouse in one field).
- **Change**: Surface the **Platform→Framework category reframe** explicitly as a gate decision rather than silently inheriting the router's provisional ruling (ADR-000 D2).
- **Follow-up**: Operator **charter gate** → on APPROVE: flip ADRs 000–003 `accepted`, insert the router row (Hestia/PT ack), open **P1** (`p1_research_fleet_inventory`).
