---
type: decision
adr_id: adr_014
title: "ADR-014 — The `mesh` Remote Role (fifth canonical role: subnet-internal mesh replicas)"
status: accepted   # base ADR accepted 2026-08-08; A2 + A3 accepted 2026-08-19 (R3-pivot gate); Amendment A4 PROPOSED 2026-08-19, §1a added 2026-08-20 (F-A4-01 transition-into-force) — awaits operator §7.7
created: 2026-08-08
updated: 2026-08-19
last_edited_by: agent_stanley
ratifies_at: "operator blanket ruling approval 2026-08-08 (the forward gate) — discharges Bulwark DP-2 (= Venus S188 A1, nudged 2026-06-26)"
depends_on: [adr_006, adr_010, adr_013]
amends: [adr_006]
tags: [decision, adr, adr_014, git, remotes, mesh, replica, dp2, bulwark, freshness_mode, f_a3_01, accepted]
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

## Amendment A4 — The declared freshness mode is a **field** (completes A3 §1) — **proposed 2026-08-19**

*Answers **F-A3-01**, filed by Pythia (`Inference.aDNA`) in [[../../who/coordination/coord_2026_08_19_pythia_to_hopper_a3_markup|her A3 markup]] — the mark-up window A3's own provenance note held open, used exactly as A3 §-provenance said it should be: **"a material objection reopens via a superseding edit, not silent divergence."** A3 is `accepted`, so this is a superseding amendment rather than an edit to ratified text. Ratification: **decision** = A4 as written · **ratified-by** = *(pending — operator §7.7)* · **date** = *(pending)* · **status** = `proposed`.*

**The finding, in one line: A3 §1 violated A2 §2 eleven lines after it was written, in the same ratified commit.** A2 §2 requires that a replica's state be carried as *"an explicit **`state: graduated`** field (**a field, not a comment**)"*, and gives the reason — **absence can never distinguish "graduated" from "broken"**, so absence is never a state signal. A3 §1 then created a *second* per-replica state axis — **which of two contracts governs this replica** — and left it as **prose in a mission/task file**. Pythia is right, and the argument is A2's own.

