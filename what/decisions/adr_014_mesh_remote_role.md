---
type: decision
adr_id: adr_014
title: "ADR-014 — The `mesh` Remote Role (fifth canonical role: subnet-internal mesh replicas)"
status: accepted   # base ADR accepted 2026-08-08; A2 + A3 accepted 2026-08-19 (R3-pivot gate); Amendment A4 (§1a incl., F-A4-01 transition-into-force) ACCEPTED 2026-08-23 (ratification-packet gate). ⭐ This unblocks Berthier's `freshness_mode` conf patch — whose shape was already authored + delivered 2026-08-20 — and with it the 11 mesh rows that are currently unadjudicable (unmeasured, not healthy). Amendment A5 (reconcile-force narrowed; direction · rescue-read-back · explicit lease OID) ACCEPTED 2026-08-24 (plan gate) — discharges ADR-026 D3's inline A5-pending self-restriction and files ⛔ F-P7b-t against the sanctioned ceremony's own guard. ✅ A4's SECTION HEADING read `proposed 2026-08-19` — contradicted by this line and by A4's own ratification block — from its stamp until **2026-08-29, when it was corrected to `accepted 2026-08-23`** under [[adr_017_ratification_record|ADR-017]] D1/D4 (heading takes the date from its own inline block). A5's provenance note recording the defect **stands unedited** (ADR-017 D2): it was right about append-only and right to decline the fix under the rule then available. ⛔ It was **not one instance but a class of six** — F-P7b-ap, five of them in ADR-011. Amendment A6 (graduation triggers **T1/T2 only**; T2 made evaluable; disposition ruled per verdict class) **PROPOSED 2026-08-29, at `rev 2`** — formalizes the operator's 2026-08-28 phased-replica-first ruling and discharges Ilmarinen's two `ack_required` memos. ⛔ **rev 2 revises rev 1 before any stamp** (A6 was never ratified, so the no-edit precedent does not reach it): §3 **no longer transcribes a population table** into a binding clause (**F-P7b-an** — the practice ADR-016 rev 3 was corrected for two days earlier; rev 1's table was false inside 24 hours), §2's verdict set is made **total** and adopts Ilmarinen's `REPLICA_ACTIONS_ON` for a state rev 1 could not classify (**F-P7b-ao**), **T3 is WITHDRAWN** (§4 — A2 §1 binds *graduated* repos, so the ruling's nominated first candidate was misclassified; ⚖ **this contests the operator ruling and is flagged as a contest**), and a named exception now requires **operator ratification** rather than self-declaration. Also files ⛔ F-P7b-al (four artifacts, incl. our own wrapper twice, cite an `A4 §5` that does not exist — the obligation is A4 §1; it read as familiar because **ADR-011** A4 §5 is real and cited ~15×) and ⛔ F-P7b-am (our own carriage measurement printed a confident `carrying=0` from a broken loop environment; caught by a positive control before use). Takes Ilmarinen's **F-F93** (a `LATENT` graph already landed, correctly).
created: 2026-08-08
updated: 2026-08-29
last_edited_by: agent_stanley
ratifies_at: "operator blanket ruling approval 2026-08-08 (the forward gate) — discharges Bulwark DP-2 (= Venus S188 A1, nudged 2026-06-26)"
depends_on: [adr_006, adr_010, adr_013]
amends: [adr_006]
tags: [decision, adr, adr_014, git, remotes, mesh, replica, dp2, bulwark, freshness_mode, f_a3_01, accepted, a5, adr_026, reconcile, force_with_lease, f_p7b_t, rescue_branch, direction_binding, a6, graduation_triggers, t1, t2, t3, build_home,
  replica_build_home, latent, indeterminate, enumerated_not_rostered, f_f86, f_f89, f_f91,
  f_p7b_al, f_p7b_am, f_p7b_an, f_p7b_ao, f_f93, replica_actions_on, clear, total_classification,
  vantage_split, t3_withdrawn, undeclared_canonical, rev2, contests_ruling, proposed]
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

## Amendment A4 — The declared freshness mode is a **field** (completes A3 §1) — **accepted 2026-08-23**

*Answers **F-A3-01**, filed by Pythia (`Inference.aDNA`) in [[../../who/coordination/coord_2026_08_19_pythia_to_hopper_a3_markup|her A3 markup]] — the mark-up window A3's own provenance note held open, used exactly as A3 §-provenance said it should be: **"a material objection reopens via a superseding edit, not silent divergence."** A3 is `accepted`, so this is a superseding amendment rather than an edit to ratified text. Ratification: **decision** = A4 as written, **including §1a** · **ratified-by** = operator (Stanley, ratification-packet gate — RCC accepted in-session; basis at `session_stanley_20260823_git_ratification_packet`) · **date** = 2026-08-23 · **status** = `accepted`. ⭐ *§1a is now in force, so the transition is the one F-A4-01 engineered: pre-existing enrollments carry **`freshness_mode: pending_declaration`** — a third explicit value — written by the conf patch in the same act that adds the field. **No enrolled replica is an error through anyone's inaction.** Berthier's conf shape was authored and delivered 2026-08-20 (`coord_2026_08_20_berthier_to_hopper_freshness_mode_conf_shape_authored`); this stamp is the gate it was waiting on.*

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

