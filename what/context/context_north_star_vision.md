---
type: context
context_id: context_north_star_vision
title: "North-Star & End-State Vision — Git.aDNA as the road to decentralized git for agentic context"
status: active
created: 2026-06-20
last_edited_by: agent_stanley
tags: [context, git, north_star, vision, lighthouse, context_sync, decentralized_git, federation]
---

# North-Star & End-State Vision

Captured 2026-06-20 (post-P3 strategic review). This is the **load-bearing vision** the campaign now serves; it elevates and sharpens ADR-000 D5's "self-hosted mesh-git = strategic north star." Authoritative decisions are in the ADRs ([[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]] binds the new ones); this doc is the *why* and the map.

## The reconciliation (no contradiction)
**Agnostic mechanism + opinionated default.** The provider-agnostic contract (host-choice forever — ADR-004) is the *permanent architecture*. On top of it sits an **opinionated default for one persona**: the operator who runs their own L1 lighthouse subnet. For them, the default is **their own Forgejo as the subnet's core git**. Everyone else stays agnostic/hosted (GitHub public · Codeberg FOSS). Mechanism never changes; the *default* is persona-scoped.

## Four threads

**A — Git.aDNA as an options/advisory layer.** On install, an agent should carry context on *all* git-ops options + patterns (GitHub · Codeberg · self-hosted Forgejo · lighthouse) and help a user **choose · interoperate · refactor** their context to integrate git with aDNA's agentic patterns. → `context_gitops_options.md` + an advisory skill (WS-4).

**B — Lighthouse-operator default.** When a user stands up their own L1 lighthouse subnet, running their own Forgejo as core git is the **default/de-facto**. → ADR-012 (extends ADR-005 D5); applied at fork-time by the `git/` fork-hook.

**C — Git-as-context-sync fabric (the deep insight).** **aDNA vaults *are* git repos** → the subnet's forge is literally the mesh's **context-management/sync substrate**, integrated with the lighthouse's other agentic roles (coordination, sync, context-management). Pushing/pulling/mirroring vaults across the mesh *is* context propagation. → ADR-012 thesis; the integration-architecture mission (WS-5).

**D — Decentralized git for agentic context (the product).** If enough lighthouse nodes run Forgejo and some choose to **provide mesh/federated git to others**, the network becomes a **decentralized git for agentic context** — a core feature/product/power of the aDNA network. Reachable **incrementally via mirror-mesh** ("git data is self-replicating — every clone is a backup", per the seed); **does not depend on experimental ForgeFed** (which matures into the federation layer later). → named strategic objective; `idea_decentralized_git_for_agentic_context` backlog (WS-7).

## The triad (who owns what)
| Vault | Role | Owns |
|---|---|---|
| **Git.aDNA** (Hopper) | the **standard** (Framework) | provider contract · host policy · agnostic skills · `git/` wrapper · doctrine · the advisory layer |
| **Lighthouse.aDNA** (TBD-at-P0) | the **deployable** (Platform) | the integrated lighthouse node (forge + node-operator UX + context-sync + node stack); the seed deploy/runbook corpus is its quarry |
| **Network.aDNA** (Venus) | the **substrate** | mesh (Nebula/Tailscale) · node identity (DIDs/federation keys) · the lighthouse role · context-distribution (drill #7) |

## Findings that shaped this (2026-06-20 review)
1. **🚨 ADR-016 §8 (Network) forbids a data-bearing forge on the lighthouse host** (control-plane, non-data-bearing). The subnet forge runs on a **data-plane node the lighthouse coordinates** (or Venus blesses a "forge hub" class). → ADR-012 corrects [[adr_010_mesh_git_north_star|ADR-010]] D1/D4.
2. **Network already prototypes git-over-mesh context exchange** — `adna-exchange` (bare repo via git-shell over mesh tcp/22, "drill #7") + a Phase-5.5 `idea_context_distribution_testnet`. Thread C is *partly live*; P7 builds **on** it.
3. **This vision ≈ the seed's original integrated Lighthouse node-stack** (forge + identity/mesh/collab/inference/ops; `pharos` flagship; flagship-canonical + site-local-pull-mirror replication) that ADR-001 deliberately scoped out to keep Git.aDNA a Framework. Re-elevated — now correctly homed in `Lighthouse.aDNA`, not folded back into Git.aDNA.

## Incremental path (capture + design now; build later)
1. **Now**: capture the vision (this doc + charter + ADR-012); advisory artifacts; fork the `Lighthouse.aDNA` stub; design the integration seam (joint Git×Network research mission); coordinate with Venus.
2. **P4–P6**: agnostic standard upstreamed (`.adna/`); Codeberg beachhead; fleet alignment (unchanged near-term — hosted).
3. **P7 (expanded)**: integrated lighthouse forge + context-sync proof on Network's drill-#7 substrate; federation-product spike; go/no-go → Lighthouse.aDNA deployable build.
4. **Later**: multi-lighthouse mirror-mesh → willing-provider federation → decentralized git for agentic context (the product). ForgeFed adopted when production-ready.

## Guardrails
Git.aDNA stays a **clean Framework** — no runtime, no deploy. The deployable lives in `Lighthouse.aDNA`. The forge↔mesh seam is **coordinated with Network.aDNA**, never absorbed. No outward actions / no infra until the relevant gated phase.
