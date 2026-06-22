---
type: inventory
ledger_id: disposition_ledger
title: "P6 Disposition Ledger — fleet → ADR-013 host table"
created: 2026-06-21
updated: 2026-06-21
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
| **1a** | FOSS-in-dev, **local-only** → Codeberg-private | create-repo + set-remote + push (greenfield) | **lowest** — no existing remote; = the proven TypeScript pilot; fully rollbackable | token (C58 ✅) · per-repo gitleaks ✅ pre-cleared |
| **1b** | FOSS-in-dev, **on GitHub-private** → Codeberg-private | host-move (rename origin→rollback · set new origin · push · shim · retire rollback) | medium — existing remote; reversible via rollback remote | **full-history secret-scan** ✅ pre-cleared · Berthier coord (Homecoming) · shim entry |
| **2** | **Released-FOSS** → GitHub-public | visibility-flip private→public (+ name-drift / cross-org reconcile) | higher **exposure** blast radius → **deferred after W1, per-graph** | **full-history secret-scan (hard gate)** · operator "released" confirm ✅ (`aDNA`·`III`·`Canvas`·`Astro`) |
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
| `VisualDNA.aDNA` | local-only | **P-dev** ✅ | Codeberg-private | ✅ clean (2026-06-21) | n/a (first remote) | framework GA v1.0.0 — Codeberg-private (conservative; not in released-4); may flip public at a later release gate |
| `Lighthouse.aDNA` | local-only (forked 2026-06-20) | **P-dev** ✅ | Codeberg-private | ✅ clean (2026-06-21) | n/a (first remote) | new deployable stub; FOSS-intended (north-star) |

> **Re-mapped OUT of Wave 1a:** `ComfyUI.aDNA` → **Wave 3 / class I** — STATE.md is explicit "**NOT for release**" (research checkpoints, Anduril-dependent); internal, **never Codeberg**. Stays local (class L) or takes a first GitHub-private remote — operator confirm at the W3 gate.

### Wave 1b — FOSS-in-dev, on GitHub-private → Codeberg-private (host-move)
| Graph | Current | ADR-013 class | Target | Scan | Shim | Notes |
|---|---|---|---|---|---|---|
| `Videos.aDNA` | GH-priv `aDNA-Network/Videos.aDNA` | **P-dev** ✅ | Codeberg-private | ✅ clean (2026-06-21) | ✅ | forge; genesis-complete but pre-release (not in released-4) |
| `Molecules.aDNA` | GH-priv `aDNA-Network/moleculeforge` | **P-dev** ✅ | Codeberg-private `Molecules.aDNA` | ⚠️→✅ FP-only (2026-06-21) | ✅ | **name-drift** → rename-on-host (Berthier); 16 gitleaks hits = **confirmed false-positives** (8-char verdict enums `accepted`/`rejected` + module-type `verifier` in `execution_result.json`; `generic-api-key` on dict-words) → **NO secret, NO rotation**; scoped per-graph `.gitleaks.toml` allowlist staged |
| `Oration.aDNA` | GH-priv `aDNA-Network/SpeechForge.aDNA` | **P-dev** ✅ | Codeberg-private `Oration.aDNA` | ✅ clean (2026-06-21) | ✅ | **name-drift** → rename-on-host (Berthier); genesis P1 |
| `Spacemacs.aDNA` | **LatticeProtocol**/`Spacemacs.aDNA` | **P-dev** (confirm FOSS-intent) | Codeberg-private | ✅ clean (2026-06-21) | ✅ | **cross-org** → migrate `aDNA-Network` (Berthier); v1.0.0; if operator deems internal → W3 (GH-priv, cross-org only) |

> **Re-mapped OUT of Wave 1b → Wave 2 (released-FOSS → GitHub-public):** `Canvas.aDNA` (Op Keystone complete, **v2.0.0 shipped**, live consumers) + `Astro.aDNA` (production, phase 7 complete). Both are **released** → GitHub-public, **not** Codeberg-private. See Wave 2.

