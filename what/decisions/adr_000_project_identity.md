---
type: decision
adr_id: adr_000
title: "ADR-000 — Git.aDNA Project Identity"
status: proposed
created: 2026-06-19
updated: 2026-06-19
last_edited_by: agent_stanley
ratifies_at: "genesis P0 charter gate (campaign_git_genesis / Operation Free Harbor)"
tags: [decision, adr, adr_000, git, identity, genesis, provider_agnostic, proposed]
---

# ADR-000 — Git.aDNA Project Identity

**Status**: `proposed` (authored at genesis P0, 2026-06-19; **ratified at the P0 charter gate**, operator sign-off). Until ratified, every decision below is a proposal the operator may amend, defer, or reject.

## Context

`Git.aDNA` was stood up (pre-P0) as the *"canonical git/git-ops/CI-CD context graph for every `.aDNA` code-home."* It sat as a seed-staging directory holding six spec docs (the **Lighthouse.aDNA** seed set, authored 2026-06-11) that describe a **self-hosted-Forgejo-first** system whose thesis is *"git.aDNA is canonical; GitHub is the harbor."* On 2026-06-19 the operator set a new mandate that **reframes** that thesis: git-ops must be **platform-agnostic** (GitHub, Codeberg, *or* self-hosted git, user's choice, forever), with **Codeberg as the immediate private/internal home** (`codeberg.org/aDNA-Network`) and **GitHub for public graphs/releases** — and with **mesh-operated self-hosted git as a strategic north star** (a genuine decentralized competitor to centralized git, never a forced destination).

This ADR fixes the identity the genesis campaign builds on. It was authored this session (genesis was performed in the same session per the approved plan, *plan-first/gated-execution*); it is ratified at the P0 charter gate that closes the session.

## Decisions (proposed; operator ratifies at the P0 charter gate)

### Decision 1 — Name & display
**Name**: `Git.aDNA` (PascalCase — the ADR-009 §4 workspace-tier operator-override; the fork skill's snake_case validation applies to the project base name, not the workspace `<Name>.aDNA` convention all siblings follow). **Display name**: "Git". Fork provenance: `who/coordination/coord_2026_06_19_fork_provenance.md`.

### Decision 2 — Category (REFRAME PROPOSED — operator decision)
**Framework.aDNA (primary), with a latent Platform dimension.** The router currently lists Git.aDNA as *"Platform.aDNA (provisional)."* This ADR **proposes a reframe to Framework.aDNA**, because what Git.aDNA produces today is an **operational standard other vaults federate against** — the provider-agnostic git-ops contract + repo-class/visibility doctrine + the agnostic skills (authored here, upstreamed into `.adna/` via `aDNA.aDNA`), consumed by every code-home via a `git/` wrapper + `federation_ref` block. That is the **III.aDNA pattern** exactly (a framework, not a deployed runtime). The **self-hosted mesh-git forge** (the north-star deployable) is a genuine *Platform* artifact — but it is **future/optional**, and if pursued it spins a **separate `Lighthouse.aDNA` Platform** (or a code-as-WHAT under Git.aDNA), keeping this graph a clean Framework. *Operator must confirm the reframe at the gate (it changes the router row); if rejected, Git.aDNA stays Platform.aDNA and the wrapper-consumer language below is re-cast.*

### Decision 3 — Persona (governance)
**Grace Hopper** (working-pin). Rear Admiral Grace Hopper is the patron of **machine-independence, portability, and open standards** — she fought for hardware-independent languages so a program could *run anywhere*, which is precisely Git.aDNA's thesis: a repo (and its ops) should run on *any* host the operator chooses. "Amazing Grace" also championed sharing and standardization — the federation instinct behind the mesh-git north star. Working-pin at genesis; **ratified at the gate with a fleet ruled-out check** (confirm Hopper is not already a fleet persona — initial scan: clear). Distinct from `Berthier` (the heavily-loaded interim placeholder, now released). **Alternative considered** (operator may prefer): a **harbor-keeper / Pharos / Sostratus of Cnidus** archetype — nautical, continuing the seed set's lighthouse/harbor metaphor and the "Operation Free Harbor" codename. Noted at Decision 8 + Alternatives.

### Decision 4 — Scope
Git.aDNA owns **git / forge / CI-CD only**:
- the **provider abstraction** (a git-ops provider contract over GitHub-API + Forgejo-API backends — ADR-002),
- the **repo-class / visibility / host policy** (generalizing the seed set's P/I/R — ADR-003),
- the **agnostic git-ops skills** (remote-setup · publish · provider-config · repo-migrate · release-mirror), authored here and **upstreamed into `.adna/` via `aDNA.aDNA`'s `skill_template_release`** (Standing Rule 1 — never edit `.adna/` directly),
- **CI/CD parity** (`.github/` ↔ `.forgejo/` Actions),
- the **dev-process git doctrine** (branch / commit / sign / PR conventions + multi-graph change coordination — the "tracking/operations/process for development" the operator called out),
- the **`git/` consumer-wrapper** pattern other graphs federate against,
- and the **self-hosted-forge north-star profile** (the mesh-git design + ForgeFed posture).

It does **not** own: the broader "Lighthouse node stack" from the seed docs — **identity/mesh** (→ `Network.aDNA`, Venus), node **inventory/health/credentials** (→ `Home.aDNA`, Hestia), **collab/inference** (out of scope); the `.adna` **standard itself** (→ `aDNA.aDNA`, Rosetta); or the **GitHub-org migration program** (→ `aDNALabs.aDNA`, Berthier — Git.aDNA supplies the *patterns*; aDNALabs runs the org-level *program*).

### Decision 5 — Integration model (LOAD-BEARING)
**PROVIDER-AGNOSTIC ABSTRACTION (permanent) + SELF-HOSTED MESH-GIT (north star) — both, not either.** Git-ops rides a **provider contract** (verbs: create-repo · set-remote · push · open-PR · cut-release · configure-mirror · port-CI) implemented over **two backends**: GitHub API (`gh`) and Forgejo API (`tea`/REST). Because **Codeberg runs Forgejo**, the Forgejo backend covers *both* hosted Codeberg *and* any future self-hosted lighthouse forge — so the agnostic layer is a **2-backend** problem, and the mesh-git north star is reachable through the *same* contract a subnet re-points to. **User choice of host is preserved forever**; no graph is ever locked to a provider. Detail + the contract sketch: [[adr_002_provider_abstraction]].

### Decision 6 — Default host policy (LOAD-BEARING)
**Visibility-driven split.** Private/internal graphs → **Codeberg** (`aDNA-Network`); public graphs → **GitHub** (`aDNA-Network`); public releases of internal work **mirror Codeberg→GitHub on tags** (the seed set's "Class R"); existing GitHub-private repos **migrate to Codeberg in gated waves**. This is the **default *binding* of the abstraction today**, not a property of it — a subnet may later re-point its private home to its own lighthouse forge without rewriting tooling or graphs. Detail: [[adr_003_visibility_split_policy]].

### Decision 7 — Relationship to the Lighthouse seed set
**Adopt-and-generalize, not supersede-wholesale.** The six seed docs are retained as source material (architecture · requirements · repo-class model · migration mechanics are all reused); only their *top-level canonical-host stance* is reframed to provider-agnostic. The deployable "Lighthouse" system becomes the **self-hosted-forge profile / future `Lighthouse.aDNA`**. Detail + supersession banners: [[adr_001_seed_docs_reframe]].

### Decision 8 — Campaign codename
**Operation Free Harbor** (working) — *free* (libre + freedom-of-host-choice) + *harbor* (the git host, continuing the seed set's metaphor). **Alternative**: *Operation Lodestar* (the mesh-git north star as the guiding star). Operator picks at the gate.

## Consequences

- The **router row** changes if Decision 2 is ratified: `Platform.aDNA (provisional)` → `Framework.aDNA` (with a note on the latent Platform/forge dimension). Staged, inserted at the gate.
- Git.aDNA becomes a **consumer-facing framework**: graphs adopt it via a `git/` wrapper + `federation_ref` (P3 defines the wrapper; the III `iii/` wrapper is the template).
- The agnostic skills are **authored here but shipped via `aDNA.aDNA`** — a hard coordination dependency (P4), because `.adna/` is do-not-modify (Standing Rule 1).
- "**Self-hosted is the north star, not the default**" means the seed set's net-new-freeze / GitHub-as-harbor absolutism is **relaxed**; doctrine becomes *per-graph/per-node host policy*.
- A **separate `Lighthouse.aDNA`** may be forked later for the forge deployable (P2/P7 decision); this graph stays Framework-clean.
- Persona Hopper sets the **voice**: portability-first, standards-minded, terse, host-neutral.

## Open questions carried forward (→ [[adr_001_seed_docs_reframe]] + P1/P2)

1. Exact Codeberg org/team topology vs. the GitHub layout (→ P1 inventory / P5 beachhead).
2. Whether the self-hosted forge is a **separate `Lighthouse.aDNA`** or a **code-as-WHAT** under Git.aDNA (→ P2 architecture).
3. Credential model for a second provider (Codeberg/Forgejo tokens) under the `Home.aDNA` broker (→ P2 + Home coord).
4. How the Codeberg split coordinates with `aDNALabs.aDNA`'s in-flight GitHub-org migration (Operation Homecoming) without collision (→ P1 coord memo).
5. CI/CD parity surface — how much `.github/` ↔ `.forgejo/` Actions divergence the fleet actually carries (→ P1 fleet inventory).

## Alternatives considered

- **Keep Platform.aDNA (router's provisional ruling)** — defensible (the forge deployable is Platform-shaped), but **rejected as primary** because today's product is a standard+skills+wrapper with no runtime; Framework is the honest current category, and the Platform dimension is cleanly carved off to a future `Lighthouse.aDNA`.
- **Self-hosted-first (keep the seed set's thesis)** — the operator's Q1 answer leaned toward the mesh-git ambition but **explicitly required preserving user host-choice**, which is the agnostic abstraction. Self-hosted-first is therefore framed as the *north star*, not the *architecture*.
- **Persona = harbor-keeper / Pharos** — strong thematic fit with the seed metaphor; held as the named alternative to Hopper, operator's call. Hopper wins the working-pin on the *portability* thesis (the headline mandate) over the *harbor* metaphor (the inherited flavor).
- **Defer persona to bare TBD** — rejected (Warp precedent: the vault's nature is fully known; a working-pin gives the gate a concrete thing to ratify).
- **Rename graph → `Lighthouse.aDNA`** — rejected; "lighthouse" is *one provider profile*, not the agnostic whole. The router name `Git.aDNA` is kept.
