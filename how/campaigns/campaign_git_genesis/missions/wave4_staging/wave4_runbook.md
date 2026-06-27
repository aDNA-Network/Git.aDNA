---
type: runbook
runbook_id: wave4_runbook
title: "P6 Wave 4 — nested code-as-WHAT federation-touch runbook + staged artifacts (reconciliation)"
created: 2026-06-27
updated: 2026-06-27
status: staged
last_edited_by: agent_stanley
campaign: campaign_git_genesis
phase: P6
wave: 4
binds_adrs: [adr_013, adr_006, adr_008, adr_011, adr_004, adr_007]
gate: rollout_DP5
coordinates_with: aDNALabs.aDNA   # Berthier — the org-migration program (WS-1) owns per-repo host execution
tags: [runbook, wave4, fleet_alignment, nested_code_as_what, federation_reconciliation, staged, dp5_gated, operation_free_harbor]
---

# P6 Wave 4 — Nested code-as-WHAT Federation-Touch Runbook (Reconciliation)

> **STATUS (2026-06-27, non-outward staging — `session_stanley_20260627_git_p6_wave4_staging`): RECONCILED to ground truth + federation-touch pattern generalized; gate-ready for a Berthier-coordinated per-repo fire.** The plan's "migrate 7 nested repos" premise was **overtaken by events** — the **host-migration is already largely done** by two parallel workstreams, so Wave 4's real residue is the **Git.aDNA federation *touch*** (the `git/` declaration + `## Git-Ops` doctrine + gitleaks hook + CI-parity), **not** a host move. **Fire = a separate rollout DP5 gate, coordinated with Berthier's WS-1 program** (Standing Order #1/#10).

## ⭐ Ground-truth reconciliation (read first) — Wave 4 is NOT greenfield

A fresh re-probe (F-W3-e discipline — verify actual git state, not the recorded status) found the nested-repo landscape already moved:

| Nested repo (path under `~/aDNA/`) | Live origin (now) | `legacy` remote? | Host state | Federation touch | Wave-4 residue |
|---|---|---|---|---|---|
| `Harness.aDNA/what/harness` | `aDNA-Network/adna-harness` (private) | — | ✅ **DONE 06-26** (first-remote + CI green `631f7a0`) | ✅ committed-into-repo | **NONE — this is the EXEMPLAR** |
| `LatticeProtocol.aDNA/what/latticeprotocol` | `aDNA-Network/lattice-protocol` | ✅ `LatticeProtocol/…` | ✅ WS-1 host-moved | ❌ no wrapper | **federation touch** (I/R) |
| `Lab.aDNA/what/lab` (`latlab`) | `aDNA-Network/latlab` | ✅ `LatticeProtocol/…` | ✅ WS-1 host-moved | ❌ no wrapper | **federation touch** (I; 5-dirty hold) |
| `Lab.aDNA/what/lab-workspace` (`latlab-lab`) | `aDNA-Network/latlab-lab` (**ssh**) | — | ✅ on aDNA-Network | ❌ no wrapper | **federation touch** (I; ssh push) |
| `Context.aDNA/what/contextscope` | `aDNA-Network/contextscope` | — | ✅ on aDNA-Network | ❌ no wrapper | **federation touch** (I) |
| `Molecules.aDNA/what/moleculeforge` | `aDNA-Network/moleculeforge` | ✅ `LatticeProtocol/…` | ✅ WS-1 host-moved (GitHub) | ❌ no wrapper | **federation touch + HOST-DECISION** (P-dev?→Codeberg vs stay-I; active-dev collision) |
| `DataRoom.aDNA/what/dataroom` | **NO-ORIGIN** | — | class **L** (never-push) | ❌ | **declaration only** (no remote, ever) |

**Two parallel workstreams already executed the host moves:**
1. **Berthier's aDNALabs WS-1 pilot** (early June; `aDNALabs.aDNA/how/sessions/history/2026-06/session_*_ws1_*`) host-moved `lattice-protocol` · `latlab` · `moleculeforge` from the `LatticeProtocol` GitHub org → `aDNA-Network`, keeping the old origin as a **`legacy`** remote (the WS rollback convention). These were the **org-migration program** (Operation Homecoming), which Git.aDNA's charter explicitly defers to Berthier ("we supply patterns; they run the org-level program").
2. **The Harness team** (`Harness.aDNA/.../session_20260625_gitadna_wave4_harness_code_federation`, **completed** 06-26) took `what/harness` to its **first remote** `aDNA-Network/adna-harness` (private, class I) + portable CI + the `git/` wrapper **committed into the repo**, explicitly framed as "Git.aDNA R2/P6 Wave 4 / WS-1 pilot #4." → the **canonical exemplar** this runbook generalizes.