### Wave 2 — Released-FOSS → GitHub-public (visibility flip; deferred after W1, per-graph gated)
| Graph | Current | ADR-013 class | Target | Scan | Shim | Notes |
|---|---|---|---|---|---|---|
| `Git.aDNA` | GitHub-public ✅ | **P-released** | GitHub-public | ✅done | — | **DONE** (this graph; P5 beachhead) |
| `aDNA.aDNA` | GH-priv `aDNA-Network/aDNA.aDNA` | **P-released** ✅ | GitHub-public | W2-gate | — | the standard's docs face (template already public) |
| `III.aDNA` | GH-priv `aDNA-Network/III.aDNA` | **P-released** ✅ | GitHub-public | W2-gate | — | production framework; 5–6 live consumers |
| `Canvas.aDNA` | GH-priv `aDNA-Network/Canvas.aDNA` | **P-released** ✅ | GitHub-public | W2-gate | — | **re-mapped from W1b** — Op Keystone complete, v2.0.0 shipped, live consumers |
| `Astro.aDNA` | **LatticeProtocol**/`SiteForge.aDNA` | **P-released** ✅ | GitHub-public `aDNA-Network/Astro.aDNA` | W2-gate | ✅ | **re-mapped from W1b** — production, phase 7 complete; **cross-org + name-drift** → migrate `aDNA-Network` + rename (Berthier) **before** the public flip |

> Wave 2 secret-scans are a **hard full-history gate** (public exposure) run at the **Wave 2 session**, per-graph — not pre-cleared here (W2 is deferred after W1). `Astro` sequences cross-org migrate + rename → scan → public-flip.

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
1. **Released vs in-dev split** (the pivotal call) — **✅ RESOLVED 2026-06-21 (conservative threshold).** Released → GitHub-public (W2) = **`aDNA` · `III` · `Canvas` · `Astro`**. FOSS-in-dev → Codeberg-private (W1) = **`TypeScript`(done) · `VisualDNA` · `Lighthouse` · `Videos` · `Molecules` · `Oration` · `Spacemacs`**. Internal → stay (W3) = **`ComfyUI`** + the I-majority.
2. **Name-drift** — **✅ RESOLVED: rename-on-host now** (origin = dirname), coord Berthier. Wave-1 cases: `Molecules` (`moleculeforge`→`Molecules.aDNA`), `Oration` (`SpeechForge.aDNA`→`Oration.aDNA`). Other drift (`Operations`, `TappProtocol`, `VAAS`, `LatticeProtocol`, `Lab`, …) renamed at their W3 touch.
3. **Cross-org stragglers** — **✅ RESOLVED: migrate now**, coord Berthier. Wave-1 case: `Spacemacs` (`LatticeProtocol`→`aDNA-Network`, but to **Codeberg**). Wave-2 case: `Astro` (`LatticeProtocol`→`aDNA-Network` on **GitHub**, before the public flip). W3 cases: `ContextCommons` + personal `ScienceStanley/LAStartupLattice`.
4. **Unmapped GitHub repos** (exist on a host, no obvious local graph) — **OPEN** (not Wave-1-blocking): `TheKINN.aDNA`, `WGS.aDNA`, `WorldGenomeProtocol.aDNA` (aDNA-Network; WorldGenome quarries) · `richie_lab.aDNA` (LatticeProtocol). → archive / map / ignore at a later gate.
5. **Residual sub-confirms** (at the relevant gate, not Wave-1-blocking): `Spacemacs` FOSS-intent (P-dev→Codeberg vs I→stay) · `ComfyUI` local-L-vs-GitHub-private · `Datasets.aDNA` remote-intent.

## Reconciliation — zero unaccounted (vs `fleet_git_state.md`)
Buckets are the `fleet_git_state` source grouping; the **this-ledger** column shows the post-reconciliation (ADR-013, conservative-threshold) wave. The re-map moved graphs *between waves* — the 45-graph total is unchanged.

| Bucket | fleet_git_state | this ledger (reconciled 2026-06-21) | Δ |
|---|---|---|---|
| Intended-PUBLIC (9) | aDNA, III, Canvas, Astro, Videos, Molecules, Oration, TypeScript, ComfyUI | aDNA/III/Canvas/Astro→**W2**; TypeScript(done)/Videos/Molecules/Oration→**W1**; **ComfyUI→W3 (internal — re-classified)** | 0 |
| Private/internal (23) | aDNALabs…LAVentureGraph | W3 touch + W5 for the 3 client; **`Spacemacs`→W1b (FOSS-in-dev — re-classified)** | 0 |
| Local-only (10) | Home, DataRoom, Datasets, CakeProtocol, MagnaPetra, RemoteControl, VisualDNA, Warp, Git, Archive | L / W5 / W3 / **VisualDNA→W1a** / Git done | 0 |
| Partner-anchored (2) | RareArchive→vault, WilhelmAI | mapped (W5 / W3) | 0 |
| Post-P1 fork (1) | Lighthouse.aDNA | mapped (**W1a** ✅) | 0 |
| Nested code-as-WHAT (7 internal) | per §nested | mapped (W4) | 0 |
| External/never-moved (4) | rare-archive, 2× Percy, llama.cpp | listed (untouched) | 0 |
| Unmapped (4) | TheKINN, WGS, WorldGenomeProtocol, richie_lab | flagged (decision row 4) | 0 |

