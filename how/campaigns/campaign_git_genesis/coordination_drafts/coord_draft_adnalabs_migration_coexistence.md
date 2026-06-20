---
type: coordination
created: 2026-06-19
updated: 2026-06-19
status: draft
last_edited_by: agent_stanley
to: "aDNALabs.aDNA (Berthier)"
deliver_at: "P1 (Inventory) / before any P6 wave"
tags: [coordination, draft, git, adnalabs, migration_coexistence, operation_free_harbor]
---

# Coord Draft → aDNALabs.aDNA (Berthier): Codeberg-Split ↔ Operation Homecoming Coexistence

**Status**: DRAFT — staged at genesis P0; **deliver at P1** (inventory) and re-confirm **before any P6 migration wave**. Not yet sent.

## The ask
Reconcile Operation Free Harbor's **Codeberg-private / GitHub-public split** with `aDNALabs.aDNA`'s **Operation Homecoming** (which just moved ~23 repos **onto** GitHub `aDNA-Network`). We must not undo or collide with that work.

## The clean partition (proposed)
- **GitHub `aDNA-Network`** = the **public** face (public graphs, releases, community) — exactly what Homecoming populated; **unchanged for public graphs**.
- **Codeberg `aDNA-Network`** = the **private** home (internal/dev work) — where private repos *move off* the GitHub org.
- The two programs **partition by visibility**, not by competing for the same repos. ([[adr_003_visibility_split_policy]] D5.)

## What we need from Berthier
1. The authoritative list of repos Homecoming placed on GitHub `aDNA-Network` (+ their public/private status) — feeds the P1 `fleet_git_state.md`.
2. Agreement on the visibility partition + which repos are **public-stay-on-GitHub** vs **private-move-to-Codeberg**.
3. A joint gate before each P6 wave (Git.aDNA executes the host move; aDNALabs owns the org-level program).

## Boundary
Git.aDNA owns the **patterns + tooling + per-graph execution**; aDNALabs owns the **org-level migration program**. No org-level change without Berthier in the loop. Decision Points 2, 5.