**Git.aDNA's own record (the disposition ledger) knew none of this** — an **F-W4-a** desync (the F-W3-e class, applied to Wave 4): on every "continue," verify each nested repo's *actual* origin/legacy/wrapper state, not the recorded one. Reconciled here + in [[disposition_ledger]] + STATE + the p6 AAR.

## How Wave 4 differs from Waves 1–3 (the code-repo federation touch)

| | Wave 3 (vault touch) | **Wave 4 (nested code-repo touch)** |
|---|---|---|
| Target | aDNA **vault** (`CLAUDE.md`/`STATE.md`/`MANIFEST.md`) | standalone **code repo** (own `.git`, own remote, may lack vault files) |
| Wrapper | `git/CLAUDE.md` lives **in the vault** | `git/CLAUDE.md` committed **INTO the repo** (federation travels with the standalone repo) |
| Doctrine | `## Git-Ops` block in the vault `CLAUDE.md` | `## Git-Ops` in the repo's `CLAUDE.md` (**code-tailored**; add a minimal `CLAUDE.md` if the repo lacks one) |
| Host-fact | STATE/MANIFEST patch | **none** (no STATE/MANIFEST) — the host-fact lives in the in-repo `git/CLAUDE.md` + the parent vault's STATE |
| Host move | per ADR-013 | **mostly already done** (WS-1 + Harness) — Wave 4 ≈ federation-only; the one open host call is `moleculeforge` |
| CI | (vault has none) | **CI-parity matters** — portable `.github/workflows/ci.yml` (ADR-008); `.forgejo/` delta only if host-moved to Codeberg |
| Owner | Git.aDNA (Hopper) | **Git.aDNA supplies the pattern; Berthier's WS-1 program runs per-repo execution** (coordinate first) |
| New verb | none | **none** — `gitops_push` (touch) / the host-move trio (only if `moleculeforge`→Codeberg); dry-run **31/31** |

**No new lib verb is required for Wave 4.** The federation touch is `gitops_push` to the existing origin (the proven 3a mechanic); only a `moleculeforge`→Codeberg decision would invoke the Wave-1b host-move trio. The dispatch lib stays at dry-run **31/31**.

## The harness exemplar — the canonical code-repo federation touch (generalize this)

`Harness.aDNA/what/harness` (federated 06-26) is the reference. Per repo `R`:

1. **`R/git/CLAUDE.md`** (committed INTO `R`) — the code-repo wrapper variant: `federation_ref` (pin = Git.aDNA HEAD at apply; binds ADR-004/006/007/008/011/013; `verbs_exposed`) + `git_provider` (`host`/`backend`/`org`/`visibility`/`class`/`repo_name`/`remotes`). States plainly it is committed into the repo "so the git-ops doctrine, classification (and any PHI boundary) travel with the standalone repo." Template in §"Staged artifact" below.
2. **`## Git-Ops` block in `R/CLAUDE.md`** — a **code-tailored** 7-item doctrine (remotes per ADR-006 · local-first/HEAD-is-truth · outward-gated · creds via Home broker/never-inlined · CI portable-first ADR-008 · cross-graph writes staged Rule 10 · gitleaks pre-push + full-history-gate-before-host-move ADR-011). If `R` has **no `CLAUDE.md`** (`contextscope`, `moleculeforge`), add a **minimal** one (code-as-WHAT header + governing-vault pointer + the three travelling facts: classification, git-ops doctrine, any data boundary) — the harness CLAUDE.md is the model.
3. **`R/git/.gitleaks.toml`** — `[extend] useDefault = true`; **omit `[allowlist]` if the repo scans clean** (gitleaks 8.x rejects an empty `[allowlist]` table). For FP repos, apply the staged per-repo allowlist (see §Pre-clear).
4. **Pre-push hook** — copy `Git.aDNA/git/hooks/` into `R/git/hooks/`, then `ln -sf ../../git/hooks/pre-push.gitleaks.sh R/.git/hooks/pre-push`. (All 7 nested repos have `core.hooksPath` **unset** — no F-W3-c chaining needed; standard symlink works.)
5. **CI parity (ADR-008)** — ensure `R/.github/workflows/ci.yml` (the portable Git.aDNA template; gitleaks + shellcheck/lint; Forgejo falls back to it). `lattice-protocol` + `moleculeforge` + `harness` already carry `.github` — align, don't clobber. Add a `.forgejo/workflows/ci.yml` delta **only** if `R` host-moves to Codeberg (i.e., `moleculeforge` if the host-decision lands on Codeberg).
6. **Commit INTO `R`** (stage-only-mine) → **dogfood push** to the existing origin via `gitops_push <branch>` (pre-push hook fires live) → verify (`anon-clone refused` / `private:true` / HEAD match).

