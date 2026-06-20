---
type: inventory
created: 2026-06-19
updated: 2026-06-19
status: active
last_edited_by: agent_stanley
campaign: campaign_git_genesis
phase: P1
tags: [inventory, git, fleet, provider_agnostic, fleet_git_state, p1]
---

# Fleet Git-State Ledger

> P1 deliverable (Operation Free Harbor). Authoritative snapshot of every graph's git topology, captured **2026-06-19** by read-only sweep (`git remote -v` per dir + `gh repo list <org> --json visibility`). Visibility is **resolved** (not "unknown-from-local"). This is the evidence base for the visibility-driven split ([[adr_003_visibility_split_policy]]) and the P6 migration waves.

## ⭐ Load-bearing findings (read first)

1. **The fleet is ~95% PRIVATE on GitHub.** Of all `aDNA-Network` repos, **only `aDNA` (the template) is PUBLIC**; *every* graph repo is `PRIVATE` — including the ones the ecosystem docs call "public/OSS" (**III, Canvas, Astro, Videos, Molecules, Oration, TypeScript, aDNA.aDNA**). **Consequence:** applying the visibility split *as the fleet stands today* moves **almost the entire fleet → Codeberg**, and GitHub keeps only a **curated public set that must first be flipped public**. → **Operator decision at P2 entry:** confirm the intended-public set (and authorize flipping them public on GitHub) vs. private-to-Codeberg.
2. **Remote-name drift (≈14 graphs).** PT renamed the *directories* but not the *GitHub repos*, so origins still point at pre-rename names: `Molecules.aDNA`→`moleculeforge`, `Oration.aDNA`→`SpeechForge.aDNA`, `Operations.aDNA`→`TaskForge.aDNA`, `VAAS.aDNA`→`VAASLattice.aDNA`, `LatticeProtocol.aDNA`→`latticeprotocol-adna`, `Lab.aDNA`→`lab-adna`, `Astro.aDNA`→`SiteForge.aDNA`, etc. Migration must reconcile repo names (rename on the host or accept the drift).
3. **Cross-org stragglers (5).** Still on the **legacy `LatticeProtocol` org** (not migrated to `aDNA-Network`): **Astro.aDNA** (`SiteForge.aDNA`), **ContextCommons.aDNA**, **Spacemacs.aDNA**, + `SiteForge.aDNA` alias. **LAVentureGraph.aDNA** is on a *personal* account (`ScienceStanley/LAStartupLattice`).
4. **12 local-only graphs (no remote).** `Git.aDNA`, `Home.aDNA` (Rule-4 local-by-default), `DataRoom.aDNA` (never-push), `Datasets.aDNA`, `CakeProtocol.aDNA`, `MagnaPetra.aDNA`, `RemoteControl.aDNA`, `TypeScript.aDNA`, `VisualDNA.aDNA`, `Warp.aDNA`, `ComfyUI.aDNA`, `Archive.aDNA`. These get a **first** remote during migration (Codeberg, unless intended-public).
5. **10 nested code-as-WHAT repos** carry their **own** remotes, distinct from the parent graph (e.g. `Context.aDNA/what/contextscope`→`aDNA-Network/contextscope`; `LatticeProtocol.aDNA/what/latticeprotocol`→`aDNA-Network/lattice-protocol`). Two are **NO-ORIGIN** (`DataRoom/what/dataroom`, `Harness/what/harness`). `PercySleep/what/percysleep_code/*` are **external** (`percysleep` org — partner, never moved). → P6 **wave 3** handles these separately from their parent graph.
6. **Partner-org repos** (`Wilhelm-Foundation`): `rare-archive` + the `udni-*` set are **PUBLIC**, externally canonical — **never moved** (ADR-001 out-of-scope). `RareArchive.aDNA` graph → `Wilhelm-Foundation/rare-archive-vault` (PRIVATE, our vault).
7. **Branch drift.** Mixed `main`/`master` defaults across the fleet; `ScienceStanley.aDNA` is on `dev`. A CI/hygiene item, not blocking.
8. **CI is sparse.** Only `ScienceStanley.aDNA` (`preflight.yml`), `Spacemacs.aDNA`, `wga.aDNA`, `llama.cpp`, `latlab`, + the 3 reusable workflows at `.adna/` carry CI. Caller URLs still reference the **old `LatticeProtocol/aDNA`** org — a CI-parity migration item.

## Counts

