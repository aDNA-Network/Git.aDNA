---
type: decision
adr_id: adr_013
title: "ADR-013 — Host-Role Inversion (GitHub-public-home / Codeberg-private-FOSS-dev; supersedes ADR-005 Path B; reverses SD-1)"
status: accepted
created: 2026-06-20
updated: 2026-06-20
last_edited_by: agent_stanley
ratifies_at: "authored + operator-ratified at R1/P5 (2026-06-20), mid-beachhead; per-graph assignments re-confirmed wave-by-wave at P6"
depends_on: [adr_000, adr_004, adr_005]
supersedes: adr_005
tags: [decision, adr, adr_013, git, visibility, codeberg, github, host_policy, inversion, foss_in_dev, binding, accepted, operation_free_harbor]
---

# ADR-013 — Host-Role Inversion (GitHub-public-home / Codeberg-private-FOSS-dev)

**Status**: `accepted` (authored + **operator-ratified at R1/P5**, 2026-06-20, mid-beachhead). **Supersedes [[adr_005_visibility_host_policy|ADR-005]]** (Path B) — reverses its public-home *direction* and **reverses SD-1**; **carries forward** ADR-005's proprietary/self-hosted posture, Operation-Homecoming coexistence, and the mesh-git north star. Depends on [[adr_004_provider_contract_interface|ADR-004]].

## Context

[[adr_005_visibility_host_policy|ADR-005]] (Path B, genesis P2) set **Codeberg as the public-FOSS *home*** (origin) with GitHub as a discovery mirror, and **GitHub-interim-private** for the ~95%-private fleet — itself a correction of [[adr_003_visibility_split_policy|ADR-003]] after the P1 finding that Codeberg's ToS forbids private *proprietary* repos.

At **R1/P5** (the first outward step) the operator stated the actual intent: **use Codeberg for private development; keep public repos on GitHub** — i.e. ADR-003's original *direction*. Surfaced against Codeberg's FOSS-only ToS, the operator chose the **ToS-compliant** form: Codeberg-private is scoped to **FOSS projects kept private *during development*** (opened/released to GitHub-public when ready), **never** to proprietary code.

This **re-inverts** the public-home direction (Codeberg → GitHub) and adds an explicit **FOSS-in-private-development** lane on Codeberg. The permanent architecture ([[adr_000_project_identity|ADR-000]] D5) is unchanged: provider-agnostic contract; self-hosted Forgejo = north-star private home; user host-choice preserved forever. Path B was *near-term sequencing*; this ADR corrects its direction to the operator's actual model.

## Decisions

### D1 — The host split, re-inverted (binding)

| Visibility / kind | Default **origin** | Eventual home | Public face | Why |
|---|---|---|---|---|
| **public / released FOSS** | **GitHub** (`aDNA-Network`, public) | GitHub | — (GitHub *is* the public home) | GitHub's network effect = discovery/stars/PRs for released work |
| **FOSS, in private development** | **Codeberg** (`aDNA-Network`, **private**) | opens → GitHub-public at release | GitHub on release | develop privately; Codeberg-private is ToS-OK **only** for FOSS-bound work |
| **private / proprietary / client** | **GitHub** (private, interim) | **self-hosted Forgejo** (post-P7) | — | Codeberg ToS forbids proprietary; **unchanged** from ADR-005 |
| **release of internal work** (Class R) | private origin | self-hosted | GitHub mirror on tags | **unchanged** from ADR-005 D3 |
| **local-only** (Class L) | none | none | — | Rule 4 / legal IP |

> 🚩 **Codeberg = FOSS-only.** Codeberg-private is permitted *only* for FOSS work that will be opened (pre-release development) — **never** for proprietary/closed code. This ToS line is exactly what separates row 2 from row 3.

