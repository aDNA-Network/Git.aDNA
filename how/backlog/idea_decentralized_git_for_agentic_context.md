---
type: backlog
idea_id: idea_decentralized_git_for_agentic_context
title: "Decentralized git for agentic context (network product)"
status: idea
created: 2026-06-20
last_edited_by: agent_stanley
horizon: long
tags: [backlog, idea, git, decentralized, federation, network_product, lighthouse, north_star]
---

# Idea — Decentralized Git for Agentic Context (network product)

**Horizon: long (post-genesis).** The strategic end-state the operator named on 2026-06-20 ([[context_north_star_vision]], [[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]] D5).

## The thesis
aDNA vaults *are* git repos (agentic context graphs). If enough **lighthouse nodes** run their own Forgejo (the lighthouse-operator default) and some choose to **provide mesh/federated git to other nodes**, the network becomes a **decentralized git for agentic context** — a core feature/product/power of the aDNA network: agentic context, hosted and synced across a federation of operator-owned forges, with no central provider.

## Why it's reachable (and not a moonshot)
- **Incremental via mirror-mesh.** "Git data is self-replicating — every clone is a backup" (seed). Cross-subnet **push/pull mirroring** + REST already delivers decentralization **without** experimental ForgeFed (ADR-010 D3). ForgeFed becomes the richer federation layer (issues/PRs/identity) when production-ready.
- **The substrate exists.** Network.aDNA already prototypes git-over-mesh context exchange (`adna-exchange` drill-#7) + a context-distribution backlog.
- **The contract is host-neutral.** Any node points its `git/` at a peer/lighthouse forge with a one-field host swap.

## What it needs (when chartered)
- The **P7a integration ADR** + **P7b spike** proven (forge-as-context-sync over the mesh).
- The **`Lighthouse.aDNA` deployable** built (operator-ownable lighthouse forge).
- A **willing-provider / trust + consent model**: which nodes serve git to whom, under what membership/ACL/economics (coord Network.aDNA + aDNALabs governance).
- A **federation topology**: mirror-mesh now; ForgeFed when ready; conflict/divergence reconciliation (site-local issues, merge-on-recovery — seed §7).

## When to charter
Post-genesis. Likely a **joint Git.aDNA × Lighthouse.aDNA × Network.aDNA program** (possibly its own product vault). Triggered after the P7 go/no-go + the `Lighthouse.aDNA` deployable exists. Carry until then; don't pull into the Git.aDNA genesis (which stays the *standard*).
