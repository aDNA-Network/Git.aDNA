---
plan_id: p6_fleet_alignment
type: plan
title: "P6 — Fleet Alignment"
owner: stanley
status: in_progress
campaign_id: campaign_git_genesis
campaign_phase: 6
campaign_mission_number: 6
mission_class: implementation
created: 2026-06-19
updated: 2026-06-21
last_edited_by: agent_stanley
tags: [plan, campaign, git, genesis, fleet_alignment, waved, operation_free_harbor]
---

# Mission: P6 — Fleet Alignment

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 6 — Fleet Alignment · **Mission**: 6 of 8

## Goal
Bring the whole `.aDNA` fleet into the platform-agnostic paradigm — each graph declares a host policy, carries the doctrine block, and lands on the right host (Codeberg-private / GitHub-public) — in **gated waves, lowest-risk first**. This is the "update/align all other graphs" mandate.

## Exit Gate
Every wave operator-gated; `disposition_ledger.md` reconciles to **zero unaccounted graphs**; each graph carries a `git/` host declaration + the doctrine block + updated STATE/MANIFEST; the `Home.aDNA` **shim registry** (Rule 9) records every remote re-point with a rollback path.

## Objectives (sketch — expand when phase opens; one sub-mission per wave)
1. **Disposition ledger** — build `disposition_ledger.md` from `fleet_git_state.md` (every graph: current host → target host → class → wave). **✅ DONE 2026-06-21** → [[disposition_ledger]] (45 graphs + nested + external; **zero unaccounted**; re-mapped to the ADR-013 table; 5-wave sequence; gate-ready Wave 1 checklist authored). **✅ RECONCILED to ground truth 2026-06-21** (released-vs-dev resolved, conservative; 5 mis-classifications corrected; wave semantics explicit).
1b. **Wave-1 gate-ready prep** — **✅ DONE 2026-06-21** (non-outward): doctrine block + spec reconciled to ADR-013 (so the fleet never inherits pre-inversion text); **6 Wave-1 secret-scans pre-cleared** (5 clean, Molecules = 16 confirmed false-positives → staged allowlist); **per-graph artifacts staged** → [[wave1_runbook]] (declarations · doctrine-paste · gitops commands · verify · 6 shim entries · STATE/MANIFEST patches) + Berthier Wave-1 coord addendum. **Wave execution is the DP5 gate (next).**
2. **Wave 1 — low-risk internal** — vaults with no LFS / client data / live consumers → Codeberg. **🔵 Wave 1a ✅ FIRED 2026-06-21** (`VisualDNA` + `Lighthouse` → Codeberg-private greenfield first-remotes). **🔵 Wave 1b CANARY (`Videos`) ✅ FIRED 2026-06-21** (first host-move; Wave-1a F1/F2 folded + dogfooded live). **🔵 Wave 1b SECOND GATE (`Oration` + `Spacemacs`) ✅ FIRED 2026-06-21** (name-drift + cross-org host-moves; F1's first real `main→master` PATCH). **Held:** `Molecules` (collision — active `session_sc_m4` + dirty tree) + **Wave 2** (public flips) remain separately gated.
3. **Wave 2 — daily-drivers** — active vaults.
4. **Wave 3 — code-as-WHAT nested repos** — `lattice-protocol`, `contextscope`, `harness`, … (handle their separate `.git` remotes).
5. **Wave 4 — client / sensitive** — history-scan mandatory before any host move (CakeHealth, sws/*, etc.).
6. **Per-graph touch** — host declaration + doctrine block + STATE/MANIFEST + shim-registry entry.
7. **Public set** — confirm public graphs stay on GitHub (optionally add a Codeberg dev-mirror).

## Campaign Context
- **Prev (M5)**: proven beachhead + agnostic skills + rollback drill.
- **Next (M8)**: a converged fleet feeds closeout + standing drift-detection.

## Notes
- **Coordinate every wave with `aDNALabs.aDNA`** (Operation Homecoming coexistence) and register re-points in the shim ledger. Public graphs are already correct — don't move them.

## Progress — 2026-06-21 (objective #1; non-outward)
Disposition ledger authored + a gate-ready Wave 1 checklist; mission opened (`planned → in_progress`). **No waves executed** — every move is DP5-gated. The load-bearing finding: **ADR-013 reverses the P1 plan** — the private/internal majority **stays GitHub-private-interim** (touch-only, no Codeberg); only the FOSS-in-dev subset → Codeberg-private; released-FOSS → GitHub-public. Pivotal open call surfaced for the operator: **released-vs-in-dev** per OSS-intended graph. Prereq folded same session: the **5 P5 beachhead lib fixes** (dry-run 23/23). Session: `session_stanley_20260621_git_p6_prep`.

### Progress AAR (objective #1 — disposition ledger)
- **Worked**: re-mapping straight off `fleet_git_state.md` + ADR-013's D1 table reconciled all 45 graphs to zero-unaccounted in one pass; the reconciliation table makes the exit-gate criterion checkable.
- **Didn't**: the released-vs-in-dev split can't be auto-decided — it's a genuine per-graph operator call, so the ledger proposes defaults + `(confirm)` rather than asserting.
- **Finding**: ADR-013 shrinks P6's outward scope dramatically vs the P1 "almost everything → Codeberg" estimate — most graphs don't move at all.
- **Change**: none.
- **Follow-up**: operator decision rows (released-vs-dev · name-drift · cross-org · unmapped) → resolve at the Wave 1/2 gates; Berthier coord for cross-org/name-drift.

## Progress — 2026-06-21 (objective #1 reconcile + #1b Wave-1 gate-ready prep; non-outward)
Session `session_stanley_20260621_git_p6_wave1_prep`. Operator resolved the three gate decisions (posture = non-outward reconcile+stage · released-threshold = conservative · drift/cross-org = reconcile-now). **Reconnaissance found the ledger's Wave-1b defaults mis-classified vs ground truth** → corrected **5 mappings** (`Canvas`+`Astro` released→W2-GitHub-public; `ComfyUI` internal→W3 never-Codeberg; `Spacemacs` FOSS-dev→W1b) and made wave semantics explicit (W1=private-moves · W2=public-flips · W3=internal-touch). **Second finding:** the doctrine block + spec §3/§5 still cited the **superseded ADR-005** ("public/FOSS→Codeberg") — reconciled to ADR-013 *before* staging, so the fleet never inherits pre-inversion text. **Pre-cleared 6 Wave-1 secret-scans** (read-only): 5 clean; **Molecules = 16 confirmed false-positives** (8-char verdict enums in `execution_result.json`; `generic-api-key` on dict-words — NO secret, NO rotation) → scoped allowlist staged. **Staged the per-graph Wave-1 artifacts** ([[wave1_runbook]]) + the Berthier Wave-1 coord addendum. **No outward · no `.adna/` edits · no cross-vault writes** (all staged in Git.aDNA). Dry-run 23/23 intact.

### Progress AAR (objective #1b — Wave-1 gate-ready prep)
- **Worked**: pre-clearing the scans before the outward gate paid off immediately — it caught that Molecules' pre-push hook would have *failed* (rc=1) at the live wave, and the triage (read-only, field-name not value) proved it a false-positive class without exposing a secret. Reconciling doctrine/spec to ADR-013 before staging prevented propagating superseded host-policy text to the whole fleet.
- **Didn't**: live re-validation of the host-move push path is still deferred (no outward action this session) — proven at the gate.
- **Finding**: the ledger's *proposed defaults* were materially wrong for the released graphs (Canvas/Astro) — a reminder that "released-vs-dev" needs ground-truth STATE.md reads, not just router descriptions. The conservative threshold + per-graph recon together produced a defensible, gate-ready Wave-1 set.
- **Change**: Wave structure clarified (private-moves-first, public-flips-deferred-and-separated) — reduces the irreversible-exposure risk surface of the first gate.
- **Follow-up**: deliver the Berthier coord + (optional) Hestia `C58`/shim-registry activation before firing; the DP5 gate fires Wave 1; Wave 2 (public flips) is its own later per-graph gate. Consider a baseline `.gitleaks.toml` tune for the verdict-enum FP class if it recurs fleet-wide.

## Progress — 2026-06-21 (objective #2 — Wave 1a FIRED; OUTWARD, scope-limited)
Session `session_stanley_20260621_git_p6_wave1a_fire`. Operator resume "continue the campaign" → AskUserQuestion scope = **Wave 1a only (greenfield)**; ExitPlanMode approval = the **rollout DP5 gate** (scope-limited to 1a). **Executed both greenfield FOSS-in-dev graphs → Codeberg-PRIVATE first-remotes:** `VisualDNA.aDNA` + `Lighthouse.aDNA` (fresh `gitleaks` clean → `gitops_create_repo`/`set_remote`/`push` via the agnostic lib → API `private:true` + anon-clone refused; default-branch corrected `main`→`master`). Per graph: `git/` wrapper + Git-Ops doctrine block + `gitleaks` pre-push hook (**dogfooded clean on the live wrapper push**) + STATE/MANIFEST host-fact. Home origins-record coord delivered (**no §C shim** — greenfield). Ledger rows ✅; runbook 1a marked executed; dry-run **23/23** intact. **Boundaries:** no GitHub action, no public exposure, no 1b/W2, no `.adna/` edits.

### Progress AAR (objective #2 — Wave 1a)
- **Worked**: the whole agnostic chain ran clean on real consumer vaults first try — `gitops_*` verbs (Forgejo backend), out-of-band token (Keychain, never echoed), and the pre-push gitleaks hook all behaved live exactly as the dry-run + beachhead predicted. Greenfield-first was the right call: zero cross-vault coordination, fully deletable, lowest possible exposure for the first fleet-scale firing.
- **Didn't**: the host-move (1b) push path + Berthier coordination + Spacemacs FOSS-intent are still unexercised — deferred to the 1b gate by design.
- **Finding (F1)**: the lib's `create-repo` leaves Codeberg's `default_branch=main`; graphs on `master` need a follow-up `PATCH default_branch` (done by hand this session) — fold into `gitops_create_repo` (set default branch to the pushed branch) before the Rosetta release.
- **Finding (F2)**: the canonical `pre-push.gitleaks.sh` reads `$repo_root/.gitleaks.toml`, but the wrapper/runbook stage the config at `git/.gitleaks.toml` — bridged this session with a root symlink. **Reconcile before Wave 1b** (Molecules' false-positive allowlist must sit where the hook reads it) — either teach the hook to also check `git/.gitleaks.toml`/`GITLEAKS_CONFIG`, or standardize on the repo-root path.
- **Change**: none to the contract; the 2 findings are lib/hook polish (queued for the next gated push + Rosetta upstreaming).
- **Follow-up**: Wave 1b gate (deliver Berthier coord + Spacemacs confirm) → then Wave 2 public flips (per-graph, hard scan). Fold F1/F2 into the lib + hook; carry into the Rosetta `.adna/` release batch.

## Progress — 2026-06-21 (objective #2 cont. — Wave 1b CANARY [Videos] FIRED + F1/F2 folded; OUTWARD, scope-limited)
Session `session_stanley_20260621_git_p6_wave1b_canary`. Operator "continue the campaign" → AskUserQuestion: **Spacemacs = FOSS-in-dev** + **posture = canary (Videos) then hold**; ExitPlanMode = the **rollout DP5 gate** (scope = the Videos canary). **Phase 1 (non-outward):** folded the two Wave-1a findings — **F1** `_gitops_git_push` PATCHes the Forgejo `default_branch` to the pushed branch **post-push** (GitHub no-op); **F2** the pre-push hook **+** Forgejo CI template resolve config via `$GITLEAKS_CONFIG`→`git/.gitleaks.toml`→root (no symlink). Dry-run **23/23 → 24/24**; bash/zsh `-n` + shellcheck clean. Runbook reconciled; **Berthier coord delivered** (aDNALabs-side commit deferred — concurrent `leg_a` session). **Phase 2 (canary, outward):** `Videos.aDNA` host-moved GitHub-private → Codeberg-**private** — F1 fired live (`default_branch → main`, no hand-PATCH) + F2 dogfooded (`pre-push: gitleaks clean ✓`); verified `private:true` + anon-refused + HEAD `7a2c29c` == `origin/main` + authed-clone OK; old GH origin kept as remote `rollback` (30d). Home §C shim coord delivered (new host-move / git-remote-rollback class). **Held (turnkey):** `Molecules`/`Oration`/`Spacemacs`.

### Progress AAR (objective #2 — Wave 1b canary)
- **Worked**: the canary validated both folded fixes on a real host-move in one shot — F1's post-push PATCH set `default_branch` automatically, F2's config search found `git/.gitleaks.toml` with no symlink (hook dogfooded clean on the live push), and the host-move (rename origin→rollback → create → push) was clean + fully reversible. Videos was the right canary (no name-drift, no cross-org).
- **Didn't**: the name-drift (Molecules/Oration) + cross-org (Spacemacs) host-moves are unexercised — held by operator choice; Berthier's GitHub-side disposition (deferred 30d) untested.
- **Finding**: F1's `main`→`master` *value-change* wasn't exercised (Videos is on `main`); the PATCH path ran idempotently (main→main) but the master-correction gets its definitive live test when Oration/Spacemacs fire. **Collision-avoidance finding**: a concurrent `leg_a_iii_hardening` session appeared in aDNALabs *after* my initial empty collision-check ⇒ re-check at write-time, not just plan-time (mirrors Hestia's §C "read-at-use" rule); the coord was delivered as a clean new file but the aDNALabs-side commit was deferred to Berthier.
- **Change**: the 2 Wave-1a findings are **closed** — F1/F2 folded into the lib + hook + Forgejo CI; manual PATCH + symlink dropped from the runbook.
- **Follow-up**: operator authorizes the held Wave 1b set (Molecules → Oration → Spacemacs; quick confirm; name-drift/cross-org need the Berthier ack) → then Wave 2 public flips. Carry F1/F2 into the Rosetta `.adna/` release batch (now **7** folded fixes: 5 P5 + F1 + F2). Hestia registers the Videos §C shim.

## Progress — 2026-06-21 (objective #2 cont. — Wave 1b SECOND GATE [Oration + Spacemacs] FIRED; Molecules held-collision; OUTWARD, scope-limited)
Session `session_stanley_20260621_git_p6_wave1b_oration_spacemacs`. Operator "continue the campaign" → AskUserQuestion scope = **fire all 3 held**; **pre-flight caught a `Molecules` collision** (active `session_sc_m4_2026_06_21` + dirty sc_web_configurator tree) → second AskUserQuestion → **fire `Oration` + `Spacemacs`, hold `Molecules`**; ExitPlanMode = the DP5 gate (scope = the two clean graphs). Both host-moved GitHub-private → Codeberg-**private**: `Oration.aDNA` (`aDNA-Network/SpeechForge.aDNA` → `…/Oration.aDNA`, **name-drift**; HEAD `c9be5fd`) · `Spacemacs.aDNA` (`LatticeProtocol/Spacemacs.aDNA` → `…/Spacemacs.aDNA`, **cross-org**; `master`+`v1.0.0` tag; HEAD `3dd833e`). Per graph: fresh `gitleaks` clean → rename origin→rollback → `gitops_create_repo`/`set_remote`/`push` → **F1 fired live** (the **first real `main→master` default-branch PATCH**) → artifacts (git/ wrapper pin `6eb0fca` + doctrine + hook + STATE/MANIFEST) committed → **F2 dogfood `pre-push: gitleaks clean ✓`**. Verified both `private:true` + anon-refused + HEAD==`origin/master` + authed-clone OK; old GH origins kept as `rollback` (30d). Home §C shim coord (both rows) + Berthier coord ack-update delivered (collision-checked clean, uncommitted → owners register). dry-run **24/24** intact.

### Progress AAR (objective #2 — Wave 1b second gate)
- **Worked**: the two held graphs fired clean, sequenced with per-graph verify + halt-on-failure. F1's *value-change* path (`main`→`master`) — untested by the canary's `main→main` no-op — worked first try on both; F2 dogfooded clean on both. The name-drift (Oration) and cross-org (Spacemacs) moves were mechanically identical to the canary's plain move — the wrinkles are Berthier's GitHub-side disposition at window close, not the move itself.
- **Didn't**: `Molecules` — pre-flight found an active session + dirty tree → correctly held (collision-avoid); not fired.
- **Finding**: pre-flight (porcelain + fresh-session check) is **load-bearing** — it caught the Molecules collision that the staged runbook had marked "turnkey." Lesson: re-verify clean-tree + no-active-session **at the gate**, not just at staging (mirrors the canary's "read-at-use" collision finding). Also: Spacemacs's STATE carried a stale "pending `v1.0.0` remote push" — the host-move resolved it (onto Codeberg) and the line was reconciled in-place.
- **Change**: ledger Oration+Spacemacs → ✅ FIRED, Molecules → HELD-COLLISION; runbook as-fired; CHANGELOG v0.17.
- **Follow-up**: operator authorizes `Molecules` once `session_sc_m4` closes + tree clean (turnkey) → then Wave 2 public flips. Fast-follows unchanged: Rosetta `.adna/` release (7 folded fixes), Hestia registers the 3 §C shims (Videos + Oration + Spacemacs) + C58.

## AAR (final — append before `status: completed`)
*Append at mission completion (after the waves converge).*
