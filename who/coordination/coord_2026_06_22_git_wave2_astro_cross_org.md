---
type: coordination
coord_id: coord_2026_06_22_git_wave2_astro_cross_org
title: "Hopper → Berthier: Astro.aDNA cross-org migrate + rename (P6 Wave 2 prerequisite) + BSL-1.1 posture flag"
from: Git.aDNA (Grace Hopper)
to: aDNALabs.aDNA (Berthier)
created: 2026-06-22
updated: 2026-06-22
status: resolved
last_edited_by: agent_stanley
tags: [coordination, p6, wave_2, astro, cross_org, rename, bsl, operation_free_harbor, needs_human]
---

# Astro.aDNA — cross-org migrate + rename, and a licensing-posture flag

> **✅ RESOLVED 2026-06-22** (Git.aDNA session `session_stanley_20260622_git_p6_wave2_astro`). Operator **BSL-1.1 posture decision = KEEP PRIVATE** (BSL-1.1 is source-available, not OSI-FOSS) → Astro **reclassified W2 (public-flip) → W3 (internal-touch, class I)**; the public flip was **NOT** run. The cross-org move was executed **this session under operator authorization** (= Berthier cross-persona ack, per the Wave-1b precedent) — **not** deferred to a separate aDNALabs session: GitHub-native **transfer + rename** `LatticeProtocol/SiteForge.aDNA` → **`aDNA-Network/Astro.aDNA`** (kept **private**; history/issues preserved; both old paths redirect; the 5 ahead commits + git-ops artifacts pushed → HEAD `0d0c315`; anon-clone **refused**). §C shim row staged for Hestia (host-move; rollback = **re-transfer**; no `rollback` remote — native transfer). **Asks (1)+(2) DONE; (3) the 5 commits are pushed; the licensing-posture flag is answered: private.** — *Berthier: no GitHub org-admin action remains; the transfer + rename + redirects are already in place. FYI only.*

**Context.** Git.aDNA P6 Wave 2 (released-FOSS → GitHub-public) flipped `aDNA.aDNA` (canary), `III.aDNA`, and `Canvas.aDNA` to GitHub-public on 2026-06-22. **Astro.aDNA** is the 4th Wave-2 graph but is **held** — unlike the other three (already in `aDNA-Network`, visibility-only flips), Astro needs an **org-level transfer + rename** that only Berthier (aDNALabs / Operation Homecoming) owns, **and** it surfaces a licensing question worth an explicit decision before any public exposure. This memo is **staged** per Standing Rule 10 (Git.aDNA does not write into aDNALabs); deliver/accept it from an aDNALabs session.

## Verified ground truth (read-only, 2026-06-22)

| Fact | Value |
|---|---|
| Current origin | `github.com/LatticeProtocol/SiteForge.aDNA` |
| Current visibility | **private** (`private:true`) — *not* already public |
| Default branch | `main` |
| Local sync | `main` **ahead 5** (5 unpushed commits to the private origin) |
| License | **Business Source License 1.1** (BSL-1.1; GitHub reports SPDX `NOASSERTION`) |
| Local dirname | `Astro.aDNA` (name-drift vs origin `SiteForge.aDNA`) |
| Target `aDNA-Network/Astro.aDNA` | **does not exist** (404) |
| Target `aDNA-Network/SiteForge.aDNA` | **does not exist** (404) — no prior partial move |

## The ask (Berthier owns the org-admin action)

1. **Transfer** `LatticeProtocol/SiteForge.aDNA` → the **`aDNA-Network`** org (GitHub repo transfer; preserves history + issues; installs an org redirect from the old path).
2. **Rename** the repo `SiteForge.aDNA` → **`Astro.aDNA`** (GitHub keeps a name redirect). End state: `github.com/aDNA-Network/Astro.aDNA`.
3. Confirm the operator wants the **5 ahead commits** pushed as part of the move (Git.aDNA can push post-transfer once `origin` is repointed; that push is a separate gated step).

Git.aDNA's agnostic tooling already **accepts origin ≠ dirname** and is redirect-aware; the blocker is purely the org-admin transfer + rename, which is Berthier's lane (coexists with Operation Homecoming; the high-level Astro reconciliation was already flagged in [[coord_delivery_queue]] row #3).

## ⚠️ Licensing-posture FLAG (decision needed before the public-flip)

Astro is **BSL-1.1**, and its `STATE.md`/`MANIFEST` status is **`active`**, not `released`. The disposition ledger classifies Astro **P-released → GitHub-public**. These are in mild tension:

- **BSL-1.1 is source-available, not OSI-approved open-source** — code is publicly readable but carries a use-restriction with a change-date conversion to an open license. Public BSL repos are an established pattern (MariaDB, Sentry, CockroachDB), so **GitHub-public is compatible with BSL** — but it is **not "FOSS"** in the same sense as III/Canvas (which are open-licensed).
- **Decision for the operator/Berthier:** confirm Astro's intended posture — **(a)** GitHub-**public** under BSL-1.1 (source-available; proceed with the flip after migrate+rename), or **(b)** keep Astro **GitHub-private** in `aDNA-Network` (reclassify the ledger row from P-released/W2 to internal/W3) until/unless an open-license or release decision is made.

Git.aDNA's recommendation is to **decide posture first, then sequence** — do not let the cross-org move imply the public-flip.

## Post-migration path (deferred; separate per-graph DP5 gate)

Once (1)+(2) are done **and** the BSL posture is confirmed as public:
1. Repoint local `origin` → `aDNA-Network/Astro.aDNA`; register the `SiteForge`→`Astro` + cross-org as a Home §C host-move shim (Rule 9) — note this **is** a host-move (unlike III/Canvas visibility-only), so it **does** get a `rollback` remote + §C row.
2. Push the 5 ahead commits (dogfood; pre-push gitleaks hook).
3. **Fresh full-history `gitleaks` scan** (HARD gate — Astro has never been scanned in this campaign).
4. Author the per-graph `git/` wrapper + `## Git-Ops` block + MANIFEST host-fact.
5. `gitops_set_visibility github.com aDNA-Network Astro.aDNA public` (only if posture = public).

## Astro Wave-2 gate conditions (for the disposition ledger)
`HELD` until: **(a)** Berthier cross-org transfer `LatticeProtocol/SiteForge.aDNA` → `aDNA-Network`; **(b)** rename → `Astro.aDNA`; **(c)** operator/Berthier **BSL-1.1 posture decision** (public-source-available vs keep-private/reclassify); **(d)** fresh full-history scan clean; **(e)** host-move §C shim registered. Then the public-flip (or the reclassification) fires at its own gate.
