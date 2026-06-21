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

**The pivotal per-graph operator call** is **released vs in-development** for the OSS-intended set (→ GitHub-public now, or → Codeberg-private until release). Defaults proposed below; each marked **(confirm)**.

## Wave sequence (lowest-risk first) — each gated at rollout DP5

| Wave | Set | Action | Risk | Gate prereqs |
|---|---|---|---|---|
| **1a** | FOSS-in-dev, **local-only** → Codeberg-private | create-repo + set-remote + push (greenfield) | **lowest** — no existing remote; = the proven TypeScript pilot; fully rollbackable | token (C58 ✅) · per-repo gitleaks |
| **1b** | FOSS-in-dev, **on GitHub-private** → Codeberg-private | host-move (rename origin→rollback · set new origin · push · shim · retire rollback) | medium — existing remote; reversible via rollback remote | **full-history secret-scan** · Berthier coord (Homecoming) · shim entry |
| **2** | **Released-FOSS** → GitHub-public | visibility-flip private→public (+ name-drift reconcile) | higher **exposure** blast radius | **full-history secret-scan (hard gate)** · operator "released" confirm |
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
| `TypeScript.aDNA` | Codeberg-private ✅ | **P-dev** | Codeberg-private | ✅done | — | **DONE** (P5 pilot) |
| `ComfyUI.aDNA` | local-only | **P-dev** (confirm) | Codeberg-private | per-repo | n/a (first remote) | forge; confirm public-intent |
| `VisualDNA.aDNA` | local-only | **P-dev** (confirm) | Codeberg-private | per-repo | n/a | framework; confirm intent (else I) |
| `Lighthouse.aDNA` | local-only (forked 2026-06-20) | **P-dev** (confirm) | Codeberg-private | per-repo | n/a | new deployable stub; FOSS-intended (else I) |

### Wave 1b — FOSS-in-dev, on GitHub-private → Codeberg-private (host-move)
| Graph | Current | ADR-013 class | Target | Scan | Shim | Notes |
|---|---|---|---|---|---|---|
| `Canvas.aDNA` | GH-priv `aDNA-Network/Canvas.aDNA` | **P-dev** (confirm) | Codeberg-private | ✅ | ✅ | standard-bearer; or P-released if shipping |
| `Videos.aDNA` | GH-priv `aDNA-Network/Videos.aDNA` | **P-dev** (confirm) | Codeberg-private | ✅ | ✅ | forge |
| `Molecules.aDNA` | GH-priv `aDNA-Network/moleculeforge` | **P-dev** (confirm) | Codeberg-private | ✅ | ✅ | **drift** |
| `Oration.aDNA` | GH-priv `aDNA-Network/SpeechForge.aDNA` | **P-dev** (confirm) | Codeberg-private | ✅ | ✅ | **drift** |
| `Astro.aDNA` | **LatticeProtocol**/`SiteForge.aDNA` | **P-dev** (confirm) | Codeberg-private | ✅ | ✅ | **drift + cross-org** (Berthier) |

### Wave 2 — Released-FOSS → GitHub-public (visibility flip)
| Graph | Current | ADR-013 class | Target | Scan | Shim | Notes |
|---|---|---|---|---|---|---|
| `Git.aDNA` | GitHub-public ✅ | **P-released** | GitHub-public | ✅done | — | **DONE** (this graph; P5 beachhead) |
| `aDNA.aDNA` | GH-priv `aDNA-Network/aDNA.aDNA` | **P-released** (confirm) | GitHub-public | ✅ | — | the standard's docs face (template already public) |
| `III.aDNA` | GH-priv `aDNA-Network/III.aDNA` | **P-released** (confirm) | GitHub-public | ✅ | — | production framework; 5–6 live consumers |

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
| `Spacemacs.aDNA` | **LatticeProtocol**/`Spacemacs.aDNA` | cross-org | touch (+ maybe Wave 1b/2) | v1.0.0 complete → **confirm P-released/P-dev vs I**; CI |
| `AWSBootstrap.aDNA` | GH-priv `AWSBootstrap.aDNA` | — | touch | private + mesh-bridge |
| `LAVentureGraph.aDNA` | **ScienceStanley**/`LAStartupLattice` | personal+drift | touch + org migrate | personal-account straggler → aDNA-Network |
| `RemoteControl.aDNA` | local-only | — | first-remote (GH-priv) | stub |
| `Warp.aDNA` | local-only | — | first-remote (GH-priv) | genesis P0 |
| `WilhelmAI.aDNA` | **Wilhelm-Foundation** org | partner-org | touch (coord partner) | partner-anchored; stays in partner org |

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