| Metric | Value |
|---|---|
| Canonical graphs (non-alias) | ~43 + `Archive.aDNA` holder |
| Root back-compat symlink aliases (old→new name) | ~24 (share the renamed graph's remote; **not** distinct migration targets) |
| On GitHub `aDNA-Network` | ~30 graphs |
| On GitHub `LatticeProtocol` (legacy straggler) | 4 (Astro/SiteForge, ContextCommons, Spacemacs) |
| On GitHub `Wilhelm-Foundation` | 2 (RareArchive→vault, WilhelmAI) |
| On a personal account (`ScienceStanley`) | 1 (LAVentureGraph) |
| **PUBLIC on GitHub** | **1** (`aDNA-Network/aDNA` template) + partner `Wilhelm-Foundation/rare-archive` + `udni-*` |
| Local-only (no remote) | 12 |
| Nested code-as-WHAT repos | 10 (8 with remotes, 2 NO-ORIGIN, 2 external Percy) |
| `tea` (Forgejo CLI) installed | ❌ no |
| Codeberg credential present | ❌ no |

## Inventory — canonical graphs (grouped by draft classification)

> **Class** column is a **DRAFT** for operator ratification at P2 entry (Decision Point 2). Visibility = current GitHub state. **I** = Internal→Codeberg · **P** = Public→GitHub · **R** = Release (Codeberg origin + GitHub mirror) · **L** = Local-only (Rule-4 / never-push, stays off both unless opted in).

### Intended-PUBLIC (→ GitHub; ⚠ currently PRIVATE — needs flip)

| Graph | Current remote | Vis (now) | Class-draft | Note |
|---|---|---|---|---|
| `aDNA.aDNA` | aDNA-Network/aDNA.aDNA | PRIVATE | **P** | the standard's docs vault (the *template* `aDNA-Network/aDNA` is already public; this is the `.aDNA` graph) |
| `III.aDNA` | aDNA-Network/III.aDNA | PRIVATE | **P** | Framework, "6 consumer wrappers"; OSS-intended |
| `Canvas.aDNA` | aDNA-Network/Canvas.aDNA | PRIVATE | **P** | Canvas standard-bearer |
| `Astro.aDNA` | **LatticeProtocol**/SiteForge.aDNA | PRIVATE | **P** | + cross-org + name drift |
| `Videos.aDNA` | aDNA-Network/Videos.aDNA | PRIVATE | **P** | forge |
| `Molecules.aDNA` | aDNA-Network/**moleculeforge** | PRIVATE | **P** | name drift |
| `Oration.aDNA` | aDNA-Network/**SpeechForge.aDNA** | PRIVATE | **P** | name drift |
| `TypeScript.aDNA` | (local-only) | — | **P** | OSS-intended; no remote yet |
| `ComfyUI.aDNA` | (local-only) | — | **P?** | forge; confirm intent |

### Private / internal (→ Codeberg)

| Graph | Current remote | Vis | Class-draft | Note |
|---|---|---|---|---|
| `aDNALabs.aDNA` | aDNA-Network/aDNALabs.aDNA | PRIVATE | **I** | org HQ |
| `Harness.aDNA` | aDNA-Network/Harness.aDNA | PRIVATE | **I** | + nested `what/harness` NO-ORIGIN |
| `Context.aDNA` | aDNA-Network/Context.aDNA | PRIVATE | **I** | + nested `contextscope` |
| `LatticeProtocol.aDNA` | aDNA-Network/**latticeprotocol-adna** | PRIVATE | **I/R** | name drift; core lib (R if published) + nested `lattice-protocol` |
| `Lab.aDNA` | aDNA-Network/**lab-adna** | PRIVATE | **I** | name drift; + nested `lab`,`lab-workspace` |
| `Network.aDNA` | aDNA-Network/Network.aDNA | PRIVATE | **I** | mesh registry (sensitive) |
| `Terminal.aDNA` | aDNA-Network/Terminal.aDNA | PRIVATE | **I** | |
| `Obsidian.aDNA` | aDNA-Network/Obsidian.aDNA | PRIVATE | **I** | |
| `Operations.aDNA` | aDNA-Network/**TaskForge.aDNA** | PRIVATE | **I** | name drift |
| `TappProtocol.aDNA` | aDNA-Network/**TappInterface.aDNA** | PRIVATE | **I** | name drift |
| `VAAS.aDNA` | aDNA-Network/**VAASLattice.aDNA** | PRIVATE | **I** | name drift |
| `WorldGenome.aDNA` | aDNA-Network/WorldGenome.aDNA | PRIVATE | **I** | |
| `ScienceStanley.aDNA` | aDNA-Network/ScienceStanley.aDNA | PRIVATE | **I** | brand vault (br=dev; CI) |
| `ZenZachary.aDNA` | aDNA-Network/ZenZachary.aDNA | PRIVATE | **I** | brand vault |
| `zeta.aDNA` | aDNA-Network/zeta.aDNA | PRIVATE | **I** | |
| `wga.aDNA` | aDNA-Network/wga.aDNA | PRIVATE | **I** | CI |
| `ContextCommons.aDNA` | **LatticeProtocol**/ContextCommons.aDNA | PRIVATE | **I** | cross-org straggler |
| `Spacemacs.aDNA` | **LatticeProtocol**/Spacemacs.aDNA | PRIVATE | **I/P?** | cross-org straggler; CI |
| `AWSBootstrap.aDNA` | aDNA-Network/AWSBootstrap.aDNA | PRIVATE | **I** | private + mesh-bridge |
| `SuperLeague.aDNA` | aDNA-Network/SuperLeague.aDNA | PRIVATE | **I-strict** | client (org-graph) |
| `CakeHealth.aDNA` | aDNA-Network/CakeHealth.aDNA (ssh) | PRIVATE | **I-strict** | client clinical data — **history-scan before any move** |
| `PercySleep.aDNA` | aDNA-Network/PercySleep.aDNA | PRIVATE | **I-strict** | client; + 2 external nested Percy repos |
| `LAVentureGraph.aDNA` | **ScienceStanley**/LAStartupLattice | PRIVATE | **I** | personal-account straggler |

### Local-only (no remote today — first remote at migration)

| Graph | Class-draft | Note |
|---|---|---|
| `Home.aDNA` | **L** | Rule-4 local-by-default; remote operator-discretionary |
| `DataRoom.aDNA` | **L** | never-push (legal IP, ~120G) |
| `Datasets.aDNA` | **I/L** | new (PT pt15) |
| `CakeProtocol.aDNA` | **I-strict** | local-only per router; → Codeberg |
| `MagnaPetra.aDNA` | **I-strict** | vendor/founding material |
| `RemoteControl.aDNA` | **I** | stub |
| `VisualDNA.aDNA` | **I/P?** | framework; confirm intent |
| `Warp.aDNA` | **I** | genesis P0 (local-by-default at fork) |
| `Git.aDNA` | **I** | this graph (first remote = P5 dogfood) |
| `Archive.aDNA` | **L** | archive holder |

## Nested code-as-WHAT repos (P6 wave 3 — own remotes)

| Path | Remote | Note |
|---|---|---|
| `Context.aDNA/what/contextscope` | aDNA-Network/contextscope | PRIVATE |
| `LatticeProtocol.aDNA/what/latticeprotocol` | aDNA-Network/lattice-protocol | PRIVATE |
| `Lab.aDNA/what/lab` | aDNA-Network/latlab | PRIVATE |
| `Lab.aDNA/what/lab-workspace` | aDNA-Network/latlab-lab (ssh) | PRIVATE |
| `Molecules.aDNA/what/moleculeforge` | aDNA-Network/moleculeforge | PRIVATE |
| `RareArchive.aDNA/what/rare-archive` | Wilhelm-Foundation/rare-archive | **PUBLIC, external — never moved** |
| `DataRoom.aDNA/what/dataroom` | NO-ORIGIN | never-push |
| `Harness.aDNA/what/harness` | NO-ORIGIN | first remote at migration |
| `PercySleep.aDNA/what/percysleep_code/Percy_Firmware` | percysleep/Percy_Firmware | **external partner — never moved** |
| `PercySleep.aDNA/what/percysleep_code/percy-adapter` | percysleep/percy-adapter | **external partner — never moved** |

## Edge cases / hygiene

- **Dual remotes:** `latlab` (`legacy`=LatticeProtocol/latlab + `origin`=aDNA-Network/latlab); `lattice-labs`→`LatticeProtocol/lattice-vault` (+LFS); `LPWhitepaper.aDNA` has a **path-style** remote `origin-whitepaper=/Users/stanley/aDNA/_archive/whitepaper_predecessor` (archived).
- **External upstreams (never moved):** `llama.cpp`→`ggml-org/llama.cpp` (MIT, +submodules, CI); Wilhelm `rare-archive`/`udni-*`; Percy nested repos.
- **Archived GitHub repos** (PRIVATE/PUBLIC `[ARCHIVED]`): `adna-legacy`, `videoforge`, LatticeProtocol `latlab`/`lattice-protocol`/`moleculeforge`/`rareharness`/`whitepaper`/`spacelattice`.
- **Unmapped GitHub repos** (exist on `aDNA-Network`, no obvious local graph): `TheKINN.aDNA`, `WGS.aDNA`, `WorldGenomeProtocol.aDNA` (WorldGenome quarries), `richie_lab.aDNA` (LatticeProtocol). → flag for operator.

## Open items → P2 / operator
- Ratify the **intended-public set** (and authorize flipping those GitHub repos public) — finding #1.
- Decide whether **name-drift** repos get renamed on the host or accept origin≠dirname.
- Decide handling of the **cross-org stragglers** (LatticeProtocol → aDNA-Network) — coordinate with `aDNALabs.aDNA` (Homecoming).
- `Datasets.aDNA`, `VisualDNA.aDNA`, `ComfyUI.aDNA`, `TypeScript.aDNA` public-vs-private intent.
