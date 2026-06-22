---
type: coordination
created: 2026-06-19
updated: 2026-06-21
status: draft
last_edited_by: agent_stanley
to: "aDNALabs.aDNA (Berthier)"
deliver_at: "BEFORE the P6 Wave-1 gate fires (see the 2026-06-21 addendum)"
binds_adrs: [adr_013, adr_006, adr_003]
tags: [coordination, draft, git, adnalabs, migration_coexistence, p6, wave1, adr_013, operation_free_harbor]
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

---

## P2 update (2026-06-20) — Path B confirmed; partition bound in ADR-005

At the P2-entry gate the operator chose **Path B** (GitHub-interim private + Codeberg-FOSS; self-host eventual). The coexistence partition is now bound in [[adr_005_visibility_host_policy|ADR-005]] D6 and is *cleaner* than first foreseen — **no private repos leave GitHub near-term**, so Operation Homecoming is fully preserved:

- **GitHub `aDNA-Network`** = private-interim home (stays) + public discovery for the OSS set.
- **Codeberg `aDNA-Network`** = the FOSS subset only.
- **Self-hosted Forgejo** = eventual private home (post-P7).

Classification is **approved-in-principle** ([[adr_005_visibility_host_policy|ADR-005]] D4); the name-drift list (~14) + the 4 cross-org/personal-account stragglers fold into your migration ledger (admin:org lane); **joint operator + Berthier gate before any P6 wave**. Memo stays **staged** (Rule 10) — re-confirm with Berthier before the first wave. No action undoes Homecoming.

---

## P6 Wave-1 addendum (2026-06-21) — partition inverted by ADR-013; concrete Wave-1 asks

> **🔄 The partition above is SUPERSEDED by [[adr_013_host_role_inversion|ADR-013]] (host-role inversion, ratified 2026-06-20).** Codeberg is now the **PRIVATE FOSS-in-development** home (not the "public subset"). The corrected, current partition:
> - **GitHub `aDNA-Network` (public)** = **released** FOSS (the public home — network effect) → `aDNA`, `III`, `Canvas`, `Astro`, `Git.aDNA`(done). **This is Wave 2.**
> - **Codeberg `aDNA-Network` (private)** = **FOSS-in-development** (opens to GitHub at release; ToS-OK for FOSS-bound work only). **This is Wave 1.**
> - **GitHub `aDNA-Network` (private, interim)** = internal/proprietary majority → **stays put** (Homecoming preserved), self-hosted post-P7.
> **Homecoming is still fully preserved** — the internal majority does not move; only the FOSS-in-dev subset leaves GitHub-private for Codeberg-private, and the released subset flips public *on GitHub* (your admin:org lane).

**The disposition ledger is reconciled to ground truth** ([[disposition_ledger]], conservative released-threshold). **Wave 1 fires these host moves — each needs your coordination BEFORE the gate:**

| Graph | Wave-1 move | Old GitHub repo (→ rollback, then your call) | Your action |
|---|---|---|---|
| `Molecules.aDNA` | → Codeberg-private `Molecules.aDNA` | `aDNA-Network/MoleculeForge.aDNA` | **name-drift** — confirm GitHub-side archive/redirect of the old drifted name at shim-window close (archive-never-delete) |
| `Oration.aDNA` | → Codeberg-private `Oration.aDNA` | `aDNA-Network/SpeechForge.aDNA` | **name-drift** — same |
| `Spacemacs.aDNA` | → Codeberg-private `Spacemacs.aDNA` | `LatticeProtocol/Spacemacs.aDNA` | **cross-org straggler** — it leaves `LatticeProtocol` for Codeberg (not GitHub `aDNA-Network`); update your straggler ledger. *(If you/operator deem it internal, it instead goes GitHub `aDNA-Network`-private — confirm.)* |
| `Videos.aDNA` | → Codeberg-private `Videos.aDNA` | `aDNA-Network/Videos.aDNA` | no drift/cross-org; FYI only |
| `VisualDNA`, `Lighthouse` | first-remote → Codeberg-private | — (local-only) | FYI only (greenfield) |

**Wave-2 preview (your direct lane, fires later):** `Astro.aDNA` — migrate `LatticeProtocol/SiteForge.aDNA` → `aDNA-Network` **on GitHub** + rename → then public-flip (admin:org). `ContextCommons` + personal `ScienceStanley/LAStartupLattice` → `aDNA-Network` at their W3 touch.

**The Wave-1 asks (confirm before the gate):**
1. **Ack the ADR-013 partition** (Codeberg = private FOSS-dev; the released-4 flip public on GitHub) — supersedes the ADR-005 framing above.
2. **The 4 FOSS-in-dev graphs leave GitHub-private for Codeberg-private** — confirm this does not conflict with any in-flight Homecoming action on them; old GitHub repos held as `rollback` (30d window) then archived (your admin:org).
3. **Spacemacs** — confirm FOSS-in-dev (→ Codeberg) vs internal (→ GitHub `aDNA-Network`-private); it leaves `LatticeProtocol` either way.
4. **Joint gate** stands — Git.aDNA executes the per-graph host move; you own the org-level disposition of the vacated GitHub repos + the Wave-2 cross-org/public flips.

**Boundary unchanged:** Git.aDNA owns patterns + tooling + per-graph execution; aDNALabs owns the org-level program. Memo stays **staged** (Rule 10) — **deliver before the Wave-1 gate fires.**
