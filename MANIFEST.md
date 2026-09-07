---
type: manifest
created: 2026-06-19
updated: 2026-09-07
last_edited_by: agent_stanley
tags: [manifest, governance, git, framework_adna, genesis, provider_agnostic, adr_011_a8_ratified, no_proposed_decisions, findings_enumerable]
---

# Git.aDNA — Project Manifest

## Project Identity

**Git.aDNA** — a **Framework.aDNA** context graph (proposed reframe from the router's provisional Platform.aDNA; [[what/decisions/adr_000_project_identity|ADR-000]] D2) that defines the **platform-agnostic git / forge / CI-CD standard** for every aDNA code-home. It owns the **provider abstraction** that lets a repo and its git-ops run on **any host the operator chooses — GitHub, Codeberg, or a self-hosted Forgejo lighthouse — with no lock-in, forever.**

**Thesis (load-bearing):** the provider-agnostic abstraction is the **permanent architecture** (host-choice preserved always); self-hosted **mesh-git is the strategic north star** — a genuine decentralized competitor to centralized git, reachable through the *same* abstraction a subnet re-points to. **Key reconciliation:** Codeberg runs Forgejo, so one Forgejo backend covers hosted Codeberg **and** any future self-hosted lighthouse — the abstraction is a **2-backend** problem (GitHub-API + Forgejo-API).

**Default host policy (Host-Role Inversion — [[what/decisions/adr_013_host_role_inversion|ADR-013]], supersedes ADR-005 Path B; reverses SD-1):** **public/released FOSS → GitHub** (the public home); **FOSS-in-private-development → Codeberg-private** (opened to GitHub at release — ToS-OK only for FOSS-bound work); **private/proprietary/client → GitHub-private (interim) → self-hosted Forgejo** (post-P7; **never Codeberg**). Codeberg stays **FOSS-only** (ToS — a P1 finding). Classification re-mapped + flips gated per-wave at P6. *(Revives ADR-003's direction, ToS-scoped.)*

Persona: **Grace Hopper** (the portability / open-standards archetype — code that runs anywhere; working-pin, ratified at genesis P0). Distinct from the prior `Berthier`-interim placeholder.

It is the sibling of the other infrastructure Frameworks/Platforms: `aDNA.aDNA` (Rosetta) ships our skills into `.adna/`; `aDNALabs.aDNA` (Berthier) runs the GitHub-org migration *program*; `Network.aDNA` (Venus) is the mesh substrate for the north star; `Home.aDNA` (Hestia) brokers multi-provider credentials. Git.aDNA owns **git/forge/CI-CD only** — not node identity/mesh, not credentials, not the standard itself.

## Status

> **⛩ Current (2026-09-07 — 31st sitting + winddown): Genesis P0–P6 ✅ (P6 reachable-complete) → R3/P7 — the mesh era.** The **P7b spike instance is LIVE** (Forgejo 15.0.6 LTS on the aDNA-Labs R&D Node — the Ubuntu box — mesh-only, portable-CI green on runner `rd-node`, `mesh-rd` remotes per ADR-014; LAVG = the **first ADR-013 class-I graduation**, 2026-08-09). **P7a (integration architecture: TLS/addressing · identity bridge · context-sync · joint ADR with Venus) is the prioritized next block, weeks-out.** Residual P6 rows (`zeta` · `WilhelmAI` · `moleculeforge` · Wave 5) live as **standing waves** in the disposition ledger, fired opportunistically at per-wave DP5 gates.
>
> ⚠ **This block read *"Four amendments `proposed` pending operator ratification (ADR-014 A2/A3 · ADR-011 A2 · ADR-009 A1)"* until 2026-09-07 — all four had been ratified weeks earlier.** ⛔ **There are now NO `proposed` decisions in this vault**; **ADR-011 A8** was the last, ratified 2026-09-07 (population · total verdict set · installation is part of the control · **a coverage claim states its population** · **a control must be runnable in the context it is required to run in** · reflexive). ⛩ *A status line that outlived its facts, in the manifest — the same class the sitting that corrected it spent the day filing against gates.*
>
> **Live instrument state (take numbers from the harness, never from this file — F-P7b-be):** `pre-push-sanitize.sh` at **4.3.0**, live as gate 2 of the chained dispatcher; `.adna/` at **4.0.1**, three versions behind, and the template fix is Rosetta's. Findings are **enumerable** since the 2026-09-07 winddown — `bash how/tests/census_findings.sh --meta && bash how/tests/census_findings.sh` is authoritative over any list, including this one.
>
> The paragraph below is the as-was P5/P6-era record. **STATE.md carries the live pointer.**

**Genesis P0–P5 ✅ → R2/P6 (Operation Free Harbor)** — **R1/P5 beachhead executed 2026-06-20** (first outward) under an operator **host-role inversion** ([[what/decisions/adr_013_host_role_inversion|ADR-013]], supersedes ADR-005, reverses SD-1): **Git.aDNA → GitHub-public** (predecessor `v0.1.x` archived → `Git.aDNA-legacy`), **TypeScript.aDNA → Codeberg-private** (the FOSS-in-dev pilot); both backends dogfooded live; rollback drill PASS. **Resume-Here = R2/P6 — Fleet Alignment** (waved). **R2/P6 Wave 1 is now GATE-READY 2026-06-21 (non-outward):** the **released-vs-dev call is RESOLVED** (conservative — `aDNA`·`III`·`Canvas`·`Astro`→GitHub-public/W2; all else FOSS-intended→Codeberg-private/W1); the **disposition ledger is reconciled to ground truth** (`what/inventory/disposition_ledger.md` — 5 mis-classifications corrected; wave semantics explicit); the **doctrine block + spec are reconciled to ADR-013**; **6 Wave-1 secret-scans pre-cleared**; **per-graph artifacts staged** (`wave1_staging/wave1_runbook.md` + Berthier coord). **Wave 1a ✅ FIRED 2026-06-21** (`VisualDNA` + `Lighthouse` → Codeberg-private greenfield first-remotes). **Wave 1b CANARY (`Videos`) ✅ FIRED 2026-06-21** — the campaign's first **host-move** (GitHub-private → `codeberg.org/aDNA-Network/Videos.aDNA` private; old origin → `rollback` 30d); folded + live-validated the 2 Wave-1a findings (**F1** Forgejo default-branch auto-PATCH + **F2** hook/CI config-path; dry-run **24/24**); Berthier coord delivered; Spacemacs FOSS-confirmed. **Wave 1b ✅ COMPLETE 2026-06-22** (`Videos`·`Oration`·`Spacemacs`·`Molecules` → Codeberg-private). **Wave 2 (public-flips) ✅ COMPLETE 2026-06-22** — `aDNA.aDNA` (canary) · `III.aDNA` · `Canvas.aDNA` → GitHub-public via the authored `gitops_set_visibility` verb (proven across 3 graphs; anon-clone succeeds; dry-run 31/31); **`Astro.aDNA` resolved by reclassification** — operator BSL-1.1 = keep private ⇒ **W2→W3 (class I)**; GitHub-native cross-org transfer+rename → `aDNA-Network/Astro.aDNA` (stays private, no public flip; HEAD `0d0c315`; anon-clone refused; native-transfer §C shim). **→ Wave 2 COMPLETE; next = Wave 3 (internal touch-only).** Remaining fast-follows: Rosetta `.adna/` release (validated; now **8** folded fixes); Hestia registers the **5** §C shims (4 Wave-1b + Astro) + `C58`. This vault was genesis'd from `.adna/` on 2026-06-19 and **direct-authored**; the 2026-06-11 *Lighthouse.aDNA* seed set was folded into `what/` with reframe banners. See `STATE.md` for the live phase pointer.

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