## Pre-clear status (2026-06-27, non-outward; full-history `gitleaks detect`)

| Repo | Commits | Raw hits | Verdict | Scan config at gate |
|---|---|---|---|---|
| `contextscope` | 64 | 0 | ✅ **clean** | baseline (`[extend] useDefault`, no allowlist) |
| `lattice-protocol` | 121 | 0 | ✅ **clean** | baseline |
| `latlab` | 340 | 15 | ▲→✅ **all FP** (11 test-fixture + **4 `Ed25519PrivateKey` param type-annotations** — the Network S100 class-name pattern) | staged `latlab.gitleaks.toml` ✅ re-scan clean |
| `latlab-lab` | 4 | 0 | ✅ **clean** | baseline |
| `moleculeforge` | 44 | 71 | ▲→✅ **all FP** (`runs/*/execution_result.json` cache_key/verdict hashes — the parent-Molecules class) | staged `moleculeforge.gitleaks.toml` ✅ re-scan clean |
| `harness` | 41 | 0 | ✅ **DONE** (clean at 06-26 federation; the exemplar) | — |
| `dataroom` | (L) | — | scan **deferred** | class L never-push (~120 G legal IP); scan only if ever remoted |

**Scan summary:** 5 pending scanned · 3 clean · 2 FP (latlab 15 / moleculeforge 71) — **all triaged false-positive, no real secret**; 2 allowlists staged + **validated** (each re-scans to 0). Re-scan fresh at the gate (ADR-011 hard gate; the pre-push hook fires live on the artifact commit).

