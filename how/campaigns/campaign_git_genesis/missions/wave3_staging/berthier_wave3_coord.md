---
type: coordination
coord_id: coord_2026_06_22_git_wave3_berthier_reconcile
title: "Hopper → Berthier: P6 Wave 3 name-drift renames + cross-org transfers (8 graphs) — STAGED"
from: Git.aDNA (Grace Hopper)
to: aDNALabs.aDNA (Berthier)
created: 2026-06-22
updated: 2026-06-22
status: staged
last_edited_by: agent_stanley
tags: [coordination, p6, wave_3, name_drift, cross_org, homecoming, operation_free_harbor, needs_human]
---

# Wave 3 — GitHub-side reconcile (name-drift renames + cross-org transfers)

> **STAGED per Standing Rule 10** — Git.aDNA does not write into aDNALabs. Deliver/accept from an aDNALabs session **at the Wave-3 fire gate** (the Wave-1b precedent: operator approval at the gate = Berthier cross-persona ack; renames/transfers can then execute in the same Git.aDNA session, GitHub-native, like Astro). Nothing here fires until the rollout DP5 gate.

**Context.** Git.aDNA P6 **Wave 3** brings the internal/proprietary (class I) majority into the agnostic paradigm — each graph gets a `git/` wrapper + `## Git-Ops` doctrine + gitleaks hook + host-fact, and **stays GitHub-private-interim** (no Codeberg, no public flip; ADR-013). Most Wave-3 graphs are **pure touch** (origin already correct). **8 graphs additionally need a GitHub-side reconcile** that is Berthier's lane (coexists with Operation Homecoming). All stay **private** throughout; these are housekeeping renames/transfers, the proven Astro mechanic (GitHub-native, history/issues preserved, old paths redirect, **no `rollback` remote** — rollback = re-transfer/re-rename).

## A. Name-drift renames (same org `aDNA-Network`; repo name ≠ vault dirname)

GitHub-native `gh repo rename`; old refs redirect. End state: repo name = `<Vault>.aDNA`.

| Vault | Current repo | → Rename to | Branch |
|---|---|---|---|
| `LatticeProtocol.aDNA` | `aDNA-Network/latticeprotocol-adna` | `LatticeProtocol.aDNA` | `main` |
| `Lab.aDNA` | `aDNA-Network/lab-adna` | `Lab.aDNA` | `main` |
| `Operations.aDNA` | `aDNA-Network/TaskForge.aDNA` | `Operations.aDNA` | `master` |
| `TappProtocol.aDNA` | `aDNA-Network/TappInterface.aDNA` | `TappProtocol.aDNA` | `master` |
| `VAAS.aDNA` | `aDNA-Network/VAASLattice.aDNA` | `VAAS.aDNA` | `main` |

> These mirror the Wave-1b name-drift cases (`MoleculeForge`→`Molecules`, `SpeechForge`→`Oration`) that you already ack'd — same pattern, on GitHub (private) rather than Codeberg. Coexists with the renames Operation Homecoming may already plan.

## B. Cross-org transfers (→ `aDNA-Network`, kept private)

GitHub-native repo transfer (the Astro mechanic: `gh api -X POST repos/<src>/<repo>/transfer -f new_owner=aDNA-Network`, poll-until-settled; a transient **422 "operation in progress"** on an immediate follow-up is expected — retry once settled).

| Vault | Current repo | → Transfer (+rename) to | Note |
|---|---|---|---|
| `ContextCommons.aDNA` | `LatticeProtocol/ContextCommons.aDNA` | `aDNA-Network/ContextCommons.aDNA` | name matches; **operator confirm I vs P-dev first** — if P-dev it leaves Wave 3 → Codeberg-private instead |
| `LAVentureGraph.aDNA` | **`ScienceStanley/LAStartupLattice`** (personal acct) | `aDNA-Network/LAVentureGraph.aDNA` | transfer **+ rename**; **personal-account** transfer needs source-owner (ScienceStanley) auth + target-org accept — verify token scopes |

## C. Partner-org — `WilhelmAI.aDNA` (STAYS; coexistence only)

| Vault | Current repo | Disposition |
|---|---|---|
| `WilhelmAI.aDNA` | `Wilhelm-Foundation/WilhelmAI` | **STAYS in `Wilhelm-Foundation`** (partner-org, ADR-001 — not part of the aDNA-Network migration). Touch-only: wrapper (`org: Wilhelm-Foundation`) + doctrine + hook + host-fact pushed to the partner origin. **Repo name lacks the `.aDNA` suffix** — adding it is a **partner decision** (Wilhelm-Foundation owns the repo); do **not** rename without partner coord. Flag for the Wilhelm-Foundation relationship owner. |

## D. FYI — unmapped GitHub repos (not a Wave-3 ask; operator-decision row 4)

For your awareness during Homecoming: `aDNA-Network/{TheKINN.aDNA, WGS.aDNA, WorldGenomeProtocol.aDNA}` + `LatticeProtocol/richie_lab.aDNA` exist on GitHub with no obvious local graph (WorldGenome quarries). Disposition (archive / map / ignore) is an operator call at a later gate — **not** part of Wave 3.

## Sequencing (at the gate)
Per graph: Git.aDNA touches (wrapper+doctrine+hook+host-fact) + dogfood-pushes to the **current** origin → then the GitHub-native rename/transfer → repoint local `origin` → re-fetch → update the wrapper `origin` + STATE/MANIFEST host-fact. **No `rollback` remote, no §C host-move shim with a window** — native transfer/rename redirects are the rollback (a §C *native-transfer/redirect* note is registered for B's transfers, like Astro). Each runs only under the per-graph DP5 gate (Standing Order #1).
