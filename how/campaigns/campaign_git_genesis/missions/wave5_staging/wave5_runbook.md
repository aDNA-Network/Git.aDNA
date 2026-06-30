---
type: runbook
runbook_id: wave5_runbook
title: "P6 Wave 5 — client / I-strict execution runbook + staged per-graph artifacts (history-scan + operator sign-off)"
created: 2026-06-29
updated: 2026-06-29
status: staged
last_edited_by: agent_stanley
campaign: campaign_git_genesis
phase: P6
wave: 5
binds_adrs: [adr_013, adr_011, adr_008, adr_006, adr_005, adr_004, adr_007, adr_001]
gate: rollout_DP5
coordinates_with: aDNALabs.aDNA   # Berthier — Homecoming/WS-1 program; + Wilhelm-Foundation (partner) for 5d RareArchive
tags: [runbook, wave5, fleet_alignment, client_sensitive, i_strict, history_scan, operator_sign_off, staged, dp5_gated, operation_free_harbor]
---

# P6 Wave 5 — Client / I-strict Execution Runbook + Staged Per-Graph Artifacts

> **STATUS (2026-06-29, non-outward staging — `session_stanley_20260629_git_p6_wave5_staging`): STAGED + pre-cleared; gate-ready, nothing fired.** Wave 5 is the campaign's **most-constrained set** — client / clinical / vendor-founding repos, **all class I-strict** → **GitHub-private (interim) → self-hosted Forgejo post-P7; NEVER Codeberg** ([[what/decisions/adr_013_host_role_inversion|ADR-013]] D2). Per [[what/decisions/adr_011_secret_scanning|ADR-011]] D4 a **fresh full-history `gitleaks detect` MUST pass AND the operator MUST sign off** before any touch — Wave 5 *elevates* that gate from "before any host move" to **before any touch** (F-W5-a). 6 graphs, sub-waved low→high constraint: **5a** greenfield first-remotes (2) · **5b** in-place touches (2) · **5c** held/in-flight (1) · **5d** partner-org coordinated touch (1). Full-history pre-clear done (6 scanned · 4 clean · 2 FP, both allowlisted + re-scanned to 0). **Fire = a separate per-graph rollout DP5 gate with operator scan sign-off** (Standing Order #1/#2) — and for 5d, Wilhelm-Foundation partner coord + ack (#10). Authored in Git.aDNA (Rule 10 — applied into target vaults only at the gate). **STATE.md is the live phase pointer.**

## Wave 5 set — 6 ledger rows · all I-strict · sub-waved (live ground truth)

Re-probed live 2026-06-29 (F-W3-e/F-W4-a discipline — verify actual git state, not the recorded row). The pre-recon ledger assumed several were local-only; ground truth:

