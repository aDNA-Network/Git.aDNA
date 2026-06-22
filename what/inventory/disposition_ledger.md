---
type: inventory
ledger_id: disposition_ledger
title: "P6 Disposition Ledger — fleet → ADR-013 host table"
created: 2026-06-21
updated: 2026-06-22
status: active
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
| Graph | Current | Drift? | Action | Notes |
|---|---|---|---|---|
| `aDNALabs.aDNA` | GH-priv `aDNALabs.aDNA` | — | touch | org HQ |
| `Harness.aDNA` | GH-priv `Harness.aDNA` | — | touch (+nested W4) | |
| `Context.aDNA` | GH-priv `Context.aDNA` | — | touch (+nested W4) | |
| `LatticeProtocol.aDNA` | GH-priv `latticeprotocol-adna` | **drift** | touch (+nested W4) | **I/R** — R if lib published |
| `Lab.aDNA` | GH-priv `lab-adna` | **drift** | touch (+nested W4) | |
| `Network.aDNA` | GH-priv `Network.aDNA` | — | touch | mesh registry (sensitive) |
| `Terminal.aDNA` | GH-priv `Terminal.aDNA` | — | touch | |
| `Obsidian.aDNA` | GH-priv `Obsidian.aDNA` | — | touch | |
| `Operations.aDNA` | GH-priv `TaskForge.aDNA` | **drift** | touch | |
| `TappProtocol.aDNA` | GH-priv `TappInterface.aDNA` | **drift** | touch | |
| `VAAS.aDNA` | GH-priv `VAASLattice.aDNA` | **drift** | touch | |
| `WorldGenome.aDNA` | GH-priv `WorldGenome.aDNA` | — | touch | |
| `ScienceStanley.aDNA` | GH-priv `ScienceStanley.aDNA` | — | touch | brand vault; br=`dev`; CI |
| `ZenZachary.aDNA` | GH-priv `ZenZachary.aDNA` | — | touch | brand vault |
| `zeta.aDNA` | GH-priv `zeta.aDNA` | — | touch | |
| `wga.aDNA` | GH-priv `wga.aDNA` | — | touch | CI |
| `ContextCommons.aDNA` | **LatticeProtocol**/`ContextCommons.aDNA` | cross-org | touch + cross-org migrate | confirm I vs P-dev |
| `ComfyUI.aDNA` | local-only | **I** ✅ | touch (first-remote GH-priv **or** stay local L) | **re-mapped from W1a** — STATE "NOT for release"; Anduril-dep research; **never Codeberg**; confirm L-vs-GH-priv at gate |
| `Astro.aDNA` | **GH-priv ✅** `aDNA-Network/Astro.aDNA` | resolved (was cross-org) | **✅ DONE 2026-06-22** (touched early, re-mapped from W2) | operator **BSL-1.1 keep-private** ⇒ class I; GitHub-native cross-org transfer+rename done **private** (HEAD `0d0c315`); wrapper+doctrine+hook+host-fact applied; §C shim (rollback=re-transfer). Revisit public exposure at a future license/release decision |
| `AWSBootstrap.aDNA` | GH-priv `AWSBootstrap.aDNA` | — | touch | private + mesh-bridge |
| `LAVentureGraph.aDNA` | **ScienceStanley**/`LAStartupLattice` | personal+drift | touch + org migrate | personal-account straggler → aDNA-Network |
| `RemoteControl.aDNA` | local-only | — | first-remote (GH-priv) | stub |
| `Warp.aDNA` | local-only | — | first-remote (GH-priv) | genesis P0 |
| `WilhelmAI.aDNA` | **Wilhelm-Foundation** org | partner-org | touch (coord partner) | partner-anchored; stays in partner org |

> **`Spacemacs.aDNA` re-mapped OUT of Wave 3 → Wave 1b** (P-dev → Codeberg-private + cross-org migrate). If the operator deems it internal at the gate, it reverts here (GitHub-private, cross-org migrate only — never Codeberg).

### Wave 5 — Client / I-strict → stay GitHub-private; history-scan; never Codeberg
| Graph | Current | ADR-013 class | Notes |
|---|---|---|---|
| `SuperLeague.aDNA` | GH-priv `SuperLeague.aDNA` | **I-strict** | client (org-graph) |
| `CakeHealth.aDNA` | GH-priv `CakeHealth.aDNA` (ssh) | **I-strict** | clinical data — **history-scan mandatory** |
| `PercySleep.aDNA` | GH-priv `PercySleep.aDNA` | **I-strict** | client; +2 external nested (W4/external) |
| `CakeProtocol.aDNA` | local-only | **I-strict** | local-only per router → first-remote GH-priv |
| `MagnaPetra.aDNA` | local-only | **I-strict** | vendor/founding material |
| `RareArchive.aDNA` | **Wilhelm-Foundation**/`rare-archive-vault` | **I-strict** (partner) | our vault in partner org; coord Wilhelm-Foundation |

### Class L — local-only (declaration only; no remote)
| Graph | ADR-013 class | Notes |
|---|---|---|
| `Home.aDNA` | **L** | Rule-4 local-by-default; remote operator-discretionary |
| `DataRoom.aDNA` | **L** | never-push (legal IP ~120G) |
| `Archive.aDNA` | **L** | archive holder |
| `Datasets.aDNA` | **I/L** (confirm) | new (PT pt15); confirm remote intent |

---

## Nested code-as-WHAT repos (Wave 4 — own remotes, independent of parent)
| Path | Remote | ADR-013 class | Notes |
|---|---|---|---|
| `Context.aDNA/what/contextscope` | `aDNA-Network/contextscope` | **I** | GH-priv→self-hosted |
| `LatticeProtocol.aDNA/what/latticeprotocol` | `aDNA-Network/lattice-protocol` | **I/R** | R if core lib published |
| `Lab.aDNA/what/lab` | `aDNA-Network/latlab` | **I** | |
| `Lab.aDNA/what/lab-workspace` | `aDNA-Network/latlab-lab` (ssh) | **I** | |
| `Molecules.aDNA/what/moleculeforge` | `aDNA-Network/moleculeforge` | **P-dev** | follows parent (Codeberg-private if Molecules→P-dev) |
| `Harness.aDNA/what/harness` | **NO-ORIGIN** | **I** | first remote at migration |
| `DataRoom.aDNA/what/dataroom` | **NO-ORIGIN** | **L** | never-push |

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