## Amendment A5 — `reconcile-never-force` is narrowed, and the guard it is narrowed onto does not hold — **accepted 2026-08-24**

*Answers Berthier's ask ([[../../who/coordination/inbox/coord_2026_08_24_berthier_to_hopper_a5_force_with_lease_concurrence|memo]], delivered into this vault's drop-box 2026-08-24): Operations **ADR-026 D3** (`accepted` 2026-08-24) sanctions, for the noise/mistake branch of a mesh divergence, a rescue-to-`rescue/<date>-<repo>` followed by **one operator-gated `push --force-with-lease`** — narrowing A3 §2's `reconcile-never-force` from an absolute to a conditional. He routed it to this pen rather than around it, and ADR-026's text self-restricts until we rule. ⭐ **Verified at his source, not from his summary** — D3.2's clause, its inline A5-pending condition, and `status: accepted` all read as characterised. Ratification: **decision** = A5 as written · **ratified-by** = operator (Stanley, plan gate, on the stated condition that the text hold up on re-reading) · **date** = 2026-08-24 · **status** = `accepted`.*

**A5 concurs. It does not concur with the ceremony as drafted**, because re-reading it against `git push`'s own documentation found that the guard the whole narrowing rests on is disarmed by an earlier step of the same ceremony (**F-P7b-t**, below).

1. **Concurrence (binding).** `reconcile-never-force` is **not an absolute**. ADR-026 D3's merge-first
   disposition (real work → merge, never force — the S186 `Network.aDNA` precedent) and its
   rescue-then-realign path for the noise branch are **sanctioned under this ADR**. A3 §2's other half
   is **unchanged and reaffirmed**: *automation never reconciles* — no timer merges, forces, or
   fetches-into-worktree, in either freshness mode.

2. **Direction is binding, and it is ours to state.** A sanctioned force may target **only a `mesh`
   replica's integration branch**. **A force toward `origin` is never sanctioned by A5, under any
   condition, after any rescue.** D1 already makes `origin` the single canonical home and the replica
   *"a truth candidate for subnet readers, not the truth source of record"* — but A3 §2 states
   `reconcile-never-force` **direction-agnostically**, so a narrowing built only from ADR-026's
   conditions (never-for-automation; operators only after rescue) would, **read alone**, sanction an
   operator force-pushing the canonical. ⚠ **That gap is ours, not his** — ADR-026's frame is mesh
   replicas throughout. Ours is the text that must survive being read without its neighbours.

3. **A rescue is preserved only when it is read back (binding).** Before the force runs, the
   `rescue/<date>-<repo>` ref MUST be verified present at the forge by an **independent read** —
   `git ls-remote <mesh-remote> 'refs/heads/rescue/*'` — and the rescued OID MUST equal the stray tip
   recorded at classification. ⭐ *A push that exits 0 is an assertion; the ref appearing at the forge
   is a measurement.* The rescue and the destruction target **the same forge**, so a rescue that
   silently failed to create the ref leaves the ceremony proceeding to overwrite work it believes it
   saved — and nothing in the exit code can distinguish the two.

4. **The lease must be explicit (binding). Bare `--force-with-lease` is NON-CONFORMANT for mesh
   reconcile.** The required form is:

   ```sh
   git push --force-with-lease=<refname>:<expected-oid> <mesh-remote> <refname>
   ```

   where `<expected-oid>` is the integration-branch tip **the operator actually inspected at
   classification** — never whatever the remote-tracking ref happens to hold at push time.

   **The reason, in git's own words** (`git push --help`, on the bare form): it *"interacts very badly
   with anything that implicitly runs `git fetch` on the remote to be pushed to in the background"*
   and is *"trivially defeated if some background process is updating refs in the background"* —
   because git has *"nothing except the remote tracking info to go by"* as the heuristic for what you
   are willing to clobber.