## Findings (→ p6 AAR + fast-follow)
- **F-W4-a (record desync):** Git.aDNA's ledger did not reflect the WS-1 host-moves, the `legacy` remotes, or the `adna-harness` federation. Reconciled. **Generalize F-W3-e: a nested repo's state can be changed by another persona's program (Berthier WS-1, the Harness team) — verify origin/legacy/wrapper live before staging.**
- **F-W4-b (`Ed25519PrivateKey` type-annotation FP is fleet-wide):** `signing_key: Ed25519PrivateKey` / `private_key: Ed25519PrivateKey` Python annotations trip `generic-api-key` (latlab here; Network's S100 noted the same class-name pattern). Candidate for the Git.aDNA baseline allowlist (a `regexTarget="match"` regex), like the `^\.obsidian/plugins/` fold (F-W3-b). Deferred — baseline edit is its own decision (Rosetta `.adna/` release).
- **F-W4-c (`runs/*/execution_result.json` FP is a Molecules-family pattern):** both the parent vault (Wave 1b, 16 FP) and the nested code repo (71 FP) hit eval-run output hashes. Per-repo allowlist is correct (not baseline — `runs/` is Molecules-specific).
- **F-W4-d (ssh remote):** `latlab-lab`'s origin is `git@github.com:…` (ssh). `gitops_push` resolves a token-based HTTPS path; at the gate either push over ssh natively (operator key) or temporarily set an HTTPS origin for the dogfood push. Flag in the per-repo sequence.
- **F-W4-e (`moleculeforge` host-decision unresolved):** WS-1 placed it on GitHub-`aDNA-Network` (class I), but the parent `Molecules.aDNA` is P-dev → Codeberg-private (Wave 1b). The nested code repo's class follows the **harness precedent** (classify to match parent + ledger + the WS coord) → operator/Berthier decision at the gate. Until resolved, `moleculeforge` is **HELD** (also: active-dev collision, commit 06-26 14:25).

## Prerequisites at the gate
1. **Berthier (aDNALabs/WS-1) coord delivered + ack'd** ([[berthier_wave4_coord]]) — Wave 4 federation runs **in lockstep with the org-migration program**; the host moves are theirs (already done), the federation pattern is ours.
2. **`GITHUB_TOKEN`** exported (`export GITHUB_TOKEN="$(gh auth token)"`; Home broker) + `export GITOPS_ALLOW_LIVE=1`; `source how/skills/lib/gitops_dispatch.sh` (dry-run **31/31**).
3. **Fresh full-history `gitleaks detect` → clean** per repo at touch (ADR-011 hard gate; FP repos use their staged allowlist).
4. **Porcelain-clean + no active session** in the target repo AND its parent vault (collision-avoid; F-W3-d dual-check before apply AND before commit). **`latlab` (5 dirty) + `moleculeforge` (active-dev) are HELD until quiet.**
5. **Per-repo `core.hooksPath` sweep** (Astro F-Astro) — all 7 are currently unset; re-verify at the gate.
6. **`moleculeforge` only:** operator/Berthier resolve the GitHub-I vs Codeberg-P-dev host-decision (F-W4-e) **before** touching it.

---

## Staged artifact — the in-repo `git/CLAUDE.md` template (code-as-WHAT)

Fill `<R>`/`<repo_name>`/`<branch>`/`<class>` from the table; `pinned_at_commit` = Git.aDNA HEAD at apply (**currently `855347e`**; re-pin if it advances by the gate). For `class I` repos `host: github.com`/`visibility: private`.

```yaml
---
type: wrapper
wrapper: git
created: 2026-06-27
updated: 2026-06-27
status: active
last_edited_by: agent_stanley
tags: [wrapper, git, federation, git_provider, code_as_what, wave4]
---

# `git/` — `<repo_name>` code-repo wrapper (federates Git.aDNA)

Federates **Git.aDNA** (Grace Hopper) — the platform-agnostic git / forge / CI-CD standard — via the III-style consumer-wrapper pattern. Schema: `Git.aDNA/what/specs/spec_gitops_provider_abstraction.md` §7. Set at Git.aDNA **R2/P6 Wave 4** (nested code-as-WHAT federation; [[adr_013_host_role_inversion|ADR-013]]). This wrapper is committed **INTO** the nested repo (vs the parent vault's, which lives in the vault) so the git-ops doctrine + classification travel with the standalone repo. Host already on `aDNA-Network` (WS-1 program); this touch adds the Git.aDNA federation only.

```yaml
federation_ref:
  source_vault: Git.aDNA
  source_skill: how/skills/skill_git_provider_config.md
  version: "0.1.0"
  version_policy: minor
  pinned_at_commit: "855347e"     # Git.aDNA HEAD at apply (re-pin if it advances by the gate)
  binds_adrs: [adr_004, adr_006, adr_007, adr_008, adr_011, adr_013]
  verbs_exposed: [create-repo, set-remote, push, open-pr, cut-release, configure-mirror, port-ci]
  local_extensions: []            # record a pre-existing root .gitleaks.toml here if one exists (F-W3-a)
git_provider:
  host: github.com                # moleculeforge: github.com OR codeberg.org per the F-W4-e decision
  backend: github                 # forgejo if Codeberg
  org: aDNA-Network
  visibility: private             # I — internal/proprietary, GitHub-private-interim → self-hosted post-P7 (ADR-013)
  class: I                        # moleculeforge: I or P-dev per F-W4-e
  lfs: false
  repo_name: <repo_name>          # e.g. lattice-protocol, latlab, latlab-lab, contextscope, moleculeforge
  legacy_remote:                  # if WS-1 left a `legacy` rollback remote, record it (Home shim-registry, Rule 9)
  remotes:
    origin: https://github.com/aDNA-Network/<repo_name>.git
    mirror:                       # n/a unless class R (e.g. lattice-protocol if the core lib publishes)
    upstream:
```
```

**`## Git-Ops` paste:** the code-tailored 7-item block (model: `Harness.aDNA/what/harness/CLAUDE.md` §Git-Ops; canonical doctrine: [[doctrine_gitops_block]]). **Hook:** `R/git/hooks/` + symlink (step 4 above). **CI:** the portable `.github/workflows/ci.yml` (align if present). **No STATE/MANIFEST** (code repo) — record the host-fact in the in-repo `git/CLAUDE.md` + the parent vault's STATE.

---

## Per-repo federation sequence

### 4a — federation touch, existing origin (4): `contextscope` · `lattice-protocol` · `latlab` · `latlab-lab`
```bash
cd ~/aDNA/<parent>/what/<repo>
# 0. pre-flight: porcelain-clean, sessionless (repo AND parent vault), hooksPath unset
git status --porcelain && git config --get core.hooksPath
# 1. fresh full-history scan (HARD GATE; FP repos: --config the staged allowlist)
gitleaks detect --source . --redact --no-banner [--config <staged allowlist>]   # exit 0 required
# 2. apply artifacts: git/CLAUDE.md (in-repo wrapper) + ## Git-Ops in CLAUDE.md (add minimal CLAUDE.md if absent)
#    + git/.gitleaks.toml (baseline OR staged allowlist) + hooks/ + symlink + align .github CI
# 3. commit INTO the repo (stage-only-mine)
git add -A && git commit -m "feat(git): Git.aDNA Wave-4 federation — git/ wrapper + Git-Ops doctrine + CI (class I)"
# 4. dogfood push to the EXISTING origin
export GITHUB_TOKEN="$(gh auth token)"; export GITOPS_ALLOW_LIVE=1
source ~/aDNA/Git.aDNA/how/skills/lib/gitops_dispatch.sh
gitops_push <branch>            # latlab-lab: ssh origin (F-W4-d) — push over ssh or temp-set https origin
# 5. verify: authed clone OK (git/ + ## Git-Ops present, HEAD match); anon clone REFUSED (private invariant)
# 6. NO §C shim (origin unchanged). If a `legacy` remote exists, Home records it (Rule 9) — do not retire here.
```
Per-repo: `contextscope` (`main`, no CLAUDE.md → add minimal; baseline scan) · `lattice-protocol` (`main`, has CLAUDE.md + `.github`; **I/R** — add a release-mirror note if the core lib publishes; baseline scan) · `latlab` (`main`, **HELD til 5-dirty clears**; no CLAUDE.md → add minimal; staged allowlist) · `latlab-lab` (`main`, ssh push F-W4-d; baseline scan).

### 4b — federation touch + (conditional) host-move (1): `moleculeforge`
**HELD pending F-W4-e** (host-decision) **and** the active-dev collision. Resolve first:
- **If class I (stay GitHub-`aDNA-Network`, matching WS-1 + the harness precedent):** identical to 4a (touch + push to the existing origin; staged allowlist).
- **If P-dev (follow parent `Molecules` → Codeberg-private):** the Wave-1b host-move — fresh scan → `git remote rename origin rollback2` (note: a `legacy` WS-1 remote already exists; name the new rollback distinctly) → `gitops_create_repo codeberg.org aDNA-Network moleculeforge private` → `gitops_set_remote` → `gitops_push <branch>` → add `.forgejo/workflows/ci.yml` delta → §C shim (Home). Add the `git/` wrapper with `host: codeberg.org`/`backend: forgejo`/`class: P`.

### 4c — class-L declaration (1): `dataroom`
**No remote, ever** (class L; never-push legal IP ~120 G). Declaration only, applied when its tree is quiet (currently 21-dirty):
- `git/CLAUDE.md` (L-variant: `class: L`, `remotes: { origin: }` empty, a note "never pushed — local IP") + `## Git-Ops` (defensive) + a **defensive** pre-push hook (refuses any accidental push) — the ComfyUI L-class precedent. **Nothing outward** (`git remote -v` stays empty).

## Apply-order at the gate
1. **Berthier coord delivered + ack'd** (the host-program owner) — then a **canary** (recommend `contextscope` or `lattice-protocol` — clean scan, quiet) → the rest of 4a.
2. **4b `moleculeforge`** — only after F-W4-e is resolved + the repo is quiet.
3. **4c `dataroom`** — declaration only, when its tree is quiet.
4. Flip each ledger row to ✅; update Git.aDNA STATE; Home records the `legacy` remotes (Rule 9) + any new §C shim (only if `moleculeforge`→Codeberg).
**Nothing here runs without the DP5 gate** (Standing Order #1/#2) **and Berthier coordination** (#10). Per-repo, scope-limited, like every prior wave.

## Staged allowlists (this dir)
- `latlab.gitleaks.toml` — `(^|/)tests/` + `extensions/*/tests/` + `.agentic/*.md` paths + the `(private_key|signing_key):\s*Ed25519PrivateKey` `regexTarget=match` regex. ✅ validated clean.
- `moleculeforge.gitleaks.toml` — `runs/.*/execution_result\.json` path. ✅ validated clean.
- `contextscope` / `lattice-protocol` / `latlab-lab` — **no staged file** (clean under the baseline `[extend] useDefault`).