### D2 — Repo classes (P/I/R/L retained; P gains a pre-release host state)
- **P — Public-primary** (FOSS): **released → GitHub-public** origin; **in private development → Codeberg-private** origin (pre-release; opens to GitHub at release). This pre-release Codeberg-private state **is** the "private dev on Codeberg" lane. *(Reverses ADR-005's Codeberg-origin-for-P.)*
- **I / I-strict — proprietary / client**: GitHub-private (interim) → self-hosted Forgejo. **Never Codeberg.** *(unchanged)*
- **R — Release**: private origin + public mirror on tags. *(unchanged)*
- **L — Local-only**: never push (Rule 4 / legal IP). *(unchanged)*

**Decision tree:** released & FOSS? → **P-released** (GitHub-public). FOSS but developed privately first? → **P-dev** (Codeberg-private, opens at release). Proprietary/client? → **I / I-strict** (GitHub-private → self-hosted; never Codeberg). Authored internally, published outward? → **R**. Never-push? → **L**.

### D3 — Git.aDNA itself → GitHub-public (reverses SD-1)
Git.aDNA is the open git-ops standard — public by nature, with no private-dev phase. Its public home is **GitHub** (`github.com/aDNA-Network/Git.aDNA`, public, class **P-released**). This **reverses SD-1** (ratified 2026-06-20, which had pinned Git.aDNA to Codeberg-public). `git/CLAUDE.md`'s `git_provider` is updated accordingly; `origin` is set at the P5 dogfood.

### D4 — Open/release flow (P-dev → public)
When a P-dev (Codeberg-private) graph is ready to open: either **(a)** migrate origin Codeberg→GitHub-public (repoint + Home shim, [[adr_006_remote_naming|ADR-006]]), or **(b)** configure a Codeberg→GitHub push-mirror and flip the GitHub repo public at release ([[adr_004_provider_contract_interface|ADR-004]] D5 mechanics). Direction is chosen per-graph at the open gate. *(This re-scopes ADR-005's "release-mirror" — P5 step F — to the open-flow; it is exercised when a P-dev graph first releases, not at the beachhead.)*

### D5 — Carried forward from ADR-005 (unchanged, still binding)
- **Proprietary/client posture**: GitHub-private (interim) → self-hosted Forgejo (post-P7); I-strict history-scan-gated ([[adr_011_secret_scanning|ADR-011]]); external upstreams never re-homed (ADR-005 D7).
- **Homecoming coexistence** (ADR-005 D6): GitHub `aDNA-Network` stays the public + private-interim home; `aDNALabs.aDNA` (Berthier) owns the org-level program; **operator + Berthier jointly gate each wave**.
- **Self-hosted mesh-git north star** ([[adr_010_mesh_git_north_star|ADR-010]] / [[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]]) + provider-agnostic contract (ADR-004).
- **Credential model** ([[adr_007_credential_model|ADR-007]]): `GITHUB_TOKEN` + `CODEBERG_TOKEN` now, `FORGEJO_TOKEN` later.

### D6 — New-graph defaults (`git/` fork-hook)
public/released → **GitHub-public** · FOSS-in-dev → **Codeberg-private** · proprietary → **GitHub-private/self-hosted**. Retires ADR-005 D5's "new FOSS → Codeberg-public" default.

### D7 — Classification re-confirmed at P6 (no silent flips)
[[fleet_git_state]] is re-mapped to the D1 table; the intended-public OSS set (`aDNA · III · Canvas · Astro · Videos · Molecules · Oration · TypeScript · …`) splits per-graph into **released → GitHub-public** vs **still-in-dev → Codeberg-private**, authorized wave-by-wave at gated P6.

## Consequences
- The **R1/P5 beachhead** now dogfoods **both backends in their real roles**: Git.aDNA → GitHub-public (D3); a FOSS-in-dev pilot (`TypeScript.aDNA`) → Codeberg-private (P-dev). Strongest possible proof of provider-agnosticism.
- The **provider-agnostic contract is unaffected** — only the default host *bindings* change; the 7 verbs run identically on GitHub-API and Forgejo-API.
- ADR-005's careful posture for proprietary/client repos is **preserved** — no proprietary repo ever lands on Codeberg.
- Release-mirror is deferred to the D4 open-flow (re-scopes P5 step F).

## Provenance
[[adr_003_visibility_split_policy|ADR-003]] (private→Codeberg, P0) → superseded by [[adr_005_visibility_host_policy|ADR-005]] (Path B: Codeberg-public-FOSS, P2, over the ToS finding) → superseded by **ADR-013** (re-inverts the public-home to GitHub; scopes Codeberg to FOSS-in-dev). The *direction* has returned to ADR-003's intent, now ToS-correct. **SD-1** (Git.aDNA→Codeberg-public) is **reversed** (D3).

## Alternatives considered (at the R1/P5 checkpoint)
- **Keep ADR-005 Path B** (Codeberg-public home) — rejected by the operator; it inverts their actual workflow (private dev on Codeberg, public on GitHub).
- **Codeberg for *all* private dev incl. proprietary** — rejected: violates Codeberg ToS (the P1 finding). Proprietary stays GitHub-private → self-hosted (D5).
- **Drop Codeberg entirely (GitHub-public + self-hosted-private)** — rejected for now: Codeberg-private is a valid, free ToS-compliant home for FOSS-in-dev and exercises the Forgejo backend ahead of the self-hosted lighthouse.
