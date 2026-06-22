---
type: manifest
created: 2026-06-19
updated: 2026-06-21
last_edited_by: agent_stanley
tags: [manifest, governance, git, framework_adna, genesis, provider_agnostic]
---

# Git.aDNA — Project Manifest

## Project Identity

**Git.aDNA** — a **Framework.aDNA** context graph (proposed reframe from the router's provisional Platform.aDNA; [[what/decisions/adr_000_project_identity|ADR-000]] D2) that defines the **platform-agnostic git / forge / CI-CD standard** for every aDNA code-home. It owns the **provider abstraction** that lets a repo and its git-ops run on **any host the operator chooses — GitHub, Codeberg, or a self-hosted Forgejo lighthouse — with no lock-in, forever.**

**Thesis (load-bearing):** the provider-agnostic abstraction is the **permanent architecture** (host-choice preserved always); self-hosted **mesh-git is the strategic north star** — a genuine decentralized competitor to centralized git, reachable through the *same* abstraction a subnet re-points to. **Key reconciliation:** Codeberg runs Forgejo, so one Forgejo backend covers hosted Codeberg **and** any future self-hosted lighthouse — the abstraction is a **2-backend** problem (GitHub-API + Forgejo-API).

**Default host policy (Host-Role Inversion — [[what/decisions/adr_013_host_role_inversion|ADR-013]], supersedes ADR-005 Path B; reverses SD-1):** **public/released FOSS → GitHub** (the public home); **FOSS-in-private-development → Codeberg-private** (opened to GitHub at release — ToS-OK only for FOSS-bound work); **private/proprietary/client → GitHub-private (interim) → self-hosted Forgejo** (post-P7; **never Codeberg**). Codeberg stays **FOSS-only** (ToS — a P1 finding). Classification re-mapped + flips gated per-wave at P6. *(Revives ADR-003's direction, ToS-scoped.)*

Persona: **Grace Hopper** (the portability / open-standards archetype — code that runs anywhere; working-pin, ratified at genesis P0). Distinct from the prior `Berthier`-interim placeholder.

It is the sibling of the other infrastructure Frameworks/Platforms: `aDNA.aDNA` (Rosetta) ships our skills into `.adna/`; `aDNALabs.aDNA` (Berthier) runs the GitHub-org migration *program*; `Network.aDNA` (Venus) is the mesh substrate for the north star; `Home.aDNA` (Hestia) brokers multi-provider credentials. Git.aDNA owns **git/forge/CI-CD only** — not node identity/mesh, not credentials, not the standard itself.

## Status

**Genesis P0–P5 ✅ → R2/P6 (Operation Free Harbor)** — **R1/P5 beachhead executed 2026-06-20** (first outward) under an operator **host-role inversion** ([[what/decisions/adr_013_host_role_inversion|ADR-013]], supersedes ADR-005, reverses SD-1): **Git.aDNA → GitHub-public** (predecessor `v0.1.x` archived → `Git.aDNA-legacy`), **TypeScript.aDNA → Codeberg-private** (the FOSS-in-dev pilot); both backends dogfooded live; rollback drill PASS. **Resume-Here = R2/P6 — Fleet Alignment** (waved). **R2/P6 Wave 1 is now GATE-READY 2026-06-21 (non-outward):** the **released-vs-dev call is RESOLVED** (conservative — `aDNA`·`III`·`Canvas`·`Astro`→GitHub-public/W2; all else FOSS-intended→Codeberg-private/W1); the **disposition ledger is reconciled to ground truth** (`what/inventory/disposition_ledger.md` — 5 mis-classifications corrected; wave semantics explicit); the **doctrine block + spec are reconciled to ADR-013**; **6 Wave-1 secret-scans pre-cleared**; **per-graph artifacts staged** (`wave1_staging/wave1_runbook.md` + Berthier coord). **Wave 1a ✅ FIRED 2026-06-21** (`VisualDNA` + `Lighthouse` → Codeberg-private greenfield first-remotes). **Wave 1b CANARY (`Videos`) ✅ FIRED 2026-06-21** — the campaign's first **host-move** (GitHub-private → `codeberg.org/aDNA-Network/Videos.aDNA` private; old origin → `rollback` 30d); folded + live-validated the 2 Wave-1a findings (**F1** Forgejo default-branch auto-PATCH + **F2** hook/CI config-path; dry-run **24/24**); Berthier coord delivered; Spacemacs FOSS-confirmed. **Next = operator authorizes the held Wave 1b set** (`Molecules`/`Oration`/`Spacemacs`; quick confirm); Wave 2 public-flips separate. Remaining fast-follows: Rosetta `.adna/` release (validated; now 7 folded fixes); Hestia registers the Videos §C shim + `C58`. This vault was genesis'd from `.adna/` on 2026-06-19 and **direct-authored**; the 2026-06-11 *Lighthouse.aDNA* seed set was folded into `what/` with reframe banners. See `STATE.md` for the live phase pointer.

The genesis-planning campaign `campaign_git_genesis` ("Operation Free Harbor") will, phase-gated: (P1) inventory the fleet's git state + research provider tooling, (P2) architect the provider abstraction + binding ADRs, (P3) spec the agnostic skills + `git/` wrapper, (P4) coordinate skill-upstreaming + charter the execution campaign, (P5) stand up the Codeberg beachhead, (P6) align the whole fleet in waves, (P7) spike the self-hosted mesh-git north star.

See `STATE.md` for the live phase pointer and Resume-Here.

## Architecture

Standard aDNA triad (inherited from `.adna/`), with the genesis campaign + framing ADRs + folded seed set seeded at fork:

```
Git.aDNA/
├── CLAUDE.md     # Grace Hopper identity + Standing Orders + genesis pointer (authoritative agent context)
├── MANIFEST.md   # This file
├── STATE.md      # Operational state — phase ladder, Resume-Here, live git landscape, intake log
├── what/         # WHAT — knowledge
│   ├── decisions/      # adr_000 identity · adr_001 seed-reframe (accepted) · adr_002/003 → superseded by adr_004/005 · adr_004–011 P2 binding ADRs (accepted)
│   ├── doctrine/       # charter_lighthouse_seed.md + migration_doctrine_seed.md (bannered seed; P2 authors binding successors)
│   ├── architecture/   # architecture_forge_seed.md (bannered) + _seed/ (vault_spec + build_prompt, reference)
│   └── requirements/   # requirements_forge_seed.md (56 REQs × 14 domains, bannered; P1 triages in-scope)
├── how/          # HOW — operations
│   └── campaigns/campaign_git_genesis/   # Operation Free Harbor charter + P0 mission + P1–P8 stubs
│       ├── missions/             # mission_p0_meta_planning + p1..p8 stubs
│       ├── coordination_drafts/  # aDNA.aDNA · aDNALabs.aDNA · Network.aDNA · Home.aDNA memos (staged)
│       └── _seed_intake/         # raw transport zips (provenance; archive-never-delete)
└── who/          # WHO — governance + coordination
    └── coordination/   # fork-provenance memo + staged router-row text
```

| Layer | Question | Contains (Git.aDNA-specific) |
|-------|----------|------------------------------|
| **what/** | What does this vault know? | The provider abstraction, repo-class/visibility policy, the bannered Lighthouse seed set (architecture · 56 REQs · migration mechanics), the framing ADRs |
| **how/** | How does it operate? | The genesis campaign (Operation Free Harbor) + its P0–P8 missions; later the execution campaign + the agnostic skill drafts + the `git/` wrapper |
| **who/** | Who is involved? | Grace Hopper (governance); coordination with Rosetta/aDNA.aDNA, Berthier/aDNALabs.aDNA, Venus/Network.aDNA, Hestia/Home.aDNA |

## Key Carried-In Artifacts (placed at genesis)

| Artifact | Purpose |
|----------|---------|
| `how/campaigns/campaign_git_genesis/campaign_git_genesis.md` | Operation Free Harbor charter (P0–P8 phase map; risk register; verification) |
| `how/campaigns/campaign_git_genesis/missions/mission_p0_meta_planning.md` | Detailed P0 mission (this session; Resume-Here = its charter gate) |
| `how/campaigns/campaign_git_genesis/missions/p1_*..p8_*.md` | P1–P8 mission stubs (the "multiple sessions") |
| `what/decisions/adr_000..003_*.md` | The four framing ADRs (`proposed`; ratified at the P0 gate) |
| `what/{doctrine,architecture,requirements}/*_seed.md` | The folded + bannered Lighthouse seed set (source material) |
| `who/coordination/coord_2026_06_19_fork_provenance.md` | Fork audit trail + staged router-row text (incl. the Platform→Framework reframe) |
| `how/campaigns/campaign_git_genesis/coordination_drafts/*.md` | 4 staged cross-vault coord memos |

## Entry Points

| Audience | Start Here | Then |
|----------|-----------|------|
| **Agents** | `CLAUDE.md` (auto-loaded) | `STATE.md` → the P0 mission card → the charter gate |
| **Humans** | `MANIFEST.md` (this file) | `STATE.md` → the genesis charter → the 4 ADRs |

Inherited aDNA infrastructure (context library, templates, skills, lattice tools) is present from the `.adna/` fork and available immediately.