- **5a — greenfield first-remotes (2):** `CakeProtocol`, `MagnaPetra`. **Local-only** (no remote), clean, sessionless. **Action:** first GitHub-**private** remote (the Wave-3c GH-private greenfield mechanic — `create-repo`/`set-remote`/`push` to `github.com`/`aDNA-Network`/`private`, **never Codeberg**). Lowest-risk-of-the-wave (short clean history; first publication is the consequential act → scan + sign-off hard-gates it).
- **5b — in-place touch (2):** `SuperLeague`, `CakeHealth`. **Already on `github.com/aDNA-Network/<name>`** (private), clean, sessionless. **Action:** apply artifacts → commit → `gitops_push` to the existing origin (the proven 3a mechanic). No host move, no exposure change. `CakeHealth` origin is **ssh** (F-W4-d push-path) + **clinical data** (history-scan emphasized).
- **5c — held / in-flight (1):** `PercySleep`. Already on `aDNA-Network` (private) but **DIRTY + 2 active sessions** (D5 federated design in flight) → **HELD at the gate** (collision-avoid, prereq #4). Fires as a 5b-style in-place touch when quiet. Its **2 nested external repos are out-of-scope** (below).
- **5d — partner-org coordinated touch (1):** `RareArchive`. Our vault lives in the **partner org** `github.com/Wilhelm-Foundation/rare-archive-vault` (private), clean. **Action:** touch-only / **keep host + keep name** (the `WilhelmAI` precedent, ADR-001 partner-boundary) + **Berthier → Wilhelm-Foundation partner coord + ack** before the touch. Goes **last** (most constrained). Its **nested external upstream is out-of-scope** (below).

> **Out-of-scope / never-touched (documented, not actioned — ADR-005 D7 "external upstreams are never re-homed"; ADR-001):**
> - `PercySleep.aDNA/what/percysleep_code/Percy_Firmware` → `github.com/percysleep/Percy_Firmware` (external `percysleep` org)
> - `PercySleep.aDNA/what/percysleep_code/percy-adapter` → `github.com/percysleep/percy-adapter` (external `percysleep` org)
> - `RareArchive.aDNA/what/rare-archive` → `github.com/Wilhelm-Foundation/rare-archive` (external partner upstream, PUBLIC; ADR-001 out-of-scope)
> Each is a **separate `.git`** with its own origin → not in the parent vault's history (so the parent's full-history scan does not cover them, correctly). `MagnaPetra.aDNA/what/lunarpro-build-kit` is **NOT** a separate repo (monorepo-tracked, in-tree) → it **IS** covered by MagnaPetra's scan.
>
> **NOT in Wave 5:** Class-L declarations (`Home`/`Archive`/`Datasets`-confirm; `DataRoom` already declared Wave-4c). The Wilhelm-Foundation *external* upstream `rare-archive` (vs our `rare-archive-vault`).

## How Wave 5 differs from Waves 1–4

| | Wave 3a (touch) | Wave 4 (code-repo touch) | **Wave 5a (greenfield)** | **Wave 5b/5c (touch)** | **Wave 5d (partner)** |
|---|---|---|---|---|---|
| Class | I | I | **I-strict** | **I-strict** | **I-strict (partner)** |
| Action | push to existing origin | push wrapper into repo | **first GH-private remote** | push to existing origin | touch + partner coord |
| Verbs | `push` | `push` | `create-repo`/`set-remote`/`push` | `push` | `push` (keep host/name) |
| Origin change | no | no | **greenfield (local→GH-priv)** | no | no |
| Host target | GitHub-private | GitHub-private | **GitHub-private (NEVER Codeberg)** | GitHub-private | **stays Wilhelm-Foundation** |
| Scan gate | fresh at gate | fresh at gate | **full-history + operator sign-off (ADR-011 D4)** | **same** | **same** |
| Extra gate | — | Berthier coord | operator sign-off | operator sign-off | **+ partner coord + ack** |
| `rollback`/§C shim | no | no | **no** (greenfield) | no | no (keep host/name) |
| Verify invariant | anon-clone refused | anon-clone refused | anon-clone refused | anon-clone refused | anon-clone refused |
| New verb | none | none | **none** (the 3c GH-priv greenfield trio) | none | none |

**No new lib verb is required for Wave 5.** 5a = the proven Wave-3c greenfield trio (`gitops_create_repo`/`gitops_set_remote`/`gitops_push`) targeting `github.com`/`private`; 5b/5c/5d = `gitops_push` to the existing origin. The dispatch lib stays at dry-run **31/31**, unchanged.

## Pre-clear status (2026-06-29, non-outward; full-history `gitleaks detect`, gitleaks 8.30.1, baseline `Git.aDNA/git/.gitleaks.toml`)

> Point-in-time check (no token, no network). **The gate re-scans each graph fresh at touch (ADR-011 D4 hard gate) AND the operator signs off on the result** — I-strict is non-negotiable: a finding *blocks* the touch ("no push anyway"); remediate per ADR-011 D5 (`git-filter-repo`/BFG purge → rotate via Home.aDNA broker → re-scan → re-approve).

