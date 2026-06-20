---
type: coordination
created: 2026-06-19
updated: 2026-06-19
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