**Canonical graphs accounted: 45** (9 + 23 + 10 + 2 + 1). **Zero unaccounted.** ✅ (P6 exit-gate criterion #1.) **Two cross-bucket re-classifications** this reconciliation (`ComfyUI` public→internal; `Spacemacs` internal→FOSS-dev) net to zero — both still accounted, just in a different wave.

---

## Wave 1 — gate-ready execution checklist (DP5-GATED — NOT executed)

> The lowest-risk first wave (**private moves only**). **Outward — fires only on operator authorization (rollout DP5).** All verbs via the agnostic lib (the 5 P5 fixes are folded; dry-run 23/23). **Pre-cleared 2026-06-21:** per-graph secret-scans ✅ clean; per-graph artifacts (declaration · doctrine block · hook · shim · STATE/MANIFEST patch) + the Berthier coord are **staged** at [[how/campaigns/campaign_git_genesis/missions/wave1_staging/wave1_runbook|wave1_staging/]]. The runbook there has the exact commands; this is the contract summary. Per-graph, in order:

**Wave 1a (greenfield, local-only → Codeberg-private)** — target set: **`VisualDNA.aDNA`, `Lighthouse.aDNA`** *(ComfyUI dropped → W3/I; TypeScript done at P5, declaration staged)*.

For each graph `G`:
1. **Pre-flight** — confirm `G` is local-only (`git -C G remote -v` empty) ✅ verified 2026-06-21; class = P-dev ✅ (operator).
2. **Secret-scan gate (ADR-011)** — `gitleaks detect` (full history) → **clean** ✅ pre-cleared 2026-06-21; re-run at the gate as a fresh check; a finding blocks until purged + credential rotated (Home).
3. **Declaration** — apply the staged `G/git/CLAUDE.md` (`git_provider`: host `codeberg.org`, backend `forgejo`, visibility `private`, class `P`) + paste the staged ADR-013 doctrine block into `G/CLAUDE.md` *(cross-vault → applied at the gate, Rule 10)*.
4. **Create + wire + push** — `GITOPS_ALLOW_LIVE=1`, then `gitops_create_repo codeberg.org aDNA-Network G private` → `gitops_set_remote codeberg.org aDNA-Network G origin` → `gitops_push <branch>` (Forgejo token, proven live at P5).
5. **Verify** — authed clone OK; **anon clone refused** (private proven, the P-dev invariant).
6. **Shim entry** — register the new origin in Home.aDNA's shim registry (Rule 9) with a rollback path *(staged coord)*.
7. **STATE/MANIFEST** — apply `G`'s staged STATE/MANIFEST host-fact patch *(cross-vault, staged)*.

**Wave 1b (host-move, GitHub-private → Codeberg-private)** — target set: **`Videos`, `Molecules`, `Oration`, `Spacemacs`** *(Canvas, Astro dropped → W2 released; Spacemacs added from W3)*. Same as 1a but step 4 is a **host-move** (ADR-006 §4 sequence): full-history secret-scan → `git remote rename origin rollback` → `gitops_set_remote codeberg.org aDNA-Network G origin` → `gitops_push --all --tags` → shim entry → retire `rollback` at window close. **Coordinate Berthier first** for the name-drift cases (`Molecules`: `moleculeforge`→`Molecules.aDNA`; `Oration`: `SpeechForge.aDNA`→`Oration.aDNA`) + the cross-org case (`Spacemacs`: `LatticeProtocol`→`aDNA-Network` *on Codeberg*).

**Wave-exit:** each graph carries the declaration + doctrine block + updated STATE/MANIFEST + shim entry; ledger row flips to ✅. **Nothing in Wave 1 runs without the DP5 gate** (Standing Order #1/#2). **Wave 2 (public flips: `aDNA`·`III`·`Canvas`·`Astro`) is a separate, later, per-graph gate** with a mandatory full-history secret-scan.

## AAR
*(see mission `p6_fleet_alignment.md`)*
