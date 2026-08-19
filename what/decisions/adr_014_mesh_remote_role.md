---
type: decision
adr_id: adr_014
title: "ADR-014 — The `mesh` Remote Role (fifth canonical role: subnet-internal mesh replicas)"
status: accepted   # base ADR accepted 2026-08-08; Amendments A2 + A3 accepted 2026-08-19 (operator ratification, R3-pivot gate)
created: 2026-08-08
updated: 2026-08-19
last_edited_by: agent_stanley
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

## Amendment A2 — Graduation semantics (D4 completed) — **accepted 2026-08-19**

*Answers Berthier's 2026-08-09 ruling ask ([[../../who/coordination/coord_2026_08_09_berthier_to_git_adna_adr014_d4_graduation_semantics|memo]]): D4 mandated a state D1's sanctioned mechanism rejects — the ADR against itself. Reference case: LAVG (first class-I graduation, 2026-08-09), currently held out of the nightly by a comment. Ratification: **decision** = A2 as written · **ratified-by** = operator (Stanley, R3-pivot gate) · **date** = 2026-08-19 · **status** = `accepted`.*

1. **Obligation swap, not exit-to-nothing.** A graduated repo **leaves the scheduled mesh-push set** and simultaneously **acquires an off-forge replica obligation**: the canonical must never be single-homed on the subnet forge. The old host's URL is kept as **`rollback`** (interim, per the ADR-006 D3 host-move sequence — LAVG's kept GitHub remote is the reference) and converts to a standing **`mirror`** (or a second fabric's `mesh-<fabric-id>`) at the operator's disposition call. A graduated repo with no off-forge replica is **non-conformant**, not merely un-scheduled.
2. **Graduation is recognized positively, never by absence.** Three concordant, machine-readable signals: (a) `origin` resolves to the subnet forge; (b) the scheduled-push runner's enrollment conf carries an explicit **`state: graduated`** field (a field, not a comment — Berthier's n=1 observation binds here); (c) the owning graph's `git/` declaration + the disposition ledger record the graduation. A missing `mesh-rd` remote on an **enrolled** repo remains an **error** (misconfiguration) — absence can never distinguish "graduated" from "broken", so it is never a state signal.
3. **A mixed run is GREEN.** A scheduled run where some repos pushed and others are lawfully `state: graduated` exits **0**. The runner MUST print **denominator provenance** — `enrolled n · graduated g · held h` — so `OK n/n` is honest about what it counted (Berthier's "a green n/n is only as honest as its denominator"). `no-mesh-rd-remote` on an enrolled, non-graduated repo stays in the error set.
4. **SSH addressing doctrine (fleet pattern, from the LAVG execution):** mesh-forge SSH remotes use an ssh-config **`Host` alias** with `IdentitiesOnly yes` + a dedicated key, and the remote URL is written in **alias form** — raw `ssh://git@<ip>:2222/…` URLs fail under multi-key agents ("too many authentication failures") and are non-conformant for fleet use.

## Amendment A3 — mesh co-development discipline (PR-flow · freshness · CI) — **accepted 2026-08-19**

*Concurs with Pythia's 2026-08-19 three-piece joint design ([[../../who/coordination/coord_2026_08_19_pythia_to_hopper_mesh_rd_sync_discipline|memo]]) and generalizes Archimedes' 2026-08-04 measurements. This is the fifth role's operating law, so it lands here rather than as a new ADR. Pythia holds a mark-up window on the binding language (her memo is a joint design); a material objection reopens via a superseding edit, not silent divergence. Ratification: **decision** = A3 as written · **ratified-by** = operator (Stanley, R3-pivot gate) · **date** = 2026-08-19 · **status** = `accepted`.*

1. **Declared freshness contract, two modes.** Every mesh replica is governed by exactly one declared mode — never inferred: **steady-state** (the Operations standing push, ≤24 h staleness; correct for vaults nobody operates from rd-side) or **active-co-development** (declared per-mission in the mission/task file; a session-close **per-ask gated push** through Operations' §13 runner — reach-probe → claim → push → release — **never a second standing timer**). A replica an agent operates *from* without the co-dev mode declared is a process defect, not a tooling one.
2. **PR-return is the only re-entry path.** rd-side commits go to **branches + PRs on the mesh forge**, never directly to the mirrored integration branch. The consuming (canonical) side fetches **receipt-only** and merges deliberately at its own seat — **reconcile-never-force**. This keeps D1's "truth candidate, not truth source" real under bidirectional flow.
3. **Mirror CI is repo-contained and honestly scoped.** The mesh forge runs only **ADR-008 portable** checks that are true properties of the repo bytes (schema self-checks, parse/lint, merge-logic tests). Validators that read node-local state MUST NOT be given "rd-runnable" fictions — a check that cannot really run there is not ported, it is declined and documented (Pythia's posture, adopted).
4. **Local-git-only vaults.** A vault whose standing order keeps its repo local-only MAY still carry a `mesh` remote; its **local repo remains canonical** and **D4 graduation never arises** for it — the mesh replica is a permanent distribution surface, not a way-station to a forge canonical.

## Consequences
- Bulwark Phase B (M-BW.B1 forge-canonical ADR) unblocks — DP-2 was its last gate.
- (A2) The fleet host-move wave un-sequences from the D4 seam: Operations can patch the runner (enrollment `state:` field + denominator line + GREEN-on-graduated) once A2 ratifies; LAVG's comment-hold converts to `state: graduated`.
- (A3) Inference's rd-side development loop has a sanctioned shape; Emacs's two-operator pattern and any future co-dev replica declare their mode instead of inheriting the nightly by default.
- Emacs.aDNA's local doctrine is ratified fleet doctrine; no rework.
- ADR-006's "four names only" sentences read as five via the amendment banner; full-text cascade per D3.

## Alternatives considered
- **(b) model as shared `mirror`** — rejected: violates ADR-006 D2 in direction, freshness, and read-pattern; would amend core mirror semantics rather than add a row (the ADR-006 Alternatives section's own anti-conflation reasoning applies).
- **(c) per-fabric ad-hoc names, no doctrine** — rejected: three independent field uses converged on `mesh`; leaving it undoctrined reproduces the ambiguity ADR-006 exists to kill.
