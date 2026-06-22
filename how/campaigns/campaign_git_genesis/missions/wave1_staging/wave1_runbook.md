---
type: runbook
runbook_id: wave1_runbook
title: "P6 Wave 1 — gate-ready execution runbook + staged per-graph artifacts"
created: 2026-06-21
updated: 2026-06-21
status: staged
last_edited_by: agent_stanley
campaign: campaign_git_genesis
phase: P6
binds_adrs: [adr_013, adr_006, adr_007, adr_004, adr_011]
gate: rollout_DP5
tags: [runbook, wave1, fleet_alignment, staged, dp5_gated, outward, operation_free_harbor]
---

# P6 Wave 1 — Execution Runbook + Staged Per-Graph Artifacts

> **STATUS: Wave 1a ✅ EXECUTED 2026-06-21** (`VisualDNA` + `Lighthouse` → Codeberg-private; DP5 scope-limited to 1a). **Wave 1b + declaration-only(`TypeScript`) STAGED — NOT EXECUTED (separate gate).** Outward + cross-vault → fires only at the operator gate (rollout DP5). This is the single source for the Wave-1 firing: per graph, the ready-to-write `git/CLAUDE.md` declaration, the doctrine-paste target, the exact `gitops_*` command sequence, the verify steps, the Home shim entry, and the STATE/MANIFEST patch. Authored in Git.aDNA (Rule 10 — staged, applied into target vaults only at the gate). Re-mapped + scan-pre-cleared per [[disposition_ledger]] (2026-06-21).

## Wave 1 set (corrected, conservative threshold)
- **1a greenfield (local-only → Codeberg-private):** `VisualDNA.aDNA`, `Lighthouse.aDNA`.
- **1b host-move (GitHub-private → Codeberg-private):** `Videos.aDNA`, `Molecules.aDNA`, `Oration.aDNA`, `Spacemacs.aDNA`.
- **Declaration-only (done at P5):** `TypeScript.aDNA` — already on Codeberg-private; just needs the `git/` wrapper + doctrine block.
- **NOT in Wave 1:** `Canvas`/`Astro` → Wave 2 (released→GitHub-public); `ComfyUI` → Wave 3 (internal, never Codeberg).

## Pre-clear status (2026-06-21, non-outward)
| Graph | Wave | Current origin | Branch | Secret-scan (full history) |
|---|---|---|---|---|
| `VisualDNA.aDNA` | 1a | — (local-only) | master | ✅ clean |
| `Lighthouse.aDNA` | 1a | — (local-only) | master | ✅ clean |
| `Videos.aDNA` | 1b | `github.com/aDNA-Network/Videos.aDNA` | main | ✅ clean |
| `Molecules.aDNA` | 1b | `github.com/aDNA-Network/MoleculeForge.aDNA` | main | ⚠️→✅ 16 FALSE-POSITIVES (verdict enums; allowlist staged → `molecules.gitleaks.toml`) |
| `Oration.aDNA` | 1b | `github.com/aDNA-Network/SpeechForge.aDNA` | master | ✅ clean |
| `Spacemacs.aDNA` | 1b | `github.com/LatticeProtocol/Spacemacs.aDNA` | master | ✅ clean |
| `TypeScript.aDNA` | done | `codeberg.org/aDNA-Network/TypeScript.aDNA` | master | ✅ (P5) |

## Prerequisites at the gate
1. `CODEBERG_TOKEN` exported (Hestia broker; provisioned P5). `export GITOPS_ALLOW_LIVE=1`.
2. `source ~/aDNA/Git.aDNA/how/skills/lib/gitops_dispatch.sh` (the agnostic verb lib; 5 P5 + 2 Wave-1a fixes (F1/F2) folded; dry-run 24/24).
3. **Berthier coord delivered + ack'd** for the name-drift/cross-org cases (`who/coordination/coord_2026_06_21_berthier_wave1_homecoming.md`) — **before** any 1b move.
4. Fresh re-scan each graph at the moment of move (the pre-clear above is a point-in-time check).
5. Confirm no active session in the target vault (collision-avoid; mirror the Hestia P5 discipline).

---

