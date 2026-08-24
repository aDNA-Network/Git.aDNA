---
type: inventory
ledger_id: disposition_ledger
title: "P6 Disposition Ledger — fleet → ADR-013 host table"
created: 2026-06-21
updated: 2026-08-24   # §License-state roster APPENDED — discharges ADR-013 A1 §3 (23 rows, 0 absences, measured 2026-08-24T21:35Z)
status: active   # P6 reachable-complete at the R3 pivot — residual rows live in §Standing Waves below
last_edited_by: agent_stanley
campaign: campaign_git_genesis
phase: P6
binds_adrs: [adr_013, adr_006, adr_011, adr_007, adr_004]
supersedes_mapping_in: fleet_git_state.md
tags: [inventory, git, fleet, disposition_ledger, adr_013, p6, fleet_alignment, waved, operation_free_harbor]
---

# P6 Disposition Ledger — Fleet → ADR-013 Host Table

> **P6 (R2) core deliverable.** Re-maps every fleet graph (+ nested code-as-WHAT repos) from [[fleet_git_state]]'s pre-inversion draft classes to the **[[adr_013_host_role_inversion|ADR-013]]** host table, sequences the move into **operator-gated waves** (lowest-risk first), and reconciles to **zero unaccounted graphs** (the P6 exit-gate criterion). **This is a PLAN — no row here is executed.** Every host move / visibility flip / new remote is **outward** and fires only at its wave's operator gate (rollout DP5). The per-graph touch (declaration + doctrine block into another vault) is **cross-vault** (Rule 10) → staged, applied during gated waves.

