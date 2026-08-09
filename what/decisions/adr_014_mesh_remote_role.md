---
type: decision
adr_id: adr_014
title: "ADR-014 — The `mesh` Remote Role (fifth canonical role: subnet-internal mesh replicas)"
status: accepted
created: 2026-08-08
updated: 2026-08-08
last_edited_by: agent_ilmarinen_lane
ratifies_at: "operator blanket ruling approval 2026-08-08 (the forward gate) — discharges Bulwark DP-2 (= Venus S188 A1, nudged 2026-06-26)"
depends_on: [adr_006, adr_010, adr_013]
amends: [adr_006]
tags: [decision, adr, adr_014, git, remotes, mesh, replica, dp2, bulwark, accepted]
---

# ADR-014 — The `mesh` Remote Role

**Status**: `accepted` (operator ruling 2026-08-08). **This IS the DP-2 ruling: option (a).** Amends [[adr_006_remote_naming|ADR-006]] D1 (four → five roles). Answers Venus's S188 A1/A3 (`coord_2026_06_23_venus_to_grace_hopper_context_sync_fabric_pilot.md`, re-surfaced 2026-06-26) and Archimedes' 2026-08-04 mesh-mirror pattern ask.

## Context

Three vaults independently converged on a fifth, non-canonical remote for subnet-internal replicas over the Nebula mesh, and ADR-006's four roles cannot model it:

1. **Venus's interim bare-git fabric** (Hearthstone Wave 3): bare repos on `wga_l1`, remote provisionally named `mesh`.
2. **Archimedes' Emacs.aDNA pattern** (2026-08-04): a bare mirror over Nebula, remote `mesh`, "added alongside `origin`, not replacing it" — ratified as local doctrine pending this ruling.
3. **Ilmarinen's R&D forge** (2026-08-08): 8 graph replicas on the live Forgejo instance, remote provisionally named `rd-forge` explicitly pending this ruling.

Option (b) — modeling these as shared `mirror`s — fails ADR-006 D2 three ways: mesh replicas are **fetched from** by second operators; they run **fresher than the canonical origin** (local HEADs ahead of Codeberg); and their direction is canonical → **private mesh**, not private → public face. Ruling (b) would amend D2's core semantics; (a) adds a row instead.

## Decisions

### D1 — The `mesh` role (binding)

| Remote | Role | Set by | Lifetime |
|---|---|---|---|
| **`mesh`** | **subnet-internal mesh replica** — a bare fabric or mesh forge copy serving consent-scoped subnet members over the overlay | `set-remote` (or manual, registered) | permanent while the fabric/forge serves; superseded at graduation (D4) |

Properties (all binding):
- **Non-canonical, never displaces `origin`.** `origin` remains the single canonical home per ADR-006 D2; a `mesh` remote is a distribution/collaboration surface.
- **MAY run ahead of `origin`** — unlike `mirror`, freshness relative to the canonical host is expected (local-first doctrine pushes here before the operator asks for an origin push). A `mesh` replica is a *truth candidate for subnet readers*, not the truth source of record.
- **Read by consent-scoped members** (ADR-018-class consent on the hosting box; forge-side RBAC where the host is a forge).
- **Keep-fresh = push-based** from the canonical working clone (manual or scheduled — an Operations-scheduled push is the sanctioned mechanism). Forge-side pull-mirrors from the canonical host are NOT the mechanism (they would be staler than the working clone).
- **First push to a mesh host is a first-share event** → the ADR-011 Amendment A1 gate applies (full-history scan).

### D2 — Naming (binding)

- A repo with **one** mesh replica names it **`mesh`**.
- A repo with **several** mesh replicas qualifies each: **`mesh-<fabric-id>`** (e.g. `mesh` = the wga_l1 bare fabric · `mesh-rd` = the aDNA-Labs R&D forge). Existing single-fabric `mesh` remotes (wga fabric, Emacs pattern) are conformant as-is; the R&D forge's `rd-forge` remotes rename to `mesh-rd` at this ruling.

### D3 — Tooling cascade (follow-through, not this ADR's edit)

`set-remote` gains the `mesh` role; `doctrine_gitops_block.md` item 1 + `spec_gitops_provider_abstraction.md` §4 + the `git_provider` schema remote block updated now (same commit wave). Deferred to the next tooling pass: `gitops_dispatch.sh` + `dryrun_gitops.sh` harness rows + `skill_git_remote_setup.md`. Until then, manual `git remote` acts on `mesh` remotes are conformant when registered in the owning graph's `git/` declaration.

### D4 — Graduation seam (answers Venus's A3)

At mesh-git graduation (Forgejo M07-class events; ADR-010 D1), a repo whose canonical home moves to the subnet forge executes the ADR-006 D3 **host-move sequence** — the forge URL becomes `origin`, and the `mesh` remote pointing at that same forge is **removed as redundant** (not renamed in place). Mesh remotes pointing at *other* fabrics are unaffected.

## Consequences
- Bulwark Phase B (M-BW.B1 forge-canonical ADR) unblocks — DP-2 was its last gate.
- Emacs.aDNA's local doctrine is ratified fleet doctrine; no rework.
- ADR-006's "four names only" sentences read as five via the amendment banner; full-text cascade per D3.

## Alternatives considered
- **(b) model as shared `mirror`** — rejected: violates ADR-006 D2 in direction, freshness, and read-pattern; would amend core mirror semantics rather than add a row (the ADR-006 Alternatives section's own anti-conflation reasoning applies).
- **(c) per-fabric ad-hoc names, no doctrine** — rejected: three independent field uses converged on `mesh`; leaving it undoctrined reproduces the ambiguity ADR-006 exists to kill.