## Operator-decision rows (resolve before / at the relevant wave gate)
1. **Released vs in-dev split** (the pivotal call): confirm each OSS-intended graph is **P-released → GitHub-public** vs **P-dev → Codeberg-private** — `aDNA.aDNA`, `III` (proposed P-released); `Canvas`, `Astro`, `Videos`, `Molecules`, `Oration`, `ComfyUI`, `VisualDNA`, `Spacemacs` (proposed P-dev).
2. **Name-drift** (~14 repos): rename-on-host (origin = dirname) vs accept `origin ≠ dirname`. Affects `Molecules`, `Oration`, `Operations`, `TappProtocol`, `VAAS`, `LatticeProtocol`, `Lab`, `Astro`, … (ADR-006 remote-naming).
3. **Cross-org stragglers** → migrate `LatticeProtocol` → `aDNA-Network` (`Astro`, `ContextCommons`, `Spacemacs`) + personal `ScienceStanley/LAStartupLattice` → org. **Coordinate Berthier** (Homecoming).
4. **Unmapped GitHub repos** (exist on a host, no obvious local graph): `TheKINN.aDNA`, `WGS.aDNA`, `WorldGenomeProtocol.aDNA` (aDNA-Network; WorldGenome quarries) · `richie_lab.aDNA` (LatticeProtocol). → archive / map / ignore.
5. **Public-intent confirms**: `Datasets.aDNA`, `VisualDNA.aDNA`, `ComfyUI.aDNA`, `Lighthouse.aDNA`.

## Reconciliation — zero unaccounted (vs `fleet_git_state.md`)
| Bucket | fleet_git_state | this ledger | Δ |
|---|---|---|---|
| Intended-PUBLIC (9) | aDNA, III, Canvas, Astro, Videos, Molecules, Oration, TypeScript, ComfyUI | all mapped (W2/W1a/W1b) | 0 |
| Private/internal (23) | aDNALabs…LAVentureGraph | all mapped (W3 + W5 for the 3 client) | 0 |
| Local-only (10) | Home, DataRoom, Datasets, CakeProtocol, MagnaPetra, RemoteControl, VisualDNA, Warp, Git, Archive | all mapped (L / W5 / W3 / W1a / done) | 0 |
| Partner-anchored (2) | RareArchive→vault, WilhelmAI | mapped (W5 / W3) | 0 |
| Post-P1 fork (1) | Lighthouse.aDNA | mapped (W1a, confirm) | 0 |
| Nested code-as-WHAT (7 internal) | per §nested | mapped (W4) | 0 |
| External/never-moved (4) | rare-archive, 2× Percy, llama.cpp | listed (untouched) | 0 |
| Unmapped (4) | TheKINN, WGS, WorldGenomeProtocol, richie_lab | flagged (decision row 4) | 0 |

**Canonical graphs accounted: 45** (9 + 23 + 10 + 2 + 1). **Zero unaccounted.** ✅ (P6 exit-gate criterion #1.)

---

## Wave 1 — gate-ready execution checklist (DP5-GATED — NOT executed)

> The lowest-risk first wave. **Outward — fires only on operator authorization (rollout DP5).** All verbs via the agnostic lib (the 5 P5 fixes are now folded). Per-graph, in order:

**Wave 1a (greenfield, local-only → Codeberg-private)** — target set: `ComfyUI.aDNA`, `VisualDNA.aDNA`, `Lighthouse.aDNA` *(each pending the released-vs-dev confirm; drop any the operator marks `I`)*.

For each graph `G`:
1. **Pre-flight** — confirm `G` is local-only (`git -C G remote -v` empty); confirm class = P-dev (operator).
2. **Secret-scan gate (ADR-011)** — `gitleaks detect --source G` (full history) → **must be clean**; a finding blocks until purged + credential rotated (Home).
3. **Declaration** — author `G/git/CLAUDE.md` (`git_provider`: host `codeberg.org`, backend `forgejo`, visibility `private`, class `P`) + paste the doctrine block into `G/CLAUDE.md` *(cross-vault → staged coord, applied at the gate, Rule 10)*.
4. **Create + wire + push** — `GITOPS_ALLOW_LIVE=1`, then `gitops_create_repo codeberg.org aDNA-Network G private` → `gitops_set_remote codeberg.org aDNA-Network G origin` → `gitops_push <branch>` (Basic-auth path not used here — Forgejo token, proven live).
5. **Verify** — authed clone OK; **anon clone refused** (private proven, the P-dev invariant).
6. **Shim entry** — register the new origin in Home.aDNA's shim registry (Rule 9) with a rollback path *(staged coord)*.
7. **STATE/MANIFEST** — update `G`'s STATE/MANIFEST host facts *(cross-vault, staged)*.

**Wave 1b (host-move, GitHub-private → Codeberg-private)** — target set: `Canvas`, `Videos`, `Molecules`, `Oration`, `Astro` *(pending confirm)*. Same as 1a but step 4 is a **host-move** (ADR-006 §4 sequence): full-history secret-scan → `git remote rename origin rollback` → `gitops_set_remote codeberg.org aDNA-Network G origin` → `gitops_push --all --tags` → shim entry → retire `rollback` at window close. Coordinate Berthier for the name-drift/cross-org cases (`Molecules`, `Oration`, `Astro`).

**Wave-exit:** each graph carries the declaration + doctrine block + updated STATE/MANIFEST + shim entry; ledger row flips to ✅. **Nothing in Wave 1 runs without the DP5 gate** (Standing Order #1/#2).

## AAR
*(see mission `p6_fleet_alignment.md`)*