> **🟢 RECONCILED to ground truth — 2026-06-21 (`session_stanley_20260621_git_p6_wave1_prep`, non-outward).** The operator resolved the three gate decisions: **(1) released threshold = CONSERVATIVE** — "released" = shipped a versioned standard/product **OR** has live *outside-the-fleet* consumers ⇒ exactly **`aDNA` · `III` · `Canvas` · `Astro`** (+ `Git.aDNA` ✅) → GitHub-public (Wave 2); everything else FOSS-intended → Codeberg-private (Wave 1); the ambiguous set (`Videos` · `Molecules` · `VisualDNA` · `Spacemacs`) → Codeberg-private. **(2) drift/cross-org = RECONCILE NOW** — rename-on-host (origin = dirname) + migrate cross-org stragglers to `aDNA-Network`, coord Berthier before firing. **(3) posture = non-outward reconcile + stage.** This corrected **5 mis-classifications** vs the original draft (read from each graph's STATE.md): `Canvas`+`Astro` are **released → W2** (were W1b→Codeberg — wrong host); `ComfyUI` is **internal (I) → W3/L** (was W1a — "NOT for release", Anduril-dep — never Codeberg); `Spacemacs` is **P-dev → W1b** (was W3); and the **wave semantics are now explicit** (W1 = private moves only · W2 = public flips · W3 = internal touch). The Wave 1 set + checklist below are **gate-ready**.

## ⭐ The load-bearing re-map (read first) — ADR-013 REVERSES the P1 plan

`fleet_git_state.md` drafted classes under the **pre-inversion** model (ADR-003/005: *private → Codeberg*; its finding #1 concluded "applying the split moves **almost the entire fleet → Codeberg**"). **ADR-013 inverts the direction:**

| ADR-013 class | What it is | Origin | Public face | P6 action shape |
|---|---|---|---|---|
| **P-released** | released FOSS | **GitHub** (public) | GitHub *is* the home | visibility-flip private→public (+ secret-scan) |
| **P-dev** | FOSS in private development | **Codeberg** (private) | GitHub at release (D4) | host-move→Codeberg or greenfield first-remote |
| **I** | internal / proprietary | **GitHub** (private, interim) → self-hosted post-P7 | — | **stays put**; per-graph touch only |
| **I-strict** | client / sensitive | **GitHub** (private) → self-hosted | — | **stays put**; history-scan before *any* touch; **never Codeberg** |
| **R** | release of internal work | private origin | GitHub mirror on tags | mirror config (D4 open-flow) |
| **L** | local-only | none | — | declaration only (Rule 4 / legal IP) |

⇒ **The private/internal majority does NOT move.** It stays **GitHub-private-interim** until self-hosted (post-P7) — P6 only gives it the `git/` declaration + doctrine block. **Codeberg is FOSS-only** and receives *only* the P-dev (FOSS-in-dev) subset. The released-FOSS subset flips **public on GitHub**. P6's outward migration scope is therefore **a fraction** of the P1 "almost everything → Codeberg" estimate.

**The pivotal per-graph operator call — released vs in-development — is RESOLVED (2026-06-21, conservative threshold).** The released set (→ GitHub-public, Wave 2) = **`aDNA` · `III` · `Canvas` · `Astro`**; every other OSS-intended graph → **Codeberg-private** (Wave 1), opening to GitHub at its own future release (ADR-013 D4). `(confirm)` markers below are retired except where a residual sub-question remains (`Spacemacs` FOSS-intent · `ComfyUI` local-vs-GitHub-private · `Datasets` remote-intent).

## Wave sequence (lowest-risk first) — each gated at rollout DP5

**Wave semantics (explicit, 2026-06-21):** **Wave 1 = private moves only** (FOSS-in-dev → Codeberg-private — the proven, rollbackable, lowest-exposure path) · **Wave 2 = public flips** (released-FOSS → GitHub-public — high blast radius, hard secret-scan, per-graph gated, *separated* from Wave 1) · **Wave 3 = internal touch-only** (no host move, no Codeberg) · **Wave 4 = nested repos** · **Wave 5 = client/I-strict** · **L = local-only declaration**. The public flips are deliberately deferred *after* the private moves so the riskiest, irreversible step runs last and individually.

| Wave | Set | Action | Risk | Gate prereqs |
|---|---|---|---|---|
| **1a** ✅ **FIRED 2026-06-21** | FOSS-in-dev, **local-only** → Codeberg-private | create-repo + set-remote + push (greenfield) | **lowest** — no existing remote; = the proven TypeScript pilot; fully rollbackable | token (C58 ✅) · per-repo gitleaks ✅ pre-cleared → **`VisualDNA`+`Lighthouse` DONE** |
| **1b** | FOSS-in-dev, **on GitHub-private** → Codeberg-private | host-move (rename origin→rollback · set new origin · push · shim · retire rollback) | medium — existing remote; reversible via rollback remote | **full-history secret-scan** ✅ pre-cleared · Berthier coord (Homecoming) · shim entry |
| **2** ✅ **COMPLETE 2026-06-22** | **Released-FOSS** → GitHub-public | visibility-flip private→public (+ name-drift / cross-org reconcile) | higher **exposure** blast radius → **deferred after W1, per-graph** | **full-history secret-scan (hard gate)** · **`aDNA`✅ `III`✅ `Canvas`✅** → GitHub-public (3/3); **`Astro`** resolved by reclassification → **W3 private** (BSL-1.1 keep-private; cross-org transfer+rename, no public flip) |
| **3** | **Internal/proprietary (I)** — the majority | per-graph touch only (declaration + doctrine + STATE/MANIFEST); name-drift + cross-org straggler migration | low (no host move / no Codeberg) | Berthier coord for cross-org/name-drift |
| **4** | **Nested code-as-WHAT repos** | classify + touch each independently (own remotes; parent≠child) | per-repo | NO-ORIGIN repos get first remote per class |
| **5** | **Client / I-strict** | history-scan MANDATORY before any touch; **never Codeberg**; → self-hosted | **most constrained** → last | operator sign-off per ADR-011; partner-org coord |
| **L** | **Local-only** | declaration only (class L; no remote) | none-outward | — |

---

## Master ledger (one row per canonical graph)

**Legend** — *Drift?* = origin repo-name ≠ dirname · *Scan* = full-history gitleaks gate required pre-move · *Shim* = Home.aDNA shim-registry entry required (Rule 9).

### Wave 1a — FOSS-in-dev, local-only → Codeberg-private (greenfield)
| Graph | Current | ADR-013 class | Target | Scan | Shim | Notes |
|---|---|---|---|---|---|---|
| `TypeScript.aDNA` | Codeberg-private ✅ | **P-dev** | Codeberg-private | ✅done | — | **DONE** (P5 pilot); declaration staged this session |
| `VisualDNA.aDNA` | **Codeberg-private ✅** | **P-dev** ✅ | Codeberg-private | ✅done (2026-06-21) | n/a (first remote) | **✅ DONE — Wave 1a FIRED 2026-06-21** (`origin` = codeberg.org/aDNA-Network/VisualDNA.aDNA, private; wrapper + doctrine + hook + STATE/MANIFEST applied; pre-push hook dogfooded clean). framework GA v1.0.0; may flip public at a later release gate |
| `Lighthouse.aDNA` | **Codeberg-private ✅** | **P-dev** ✅ | Codeberg-private | ✅done (2026-06-21) | n/a (first remote) | **✅ DONE — Wave 1a FIRED 2026-06-21** (`origin` = codeberg.org/aDNA-Network/Lighthouse.aDNA, private). new deployable stub; FOSS-intended (north-star) |

> **Re-mapped OUT of Wave 1a:** `ComfyUI.aDNA` → **Wave 3 / class I** — STATE.md is explicit "**NOT for release**" (research checkpoints, Anduril-dependent); internal, **never Codeberg**. Stays local (class L) or takes a first GitHub-private remote — operator confirm at the W3 gate.

### Wave 1b — FOSS-in-dev, on GitHub-private → Codeberg-private (host-move)
| Graph | Current | ADR-013 class | Target | Scan | Shim | Notes |
|---|---|---|---|---|---|---|
| `Videos.aDNA` | **Codeberg-private ✅** | **P-dev** ✅ | Codeberg-private | ✅done (2026-06-21) | ✅ delivered (host-move) | **✅ DONE — Wave 1b CANARY FIRED 2026-06-21** (`origin` = codeberg.org/aDNA-Network/Videos.aDNA, private; HEAD `7a2c29c`; old GH origin → remote `rollback` 30d; **F1** auto-set `default_branch=main` + **F2** pre-push hook dogfooded clean; wrapper+doctrine+hook+STATE/MANIFEST applied). forge; genesis-complete, pre-release |
| `Molecules.aDNA` | **Codeberg-private ✅** | **P-dev** ✅ | Codeberg-private `Molecules.aDNA` | ✅ FP-only clean (2026-06-22) | ✅ delivered (host-move+rename) | **✅ DONE — Wave 1b FIRED 2026-06-22** (`origin` = codeberg.org/aDNA-Network/Molecules.aDNA, private; HEAD `be9c4b9`; old GH `MoleculeForge.aDNA` → remote `rollback` 30d; branch `main` ⇒ **F1** main→main no-op (like Videos) + **F2** pre-push hook dogfooded clean **with the per-graph allowlist** [16 `execution_result.json` verdict-enum FPs]; wrapper+doctrine+hook+STATE/MANIFEST applied). Collision cleared (`session_sc_m4` completed + tree clean). **name-drift** → Berthier renames at shim-window close |
| `Oration.aDNA` | **Codeberg-private ✅** | **P-dev** ✅ | Codeberg-private `Oration.aDNA` | ✅ clean (2026-06-21) | ✅ delivered (host-move+rename) | **✅ DONE — Wave 1b FIRED 2026-06-21** (`origin` = codeberg.org/aDNA-Network/Oration.aDNA, private; HEAD `c9be5fd`; old GH `SpeechForge.aDNA` → remote `rollback` 30d; **F1** first real `main→master` default-branch PATCH + **F2** hook dogfooded clean; wrapper+doctrine+hook+STATE/MANIFEST applied). **name-drift** → Berthier renames at shim-window close |
| `Spacemacs.aDNA` | **Codeberg-private ✅** | **P-dev** · **FOSS-intent CONFIRMED 2026-06-21** | Codeberg-private | ✅ clean (2026-06-21) | ✅ delivered (host-move+cross-org) | **✅ DONE — Wave 1b FIRED 2026-06-21** (`origin` = codeberg.org/aDNA-Network/Spacemacs.aDNA, private; HEAD `3dd833e`; `master`+`v1.0.0` tag pushed; old `LatticeProtocol/Spacemacs.aDNA` → remote `rollback` 30d; **cross-org**→aDNA-Network on Codeberg; F1+F2 dogfooded clean; wrapper+doctrine+hook+STATE/MANIFEST applied). v1.0.0 push (was a pending operator action) now done → Codeberg; public gh-release = ADR-013 D4 open-flow |

> **Re-mapped OUT of Wave 1b → Wave 2 (released-FOSS → GitHub-public):** `Canvas.aDNA` (Op Keystone complete, **v2.0.0 shipped**, live consumers) + `Astro.aDNA` (production, phase 7 complete). Both are **released** → GitHub-public, **not** Codeberg-private. See Wave 2.

### Wave 2 — Released-FOSS → GitHub-public (visibility flip; deferred after W1, per-graph gated)
| Graph | Current | ADR-013 class | Target | Scan | Shim | Notes |
|---|---|---|---|---|---|---|
| `Git.aDNA` | GitHub-public ✅ | **P-released** | GitHub-public | ✅done | — | **DONE** (this graph; P5 beachhead) |
| `aDNA.aDNA` | **GitHub-PUBLIC ✅** | **P-released** ✅ | GitHub-public | ✅done (440 commits, 2026-06-22) | — | **✅ DONE — Wave 2 CANARY FIRED 2026-06-22** (`gitops_set_visibility` first live exercise; API `private:false`/`visibility:public`; anon-clone **succeeds**; HEAD `a12d9c0`; wrapper+doctrine+hook+MANIFEST applied; pre-push hook + **GitHub Basic-auth push** both dogfooded clean). dev-graph repo (distinct from the separately-released MIT image `aDNA-Network/aDNA`); **no shim** (visibility-only) |
| `III.aDNA` | **GitHub-PUBLIC ✅** | **P-released** ✅ | GitHub-public | ✅done (72 commits, 2026-06-22) | — | **✅ DONE — Wave 2 FIRED 2026-06-22** (HEAD `fb807f1`; `private:false`; anon-clone **succeeds**; 10 gitleaks hits ALL FP → scoped `git/.gitleaks.toml` allowlist [`idempotency_key` field-name prose + vendored `.obsidian/plugins` minified JS; `regexTarget=match`]; folded 1 untracked file; wrapper+doctrine+hook+MANIFEST applied; MANIFEST stale `LatticeProtocol`→`aDNA-Network` corrected). **no shim** (visibility-only) |
| `Canvas.aDNA` | **GitHub-PUBLIC ✅** | **P-released** ✅ | GitHub-public | ✅done (62 commits, 2026-06-22) | — | **✅ DONE — Wave 2 FIRED 2026-06-22** (branch `master`; HEAD `b345e7b`; `private:false`/`default_branch:master`; anon-clone **succeeds**; fresh full-history scan CLEAN → baseline `.gitleaks.toml`, no allowlist; wrapper+doctrine+hook+MANIFEST applied; **pre-existing uncommitted Operation Salon P0 work committed first as `79f372a` [HELD at P0→P1, NOT ratified]**). **no shim** (visibility-only) |
| `Astro.aDNA` | **GitHub-private ✅** `aDNA-Network/Astro.aDNA` | **I** (reclassified from P-released) | GitHub-private (→ W3) | ✅done (35 commits, 2026-06-22) | ✅ host-move | **✅ DONE — reclassified W2→W3, KEPT PRIVATE 2026-06-22.** Operator **BSL-1.1 posture = keep private** (source-available, not OSI-FOSS). GitHub-native cross-org **transfer + rename** `LatticeProtocol/SiteForge.aDNA` → `aDNA-Network/Astro.aDNA` (history/issues preserved; old paths redirect); pushed HEAD `0d0c315`; wrapper+doctrine+hook+STATE/MANIFEST applied; **`set_visibility public` NOT run** (anon-clone refused). §C shim (host-move; rollback = re-transfer — no `rollback` remote, native transfer). **Finding:** stale `core.hooksPath` (`~/lattice/…`) silently bypassed the pre-push hook on first push → unset + re-dogfooded clean. Revisit public exposure at a future license/release decision. Coord [[coord_2026_06_22_git_wave2_astro_cross_org]] |

> **🟢 Wave 2 — ✅ COMPLETE 2026-06-22 (public-flips 3/3 + Astro resolved).** `aDNA.aDNA` (canary; `gitops_set_visibility` first live exercise) + **`III.aDNA` ✅** (10 gitleaks hits all FP → scoped allowlist; HEAD `fb807f1`) + **`Canvas.aDNA` ✅** (`master`; fresh scan clean; salon P0 work committed first; HEAD `b345e7b`) — all three `private:false`, anon-clone **succeeds**, visibility-only (no shim). Each behind its own DP5 gate + fresh full-history scan; the collision discipline held. **`Astro` — RESOLVED 2026-06-22 by reclassification:** operator **BSL-1.1 posture = keep private** (source-available, not OSI-FOSS) ⇒ **reclassified W2 → W3 (class I)**; migrated home via a GitHub-native cross-org transfer + rename (`LatticeProtocol/SiteForge.aDNA` → `aDNA-Network/Astro.aDNA`, **private throughout**; HEAD `0d0c315`; anon-clone refused); `set_visibility public` NOT run; §C shim (rollback = re-transfer). See [[wave2_runbook]]. ⇒ **Wave 2 closed: 3/3 released graphs public; Astro private/W3.**
>
> Wave 2 secret-scans were a **hard full-history gate** (run per-graph at the Wave 2 session). Astro's scan ran clean (35 commits) before its private cross-org migrate.

### Wave 3 — Internal/proprietary (I) → stay GitHub-private-interim (touch only)

> **🟢 STAGED + SUB-WAVED 2026-06-22 (non-outward — `session_stanley_20260622_git_p6_wave3_staging`).** Wave 3 = **24 rows; `Astro` ✅ done; 23 remaining.** Authored [[wave3_runbook]] (no runbook existed) and split the heterogeneous set lowest-risk-first: **3a pure-touch (12)** `aDNALabs`·`Harness`·`Context`·`Network`·`Terminal`·`Obsidian`·`WorldGenome`·`ZenZachary`·`zeta`·`wga`·`AWSBootstrap`·`ScienceStanley` (origin correct → apply artifacts + `gitops_push`, no host move) · **3b name-drift+cross-org reconcile (8)** `LatticeProtocol`·`Lab`·`Operations`·`TappProtocol`·`VAAS` (drift) + `ContextCommons`·`LAVentureGraph` (cross-org) + `WilhelmAI` (partner-org, stays) → GitHub-native rename/transfer (Astro precedent) + Berthier coord [[berthier_wave3_coord]] · **3c local-only/first-remote, operator-decision (3)** `RemoteControl`·`Warp`·`ComfyUI`. **No new lib verb** (3a=`push`, 3c=greenfield trio→GitHub-private, 3b=GitHub-native; dry-run 31/31). **Pre-clear scans (read-only): 23 scanned · 18 clean · 5 FP (Network 23 · aDNALabs 13 · ScienceStanley 11 · LAVentureGraph 5 · Obsidian 1) ALL false-positive** (vendored `.obsidian/plugins/*.js` minified bundles + `Ed25519PrivateKey` class-name + `evt_<hex>` event IDs + `cert_sha256`). Allowlists staged (aDNALabs/LAVentureGraph/Obsidian); **Network + ScienceStanley pass under their OWN root `.gitleaks.toml`** (F-W3-a: touch must preserve, not clobber). F-W3-b: the `^\.obsidian/plugins/` FP is fleet-wide → baseline-allowlist candidate. **No §C shim for 3a/3c** (origin unchanged/greenfield); 3b transfers = Astro native-transfer/redirect sub-class. **Fire = separate per-sub-wave DP5 gate** (Standing Order #1). The `(confirm)`/`Action` notes below are retained as ground truth.

> **🔵 3a AS-FIRED 2026-06-22 (`session_stanley_20260622_git_p6_wave3a_fire`; DP5 gate, scope = 3a; operator: Full 3a, canary-led).** **8 FIRED ✅** — GitHub-private **in-place touch** (class I; origin unchanged; per graph: `git/` wrapper pin `3a31b0a` + `## Git-Ops` doctrine + pre-push hook + MANIFEST/STATE host-fact → `gitops_push <branch>` → pre-push `gitleaks clean ✓` + **anon-clone REFUSED** + `gh api .private=true`): `AWSBootstrap`(canary, `1a56a52`) · `Context`(`d58ac01`) · `Terminal`(`cedf46b`) · `WorldGenome`(`5230a25`) · `ZenZachary`(`200e991`) · `Obsidian`(`06eef39`, staged allowlist) · `wga`(`03d13b9`) · `Network`(`6027681`, **F-W3-a** — passed under its own root `.gitleaks.toml`; `git/.gitleaks.toml` intentionally NOT staged). **No `rollback` remote / no §C shim** (origins unchanged — lowest-risk outward action in the campaign). **4 HELD ⏸** (collision-avoid, prereq #4 porcelain-clean+sessionless; turnkey-refire when clean): `aDNALabs` (modified STATE + today's Berthier Q2-III work — don't bundle) · `zeta` (67 dirty incl. CLAUDE+STATE) · `Harness` (68 active sessions, live P7 `s7_stable_go_live_close`) · `ScienceStanley` (porcelain 0→5 mid-wave = live site-dev; **F-W3-c** hooksPath=`how/governance/hooks` bypasses `.git/hooks/pre-push` — refire places/chains the hook there; push `dev`; surface deferred `incident_20260528`). **Finding F-W3-c (NEW):** a set `core.hooksPath` silently no-ops the `.git/hooks/pre-push` symlink-install → fold into [[wave3_runbook]] + Rosetta `skill_git_provider_config`. **3a status: 8/12 done · 4 held.** Next = refire held → 3b (Berthier) → 3c (operator-decision).

> **🟢 3b AS-FIRED 2026-06-24 (`session_stanley_20260624_git_p6_wave3b_drift`; DP5 gate, scope = 4 quiet drift graphs; operator: Fire Wave 3b in-org renames, canary-led).** **3 FIRED ✅** — GitHub-native in-org **drift rename** (class I; stays private; per graph: `git/` wrapper pin `b5a7e48` + `## Git-Ops` doctrine + pre-push hook + host-fact → `gitops_push <branch>` → pre-push `gitleaks clean ✓` → `gh repo rename` → repoint origin → **anon-clone REFUSED** + `gh api .private=true` + old→new redirect resolves): `Operations`(`TaskForge.aDNA`→, `99f2750`, canary) · `VAAS`(`VAASLattice.aDNA`→, `b9593c0`) · `LatticeProtocol`(vault `latticeprotocol-adna`→, `adf62cb`; nested code repo = Wave 4, untouched). **No `rollback` remote / no windowed §C shim** (native-rename/redirect sub-class — rollback = re-rename; Hestia registers redirect notes, [[coord_2026_06_24_git_wave3b_hestia_redirect_shims]]). **1 HELD ⏸ `TappProtocol`** (`TappInterface.aDNA`→) — **live concurrent Mentor P9/i3 session** mutating 4 files in real time at fire (lip_draft/adr_006/spec_ledger_event_schema/coord_noether_lip003) → artifacts backed out cleanly, Mentor's work preserved (F-W3-d, caught at the before-commit re-check). **Non-outward prep: F-W3-b folded** — `^\.obsidian/plugins/` added to the baseline `git/.gitleaks.toml` (fleet-wide FP; dry-run 31/31; Git.aDNA scan clean) → the 3b wrapper pin advanced `3a31b0a`→`b5a7e48`. **Berthier coord delivery HELD** (aDNALabs busy — `q8_governance_dispositions` live); renames proceeded under operator ack. **3b status: 3/5 drift fired · TappProtocol held (live) · Lab held (dirty) · cross-org/partner pending. No new lib verb (dry-run 31/31).** Next = refire TappProtocol+Lab when quiet → cross-org (ContextCommons I-vs-Pdev + LAVentureGraph) → 3c.

> **🟢 3b CONTINUE AS-FIRED 2026-06-24 (`session_stanley_20260624_git_p6_wave3b_continue`; DP5 gate, scope = Lab + ContextCommons; operator: "Lab + ContextCommons" + CC class "I — stay private").** **2 FIRED ✅** (both GitHub-private throughout; per graph: fresh full-history `gitleaks` clean → `git/` wrapper pin `f35bfe6` + `## Git-Ops` doctrine + pre-push hook + STATE/MANIFEST host-fact → `gitops_push <branch>` → pre-push `gitleaks clean ✓` → host-action → repoint → **true anon-clone REFUSED** + `gh api .private=true` + old→new redirect ✓): **`Lab`** (in-org **drift rename** `lab-adna`→`Lab.aDNA`; `main`; `1928fd1`; the untracked Berthier Keystone four-wrapper coord left in place — stage-only-mine; nested `what/lab`+`lab-workspace` = Wave 4) · **`ContextCommons`** (the campaign's **first non-Astro cross-org transfer** `LatticeProtocol`→`aDNA-Network`; name unchanged; `main`; `568b94d`; **classified I at the gate** — source stays private though the deployed site `contextcommons.vercel.app` is public; `gitops_set_visibility` not run; transfer poll settled in 1×2s). **No `rollback` remote / no windowed §C shim** (native-rename/transfer redirect sub-class; Hestia registers redirect notes → [[coord_2026_06_24_git_wave3b_hestia_redirect_shims]]). **Berthier coord delivery STILL HELD** (aDNALabs busy — `q8_governance_dispositions` still live; both proceeded under operator ack, the 06-24 drift precedent). **No new lib verb** (dry-run 31/31). Housekeeping: stale empty `…_wave3a_refire2` session stub → history (superseded/never-fired). **3b status: drift `Operations`·`VAAS`·`LatticeProtocol`·`Lab` ✅ (4/5; `TappProtocol` held-live) · cross-org `ContextCommons` ✅ (`LAVentureGraph` held — active session + personal-acct) · partner `WilhelmAI` pending.** Next = `TappProtocol`+`LAVentureGraph`+`WilhelmAI` when quiet → Wave 3c. Held-4 (`aDNALabs`/`ScienceStanley`/`Harness`/`zeta`) unchanged.

> **🟢 3b TAPP+LAVG AS-FIRED 2026-06-24 (`session_stanley_20260624_git_p6_wave3b_tapp_lavg`; DP5 gate, scope = TappProtocol + LAVentureGraph; operator: "TappProtocol + LAVG" + defer Wave 3c).** **2 FIRED ✅** (both GitHub-private throughout; per graph: F-W3-d dual-check clean+sessionless → fresh full-history `gitleaks` clean → `git/` wrapper pin `9c6a353` + `## Git-Ops` doctrine + pre-push hook + STATE/MANIFEST host-fact → `gitops_push <branch>` → pre-push `gitleaks clean ✓` → host-action → repoint → **anon-clone REFUSED** + `gh api .private=true` + old→new redirect ✓): **`TappProtocol`** (in-org **drift rename** `TappInterface.aDNA`→`TappProtocol.aDNA`; `master`; `8ab5e7c`; cleared the prior live-Mentor hold — now quiet, genesis complete/P9 closed; nested `what/tappinterface/` same-repo = Wave 4) · **`LAVentureGraph`** (the campaign's **first transfer from a personal account** `ScienceStanley/LAStartupLattice` → `aDNA-Network/LAVentureGraph.aDNA` + rename; `main`; `eaa61f0`; transfer poll settled in 5 checks, rename attempt-1 clean; untracked `.community_intel.yaml.bak` preserved [stage-only-mine]; lone April-stale active-session = abandoned cruft, not live). **No `rollback` remote / no windowed §C shim** (native-rename/transfer redirect sub-class; Hestia registers → [[coord_2026_06_24_git_wave3b_hestia_redirect_shims]], now 7 entries). **Berthier coord delivery STILL HELD** (aDNALabs busy; proceeded under operator ack). **No new lib verb** (dry-run 31/31). **→ 3b drift 5/5 (`Operations`·`VAAS`·`LatticeProtocol`·`Lab`·`TappProtocol` ✅) · cross-org 2/2 (`ContextCommons`·`LAVentureGraph` ✅) · only partner `WilhelmAI` remains (held-live).** Next = `WilhelmAI` partner-touch when quiet → Wave 3c. Held-4 (`aDNALabs`/`ScienceStanley`/`Harness`/`zeta`) unchanged.

> **🟢 3c PARTIAL AS-FIRED 2026-06-24 (`session_stanley_20260624_git_p6_wave3c_rc_comfyui`; DP5 gate, scope = RemoteControl + ComfyUI; operator: "RemoteControl→GH-priv · ComfyUI→L" + hold Harness).** **2 done ✅** (F-W3-d dual-check clean+sessionless before each apply AND before commit; wrapper pin `7c7a08a`): **`RemoteControl`** — the campaign's **first greenfield GitHub-PRIVATE first-remote** (Wave-1a greenfield went Codeberg; class I; `master`; `bb2ee63`): gitleaks full-history hard gate clean (2 commits) → artifacts (git/ wrapper + `## Git-Ops` doctrine + pre-push hook + STATE/MANIFEST host-fact) → commit → `gitops_create_repo`/`set_remote`/`push master` → **pre-push `gitleaks clean ✓`** (live dogfood) → `private:true`, **anon HTTP 404 = REFUSED**, `default_branch` auto-resolved `master`, authed HEAD match; **no §C shim** (greenfield). **`ComfyUI`** — **class L (local-only)** (`master`; `e42e2f9`): operator decision (STATE "NOT for release"); hygiene scan clean (9 commits, informational/non-gating) → git/ wrapper (L-variant, no remote) + `## Git-Ops` doctrine + **defensive** pre-push hook + STATE/MANIFEST git-posture → commit; **nothing outward** (`git remote -v` empty ✓); GitHub-private only if ever remoted — never Codeberg. Home origins-record coord staged ([[coord_2026_06_24_git_wave3c_hestia_origins_record]]; Home live `home_v2_bento` → Hestia registers when free; no §C shim). **No new lib verb** (dry-run 31/31). **3c status: first-remote 1/3 (`RemoteControl` ✅) · class-L 1/3 (`ComfyUI` ✅) · `Warp` held-live.** Next = `Warp` (3c) when quiet + Wave-3a held-4 + `WilhelmAI` (3b partner).

> **🟢 3c COMPLETE + 3a HELD-REFIRE AS-FIRED 2026-06-25 (`session_stanley_20260625_git_p6_wave3_harness_ss_warp`; DP5 gate, scope = Harness + ScienceStanley + Warp; operator: "Harness + Warp + ScienceStanley · Warp = first-remote→GitHub-private").** **3 FIRED ✅** (all GitHub-private; per graph: F-W3-d dual-check clean+sessionless before apply AND before commit → fresh full-history `gitleaks` hard gate clean → `git/` wrapper pin **`0ad41bf`** + `## Git-Ops` doctrine + pre-push hook + MANIFEST/STATE host-fact → commit (stage-only-mine) → `gitops_push` → pre-push `gitleaks clean ✓` → verify): **`Harness`** (3a touch, existing origin, `master`, `43749d0`; **the prior P7-go-live hold RESOLVED** — genesis-exec ✅ 06-22 + CG-4 ✅ 06-24, tree clean; 128-commit scan clean; nested `what/harness` = Wave 4) · **`ScienceStanley`** (3a touch, existing origin, **`dev`**, `caddf7d`; **F-W3-a** own root `.gitleaks.toml` [no `git/.gitleaks.toml`], 364-commit scan clean; **F-W3-c dogfooded LIVE** — hook **placed** at `how/governance/hooks/pre-push` [`core.hooksPath` set] FIRED on the `dev` push, not bypassed; deferred `incident_20260528` surfaced [private→private]) · **`Warp`** (3c **first-remote → GitHub-PRIVATE greenfield**, `master`, `fee4dff`; held-live `ep4` cleared; `gitops_create_repo`/`set_remote`/`push` → `private:true`, anon HTTP-404 REFUSED, default_branch auto-`master`; class I — never Codeberg; no §C shim). **Anomaly verified (not contamination):** Git.aDNA HEAD `76fc07f`→`0ad41bf` = the legitimate fleet **Illumination Wave-2 `.obsidian/` reseed** (operator-authored 06-24, pushed; the `obsidian:` prefix triggered a verify → used as the wrapper pin). **No §C shim** (3a origins unchanged; Warp greenfield). Home origins-record coord appended for Warp ([[coord_2026_06_24_git_wave3c_hestia_origins_record]]). **No new lib verb** (dry-run 31/31). **→ 3c ✅ 3/3 COMPLETE (`RemoteControl`·`ComfyUI`·`Warp`) · 3a 10/12 (held `aDNALabs`·`zeta`) · 3b 7/8 (held partner `WilhelmAI`).** Next = `aDNALabs`+`zeta` (3a) + `WilhelmAI` (3b partner) when quiet.

> **🔧 RECONCILIATION 2026-06-25 (NON-OUTWARD — `session_stanley_20260625_git_p6_wave3_reconcile`).** A held-set ground-truth audit found **`aDNALabs` was already FIRED 2026-06-22** (touch `067cd87`, `main`, private; pin `1aca0eb`; **pushed** — true remote tip contains it; `gh api` `private=true` + `git/CLAUDE.md` present 1910 B) — the 06-22 refire/refire2 in fact applied + committed + pushed it but recorded it HELD (the refire2 logged as a "never-fired stub"); the success was never journaled. The 7 "unpushed" commits on top are Berthier's own later governance work, not campaign work. **Fleet cross-check (read-only): all 19 other recorded-fired Wave-3 graphs match ground truth — `aDNALabs` is the ONLY desync** (`Operations`' doctrine sits in `AGENTS.md`, expected). The `aDNALabs` row is flipped **✅ FIRED 3a** above. **⇒ Reconciled: 3a 11/12 (held `zeta` only) · 3b 7/8 (held partner `WilhelmAI`) · 3c ✅ 3/3 — Wave 3 reachable-complete bar the 2 externally-blocked graphs.** **Operator decision captured: `WilhelmAI` = touch-only / keep name** (no `.aDNA` rename of the partner-owned repo — recorded at its row). `zeta` stays HELD (67 dirty incl. `CLAUDE.md`+`STATE.md`); `WilhelmAI` stays HELD (partner-org + active today). **Finding F-W3-e (journaling desync):** verify each *held* graph's actual git state on every "continue," not just the recorded status (generalizes F-W3-d to the held-set). **No outward · no cross-vault writes · no re-fire of aDNALabs.** Next = `zeta` (3a touch once its WIP clears) + `WilhelmAI` (3b touch-only when quiet + Berthier partner coord) → Wave 4 (nested) / Wave 5 (client) / P7.

| Graph | Current | Drift? | Action | Notes |
|---|---|---|---|---|
| `aDNALabs.aDNA` | **✅ GH-priv `aDNALabs.aDNA`** | — | **✅ FIRED 3a** | **2026-06-22 (`067cd87`, `main`, private; in-place touch, origin unchanged) — RECORD-RECONCILED 2026-06-25 (F-W3-e):** was recorded HELD, but the 06-22 refire2 actually applied + committed + pushed the touch (pin `1aca0eb`; true remote tip contains it; `gh api` `private=true`, `git/CLAUDE.md` present 1910 B) — the success was never journaled. org HQ; staged `aDNALabs.gitleaks.toml` (13 FP) |
| `Harness.aDNA` | **✅ GH-priv `Harness.aDNA`** | — | **✅ FIRED 3a** (+nested W4) | 2026-06-25 (`43749d0`, `master`, private; held-refire — the P7-go-live hold RESOLVED [genesis-exec ✅ + CG-4 ✅]; touch, origin unchanged; 128-commit scan clean; nested `what/harness` = Wave 4) |
| `Context.aDNA` | GH-priv `Context.aDNA` | — | touch (+nested W4) | |
| `LatticeProtocol.aDNA` | **✅ vault `aDNA-Network/LatticeProtocol.aDNA`** | drift→resolved | **✅ FIRED 3b** (+nested W4) | **I/R** — R if lib published. 2026-06-24 (vault `adf62cb`, `main`, private; `latticeprotocol-adna`→ redirect ✓; nested `lattice-protocol` = Wave 4) |
| `Lab.aDNA` | **✅ `aDNA-Network/Lab.aDNA`** | drift→resolved | **✅ FIRED 3b** (+nested W4) | 2026-06-24 (`1928fd1`, `main`, private; `lab-adna`→ redirect ✓; nested `what/lab`+`lab-workspace` = Wave 4; untracked Keystone coord preserved) |
| `Network.aDNA` | GH-priv `Network.aDNA` | — | touch | mesh registry (sensitive) |
| `Terminal.aDNA` | GH-priv `Terminal.aDNA` | — | touch | |
| `Obsidian.aDNA` | GH-priv `Obsidian.aDNA` | — | touch | |
| `Operations.aDNA` | **✅ `aDNA-Network/Operations.aDNA`** | drift→resolved | **✅ FIRED 3b** | **canary 2026-06-24** (`99f2750`, `master`, private; `TaskForge.aDNA`→ redirect ✓; doctrine in AGENTS.md) |
| `TappProtocol.aDNA` | **✅ `aDNA-Network/TappProtocol.aDNA`** | drift→resolved | **✅ FIRED 3b** | 2026-06-24 (`8ab5e7c`, `master`, private; `TappInterface.aDNA`→ redirect ✓; prior live-Mentor hold cleared — genesis complete; nested `what/tappinterface/` same-repo = Wave 4) |
| `VAAS.aDNA` | **✅ `aDNA-Network/VAAS.aDNA`** | drift→resolved | **✅ FIRED 3b** | 2026-06-24 (`b9593c0`, `main`, private; `VAASLattice.aDNA`→ redirect ✓) |
| `WorldGenome.aDNA` | GH-priv `WorldGenome.aDNA` | — | touch | |
| `ScienceStanley.aDNA` | **✅ GH-priv `ScienceStanley.aDNA`** | — | **✅ FIRED 3a** | 2026-06-25 (`caddf7d`, `dev`, private; **F-W3-a** own root `.gitleaks.toml` [no `git/.gitleaks.toml`], 364-commit scan clean; **F-W3-c** hook placed at `how/governance/hooks/pre-push` — **fired live** on the `dev` push; deferred `incident_20260528` surfaced [private→private, not exposed]; brand vault; CI) |
| `ZenZachary.aDNA` | GH-priv `ZenZachary.aDNA` | — | touch | brand vault |
| `zeta.aDNA` | GH-priv `zeta.aDNA` | — | touch | |
| `wga.aDNA` | GH-priv `wga.aDNA` | — | touch | CI |
| `ContextCommons.aDNA` | **✅ `aDNA-Network/ContextCommons.aDNA`** | cross-org→resolved | **✅ FIRED 3b** | 2026-06-24 (`568b94d`, `main`, private; **class I — operator call** at the gate; cross-org transfer `LatticeProtocol`→`aDNA-Network`, redirect ✓; deployed site public but source stays private; no visibility flip) |
| `ComfyUI.aDNA` | **local-only (class L)** | **L** ✅ | **✅ DECLARED 3c (class L)** | 2026-06-24 (`e42e2f9`, `master`; operator call: **class L — local-only, no remote** ("NOT for release", Anduril-dep); git/ wrapper (L-variant) + `## Git-Ops` doctrine + **defensive** gitleaks hook; **no remote / no push**; GitHub-private only if ever remoted — **never Codeberg**) |
| `Astro.aDNA` | **GH-priv ✅** `aDNA-Network/Astro.aDNA` | resolved (was cross-org) | **✅ DONE 2026-06-22** (touched early, re-mapped from W2) | operator **BSL-1.1 keep-private** ⇒ class I; GitHub-native cross-org transfer+rename done **private** (HEAD `0d0c315`); wrapper+doctrine+hook+host-fact applied; §C shim (rollback=re-transfer). Revisit public exposure at a future license/release decision |
| `AWSBootstrap.aDNA` | GH-priv `AWSBootstrap.aDNA` | — | touch | private + mesh-bridge |
| `LAVentureGraph.aDNA` | **✅ `aDNA-Network/LAVentureGraph.aDNA`** | personal+drift→resolved | **✅ FIRED 3b** | 2026-06-24 (`eaa61f0`, `main`, private; **first personal→org transfer** `ScienceStanley/LAStartupLattice`→ + rename, redirect ✓; rollback = re-transfer) |
| `RemoteControl.aDNA` | **✅ `aDNA-Network/RemoteControl.aDNA`** | greenfield→resolved | **✅ FIRED 3c** | 2026-06-24 (`bb2ee63`, `master`, **private**; **first remote** — greenfield, no host move; pre-push hook dogfooded clean; anon HTTP 404 REFUSED; default_branch auto-`master`; **no §C shim**) |
| `Warp.aDNA` | **✅ `aDNA-Network/Warp.aDNA`** | greenfield→resolved | **✅ FIRED 3c** | 2026-06-25 (`fee4dff`, `master`, **private**; **first remote** — greenfield, no host move; operator: first-remote→GH-private; 43-commit scan clean; anon HTTP 404 REFUSED; default_branch auto-`master`; class I — **never Codeberg**; **no §C shim**) |
| `WilhelmAI.aDNA` | **Wilhelm-Foundation** org | partner-org | **touch-only, keep name** (coord partner) | partner-anchored; stays in partner org. **Operator decision 2026-06-25: touch-only / keep name** — when quiet, push wrapper + `## Git-Ops` doctrine + hook + host-fact to the existing `Wilhelm-Foundation/WilhelmAI` origin; **NO `.aDNA` rename** of the partner-owned repo (cosmetic; respects partner ownership, ADR-001). **HELD** (active today + dedicated partner-coord gate; deliver [[berthier_wave3_coord]] first). |

> **`Spacemacs.aDNA` re-mapped OUT of Wave 3 → Wave 1b** (P-dev → Codeberg-private + cross-org migrate). If the operator deems it internal at the gate, it reverts here (GitHub-private, cross-org migrate only — never Codeberg).

### Wave 5 — Client / I-strict → stay GitHub-private; history-scan + operator sign-off; never Codeberg
> **🟢 STAGED + pre-cleared 2026-06-29 (`session_stanley_20260629_git_p6_wave5_staging`, NON-OUTWARD): [[wave5_runbook]] authored; full-history scans done (6 scanned · 4 clean · 2 FP allowlisted → re-scan 0); [[berthier_wave5_coord]] staged.** Live re-probe (F-W3-e/F-W4-a) corrected the pre-recon rows: `SuperLeague`/`CakeHealth`/`RareArchive` are **already-remote** (in-place touch), `CakeProtocol`/`MagnaPetra` are **local-only** (greenfield first-remote), `PercySleep` is **already-remote but HELD** (dirty + 2 active sessions). All class I-strict; each fires at a **per-graph DP5 gate + operator scan sign-off** (ADR-011 D4, elevated to before-any-touch = F-W5-a); 5d also needs Wilhelm-Foundation partner ack. **Sub-waved:** 5a greenfield (2) · 5b in-place touch (2) · 5c held (1) · 5d partner-org (1).

| Graph | Sub | Current (live) | Branch · commits | ADR-013 class | Scan (pre-clear) | Status |
|---|---|---|---|---|---|---|
| `CakeProtocol.aDNA` | 5a | local-only | `master` · 28 | **I-strict** | ✅ clean (baseline) | STAGED — first-remote GH-priv (**canary**) |
| `MagnaPetra.aDNA` | 5a | local-only | `master` · 5 | **I-strict** | ✅ clean (incl. in-tree `lunarpro-build-kit`) | STAGED — first-remote GH-priv |
| `SuperLeague.aDNA` | 5b | GH-priv `aDNA-Network/SuperLeague.aDNA` | `master` · 416 | **I-strict** | ⚠️→✅ 1 FP (coord-filename) → `superleague.gitleaks.toml` ✅0 | STAGED — in-place touch |
| `CakeHealth.aDNA` | 5b | GH-priv `aDNA-Network/CakeHealth.aDNA` (**ssh**) | `main` · 16 | **I-strict** | ✅ clean — **clinical** | STAGED — in-place touch (F-W4-d ssh) |
| `PercySleep.aDNA` | 5c | GH-priv `aDNA-Network/PercySleep.aDNA` | `master` · 81 | **I-strict** | ⚠️→✅ 1 FP (ssh-ed25519 pubkey) → `percysleep.gitleaks.toml` ✅0 | **HELD** (dirty + 2 active sessions) |
| `RareArchive.aDNA` | 5d | **`Wilhelm-Foundation/rare-archive-vault`** | `main` · 97 | **I-strict** (partner) | ✅ clean (baseline) | STAGED — touch-only/**keep host+name**; partner ack req'd |

> External nested repos under these vaults (`percysleep/Percy_Firmware`, `percysleep/percy-adapter`, `Wilhelm-Foundation/rare-archive`) are **out-of-scope / never re-homed** (ADR-005 D7 / ADR-001) — see §External below; each a separate `.git`, not in the parent's scanned history.

### Class L — local-only (declaration only; no remote)
| Graph | ADR-013 class | Notes |
|---|---|---|
| `Home.aDNA` | **L** | Rule-4 local-by-default; remote operator-discretionary |
| `DataRoom.aDNA` | **L** | never-push (legal IP ~120G) |
| `Archive.aDNA` | **L** | archive holder |
| `Datasets.aDNA` | **I/L** (confirm) | new (PT pt15); confirm remote intent |

---

## Nested code-as-WHAT repos (Wave 4 — own remotes, independent of parent)

> **🟢 RECONCILED to ground truth 2026-06-27 (non-outward — `session_stanley_20260627_git_p6_wave4_staging`).** Wave 4 is **NOT greenfield.** The host-migration is already largely done by **two parallel workstreams**: **`harness` ✅ fully federated 06-26** (Harness team → `aDNA-Network/adna-harness` private + portable CI + `git/` wrapper committed **into the repo** = the **EXEMPLAR**); **`lattice-protocol`·`latlab`·`moleculeforge` host-moved `LatticeProtocol`→`aDNA-Network` by Berthier's WS-1 pilot** (early June; old origin kept as a **`legacy`** remote). ⇒ Wave 4's residue = the **Git.aDNA federation *touch*** (in-repo `git/` wrapper + `## Git-Ops` doctrine + gitleaks hook + CI-parity), **not** a host move. **Finding F-W4-a (record desync, F-W3-e class):** this ledger reflected none of the above → corrected below. [[wave4_runbook]] generalizes the harness exemplar; [[berthier_wave4_coord]] fixes the ownership boundary (WS-1 owns host execution; Git.aDNA supplies the pattern). **Pre-clear scans 2026-06-27 (full history):** 3 clean · `latlab` (15) + `moleculeforge` (71) **all false-positive** → allowlists staged + validated. **Fire = a Berthier-coordinated per-repo DP5 gate** (Standing Order #1/#10). **🔵 4a CANARY ✅ FIRED 2026-06-27** — `lattice-protocol` federation touch (`47935b6`; in-repo `git/` wrapper + `## Git-Ops` + gitleaks hook; pushed to the existing origin; `private:true`, anon-clone refused, pre-push hook `gitleaks clean ✓`; CI already-federated → no CI added; stale `LatticeProtocol`-org fact corrected). **5 repos remain** (held/decision). [**Update — 4a CONTINUE (FULL) 2026-06-29 (`session_stanley_20260629_git_p6_wave4_fire_full`):** `contextscope` (`3b34c92`) + `latlab-lab` (`cb0896a`, F-W4-d ssh resolved) federation-touched + `dataroom` (`9ae18b7`) class-L declared (refuse-all hook, no remote, NON-OUTWARD); `moleculeforge` **HELD** — live collision **F-W4-g** (`scoring_ensemble.py` dirty mid-session; F-W4-e resolved = GitHub-I); `latlab` still 5-dirty. [[berthier_wave4_coord]] **DELIVERED** (aDLabs `56ed23e`). ⇒ **4a 3/4 · 4b held · 4c ✅.**] [**Update — 4a `latlab` ✅ FIRED 2026-06-29 (`session_stanley_20260629_git_p6_wave4_latlab`):** the last held 4a graph federation-touched in-place (`36a774c`; existing `aDNA-Network/latlab` GitHub-private origin; `## Git-Ops` appended to the existing CLAUDE.md; stale `LatticeProtocol`→`aDNA-Network` host-fact corrected; CI already-federated [WS-1 vendored `reusable_ci.yml`] → no change; stage-only-mine around 5 stale deploy-config files; full-history `gitleaks` clean 355c; `private:true`, anon-clone refused exit 128, pre-push `gitleaks clean ✓`). ⇒ **✅ WAVE 4a COMPLETE (4/4)** · 4b `moleculeforge` HELD (F-W4-g) · 4c `dataroom` ✅.] **F-W4-f** filed (Git.aDNA CI-template lags lattice-protocol's live vendored `reusable_ci.yml`; the `what/ci_templates/` path it cites is absent → `what/templates/ci/`).

| Path | Live origin | `legacy`? | Class | Federation | Scan | Wave-4 status |
|---|---|---|---|---|---|---|
| `Harness.aDNA/what/harness` | `aDNA-Network/adna-harness` (private) | — | **I** | ✅ in-repo | ✅ clean (41c, 06-26) | **✅ DONE — the EXEMPLAR** (Harness team) |
| `Context.aDNA/what/contextscope` | `aDNA-Network/contextscope` | — | **I** | ✅ in-repo `3b34c92` | ✅ clean (65c) | **✅ FIRED 4a 2026-06-29** (`3b34c92`; minimal CLAUDE.md added; baseline scan; push synced 3 pre-existing commits + `v0.2.8` tag) |
| `LatticeProtocol.aDNA/what/latticeprotocol` | `aDNA-Network/lattice-protocol` | ✅ `LatticeProtocol/` | **I/R** | ✅ in-repo `47935b6` | ✅ clean (121c) | **✅ FIRED 4a canary 2026-06-27** (CI already-federated; stale `LatticeProtocol`-org fact corrected; R if core lib publishes) |
| `Lab.aDNA/what/lab` (`latlab`) | `aDNA-Network/latlab` | ✅ `LatticeProtocol/` | **I** (BSL 1.1) | ✅ in-repo `36a774c` | ✅ clean (355c, allowlist 15 FP) | **✅ FIRED 4a 2026-06-29** (`36a774c`; `## Git-Ops` appended to existing CLAUDE.md; stale `LatticeProtocol`→`aDNA-Network` host-fact corrected; CI already-federated [WS-1 vendored `reusable_ci.yml`] → no CI change; stage-only-mine around 5 stale deploy files; pre-push `gitleaks clean ✓`, `private:true`, anon-clone refused) |
| `Lab.aDNA/what/lab-workspace` (`latlab-lab`) | `aDNA-Network/latlab-lab` (**ssh**) | — | **I** | ✅ in-repo `cb0896a` | ✅ clean (4c) | **✅ FIRED 4a 2026-06-29** (`cb0896a`; F-W4-d ssh resolved via transient `ghhttps`, origin-ssh untouched; stale `LatticeProtocol`→`aDNA-Network` host-fact corrected) |
| `Molecules.aDNA/what/moleculeforge` | `aDNA-Network/moleculeforge` | ✅ `LatticeProtocol/` | **I vs P-dev** (F-W4-e) | ❌ | ▲→✅ 71 FP (allowlist) | **HELD 2026-06-29** — F-W4-e **RESOLVED (GitHub-I)**; scan PASSED (52c) but live collision **F-W4-g** (`scoring_ensemble.py` dirty mid-session) → no apply; fires turnkey when quiet (4b) |
| `DataRoom.aDNA/what/dataroom` | **NO-ORIGIN** | — | **L** | ✅ in-repo `9ae18b7` | deferred (never-push) | **✅ DECLARED 4c 2026-06-29** (`9ae18b7`; L-variant wrapper + **refuse-all** pre-push hook + `## Git-Ops`; `git remote -v` empty; NON-OUTWARD) |

## External / partner — NEVER moved (ADR-001 out-of-scope)
| Path / graph | Remote | Disposition |
|---|---|---|
| `RareArchive.aDNA/what/rare-archive` | `Wilhelm-Foundation/rare-archive` (PUBLIC) | external-canonical; untouched |
| `PercySleep.aDNA/what/percysleep_code/Percy_Firmware` | `percysleep/Percy_Firmware` | external partner; untouched |
| `PercySleep.aDNA/what/percysleep_code/percy-adapter` | `percysleep/percy-adapter` | external partner; untouched |
| `llama.cpp` (root external dep) | `ggml-org/llama.cpp` (MIT) | external upstream; untouched |

## Operator-decision rows
1. **Released vs in-dev split** (the pivotal call) — **✅ RESOLVED 2026-06-21 (conservative threshold); Astro amended 2026-06-22.** Released → GitHub-public (W2) = **`aDNA` · `III` · `Canvas`** (3/3 done; **`Astro` was here but the operator's 2026-06-22 BSL-1.1 posture call moved it → W3 private** — BSL-1.1 is source-available, not OSI-FOSS). FOSS-in-dev → Codeberg-private (W1) = **`TypeScript`(done) · `VisualDNA` · `Lighthouse` · `Videos` · `Molecules` · `Oration` · `Spacemacs`**. Internal → stay (W3) = **`ComfyUI` · `Astro`** + the I-majority.
2. **Name-drift** — **✅ RESOLVED: rename-on-host now** (origin = dirname), coord Berthier. Wave-1 cases: `Molecules` (`moleculeforge`→`Molecules.aDNA`), `Oration` (`SpeechForge.aDNA`→`Oration.aDNA`). Other drift (`Operations`, `TappProtocol`, `VAAS`, `LatticeProtocol`, `Lab`, …) renamed at their W3 touch.
3. **Cross-org stragglers** — **✅ RESOLVED: migrate now**, coord Berthier. Wave-1 case: `Spacemacs` (`LatticeProtocol`→`aDNA-Network`, to **Codeberg**) ✅. **`Astro` ✅ DONE 2026-06-22** (`LatticeProtocol/SiteForge.aDNA`→`aDNA-Network/Astro.aDNA` on **GitHub**, native transfer+rename, kept **private** — no public flip; operator approval = Berthier cross-persona ack). W3 cases remaining: `ContextCommons` + personal `ScienceStanley/LAStartupLattice`.
4. **Unmapped GitHub repos** (exist on a host, no obvious local graph) — **OPEN** (not Wave-1-blocking): `TheKINN.aDNA`, `WGS.aDNA`, `WorldGenomeProtocol.aDNA` (aDNA-Network; WorldGenome quarries) · `richie_lab.aDNA` (LatticeProtocol). → archive / map / ignore at a later gate.
5. **Residual sub-confirms** (at the relevant gate, not Wave-1-blocking): `Spacemacs` FOSS-intent (P-dev→Codeberg vs I→stay) · `ComfyUI` local-L-vs-GitHub-private · `Datasets.aDNA` remote-intent.

## Reconciliation — zero unaccounted (vs `fleet_git_state.md`)
Buckets are the `fleet_git_state` source grouping; the **this-ledger** column shows the post-reconciliation (ADR-013, conservative-threshold) wave. The re-map moved graphs *between waves* — the 45-graph total is unchanged.

| Bucket | fleet_git_state | this ledger (reconciled 2026-06-21) | Δ |
|---|---|---|---|
| Intended-PUBLIC (9) | aDNA, III, Canvas, Astro, Videos, Molecules, Oration, TypeScript, ComfyUI | aDNA/III/Canvas→**W2** ✅ (3/3 public); TypeScript(done)/Videos/Molecules/Oration→**W1** ✅; **ComfyUI→W3** (internal — re-classified); **Astro→W3 private** (BSL-1.1 keep-private, re-classified 2026-06-22) | 0 |
| Private/internal (23) | aDNALabs…LAVentureGraph | W3 touch + W5 for the 3 client; **`Spacemacs`→W1b (FOSS-in-dev — re-classified)** | 0 |
| Local-only (10) | Home, DataRoom, Datasets, CakeProtocol, MagnaPetra, RemoteControl, VisualDNA, Warp, Git, Archive | L / W5 / W3 / **VisualDNA→W1a** / Git done | 0 |
| Partner-anchored (2) | RareArchive→vault, WilhelmAI | mapped (W5 / W3) | 0 |
| Post-P1 fork (1) | Lighthouse.aDNA | mapped (**W1a** ✅) | 0 |
| Nested code-as-WHAT (7 internal) | per §nested | mapped (W4) | 0 |
| External/never-moved (4) | rare-archive, 2× Percy, llama.cpp | listed (untouched) | 0 |
| Unmapped (4) | TheKINN, WGS, WorldGenomeProtocol, richie_lab | flagged (decision row 4) | 0 |

**Canonical graphs accounted: 45** (9 + 23 + 10 + 2 + 1). **Zero unaccounted.** ✅ (P6 exit-gate criterion #1.) **Three cross-bucket re-classifications** (`ComfyUI` public→internal; `Spacemacs` internal→FOSS-dev; **`Astro` released/W2→internal/W3 private — 2026-06-22 BSL-1.1 posture call**) net to zero — all still accounted, just in a different wave.

---

## Wave 1 — gate-ready execution checklist (DP5-GATED — NOT executed)

> The lowest-risk first wave (**private moves only**). **Outward — fires only on operator authorization (rollout DP5).** All verbs via the agnostic lib (the 5 P5 fixes are folded; dry-run 23/23). **Pre-cleared 2026-06-21:** per-graph secret-scans ✅ clean; per-graph artifacts (declaration · doctrine block · hook · shim · STATE/MANIFEST patch) + the Berthier coord are **staged** at [[how/campaigns/campaign_git_genesis/missions/wave1_staging/wave1_runbook|wave1_staging/]]. The runbook there has the exact commands; this is the contract summary. Per-graph, in order:

**Wave 1a (greenfield, local-only → Codeberg-private) — ✅ FIRED 2026-06-21** — target set: **`VisualDNA.aDNA`, `Lighthouse.aDNA`** *(ComfyUI dropped → W3/I; TypeScript done at P5, declaration staged)*. Both repos created Codeberg-private, `master` pushed, wrapper/doctrine/hook/STATE-MANIFEST applied, pre-push hook dogfooded clean, anon-clone refused. Home origins-record coord delivered (no §C shim — greenfield). 1b remains gated.

For each graph `G`:
1. **Pre-flight** — confirm `G` is local-only (`git -C G remote -v` empty) ✅ verified 2026-06-21; class = P-dev ✅ (operator).
2. **Secret-scan gate (ADR-011)** — `gitleaks detect` (full history) → **clean** ✅ pre-cleared 2026-06-21; re-run at the gate as a fresh check; a finding blocks until purged + credential rotated (Home).
3. **Declaration** — apply the staged `G/git/CLAUDE.md` (`git_provider`: host `codeberg.org`, backend `forgejo`, visibility `private`, class `P`) + paste the staged ADR-013 doctrine block into `G/CLAUDE.md` *(cross-vault → applied at the gate, Rule 10)*.
4. **Create + wire + push** — `GITOPS_ALLOW_LIVE=1`, then `gitops_create_repo codeberg.org aDNA-Network G private` → `gitops_set_remote codeberg.org aDNA-Network G origin` → `gitops_push <branch>` (Forgejo token, proven live at P5).
5. **Verify** — authed clone OK; **anon clone refused** (private proven, the P-dev invariant).
6. **Shim entry** — register the new origin in Home.aDNA's shim registry (Rule 9) with a rollback path *(staged coord)*.
7. **STATE/MANIFEST** — apply `G`'s staged STATE/MANIFEST host-fact patch *(cross-vault, staged)*.

**Wave 1b (host-move, GitHub-private → Codeberg-private)** — target set: **`Videos`, `Molecules`, `Oration`, `Spacemacs`** *(Canvas, Astro dropped → W2 released; Spacemacs added from W3)*. **Progress: `Videos` (canary) ✅ + `Oration` ✅ + `Spacemacs` ✅ FIRED 2026-06-21; `Molecules` ✅ FIRED 2026-06-22 (collision cleared) → ✅ WAVE 1b COMPLETE (4/4).** Same as 1a but step 4 is a **host-move** (ADR-006 §4 sequence): full-history secret-scan → `git remote rename origin rollback` → `gitops_set_remote codeberg.org aDNA-Network G origin` → `gitops_push --all --tags` → shim entry → retire `rollback` at window close. **Coordinate Berthier first** for the name-drift cases (`Molecules`: `moleculeforge`→`Molecules.aDNA`; `Oration`: `SpeechForge.aDNA`→`Oration.aDNA`) + the cross-org case (`Spacemacs`: `LatticeProtocol`→`aDNA-Network` *on Codeberg*).

**Wave-exit:** each graph carries the declaration + doctrine block + updated STATE/MANIFEST + shim entry; ledger row flips to ✅. **Nothing in Wave 1 runs without the DP5 gate** (Standing Order #1/#2). **Wave 2 (public flips: `aDNA`·`III`·`Canvas`·`Astro`) is a separate, later, per-graph gate** with a mandatory full-history secret-scan.

## AAR
*(see mission `p6_fleet_alignment.md`)*

## Wave 6 — Keystone cohort first-remotes ✅ FIRED 2026-08-07 (6/6)

Operator DP5 gate = the 2026-08-07 plan approval (same sitting chartered **P7a/P7b** — the R&D-node spike). Per the staged [[../../how/campaigns/campaign_git_genesis/missions/wave6_staging/wave6_keystone_runbook|wave6 runbook]] §8 fire record: **`Groupware` (canary) · `Nextcloud` · `Caddy` · `Nebula` · `Container` · `Forgejo`** → `codeberg.org/aDNA-Network/<Name>.aDNA` **private, class P-dev** (operator host ruling 2026-07-27). Fresh full-history scans clean 6/6 (controls 2/2); wrappers at `how/federation/git/` (ADR-045 placement) + `## Git-Ops` blocks + pre-push hooks applied; `luke-mesh` untouched (T-8); all verified private / anon-refused (credential-helper-disabled probe — **F-W6-a**) / HEAD-matched. **The "no origin at all" class is now EMPTY** — every tracked graph in the fleet has a declared disposition AND a live canonical home (or a declared L). Hestia records: [[../../who/coordination/coord_2026_08_07_git_wave6_hestia_records|coord_2026_08_07_git_wave6_hestia_records]].

## Standing Waves — R3 pivot 2026-08-19 (P6 reachable-complete; these rows fire opportunistically)

> **⛩ Operator-ruled at the R3 pivot** (`session_stanley_20260819_git_reactivation_r3_pivot`): with the no-origin class empty (Wave 6) and every graph carrying a declared disposition + live canonical home or declared-L, **P6 is reachable-complete** and no longer the campaign's Resume-Here. The rows below are **standing** — each still fires at its own per-wave DP5 gate (charter DP5 "stays live"), on the same runbooks and pre-cleared scans, whenever its block clears. They gate nothing.

| Row | Wave | Block | Fires when | Runbook / staging |
|---|---|---|---|---|
| `zeta` | 3a touch | operator WIP (was 141 dirty incl. CLAUDE/STATE) | tree clean + sessionless (F-W3-d dual-check) | [[../../how/campaigns/campaign_git_genesis/missions/wave3_staging/wave3_runbook\|wave3_runbook]] |
| `WilhelmAI` | 3b partner-org, **touch-only / keep name** | partner-org + active sessions | quiet window (F-W3-d) | wave3_runbook |
| `moleculeforge` | 4b federation touch | F-W4-g live collision (parent `Molecules.aDNA` hot) | code tree + parent quiet | [[../../how/campaigns/campaign_git_genesis/missions/wave4_staging/wave4_runbook\|wave4_runbook]] |
| `CakeProtocol` (canary) → `MagnaPetra` | 5a greenfield → GH-private | operator scan sign-off (ADR-011 D4/F-W5-a) | operator elects Wave 5 | [[../../how/campaigns/campaign_git_genesis/missions/wave5_staging/wave5_runbook\|wave5_runbook]] (scans pre-cleared 2026-06-29) |
| `SuperLeague` · `CakeHealth` | 5b in-place touch | operator sign-off (I-strict) | operator elects Wave 5 | wave5_runbook (+ staged allowlist / clinical ssh note) |
| `PercySleep` | 5c | dirty + active sessions | clean + sessionless + sign-off | wave5_runbook (+ staged allowlist) |
| `RareArchive` | 5d partner-org touch-only | Wilhelm-Foundation ack | partner ack lands | wave5_runbook + [[../../how/campaigns/campaign_git_genesis/missions/wave5_staging/berthier_wave5_coord\|berthier_wave5_coord]] |

### Graduation record (ADR-014 A2 class — mesh-forge canonical moves)

| Graph | Event | Date | State |
|---|---|---|---|
| `LAVentureGraph` | **First ADR-013 class-I graduation** — GitHub-private → R&D forge (`rd-forge:aDNA-Network/LAVentureGraph.aDNA.git`, SSH alias form), old origin kept as `rollback` (unpushed; disposition = later operator call) | 2026-08-09 | ✅ executed by Cartographer (A1 gate ran: 19 findings all triaged-FP); **runner enrollment awaits the ADR-014 A2 `state: graduated` field** (currently a comment-hold — converts when A2 ratifies) |

### Replica-hold lift record (mis-laned `aDNA-Network/Git.aDNA` rd-forge replica)

| Event | Date | Detail |
|---|---|---|
| HOLD placed | 2026-08-19 | [[../../who/coordination/coord_2026_08_19_hopper_to_ilmarinen_allowlists_staging_p7a_weeks_replica_hold\|our §3]] — "until Exchange ADR-041 operator-ratifies + F-F7 settles" |
| Both conditions verified fired | 2026-08-15 (verified 2026-08-19) | Exchange ADR-041 **`accepted`, operator-ratified 2026-08-15 as-proposed** (§7.7 record verbatim, verified at source in `Exchange.aDNA/what/decisions/adr_041_manifest_visibility_and_host_class.md`); its §2 table = F-F7 settled: `Git.aDNA` manifest **public** → **`aDNA-Commons`** lane. The cc that should have told us failed to a dormant lane (Ilmarinen's F-F21). |
| **HOLD LIFTED** | **2026-08-19** | Hopper's act, this session ([[../../who/coordination/coord_2026_08_19_hopper_to_ilmarinen_hold_lifted_p7a_addressing_landed\|lift memo]]). The **move stays Ilmarinen's lane** (M08 step 0/2 dependency comes off; M08 itself still gated on Exchange P2 §7/§8 + deploy window). Both execution caveats stand as law: explicit `private=false` + API list-back; anonymous unauthenticated `ls-remote` as the only honest Commons probe. |

*Fleet host-move wave (which repos flip `origin` to the subnet forge next, order, criteria — Cartographer's open item): sequences on **ADR-014 A2 ratification** (✅ ratified 2026-08-19, the D4 seam is open) + P7a's TLS/addressing work; sequencing doctrine authored as **[[../decisions/adr_015_lighthouse_integration_architecture|ADR-015]] D5** (P7a block, this session).*

### Secret-gate install roster (ADR-011 A3 §6 — one row per enrolled vault)

> ### ⚠ SUPERSEDED AS A COVERAGE INSTRUMENT — 2026-08-20 ⚠
>
> **This roster is no longer the fleet's coverage number.** It remains authoritative for what it was
> built to hold: the **per-vault caveat-retirement record** (induced-positive dates, A2 §4). It is
> **not** a denominator, and the `8/10` below is honest about the wrong population.
>
> **Measured replacement**: [[secret_gate_census]] (`measured_at` 2026-08-21T02:26Z, instrument
> `how/tests/census_secret_gate.sh`, re-runnable). **Coverage = 70/117 (60%)** across every
> push-capable repo — 14 gates that appear installed and do not gate (10 wrapper files), 31 with no
> gate at all, 2 running a different control. Ruling: [[../decisions/adr_011_secret_scanning|ADR-011
> A4]] (`proposed`).
>
> **F-P7a-e is CLOSED by measurement**, and its answer was worse than the finding assumed: the gap was
> not one off-roster vault, it was 47 — and three of the census's own columns had to be corrected
> before the number could be trusted (`core.hooksPath` shadowing · worktrees excluded by the
> enumeration predicate · a stronger control mis-read as a failure). See census §5.
>
> **The text below is preserved as the as-was record — append-only, not rewritten** (the `action_run`
> discipline: a historical measurement is falsified, not improved, by editing it).

> **Instrument (A3 §1):** resolve `.git/hooks/pre-push` to its **realpath**, then **adjudicate** —
> `a1288f73…` PASS (skeleton v2) · `f255e2a0…` **PASS-equivalent** (Venus's script; range-scanning +
> fail-closed; *not* a finding) · `216aaca2…` FAIL (v1 no-op) · **no file → FAIL, worse**.
> Never equality-test one digest, and never md5 the `git/` wrapper copy — on 4 of 10 vaults nothing
> reads it (A3 §2). **The `scan-ok` caveat retires per-vault on the induced positive, not on the md5**
> (A2 §4): md5 is evidence of a file, not of a control.
>
> Roster source of truth = `Operations.aDNA/what/orchestration/mesh_rd_push/enrolled_vaults.conf`
> (10 paths). **Every row below was adjudicated at source by Hopper on 2026-08-19**, walking the conf
> rather than transcribing Berthier's S214 table — which is how the `aDNALabs.aDNA` row was caught
> having changed under it (F-W3-e discipline: verify at use, never trust a recorded status).
> **Coverage: 8/10 have a behaviourally-correct gate; 2 have none** (A3 §4).
>
> ### ⛔ F-P7a-e — the denominator is the enrollment list, not the population the gate claims to cover
>
> **"8/10" is honest about the wrong denominator.** The roster's 10 rows are the *mesh-rd push
> enrollment*. The population the ADR-011 gate actually claims is **every vault carrying `## Git-Ops`
> doctrine — 40+ of them.** The enrollment list is a scheduling artifact that happens to be
> enumerable; it was never a coverage denominator, and reading it as one is the same instrument error
> A3 §3 names (*an instrument that cannot represent the worst state it looks for reports that state
> as health*), one level up: an instrument pointed at a **subset** reports the subset's health as the
> fleet's.
>
> **First off-roster vault checked, and it fails — the standard-bearer.** Adjudicated at source
> 2026-08-19: `aDNA.aDNA/.git/hooks/pre-push` is a **symlink** into its own wrapper, resolving to
> `how/federation/git/hooks/pre-push.gitleaks.sh` @ **`216aaca254b97d69819562d506afca29`** — the
> retired v1 no-op (`gitleaks git --pre-commit`: scans the *staged* diff, empty at push). It **appears
> installed and does not gate**, and because it resolves *through* the wrapper it will stay a no-op
> until the wrapper is repointed. Per A3 §1's own table that is **FAIL**, not PASS. `aDNA.aDNA` is
> not on the roster, so this contradicts nothing above — which is precisely the finding.
>
> *(Contrast `Canvas.aDNA`, whose wrapper carries the same stale `216aaca2…` file but whose
> `.git/hooks/pre-push` is a **regular-file copy** of the hardened v2 — saved by the install method,
> not by the wrapper. The symlink-vs-copy distinction is load-bearing and was invisible to a
> wrapper-level check.)*
>
> **Not remediated here.** Operator ruling 2026-08-19: **record only** this session. The fleet-wide
> realpath census (~40 doctrine-carrying vaults) and any repoint/install are a **separate gated act**
> — the same Rule 10 scoping the two `FAIL, worse` rows already carry. Recording the roster's
> denominator honestly is the part that was owed today.

| Enrolled vault | Realpath verdict | Induced positive | `scan-ok` caveat |
|---|---|---|---|
| `Git.aDNA` (this vault) | **PASS-equivalent** (`f255e2a0…`) | ✅ 2026-08-19 — drill 3/3 (planted-secret-in-pushed-commit BLOCKED · clean PASSED · scanner-absent BLOCKED) | ⛔ not retired — drill validated the *skeleton*, per-vault install record owed |
| `aDNALabs.aDNA` | **PASS** (`a1288f73…`, v2) — ⚠ **corrected against ground truth 2026-08-19 18:12**: Berthier's S214 table (authored 17:18) recorded this as the fleet's only `216aaca2…` no-op; v2 landed on his desk at 18:12, after authoring. **The fleet's only no-op is now closed.** Also the one vault whose hook resolves *through* its `git/` wrapper (symlink), which is why a wrapper install worked there | — | ⛔ not retired — induced positive owed |
| `Network.aDNA` | **PASS-equivalent** (`f255e2a0…` — the source of v2) | ✅ upstream (Venus's own self-test) | ⛔ not retired — record owed |
| `Forgejo.aDNA` · `Inference.aDNA` · `Jupyter.aDNA` · `LlamaCppForge.aDNA` · `Molecules.aDNA` | **PASS-equivalent** (`f255e2a0…`) — behaviourally v2; a byte sweep would file these as false reds | — | ⛔ not retired |
| ⛔⛔ `WGS.aDNA` | **FAIL, worse** — no `pre-push` hook **and** no `how/federation/git/` wrapper to install one through. *Re-verified at source 2026-08-19: `.git/hooks/` holds only the 14 stock `*.sample` files; `core.hooksPath` unset; no `.gitleaks.toml`; no `## Git-Ops` block.* | — | n/a — **no gate exists**; pushes nightly |
| ⛔⛔ `WilhelmAI.aDNA` | **FAIL, worse** — as above, re-verified at source 2026-08-19 | — | n/a — **no gate exists**; pushes nightly |

**Liveness + exposure facts on the two `FAIL, worse` rows** (captured 2026-08-19 for whoever fires the
remediation; **no vault was written to**):

| | `WGS.aDNA` | `WilhelmAI.aDNA` |
|---|---|---|
| `origin` | `github.com/aDNA-Network/WGS.aDNA` (`main`) | `github.com/**Wilhelm-Foundation**/WilhelmAI` (`master`) — **partner org** |
| Other push paths | `mesh-rd` | `mesh-rd` **+ `mesh` → `wga-mesh:/Users/mccoy/…`** (another operator's machine) |
| Dirty tree | **0** — clean | **184 files**, incl. `CLAUDE.md`·`STATE.md`·`MANIFEST.md`·`CHANGELOG.md` |
| `how/sessions/active/` | 2 (newest 2026-08-17) | **49**, never graduated; oldest 2026-05-14 |
| Collision verdict | **quiet** — F-W3-d clean | ⛔ **live-collision profile** (F-W3-d / F-W4-g) — do not touch until quiet |
| Aggravator | root `CLAUDE.md` §Git Coordination instructs *"Push after committing. Run `git push` after each explicit commit."* — **doctrine actively mandates unguarded pushes** | its own tree records (`e7f02d4`, 2026-08-10) that **it is replicated nightly to the R&D forge** — exposure is **scheduled and unattended**, independent of any manual push |

**Read together, these two rows are asymmetric and should not fire as one wave.** `WGS` is quiet,
clean, and remediable turnkey. `WilhelmAI` is the higher exposure (partner org · a third push path
into another operator's home directory · nightly replication) **and** the one the vault's own
collision doctrine forbids touching today. The right shape is `WGS` first when a gate opens, then
`WilhelmAI` in a quiet window — not a two-vault sweep. Operator ruled **record only** for
2026-08-19; this table exists so the next gate starts from facts rather than a re-probe.

**Open, with owners.** The two `FAIL, worse` rows are the finding that outranks the rollout they were
found during (A3 §4) — remediation is a scoped, gated cross-vault act (Rule 10), not a sweep.
**No vault's caveat retires yet**: eight now hold a behaviourally-correct gate, but A2 §4's bar is the
**induced positive per install**, and only `Git.aDNA`'s skeleton drill has fired. The nightly's
`OK_SCAN_SKIPPED` token is structurally unreachable under v2 (A3 §5) — Operations' pen; **F-S158-01
stays open on that limb** and is not recorded as closing.

*(2026-08-20: operator ruled **record only** again — scope held to P7a. Rows unchanged; no vault
written to. The census and installs stay on the debt register with the same Rule-10 scoping.)*

---

## ADR-015 rev 4 record + P7a gate state (2026-08-20)

**ADR-015 → `revision: 4`**, still `proposed`. Delta = **§D1.5a's probe-measurement paragraph (adding
§D1.5b) and D1.3**, nothing else. D1.1 · D1.2 · D1.4 · D1.5's egress logic · D2 · D3 · D4 · D5 are
untouched from rev 3, so a rev-3 concurrence stands over all of them.

| Gate half | State | Blocked on |
|---|---|---|
| **Venus's concurrence** | **written, affirmative, made against the ADR file at `revision: 3` (`7f4bd48`)** — and **`status: staged` in her tree under a per-send operator GO, never delivered here** | ⛔ **an operator per-send GO in `Network.aDNA`** — *not* on Venus. Recorded **observed-at-source, NOT received**; the gate is **not** half-closed. Rev-4 ask = extend over the two moved clauses. |
| **Operator §7.7** | outstanding | now applies to **rev 4** |

**⭐ F-P7a-f — a measurement that cannot fail is not a control.** Ilmarinen's **F-F25**, adopted and
generalized. The flip probe's only measured column — *"redirect chain: empty"* — was empty by
construction under `follow_redirects=False`, so it passed on exactly the failure it existed to catch.
**Audit question for every probe column in this vault's runbooks: *can this column ever report the
failure it exists to catch?*** If not, it is decoration. Direct sibling of **ADR-011 A3**'s *"an
instrument that cannot represent the worst state it looks for reports that state as health"* — which
this vault authored on 2026-08-19 and violated in a different artifact five days earlier without
noticing. Two consequences already booked: D1.2's `:80` `301` hazard was **documented and undetectable
in the same document**, and this is the **second instance of the class inside ADR-015** (the first
being §D1.5a's pre-restore egress probe), which is why §D1.5b now requires any probe added later to
state its failure condition at the point of definition.

**F-P7a-g — the gate was blocked on a per-send GO in a peer's vault, and neither side could see it.**
We recorded "awaiting Venus"; Venus recorded "concurrence discharged, operator's half is theirs." Both
true, both incomplete, and the missing fact — that her answer was written and held — was visible only
by reading her tree. **Fifth instance in eight days across four vaults** of the staged-memo-already-
readable class: her F-S390-01, Berthier's F-S218-01, our F-P7a-b and F-P7a-d. Per her STATE the
operator has ruled *file the finding, install no rule*, and this vault is not relitigating that from
the outside. Recorded here so the next sitting starts from the fact rather than re-deriving it.

**Disclosure, recorded against ourselves.** We read her staged memo. We did **not** count it as
received, and we did fold its D1.3 correction — after **re-verifying the CA class and the DNS-01
property at source**, so rev 4 depends on facts we checked and not on a document its author has not
released. Disclosed to her in the rev-4 memo before the ask, not after.

---

## License-state roster (ADR-013 A1 §3 — one row per PUBLISHED repo)

> **⭐ This section discharges a promise made inside ratified text.** [[../decisions/adr_013_host_role_inversion|ADR-013]]
> **Amendment A1 §3** (`accepted` 2026-08-24) commits the already-placed unlicensed set to this ledger
> *"with an explicit `license_state`, a **third value and never an absence** — because an absent field
> cannot be distinguished from a dropped one."* At the moment of that stamp this ledger carried **zero**
> `license_state` values, and A1's own Consequences recorded the gap as **owed**: *a promise inside
> ratified text is a debt from the instant it is signed.* This roster is that debt's discharge.
>
> ⛔ **A1's Consequences bullet is NOT edited to say so.** It is a dated record of the state at the
> stamp, and a historical measurement is falsified — not improved — by editing it.

**Source**: [[foss_predicate_measurement]], **second reading `2026-08-24T21:35Z`** (§7), which
reproduces the 03:52Z figures exactly and additionally measures the predicate **at each tracking ref**.
Re-measured at the window rather than inherited, because *a baseline captured before the window is a
claim; one captured at the window is a control* — and this roster is the act.

### The three values — and why absence is not one of them

| `license_state` | Meaning | n |
|---|---|---|
| `licensed:<SPDX>` | `LICENSE` present at `HEAD`, SPDX id read **at the object** (`git show HEAD:LICENSE`) | **2** |
| `unlicensed` | no `LICENSE` at `HEAD` — the A1 §3 remediation set | **21** |
| `pending_declaration` | placed, but the license call has not been made and is not claimed to have been | **0** |

⛩ `pending_declaration` is carried **even at n=0**, modelled on **ADR-014 A4 §1a**: a value that only
exists once someone needs it is a value nobody writes, and then absence silently starts meaning
something. It is declared here so that the first repo to enter that state has a value to enter.

⚠ **This roster is a DENOMINATOR, not a complaint list.** Licensed rows are included. The superseded
[[#secret-gate-install-roster-adr-011-a3-6--one-row-per-enrolled-vault|install roster]] above was
*"honest about the wrong population"*, and §7c of the measurement records two repos a reasonable sweep
drops silently. A roster that lists only failures cannot be checked for completeness.

### Codeberg lane — ADR-013 row 2 (P-dev, private, FOSS-only by ToS)

| # | Repo | Local dir(s) | `license_state` | upstream agrees | note |
|---|---|---|---|---|---|
| 1 | `Caddy.aDNA` | `Caddy.aDNA` | `unlicensed` | ✅ | |
| 2 | `Container.aDNA` | `Container.aDNA` | `unlicensed` | ✅ | ahead 146 |
| 3 | `D3.aDNA` | `D3.aDNA` | `unlicensed` | ✅ | |
| 4 | `Emacs.aDNA` | `Emacs.aDNA` | `unlicensed` | ✅ | |
| 5 | `Exchange.aDNA` | `Exchange.aDNA` | **`licensed:MIT`** | ✅ | ⭐ a human decided |
| 6 | `Forgejo.aDNA` | `Forgejo.aDNA` | `unlicensed` | ✅ | ahead 62 |
| 7 | `Groupware.aDNA` | `Groupware.aDNA` | `unlicensed` | ✅ | |
| 8 | `Lighthouse.aDNA` | `Lighthouse.aDNA` | `unlicensed` | ✅ | |
| 9 | `Molecules.aDNA` | `Molecules.aDNA` + `MoleculeForge.aDNA` | `unlicensed` | ✅ | shim dir |
| 10 | `Nebula.aDNA` | `Nebula.aDNA` | `unlicensed` | ✅ | |
| 11 | `Nextcloud.aDNA` | `Nextcloud.aDNA` | `unlicensed` | ✅ | |
| 12 | `Oration.aDNA` | `Oration.aDNA` | `unlicensed` | ⛔ **`upstream: none`** | ⚠ see below |
| 13 | `Spacemacs.aDNA` | `Spacemacs.aDNA` | `unlicensed` | ✅ | ahead 58 |
| 14 | `Tailwind.aDNA` | `Tailwind.aDNA` | `unlicensed` | ✅ | |
| 15 | `ThreeJS.aDNA` | `ThreeJS.aDNA` | `unlicensed` | ✅ | |
| 16 | `TypeScript.aDNA` | `TypeScript.aDNA` | `unlicensed` | ✅ | ⛔ the P5 beachhead pilot, live since 2026-06-20 |
| 17 | `Videos.aDNA` | `VideoForge.aDNA` + `VideosOld.aDNA` | `unlicensed` | ✅ | ⚠ canonical dir has **no remotes** (Iris's) |
| 18 | `VisualDNA.aDNA` | `VisualDNA.aDNA` | `unlicensed` | ✅ | |
| 19 | `WebForge.aDNA` | `WebForge.aDNA` + `Websites.aDNA` | `unlicensed` | ✅ | ahead 677 |

**18 / 19 `unlicensed`.**

⛔ **Row 12 carries `upstream: none` rather than a tick or a blank.** `Oration.aDNA` has a Codeberg
`origin` but its local `master` has **no tracking branch**, so it cannot be divergence-checked and any
sweep keyed on `@{upstream}` **drops it silently**. ⭐ Same denominator class as row 17's missing
remotes, found by a *different* probe — *two instruments, two blind spots, and neither would have found
the other's case.* Both are the owning graph's to repair under Rule 10; **named here, not performed here.**

### GitHub-public lane — ADR-013 row 1 (P-released, distributing NOW)

| # | Repo | Public since | `license_state` | upstream agrees |
|---|---|---|---|---|
| 20 | `aDNA.aDNA` | 2026-06-22 (Wave 2 canary) | **`licensed:MIT`** | ✅ |
| 21 | **`Git.aDNA`** | **2026-06-20 (P5 beachhead)** | ⛔ **`unlicensed` — this vault** | ✅ |
| 22 | `III.aDNA` | 2026-06-22 | `unlicensed` | ✅ |
| 23 | `Canvas.aDNA` | 2026-06-22 | `unlicensed` | ✅ |

**3 / 4 `unlicensed`.**

⭐ **This lane is the one with a clock.** The Codeberg set is private and undistributed, so its ToS
exposure is latent. These four are **publicly readable right now**, and default copyright makes an
unlicensed public repo *all rights reserved* — no grant to read, fork, or reuse. Row 21 is this vault,
whose stated thesis is portability and open standards, **listed by name rather than found in the set**
(A1 §4's discipline).

### Licensed control — not one of the 23

| Repo | Host | Visibility | `license_state` | Why it is here |
|---|---|---|---|---|
| `Astro.aDNA` | GitHub | **private** (BSL-1.1, operator ruling 2026-06-22) | **`licensed:BSL-1.1`** | Correctly licensed, correctly private, correctly **not** on Codeberg. It is the proof the mechanism works **when invoked** — a control, so the roster cannot be read as "everything is broken." |

### Scope — what this roster does and does not do

- ✅ **Enumerates.** A1 §3 asked for the set on the ledger with an explicit value. Done: **23 rows, 0 absences.**
- ⛔ **Does not remediate.** No `LICENSE` is written into any repo by this roster — including this one.
  **Which** license an aDNA graph carries is **`aDNALabs.aDNA`'s (Berthier)** org/legal call, *asked
  and not taken* (A1 §2). The fork-skill half (`skill_project_fork.md:100` removes the template
  `LICENSE` and nothing downstream ever asks for one) is **Rosetta's**, in `.adna/`, which we do not edit.
- ⛔ **Does not make anything an error.** A1 §3 binds **prospectively** by construction; these 21 are a
  finding with an owner, not a violation booked against a holder who caused nothing.
- ⚠ **Freshness is per-row and bounded.** Rows are `HEAD` + tracking-ref readings with **no fetch
  performed** (non-outward sitting). A `LICENSE` added server-side since the last fetch is invisible to
  both refs; some tracking refs are weeks stale. ⇒ **re-measure at the act**, never from this table.

*Measured `2026-08-24T21:35Z` · instrument: [[foss_predicate_measurement]] §2 + §7b · discharges ADR-013 A1 §3.*

### ⚠ Finding recorded against this roster's own verifier — `grep -c` is not a row count

The plan that authorized this section carried a verification criterion reading
`grep -c license_state what/inventory/disposition_ledger.md` → **expect 0 → 23**. It returns **6**, and
it would have returned 6 for a roster with **any** number of rows: `grep -c` counts *matching lines*,
and the literal token `license_state` appears in **column headers and prose**, never in a row.

⛔ **A criterion keyed on the presence of a NAME rather than on the MECHANISM it claims to measure** —
[[../decisions/adr_011_secret_scanning|ADR-011]] **A6**'s rule exactly, found this time in the
*verification table of the plan that discharges A1 §3*, one sitting after A6 was ratified.

The predicate that actually measures the claim counts **numbered rows carrying one of the three
values**, and — the part that makes it a control rather than a tally — counts rows carrying **none**:

```bash
awk '/^## License-state roster/,0' what/inventory/disposition_ledger.md > /tmp/roster.txt
grep -cE '^\| *[0-9]+ \|' /tmp/roster.txt                                            # 23 rows
grep -E  '^\| *[0-9]+ \|' /tmp/roster.txt \
  | grep -vcE '`(unlicensed|licensed:|pending_declaration)'                          # 0 absences  <- the load-bearing line
```

⭐ *The second command is the one that matters: a roster's defect is a row with no value, and a check
that only counts the values present cannot see a row that has none.* Measured: **23 · 21 · 2 · 0**.
