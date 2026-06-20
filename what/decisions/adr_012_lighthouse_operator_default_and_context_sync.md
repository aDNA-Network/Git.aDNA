---
type: decision
adr_id: adr_012
title: "ADR-012 — Lighthouse-Operator Default + Git-as-Context-Sync (north-star re-elevation)"
status: proposed
created: 2026-06-20
updated: 2026-06-20
last_edited_by: agent_stanley
ratifies_at: "authored at the post-P3 strategic review (2026-06-20); ratified at the next operator gate"
depends_on: [adr_005, adr_010]
amends: [adr_010]
tags: [decision, adr, adr_012, git, lighthouse, context_sync, decentralized_git, federation, north_star, proposed]
---

# ADR-012 — Lighthouse-Operator Default + Git-as-Context-Sync

**Status**: `proposed` (post-P3 strategic review, 2026-06-20; ratified at the next operator gate). **Amends [[adr_010_mesh_git_north_star|ADR-010]]** (D1/D4 forge-placement; D5 timing) and **extends [[adr_005_visibility_host_policy|ADR-005]]** (D5 defaults). Captures the operator's elevated end-state vision ([[context_north_star_vision]]). Depends on [[adr_005_visibility_host_policy|ADR-005]], [[adr_010_mesh_git_north_star|ADR-010]].

## Context
After P0–P3 the operator sharpened the end-state: Git.aDNA should (a) carry advisory context on *all* git-ops options and help users choose/interoperate/refactor; (b) make **self-hosted Forgejo the default for L1-lighthouse-subnet operators**, integrated with the lighthouse's agentic roles; and (c) treat a **federation of lighthouse-Forgejo nodes as a decentralized git for agentic context** — a network product. The post-P3 review also surfaced two findings: Network's `ADR-016 §8` forbids a data-bearing forge on the lighthouse host, and Network already prototypes git-over-mesh context exchange (`adna-exchange`, "drill #7"). This ADR binds the resulting decisions while **keeping Git.aDNA a clean Framework** — the deployable lives in the new `Lighthouse.aDNA`.

## Decisions

### D1 — Lighthouse-operator default (extends ADR-005 D5)
The provider-agnostic mechanism + host-choice-forever ([[adr_004_provider_contract_interface|ADR-004]]) is unchanged. **Added: an opinionated default for one persona** — a node that stands up its own **L1 lighthouse subnet** defaults to **its own Forgejo as the subnet's core git** (+ context-sync, D2). Non-lighthouse users keep the ADR-005 default (Codeberg-FOSS / GitHub-interim-private). The `git/` fork-hook ([[skill_git_provider_config]]) detects "this node operates a lighthouse subnet → default `host: git.<subnet>.adna.network`, `backend: forgejo`". *Default, not lock-in:* any operator may choose hosted instead.

### D2 — Git-as-context-sync fabric (thesis, binding)
**aDNA vaults *are* git repos**, so a subnet's forge is not "code hosting on the side" — it is the mesh's **context-management/sync substrate**: propagating vaults across the subnet *is* git (clone/pull/push/mirror). The lighthouse-subnet Forgejo is therefore **integrated with the lighthouse's other agentic/sync/context-management roles**, building on Network.aDNA's existing `adna-exchange` git-over-mesh prototype ("drill #7") + its context-distribution backlog — **we build on it, not parallel to it.** The integration design (the seam between the forge, Network's mesh/identity, and context-sync) is the **Integration-Architecture mission** (joint Git × Network); it produces an integration ADR before P7.

### D3 — Forge placement correction (amends ADR-010 D1/D4 — `ADR-016 §8`)
[[adr_010_mesh_git_north_star|ADR-010]] D1 said "Forgejo runs **on** a Nebula lighthouse node." That **violates Network `ADR-016 §8`** ("data-bearing hosts take no overlay inbound"; the lighthouse is control-plane / non-data-bearing). **Corrected:** the subnet forge runs on a **data-plane node the lighthouse *coordinates*** (the lighthouse provides discovery/relay/DNS; the forge is a separate data-bearing host), **or** Network amends §8 to bless a "forge hub" service class. The choice is the Integration-Architecture mission's, **co-decided with Venus**. ADR-010 D1/D4 are amended accordingly; the rest of ADR-010 (on-ramp via one-field host swap, ForgeFed realism, federation end-state) stands.

### D4 — `Lighthouse.aDNA` is the deployable home; fork the stub NOW (amends ADR-010 D5 timing)
[[adr_010_mesh_git_north_star|ADR-010]] D5 resolved that a deployable forge spins a **separate `Lighthouse.aDNA` Platform** — disposition unchanged. **Timing amended:** the `Lighthouse.aDNA` **planning vault is forked now** (genesis stub, 2026-06-20) so the integrated-lighthouse + node-operator-UX vision has a home to capture/design — **the deployable *build* still gates on the Integration-Architecture mission + the P7 spike go/no-go.** This keeps Git.aDNA a clean Framework (standard/skills/wrapper, no runtime) while the runtime/deployable design proceeds in its own vault. Triad: **Git.aDNA** (standard) · **Lighthouse.aDNA** (deployable) · **Network.aDNA** (substrate).

### D5 — Decentralized git for agentic context (named strategic objective)
The end-state is elevated from "north-star spike" to a **named strategic objective**: a federation of **willing** lighthouse-Forgejo nodes providing mesh/federated git to others → a **decentralized git for agentic context**, a core power/product of the network. **Reachable incrementally** — "git data is self-replicating; every clone is a backup" (seed) + cross-subnet **mirror-mesh** deliver decentralization **without** experimental ForgeFed; ForgeFed is adopted as the federation layer when production-ready ([[adr_010_mesh_git_north_star|ADR-010]] D3). Carried as `idea_decentralized_git_for_agentic_context` (backlog) + the expanded P7; the product itself is built post-genesis (likely a joint Git/Lighthouse/Network program).

## Consequences
- Git.aDNA gains an **advisory layer** ([[context_gitops_options]] + an advisory skill) and a **lighthouse-operator default** in the policy + fork-hook — without becoming a runtime.
- The campaign gains an **Integration-Architecture mission** (joint Venus) + an **expanded P7**; `Lighthouse.aDNA` exists as the deployable home.
- A real cross-vault constraint (`ADR-016 §8`) is now respected; coordination with Venus deepens (expanded coord memo).
- ADR-010 D1/D4/D5 carry amendment pointers to this ADR.

## Open questions (→ Integration-Architecture mission / Venus)
- Forge on a dedicated data-plane node vs. a Network-blessed "forge hub" class on/beside the lighthouse.
- The Forgejo-user ↔ Network-DID identity bridge (Network owns node identity, not user auth).
- `git.<subnet>.adna.network` DNS + mesh-internal TLS.
- How vault-sync-via-git relates to Network's tarball-transmission ceremony (converge or coexist).

## Alternatives considered
- **Keep ADR-010 as written** (forge on the lighthouse host) — rejected: violates Network §8.
- **Fold the deployable into Git.aDNA** (code-as-WHAT) — rejected: makes Git.aDNA a runtime Platform (ADR-010 D5).
- **Defer the Lighthouse.aDNA fork to post-P7** (the prior ADR-010 D5 timing) — superseded by the operator's "pull in the context graph now" decision; design needs a home now, build stays gated.
- **Universal self-hosted default** — rejected: too heavy for non-infra users; the default is persona-scoped (lighthouse operators).
