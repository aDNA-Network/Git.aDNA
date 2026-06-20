---
type: coordination
created: 2026-06-19
updated: 2026-06-20
status: draft
last_edited_by: agent_stanley
to: "Network.aDNA (Venus)"
deliver_at: "P7 (Mesh-Git North-Star Spike)"
tags: [coordination, draft, git, network, mesh_git, forgejo, forgefed, operation_free_harbor]
---

# Coord Draft → Network.aDNA (Venus): Lighthouse-Run Forgejo (Mesh-Git Spike)

**Status**: DRAFT — staged at genesis P0; **deliver at P7**. Not yet sent.

## The ask
A `Network.aDNA` **Nebula lighthouse node** to host a **Forgejo** instance serving git for its subnet over the mesh — the first concrete proof of the **mesh-git north star** (self-hosted aDNA git as a decentralized competitor to centralized git).

## Why this fits the mesh
- "Lighthouse" is already a Nebula node role (relay + authority). A lighthouse running a forge = git-ops for its subnet, mesh-only writes.
- Git.aDNA's provider abstraction already targets a `git.<subnet>.adna.network` Forgejo host as the **self-hosted profile** — a host-swap is one field in a graph's `git/` declaration ([[adr_002_provider_abstraction]]).
- **ForgeFed** (Forgejo-native federation) is the substrate for forge-to-forge federation across subnets.

## What we need from Venus
1. A Nebula node willing to host the spike + the mesh ACLs (mesh-only forge writes; read plane TBD).
2. Guidance on the Tailscale/Nebula addressing for `git.<subnet>...` DNS over the mesh.
3. Alignment on where the **forge** boundary sits vs `Network.aDNA`'s identity/mesh ownership — Git.aDNA owns the *forge*; Network owns the *mesh + identity*. We coordinate, we don't absorb.

## Scope guard
P7 is a **spike**, not production. A real deployable spins a separate `Lighthouse.aDNA` (Decision Point 7). The seed set's compose/runbook content (bannered, `_seed/`) is the reference. Decision Point 6.

---

## 2026-06-20 re-elevation update (post-P3 strategic review)

The operator elevated the vision — self-hosted Forgejo as the **lighthouse-operator default** + **git-as-context-sync fabric** + **decentralized git for agentic context** ([[context_north_star_vision]], [[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]]). Two findings reshape this ask — and it's **less greenfield than we thought**:

1. **🚨 Your `ADR-016 §8` forbids a data-bearing forge on the lighthouse host.** Corrected ask: the subnet forge runs on a **data-plane node the lighthouse coordinates** (lighthouse = discovery/relay/DNS; forge = a separate data-bearing host), **or** you bless a "forge hub" service class. **Your call, co-decided** — the crux of the new **P7a Integration-Architecture mission (joint)**.
2. **Build on your `adna-exchange` "drill #7"** (git-over-mesh context exchange) + the `idea_context_distribution_testnet` backlog — don't reinvent. Our "vaults-are-git-repos → the forge is the subnet's **context-sync fabric**" thesis is partly yours already.

**Expanded asks (for P7a, joint):**
1. Forge-placement decision (data-plane node vs. "forge hub" class) under `ADR-016 §8`.
2. The **identity bridge**: Forgejo user-auth ↔ your node DIDs / federation-signing keys (you own *node* identity; the forge needs *user* auth).
3. `git.<subnet>.adna.network` DNS + mesh-internal TLS.
4. How **vault-sync-via-git** relates to your tarball-transmission ceremony (`spec_node_adna_transmission_registration`) — converge or coexist.

**Output**: a **joint integration ADR** (P7a) before the P7b spike. The deployable lives in the new **`Lighthouse.aDNA`** (forked 2026-06-20). Still **staged** (Rule 10) — deliver/co-author at P7a. Decision Points 6 + 9.