| Graph | Sub | Origin (live) | Branch | Commits | Scan |
|---|---|---|---|---|---|
| `CakeProtocol.aDNA` | 5a | — (local-only) | `master` | 28 | ✅ clean (baseline) · first-remote GH-priv |
| `MagnaPetra.aDNA` | 5a | — (local-only) | `master` | 5 | ✅ clean (baseline; incl. in-tree `lunarpro-build-kit`) · first-remote GH-priv |
| `SuperLeague.aDNA` | 5b | `github.com/aDNA-Network/SuperLeague.aDNA` | `master` | 416 | ⚠️→✅ 1 FP (`coord_<date>_<slug>.md` filename in governance prose → `generic-api-key`) → `superleague.gitleaks.toml` ✅ re-scan 0 |
| `CakeHealth.aDNA` | 5b | `git@github.com:aDNA-Network/CakeHealth.aDNA` (**ssh**) | `main` | 16 | ✅ clean (baseline) · **clinical data** · ssh push (F-W4-d) |
| `PercySleep.aDNA` | 5c | `github.com/aDNA-Network/PercySleep.aDNA` | `master` | 81 | ⚠️→✅ 1 FP (ssh-ed25519 **public** key in an ops paste → `generic-api-key`) → `percysleep.gitleaks.toml` ✅ re-scan 0 · **HELD** (dirty + 2 active sessions) |
| `RareArchive.aDNA` | 5d | `github.com/Wilhelm-Foundation/rare-archive-vault` | `main` | 97 | ✅ clean (baseline) · **partner-org (STAYS)** · partner coord |

**Scan summary:** 6 scanned · 4 clean · 2 FP (SuperLeague 1 / PercySleep 1) — **all triaged false-positive, no real secret**; 2 allowlists staged + **validated** (each re-scans to 0). None has its own root `.gitleaks.toml` (no F-W3-a). `trufflehog` (the ADR-011 D1 optional deep/verified-secret adjunct for I-strict) is **not installed** on this node → offered as an install-on-request deeper pass for `CakeHealth` (clinical) + the client graphs at the gate; gitleaks (tool-of-record) is the binding gate.

## Findings (→ p6 AAR + fast-follow)
- **F-W5-a (I-strict scan-gate elevation — before-any-touch):** ADR-011 D4 triggers the mandatory full-history scan "before ANY host move." Wave 5's set is class I-strict (client/clinical), where the ledger header + ADR-005 D7 require "history-scan before any move … go last." **Encoded stance:** for Wave-5 I-strict, the full-history scan **+ operator sign-off** is mandatory before **any touch** (not only host moves) — including the 5b/5c/5d in-place touches that don't change origin. Defensible (strictly stronger than D4); documented so the gate is unambiguous. Candidate clarification for ADR-011 / Rosetta `skill_git_provider_config`.
- **F-W5-b (ssh-ed25519 *public*-key FP is fleet-wide):** `AAAAC3NzaC1lZDI1NTE5…` (the base64 body of an ssh-ed25519 **public** key) trips `generic-api-key` in ops/inventory docs (PercySleep here; latent fleet-wide wherever authorized_keys / SSH pastes live). A public key is not a secret. This is the **public-key sibling of F-W4-b** (`Ed25519PrivateKey` annotation). **Candidate for the Git.aDNA baseline allowlist** (`AAAAC3NzaC1lZDI1NTE5[A-Za-z0-9+/=]+`), like the `^\.obsidian/plugins/` fold (F-W3-b). Deferred — baseline edit is its own decision (Rosetta `.adna/` release).
- **F-W5-c (`coord_<date>_<slug>.md` filename FP):** long aDNA coordination-doc filenames in backtick prose (`coord_2026-06-13_sws_l1_health_precondition.md`) trip `generic-api-key`. Per-graph allowlist is correct here (governance-prose-specific); watch whether it recurs fleet-wide before any baseline fold.
- **F-W4-d (ssh remote push) recurs:** `CakeHealth` origin is `git@github.com:…` (ssh). At the gate either push over ssh natively (operator key) or temporarily set an HTTPS origin for the dogfood `gitops_push` (the `latlab-lab` precedent). The touch pushes to the **existing** origin (no new remote), so the operator already holds access.

