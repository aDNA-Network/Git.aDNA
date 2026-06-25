---
type: runbook
runbook_id: wave3_runbook
title: "P6 Wave 3 — internal touch-only execution runbook + staged per-graph artifacts"
created: 2026-06-22
updated: 2026-06-22
status: staged
last_edited_by: agent_stanley
campaign: campaign_git_genesis
phase: P6
wave: 3
binds_adrs: [adr_013, adr_006, adr_011, adr_004]
gate: rollout_DP5
tags: [runbook, wave3, fleet_alignment, internal_touch, staged, dp5_gated, operation_free_harbor]
---

# P6 Wave 3 — Execution Runbook + Staged Per-Graph Artifacts (Internal Touch-Only)

> **STATUS: 3a ✅ FIRED 2026-06-22 (8/12 fired · 4 held — `session_stanley_20260622_git_p6_wave3a_fire`); 3b PARTIAL ✅ 2026-06-24 (3/5 drift fired: `Operations`·`VAAS`·`LatticeProtocol` → GitHub-native in-org renames, private, redirects ✓; `TappProtocol` held-live-Mentor, `Lab` held-dirty; cross-org/partner pending — `session_stanley_20260624_git_p6_wave3b_drift`); 3c gate-ready, not fired.** Fired: `AWSBootstrap`·`Context`·`Terminal`·`WorldGenome`·`ZenZachary`·`Obsidian`·`wga`·`Network` (GitHub-private in-place; hook clean; anon-refused; F-W3-a live on Network). Held (collision-avoid, prereq #4): `aDNALabs`·`zeta`·`Harness`·`ScienceStanley` (the last also needs F-W3-c hooksPath handling). See the disposition ledger "3a AS-FIRED" block + STATE callout. Wave 3 = the **class-I internal/proprietary majority** that **stays GitHub-private-interim** (until self-hosted post-P7; ADR-013). P6 gives each graph only the `git/` declaration + `## Git-Ops` doctrine block + gitleaks hook + STATE/MANIFEST host-fact. **No host move, no Codeberg, no visibility flip** for the pure set. This is the single source for the Wave-3 firing — per graph: the ready-to-write `git/CLAUDE.md`, the doctrine-paste target, the `gitops_*` sequence, verify steps, allowlist handling, and STATE/MANIFEST patch. Authored in Git.aDNA (Rule 10 — applied into target vaults only at the gate). Pre-cleared per the scans below. **Fire = a separate rollout DP5 gate** (Standing Order #1).

## Wave 3 set — 24 ledger rows · `Astro` ✅ done · **23 remaining**, sub-waved

Wave 3 is **heterogeneous** (unlike the uniform Wave 1/2). Sub-waved lowest-risk-first, mirroring 1a/1b:

- **3a — pure touch (12):** `aDNALabs`, `Harness`, `Context`, `Network`, `Terminal`, `Obsidian`, `WorldGenome`, `ZenZachary`, `zeta`, `wga`, `AWSBootstrap`, `ScienceStanley`. Already on `github.com/aDNA-Network/<name>` (name matches), private. **Action:** apply artifacts → commit → `gitops_push` to the existing origin. **Lowest-risk outward action in the campaign** — no host move, no exposure, no visibility change.
- **3b — name-drift + cross-org reconcile (8):** drift (repo ≠ dirname, same org) `LatticeProtocol`(`latticeprotocol-adna`), `Lab`(`lab-adna`), `Operations`(`TaskForge.aDNA`), `TappProtocol`(`TappInterface.aDNA`), `VAAS`(`VAASLattice.aDNA`); cross-org `ContextCommons`(`LatticeProtocol`→`aDNA-Network`), `LAVentureGraph`(personal `ScienceStanley/LAStartupLattice`→`aDNA-Network`, +drift), `WilhelmAI`(`Wilhelm-Foundation/WilhelmAI` — **stays** partner-org, +drift). **Action:** touch (as 3a) **+** GitHub-native rename/transfer (the Astro precedent) → **Berthier coord**.
- **3c — local-only / first-remote, operator-decision (3):** `RemoteControl`, `Warp`, `ComfyUI`. **Action:** first GitHub-**private** remote (the Wave-1a greenfield trio, but to `github.com` not `codeberg.org`) **or** stay class L — **operator confirms at the gate**.

> **`Astro.aDNA` ✅ DONE 2026-06-22** (reclassified W2→W3; GitHub-native cross-org transfer+rename, kept private, HEAD `0d0c315`; wrapper+doctrine+hook+host-fact applied; §C native-transfer shim). Not re-touched.
> **NOT in Wave 3:** Wave 4 nested code-as-WHAT repos (`Harness/what/harness`, `Context/what/contextscope`, `Lab/what/{lab,lab-workspace}`, `LatticeProtocol/what/latticeprotocol`, …) — own remotes, independent; Wave 5 client/I-strict (`SuperLeague`/`CakeHealth`/`PercySleep`/`CakeProtocol`/`MagnaPetra`/`RareArchive`); Class L declarations (`Home`/`DataRoom`/`Archive`/`Datasets`-confirm).

## How Wave 3 differs from Wave 1 & 2

| | Wave 1 (private moves) | Wave 2 (public flips) | **Wave 3a/3c (touch / first-remote)** | **Wave 3b (reconcile)** |
|---|---|---|---|---|
| Action | host-move → Codeberg-private | visibility-flip → GitHub-public | stay put (3a) / first GH-priv remote (3c) | touch + GitHub-native rename/transfer |
| Verbs | `create-repo`/`set-remote`/`push` | `set-visibility` | 3a: `push` only · 3c: `create-repo`/`set-remote`/`push` | `push` + GitHub-native `gh repo rename` / API transfer |
| Origin change | yes (Codeberg) | no | 3a: no · 3c: greenfield | yes (rename/transfer, same provider) |
| `rollback` remote / §C shim | yes (30d) | no | **no** (origin unchanged / greenfield) | **no `rollback` remote** — Astro native-transfer/redirect sub-class (rollback = re-transfer) |
| Secret-scan | pre-clear + fresh at gate | fresh at gate (hard) | **fresh full-history at gate (hard; ADR-011)** | same |
| Verify invariant | anon-clone **refused** (private) | anon-clone **succeeds** (public) | anon-clone **refused** (private) | anon-clone **refused** (private) |
| New verb needed | — | `set-visibility` | **none** (lib complete; dry-run 31/31) | **none** (rename/transfer is GitHub-native) |

**No new lib verb is required for Wave 3.** 3a = `gitops_push`; 3c = the Wave-1a greenfield trio targeting `github.com`/`private`; 3b rename/transfer is GitHub-native (the proven Astro mechanic). The dispatch lib stays at dry-run **31/31**, unchanged.

## Pre-clear status (2026-06-22, non-outward; baseline `Git.aDNA/git/.gitleaks.toml`)

> Point-in-time check (no token, no network). **The gate re-scans each graph fresh at fire time** (ADR-011 hard gate) — the pre-push hook runs live on the artifact commit even though Wave 3 has no public exposure.

| Graph | Sub | Origin | Branch | Scan |
|---|---|---|---|---|
| `aDNALabs.aDNA` | 3a | `github.com/aDNA-Network/aDNALabs.aDNA` | `main` | ⚠️→✅ 13 FP (`.obsidian/plugins/*.js` + `access-grant` prose + `signing_key_path`) → allowlist staged |
| `Harness.aDNA` | 3a | `github.com/aDNA-Network/Harness.aDNA` | `master` | ✅ clean (+nested W4) |
| `Context.aDNA` | 3a | `github.com/aDNA-Network/Context.aDNA` | `master` | ✅ clean (+nested W4) |
| `Network.aDNA` | 3a | `github.com/aDNA-Network/Network.aDNA` | `main` | ⚠️→✅ 23 FP (`Ed25519PrivateKey` class-name + `evt_<hex>` + `cert_sha256` + `signing_key_type`) → **clean under Network's OWN `.gitleaks.toml`** (F-W3-a). **⚠️ COLLISION-FLAG:** active concurrent Venus session observed 2026-06-22 (`session_..._s181_cutover01_execution`, dirty tree) → **collision-hold at the gate** (re-check porcelain + sessionless at fire, the Molecules precedent) |
| `Terminal.aDNA` | 3a | `github.com/aDNA-Network/Terminal.aDNA` | `master` | ✅ clean |
| `Obsidian.aDNA` | 3a | `github.com/aDNA-Network/Obsidian.aDNA` | `master` | ⚠️→✅ 1 FP (`.metadata-property-key` CSS selector in `iii/*.jsonl`) → allowlist staged |
| `WorldGenome.aDNA` | 3a | `github.com/aDNA-Network/WorldGenome.aDNA` | `main` | ✅ clean |
| `ZenZachary.aDNA` | 3a | `github.com/aDNA-Network/ZenZachary.aDNA` | `main` | ✅ clean |
| `zeta.aDNA` | 3a | `github.com/aDNA-Network/zeta.aDNA` | `main` | ✅ clean |
| `wga.aDNA` | 3a | `github.com/aDNA-Network/wga.aDNA` | `main` | ✅ clean (has CI) |
| `AWSBootstrap.aDNA` | 3a | `github.com/aDNA-Network/AWSBootstrap.aDNA` | `main` | ✅ clean |
| `ScienceStanley.aDNA` | 3a | `github.com/aDNA-Network/ScienceStanley.aDNA` | **`dev`** | ⚠️→✅ 11 FP (`.obsidian/plugins/*.js`) → **clean under SS's OWN `.gitleaks.toml`** (F-W3-a); ⚠ SS config has a **known operator-deferred** `incident_20260528` Vercel-token item — surface at the gate; **branch `dev`**; has CI (`preflight.yml`) |
| `LatticeProtocol.aDNA` | 3b | `github.com/aDNA-Network/latticeprotocol-adna` | `main` | ✅ clean · **drift** · +nested W4 · I/R (R if lib published) |
| `Lab.aDNA` | 3b | `github.com/aDNA-Network/lab-adna` | `main` | ✅ clean · **drift** · +nested W4 |
| `Operations.aDNA` | 3b | `github.com/aDNA-Network/TaskForge.aDNA` | `master` | ✅ clean · **drift** |
| `TappProtocol.aDNA` | 3b | `github.com/aDNA-Network/TappInterface.aDNA` | `master` | ✅ clean · **drift** |
| `VAAS.aDNA` | 3b | `github.com/aDNA-Network/VAASLattice.aDNA` | `main` | ✅ clean · **drift** |
| `ContextCommons.aDNA` | 3b | `github.com/LatticeProtocol/ContextCommons.aDNA` | `main` | ✅ clean · **cross-org** (name matches) · confirm I vs P-dev at gate |
| `LAVentureGraph.aDNA` | 3b | `github.com/ScienceStanley/LAStartupLattice` | `main` | ⚠️→✅ 5 FP (`.obsidian/plugins/*.js`) → allowlist staged · **personal-account cross-org + drift** |
| `WilhelmAI.aDNA` | 3b | `github.com/Wilhelm-Foundation/WilhelmAI` | `master` | ✅ clean · **partner-org (STAYS) + drift** (repo lacks `.aDNA`) · partner coord |
| `RemoteControl.aDNA` | 3c | — (local-only) | `master` | ✅ clean · first-remote GH-priv **or** L (operator) |
| `Warp.aDNA` | 3c | — (local-only) | `master` | ✅ clean · first-remote GH-priv **or** L (operator) |
| `ComfyUI.aDNA` | 3c | — (local-only) | `master` | ✅ clean · **L-vs-GH-priv operator decision** (STATE "NOT for release", Anduril-dep; **never Codeberg**) |

**Scan summary:** 23 scanned · 18 clean · 5 FP (Network 23 / aDNALabs 13 / ScienceStanley 11 / LAVentureGraph 5 / Obsidian 1) — **all triaged false-positive, no real secret**. (Detail: `session_stanley_20260622_git_p6_wave3_staging.md`.)

## Findings (→ p6 AAR + fast-follow)
- **F-W3-a (merge-not-clobber):** `Network` + `ScienceStanley` already self-manage with a mature **root** `.gitleaks.toml`. The hook resolves `git/.gitleaks.toml` **before** root → a naive baseline `git/.gitleaks.toml` would **shadow** their good config (regression). **Their touch must preserve the existing allowlist** — either (i) leave the root `.gitleaks.toml` and **do not** stage a `git/.gitleaks.toml` (hook falls through to root), or (ii) copy/merge the root allowlist into `git/.gitleaks.toml`. Recommended: **(i) — leave root config in place** (simplest, no merge risk); the wrapper's `local_extensions` records the pre-existing config as authoritative.
- **F-W3-b (`.obsidian/plugins/` FP is fleet-wide):** the vendored minified-bundle FP hit `aDNALabs`/`ScienceStanley`/`LAVentureGraph` (W3) and `III` (W2). ScienceStanley already path-allowlists `^\.obsidian/plugins/`. **Fold `^\.obsidian/plugins/` into the Git.aDNA baseline `git/.gitleaks.toml`** (fast-follow → Rosetta `.adna/` release) so every Obsidian-content vault inherits it; then per-graph allowlists shrink to true graph-specifics. (Deferred; baseline edit is its own decision.)
- **F-W3-c (hooksPath bypass — discovered AS-FIRING 3a):** a graph with `core.hooksPath` set (`ScienceStanley` → `how/governance/hooks`) **bypasses `.git/hooks/pre-push`** — the standard symlink-install (`ln -sf ../../git/hooks/pre-push.gitleaks.sh .git/hooks/pre-push`) **silently no-ops** (git reads hooks from the configured dir, not `.git/hooks/`), so the gitleaks pre-push never fires. **Refire must place the hook at the hooksPath** (`how/governance/hooks/pre-push`) **or chain** it into the existing set (SS already keeps a `pre-commit` deploy-airlock + `ci-airlock-check` there). **Generalize the pre-flight `core.hooksPath` sweep** from Astro's *stale-absolute-path* (F-Astro) to **any set hooksPath** — if set, place/chain rather than symlink `.git/hooks/`. Fold → Rosetta `skill_git_provider_config` (detect `core.hooksPath`; place/chain, not blind-symlink). (`Network` was clean here — hooksPath unset; the other 7 fired graphs all had hooksPath unset.)
>
> **As-refiring mechanic (SS, 2026-06-22 — folded into `skill_git_provider_config` step 5):** SS's `how/governance/hooks/` holds `pre-commit` + `ci-airlock-check` (different events) and **no `pre-push`** (slot free) → place, no chain needed. From the SS repo root: `cp` the canonical hook into `git/hooks/`, then `ln -sf ../../../git/hooks/pre-push.gitleaks.sh how/governance/hooks/pre-push && chmod +x git/hooks/pre-push.gitleaks.sh`. The hook resolves SS's **own root `.gitleaks.toml`** (F-W3-a — do **not** stage `git/.gitleaks.toml`). **Proof = `pre-push: gitleaks clean ✓` appearing on the SS `dev` push** (vs the silent bypass it replaces).

## Prerequisites at the gate

1. **`GITHUB_TOKEN`** exported (`export GITHUB_TOKEN="$(gh auth token)"`; Hestia broker; the Wave-2 finding — not auto-resolved) + `export GITOPS_ALLOW_LIVE=1`.
2. `source ~/aDNA/Git.aDNA/how/skills/lib/gitops_dispatch.sh` (dry-run **31/31**; no new verb).
3. **Fresh full-history `gitleaks detect` → clean** per graph at the moment of touch (ADR-011 hard gate; FP graphs use their staged/own allowlist).
4. **Porcelain-clean + no active session** in the target vault (collision-avoid; the standing discipline).
5. **3b only:** Berthier coord delivered + ack'd (`berthier_wave3_coord.md`) **before** any rename/transfer.
6. **3c only:** operator confirms first-remote-vs-L per graph (`ComfyUI` especially).
7. **Per-graph hooksPath sweep** (Astro F-Astro): `git config --get core.hooksPath` — must be empty or the in-repo relative path; unset any stale absolute path before the dogfood push so the pre-push hook isn't silently bypassed. (`ScienceStanley` carries an intentional **relative** hooksPath — verify it routes through / co-exists with the gitleaks hook.)

---

## Staged artifact: the I-class `git/CLAUDE.md` template

Every Wave-3 graph `G` gets this wrapper (fill `origin`/`branch` from the value table; `pinned_at_commit` = Git.aDNA HEAD at apply, **currently `e462e31`**):

```yaml
---
type: wrapper
wrapper: git
created: 2026-06-22
updated: 2026-06-22
status: active
last_edited_by: agent_stanley
tags: [wrapper, git, federation, git_provider]
---

# `git/` — G.aDNA consumer wrapper (federates Git.aDNA)

federation_ref:
  source_vault: Git.aDNA
  source_skill: how/skills/skill_git_provider_config.md
  version: "0.1.0"
  version_policy: minor
  pinned_at_commit: "e462e31"          # Git.aDNA HEAD at apply (re-pin if it advances by the gate)
  binds_adrs: [adr_004, adr_006, adr_007, adr_008, adr_009, adr_011, adr_013]
  verbs_exposed: [create-repo, set-remote, push, open-pr, cut-release, configure-mirror, port-ci]
  local_extensions: []                 # Network/ScienceStanley: record pre-existing root .gitleaks.toml here (F-W3-a)
git_provider:
  host: github.com
  backend: github
  org: aDNA-Network                    # WilhelmAI = Wilhelm-Foundation (partner-org, stays)
  visibility: private                  # I — internal/proprietary, GitHub-private-interim → self-hosted post-P7 (ADR-013)
  class: I
  lfs: false
  remotes:
    origin: https://github.com/aDNA-Network/G.aDNA.git
    mirror:                            # n/a (internal; no release mirror unless class R)
    upstream:
```

**Doctrine paste:** the canonical [[doctrine_gitops_block]] fenced block (ADR-013 v., 7 items) under a `## Git-Ops` heading in `G/CLAUDE.md`.
**Hook:** copy `Git.aDNA/git/hooks/` + (baseline) `git/.gitleaks.toml` into `G/git/`, then `ln -sf ../../git/hooks/pre-push.gitleaks.sh ~/aDNA/G/.git/hooks/pre-push`. **F-W3-a exception:** for `Network`/`ScienceStanley`, do **not** stage `git/.gitleaks.toml` — let the hook fall through to their existing root `.gitleaks.toml`.
**STATE/MANIFEST patch:** record the host fact "origin = github.com/aDNA-Network/G.aDNA (private, class I; declared <date>)" — for 3a this *documents* the unchanged origin; for 3b/3c it records the rename/transfer/first-remote.

---

## Sub-wave 3a — pure touch (12; existing GitHub-private origin)

### Common sequence (per graph `G`, from `~/aDNA/<G>`)
```bash
cd ~/aDNA/<G>
# 0. pre-flight: porcelain-clean, sessionless, hooksPath sweep
git status --porcelain        # expect empty
git config --get core.hooksPath   # expect empty (unset stale absolute paths; Astro F-Astro)
# 1. fresh full-history scan (HARD GATE; Network/SS use their OWN .gitleaks.toml; FP graphs use staged allowlist)
gitleaks detect --source . --config <cfg> --redact --no-banner   # exit 0 required
# 2. apply artifacts: git/CLAUDE.md (I-class template) + doctrine block in CLAUDE.md + hook (+ git/.gitleaks.toml UNLESS F-W3-a) + STATE/MANIFEST host-fact
# 3. commit
git add -A && git commit -m "feat(git): Wave-3 git/ wrapper + Git-Ops doctrine (GitHub-private, class I; P6 internal touch)"
# 4. dogfood push to the EXISTING origin (pre-push hook fires live)
export GITHUB_TOKEN="$(gh auth token)"; export GITOPS_ALLOW_LIVE=1
source ~/aDNA/Git.aDNA/how/skills/lib/gitops_dispatch.sh
gitops_push <branch>          # GitHub HTTP-Basic path (proven Wave-2)
# 5. verify
git clone https://github.com/aDNA-Network/<G>.git /tmp/_verify_<G>   # authed → OK; git/ + ## Git-Ops present; HEAD match
GIT_TERMINAL_PROMPT=0 git clone https://github.com/aDNA-Network/<G>.git /tmp/_anon_<G> 2>&1 | grep -qi 'fatal\|denied' && echo "anon REFUSED ✅ (private invariant)"
rm -rf /tmp/_verify_<G> /tmp/_anon_<G>
# 6. NO §C shim (origin unchanged); NO rollback remote
```

### Per-graph (3a) — value table
| Graph | Branch | `cfg` (scan) | Notes |
|---|---|---|---|
| `aDNALabs.aDNA` | `main` | staged `aDNALabs.gitleaks.toml` | org HQ |
| `Harness.aDNA` | `master` | baseline | vault only; `what/harness` = W4 |
| `Context.aDNA` | `master` | baseline | vault only; `what/contextscope` = W4 |
| `Network.aDNA` | `main` | **own root `.gitleaks.toml`** (F-W3-a) | mesh registry (sensitive) — no `git/.gitleaks.toml` |
| `Terminal.aDNA` | `master` | baseline | — |
| `Obsidian.aDNA` | `master` | staged `obsidian.gitleaks.toml` | — |
| `WorldGenome.aDNA` | `main` | baseline | — |
| `ZenZachary.aDNA` | `main` | baseline | brand vault |
| `zeta.aDNA` | `main` | baseline | — |
| `wga.aDNA` | `main` | baseline | has CI |
| `AWSBootstrap.aDNA` | `main` | baseline | private + mesh-bridge |
| `ScienceStanley.aDNA` | **`dev`** | **own root `.gitleaks.toml`** (F-W3-a) | brand vault; push `dev`; CI; surface the deferred `incident_20260528` token at gate |

---

## Sub-wave 3b — name-drift + cross-org reconcile (8; Berthier)

> **Berthier coord delivered + ack'd first** (`berthier_wave3_coord.md`). Renames/transfers are **GitHub-native** (the Astro precedent), same provider, history/issues preserved, old paths auto-redirect. **No `rollback` remote** (native-transfer/redirect sub-class — rollback = re-transfer/re-rename). The vault stays **private** throughout.

### Name-drift (same org `aDNA-Network`; repo ≠ dirname)
`LatticeProtocol`(`latticeprotocol-adna`), `Lab`(`lab-adna`), `Operations`(`TaskForge.aDNA`), `TappProtocol`(`TappInterface.aDNA`), `VAAS`(`VAASLattice.aDNA`).
```bash
# after 3a-style touch + push to the CURRENT (drifted) origin:
gh repo rename <NewName>.aDNA --repo aDNA-Network/<OldRepoName>   # GitHub-native; old refs redirect
cd ~/aDNA/<G> && git remote set-url origin https://github.com/aDNA-Network/<NewName>.aDNA.git
git remote -v   # verify; re-fetch
# update git/CLAUDE.md origin + STATE/MANIFEST host-fact to the new canonical name
```

### Cross-org
- `ContextCommons` — `LatticeProtocol/ContextCommons.aDNA` → `aDNA-Network/ContextCommons.aDNA` (GitHub-native transfer, the Astro mechanic; **confirm I vs P-dev** at gate — if P-dev it leaves Wave 3 → Codeberg).
- `LAVentureGraph` — personal `ScienceStanley/LAStartupLattice` → `aDNA-Network/LAVentureGraph.aDNA` (transfer **+** rename; personal-account transfers need the target-org accept + source-owner auth — verify scopes; staged allowlist for `.obsidian/plugins`).
- `WilhelmAI` — **STAYS** `Wilhelm-Foundation/WilhelmAI` (partner-org, ADR-001). Touch only (wrapper+doctrine+hook+host-fact pushed to the partner origin). **Partner coord** before any rename of the partner-owned repo (the `.aDNA` suffix add is a partner decision). `org: Wilhelm-Foundation` in its `git/CLAUDE.md`.

**Transfer mechanic (Astro precedent, native, poll-until-settled):** `gh api -X POST repos/<src-org>/<repo>/transfer -f new_owner=aDNA-Network` → poll `gh repo view aDNA-Network/<repo>` until resolved (a transient **422 "operation in progress"** on an immediate follow-up rename is expected — retry once settled) → rename → repoint origin → re-fetch.

---

## Sub-wave 3c — local-only / first-remote (3; operator-decision)

> **Operator confirms first-remote-vs-L per graph at the gate.** If first-remote: the Wave-1a greenfield trio, **but target `github.com`/`private`** (never Codeberg — these are internal/I). If L: declaration only (class L; no remote), like `Home`/`DataRoom`.

```bash
# first-remote (GH-private) — only if the operator confirms (else stop at declaration/L):
cd ~/aDNA/<G>
gitleaks detect --source . --config <baseline> --redact --no-banner   # clean
export GITHUB_TOKEN="$(gh auth token)"; export GITOPS_ALLOW_LIVE=1
source ~/aDNA/Git.aDNA/how/skills/lib/gitops_dispatch.sh
gitops_create_repo github.com aDNA-Network <G> private
gitops_set_remote  github.com aDNA-Network <G> origin
gitops_push <branch>
# verify: API private:true, anon-clone refused, authed HEAD match; apply artifacts; NO shim (greenfield)
```
| Graph | Branch | Decision |
|---|---|---|
| `RemoteControl.aDNA` | `master` | first-remote GH-priv (stub) **or** L |
| `Warp.aDNA` | `master` | first-remote GH-priv (genesis P0) **or** L |
| `ComfyUI.aDNA` | `master` | **L vs GH-priv** — STATE "NOT for release", Anduril-dep; **never Codeberg** |

---

## Apply-order at the gate
1. **3a first** (lowest risk) — recommend a **canary** (e.g. `AWSBootstrap` or `aDNALabs`) then the rest; each: hooksPath sweep → fresh scan → artifacts → commit → dogfood push → verify (anon-refused).
2. **3b** — deliver+ack Berthier coord → per graph: touch+push to current origin → GitHub-native rename/transfer → repoint → re-verify. `WilhelmAI` = touch-only + partner coord. `ContextCommons` = confirm I-vs-P-dev first.
3. **3c** — operator confirms per graph → first-remote (GH-priv) or L-declaration.
4. Flip each ledger row to ✅; update Git.aDNA STATE; Hestia registers **no** new §C shims for 3a/3c (only 3b transfers note a native-transfer/redirect entry, like Astro).
**Nothing here runs without the DP5 gate** (Standing Order #1/#2). The fire is per-sub-wave, scope-limited, like every prior wave.

## Staged allowlists (this dir)
- `aDNALabs.gitleaks.toml` — `^\.obsidian/plugins/` + `access-grant`/`signing_key_path` FP regexes.
- `laventuregraph.gitleaks.toml` — `^\.obsidian/plugins/`.
- `obsidian.gitleaks.toml` — `^\.obsidian/plugins/` + `iii/*.jsonl` CSS-selector FP.
- `Network` + `ScienceStanley` — **no staged file** (use their own root `.gitleaks.toml`; F-W3-a).
