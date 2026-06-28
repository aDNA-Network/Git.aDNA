# Changelog — Git.aDNA

All notable changes to the **Git.aDNA** graph are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Governance version lives in `CLAUDE.md` frontmatter.

> This graph tracks **git/forge/CI-CD** doctrine + tooling for the aDNA fleet. The aDNA *standard's* changelog lives in `aDNA.aDNA` (this file was reset from the inherited template changelog at genesis).

---

## [v0.28] — 2026-06-27 — R2/P6 Wave 4 CANARY FIRED (outward): lattice-protocol federation touch

> Operator "your recommendation is good, please continue" (**F-W4-e resolved: `moleculeforge` = class I**) → live re-probe (only `lattice-protocol`/`latlab-lab` quiet) → AskUserQuestion **Canary `lattice-protocol`**; ExitPlanMode (`please-read-the-claude-md-lively-floyd.md`) = the DP5 gate (= Berthier cross-persona ack). **The campaign's first Git.aDNA-tooling code-repo federation touch** (the harness exemplar was applied by the Harness team itself).

### Fired (outward, scope = lattice-protocol)
- **`lattice-protocol`** (`aDNA-Network/lattice-protocol`, `main`, HEAD `47935b6`): F-W3-d dual-check → fresh full-history `gitleaks` clean (121c, hard gate) → in-repo `git/CLAUDE.md` wrapper (pin `3ba254a`, class **I/R**) + `## Git-Ops` doctrine in the repo `CLAUDE.md` + `git/.gitleaks.toml` (baseline) + pre-push hook (symlink) + **corrected a stale `LatticeProtocol`-org fact** (WS-1 → `aDNA-Network`) → commit `47935b6` (repo's own ruff/mypy/secret-detect pre-commit gate passed) → `gitops_push main` to the **existing** origin → **pre-push hook `gitleaks clean ✓`**. Verified: `private:true`, **anon-clone refused**, authed HEAD match, artifacts present. **CI already-federated** (vendored `reusable_ci.yml`) → no CI added. **No host move / no §C shim** (origin unchanged).
- **F-W4-f**: Git.aDNA's CI templates (`what/templates/ci/`) lag the live vendored `reusable_ci.yml` lattice-protocol uses (cites an absent `what/ci_templates/`) → candidate upstream.
- **Held:** `latlab`(5-dirty) · `latlab-lab`(ssh, next) · `contextscope`(active-today) · `moleculeforge`(54-sessions; class I) · `dataroom`(L). **Berthier coord delivery HELD** (aDNALabs busy; operator ack = cross-persona ack). **No new lib verb** (dry-run 31/31). **Wave-4: 4a 1/4 fired.**

## [v0.27] — 2026-06-27 — R2/P6 Wave 4 STAGED (non-outward): federation-reconciliation of nested code-as-WHAT repos

> Operator "continue the campaign" → held-2 (`zeta`/`WilhelmAI`) STILL blocked ⇒ no outward Wave-3 fire → AskUserQuestion **Stage Wave 4 (non-outward)**; ExitPlanMode (`please-read-the-claude-md-lively-floyd.md`). **Mid-pass ground-truth discovery (F-W4-a, F-W3-e class):** Wave 4 (nested code-as-WHAT repos) is **NOT greenfield** — the host-migration is already largely done — **`harness` ✅ fully federated 06-26** (Harness team → `aDNA-Network/adna-harness` private + CI + in-repo `git/` wrapper = the **EXEMPLAR**); **`lattice-protocol`·`latlab`·`moleculeforge` host-moved → `aDNA-Network` by Berthier's WS-1 pilot** (`legacy` rollback remotes). ⇒ residue = the **Git.aDNA federation *touch***, not a host move. → AskUserQuestion **Reframe to federation-reconciliation**.

### Staged (all non-outward)
- **Authored** [[wave4_runbook]] — generalizes the harness exemplar (in-repo `git/` wrapper + `## Git-Ops` + gitleaks hook + portable CI; ADR-008); sub-waved **4a** touch ×4 (`contextscope`/`lattice-protocol`/`latlab`/`latlab-lab`) · **4b** `moleculeforge` (host-decision HELD) · **4c** `dataroom` class-L declaration.
- **Reconciled** [[disposition_ledger]] nested-repo table to ground truth (harness ✅ DONE + WS-1 host-moves + `legacy` remotes + per-repo scan/status).
- **Pre-clear scans** (full history): `contextscope`/`lattice-protocol`/`latlab-lab` **clean**; `latlab` (15) + `moleculeforge` (71) **all false-positive** (latlab = `Ed25519PrivateKey` param type-annotations + test fixtures; moleculeforge = `runs/*/execution_result.json` hashes) → 2 allowlists staged + **validated clean**.
- **Drafted** [[berthier_wave4_coord]] — ownership boundary (WS-1 owns host execution; Git.aDNA supplies the pattern) + the `moleculeforge` GitHub-I-vs-Codeberg-P-dev decision (**F-W4-e**) + Home `legacy`-remote/`adna-harness` records.
- **No new lib verb** (dry-run 31/31). **Findings F-W4-a..e.** **Held-2 unchanged.** Next = a Berthier-coordinated Wave-4 per-repo DP5 fire → Wave 5 / P7.

## [v0.26] — 2026-06-25 — R2/P6 Wave 3 RECONCILIATION (non-outward): aDNALabs already-fired desync corrected → 3a 11/12

> Operator "continue the campaign" → liveness sweep of the held graphs found the one quiet 3a graph (`aDNALabs`) **already fired + pushed 2026-06-22** (touch `067cd87`, `main`, private; pin `1aca0eb`; true remote tip contains it; `gh api` `private=true` + `git/CLAUDE.md` present 1910 B) — the 06-22 refire/refire2 in fact applied + committed + pushed it but recorded it HELD (the refire2 logged as a "never-fired stub"); the success was never journaled. The 7 "unpushed" commits on top are Berthier's own later governance work, not campaign work. AskUserQuestion → **Reconcile + verify (non-outward)** + **WilhelmAI = touch-only / keep name**; ExitPlanMode (`please-read-the-claude-md-mossy-biscuit.md`).

### Reconciled
- **Record corrected** in `STATE.md` (callout + intake), `disposition_ledger.md` (aDNALabs 3a → ✅ FIRED + reconciliation callout + WilhelmAI touch-only), `wave3_runbook.md` (STATUS → 3a 11/12), `p6_fleet_alignment.md` (AAR).
- **Fleet cross-check (read-only):** all 19 other recorded-fired Wave-3 graphs match ground truth (wrapper + `## Git-Ops` + correct origin) → **`aDNALabs` is the ONLY desync** (`Operations`' doctrine sits in `AGENTS.md`, expected).
- **Reconciled Wave-3 truth: 3a 11/12 (held `zeta` only) · 3b 7/8 (held partner `WilhelmAI`) · 3c ✅ 3/3** — Wave 3 reachable-complete bar the 2 externally-blocked graphs.

### Decision
- **WilhelmAI = touch-only / keep name** — when quiet, push artifacts to the existing `Wilhelm-Foundation/WilhelmAI` origin; **no `.aDNA` rename** of the partner-owned repo (ADR-001).

### Finding
- **F-W3-e (journaling desync — fired-but-recorded-held):** a clean back-out was journaled, then a follow-on apply completed without re-journaling. Mitigation: on every "continue the campaign," verify each *held* graph's **actual git state** (wrapper/doctrine/origin/remote-tip), not just the recorded status (generalizes F-W3-d to the held-set).
- Secondary hygiene: this CHANGELOG + the STATE intake log lagged the 06-24 (wave3c) + 06-25 (harness/ss/warp) fire sessions (top-of-file callouts present; CHANGELOG/intake entries missing) — back-fill at a future pass.

### Boundaries
- **Non-outward (reconcile session):** no host moves · no pushes · no cross-vault writes · no `.adna/` edits · **no re-fire of aDNALabs** (already done). One local commit.
- **Wind-down 2026-06-26:** Git.aDNA `master` synced to public `aDNA-Network/Git.aDNA`. Ground-truth check (F-W3-e): the reconcile `4adfcbc` + held-refire `3a89270` docs were **already pushed** — carried by the operator's fleet **Illumination Wave-2 reseed** `b72056f` (`.obsidian/`-only, verified not contamination); the wind-down pushed only its own marker commit. Pre-push gitleaks clean (41 commits, no leaks). Fleet untouched (aDNALabs's unpushed commits = Berthier's; `zeta`/`WilhelmAI` blocked).

---

## [v0.25] — 2026-06-24 — R2/P6 Wave 3b COMPLETE (reachable): TappProtocol + LAVentureGraph fired → drift 5/5 + cross-org 2/2

> Operator "continue the campaign" → liveness sweep (held-4 + WilhelmAI + Warp all live/dirty) → AskUserQuestion **scope = TappProtocol + LAVentureGraph** + **defer Wave 3c** → ExitPlanMode (`please-read-the-claude-md-peaceful-cascade.md`) = the rollout **DP5 gate**. Completes all reachable Wave-3b graphs; only partner `WilhelmAI` (held-live) remains for 3b.

### Fired (outward, GitHub-private throughout)
- **`TappProtocol`** — GitHub-native in-org **drift rename** `aDNA-Network/TappInterface.aDNA` → `aDNA-Network/TappProtocol.aDNA` (`master`, HEAD `8ab5e7c`; `private:true`; old→new redirect ✓; anon-clone REFUSED). Cleared the prior live-Mentor hold (now quiet — genesis complete/P9 closed). Nested `what/tappinterface/` same-repo = Wave 4.
- **`LAVentureGraph`** — the campaign's **first transfer from a personal account**: GitHub-native cross-org **transfer + rename** `ScienceStanley/LAStartupLattice` → `aDNA-Network/LAVentureGraph.aDNA` (`main`, HEAD `eaa61f0`; `private:true`; redirect ✓; anon REFUSED). Transfer settled in 5 poll-checks; rename attempt-1 clean; untracked `.community_intel.yaml.bak` preserved (stage-only-mine).
- Per graph: `git/` wrapper (pin `9c6a353`) + `## Git-Ops` doctrine + gitleaks pre-push hook (dogfooded `clean ✓`) + STATE/MANIFEST host-fact. **F-W3-d dual-check** held (clean+sessionless before apply AND before commit).

### Cross-vault (staged, Rule 9/10)
- Hestia redirect-shim coord → **7 entries** (added TappProtocol + LAVentureGraph; native-rename/transfer redirect sub-class — no `rollback` remote; rollback = re-rename / re-transfer).
- Berthier coord delivery **STILL HELD** (aDNALabs busy); renames/transfer proceeded under operator ack (the 06-24 precedent).

### Unchanged / boundaries
- No new lib verb (dry-run **31/31**). No `.adna/` edits. No writes into busy vaults. Wave-3a held-4 (`aDNALabs`/`ScienceStanley`/`Harness`/`zeta`) + Wave 3c (`RemoteControl`/`ComfyUI`/`Warp`) deferred.

> **Continuity:** the earlier 06-24 sessions `…_wave3b_drift` (Operations·VAAS·LatticeProtocol) + `…_wave3b_continue` (Lab + ContextCommons) advanced 3b without their own CHANGELOG entries; this v0.25 entry closes the reachable-3b arc. Per-session detail: STATE QUEUED callouts + [[disposition_ledger]].

## [v0.24] — 2026-06-22 — R2/P6 Wave 3a REFIRE attempt — both targets in active concurrent use → 0 fired (held); Phase-1 F-W3-c fold landed

> Operator "continue the campaign" → AskUserQuestion **Fire aDNALabs + SS** (hold Harness + zeta) → ExitPlanMode (`please-read-the-claude-md-pure-canyon.md`) = the rollout **DP5 gate** (scope = the 2 then-clear held graphs). Live re-check at pre-flight had shown both clean + sessionless; **both collided mid-session** under live concurrent activity → **nothing fired outward** (collision-avoid, Standing Order #2; the operator's "clean" condition no longer held).

### Phase 1 — non-outward prep (landed, commit `f2711d4`)
- **Folded F-W3-c** (+ F-Astro + F-W3-a) into `skill_git_provider_config.md` step 5 — `core.hooksPath`-aware hook install (stale-absolute → unset+symlink · in-repo relative → place/chain at the configured dir · unset → standard `.git/hooks` symlink · dogfood-verify the hook fires, never assume install-by-presence). Upstreams via Rosetta later (no `.adna/` edit).
- Marked `wave3_runbook` with the concrete SS as-refiring hook mechanic. dry-run **31/31** (no new verb). Token `gho_`/40.

### Held (collision recurred this session — 0 outward)
- **`aDNALabs`** — hard-gate scan PASSED (149 commits clean) and artifact application began, but a **concurrent Berthier `ffla_go_preflight` session** (completed ~16 min prior, `status:complete`) had left **operator-gated uncommitted work** in the tree (`STATE.md` modified + a new history session file; *"records commit on the operator's word"*). My `STATE.md` host-fact edit correctly refused (file-changed-since-read) → **backed out my partial application cleanly** (reverted `CLAUDE.md`, removed `git/` + the `.git/hooks/pre-push` symlink); Berthier's work preserved untouched. **HELD** (same class as the original 3a hold).
- **`ScienceStanley`** — race-guard re-check found a **live active session** (`session_..._165500_ci09_s2_triad_motion_a11y`, SS site-dev) **mutating the tree in real-time** (6 dirty + active session → clean + session file moved, between two checks seconds apart). Applied nothing (read-only checks only) → **HELD** (the same clean→dirty-mid-wave pattern that held SS in 3a).
- `Harness` (active P7 `s7_stable_go_live_close`, `status:active`, touched ~60 min ago) + `zeta` (67 dirty) — unchanged HOLD.

### Net
- **0 graphs fired outward.** All 4 held-set graphs remain HELD. No host move · no visibility flip · no `.adna/` edits · no cross-vault writes. The workspace is currently busy (concurrent sessions in both target vaults). **Next = re-attempt in a quiet window** — `aDNALabs` fires turnkey (STATE-deferred stage-only-mine, the aDNA-canary precedent) once Berthier's FF-LA work is committed; SS once its `ci09_s2` session closes + tree clean.

## [v0.23] — 2026-06-22 — R2/P6 Wave 3a FIRED (8 graphs → GitHub-private in-place; 4 held)

> Operator "continue the campaign" → AskUserQuestion **Full 3a, canary-led** → ExitPlanMode (`please-read-the-claude-md-fluttering-badger.md`) = the rollout **DP5 gate** (scope = sub-wave 3a). The lowest-risk outward action in the campaign — class-I internal/proprietary graphs federate Git.aDNA **in place** (no host move, no Codeberg, no visibility flip, no shim).

### Added (per fired graph: `git/` wrapper pin `3a31b0a`/class I + `## Git-Ops` doctrine in CLAUDE.md + `gitleaks` pre-push hook + MANIFEST/STATE host-fact)
- **8 graphs FIRED** → dogfood-pushed to the existing GitHub-private origin (pre-push `gitleaks clean ✓`; **anon-clone REFUSED**; `gh api .private=true`): `AWSBootstrap` (canary `1a56a52`) · `Context` `d58ac01` · `Terminal` `cedf46b` · `WorldGenome` `5230a25` · `ZenZachary` `200e991` · `Obsidian` `06eef39` (staged FP allowlist) · `wga` `03d13b9` · `Network` `6027681` (**F-W3-a** — own root `.gitleaks.toml`; `git/.gitleaks.toml` not staged).

### Held (collision-avoid, prereq #4 — turnkey-refire when porcelain-clean + sessionless)
- `aDNALabs` (modified STATE + today's Berthier Q2-III work) · `zeta` (67 dirty incl. CLAUDE+STATE) · `Harness` (68 active sessions, live P7 go-live) · `ScienceStanley` (live site-dev churn + F-W3-c).

### Findings
- **F-W3-c (NEW):** a graph with `core.hooksPath` set (ScienceStanley → `how/governance/hooks`) **bypasses `.git/hooks/pre-push`** — the symlink-install silently no-ops; refire must place/chain the gitleaks hook at the hooksPath location. Fold → `wave3_runbook` + Rosetta `skill_git_provider_config`.
- Collision windows are **live** — ScienceStanley went porcelain 0→5 within the wave (a site-dev session started mid-flight); re-check at the moment of touch, not just at staging (the Molecules discipline, reconfirmed).

### Verified
- Per fired graph: fresh full-history `gitleaks` (hard gate) → pre-push hook dogfooded clean → authed clone HEAD-match with `git/` + `## Git-Ops` present → anon-clone refused → `gh api .private=true`. **No new lib verb** (dry-run **31/31** unchanged, as predicted). **F-W3-a** validated live on Network.

### Outward actions (all DP5-authorized)
- 8 commits + 8 pushes to **existing** GitHub-private origins. No repo creates, no transfers, no visibility changes, no Codeberg, no `rollback`/§C shim, no `.adna/` edits, no cross-vault writes.

---

## [v0.22] — 2026-06-22 — R2/P6 Wave 3 STAGED + sub-waved (3a/3b/3c) — gate-ready (non-outward)

> Operator "continue the campaign" → AskUserQuestion: **Staging pass only (non-outward)**; ExitPlanMode (`please-read-the-claude-md-cheeky-sloth.md`) approved. Wave 2 complete ⇒ next gated step = **Wave 3 (internal/proprietary class-I majority → stay GitHub-private-interim, touch only)**; no Wave-3 runbook existed.

### Added
- **`how/campaigns/campaign_git_genesis/missions/wave3_staging/wave3_runbook.md`** — the Wave-3 execution runbook (mirrors `wave1_runbook`), **sub-waved lowest-risk-first**: **3a pure-touch (12)** existing-origin → `gitops_push` (no host move) · **3b name-drift+cross-org reconcile (8)** GitHub-native rename/transfer (Astro precedent) + Berthier · **3c local-only/first-remote (3)** operator-decision. I-class `git/CLAUDE.md` template (pinned `e462e31`), per-graph value table, pre-clear table, per-sub-wave command sequences, verify invariants, `core.hooksPath` sweep (Astro F-Astro), apply-order. **24 ledger rows · Astro ✅ done · 23 remaining.**
- **3 staged FP allowlists** (`aDNALabs.gitleaks.toml`, `laventuregraph.gitleaks.toml`, `obsidian.gitleaks.toml`) — validated clean.
- **`berthier_wave3_coord.md`** (staged per Rule 10) — 5 same-org renames + 2 cross-org transfers + WilhelmAI partner-org coexistence + unmapped-repos FYI.

### Verified (read-only, non-outward)
- **Pre-clear gitleaks: 23 scanned · 18 clean · 5 findings ALL FALSE-POSITIVE** (Network 23 · aDNALabs 13 · ScienceStanley 11 · LAVentureGraph 5 · Obsidian 1 — vendored `.obsidian/plugins/*.js` + `Ed25519PrivateKey` class-NAME + `evt_<hex>` event IDs + `cert_sha256`). `Network`+`ScienceStanley` clean under their **own** root `.gitleaks.toml`.
- **No new lib verb needed** — dry-run harness re-confirmed **31/31** (3a=`push`; 3c=greenfield trio→GitHub-private; 3b=GitHub-native).

### Findings
- **F-W3-a (merge-not-clobber):** graphs with a pre-existing root `.gitleaks.toml` (Network, ScienceStanley) — the touch must **preserve** it (the hook prefers `git/.gitleaks.toml`, which would shadow the root config).
- **F-W3-b (fleet-wide FP):** the vendored `^\.obsidian/plugins/` minified-bundle FP hit III (W2) + aDNALabs/ScienceStanley/LAVentureGraph (W3) → fold `^\.obsidian/plugins/` into the Git.aDNA baseline `git/.gitleaks.toml` (fast-follow → Rosetta `.adna/` release).
- ⚠ ScienceStanley's config carries a **known operator-deferred** `incident_20260528` Vercel-token item — surface at its gate (private→private; not a blocker).

### Changed
- `what/inventory/disposition_ledger.md` — Wave-3 section annotated (sub-waved 3a/3b/3c + staged + scan results; zero-unaccounted preserved).
- `how/campaigns/campaign_git_genesis/missions/p6_fleet_alignment.md` — objective #4 (Wave 3 staging) progress + AAR.
- `STATE.md` — Wave-3-staged callout + intake entry + QUEUED pointer (Resume-Here unchanged = R2/P6).

### Boundaries
- **Nothing outward · no `.adna/` edits · no cross-vault writes** (all authored in Git.aDNA; Berthier coord staged-not-delivered). The fire is a **separate per-sub-wave DP5 gate** (Standing Order #1).

---

## [v0.21] — 2026-06-22 — R2/P6 Wave 2 CLOSE: Astro.aDNA → GitHub-private (reclassified W2→W3) → ✅ WAVE 2 COMPLETE

> Operator "continue the campaign" → resolved the held 4th Wave-2 graph. AskUserQuestion: **BSL-1.1 posture = keep private** (source-available, not OSI-FOSS) ⇒ Astro **reclassified W2 (public-flip) → W3 (internal-touch, class I)**; **scope = Astro now**. ExitPlanMode (`please-read-the-claude-md-glowing-stardust.md`) = the DP5 gate (scope = Astro). Migrated home via a GitHub-native cross-org transfer + rename, kept **private** (no public flip). **→ Wave 2 COMPLETE (public 3/3: aDNA·III·Canvas; Astro private/W3); next = Wave 3 (internal touch-only).**

### Changed (outward — GitHub, stays private)
- **`github.com/LatticeProtocol/SiteForge.aDNA` → `github.com/aDNA-Network/Astro.aDNA`** via GitHub-native **transfer + rename** (history/issues preserved; both old paths redirect; `private:true` throughout). The 5 ahead commits + artifacts pushed → HEAD `0d0c315`. **`gitops_set_visibility public` NOT run** — anon-clone **refused** (private invariant). Pre-flight `admin:true` confirmed transfer feasibility; the rename hit a transient **422** ("conflicting operation in progress") while the transfer finalized async → a bounded retry (no foreground sleep) cleared it.

### Added (per-graph artifacts in Astro)
- `git/` wrapper (`git/CLAUDE.md` `git_provider`: github.com/aDNA-Network, visibility:**private**, class **I**; pin Git.aDNA@`b870c16`) + `git/.gitleaks.toml` (baseline; scan clean, no allowlist) + `git/hooks/pre-push.gitleaks.sh` + `## Git-Ops` doctrine block in CLAUDE.md + MANIFEST/STATE host-fact. Corrected the stale CLAUDE.md "remote unchanged" note.
- Home §C shim coord (`Home.aDNA/who/coordination/coord_2026_06_22_git_wave2_astro_shim.md`) — **NEW native-transfer/redirect sub-class** (no `rollback` remote; rollback = re-transfer). Delivered; Hestia registers.

### Fixed
- **F-Astro (stale `core.hooksPath`)**: Astro's `.git/config` pointed `core.hooksPath` at the defunct `/Users/stanley/lattice/SiteForge.aDNA/.git/hooks` (pre-Operation-Homecoming path; whole `~/lattice` is gone) → it **silently bypassed the gitleaks pre-push hook on the first push**. `git config --unset core.hooksPath` → `.git/hooks/pre-push` (symlink → `git/hooks/pre-push.gitleaks.sh`) active → re-dogfooded `pre-push: gitleaks clean ✓`. **No secret risk** (full-history scan is the hard gate; clean ×3). Fleet sweep: only `ScienceStanley.aDNA` else carries a hooksPath (`how/governance/hooks` — intentional/relative; flag for its W3 touch). → add a `core.hooksPath` check to the wave hook-install step.

### Bookkeeping
- `disposition_ledger` (Astro W2→W3 reclassified/done; Wave 2 COMPLETE; zero-unaccounted re-confirmed — 45) · `wave2_runbook` (Astro as-fired; STATUS → complete) · Astro coord → `resolved` · delivery-queue rows #2/#3 · `p6_fleet_alignment` progress + AAR · STATE callout + intake (incl. backfilled III+Canvas intake entry) · CLAUDE.md top-status + Resume-Here. **Next gated step = Wave 3 (internal touch-only, ~20 graphs).**

---

## [v0.20] — 2026-06-22 — R2/P6 Wave 2: III.aDNA + Canvas.aDNA → GitHub-public

> Operator "continue the campaign" → with the aDNA canary proven, flipped the next two released-FOSS graphs to GitHub-public, **sequential, each behind its own fresh full-history scan gate** (AskUserQuestion scope = III + Canvas; Astro → coord + BSL flag, deferred). ExitPlanMode (`please-read-the-claude-md-happy-balloon.md`) = the per-graph DP5 gate. `gitops_set_visibility` now proven across 3 Wave-2 graphs.

### Changed (outward — GitHub, public)
- **`github.com/aDNA-Network/III.aDNA`** flipped **private → public** (HEAD `fb807f1`). Fresh full-history `gitleaks` (72 commits) → 10 hits **all false-positive** → scoped `git/.gitleaks.toml` allowlist (`paths` for vendored `.obsidian/plugins/{obsidian-tasks-plugin,termy}/main.js` + `regexes=['idempotency_key']` with `regexTarget="match"`). Dogfood push (hook clean) → flip → `private:false`; anon-clone succeeds. No host move ⇒ **no `rollback`/§C shim**.
- **`github.com/aDNA-Network/Canvas.aDNA`** flipped **private → public** (branch `master`, HEAD `b345e7b`). Fresh full-history scan (62 commits) **clean** (baseline `.gitleaks.toml`, no allowlist). `private:false`/`default_branch:master`; anon-clone succeeds. **No shim** (visibility-only).

### Added (per-graph artifacts in III + Canvas)
- `git/` wrapper (`git/CLAUDE.md` with `git_provider`: github.com/aDNA-Network, visibility:public, class P; pin Git.aDNA@`6b7a559`) + `git/.gitleaks.toml` + `git/hooks/pre-push.gitleaks.sh` + `## Git-Ops` doctrine block in CLAUDE.md + MANIFEST repo-visibility host-fact, in each graph.
- III: corrected a **stale MANIFEST host-fact** (`LatticeProtocol/III.aDNA` → `aDNA-Network/III.aDNA` — III had already moved orgs; the doc hadn't caught up).

### Coordination (staged, non-outward)
- **Astro held** → authored `who/coordination/coord_2026_06_22_git_wave2_astro_cross_org.md` (Hopper→Berthier): cross-org transfer + rename `LatticeProtocol/SiteForge.aDNA` (private) → `aDNA-Network/Astro.aDNA`, **+ a new BSL-1.1 licensing-posture flag** (source-available, status `active`; confirm public-vs-keep-private before any flip). Delivery-queue row #3 updated.

### Notes
- **Canvas pre-flip:** the tree carried uncommitted completed **Operation Salon P0** work (new campaign + `adr_006` + 8-decision record, held at P0→P1) — surfaced to operator → authorized "commit salon, then flip"; committed as its own provenance-clear commit `79f372a` (**NOT** ratified; gate stays held) before the Wave-2 artifact commit `b345e7b`.
- **Findings:** the lib's GitHub path needs `GITHUB_TOKEN` exported via `gh auth token` (not auto-resolved); `regexTarget="match"` is required when a gitleaks FP is a field **NAME** (vs Molecules' value-enum, default `secret` target).
- **No Codeberg action · no Astro flip · no `.adna/` edits · no Wave 3+.** Reversible (one-command re-privatize; no shim).

---

## [v0.19] — 2026-06-22 — R2/P6 Wave 2 CANARY: aDNA.aDNA → GitHub-public

> Operator "continue the campaign" → Wave 1a+1b complete ⇒ entered **Wave 2 (public-flips)** with a single canary. **`aDNA.aDNA` → GitHub-public** (the **dev-graph** repo `aDNA-Network/aDNA.aDNA`, distinct from the separately-released MIT image `aDNA-Network/aDNA`). **Tooling finding folded first (non-outward):** the lib had **no visibility-flip verb** (Wave 1 only *created* repos) → authored `gitops_set_visibility` (GitHub PATCH + Forgejo PATCH for portability; ADR-013 D4; contract unchanged); dry-run 24/24 → **31/31**. AskUserQuestion → "Canary: flip aDNA public"; ExitPlanMode = the **rollout DP5 gate** (scope = aDNA). Approved plan: `please-read-the-claude-md-gleaming-sprout.md`. **No Codeberg action · no III/Canvas/Astro · no `.adna/` edits · no Wave 3+.** Reversible (one-command re-privatize; no shim).

### Added (lib + tooling — non-outward; Git.aDNA commit `40f3c58`)
- **`gitops_set_visibility <host> <org> <repo> public|private`** in `how/skills/lib/gitops_dispatch.sh` — non-contract helper (ADR-013 D4 release open-flow; ADR-004 contract unchanged, like `create-org`). GitHub `PATCH /repos -F private=`; Forgejo `PATCH /repos {private}` for portability (only the GitHub path runs live at W2).
- **`how/tests/dryrun_gitops.sh`** +7 assertions (loop dispatch both backends · public/private value-correctness · Forgejo portability · input validation · live-refusal) → **31/31 PASS**. bash+zsh `-n` + shellcheck clean.
- **`how/campaigns/campaign_git_genesis/missions/wave2_staging/wave2_runbook.md`** — public-flip semantics (visibility-only; no rollback/shim; anon-clone-**SUCCEEDS** verify; hard per-graph full-history scan); aDNA canary recipe + III/Canvas/Astro held.

### Changed (outward — GitHub, public)
- **`github.com/aDNA-Network/aDNA.aDNA`** flipped **private → public** via `gitops_set_visibility` (the verb's first live exercise; API `private:false`/`visibility:public`). HEAD `a12d9c0` (6 commits pushed `c092b68..a12d9c0` — the **first live validation of the P5 GitHub Basic-auth push path**; Waves 1a/1b were all Forgejo). Anon-clone now **succeeds** (public invariant). No host move ⇒ origin unchanged, **no `rollback`/§C shim**.

### Added / Changed (cross-vault — Rule 10; `aDNA.aDNA` quiescent → committed `a12d9c0` + pushed in-vault)
- **`aDNA.aDNA`** (subject graph): new `git/CLAUDE.md` wrapper (federates Git.aDNA `pinned_at_commit 40f3c58`; `local_extensions` notes `set-visibility`) + `git/.gitleaks.toml` + `git/hooks/pre-push.gitleaks.sh` (installed) + `## Git-Ops` doctrine block in `CLAUDE.md` + MANIFEST host-fact. **STATE.md host-fact deferred** (active 33 K-token Operation-aDNA churn) → Rosetta folds.

### Findings
- **Org policy**: `aDNA-Network` permits the visibility PATCH (no 403) ⇒ `III`/`Canvas`/`Astro` clear the same auth path.
- **Verb gap**: Wave 2 needed an 8th operation the 7-verb contract lacked → folds into the Rosetta `.adna/` release (now **8** fixes: 5 P5 + F1 + F2 + `set-visibility`).
- **Held (separate per-graph gates)**: `III` (full-history `gitleaks` → 10 hits, triage FP-vs-real) · `Canvas` (active `palette_p4_close` session collision) · `Astro` (cross-org + name-drift → Berthier migrate+rename before flip).

## [v0.18] — 2026-06-22 — R2/P6 Wave 1b COMPLETE: Molecules → Codeberg-private (4/4)

> Operator "continue the campaign" → verified the prior **`Molecules` collision cleared** (`session_sc_m4` completed + tree clean; one caveat surfaced — a stale-`active` `session_e6_5_m2` frontmatter on already-committed work) → AskUserQuestion **Fire Molecules now**; ExitPlanMode = the **rollout DP5 gate** (scope = Molecules). The **last held 1b graph** — a **name-drift** host-move (`MoleculeForge.aDNA`→`Molecules.aDNA`) on branch `main` — fired turnkey, **completing Wave 1b (4/4: Videos · Oration · Spacemacs · Molecules)**. First **live exercise of a per-graph gitleaks allowlist** (16 `execution_result.json` verdict-enum false-positives passed the F2-resolved hook). **No GitHub action · no public exposure · no Wave 2 · no `.adna/` edits.** Reversible (old origin kept as `rollback`, 30d). Approved plan: `please-read-the-claude-md-wise-raccoon.md`.

### Added (outward — Codeberg, private)
- **`codeberg.org/aDNA-Network/Molecules.aDNA`** (private, P-dev) — host-moved off `aDNA-Network/MoleculeForge.aDNA` (**name-drift**); `main` pushed; `default_branch:main` (F1 no-op, like the Videos canary); HEAD `be9c4b9`. Old origin → remote `rollback` (30d).

### Added / Changed (cross-vault — Rule 10; Home sessionless → uncommitted, owner registers)
- **`Molecules.aDNA`** (subject graph; applied at the gate): new `git/CLAUDE.md` wrapper (federates Git.aDNA `pinned_at_commit f0e507c`; `local_extensions` declares the gitleaks allowlist) + `git/.gitleaks.toml` (16 FPs) + `## Git-Ops` doctrine block in `CLAUDE.md` (replacing the stale "local-only at fork" posture) + `gitleaks` pre-push hook + STATE/MANIFEST host-fact (`git_origin`). **Vault repo only** — nested `what/moleculeforge/` (Wave 4) untouched.
- **`Home.aDNA/who/coordination/coord_2026_06_22_git_wave1b_molecules_shim.md`** — §C shim row for Hestia (host-move+rename); completes the Wave-1b §C set (4 rows).

### Changed (Git.aDNA bookkeeping)
- **`disposition_ledger.md`** — Molecules → ✅ FIRED; Wave 1b progress → COMPLETE (4/4). **`wave1_runbook.md`** — Molecules as-fired (HELD→EXECUTED). **`p6_fleet_alignment.md`** — objective #2 + Wave-1b-complete progress + AAR. **`STATE.md`** — Wave-1b-complete callout + intake entry.

### Verified
- API `private:true`; anon-clone **refused**; authed-clone HEAD `be9c4b9` == `origin/main`; `default_branch:main`; `rollback` remote retained. Pre-flight: dry-run **24/24**; full-history `gitleaks` (83 commits) clean with the allowlist; Molecules porcelain-clean + no live session.

---

## [v0.17] — 2026-06-21 — R2/P6 Wave 1b SECOND GATE: Oration + Spacemacs → Codeberg-private (Molecules held)

> Operator "continue the campaign" → AskUserQuestion scope = **fire all 3 held**; pre-flight caught a **`Molecules` collision** (active `session_sc_m4` + dirty tree) → second AskUserQuestion → **fire `Oration` + `Spacemacs`, hold `Molecules`**; ExitPlanMode = the **rollout DP5 gate** (scope-limited to the two clean graphs). Two host-moves off GitHub-private — a **name-drift** (`SpeechForge.aDNA`→`Oration.aDNA`) and a **cross-org** (`LatticeProtocol`→`aDNA-Network`) — live-validated F1's **first real `main→master` default-branch PATCH** + F2's hook-resolved config. **No GitHub action · no public exposure · no Wave 2 · no `.adna/` edits.** Reversible (old origins kept as `rollback`, 30d). Approved plan: `please-read-the-claude-md-spicy-phoenix.md`.

### Added (outward — Codeberg, private)
- **`codeberg.org/aDNA-Network/Oration.aDNA`** (private, P-dev) — host-moved off `aDNA-Network/SpeechForge.aDNA` (name-drift); `master` pushed; `default_branch` auto-set `master` (F1 — first real value-change); HEAD `c9be5fd`. Old origin → remote `rollback` (30d).
- **`codeberg.org/aDNA-Network/Spacemacs.aDNA`** (private, P-dev) — **cross-org** host-move off `LatticeProtocol/Spacemacs.aDNA`; `master`+`v1.0.0` tag pushed; `default_branch` auto-set `master` (F1); HEAD `3dd833e`. Old origin → remote `rollback` (30d). The long-pending Spacemacs `v1.0.0` remote push now lands (on Codeberg).

### Added / Changed (cross-vault — Rule 10; collision-checked clean, uncommitted → owners register)
- **`Oration.aDNA`** + **`Spacemacs.aDNA`** (subject graphs; applied at the gate): new `git/CLAUDE.md` wrapper (federates Git.aDNA `pinned_at_commit 6eb0fca`) + `## Git-Ops` doctrine block in `CLAUDE.md` + `gitleaks` pre-push hook + STATE/MANIFEST host-fact. Spacemacs STATE's pending-push line reconciled (done → Codeberg; public release = ADR-013 D4).
- **`Home.aDNA/who/coordination/coord_2026_06_21_git_wave1b_oration_spacemacs_shims.md`** — §C shim rows for Hestia (host-move+rename / host-move+cross-org).
- **`aDNALabs.aDNA/who/coordination/coord_2026_06_21_inbound_from_hopper_git_wave1_homecoming.md`** — Berthier coord ack-updated (Oration+Spacemacs fired; Molecules held; operator approval = cross-persona ack).

### Changed (Git.aDNA bookkeeping)
- **`disposition_ledger.md`** — Oration + Spacemacs → ✅ FIRED; Molecules → HELD-COLLISION. **`wave1_runbook.md`** — Oration + Spacemacs as-fired; Molecules collision-hold. **`p6_fleet_alignment.md`** — objective #2 progress + second-gate AAR. **`STATE.md`** — second-gate callout + intake entry.

### Verified
- Both: API `private:true`; **anon clone refused**; **F1 fired live** (`default_branch → master` — first real value-change, not the canary's no-op); **F2 dogfooded** (`pre-push: gitleaks clean ✓`); HEAD == `origin/master`; authed-clone OK. Dry-run **24/24** intact.

---

## [v0.16] — 2026-06-21 — R2/P6 Wave 1b CANARY (Videos) FIRED: Wave-1a F1/F2 folded + first host-move

> Operator "continue the campaign" → AskUserQuestion: **Spacemacs = FOSS-in-dev**, **posture = canary (Videos) then hold**; ExitPlanMode = the **rollout DP5 gate** (scope-limited to the Videos canary). Non-outward prep folded the two Wave-1a findings into the lib/hook/CI; then the campaign's **first host-move** (`Videos.aDNA` GitHub-private → Codeberg-private) live-validated both fixes. The held set (`Molecules`/`Oration`/`Spacemacs`) is turnkey for a later gate. **No GitHub action · no public exposure · no Wave 2 · no `.adna/` edits.** Reversible (old origin kept as `rollback`, 30d). Approved plan: `please-read-the-claude-md-enchanted-spring.md`.

### Fixed (the 2 Wave-1a findings — folded + live-validated)
- **F1 (default-branch)** — `how/skills/lib/gitops_dispatch.sh`: `_gitops_git_push` PATCHes the Forgejo/Codeberg `default_branch` to the pushed branch **post-push** (idempotent; a fresh empty repo can't PATCH a not-yet-existing branch ⇒ post-push, not at-create; GitHub no-op). Push PLAN string advertises it; removes the manual PATCH.
- **F2 (hook config-path)** — `git/hooks/pre-push.gitleaks.sh` + `what/templates/ci/forgejo/ci.yml`: config search `$GITLEAKS_CONFIG` → `git/.gitleaks.toml` → repo-root → none. The hook finds the wrapper-staged allowlist with **no root symlink** (unblocks Molecules' FP allowlist at the held gate).

### Added (outward — Codeberg, private)
- **`codeberg.org/aDNA-Network/Videos.aDNA`** (private, P-dev) — host-moved off GitHub-private; `main` pushed; `default_branch` auto-set `main` (F1); HEAD `7a2c29c`. Old `github.com/aDNA-Network/Videos.aDNA` retained as remote `rollback` (30d shim).

### Added / Changed (cross-vault — Rule 10)
- **`Videos.aDNA`** (subject graph; applied directly per the wave): new `git/CLAUDE.md` wrapper (federates Git.aDNA `pinned_at_commit dc1dea7`) + `## Git-Ops` doctrine block in `CLAUDE.md` + `gitleaks` pre-push hook + STATE/MANIFEST host-fact.
- **`aDNALabs.aDNA/who/coordination/coord_2026_06_21_inbound_from_hopper_git_wave1_homecoming.md`** — Berthier Wave-1 coord **DELIVERED** (file); aDNALabs-side commit **deferred** (concurrent `leg_a` session; collision-avoid).
- **`Home.aDNA/who/coordination/coord_2026_06_21_git_wave1b_videos_shim.md`** — §C shim row for Hestia (new **host-move / git-remote-rollback** shim class); uncommitted per the Wave-1a `origins` precedent (Hestia registers).

### Changed (Git.aDNA bookkeeping)
- **`how/tests/dryrun_gitops.sh`** — +1 F1 assertion → **24/24**. **`disposition_ledger.md`** — Videos → DONE; Spacemacs → FOSS-confirmed; Molecules/Oration/Spacemacs → HELD (turnkey). **`wave1_runbook.md`** — Videos EXECUTED; manual PATCH + symlink dropped; Spacemacs confirmed. **`p6_fleet_alignment.md`** — objective #2 progress + Wave-1b AAR. **`STATE.md`** — canary callout + intake entry. **`who/coordination/coord_delivery_queue.md`** — Berthier row → DELIVERED.

### Verified
- API `private:true`; **anon clone refused**; **F1 fired live** (`default_branch → main`, no hand-PATCH); **F2 dogfooded** (`pre-push: gitleaks clean ✓` resolving `git/.gitleaks.toml`); HEAD `7a2c29c` == `origin/main`; authed-clone OK (`git/` wrapper + `videoforge/` code present). Dry-run **24/24**; bash+zsh `-n` + shellcheck clean.

---

## [v0.15] — 2026-06-21 — R2/P6 Wave 1a FIRED (outward): VisualDNA + Lighthouse → Codeberg-private

> Operator resume "continue the campaign" → AskUserQuestion scope = **Wave 1a only (greenfield)**; ExitPlanMode approval = the **rollout DP5 gate** (scope-limited to 1a). The campaign's **first fleet-scale outward action**: the two greenfield FOSS-in-dev graphs took their **first remote — Codeberg-PRIVATE**, dogfooding the agnostic lib + `gitleaks` pre-push hook live on real consumer vaults. **No GitHub action · no public exposure · no Wave 1b/Wave 2 · no `.adna/` edits.** Fully reversible (deletable repos). Approved plan: `please-read-the-claude-md-async-graham.md`.

### Added (outward — Codeberg, private)
- **`codeberg.org/aDNA-Network/VisualDNA.aDNA`** (private, P-dev) — first remote; `master` pushed; default-branch `master`.
- **`codeberg.org/aDNA-Network/Lighthouse.aDNA`** (private, P-dev) — first remote; `master` pushed; default-branch `master`.

### Added / Changed (cross-vault — applied at the gate, Rule 10)
- **`VisualDNA.aDNA`** + **`Lighthouse.aDNA`**: new `git/CLAUDE.md` wrapper (federates Git.aDNA, `pinned_at_commit c7ead53`); `## Git-Ops` doctrine block appended to `CLAUDE.md`; `gitleaks` pre-push hook + `.gitleaks.toml` installed (root symlink bridges the hook's repo-root config lookup); STATE/MANIFEST host-fact + governance line.
- **`Home.aDNA/who/coordination/coord_2026_06_21_git_wave1a_origins.md`** — inbound origins-record for Hestia (**no §C shim** — greenfield first-remote ⇒ no redirect/rollback/retirement; §C is 1b-only).

### Changed (Git.aDNA bookkeeping)
- **`what/inventory/disposition_ledger.md`** — Wave-1a rows (`VisualDNA`, `Lighthouse`) → ✅ DONE; wave-sequence + checklist banners marked FIRED.
- **`how/campaigns/.../wave1_staging/wave1_runbook.md`** — Wave 1a → EXECUTED; 2 as-fired findings noted.
- **`how/campaigns/.../missions/p6_fleet_alignment.md`** — objective #2 progress + Wave-1a AAR. **STATE.md** — FIRED callout + intake entry. **MANIFEST.md / CLAUDE.md** — status synced.

### Verified
- Per repo: API `private:true`; **anon clone refused**; pre-push hook **dogfooded clean** (`pre-push: gitleaks clean ✓`) on the live wrapper push; default-branch corrected `main`→`master`.
- Dry-run harness **23/23** intact (lib untouched).

### Findings (→ mission AAR; fold before Wave 1b / Rosetta release)
- **F1** — `gitops_create_repo` leaves Codeberg `default_branch=main`; graphs on `master` need a follow-up `PATCH default_branch` (done by hand; fold into the verb so the default tracks the pushed branch).
- **F2** — `pre-push.gitleaks.sh` reads `$repo_root/.gitleaks.toml` but the wrapper/runbook stage config at `git/.gitleaks.toml` — bridged by a root symlink; reconcile (Molecules' 1b false-positive allowlist depends on the hook-read path).

---

## [v0.14] — 2026-06-21 — R2/P6 Wave-1 gate-ready (non-outward): ledger reconciled + doctrine→ADR-013 + scans + staging

> Operator resume "continue the campaign". Reconnaissance found the disposition ledger's Wave-1b defaults **mis-classified vs ground truth**; the operator resolved three gate decisions (**non-outward reconcile+stage** · **conservative** released-threshold · **reconcile-now** drift/cross-org). The session reconciled the ledger + the fleet-propagated doctrine to ADR-013, pre-cleared the Wave-1 secret-scans, and staged the per-graph artifacts — **Wave 1 is now gate-ready**. **No outward · no `.adna/` edits · no cross-vault writes.** Wave execution is the next operator gate (rollout DP5). Approved plan: `please-read-the-claude-md-luminous-stroustrup.md`.

### Changed
- **`what/inventory/disposition_ledger.md`** — reconciled to ground truth. Corrected **5 mis-classifications**: `Canvas`+`Astro` (released → Wave 2 GitHub-public, *not* Wave 1b Codeberg); `ComfyUI` (internal → Wave 3, never Codeberg); `Spacemacs` (FOSS-dev → Wave 1b). **Wave semantics made explicit** (W1 = private-moves · W2 = public-flips-deferred-and-separated · W3 = internal-touch). Released-vs-dev RESOLVED (conservative); operator-decision rows updated; zero-unaccounted re-confirmed (45 graphs).
- **`what/doctrine/doctrine_gitops_block.md`** — item 1 host-policy clause reconciled from superseded **ADR-005** ("public/FOSS→Codeberg") to **ADR-013** (released→GitHub-public · FOSS-in-dev→Codeberg-private · proprietary→GitHub-private→self-hosted). Done *before* fleet staging so consumers never inherit pre-inversion text. `binds_adrs` leads with `adr_013`.
- **`what/specs/spec_gitops_provider_abstraction.md`** — §3/§7 host-policy prose + both `federation_ref` `binds_adrs` templates reconciled to ADR-013; the ⚠ pending-reconciliation banner flipped to ✅ done.
- **`git/CLAUDE.md`** — consumer wrapper template `binds_adrs` → adds `adr_013`.
- **`how/campaigns/.../coordination_drafts/coord_draft_adnalabs_migration_coexistence.md`** — **P6 Wave-1 addendum**: partition inverted by ADR-013 (Codeberg = private FOSS-dev) + concrete per-graph asks (name-drift `Molecules`/`Oration`; cross-org `Spacemacs`→Codeberg, `Astro`→GitHub-public). **`who/coordination/coord_delivery_queue.md`** row updated.

### Added
- **`how/campaigns/campaign_git_genesis/missions/wave1_staging/wave1_runbook.md`** — gate-ready Wave-1 runbook: per-graph `git/CLAUDE.md` declarations · doctrine-paste targets · exact `gitops_*` command sequences (1a greenfield / 1b host-move) · verify (authed-clone-OK / anon-refused) · **6 Home shim-registry entries** with rollback paths · STATE/MANIFEST patches.
- **`how/campaigns/campaign_git_genesis/missions/wave1_staging/molecules.gitleaks.toml`** — staged scoped allowlist for Molecules' 16 confirmed false-positives (8-char verdict enums in `execution_result.json`; `generic-api-key` on dictionary words — no secret).

### Verified (non-outward)
- **6 Wave-1 full-history secret-scans pre-cleared**: 5 clean; Molecules = 16 confirmed false-positives (triaged by field-name, never value) → allowlist staged. *Pre-clearing caught that Molecules' pre-push hook would have failed (rc=1) at the live gate.*
- Dry-run harness **23/23** intact (lib untouched). `git status` confined to Git.aDNA; target vaults only read (Rule 10).

---

## [v0.13] — 2026-06-21 — R2/P6 prep (non-outward): 5 lib fixes folded + disposition ledger authored

> Operator chose **"continue the campaign" → both, in dependency order**. Two non-outward tracks: the **5 P5 beachhead lib fixes** are folded (the tooling is now correct for fleet-scale use + ready for the Rosetta release), and the **P6 disposition ledger** re-maps the whole fleet to the ADR-013 table with a gate-ready Wave 1. **No outward actions · no `.adna/` edits · no cross-vault writes.** Wave execution is the next operator gate (rollout DP5).

### Added
- **`what/inventory/disposition_ledger.md`** — P6 objective #1. 45 graphs + 7 nested + 4 external + 4 unmapped re-mapped to the ADR-013 host table; **zero unaccounted** (exit-gate criterion met); 5-wave sequence (1a greenfield · 1b host-move · 2 public-flip · 3 internal-touch · 4 nested · 5 client) + a **gate-ready Wave 1 checklist**; operator-decision rows (released-vs-dev · name-drift · cross-org · unmapped).
- **`how/tests/dryrun_gitops.sh`** — +4 assertions (Forgejo `cut-release` `target_commitish`; `create-org` dispatch both backends; live-refusal) → **23/23 PASS** (was 19/19).

### Changed (the 5 beachhead lib fixes — `how/skills/lib/gitops_dispatch.sh` + `how/tests/livesmoke_gitops.sh`)
- **`_gitops_git_push`** — per-backend auth: GitHub **HTTP Basic** (`x-access-token:tok`, base64 unwrapped) via `GIT_CONFIG_*` env (token never in argv/`.git/config`); Forgejo `Authorization: token` unchanged.
- **`gitops_cut_release`** — Forgejo body now carries `target_commitish` (defaults to current branch); optional trailing arg.
- **`gitops_create_org`** — new **non-contract** gated helper (Forgejo `POST /orgs`; GitHub admin-scoped note). **ADR-004 7-verb contract unchanged.**
- **`_gitops_gh_create_repo`** — rename-redirect-safe (compares resolved `full_name`; a 301 can't false-positive).
- **`livesmoke_gitops.sh`** — `_smoke` private-default (`SMOKE_VIS`) + explicit `main` `target_commitish`.
- **`what/specs/spec_gitops_provider_abstraction.md`** — §1.1 lib-fix addendum + banner flagging the ADR-013 host-policy reconciliation still pending in §3/§5; dry-run note → 23/23.
- **`how/campaigns/.../missions/p6_fleet_alignment.md`** → `in_progress` (objective #1 ✅ + progress AAR). **`STATE.md`**, **`CLAUDE.md`** (→ v0.13), **`MANIFEST.md`** refreshed (lib-fixes folded; ledger built; Resume-Here unchanged R2/P6).

### Deferred
- **Live re-validation of the GitHub push-auth + Forgejo `cut-release`** — only provable by a real push/release; deferred to the next gated outward push (operator-run `livesmoke_gitops.sh`, now private-default, or a P6 wave). Validate-then-release.

---

## [v0.12] — 2026-06-20 — R1/P5 BEACHHEAD EXECUTED (first outward) + Host-Role Inversion (ADR-013)

> Operator chose **"execute the beachhead now"** (pilot `TypeScript.aDNA`, decouple Gate #1). Mid-execution, two pre-existing-resource surprises were caught + checkpointed before any clobber, and the operator **inverted the host policy**: **GitHub = public home · Codeberg = private FOSS-in-development** (ToS-scoped revival of ADR-003) — authored + ratified **ADR-013** (supersedes ADR-005, reverses SD-1). The agnostic contract was then **dogfooded live across both backends**. **First outward actions of the campaign** (DP4-authorized); token out-of-band throughout.

### Added
- **`what/decisions/adr_013_host_role_inversion.md`** (`accepted`) — GitHub-public-home / Codeberg-private-FOSS-dev / proprietary→GitHub-private→self-hosted; supersedes ADR-005, reverses SD-1; carries forward ADR-005's proprietary posture + Homecoming + the north star.
- **`how/tests/drill_report_p5_beachhead_20260620.md`** — rollback repoint-back drill **PASS** (gates R2).
- *(outward)* **`github.com/aDNA-Network/Git.aDNA`** — PUBLIC, 14 commits (the open standard's public home; anonymous-cloneable).
- *(outward)* **`codeberg.org/aDNA-Network/TypeScript.aDNA`** — PRIVATE pilot, 3 commits (FOSS-in-dev exemplar; authed-only, anon refused).

### Changed
- *(outward)* **GitHub predecessor `Git.aDNA`** (v0.1.x, 8 commits) renamed → **`Git.aDNA-legacy`** + archived read-only (archive-never-delete; GitHub redirects old refs). "Predecessor: None" provenance corrected.
- **`adr_005_visibility_host_policy.md`** → `superseded` (banner; `superseded_by: adr_013`).
- **`git/CLAUDE.md`** — `git_provider` → `github.com`/public/class P (reverses SD-1).
- **`CLAUDE.md`** (→ v0.12), **`MANIFEST.md`**, **`STATE.md`**, **`p5_codeberg_beachhead.md`** (re-scoped exit gate + AAR + `completed`), **`coord_delivery_queue.md`** (gate flips: token provisioned; Gate #1 decoupled) — all synced to ADR-013 + Resume-Here **R2/P6**.

### Findings (lib fixes — fold before the Rosetta `.adna/` release; validate-then-release)
- **GitHub git-push** rejects the lib's `Authorization: token`/`Bearer` extraHeader (OAuth `gho_`) → needs Basic/credential-helper; **Forgejo accepts** `Authorization: token`. **Forgejo `cut-release`** needs `target_commitish`. No **`create-org`** verb; GitHub **rename-redirect** fools get-or-create; **livesmoke** `_smoke` defaults public. *Dogfooding caught 5 lib bugs before they'd ship fleet-wide.*

### Deferred / Fast-follows
- Release-mirror → ADR-013 D4 open-flow (N/A today). Hestia `C58` inventory row + 1P backup; Rosetta `.adna/` release (validated). STATE → **R2/P6**.

---

## [v0.11] — 2026-06-20 — P5 prereq-drive (non-outward): Rosetta hand-off DELIVERED, Hestia kit READY-TO-DELIVER

> Operator chose **"Drive prereqs (non-outward)"**. Advanced both R1/P5 cross-vault hand-offs to the operator/outward boundary. **🚨 Finding:** `aDNA.aDNA`'s `skill_template_release` is **OUTWARD** (public-face push to `github.com/aDNA-Network/aDNA` + standard version-bump; node-local `.adna/` sync is the *tail* of that push; no sanctioned local-only path) and there's no open release gate — so **gate #1 cannot flip green under a non-outward authorization**; the non-outward portion (deliver + decision-resolve) was done, firing is a future operator-gated Rosetta release. **No outward actions / no `.adna/` edits / no token value / no remote/push.** Local commits in Git.aDNA + aDNA.aDNA.

### Added
- **`aDNA.aDNA/who/coordination/coord_2026_06_20_git_skill_upstreaming.md`** *(cross-vault — delivered into idle Rosetta vault, new file)* — inbound coord note: the upstreaming ask + the 4 resolved alignment decisions + the OUTWARD-release finding; status `received`, **queued for the next release gate (not fired)**.
- **`coord_draft_home_credentials_shims.md` §Provisioning Kit** — turnkey `CODEBERG_TOKEN` kit: operator mint steps (scopes `write:organization`+`write:repository`) · Keychain/1P/`~/.zshrc` stash commands · ready-to-paste NAMES-ONLY `C58` inventory row · host→env map · shim tie-in. All NAMES-only (no value transits).

### Changed
- **`coord_draft_adna_skill_upstreaming.md`** — status `draft → delivered`; 4 decisions RESOLVED with Git.aDNA recommendations (1 batch · supersede-in-place non-breaking · `git/` fork-inheritance fast-follow · advisory ships); OUTWARD-release finding banner; `mirror:` pointer.
- **`coord_draft_home_credentials_shims.md`** — status `draft → ready_to_deliver`; **delivery HELD** (Home.aDNA active Hestia session → collision-avoid); `mirror:` pointer.
- **`who/coordination/coord_delivery_queue.md`** — rows #1 → **DELIVERED** (awaiting outward release gate) / #2 → **READY-TO-DELIVER, held**; prerequisites note updated with the finding + the all-operator/outward remaining set.
- **`STATE.md`** — QUEUED-block prereq-drive note + 1 append-only intake-log entry.

### Finding
- **`skill_template_release` is outward + a Rosetta-governance event** — "release into `.adna/`" is not a local sync. Recorded in STATE, the delivery queue, and both memos. The non-outward runway for R1 is now **fully consumed**: remaining = (a) Rosetta release gate fires the batch, (b) operator mints `CODEBERG_TOKEN`, (c) operator DP4 + SD-2.

---

## [v0.10] — 2026-06-20 — P5 Step 0: live dispatch path wired (non-outward) + SD-1 ratified

> First build work of R1/P5, scoped **non-outward** per operator (AskUserQuestion: "Wire live path"). The dispatch lib's live branch (`LIVE-STUB`) is now real `gh`/`curl` execution behind the existing `GITOPS_ALLOW_LIVE=1` gate. **No outward actions / no `.adna/` edits / no cross-vault writes / no remote.** The three R1 gates (Rosetta release · Hestia `CODEBERG_TOKEN` · operator DP4) are unchanged — Step 0 only makes the tooling live-ready.

### Added
- **`how/tests/livesmoke_gitops.sh`** — OUTWARD live-smoke (create→push→release→clone→delete on `aDNA-Network/_smoke`), triple-gated (`GITOPS_ALLOW_LIVE=1` + `GITOPS_SMOKE=1` + token). Authored, **not run** this session; every refusal path exits 3 before any network.

### Changed
- **`how/skills/lib/gitops_dispatch.sh`** — `_gitops_emit` → dual-channel `_gitops_run <label> <PLAN> -- <argv>`: dry-run prints the PLAN verbatim (every harness substring preserved → **19/19 intact**); `GITOPS_ALLOW_LIVE=1` dispatches real executors — Forgejo (`_gitops_api`: curl `--config`-stdin auth, idempotent 409/422, fail-loud non-2xx, error redaction), GitHub (`gh api`), git (`set-remote`/`push` via `http.extraHeader` env-config), `port-ci` (local CI-template copy), + a smoke-only `_gitops_delete_repo`. Token discipline per ADR-007 D3 (resolved by env-var name; never in argv/`.git/config`/logs).
- **`git/CLAUDE.md`** — **SD-1 ratified**: Git.aDNA's own `git_provider` → `host: codeberg.org · backend: forgejo · visibility: public · class: P` (was private/GitHub/I); `origin` stays BLANK (P5 dogfood). Added an SD-1 note.
- **`STATE.md`** — QUEUED block (Step 0 WIRED + SD-1 paragraphs); frontmatter `last_session`; +1 append-only intake-log line.

### Fixed
- **Portability (Hopper).** Dropped the bash-only `${!name}` indirect token read — a "bad substitution" under **zsh** (this node's default shell) that bypassed the empty-token guard and let **one unauthenticated POST reach `codeberg.org` → HTTP 401** (no token, nothing created, no auth leaked). Replaced with a portable `case` + a belt-and-suspenders non-empty assert; the guard is re-verified to fire **before any network under bash AND zsh**.

---

## [v0.9] — 2026-06-20 — Governance doc-sync (CLAUDE/MANIFEST reconciled to P4-exit)

> Doc-only reconciliation. `CLAUDE.md` + `MANIFEST.md` had lagged at **v0.7** ("P0–P3 ✅ … at the P4-exit gate") — the v0.8 P4-exit-close commit updated STATE/CHANGELOG/charter but not them. Brought every governance surface into agreement: **P0–P4 ✅ · `campaign_gitops_rollout` ratified (P4-exit closed) · Resume-Here = R1/P5**. **No outward actions / no `.adna/` edits / no cross-vault writes.**

### Changed
- **`CLAUDE.md`** — top Status line, First-Run pointer, Genesis-Campaign phase table (P1–P4 → ✅; P7 → "Integrated Lighthouse Forge + Context-Sync" P7a/P7b per ADR-012; P5 marked Resume-Here), Resume-Here paragraph, and the workspace-router note (row **inserted** 2026-06-19, not "staged"); frontmatter `version 0.1→0.9` + `updated`.
- **`MANIFEST.md`** — Status section: "Phase 3 → P4 … P4 is Resume-Here" → "Phase 4 complete → R1/P5 is Resume-Here".
- **`how/campaigns/campaign_git_genesis/campaign_git_genesis.md`** — P4 mission-row status: `proposed → ratified (P4-exit closed)` (resolves the in-file contradiction with the gate line).
- **`STATE.md`** — frontmatter `last_session` + `tags` (phase_4→5) + one append-only intake-log line (body already current).

### Noted (follow-up, not in scope)
- `CLAUDE.md` Framework-Identity table still cites the superseded **ADR-002/003** ("Codeberg-private / GitHub-public") rather than **Path B (ADR-004/005)** — a pre-existing doctrine-reference drift, separate from the phase-pointer sync; flagged for a later pass.

---

## [v0.8] — 2026-06-20 — P4-exit closed (rollout charter ratified) + hand-offs queued

> Operator "make it so": **`campaign_gitops_rollout` ratified** (`proposed→accepted`, two-cycle) — the P4-exit gate is closed on our side; the genesis-planning campaign (P0–P4) is complete. Cross-vault hand-offs **queued, not delivered** (Rule 10). **No outward actions, no `.adna/` edits.** Next: R1/P5 (first outward) — gated on Rosetta release + Hestia `CODEBERG_TOKEN` + Decision Point 4.

### Changed
- **`campaign_gitops_rollout` → `accepted`** (DP1 done) — now the live execution charter (R1–R5).
- Rosetta + Hestia coord memos → **QUEUED for delivery**.

### Added
- `who/coordination/coord_delivery_queue.md` — the cross-vault hand-off delivery queue (Rosetta · Hestia · Berthier · Venus · Lighthouse) with triggers, what each unblocks, and the R1/P5 critical path.

---

## [v0.7] — 2026-06-20 — Re-Elevation Ratified + P4 (Upstream Coordination & Execution Charter)

> Operator ratified the re-elevation; opened + executed P4. Design/coordination only — **no outward actions, no `.adna/` edits**. Resume-Here → P4-exit gate (ratify the rollout charter + deliver the Rosetta memo) → R1/P5.

### Changed
- **ADR-012 → `accepted`** (lighthouse-operator default + git-as-context-sync + §8 forge-placement correction + Lighthouse.aDNA-now). Charter DP8 ratified; vision section marked ratified.
- **Root workspace router** (`~/aDNA/CLAUDE.md`): **`Lighthouse.aDNA` row inserted** (Project Discovery + Workspace Layout + Platform Ecosystem); **Git.aDNA row refreshed** to Path B + P0–P3 + Lighthouse-forked (`#needs-human` Hestia/PT). `Lighthouse.aDNA/STATE.md`: router row → inserted.
- **P4 executed**: Rosetta upstreaming memo finalized + staged (`coord_draft_adna_skill_upstreaming`); P4 mission → completed + AAR. Git.aDNA `CLAUDE.md` status refreshed (P0–P3 ✅ + re-elevation ratified).

### Added
- **`campaign_gitops_rollout`** (execution charter, `proposed`) — R1 Codeberg-FOSS beachhead · R2 fleet Path-B waves · R3 integration architecture (joint Network) · R4 integrated forge + context-sync spike · R5 adoption.

---

## [v0.6] — 2026-06-20 — Strategic Re-Elevation + Wind-Down

> Post-P3 review: captured the operator's elevated end-state (lighthouse-operator default · git-as-context-sync · decentralized-git-for-agentic-context) + 2 findings; forked the `Lighthouse.aDNA` stub. **Design/context only — no outward actions, no `.adna/` edits, no infra.** Resume-Here stays **P4**; the re-elevation (incl. ADR-012) awaits an operator ratification gate.

### Added
- `what/context/context_north_star_vision.md` (4 threads + triad + incremental path) + `what/context/context_gitops_options.md` (advisory decision guide).
- `what/decisions/adr_012_lighthouse_operator_default_and_context_sync.md` (`proposed`) — lighthouse-operator default + git-as-context-sync thesis + §8 forge-placement correction + Lighthouse.aDNA-now + decentralized-git objective.
- `how/skills/skill_gitops_advisor.md` (draft) — choose/interoperate/refactor advisory.
- `how/campaigns/campaign_git_genesis/missions/p7a_integration_architecture.md` (joint Network mission; precedes the spike).
- `who/coordination/coord_2026_06_20_git_lighthouse_handoff.md`; `how/backlog/idea_decentralized_git_for_agentic_context.md`.
- **`Lighthouse.aDNA`** genesis-planning stub forked (sibling vault — the deployable home; its own local git, no remote).
- Project memory: the elevated north-star vision.

### Changed
- Campaign charter: **Goal elevated** (+ fixed stale pre-Path-B wording) + North-Star vision section; risk register += §8 + scope-balloon; decision points += DP7-timing-amend, DP8 (default), DP9 (spike auth); **Phase 7 → P7a (integration arch, joint Network) + P7b (integrated forge + context-sync spike)**; timeline → 10 missions; Progress AAR (P0–P3) filed.
- `adr_010_mesh_git_north_star` — amendment pointer to ADR-012 (D1/D4 §8 forge-placement; D5 timing). `spec_gitops_provider_abstraction` + `skill_git_provider_config` — lighthouse-operator default encoded (policy + fork-hook).
- STATE — carried-facts (elevated vision · §8 finding · Lighthouse.aDNA fork) + P7 ladder row + intake entry.

### Findings
- 🚨 ADR-010 D1 collided with Network `ADR-016 §8` (forge ≠ lighthouse host) — corrected via ADR-012.
- Network already prototypes git-over-mesh context exchange (`adna-exchange` "drill #7") — P7 builds on it.

---

## [v0.5] — 2026-06-20 — P3 Specs & Tooling Skeleton

> Drafts only (Git.aDNA-local `how/`+`what/`); **no `.adna/` edits, no outward actions** (dry-run = plan-mode). Exit gate green: harness 19/19. P4 (Upstream Coordination) opens next.

### Added
- **Spec** `what/specs/spec_gitops_provider_abstraction.md` — consumer-facing contract (7 verbs + dispatch · `git_provider` schema · remote-naming · mirror gotchas · `git/` wrapper + `federation_ref` · dispatch-lib contract).
- **5 agnostic skill drafts** `how/skills/skill_{git_remote_setup,vault_publish,git_provider_config,repo_migrate,release_mirror}.md`.
- **Shared dispatch lib** `how/skills/lib/gitops_dispatch.sh` (the "`gh api` for Forgejo"; `--dry-run` plan mode; live refused without `GITOPS_ALLOW_LIVE`).
- **Doctrine block** `what/doctrine/doctrine_gitops_block.md` (ADR-009 D6); **gitleaks** pre-push hook `git/hooks/pre-push.gitleaks.sh` + `git/.gitleaks.toml` (ADR-011).
- **`git/` wrapper** `git/CLAUDE.md` (dogfood + consumer template); **CI templates** `what/templates/ci/{github,forgejo}/ci.yml` (ADR-008).
- **Dry-run harness** `how/tests/dryrun_gitops.sh` — 19/19 PASS.

### Changed
- `how/skills/skill_git_remote_setup.md` + `skill_vault_publish.md` — the inherited GitHub-hardcoded v7.0 copies superseded by provider-agnostic drafts (`status: draft`).

---

## [v0.4] — 2026-06-20 — P2 Ratified (+ two-review revision pass)

> P2-exit gate: operator-approved revision pass (closing two independent adversarial reviews' gaps), then **ADRs 004–011 ratified `proposed → accepted`**. Architecture-only; **no outward writes**. P3 (Specs & Tooling Skeleton) opens next.

### Added
- **`adr_011_secret_scanning`** (binding) — `gitleaks` pre-push hook + CI scan + **hard full-history pre-move gate** (I-strict client repos need operator sign-off) + `git-filter-repo` remediation. Closes the campaign's **#1 High risk** (history secret-leakage), previously only a label. Covers MIG-006 / SEC-002.

### Changed
- **ADRs 004–011 → `accepted`** (ratified at the P2-exit gate).
- **`adr_008`** CI framing corrected — Forgejo Actions is *familiar, not byte-compatible* (P1 evidence) + native `.github/` fallback; `port-ci` now emits a `.forgejo/` variant **only where a delta requires it**; new **D6** disposition for package/OCI registry (FRG-003 → provider-managed/per-graph; self-hosted → Lighthouse). **`adr_004`** `port-ci` wording aligned.
- **`adr_009`** D3 — **server-side signing enforcement** (FRG-006, P5+) + secret-scan hook; D6 doctrine block gains a secret-hygiene line. **`adr_010`** D4 — explicit **SEC-004** (audit-retention) disposition.
- **`adr_006`** D3 / **`adr_005`** D7 wired to ADR-011 (pre-move scan gate). **`adr_007`** — decision-point citation fix + SSH-signing-key row.

### Findings
- Two independent adversarial reviews converged: architecture sound, clears the gate; the only must-fixes were the secret-scan mechanism + the CI compatibility framing — both closed before ratification.

---

## [v0.3] — 2026-06-20 — P2 Architecture & Binding ADRs

> Architecture-only. **No outward writes** (local commits; no remotes/pushes/`.adna` edits). P2-entry gate cleared (operator: **Path B** + classification **approve-in-principle**); ends at the **P2-exit ratification gate** (ADRs 004–010 `proposed`).

### Added
- **7 binding ADRs (`proposed`)** — `adr_004_provider_contract_interface` (verbs · GitHub-API + raw Forgejo REST · per-graph schema · mirror gotchas) · `adr_005_visibility_host_policy` (**Codeberg-ToS amendment + Path B**; classification-in-principle; intended-public set) · `adr_006_remote_naming` (origin/mirror/upstream/rollback) · `adr_007_credential_model` (Codeberg/Forgejo PAT via Home broker) · `adr_008_ci_cd_parity` (`.github` ↔ `.forgejo`) · `adr_009_dev_process_doctrine` (branch/commit/sign/PR + multi-graph coordination) · `adr_010_mesh_git_north_star` (lighthouse Forgejo + ForgeFed realism; **DP7 → separate `Lighthouse.aDNA`**).
- P2 session file (`session_stanley_20260620_git_genesis_p2`).

### Changed
- **`adr_002` + `adr_003` → `superseded`** (by `adr_004` / `adr_005`) — banners + `superseded_by` pointers; content preserved (SO#6).
- **Default host policy reframed** — "Codeberg-private / GitHub-public" (ADR-003) → **Path B** (Codeberg FOSS-only; private→GitHub-interim→self-hosted; ADR-005).
- Home + aDNALabs **coord memos finalized + staged** (Rule 10 — not delivered).
- Campaign charter: **DP2 done** (approve-in-principle), **DP7 resolved** (separate `Lighthouse.aDNA`); P1 row → complete; P2 row → authored/awaiting-ratification. P2 mission → `completed` + AAR.

### Findings
- Path B makes near-term outward work **only FOSS→Codeberg**; private-repo decentralization is **earned by the P7 self-hosted spike** (restore-drill gate; ADR-010 D2), not rushed.

---

## [v0.2] — 2026-06-19 — P1 Research & Fleet Git-State Inventory

> Read-only research phase (local inventory + read-only `gh`/web). **No outward writes.**

### Added
- `what/inventory/fleet_git_state.md` — authoritative fleet git-state ledger (visibility resolved via `gh repo list`; draft classification).
- `what/context/context_provider_tooling_sota.md` — Forgejo/Codeberg/ForgeFed SOTA; **tool-of-record = raw Forgejo REST API** (not `tea`).
- `what/requirements/req_triage_inscope.md` — 14-domain seed-REQ in-scope triage.

### Findings (→ P2-entry gate)
- 🚨 **Codeberg ToS prohibits private proprietary repos** → **amends `adr_003_visibility_split_policy`** ("private→Codeberg" invalid); corrected: Codeberg=FOSS / self-hosted-Forgejo=private (north star pulled forward) / GitHub=interim-private+public.
- Fleet ~95% PRIVATE on GitHub; intended-public OSS set must be flipped public.
- ForgeFed experimental (federated stars only); near-term mesh = mirroring + REST.

---

## [v0.1] — 2026-06-19 — Genesis (Operation Free Harbor, P0)

> Governance v0.1. Graph genesis'd from `.adna/`; **direct-authored, not onboarded**. Plan-first / gated-execution — **no outward actions** (no remotes, no pushes, no `.adna/` edits). **P0 charter gate RATIFIED 2026-06-19** (operator APPROVE): ADRs 000–003 → `accepted`; category **Framework.aDNA** confirmed; persona **Grace Hopper** ratified; router row **inserted** into root `~/aDNA/CLAUDE.md` (operator-authorized); **P1** (fleet inventory + provider SOTA) opened.

### Added
- **Genesis scaffold** — forked `.adna/` structure in-place; `who/what/how` legs; local `git init` (no remote).
- **4 framing ADRs (`proposed`)** — `adr_000_project_identity` (name · **Framework.aDNA reframe** from Platform-provisional · persona **Grace Hopper** · scope=git/forge/CI-CD · codename *Operation Free Harbor*) · `adr_001_seed_docs_reframe` (Lighthouse seed → adopt-and-generalize) · `adr_002_provider_abstraction` (git-ops contract over GitHub-API + Forgejo-API; Forgejo covers Codeberg **and** self-hosted) · `adr_003_visibility_split_policy` (Codeberg-private / GitHub-public / release-mirror).
- **Genesis campaign** `campaign_git_genesis` ("Operation Free Harbor") — 9-phase ladder (P0–P8), risk register, verification strategy; P0 mission + **P1–P8 mission stubs**.
- **Operational trio** — `STATE.md` (phase ladder · carried facts · live git landscape · intake log), `CLAUDE.md` (Hopper identity · Standing Orders), `MANIFEST.md` (Framework identity).
- **4 coordination memos staged** — aDNA.aDNA (skill upstreaming) · aDNALabs.aDNA (Homecoming coexistence) · Network.aDNA (mesh-git) · Home.aDNA (credentials + shim registry).
- **Fork-provenance memo** with the staged root-router row (Platform→Framework reframe; pending Hestia/PT ack).

### Changed
- **Seed set folded + reframed** — the 2026-06-11 *Lighthouse.aDNA* seed docs (00–05) relocated into `what/{doctrine,architecture,requirements}/` with agnostic-reframe banners (04/05 kept in `what/architecture/_seed/`). The "git.aDNA-canonical / GitHub-harbor" thesis is generalized to provider-agnostic.
- **CHANGELOG reset** — from the inherited standard changelog to this graph-specific one.

### Triaged / Preserved
- The mislabeled root `AGENTS.md` (a **zip blob**) + `files.zip` preserved as intake provenance at `how/campaigns/campaign_git_genesis/_seed_intake/` (archive-never-delete).
- Inherited template ADRs (Obsidian / YAML / system-config) archived → `what/decisions/_archive/`.