## Prerequisites at the gate
1. **Operator sign-off on the fresh full-history scan, per graph (ADR-011 D4 — I-strict).** This is the binding extra gate for Wave 5: the operator reviews the scan result and authorizes before the touch. A finding blocks the touch — no override.
2. **`GITHUB_TOKEN`** exported (`export GITHUB_TOKEN="$(gh auth token)"`; Home.aDNA broker) + `export GITOPS_ALLOW_LIVE=1`.
3. `source ~/aDNA/Git.aDNA/how/skills/lib/gitops_dispatch.sh` (dry-run **31/31**; no new verb).
4. **Fresh full-history `gitleaks detect` → clean** per graph at the moment of touch (FP graphs use their staged allowlist; clean graphs use baseline). Re-run even though pre-cleared (the tree/history can move).
5. **Porcelain-clean + no active session** in the target vault (collision-avoid; F-W3-d dual-check before apply AND before commit). **`PercySleep` is HELD until quiet.**
6. **Per-graph `core.hooksPath` sweep** (Astro F-Astro / F-W3-c): `git config --get core.hooksPath` — must be empty or the in-repo relative path; unset stale absolutes; if a hooksPath is set, place/chain the gitleaks hook there (don't blind-symlink `.git/hooks/`).
7. **5d only:** Berthier → **Wilhelm-Foundation partner coord delivered + ack'd** ([[berthier_wave5_coord]]) **before** the `RareArchive` touch; `org: Wilhelm-Foundation` in its `git/CLAUDE.md`; **keep host + keep name**.
8. **5a only:** greenfield first-remote is **GitHub-private** (`gitops_create_repo github.com aDNA-Network <G> private`) — **never Codeberg** (I-strict, ADR-013 D2).

---

## Staged artifact: the I-strict `git/CLAUDE.md` template

Every Wave-5 graph `G` gets this wrapper (fill `origin`/`branch` from the value tables; `pinned_at_commit` = Git.aDNA HEAD at apply, **currently `cada676`** — re-pin if it advances by the gate). Per-sub-wave deltas noted inline.

```yaml
---
type: wrapper
wrapper: git
created: 2026-06-29
updated: 2026-06-29
status: active
last_edited_by: agent_stanley
tags: [wrapper, git, federation, git_provider, i_strict, wave5]
---

# `git/` — G.aDNA consumer wrapper (federates Git.aDNA)

federation_ref:
  source_vault: Git.aDNA
  source_skill: how/skills/skill_git_provider_config.md
  version: "0.1.0"
  version_policy: minor
  pinned_at_commit: "cada676"          # Git.aDNA HEAD at apply (re-pin if it advances by the gate)
  binds_adrs: [adr_004, adr_006, adr_007, adr_008, adr_011, adr_013]
  verbs_exposed: [create-repo, set-remote, push, open-pr, cut-release, configure-mirror, port-ci]
  local_extensions: []                 # I-strict may ship a stricter per-repo .gitleaks.toml (local wins)
git_provider:
  host: github.com                     # 5d RareArchive: github.com (Wilhelm-Foundation) — stays
  backend: github
  org: aDNA-Network                    # 5d RareArchive = Wilhelm-Foundation (partner-org, stays)
  visibility: private                  # I-strict — GitHub-private-interim → self-hosted Forgejo post-P7 (ADR-013); NEVER Codeberg
  class: I-strict
  lfs: false
  remotes:
    origin: https://github.com/aDNA-Network/G.aDNA.git   # 5a: set at first-remote; 5d: Wilhelm-Foundation/rare-archive-vault
    mirror:                            # n/a (I-strict; no release mirror)
    upstream:                          # 5c/5d: external nested repos are NOT remapped here (out-of-scope, ADR-005 D7)
```

**Doctrine paste:** the canonical [[doctrine_gitops_block]] fenced block (ADR-013 v., 7 items) under a `## Git-Ops` heading in `G/CLAUDE.md`.
**Hook:** copy `Git.aDNA/git/hooks/` (+ the staged `git/.gitleaks.toml` for SuperLeague/PercySleep; baseline for the rest) into `G/git/`, then symlink `.git/hooks/pre-push` (place/chain if `core.hooksPath` is set — F-W3-c).
**CI parity (ADR-008):** install the portable `.github/workflows/ci.yml` (gitleaks + lint); align, don't clobber, if present.
**STATE/MANIFEST patch:** record the host fact — 5a: the new first-remote; 5b/5c: the unchanged origin (declared); 5d: the partner-org host (stays).

---

## Sub-wave 5a — greenfield first-remote (2; local-only → GitHub-private)

> **Operator signs off on the fresh full-history scan first (prereq #1).** First-remote is **GitHub-private** (never Codeberg — I-strict). The Wave-3c greenfield mechanic, targeting `github.com`/`private`.

```bash
cd ~/aDNA/<G>
# 0. pre-flight: porcelain-clean, sessionless, hooksPath sweep
git status --porcelain && git config --get core.hooksPath
# 1. fresh full-history scan (HARD GATE) → operator sign-off
gitleaks detect --source . --config ~/aDNA/Git.aDNA/git/.gitleaks.toml --redact --no-banner   # exit 0 required
# 2. apply artifacts: git/CLAUDE.md (I-strict, origin set below) + ## Git-Ops + hook + baseline git/.gitleaks.toml + CI + STATE/MANIFEST host-fact
git add -A && git commit -m "feat(git): Wave-5 git/ wrapper + Git-Ops doctrine + first-remote (GitHub-private, class I-strict)"
# 3. greenfield first-remote (GH-private) — operator-confirmed
export GITHUB_TOKEN="$(gh auth token)"; export GITOPS_ALLOW_LIVE=1
source ~/aDNA/Git.aDNA/how/skills/lib/gitops_dispatch.sh
gitops_create_repo github.com aDNA-Network <G> private
gitops_set_remote  github.com aDNA-Network <G> origin
gitops_push <branch>                 # pre-push hook fires live
# 4. verify: gh api → private:true; authed clone OK (git/ + ## Git-Ops; HEAD match); anon-clone REFUSED
# 5. NO §C shim (greenfield); NO rollback remote
```
| Graph | Branch | `cfg` | Notes |
|---|---|---|---|
| `CakeProtocol.aDNA` | `master` | baseline | **canary** (cleanest greenfield; 28c clean); local→`aDNA-Network/CakeProtocol.aDNA` private |
| `MagnaPetra.aDNA` | `master` | baseline | local→`aDNA-Network/MagnaPetra.aDNA` private; scan covers in-tree `lunarpro-build-kit` (vendor build-kit; 5c clean) |

---

## Sub-wave 5b — in-place touch (2; existing GitHub-private origin)

> **Operator signs off on the fresh full-history scan first (prereq #1).** No host move, no exposure change — apply artifacts, commit, push to the existing origin (the 3a mechanic).

```bash
cd ~/aDNA/<G>
git status --porcelain && git config --get core.hooksPath
gitleaks detect --source . --config <baseline|staged> --redact --no-banner   # exit 0 → operator sign-off
# apply artifacts (wrapper + ## Git-Ops + hook + git/.gitleaks.toml [staged for SuperLeague] + CI + host-fact) → commit
git add -A && git commit -m "feat(git): Wave-5 git/ wrapper + Git-Ops doctrine (GitHub-private, class I-strict; in-place touch)"
export GITHUB_TOKEN="$(gh auth token)"; export GITOPS_ALLOW_LIVE=1
source ~/aDNA/Git.aDNA/how/skills/lib/gitops_dispatch.sh
gitops_push <branch>                 # CakeHealth: ssh origin (F-W4-d) — push over ssh or temp-set https for the dogfood
# verify: authed clone (git/ + ## Git-Ops; HEAD match); anon-clone REFUSED (private invariant); NO §C shim
```
| Graph | Branch | `cfg` | Notes |
|---|---|---|---|
| `SuperLeague.aDNA` | `master` | staged `superleague.gitleaks.toml` | client/org-graph; 416c; coord-filename FP allowlisted |
| `CakeHealth.aDNA` | `main` | baseline | **clinical data** — emphasize the history-scan + offer trufflehog; **ssh origin** (F-W4-d push path) |

---

## Sub-wave 5c — held / in-flight (1): `PercySleep`

**HELD at the gate** (prereq #4) — dirty tree + 2 active sessions (D5 federated design, `session_2026-06-29_phantasos_d5_*`). Fires as a 5b-style in-place touch (existing `aDNA-Network/PercySleep.aDNA` origin) **when quiet**; `percysleep.gitleaks.toml` (ssh-pubkey FP allowlisted). The 2 nested external `percysleep`-org repos are **out-of-scope** (not touched, not remapped — ADR-005 D7). Re-verify clean + sessionless at the gate (read-at-use, F-W3-d).

---

## Sub-wave 5d — partner-org coordinated touch (1): `RareArchive`

> **Touch-only / keep host + keep name** (the `WilhelmAI` precedent; ADR-001 partner-boundary). Goes **last** (most constrained). Our vault stays at `github.com/Wilhelm-Foundation/rare-archive-vault` (private) — **no rename, no transfer, no host move**. **Berthier → Wilhelm-Foundation partner coord delivered + ack'd** ([[berthier_wave5_coord]]) **before** the touch.

```bash
cd ~/aDNA/RareArchive.aDNA
git status --porcelain && git config --get core.hooksPath
gitleaks detect --source . --config ~/aDNA/Git.aDNA/git/.gitleaks.toml --redact --no-banner   # exit 0 → operator sign-off
# apply artifacts with org: Wilhelm-Foundation (keep name rare-archive-vault); ## Git-Ops; hook; CI; host-fact
git add -A && git commit -m "feat(git): Wave-5 git/ wrapper + Git-Ops doctrine (Wilhelm-Foundation partner-org, class I-strict; touch-only/keep-name)"
gitops_push main                      # to the existing Wilhelm-Foundation origin (partner-coord ack'd)
# verify: authed clone OK; anon-clone REFUSED (private); the nested what/rare-archive (external upstream) UNTOUCHED
```
- Nested `what/rare-archive` → `Wilhelm-Foundation/rare-archive` (external upstream, PUBLIC) is **out-of-scope** (ADR-001) — verify it is left untouched (separate `.git`, not in the vault's history).

---

## Apply-order at the gate
1. **5a first** (lowest risk) — **canary `CakeProtocol`** (clean greenfield) → operator scan sign-off → first-remote GH-priv → verify (anon-refused) → then `MagnaPetra`.
2. **5b** — `SuperLeague` then `CakeHealth` (clinical; offer trufflehog) — each: scan sign-off → touch+push to existing origin → verify.
3. **5c `PercySleep`** — only when porcelain-clean + sessionless (re-verify live).
4. **5d `RareArchive`** — Wilhelm-Foundation partner coord delivered + ack'd → scan sign-off → touch-only/keep-name push.
5. Flip each ledger row to ✅; update Git.aDNA STATE; Home registers **no** new §C shim (5a greenfield / 5b/5c/5d origin-unchanged) — record the 5a first-remotes + any `legacy` notes (Rule 9).
**Nothing here runs without the per-graph DP5 gate + operator scan sign-off** (Standing Order #1/#2; ADR-011 D4) — and 5d also needs Wilhelm-Foundation coord (#10). Per-graph, scope-limited, like every prior wave.

## Staged allowlists (this dir)
- `superleague.gitleaks.toml` — baseline + `coord_\d{4}-\d{2}-\d{2}_[A-Za-z0-9_]+\.md` (F-W5-c coord-filename FP). ✅ validated clean.
- `percysleep.gitleaks.toml` — baseline + `AAAAC3NzaC1lZDI1NTE5[A-Za-z0-9+/=]+` (F-W5-b ssh-ed25519 public-key FP). ✅ validated clean.
- `CakeProtocol` / `MagnaPetra` / `CakeHealth` / `RareArchive` — **no staged file** (clean under the baseline `git/.gitleaks.toml`).
