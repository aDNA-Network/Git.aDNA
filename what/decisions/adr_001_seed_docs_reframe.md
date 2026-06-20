---
type: decision
adr_id: adr_001
title: "ADR-001 — Lighthouse Seed-Set Reframe (adopt-and-generalize)"
status: accepted
created: 2026-06-19
updated: 2026-06-19
last_edited_by: agent_stanley
ratifies_at: "genesis P0 charter gate (campaign_git_genesis / Operation Free Harbor)"
depends_on: [adr_000]
tags: [decision, adr, adr_001, git, seed_reframe, lighthouse, provider_agnostic, accepted]
---

# ADR-001 — Lighthouse Seed-Set Reframe (adopt-and-generalize)

**Status**: `accepted` (ratified at the P0 charter gate — operator APPROVE, 2026-06-19). Depends on [[adr_000_project_identity]].

## Context

Git.aDNA inherited a six-document seed set (the **Lighthouse.aDNA** set, authored 2026-06-11), preserved at:
- `what/doctrine/charter_lighthouse_seed.md` (00 — charter)
- `what/architecture/architecture_forge_seed.md` (01 — architecture)
- `what/requirements/requirements_forge_seed.md` (02 — 56 REQs × 14 domains)
- `what/doctrine/migration_doctrine_seed.md` (03 — repo classes P/I/R, FIRST LIGHT campaign)
- `what/architecture/_seed/vault_spec_seed.md` (04 — vault scaffold spec)
- `what/architecture/_seed/build_prompt_seed.md` (05 — construction mission)

The raw transport artifacts (the as-received zips) are preserved at `how/campaigns/campaign_git_genesis/_seed_intake/` (archive-never-delete).

The seed set is **production-grade** but commits to a thesis the 2026-06-19 mandate **reframes**: *"git.aDNA (self-hosted Forgejo) is canonical; GitHub is merely the harbor; net-new internal repos are frozen off GitHub at D+0."* The new mandate makes git-ops **provider-agnostic** with **user host-choice preserved forever**, **Codeberg the immediate private home**, and **self-hosted mesh-git the strategic north star** rather than the mandated canonical home (see [[adr_000_project_identity]] Decisions 5–7).

This ADR decides, **clause by clause, what is adopted, what is generalized, and what is superseded** — so no agent mistakes the seed docs for current binding doctrine.

## Key reconciliation (why this is cheap)

**Codeberg runs Forgejo.** The seed set bet the whole system on Forgejo; that bet still pays off — Codeberg is a *hosted* Forgejo we can use **now** (zero infra), and a lighthouse forge is the *same* Forgejo API self-hosted **later**. So the seed set's deep Forgejo work (org layout, Actions, package/OCI registry, LFS, ForgeFed, backup doctrine) is **directly reusable** as the **Forgejo-backend / self-hosted-profile** of the agnostic abstraction — not discarded.

## Decisions (proposed; operator ratifies at the gate)

### Decision 1 — Adopt-and-generalize, not supersede-wholesale
The seed docs are **retained as source material** with reframe banners (already prepended). P1 mines them; P2 authors the *binding* successor docs. Nothing is deleted.

### Decision 2 — Reframe table (clause-level dispositions)

| Seed-set claim | Disposition | Successor |
|---|---|---|
| "git.aDNA (self-hosted Forgejo) is **canonical**; GitHub is the harbor" | **GENERALIZED** → provider-agnostic; canonical home is **per-graph/per-node policy** (Codeberg-private / GitHub-public today) | ADR-002, ADR-003 |
| Repo classes **P / I / R** | **ADOPTED + generalized** → `(visibility × provider)` policy; P/I/R survive as shorthands | ADR-003 |
| "Net-new freeze: zero new internal repos on GitHub at D+0" | **SOFTENED** → new *private* repos default to **Codeberg**, not "frozen off GitHub"; freeze becomes a *policy default*, not an absolute | ADR-003 |
| Forgejo as forge engine | **ADOPTED** → the Forgejo backend (covers Codeberg + self-hosted) | ADR-002 |
| Forgejo Actions / `.forgejo/workflows/` CI | **ADOPTED** → CI/CD parity workstream | P2 CI-parity ADR |
| Mesh-only writes / Tailscale→Headscale; identity plane; collab (Zulip); inference gateway; object store (Garage) | **OUT OF SCOPE for Git.aDNA** → these are the "Lighthouse node stack" (mesh→`Network.aDNA`, node→`Home.aDNA`); only the **forge** piece stays here | `Network.aDNA`, `Home.aDNA`, future `Lighthouse.aDNA` |
| "Lighthouse.aDNA" as the deliverable vault | **REFRAMED** → the self-hosted-forge **profile / north star**; if built as a deployable, a **separate `Lighthouse.aDNA`** | ADR-000 D2/D7, P2 |
| `pharos` flagship at `git.adna.network` | **DEFERRED** → north-star spike (P7), not a genesis deliverable | P7 |
| Migration mechanics (rehome bash, push-mirror, history-scan, LFS full-fetch) | **ADOPTED** → reused for the Codeberg migration waves | P5/P6, skills |
| Backup doctrine (forgejo dump + restic + restore drill gates migration) | **ADOPTED** for the self-hosted profile; **N/A for hosted Codeberg/GitHub** (provider-managed) | P5/P7 |
| Doctrine block propagated verbatim into every sibling CLAUDE.md | **ADOPTED + rewritten** → the agnostic "git-ops doctrine block" | P3 |
| Agent machine-accounts + SSH-signed commits + `Agent:` trailer | **ADOPTED** → dev-process git doctrine | P2 |

### Decision 3 — The deployable "Lighthouse" is deferred and re-homed
No part of this genesis deploys a forge, identity plane, mesh, or backups. The seed set's deploy/runbook/infra content (04, 05, parts of 01/03) is **reference for a future `Lighthouse.aDNA`** (or a code-as-WHAT), decided at P2. Git.aDNA stays a Framework (ADR-000 D2).

### Decision 4 — Provenance is preserved
Seed docs keep their original `adna: Lighthouse.aDNA` frontmatter (shows origin) under the reframe banner; raw zips kept at `_seed_intake/`. The seed set is never edited for *content* — only bannered.

## Consequences

- P1 has a **ready-made source corpus** (no need to re-derive forge architecture or migration mechanics).
- P2's binding docs **supersede** the bannered seed docs (which then get a "superseded by …" note, retained per SO archive-never-delete).
- The out-of-scope rows create **coordination obligations** with `Network.aDNA` and `Home.aDNA` (memos staged this session).
- Anyone reading `what/doctrine/*_seed.md` sees the banner first and is routed to the agnostic ADRs.

## Open questions carried forward

- Which seed REQs (of 56) are **in-scope** for Git.aDNA vs. belong to the deferred Lighthouse deployable (→ P1 requirements triage).
- Whether to physically relocate 04/05 to a future `Lighthouse.aDNA` at its fork, or leave as reference here (→ P2).

## Alternatives considered

- **Supersede the seed set entirely** (archive all six, start fresh) — rejected; discards production-grade, directly-reusable forge + migration work. The Forgejo bet is *validated* by Codeberg, not invalidated.
- **Keep the seed thesis intact, layer agnosticism on top** — rejected; leaves contradictory canonical-host claims in `what/doctrine/`, confusing agents. A clause-level reframe is cleaner and honest.
