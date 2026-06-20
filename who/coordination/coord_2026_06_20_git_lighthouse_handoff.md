---
type: coordination
created: 2026-06-20
updated: 2026-06-20
status: draft
last_edited_by: agent_stanley
to: "Lighthouse.aDNA (persona TBD-at-P0)"
deliver_at: "Lighthouse.aDNA's P0 genesis"
tags: [coordination, draft, git, lighthouse, standard_deployable_handoff, operation_free_harbor]
---

# Coord Draft → Lighthouse.aDNA: Standard ↔ Deployable Handoff

**Status**: DRAFT — staged at Git.aDNA's post-P3 re-elevation (2026-06-20), when `Lighthouse.aDNA` was forked as a genesis-planning stub. **Deliver/use at Lighthouse.aDNA's own P0.** Not a silent cross-vault write (Rule 10) — the stub already exists; this records the handoff contract.

## The split (triad)
- **Git.aDNA = the standard** (Framework): the provider contract ([[adr_004_provider_contract_interface|ADR-004]]), host policy ([[adr_005_visibility_host_policy|ADR-005]] + [[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]]), agnostic skills, the `git/` wrapper, doctrine, and the advisory layer ([[context_gitops_options]] + [[skill_gitops_advisor]]).
- **Lighthouse.aDNA = the deployable** (Platform): the integrated lighthouse node — Forgejo deployment + node-operator setup UX + context-sync + the node stack (identity/mesh/collab/inference/ops profiles).
- **Network.aDNA = the substrate**: mesh, node identity, the lighthouse role, context-distribution (drill-#7).

## What Git.aDNA hands to Lighthouse.aDNA
1. **The contract to consume** — Lighthouse.aDNA federates Git.aDNA via a `git/` wrapper; **never re-derives** the contract/policy/skills.
2. **The quarry** — the seed deploy/runbook/backup corpus (`Git.aDNA/what/architecture/architecture_forge_seed.md`, `_seed/`, `what/doctrine/charter_lighthouse_seed.md`, `migration_doctrine_seed.md`) is Lighthouse.aDNA's reference material for its deployable architecture.
3. **The constraints** — Network `ADR-016 §8` (forge on a data-plane node, not the lighthouse host); the lighthouse-operator default ([[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]] D1); the git-as-context-sync thesis (D2).
4. **The gate** — the deployable build depends on the **P7a integration ADR** (joint Git×Network) + the **P7b spike** go/no-go. Lighthouse.aDNA's P0 should sequence after / alongside P7a.

## What Lighthouse.aDNA owns (not Git.aDNA)
The runtime, the deploy mechanics, the node-operator UX, the context-sync integration, and the node stack. If Git.aDNA tooling needs a runtime behavior, it's specified in Git.aDNA (the standard) and *implemented* in Lighthouse.aDNA (the deployable).

## Boundary
Git.aDNA stays a clean Framework — no runtime. Cross-vault changes are staged coord memos (Rule 10). Decision Point 7 (disposition: separate `Lighthouse.aDNA`) + DP9 (the P7 spike authorization).
