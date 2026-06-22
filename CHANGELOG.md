# Changelog — Git.aDNA

All notable changes to the **Git.aDNA** graph are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Governance version lives in `CLAUDE.md` frontmatter.

> This graph tracks **git/forge/CI-CD** doctrine + tooling for the aDNA fleet. The aDNA *standard's* changelog lives in `aDNA.aDNA` (this file was reset from the inherited template changelog at genesis).

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