5. **A5 wires no gate.** This amendment rules **that** the force is conditional and **under which
   conditions**; it does not specify the runner's implementation, the ceremony's operator-facing
   shape, or ADR-026's own text. That is `Operations.aDNA`'s pen — the line A4 §4 already drew
   (*"the doctrine is ours; the conf's shape is Berthier's"*), applied consistently rather than
   quietly taken back now that we have a correction to offer. **No check ships ahead of this
   ratification** (ADR-013 A1's finding, applied).

6. **Consequence of A5** *(carried here rather than appended to the ratified Consequences section — see the provenance note on append-only discipline)*: ADR-026 D3.2's inline A5-pending self-restriction **is discharged**; the force-with-lease step is sanctioned doctrine from this stamp, **subject to §2–§4**, which are conditions ADR-026 does not currently carry. Until ADR-026 carries them, an operator executing D3.2 satisfies A5 only by adding them at the seat.

### A5 provenance — one finding against the ceremony, one against ourselves, one against this file

- **⛔⛔ F-P7b-t — the ceremony's own inspection step disarms the guard the ceremony depends on.**
  ADR-026 D3.1 has the §13 runner classify divergence by **receipt-only fetch + rev-list**, on a
  nightly timer. A fetch **updates the remote-tracking ref**. A bare `--force-with-lease` then takes
  its expected value **from that refreshed ref** — i.e. from the stray commit it exists to protect —
  **and passes.** ⭐ **The tightest form does not depend on where the runner runs**: D3.2 requires the
  operator to decide *"is the stray work real?"*, and **that decision cannot be made without
  fetching**. The ceremony therefore *requires* the act that vacates its own lease. ⛩ **Third
  instance of F-P7b-r's shape, and the worst-directed one yet: an instrument valid under an unstated
  precondition does not fall silent when the precondition fails — and here it fails toward
  *permission*. A refused force is safe. A force that passes because its guard was silently disarmed
  is the one that destroys a peer's work**, in the ceremony written to guarantee nothing is destroyed.
  Found by reading `git push --help` before drafting a concurrence, not by reasoning about it.

- **⚠ Against ourselves — A3 §2 was written direction-agnostically and we did not notice until a peer
  tried to narrow it.** §2 above exists because our own ratified sentence, read alone, does not say
  which way a force may point. Berthier's narrowing is faithful to his frame and would have been
  faithful to ours had ours been complete. *A clause that is safe only because a different clause
  catches its worst case is under-conditioned, and the catching clause is in a different section of a
  different decision.*

- **⚠ Against this file — A4's heading still reads `proposed`.** The heading of Amendment A4 says
  ***"proposed 2026-08-19"*** while the frontmatter says `Amendment A4 … ACCEPTED 2026-08-23` and A4's
  own inline ratification block says `status` = `accepted`. **The document contradicts itself, and a
  reader who scans headings sees a ratified amendment as unratified.** ⛔ **Recorded, deliberately NOT
  fixed here** — this document's own precedent is explicit (*"ratified A3 text is not edited"*), and
  A5 will not be the amendment that quietly edits a ratified heading while claiming append-only
  discipline. It is the same stale-row class this campaign keeps finding, this time in the heading of
  the amendment that fixed a stale-field class.

- **Append-only discipline, proved not asserted.** A5 is **inserted whole** before `## Consequences`;
  every pre-existing section — frontmatter excepted — is byte-identical before and after, digests
  recorded in the session file. ⚠ **A5 deliberately does NOT add a bullet to `## Consequences`**,
  although A2/A3/A4 each did. Those edits were legitimate at the time; this vault's discipline has
  since tightened (A1/A7 proved strict append-only with digests), and adding a bullet would mean
  editing a ratified section in the same act that claims not to. §6 above carries the consequence
  instead. **Recorded as a deliberate divergence from how earlier amendments were folded**, not as a
  silent improvement.

## Amendment A6 — Graduation triggers (T1 · T2), and T2 made evaluable — **proposed 2026-08-29 · rev 2**

*Formalizes the operator's 2026-08-28 phased-replica-first ruling ([[../../who/coordination/coord_2026_08_28_operator_to_hopper_truth_model_phased_graduation_ruling|memo]], committed `ac0f338`), which named the triggers and assigned this amendment to this pen. Answers Ilmarinen's two 2026-08-28 memos — [[../../who/coordination/coord_2026_08_28_ilmarinen_to_hopper_t2_has_already_fired_for_three_graphs|T2 has already fired]] and [[../../who/coordination/coord_2026_08_28_ilmarinen_to_hopper_ff86_measured_and_the_third_population|F-F86 measured · the third population]] — whose only `ack_required` was §4: rule on the replicas that carry a build home, so they do not sit unruled while both desks assume the other holds them. Ratification: **decision** = A6 as written **at rev 2** · **ratified-by** = _pending operator_ · **date** = _pending_ · **status** = `proposed`.*

> **⛔ rev 2 (2026-08-29) — revised in place before ratification, at the operator's RCC gate.** A6 has never been stamped, so this is not an edit to ratified text; the precedent binding A3/A4/A5 does not reach it. **Four changes, all against rev 1's own author:**
> **(i) §3 no longer transcribes a population table into a binding clause** — the practice ADR-016 rev 3 was corrected for two days earlier (**F-P7b-an**). Membership now comes from the instrument at read time; the figures survive as a dated **non-normative** snapshot.
> **(ii) §2's verdict set was not total** — a landed replica with carriage, Actions **on** and zero runs matched **no** verdict (**F-P7b-ao**). Fixed, adopting Ilmarinen's `REPLICA_ACTIONS_ON` for the state rev 1 had no name for.
> **(iii) §4's T3 is WITHDRAWN.** The case it was invented for was misclassified: **A2 §1 binds graduated repos and `Inference.aDNA` has not graduated.** ⚖ This **contests the operator ruling's nominated first candidate** and says so in §4.
> **(iv) §3.2 — a named exception now requires operator ratification**; rev 1 let a graph exempt itself.
> ⭐ **(i) and (ii) were both surfaced by peers, not by this desk**: the RCC gate found (i) and (iv); Ilmarinen's [[../../who/coordination/inbox/coord_2026_08_29_ilmarinen_to_hopper_the_latent_seven_hold_a_landed_repo|2026-08-29 memo]] (F-F93) forced (ii) and §3.1. **Rev 1 was false inside 24 hours, in the clause that named itself binding.**

**The finding, in one line: the ruling's own premise was already false at the instant it was ruled, and nothing in the fleet could have noticed.** The ruling grounds T2 on Ilmarinen's CI_BRICK reasoning — *"a replica is a distribution substrate, never a build home"* — while **ten enrolled replicas carried workflow objects that day** and three had already run builds. That is not a defect in the ruling; it is the defect **A4 §1 was written about**, one axis over: a rule stated as prose, with no mechanism that could ever notice it was untrue. A6's job is to make T2 checkable, exactly as A4 made A3's declared mode checkable.

### §1 — The triggers are named (binding)

D4's graduation path is **unchanged**. A6 names what fires it:

- **T1 — multi-writer.** A second regular writer needs merge authority on the graph. (A replica whose canonical is the operator's working clone makes the operator the merge SPOF.)
- **T2 — build-home need.** The graph's CI must run on the forge. Evaluable per §2.

⛔ **There are exactly two triggers.** Rev 1 added a third ("T3 — regularization"); **rev 2 withdraws it** — see §4, which finds the case it was built for misclassified rather than uncovered. ⛩ *A trigger list that grows to fit its first exception is not a trigger list.*

Each graduation runs the **full ADR-006 D3 host-move ceremony** and mints the **A2 §1 off-forge replica obligation** — the canonical is never single-homed on the subnet forge. **Batch graduation stays rejected** (the ruling's word, kept).

### §2 — T2 is a predicate, not a premise (binding)

A replica has a **build home** iff **both** halves hold:

- **(a) carriage** — the repository contains an object at `.github/workflows/*.y[a]ml` or `.forgejo/workflows/*.y[a]ml`;
- **(b) capability** — the forge reports `actions_unit = 1` for that repository.

⛔ **Each half names its vantage, and they are different desks.** **(a)** is read from the **owning vault's git index** — reachable from any node holding the vault. **(b)** is read from the **forge's own `repo_unit` rows** — reachable only from a desk that reaches the forge. ⚠ So is **landing state**, and that is not a detail: **a class defined on two axes can only be populated from a vantage that reaches both.** Where the two disagree (an index carries a workflow the pushed ref does not, or the reverse), the disagreement is **`INDETERMINATE`** and is reported — never resolved by preferring the reachable half.

**The verdict set is TOTAL over (a) × (b) × runs.** Every combination lands on exactly one verdict, and that property is binding:

| verdict | predicate | meaning |
|---|---|---|
| **`REPLICA_BUILD_HOME`** | (a) ∧ (b) ∧ `action_run` rows **> 0** | **T2 has fired** |
| **`REPLICA_ACTIONS_ON`** | (a) ∧ (b) ∧ `action_run` rows **= 0** | **armed and not yet fired — one push away.** The most time-sensitive class, and the cheapest to fix |
| **`LATENT`** | (a) ∧ ¬(b) | carriage without capability. ⚠ Holds **two operationally distinct populations** — see §3 |
| **`CLEAR`** | ¬(a) | no carriage; T2 cannot fire |
| **`INDETERMINATE`** | any half unread, or the two vantages disagree | never a green, never a zero |

⭐ **`REPLICA_ACTIONS_ON` is Ilmarinen's string, adopted rather than renamed, and rev 1 had no verdict for the state it names.** His [[../../who/coordination/inbox/coord_2026_08_29_ilmarinen_to_hopper_the_latent_seven_hold_a_landed_repo|2026-08-29 memo]] §5 offered a binary — *"our `REPLICA_ACTIONS_ON` **is** your `LATENT`; bump our contract or leave the mapping"* — and **both options were wrong, in our favour and to our cost**: rev 1's `LATENT` required **¬(b)**, so a landed repo with carriage, Actions **on**, and zero runs matched **`REPLICA_BUILD_HOME`** (no — it requires runs), **`LATENT`** (no — (b) holds) and **`INDETERMINATE`** (no — both halves were read). ⛩ **It fell through a classification whose whole purpose was to be exhaustive, and the missing case was the urgent one.** His instrument was more complete than our vocabulary; the vocabulary is ours to fix, so it is fixed here rather than by asking him to rename anything. ⚠ If his instrument's predicate for that string differs from the row above, the difference is **his to state as a mapping** — we ruled a vocabulary, not his contract.

Three properties are binding, and each was bought by a measured failure:

1. **Enumerated, never rostered.** Both halves are read from the **forge** and from **each vault's git index** — never from a list of what we believe is enrolled. This is [[adr_016_publication_boundary|ADR-016]] D6.2's rule, and **Ilmarinen's own first filing broke it and self-corrected** (F-F89): it wrote *"enumerated, not rostered"* over an enumeration of a **stale 22-row roster** while the conf held 71, and reported 3 carriers where there are 10.
2. **⛔ Unmeasured is `INDETERMINATE`, never a green and never a zero.** F-F91, filed by Ilmarinen against his own instrument: an un-namespaced `VAULT_ROOT` resolved to an *archived* vault, so every reading it had ever taken came back `UNMEASURED` — **printed beside `compared=4/4` and folded into a benign bucket.** An absence that borrows a benign verdict is the failure mode this clause exists to forbid. ⭐ **This desk reproduced that class in its own harness while measuring for §3** — see F-P7b-am in the provenance below.
3. **Carriage without capability is still a finding.** `LATENT` is reported, not dropped. A repo that carries workflows and has not landed is one push away from `REPLICA_BUILD_HOME`, and the whole value of measuring before the landing is that the window is still open.

### §3 — Disposition per verdict class (binding)

**⛔ This clause carries no counts and no vault names.** Membership is **whatever the instrument reports at the moment of reading**, never what this file says. *(Rev 1 transcribed a population table into a clause labelled binding — **F-P7b-an**, §provenance. It was false inside 24 hours.)*

**Population** = the rows of Operations' `enrolled_vaults.conf`, **enumerated at read time** (§2.1).

| verdict | disposition (binding) | owner of the act |
|---|---|---|
| **`REPLICA_BUILD_HOME`** | **T2 has fired.** Its own ADR-006 D3 ceremony **or** a named exception (§3.2). ⛔ Never patched off from another desk: stopping a live build a consumer depends on is SO#1 broken by an instrument. | owning graph authors · **operator ratifies** |
| **`REPLICA_ACTIONS_ON`** | **T2 has not fired and is one push from firing.** `has_actions=false` is PATCHed and **read back from the forge's own rows** before any further push; or the graph declares T2 intent and takes the `REPLICA_BUILD_HOME` path. **This is the class where acting is cheapest.** | forge lane, gated |
| **`LATENT` · pre-landing** | Land in the gated order — **create → PATCH `has_actions=false` → read back → push**, the push conditional on the read-back. Graduation intent declared **at enrollment, before the landing**. | forge lane, gated |
| **`LATENT` · already landed** | **Conformant — this is the target state, not a defect.** The standing obligation is that it *stays* `has_actions=false`; nothing re-checks it today, and a repo re-minted by push-create defaults to Actions **on**. | forge lane, standing |
| **`CLEAR`** | nothing owed | — |
| **`INDETERMINATE`** | **Neither cleared nor graduated.** No disposition may be inferred from an unread half. | whoever can reach the unread vantage |

**§3.1 — `LATENT` is two populations and the disposition splits on landing state.** ⛔ Rev 1 glossed `LATENT` as *"carriage, not yet landed"* and instructed the whole class to declare intent *"before its first landing"* — **an act with no *before* left for a replica already landed**. Ilmarinen measured exactly that case (F-F93): a landed replica with carriage, `actions_unit=0`, zero runs — landed in **this clause's own order**, correctly. ⭐ **The model, not the straggler.** The predicate in §2 classified it right; only the prose and the disposition assumed landing.

**§3.2 — A named exception has a ratifier, and it is not the graph claiming it.** The owning graph **authors** the exception with its reason; the **operator ratifies** it under §7.7. ⛔ Rev 1 let a graph declare its own exemption from a fleet rule — **self-certification, the "clean by authorship, not by control" pattern** `F-P7b-ad(i)` was filed against. ⚖ And the count matters: *a rule with a handful of self-declared exceptions is close to not being a rule*, which is Ilmarinen's own warning about three, applied at ten.

**§3.3 — The 2026-08-29 snapshot** *(⛔ **NON-NORMATIVE**; superseded by any later reading of the instrument)*

> Retained **only** as the evidence that the operator ruling's premise was false when it was ruled — deleting it would erase why A6 exists. **It binds nothing.**
>
> Conf **71 rows = 70 `enrolled` + 1 `graduated`**. Carriage **10 of 70** — `aDNALabs` 2 · `Network` 3 · `WGS` 2 · `aDNA` 3 · `Emacs` 6 · `Spacemacs` 3 · `ScienceStanley` 2 · `Exchange` 1 · `TappProtocol` 1 · `wga` 1. Of those: **3 `REPLICA_BUILD_HOME`** (`aDNALabs` 8 runs · `Network` 21 · `WGS` 2) · **1 `LATENT`·landed** (`Exchange`, `actions_unit=0`) · **6 `LATENT`·pre-landing** · `LAVentureGraph` (graduated) carriage 0.
>
> ⚠ **Provenance split**: carriage re-derived at this desk from each vault's `git ls-files`; **capability, run counts and landing state are Ilmarinen's, at a vantage this desk cannot reach.** ⚠ Rev 1 recorded the seven as pre-landing; **6 + 1** is the corrected split.

⇒ **A6 rules dispositions, not a roster.** The ruling's shape — act before landing where it is cheap, ceremony-or-ratified-exception where it has already fired — is what survives; the membership is recomputed every time anyone asks.

⛔ **A6 patches nothing and graduates nobody.** The operator's *record-and-route, patch nothing* binds: patching `has_actions=false` on the three would stop live CI that other lanes depend on today — SO#1 broken by an instrument, which is precisely what Ilmarinen declined to do and was right to decline.

⚖ **Why the three are per-graph decisions and not a blanket exception.** Ilmarinen named the cost of the blanket himself: *"it makes 'a replica is never a build home' a rule with three standing exceptions, which is close to not being a rule."* At ten it is not close — it is one. An exception that must be **declared and reasoned by its owner** survives that; a class-wide one does not.

⚠ **Provenance split, and it matters.** Half of §3's table is ours and half is his:
- **(a) carriage — re-derived at this desk**, from each vault's own `git ls-files`, a **different vantage** from his forge read. All ten vaults and **every per-vault count reproduce exactly.** Denominator likewise: 71 = 70 + 1.
- **(b) capability — his measurement at a vantage this desk cannot reach** (`repo_unit`/`action_run` rows on the box). **Not re-derived here, and not presented as if it were.** His first reading of it was an *inference*, disclosed as one, and he replaced it with a measurement one sitting later — the disclosure is why it can be relied on.

### §4 — There is no T3. An undeclared canonical is a **declaration** defect, and graduation is never its cure (binding)

⛔ **Rev 1 invented a third trigger. Rev 2 withdraws it**, because reading the case at the object showed the trigger was built on a misapplied clause — ours, not the operator's.

**The ruling's rationale, checked against the clause it names.** The ruling nominates **`Inference.aDNA`** as first graduation candidate because *"it is mesh-rd-only, so its 'replica' has no off-forge canonical,"* calling this an existing **A2 §1** exposure. ⛔ **A2 §1 binds a *graduated* repo** — *"the canonical must never be single-homed on the subnet forge"* is an obligation **acquired at graduation**. `Inference.aDNA` has not graduated, so **A2 §1 does not attach to it.** The premise is a clause applied outside its scope.

**Measured at the object, 2026-08-29:**

- `Inference.aDNA` has **exactly one remote — `mesh-rd`; there is no `origin`.**
- Its `how/federation/git/CLAUDE.md` declares **`mesh_remotes:` only — there is no `git_provider:` block at all**, hence no declared `origin`, `visibility`, or `class`.
- Carriage **0** ⇒ T2 cannot fire. No second writer claimed ⇒ T1 has not fired.
- ⚠ Its earlier wrapper assertion — *"local `git init` only at genesis — no remote, nothing pushed"* — was **measured false since 2026-08-08** and is already on this ADR's record (A4 provenance).

⇒ It is not a graduation candidate. **It is a vault with no declared canonical**, which is a different defect with a different repair.

**§4.1 — The rule (binding).** Where a vault's canonical host is **undeclared**, the remedy is to **declare it**, never to graduate. Two lawful declarations exist and both already have homes in this ADR and in ADR-013:

1. **Local-canonical** — a standing order keeping the repo local, its `mesh` replica a permanent distribution surface. **[[#Amendment A3|A3 §4]] already sanctions exactly this, and says D4 graduation never arises for it.**
2. **Remote-canonical** — mint an `origin` per **ADR-013** (private/proprietary → GitHub-private interim), leaving the vault a **conformant replica** with an off-forge canonical.

⛔ **Graduation is the one cure that is not indicated**, and it is worse than doing nothing: graduating makes the forge canonical and *then* mints A2 §1's off-forge obligation — **manufacturing the exposure the ruling set out to cure.** ⛩ *You cannot regularize a missing canonical by making the forge the canonical.*

**§4.2 — Whose act this is.** The declaration is **Pythia's** (`Inference.aDNA`), not ours and not the forge lane's — Rule 10, and the same line §5 holds on the instrument. A6 rules what the lawful shapes are; it does not choose between them for another graph.

> ⚖ **This contests the operator ruling and is flagged as a contest, not folded in as drafting.** The 2026-08-28 ruling names `Inference.aDNA` as the first graduation candidate; **rev 2 finds it is not one.** The phased-replica-first model, T1, and T2 are untouched and concurred with — only the nominated first case is disputed, on the ground that A2 §1 was read outside its scope. **§7.7 applies: this is authored for ratification, and the operator may overrule it.**

⚠ **Filed against ourselves, twice over.** Rev 1 built a trigger to accommodate a case rather than checking whether the case was correctly classified — **and the clause it misapplied is in this same file, eleven lines above the one rev 1 cited.** *A new rule invented to fit an example is how a wrong example becomes doctrine.*

### §5 — The enforcement surface: **that**, not **what**

A6 rules **that** T2 must have an evaluable surface, and fixes its **verdict vocabulary** (§2). It does **not** specify the instrument's shape, language, contract version, or where it lives.

Ilmarinen has built one — `check_replica_actions_posture.sh` (his tree; enumerates from the forge and classifies against the conf, never the inverse; names `forge_only` and `conf_only` rather than dropping them; **reports and never refuses**). ⭐ Its `conf_only` handling already encodes A2 §2 correctly: an enrolled row with no replica is an **error**, never a graduation, *because absence can never distinguish the two.*

⛔ **The pen is his, and this clause exists to say so.** A4 §4 declined to specify the conf's serialization because that was Operations' pen; the same line holds here. **Taking the pen because we were the ones asked to rule is the failure mode A4 §4 already named** — and a second predicate authored at this desk would be exactly the *fourth number* problem our own send-boundary header argues against.

**§5.1 — The vocabulary question, answered (rev 2).** He asked whether `REPLICA_ACTIONS_ON` should be renamed to our `LATENT` (a contract bump) or left as a documented mapping. ⭐ **Neither: his string is adopted into §2's vocabulary, because the two are not the same predicate and his named a state ours could not express.** ⛔ **No contract bump is owed, and no rename is requested** — a verdict string is a published contract read by runbooks and peers, and his reason for not renaming it unilaterally was the correct one. ⚠ Where his instrument's predicate for that string differs from §2's row, **the mapping is his to state**; we ruled a vocabulary, not his implementation.

### §6 — Consequence (carried here, per A5's precedent)

Operations' runner gains a **third reported axis** if it chooses to surface T2 posture beside A2 §3's `enrolled n · graduated g · held h` and A4 §3's mode split — **their pen, not sequenced by us.**

The `LATENT`·pre-landing and `REPLICA_ACTIONS_ON` classes acquire obligations that did not exist before this amendment. ⛔ **They land on the forge lane's runbook, not on the owning graphs' desks** — the operator's 2026-08-29 routing ruling, recorded here rather than left implied, **because an obligation nobody was told about is the failure this campaign keeps finding.** A graph learns of its own class at its next enrollment touch; no broadcast is owed, and that is a decision with a reason rather than a silence.

*(A6 adds no bullet to `## Consequences` — A5's discipline, for A5's reason: an amendment that edits a ratified section in the same act that claims append-only is not append-only.)*

### A6 provenance — four findings against ourselves, four records for peers

- **⛔⛔ F-P7b-an — rev 1 §3 transcribed a population table into a clause labelled `(binding)`, two days after the operator ruled against exactly that.** [[adr_016_publication_boundary|ADR-016]] rev 3 struck its figures and now **cites `census_public_carriers.sh`** because the allowlist number moved three times in one sitting; its §Consequences states figures are read from the instrument *"at the moment it is written, never quoted from this file."* Rev 1 §3 then froze **3 / 7 / 60 / 1** with per-vault workflow and run counts into binding text — **and §3's own body said the seven would land**, i.e. it was authored knowing the table expired. ⭐ **It was false inside 24 hours** (F-F93, below). ⛩ *The rule was learned, written down, ratified, and then broken by its own author in the next document* — which is the strongest argument in this file that a discipline held only in prose is not held at all. §2 had already made the classification a **predicate**; §3 froze one evaluation of it and called that doctrine.
- **⛔ F-P7b-ao — rev 1 §2's verdict set was not total, and the missing case was the urgent one.** `REPLICA_BUILD_HOME` required `action_run` rows **> 0**; `LATENT` required **¬(b)**; `INDETERMINATE` required an unread half. ⇒ a **landed replica with carriage, Actions ON, and zero runs** matched **none of the three** — the *armed but not yet fired* state, one push from becoming a build home and the cheapest of all to fix. ⭐ **Found by reading Ilmarinen's §5 vocabulary question**, which offered a binary (rename his string, or map it) on the premise that `REPLICA_ACTIONS_ON` **is** our `LATENT`. **Both his options were wrong in our favour**: the strings are not synonyms, and his instrument was more complete than our vocabulary. ⛩ *A classification whose stated purpose is exhaustiveness had a hole, and it took a peer's question about naming to find it.*
- **⛔ F-F93 (Ilmarinen's, taken) — one of rev 1's seven `LATENT` graphs was already landed**, correctly, in the order §3 makes binding: `Exchange.aDNA`, present on the forge with `actions_unit=0`, `is_empty=false`, zero runs. Rev 1 §3 bound the whole class to *"declare intent before its first landing"* — **an act with no *before* left for that repo.** ⭐ **The one is the model, not the straggler**, and his framing is the durable half: **landing state is forge-side, the same kind of fact as capability** ⇒ *a class defined on two axes can only be populated from a vantage that reaches both* — which §2's own vantage split says ours does not. Folded as §2's vantage clause and §3.1's split.
- **⛔ F-P7b-am (carried from rev 1) — our own carriage measurement first printed `enumerated 71 · carrying=0`**: a correct denominator with a completely false numerator, from a loop in which command resolution failed. Caught **only** by a positive control run against a known carrier **before** the number was used. **F-F91's shape** — an instrument printing a benign value it never measured — **in our own harness, in the same hour §2 was drafted forbidding it.**

- **⛔ F-P7b-al — `ADR-014 A4 §5` does not exist, our own wrapper cited it twice, and it survived every read because *a real `A4 §5` lives in a different ADR*.** ADR-014's A4 runs **§1, §1a, §2, §3, §4** — there is no §5. Yet `how/federation/git/CLAUDE.md`, committed by this vault at `ac0f338`, carried *"ADR-014 A4 §5 mirror"* **twice**, and Berthier's wave memo is titled for it; his §2 resolves it correctly to *"per **spec** §5"* — a section of Operations' `spec_freshness_mode_conf_shape_s221`, never of this ADR.
  ⭐⭐ **The reason it is the hard class, measured rather than supposed: `ADR-011` A4 §5 is real, load-bearing, and cited in ~15 artifacts in this tree** (*"Content is not execution, and presence is not content"* — the honest-vs-deceptive distinction the hook, the census, and two inventories all turn on). So *"A4 §5"* is a **familiar and valid citation at this desk**, and a reader who knows it will recognise the shape and never check the ADR it is attached to. ⛩ **A wrong pointer that collides with a right one somewhere else does not read as broken — it reads as known.** That is why four artifacts carried it and none of the readings caught it; a citation pointing at *nothing* would have been found on the first read-back.
  ⭐ The obligation itself is real and is **A4 §1**: *"…and mirrors it in the owning graph's `git/` declaration."* ⛔ **A4's ratified text is not edited** (this file's standing precedent, applied to A3 §4 and to A4's own `proposed` heading); the correction lives here, and the **wrapper's comment** is what gets fixed, since it is ours and unratified. **The substance was right the whole time** — Berthier's block was measured from our live remote and our conf row, and our applied `active_co_development` was re-verified against the conf this sitting and **agrees**. Only the citation was wrong, which is the half nobody was checking.
- **⛔ F-P7b-am — our own measurement returned a confident `carrying=0`, and it was a broken environment, not a result.** The first pass at §3's carriage table ran the predicate inside a `while read … done < conf` loop; every `git` call returned empty and the run printed **`enumerated 71 · carrying=0`** — a well-formed total, a correct denominator, and a completely false numerator. Caught only because a positive control was run against a known carrier **before** the number was used, at which point the same predicate standalone returned 2. Diagnosis: command resolution failed inside the loop (`basename` reported *command not found* on the same line), so the zero was the environment, not the tree. ⛩ **This is F-F91's shape — an instrument printing a benign value it never measured — reproduced in our own harness, in the same hour we wrote §2.2 forbidding it.** It is the fifth instance of the class this campaign has recorded and the first found by a control we ran on ourselves rather than by a peer.
- **⭐ F-F89 was found by a peer, not by its author's review.** Hermes named the third population from `Exchange.aDNA`'s side, `ack_required: false`, asking for nothing; Ilmarinen credits it in the open. Second time in three sittings a peer's memo has found the blind spot in an instrument — and the same relationship in which our own census was refuted twice. **Recorded because the pattern is the finding.**
- **⭐ D3 gains a carrier class, from Berthier.** ADR-016 D3 names correspondence and session history; his corpus measures `how/campaigns/` at **334 occurrences / 110 files**, his single heaviest leg, which D3's *reasoning* covers (*"carrying other graphs' operational detail is their normal content"*) and whose *clause* does not list it. Offered by him as an addition, not a correction, and **taken as one**.
- **⭐ The D6.3 instance on the "20", and it is about us.** Our struck §Context figure reproduces exactly at his desk — and it is a **file** count on the narrowest predicate, carried in a sentence about *"carrying the address."* The number was never wrong; the sentence around it was. **Third independent instance of the class rev 2 names, five days after we wrote the clause prohibiting it.** Recorded; ADR-016's ratified text is not edited.
- **Append-only discipline, proved not asserted.** A6 is **inserted whole** before `## Consequences`; every pre-existing section — frontmatter excepted — is byte-identical before and after, digests recorded in the session file.

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