## Wave 1a — greenfield (local-only → Codeberg-private) — ✅ EXECUTED 2026-06-21

> **As-fired note (2026-06-21):** both graphs created Codeberg-private, `master` pushed, default-branch corrected `main`→`master`, wrapper/doctrine/hook/STATE-MANIFEST applied, pre-push hook **dogfooded clean** on the live push, anon-clone refused (private proven). **2 findings folded to the AAR:** (F1) the lib's `create-repo` leaves Codeberg's `default_branch=main` — graphs on `master` need a follow-up `PATCH default_branch`; (F2) the pre-push hook reads `$repo_root/.gitleaks.toml` but the wrapper/runbook place config at `git/.gitleaks.toml` — bridged with a root symlink (mattered for Molecules' allowlist at 1b). **Both FOLDED 2026-06-21** (`session_stanley_20260621_git_p6_wave1b_canary`): F1 → `_gitops_git_push` PATCHes the Forgejo `default_branch` to the pushed branch post-push (idempotent; GitHub no-op); F2 → the hook **and** the Forgejo CI template resolve config via `$GITLEAKS_CONFIG` → `git/.gitleaks.toml` → root (**no symlink**). Dry-run 24/24.

### Common sequence (per graph `G`, run from `~/aDNA/<G>`)
```bash
# 0. pre-flight + fresh scan
git -C ~/aDNA/<G> remote -v            # expect empty
gitleaks detect --source ~/aDNA/<G> --config ~/aDNA/Git.aDNA/git/.gitleaks.toml --redact --no-banner   # expect clean
# 1. create the private Codeberg repo, wire origin, push
gitops_create_repo codeberg.org aDNA-Network <G> private
cd ~/aDNA/<G>
gitops_set_remote codeberg.org aDNA-Network <G> origin
gitops_push <branch>                   # Forgejo token auth (proven live at P5)
# 2. verify
git clone https://codeberg.org/aDNA-Network/<G>.git /tmp/_verify_<G>   # authed → OK
GIT_TERMINAL_PROMPT=0 git clone https://codeberg.org/aDNA-Network/<G>.git /tmp/_anon_<G> 2>&1 | grep -qi 'fatal' && echo "anon REFUSED ✅ (private)"
rm -rf /tmp/_verify_<G> /tmp/_anon_<G>
# 3. install hook, 4. apply declaration + doctrine, 5. shim entry, 6. STATE/MANIFEST (see per-graph below)
```

### `VisualDNA.aDNA` (class P-dev · branch `master`)
**Staged `VisualDNA.aDNA/git/CLAUDE.md`:**
```yaml
---
type: wrapper
wrapper: git
created: 2026-06-21
updated: 2026-06-21
status: active
last_edited_by: agent_stanley
tags: [wrapper, git, federation, git_provider]
---

# `git/` — VisualDNA.aDNA consumer wrapper (federates Git.aDNA)

federation_ref:
  source_vault: Git.aDNA
  source_skill: how/skills/skill_git_provider_config.md
  version: "0.1.0"
  version_policy: minor
  pinned_at_commit: "<Git.aDNA HEAD at apply>"
  binds_adrs: [adr_004, adr_006, adr_007, adr_008, adr_009, adr_011, adr_013]
  verbs_exposed: [create-repo, set-remote, push, open-pr, cut-release, configure-mirror, port-ci]
  local_extensions: []
git_provider:
  host: codeberg.org
  backend: forgejo
  org: aDNA-Network
  visibility: private          # P-dev — FOSS-in-dev, opens to GitHub at release (ADR-013 D4)
  class: P
  lfs: false
  remotes:
    origin: https://codeberg.org/aDNA-Network/VisualDNA.aDNA.git
    mirror:
    upstream:
```
- **Commands:** the common 1a sequence with `<G>=VisualDNA.aDNA`, `<branch>=master`.
- **Doctrine:** paste the canonical [[doctrine_gitops_block]] fenced block (ADR-013 v., 7 items) under a `## Git-Ops` heading in `VisualDNA.aDNA/CLAUDE.md`.
- **Hook:** `ln -sf ../../git/hooks/pre-push.gitleaks.sh ~/aDNA/VisualDNA.aDNA/.git/hooks/pre-push` (copy `Git.aDNA/git/hooks/` + `.gitleaks.toml` into `VisualDNA.aDNA/git/` first).
- **Shim entry (→ Home.aDNA, staged):** `VisualDNA.aDNA | codeberg.org/aDNA-Network/VisualDNA.aDNA | first-remote | rollback: none (greenfield) | window: n/a | owner: Pygmalion`.
- **STATE/MANIFEST patch:** add host fact "origin = codeberg.org/aDNA-Network/VisualDNA.aDNA (private, P-dev; set <date>)" to `VisualDNA.aDNA/STATE.md` + MANIFEST.

### `Lighthouse.aDNA` (class P-dev · branch `master`)
**Staged `Lighthouse.aDNA/git/CLAUDE.md`:** identical to VisualDNA's, with `origin: https://codeberg.org/aDNA-Network/Lighthouse.aDNA.git`.
- **Commands:** common 1a sequence with `<G>=Lighthouse.aDNA`, `<branch>=master`.
- **Doctrine / Hook / Shim / STATE-MANIFEST:** as VisualDNA (owner: TBD-at-P0). Shim: `Lighthouse.aDNA | codeberg.org/aDNA-Network/Lighthouse.aDNA | first-remote | rollback: none | owner: Lighthouse`.

---

## Wave 1b — host-move (GitHub-private → Codeberg-private)

> **Berthier coord required first** for name-drift (`Molecules`, `Oration`) + cross-org (`Spacemacs`). The host-move keeps a `rollback` remote (old GitHub origin) until the shim window closes — fully reversible.

### Common sequence (per graph `G`, run from `~/aDNA/<G>`)
```bash
cd ~/aDNA/<G>
# 0. fresh full-history scan (Molecules: use its own git/.gitleaks.toml)
gitleaks detect --source . --config ~/aDNA/Git.aDNA/git/.gitleaks.toml --redact --no-banner   # expect clean
# 1. host-move (ADR-006 §4): keep the old origin as rollback
git remote rename origin rollback
gitops_create_repo codeberg.org aDNA-Network <G> private
gitops_set_remote codeberg.org aDNA-Network <G> origin
gitops_push <branch>                 # default branch + tags; F1: auto-PATCHes Forgejo default_branch=<branch> post-push
# extra branches ONLY (most graphs are single-branch ⇒ the line above is the complete history):
#   GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=http.extraHeader GIT_CONFIG_VALUE_0="Authorization: token $CODEBERG_TOKEN" git push origin --all
# 2. verify authed-clone OK + anon-refused (as 1a); confirm Codeberg default_branch == <branch> (F1, no hand-PATCH)
# 3. declaration + doctrine + hook (F2: hook reads git/.gitleaks.toml directly — no symlink) + shim(rollback=old GH origin) + STATE/MANIFEST
# 4. retire `git remote remove rollback` ONLY at shim-window close (default 30d), after ref-sweep-zero
```

### `Videos.aDNA` (class P-dev · branch `main` · no drift)
- **git/CLAUDE.md:** as the 1a template, `origin: https://codeberg.org/aDNA-Network/Videos.aDNA.git`, `<branch>=main`.
- **Move:** common 1b with `<G>=Videos.aDNA`. No rename, no cross-org (already `aDNA-Network`).
- **Shim (→ Home):** `Videos.aDNA | codeberg.org/aDNA-Network/Videos.aDNA | host-move | rollback: github.com/aDNA-Network/Videos.aDNA | window: 30d | owner: Iris`.

### `Molecules.aDNA` (class P-dev · branch `main` · **name-drift** `MoleculeForge.aDNA`→`Molecules.aDNA`)
- **git/CLAUDE.md:** `origin: https://codeberg.org/aDNA-Network/Molecules.aDNA.git`; add `local_extensions` for the scan override:
```yaml
  local_extensions:
    - kind: hooks
      path: git/.gitleaks.toml
      rationale: scoped allowlist for execution_result.json verdict-enum false-positives (Git.aDNA P6 triage 2026-06-21)
```
- **Scan override:** copy `wave1_staging/molecules.gitleaks.toml` → `Molecules.aDNA/git/.gitleaks.toml` **before** the pre-move scan; re-scan with it → clean.
- **Move:** common 1b with `<G>=Molecules.aDNA` (new Codeberg name = dirname, NOT `moleculeforge`). The old `github.com/aDNA-Network/MoleculeForge.aDNA` becomes `rollback`.
- **Berthier:** GitHub-side rename/redirect `MoleculeForge.aDNA`→`Molecules.aDNA` (Homecoming) — coordinate.
- **Shim (→ Home):** `Molecules.aDNA | codeberg.org/aDNA-Network/Molecules.aDNA | host-move+rename | rollback: github.com/aDNA-Network/MoleculeForge.aDNA | window: 30d | owner: Franklin`.

### `Oration.aDNA` (class P-dev · branch `master` · **name-drift** `SpeechForge.aDNA`→`Oration.aDNA`)
- **git/CLAUDE.md:** `origin: https://codeberg.org/aDNA-Network/Oration.aDNA.git`, `<branch>=master`.
- **Move:** common 1b with `<G>=Oration.aDNA`. Old `github.com/aDNA-Network/SpeechForge.aDNA` → `rollback`.
- **Berthier:** GitHub-side rename `SpeechForge.aDNA`→`Oration.aDNA`.
- **Shim (→ Home):** `Oration.aDNA | codeberg.org/aDNA-Network/Oration.aDNA | host-move+rename | rollback: github.com/aDNA-Network/SpeechForge.aDNA | window: 30d | owner: R.Kennedy`.

### `Spacemacs.aDNA` (class P-dev · **FOSS-intent CONFIRMED 2026-06-21** · branch `master` · **cross-org** `LatticeProtocol`→`aDNA-Network`)
- **git/CLAUDE.md:** `origin: https://codeberg.org/aDNA-Network/Spacemacs.aDNA.git`, `<branch>=master`.
- **Move:** common 1b with `<G>=Spacemacs.aDNA`. Old `github.com/LatticeProtocol/Spacemacs.aDNA` → `rollback`.
- **✅ FOSS-intent confirmed** (operator, this session — context-native fork of GPLv3 Spacemacs): goes to **Codeberg-private**, opens to GitHub at release (ADR-013 D4). The "if internal → Wave-3" branch is retired.
- **Berthier:** cross-org migration story (`LatticeProtocol`→`aDNA-Network`); on Codeberg here, not GitHub.
- **Shim (→ Home):** `Spacemacs.aDNA | codeberg.org/aDNA-Network/Spacemacs.aDNA | host-move+cross-org | rollback: github.com/LatticeProtocol/Spacemacs.aDNA | window: 30d | owner: Daedalus`.

---

## Declaration-only — `TypeScript.aDNA` (done at P5; gets its wrapper now)
Already on `codeberg.org/aDNA-Network/TypeScript.aDNA` (private, P5 pilot). No move — just author `TypeScript.aDNA/git/CLAUDE.md` (1a template, `origin` = the live Codeberg URL, `<branch>=master`), paste the doctrine block, install the hook. No new shim (origin already live; record it as the canonical home).

---

## Wave 2 (DEFERRED — separate per-graph gate)
`aDNA.aDNA`, `III.aDNA`, `Canvas.aDNA`, `Astro.aDNA` → **GitHub-public visibility flip.** Each runs its own gate with a **mandatory hard full-history secret-scan** (public exposure). `Astro` sequences cross-org migrate (`LatticeProtocol`→`aDNA-Network`) + rename → scan → flip. **Not part of Wave 1.**

## Apply-order at the gate
1. Deliver + ack the Berthier coord. 2. Wave 1a (`VisualDNA`, `Lighthouse`) — lowest risk, greenfield, fully rollbackable. 3. `TypeScript` declaration (no move). 4. Wave 1b (`Videos` → `Molecules` → `Oration` → `Spacemacs`), each: fresh scan → host-move → verify → declaration/doctrine/hook → shim → STATE/MANIFEST. 5. Flip each ledger row to ✅; update Git.aDNA STATE.
**Nothing here runs without the DP5 gate** (Standing Order #1/#2).
