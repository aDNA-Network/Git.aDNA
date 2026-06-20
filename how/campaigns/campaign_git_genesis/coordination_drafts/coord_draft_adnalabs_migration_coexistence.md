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

---

## P1 coexistence findings (2026-06-19) — ✅ clean, complementary

Read-only cross-ref of the fleet ledger ([[fleet_git_state]]) against `aDNALabs.aDNA/STATE.md` (`campaign_adnalabs_genesis`, Operation Homecoming; WS-0–5 substantially complete):

1. **No collision — and the Codeberg ToS finding *removes* the original collision risk.** Codeberg's ToS prohibits private proprietary repos ([[context_provider_tooling_sota]] headline), so Git.aDNA does **NOT** pull the fleet's private repos off GitHub `aDNA-Network`. **Homecoming's work is preserved, not undone.** Git.aDNA *adds*: Codeberg for the **FOSS subset** + (future) **self-hosted Forgejo** for private. The corrected partition:
   - **GitHub `aDNA-Network`** = private-interim home (stays — Homecoming's result) **+** public discovery for the OSS set.
   - **Codeberg `aDNA-Network`** = the **FOSS/public subset only** (III, Canvas, Astro, …, once flipped public).
   - **Self-hosted Forgejo** (north star, pulled forward) = the eventual **private** home.
2. **The 3 cross-org stragglers are already YOUR tracked item.** My ledger flags `ContextCommons.aDNA`, `Astro.aDNA` (`SiteForge.aDNA`), `Spacemacs.aDNA` still on **`LatticeProtocol`** — which is exactly aDNALabs's standing follow-up *"the 3 un-migrated remotes (ContextCommons · SiteForge · Spacemacs → operator `admin:org` org-batch)."* **Aligned — same finding, your lane.** (+ `LAVentureGraph.aDNA` on a personal `ScienceStanley` account — a 4th straggler to add.)
3. **Name-drift hand-off → your migration ledger.** ~14 graphs have GitHub origins under **pre-PT-rename** repo names (`Molecules`→`moleculeforge`, `Oration`→`SpeechForge`, `Operations`→`TaskForge`, `VAAS`→`VAASLattice`, `LatticeProtocol`→`latticeprotocol-adna`, `Lab`→`lab-adna`, `Astro`→`SiteForge`, …). Repo-renames on the host need `admin:org` (your lane). Git.aDNA's tooling will *accept origin≠dirname* but recommends reconciling — feed to the migration ledger.

**Ask:** confirm the corrected partition (Decision Point 2), fold the name-drift list + the 4th straggler into the migration ledger, and gate the straggler org-batch jointly. Nothing here requires undoing Homecoming.
