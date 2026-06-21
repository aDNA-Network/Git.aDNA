---
plan_id: p5_codeberg_beachhead
type: plan
title: "P5 — Codeberg Beachhead (turnkey runbook)"
owner: stanley
status: planned
campaign_id: campaign_git_genesis
campaign_phase: 5
campaign_mission_number: 5
mission_class: implementation
created: 2026-06-19
updated: 2026-06-20
last_edited_by: agent_stanley
tags: [plan, campaign, git, genesis, codeberg, beachhead, outward, runbook, operation_free_harbor]
---

# Mission: P5 — Codeberg Beachhead

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor (= [[campaign_gitops_rollout]] **R1**)
**Phase**: 5 — Codeberg Beachhead · **Mission**: 5 of 8 · **The first *outward* phase.**

> **Readiness — TURNKEY, gate-pending (authored 2026-06-20, `session_stanley_20260620_git_p5_prep`).** This runbook is execution-ready: every step names a real skill/verb/path and its gate. **It does not start until the three pre-flight gates below are all green** (Standing Order #1/#2). The dogfood secret-scan gate is **already pre-cleared** (gitleaks 8.30.1, full history, *no leaks* — see Step 4). Status stays `planned` until the operator opens R1 at DP4.

## Goal
Stand up the **Codeberg-FOSS** home and prove the agnostic tooling **live** (no longer dry-run) by giving Git.aDNA + 1–2 low-risk FOSS pilots their Codeberg remotes — Git.aDNA dogfooding the very contract it ships. First operator-authorized outward step toward self-hosted, decentralized git.

## Pre-flight — the three gates (R1 does not start until ALL are green)

| # | Gate | Owner | Artifact | State |
|---|---|---|---|---|
| 1 | Agnostic skills released into `.adna/` (`skill_template_release`) | aDNA.aDNA (Rosetta) | [[coord_draft_adna_skill_upstreaming]] | **QUEUED** |
| 2 | `CODEBERG_TOKEN` provisioned (scopes `write:organization` + `write:repository`; Keychain+1P) | Home.aDNA (Hestia) | [[coord_draft_home_credentials_shims]], [[adr_007_credential_model\|ADR-007]] | **QUEUED** (account exists per operator 2026-06-20; token TBD) |
| 3 | **Decision Point 4** — authorize outward (Codeberg org/teams + first pushes) | operator | this runbook + STATE | **PENDING** |

Tracked in [[coord_delivery_queue]]. Delivering the two staged memos into Rosetta + Hestia is the gated action that turns #1 and #2 green.

## Two sub-decisions to settle AT DP4 (surfaced by P5 prep)

- **SD-1 — Git.aDNA's class/host.** `git/CLAUDE.md` currently declares `host: github.com · visibility: private · class: I`. But Codeberg ToS forbids private/proprietary repos ([[adr_005_visibility_host_policy|ADR-005]] Path B), so Git.aDNA can only be the *Codeberg* dogfood if it is **public/FOSS**. **Recommendation: reclassify Git.aDNA → public, host `codeberg.org`, class P** (matches III; consistent with the open-standards thesis + the "decentralized git as a network product" north star). *If kept private →* its first remote goes to GitHub-interim and a separate FOSS graph becomes the Codeberg dogfood. **This one-field decision drives Steps 1, 4, 6.**
- **SD-2 — Pilot selection.** See Step 5; final pick is the operator's at DP4.

---

## Runbook

### Step 0 — Wire the live dispatch path *(build task; non-outward to author)*
`how/skills/lib/gitops_dispatch.sh` ships a **dry-run-complete** lib whose **live path is a stub** (`_gitops_emit` → `LIVE-STUB[...]`, line ~49 — "P3 keeps live unimplemented"). Before any live verb runs:
- Refactor the 7 verb emitters so that **live mode actually executes** the `gh api` (GitHub) / `curl …/api/v1` (Forgejo) command instead of printing `LIVE-STUB`. Keep dry-run (`GITOPS_DRY_RUN=1`) and the refuse-without-`GITOPS_ALLOW_LIVE` guard exactly as-is.
- Resolve the token by **value** from the env var named by `gitops_token_env_for_host` (e.g. `$CODEBERG_TOKEN`) — used in the `Authorization` header, **never printed/echoed** (ADR-007 / Rule 5/6). Dry-run continues to emit the *name* only.
- Add response handling: non-2xx → fail loud (non-zero), surface the API error body (token-redacted).
- Extend `how/tests/dryrun_gitops.sh` with a **live-smoke** mode (`GITOPS_ALLOW_LIVE=1` against a throwaway repo, e.g. `aDNA-Network/_smoke`: create-repo → push → cut-release → delete). The smoke is **outward** ⇒ runs only after gates #2/#3.
- **Exit:** dry-run harness still **19/19**; live-smoke green against Codeberg.

### Step 1 — Settle SD-1 + finalize the `git/` declaration
Resolve SD-1 (above). Edit `git/CLAUDE.md` `git_provider` to the decided values (recommended: `host: codeberg.org · backend: forgejo · visibility: public · class: P`). Validate via [[skill_git_provider_config]]. *(This edit is local; it's the prerequisite the dogfood reads.)*

### Step 2 — Credentials (consume, never store)
Confirm gate #2: `CODEBERG_TOKEN` present via the Home broker, resolved by the spec §6 host→env map (`codeberg.org → $CODEBERG_TOKEN`). Verify scopes `write:organization` + `write:repository` ([[adr_004_provider_contract_interface|ADR-004]] D5 critical path). Git.aDNA **specifies + consumes**; Home holds (Rule 6).

### Step 3 — Codeberg org/teams
Get-or-create the Codeberg `aDNA-Network` org + teams, mirroring the GitHub layout (partitioned by visibility; coord [[coord_draft_adnalabs_migration_coexistence|Berthier]]). **Note:** `gitops_create_repo` is *repo*-scoped (`POST /orgs/{org}/repos`); **org + team creation is a separate `/api/v1/orgs` + `/api/v1/orgs/{org}/teams` call (or one-time console step)** — document the exact calls here when run. Account exists (operator-confirmed); org likely still to create.

### Step 4 — Dogfood Git.aDNA onto Codeberg *(secret-gate FIRST)*
1. **Secret-scan gate (spec §10):** `gitleaks detect --source . --config git/.gitleaks.toml` over full history — **move blocked unless clean**. ✅ **Pre-cleared 2026-06-20** (10 commits / 2.13 MB / *no leaks*); re-run at execution as the live gate.
2. [[skill_git_remote_setup]] (agnostic): `create-repo` (`aDNA-Network/Git.aDNA`, visibility per SD-1) → `set-remote origin` → `push -u origin <branch> --tags` (verbs via the now-live lib).
3. **Verify:** fresh `git clone` round-trip; branches + tags present; `git remote -v` shows the Codeberg origin. This is the first live proof of the agnostic contract.

### Step 5 — FOSS pilots (1–2, lowest-risk first)
Candidates from [[fleet_git_state]] (final pick = DP4 / SD-2):

| Pilot | Why low-risk | Path exercised |
|---|---|---|
| `TypeScript.aDNA` | **public-intended + local-only** (no remote, genesis P0-pending) → first-remote, nothing to break, no GitHub flip-public needed | create-repo + push (greenfield) |
| `ComfyUI.aDNA` | public-intended (confirm) + local-only → same greenfield profile | create-repo + push |
| `Oration.aDNA` | small forge, OSS-intended; **currently PRIVATE on GitHub** (would need flip-public first) | full migrate ([[skill_repo_migrate]]): scan → `rename origin→rollback` → set-remote → push → emit Home shim |

**Recommendation:** prove the **create+push** path on a greenfield public-intended local-only graph (`TypeScript.aDNA`); defer **existing-graph migrate** (repoint+rollback) to **R2 waves** (where flips-public + name-drift reconciliation are handled in bulk) — or exercise it once here on `Oration.aDNA` if the operator wants the full path covered at the beachhead. Each migrate registers a Home shim entry (spec §4, [[adr_006_remote_naming|ADR-006]] D3).

### Step 6 — One release-mirror (Class R)
Pick a **Codeberg-origin** FOSS graph (push-mirror requires a Forgejo origin — spec §5). Wire `configure-mirror` (`gitops_configure_mirror` → `POST …/push_mirrors`, `sync_on_commit:true`) Codeberg→GitHub via [[skill_release_mirror]]. Cut a tag (`cut-release` via [[skill_vault_publish]]); **verify the tag/release propagates to the GitHub mirror.** Encode the §5 gotchas: change = delete-then-recreate (no in-place); LFS ⇒ HTTPS+PAT.

### Step 7 — Rollback drill *(gates R2)*
Exercise the repoint-back path on the dogfood/pilot: restore `origin` from `rollback` (spec §4), confirm history intact, remove the temporary `rollback` remote. **File a drill report** under `how/tests/` — a green drill is the prerequisite that gates the [[campaign_gitops_rollout]] **R2** fleet waves.

---

## Exit Gate (all required)
- [ ] Codeberg `aDNA-Network` org/teams stood up (GitHub-layout parity).
- [ ] Git.aDNA + 1–2 FOSS pilots live on Codeberg; clone/push round-trip verified.
- [ ] Agnostic skills proven **live** against Forgejo (no longer dry-run); dry-run harness still 19/19; live-smoke green.
- [ ] One release-mirror Codeberg→GitHub round-trips on a tag.
- [ ] Rollback drill passes; drill report filed.
- [ ] Per-move secret-scan gate clean; any Home shim entries registered.
- [ ] AAR written; STATE → R2 Resume-Here.

## Verification
`gitleaks detect` clean per move · `bash how/tests/dryrun_gitops.sh` 19/19 · live-smoke create/push/release/delete on `_smoke` · `git clone` round-trip on each pilot · tag visible on the GitHub mirror · `rollback` restore verified · `git status` clean; no un-gated outward action beyond the DP4-authorized set.

## Campaign Context
- **Prev (P4)**: execution charter [[campaign_gitops_rollout]] ratified + agnostic skills drafted (Rosetta release pending).
- **Next (P6/R2)**: a proven beachhead + green drill report gate the fleet waves; **also unblocks the north-star spike** (R3/R4, in parallel).

## Notes
- **Outward + irreversible** — every Step 3–7 action is operator-gated (DP4). History-scan any pilot before its host move (spec §10).
- **I-strict client graphs** (`CakeHealth`, `PercySleep`, `SuperLeague`, `CakeProtocol`, `MagnaPetra`) are **out of the FOSS beachhead** — they stay GitHub-interim; never Codeberg (ToS), handled at R2 with operator sign-off.

## AAR
*Append before `status: completed`.*