1. **`freshness_mode` is a field.** Every enrolled mesh replica declares **`freshness_mode: steady_state | active_co_development`** in the scheduled-push enrollment conf, sibling to A2 §2's `state:`, and mirrors it in the owning graph's `git/` declaration. Prose in a mission file MAY narrate the mode; it may not *be* the mode. **A replica whose conf omits the field is an error** (misconfiguration), never a default-to-steady-state — the same reasoning A2 §2 applied to `state:`, applied to the axis A3 added.

   **§1a — transition into force** *(added 2026-08-20; **F-A4-01**, Pythia's, sustained — see §A4 provenance)*. §1 as first written is a rule about a field that **exists in no conf yet**, with no stated transition. Read literally at the ratification instant, **every already-enrolled replica's conf omits `freshness_mode` and is therefore an error** — through no act of any owning graph. That is a defect in the text, not in the plan (the Consequences line already sequences the field with A2's `state:` patch), but it matters for the reason A4 itself argues: *a rule that evaluates **everything** to `error` on day one gets read as noise and then ignored, which is how a field with teeth becomes decoration.* Therefore:

   - §1's error condition **binds on enrollment or re-enrollment after A4's conf patch lands**.
   - Pre-existing enrollments carry **`freshness_mode: pending_declaration`** — a **third explicit value, not an absence**. The conf patch writes it in the same act that adds the field.
   - **Absence never stops meaning error.** That is the whole property A4 exists to create, and extending the enum is the only way to add a transition without undoing A2 §2 the moment it is extended. Pythia's reasoning, adopted as stated.
   - `pending_declaration` is a **transitional value, not a steady one**: a replica still carrying it after its owning graph's next enrollment touch is a defect the runner's §3 split will show, because it is a value rather than a silence.
2. **A3 §1's closing clause becomes evaluable.** *"A replica an agent operates from without the co-dev mode declared is a process defect, not a tooling one"* — true, and with the declaration in prose **there is no mechanism that could ever notice it**. Pythia's phrasing, adopted verbatim because it is the correct one: *a defect definition nothing can evaluate is a hope.* A4 exists to make that sentence checkable.
3. **Denominator provenance gains its second axis** (extends A2 §3). The runner's line already owes `enrolled n · graduated g · held h`; it now also reports the mode split, so a green run says **which contract each push satisfied** rather than only how many pushes happened. A2 §3's principle — *a green `n/n` is only as honest as its denominator* — has two denominators once A3 exists, and reporting one of them is the dishonest half of an honest instrument.
4. **The doctrine is ours; the conf's shape is Berthier's.** A4 rules **that** the mode must be machine-readable, and **where** it is declared. It does **not** specify the field's serialization, placement within the conf, or the runner's output format — those belong to `Operations.aDNA`, whose pen the enrollment conf is. Pythia explicitly declined to specify it (*"We are **not** specifying the shape"*); we hold the same line rather than quietly taking the pen because we were the ones asked to rule.

### A4 provenance — two corrections against our own record

- **⚠ A3 §4 was not accepted verbatim, and A3's text implied it was.** Pythia asked for *"the local repo is canonical and D4 graduation never arises."* A3 §4 carries that **plus two clauses that are ours**: that such a vault **MAY still carry** a `mesh` remote, and that the replica is *"a permanent distribution surface, not a way-station to a forge canonical."* She caught it and filed it against her own bookkeeping; it is at least as much ours, since we did the drafting. Recorded here — **ratified A3 text is not edited** — because "accepted verbatim" credits a peer with our drafting, which is a provenance error in the direction that flatters us.
- **⚠ F-A4-01 — A4 §1 had no transition, and would have made every enrolled replica an error at the ratification instant.** Pythia's, filed on read-back **before** the gate — exactly the window this vault asked her to use, used as asked. Sustained and folded as **§1a**, in her preferred shape **(a)**: bind on enrollment-after-patch, with `pending_declaration` as a **third explicit value** so that **absence never stops meaning error**. *Recorded against ourselves twice over*: the defect is the **same class A4 was written to fix** — a rule stated without a mechanism that could carry it — committed in the amendment that fixes it, one day later. And she noted the fix lands *"far harder on Berthier's rollout than on us"* and asked for no redesign on her behalf; the correction is folded because it is right, not because it was pressed.
- **A3 §2's generalizations were ours and are noted as improvements by their author**: her `master` → *"the mirrored integration branch"* (branch-name-agnostic) and her *"dormant vaults"* → *"vaults nobody operates from rd-side"* (the real predicate; dormancy was a proxy for it). Recorded for symmetry — the same ledger that logs a correction in our favour logs one against it.

### The measurement A4 rests on

Pythia's replica, measured by receipt-only fetch at dispatch: forge tip `22b1bd2` (2026-08-18 21:43) vs local `master` `7cf120b` (2026-08-19 18:07) — **12 commits, ~20.4 h**. ⭐ **The nightly did not fail; it was correct.** At 02:30 the local tip *was* `22b1bd2` — there was nothing to push. All twelve commits landed 12:26–18:07, after it.

That is the whole argument: **a fully-honoured steady-state contract is compatible with an agent operating from a tree that predates the entire day's rulings** — and with nothing on the replica able to tell that agent which contract governs it. A4 does not change the timer, and does not claim staleness is a defect. It makes the *mode* legible so the staleness is interpretable.

*(Pythia has already conformed her own side — and doing so found her `git/` wrapper asserting "Local `git init` only at genesis — no remote, nothing pushed", **false since 2026-08-08**, corrected in her `STATE.md` at the time and never propagated to the file a consumer actually reads. Same stale-row class this campaign keeps finding, this time inside the conformance declaration itself. Cited because it is the third instance this week and belongs in the record, not because remediation is owed here.)*

## Consequences
- Bulwark Phase B (M-BW.B1 forge-canonical ADR) unblocks — DP-2 was its last gate.
- (A4) The enrollment conf gains a second required field and the runner a second reported axis — **Operations' pen**, sequenced with A2's `state:` patch so the runner is touched once, not twice. Until A4 ratifies, A3 §1's declared mode stays prose and its closing clause stays unevaluable; that is a known, named gap rather than an assumed-working control. **The window *after* ratification is now covered too** (§1a, F-A4-01): between ratification and the conf patch landing, pre-existing enrollments are `pending_declaration` rather than errors — Berthier's rollout writes the value in the same act that adds the field, so no enrolled replica is ever in a state no one caused.
- (A2) The fleet host-move wave un-sequences from the D4 seam: Operations can patch the runner (enrollment `state:` field + denominator line + GREEN-on-graduated) once A2 ratifies; LAVG's comment-hold converts to `state: graduated`.
- (A3) Inference's rd-side development loop has a sanctioned shape; Emacs's two-operator pattern and any future co-dev replica declare their mode instead of inheriting the nightly by default.
- Emacs.aDNA's local doctrine is ratified fleet doctrine; no rework.
- ADR-006's "four names only" sentences read as five via the amendment banner; full-text cascade per D3.

## Alternatives considered
- **(b) model as shared `mirror`** — rejected: violates ADR-006 D2 in direction, freshness, and read-pattern; would amend core mirror semantics rather than add a row (the ADR-006 Alternatives section's own anti-conflation reasoning applies).
- **(c) per-fabric ad-hoc names, no doctrine** — rejected: three independent field uses converged on `mesh`; leaving it undoctrined reproduces the ambiguity ADR-006 exists to kill.
