---
type: decision
adr_id: adr_003
title: "ADR-003 — Visibility-Driven Host Split (Codeberg-private / GitHub-public)"
status: proposed
created: 2026-06-19
updated: 2026-06-19
last_edited_by: agent_stanley
ratifies_at: "policy ratified at P0 charter gate; per-graph assignments ratified wave-by-wave at P6"
depends_on: [adr_000, adr_001, adr_002]
tags: [decision, adr, adr_003, git, visibility, codeberg, github, host_policy, proposed]
---

# ADR-003 — Visibility-Driven Host Split (Codeberg-private / GitHub-public)

**Status**: `proposed`. The **policy** is ratified at the P0 charter gate; **per-graph host assignments** are ratified wave-by-wave at P6 (a graph's move is never silent). Depends on [[adr_002_provider_abstraction]].

## Context

A new Codeberg org exists at `codeberg.org/aDNA-Network`. The mandate: **private/internal development on Codeberg**, **public graphs/releases on GitHub**. This ADR sets the **default binding** of the provider abstraction (ADR-002) — *which host a graph lands on, by default, given its visibility* — and the migration posture for the existing GitHub fleet. It generalizes the seed set's P/I/R repo classes (ADR-001 D2).

## Decisions (proposed)

### Decision 1 — The split (default host by visibility)

| Graph visibility | Default host | Org | Backend | Notes |
|---|---|---|---|---|
| **private / internal** | **Codeberg** | `aDNA-Network` | Forgejo | the new default for all non-public work (vaults, infra, client, experiments) |
| **public** | **GitHub** | `aDNA-Network` | GitHub | discovery, stars, external PRs, community — GitHub's network effect is the asset |

### Decision 2 — Generalized repo classes (P/I/R survive as shorthands)

| Class | Was (seed set) | Now | `origin` | `mirror` |
|---|---|---|---|---|
| **I — Internal** | self-hosted only | **Codeberg** (private) | Codeberg | — |
| **R — Release** | self-hosted, push-mirror→GitHub | **Codeberg origin → GitHub mirror on tags** | Codeberg | GitHub (public release face) |
| **P — Public-primary** | GitHub-native | **GitHub** (public) | GitHub | optional Codeberg pull-mirror |

**Decision tree** (unchanged in spirit): community discovers/contributes here today? → **P** (GitHub). Authored internally but published outward? → **R** (Codeberg origin, GitHub release mirror). Otherwise → **I** (Codeberg). When in doubt → **I** (promotion is one mirror config; demotion is history surgery).

### Decision 3 — Release mirroring (Class R)
Public releases of internal work ride a **Forgejo-native push-mirror** Codeberg→GitHub, triggered on tags/releases — so the *source of truth is private (Codeberg)* and the *public face (GitHub)* updates automatically. The seed set's `harbor` remote generalizes to the `mirror` remote (ADR-002).

### Decision 4 — Migration of the existing GitHub fleet (gated waves, P6)
Existing repos move to the split **in waves**, each operator-gated, **lowest-risk first**:
1. **Low-risk internal** vaults (no LFS, no client data, no live consumers).
2. **Daily-drivers** (active vaults).
3. **Code-as-WHAT repos** (the nested code trees — `lattice-protocol`, `contextscope`, `harness`, …; coordinate their separate `.git` remotes).
4. **Client / sensitive** (history-scan mandatory before any host move; e.g. CakeHealth, sws/*).
**Public graphs stay on GitHub** (already correct). **External upstreams** (`ggml-org/llama.cpp`, `Wilhelm-Foundation/rare-archive`) are **never moved** — their canonical home is external (ADR-001 out-of-scope rows).

### Decision 5 — Coordination with the GitHub-org migration program
`aDNALabs.aDNA` (Berthier) just completed moving ~23 repos **to** GitHub `aDNA-Network` (Operation Homecoming). This ADR's Codeberg split **must not collide** with that program — the split *re-homes private work off* the GitHub org Homecoming just populated. A coordination memo (staged this session) reconciles: GitHub `aDNA-Network` becomes the **public** face; Codeberg `aDNA-Network` the **private** home; the two programs partition cleanly by visibility. **Operator + Berthier confirm before any wave.**

### Decision 6 — Default for new graphs
New `<name>.aDNA/` graphs default to **Codeberg-private** at fork (via the updated `git/` declaration), promoted to GitHub-public only when explicitly made public. This replaces the seed set's "net-new freeze" with a positive default (ADR-001 D2).

## Consequences

- The fleet becomes **multi-host**: most vaults private on Codeberg, a curated public set on GitHub, a few Class-R with both.
- A **fleet git-state ledger** (P1) is the prerequisite — we cannot wave-migrate what we haven't inventoried (provider · visibility · class · LFS · consumers per graph).
- The **shim registry** (`Home.aDNA`, Standing Rule 9) tracks every remote re-point during migration (rollback path).
- Credential broker gains a **Codeberg/Forgejo token** (ADR-002, Home coord).
- Release-mirroring must be **verified per Class-R repo** (≤ propagation budget) before declaring it done.

## Open questions carried forward (→ P1/P6)

- The actual public-vs-private classification of each existing graph (→ P1 inventory; operator ratifies the table).
- Whether any currently-public GitHub graph should **also** carry a Codeberg dev mirror (resilience) — P6.
- Org/team topology on Codeberg to mirror GitHub's (→ P5 beachhead).
- Handling of code-as-WHAT nested repos whose `.git` remote differs from their parent graph's (→ P6 wave 3).

## Alternatives considered

- **Codeberg-primary for everything** (public + private on Codeberg; GitHub mirror-only) — rejected as default (loses GitHub's discovery for public graphs) but **available per-graph** (a graph may set Codeberg origin + GitHub mirror even when public).
- **Additive-only (no migration)** — rejected; leaves a permanently mixed fleet and never realizes "private dev on Codeberg" for existing work. Gated waves get there deliberately.
- **Visibility decided per-repo by hand, no default** — rejected; a default (private→Codeberg) is what makes new-graph creation and the fleet sweep tractable.
