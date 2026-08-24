---
type: session
session_id: session_stanley_20260824_git_p7b_the_field_that_was_never_bumped
date: 2026-08-24        # eighteenth sitting (FOURTH on this local date). Act timestamps UTC.
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — discharge the two debts that are OURS: A1 §3's ledger promise, and the wrapper-contract version field that has never been bumped"
door: "§1 open sweep + lease · §2 re-measure licences AT THE WINDOW · §3 license-state roster onto the ledger · §4 ADR-004 A1 (annotate-then-stamp) · §5 release ledger + refresh skill · §6 census --vault + chmod · §7 spec + doctrine · §8 harness both arms + discrimination · §9 verify · §10 close"
plan: please-read-the-claude-md-snazzy-waffle
head_at_open: b321223
head_at_close: see_tracking_commit   # authoring commit follows this file's move to history
inbound_at_open: 0      # `git status --porcelain who/coordination/` empty at open. Recorded as MEASURED, not assumed.
inbound_at_close: 0     # ✅ SWEPT AT CLOSE, NOT INHERITED. `git status --porcelain who/coordination/` -> 0 untracked. F-INTAKE-04 did NOT fire — recorded as MEASURED-AND-UNCHANGED, because "no new inbound" is only a finding if someone looked.
leases_at_open: "ours 0 (`how/sessions/active/` held only .gitkeep before this file). Peer leases NOT probed — this sitting sends nothing, so there is no act for a probe to gate. Recorded as deliberately-unprobed rather than as zero."
outward: false          # ⛔ ZERO outward acts — PROVEN BY MEASUREMENT, not asserted: 0 files modified anywhere outside Git.aDNA in the session window (mtime sweep, -newermt). No push, no forge call, no peer-vault file, no probe --exec.
operator_rulings:
  - "scope = BOTH ours-debts — A1 §3's ledger enumeration AND the wrapper-distribution mechanism. (AskUserQuestion, plan gate)"
  - "distribution shape = OPERATE THE EXISTING CONTRACT (bump `federation_ref.version`, ship refresh + verifier) — NOT reference-not-copy. The reference-not-copy shape was offered and declined; it is not re-litigated here."
  - "posture = FULLY NON-OUTWARD. Author, measure, stage. The remedy memo to Hestia/Berthier waits until we hold a remedy rather than a plan for one."
  - "ADR-004 Amendment A1 = RATIFY at this gate. §7.7 exercised — the plan named the amendment, its five clauses, and an explicit hold-instead option that was not taken."
signature_basis: "§7.7 on ADR-004 A1: plan-gate approval, primary account, in-session, against a plan document that carried A1's five clauses and their reasoning in full before approval — including clause 5's statement that NO blocking gate is wired to it. ⚠ This is a PLAN-GATE ACCEPTANCE OF A RECOMMENDATION, not a per-clause reply to a ratification packet — recorded so a later reader sees which of the two happened rather than inferring it. ⭐ The plan offered an explicit `hold it as proposed` escape and stated that everything else ships either way; the operator did not take it. That is a stronger basis than silence, and it is why this stamp is not read as assumed consent. NOT transcribed status; NOT held on a peer's receipt."
scope_judgment_declared_at_gate: "The operator chose `operate the existing contract`. That phrasing presumes a contract exists to operate, and the plan established it does — spec §7 already carries `federation_ref.version`, `version_policy: minor`, and `pinned_at_commit`. I read the ruling as authorizing the ADR amendment that gives that field an OWNER and a BUMP TRIGGER, not merely a release note — because a version field with no named bumper is the same shape as ADR-013 D1's FOSS predicate with no named checker, and A1 was authored one sitting ago precisely to close that shape. Shipping a release row while leaving the field ownerless would reproduce the defect inside its own repair."
declared_files:
  - what/inventory/foss_predicate_measurement.md    # §2 — re-measurement APPENDED as a second dated reading; the 03:52Z reading is NOT overwritten
  - what/inventory/disposition_ledger.md            # §3 — the license-state roster (A1 §3's discharge)
  - what/decisions/adr_004_provider_contract_interface.md   # §4 — Consequences annotation THEN the A1 stamp. Ordering is load-bearing.
  - what/inventory/wrapper_contract_releases.md     # §5 — NEW: the contract-version ledger
  - how/skills/skill_git_wrapper_refresh.md         # §5 — NEW: the consumer-run refresh procedure (upstreamable via Rosetta, NOT written to .adna/)
  - how/tests/census_wrapper_copy.sh                # §6 — --vault mode reusing the EXISTING classifier + chmod +x
  - what/specs/spec_gitops_provider_abstraction.md  # §7 — §7/§10, following the ADR
  - what/doctrine/doctrine_gitops_block.md          # §7 — item 9, 0.2.0 -> 0.3.0
  - how/tests/dryrun_gitops.sh                      # §8 — new cases, BOTH arms
  - STATE.md                                        # §10
  - CHANGELOG.md                                    # §10
declared_peer_writes: []                            # ⭐ EMPTY, AND STATED RATHER THAN OMITTED (F-F23). Nothing is written outside this vault.
out_of_scope:
  - "⛔ ANY outward act. No push, no forge call, no repo created, no visibility flip, no mirror configured, no peer-vault file drop, no `probe_peer_state.sh --exec`."
  - "⛔ repairing the 35 P3-skeleton / 2 v2.0.0 foreign wrapper copies (Rule 10) — theirs to replace. This sitting makes replacing them PERFORMABLE and VERIFIABLE; it does not perform them."
  - "⛔ remediating the 21 unlicensed repos. A1 §3 enumerates; A1 §2 assigns the license CHOICE to Berthier as an org/legal call, `asked, not taken`. Writing a LICENSE into any repo — including this one — is out of scope."
  - "⛔ editing ADR-013 A1's Consequences bullet to say §3 is now discharged. It is a DATED record of the state at the stamp; a historical measurement is falsified, not improved, by editing it. The discharge is recorded elsewhere."
  - "⛔ any clause-text edit to RATIFIED ADR text — ADR-004's D1–D7 are `accepted` and are NOT edited; A1 extends §7's wrapper schema and is the only thing stamped."
  - "⛔ any `.adna/` edit (Standing Rule 1). The refresh skill is AUTHORED here and shipped by Rosetta."
  - "⛔ wiring any blocking gate to A1 — clause 5 forbids it, and shipping an enforcing check ahead of ratification is the exact defect ADR-013 A1's Consequences recorded against this desk."
stop_conditions:
  - "the re-measurement disagrees with 18/19 Codeberg or 3/4 public ⇒ STOP and surface. Building the roster on a figure that has moved would sign a falsified number into an inventory — A1's own `43 vaults` correction is the precedent."
  - "`census_secret_gate.sh` moves off 0 dangling / 0 UNCLASSIFIED ⇒ STOP. The INSTALLED surface must not move during a DISTRIBUTED-surface sitting; if it did, something was touched that should not have been."
---

# Session — the field that was never bumped

## §0 · Why this sitting

The campaign's critical path is P7a's flip, and **every open precondition on it belongs to another
lane.** What is actionable is the debt register's two **ours** rows, and both are non-outward:

1. **ADR-013 A1 §3** — ratified 2026-08-24, promising the already-placed unlicensed set onto the
   disposition ledger with an explicit `license_state`. The ledger carries **zero**. *A promise inside
   ratified text is a debt from the instant it is signed.*
2. **F-P7b-o's remedy** — 35 of 38 fleet wrapper copies are the fail-open P3 skeleton, so Hestia's §C
   retirement condition (*"consumers re-install at contract 2.1.0"*) **cannot be cleared by the remedy
   named beside it.** The act that would clear it is each vault's under Rule 10 — but making that act
   performable is ours, and it had no owner.

⭐ **The reframe, found by reading at the object rather than trusting the debt register's wording.**
Spec §7 already specifies `federation_ref.version`, `version_policy: minor  # review on bump`, and
`pinned_at_commit`. The fleet is not stale because distribution was never designed — it is stale
because **that field has never once been bumped.** The hook went `216aaca2` → v2.0.0 → v2.1.0 with the
contract pinned at `0.1.0` throughout. There is no missing mechanism; there is an **unoperated** one.

⛩ **That is the same defect class ADR-013 A1 closed one sitting ago** — a correct rule with a missing
half — which is why ADR-004 A1 deliberately mirrors its shape instead of inventing a new one.

## §1 · Open sweep (measured, not inherited)

| Reading | Value |
|---|---|
| `HEAD` at open | `b321223` — previous sitting closed cleanly |
| Working tree | clean |
| Inbound (`who/coordination/` untracked) | **0** |
| Our leases | 0 (`.gitkeep` only) |
| Peer leases | **deliberately unprobed** — nothing is sent, so there is no act to gate |

The operator opened with *"we had a crash."* The crash cost the conversation, not the vault: `b321223`
is a session-close commit and the tree is clean. **Recorded because a crash is a reason to verify
state, not a reason to assume it was lost.**

---

*(Sections §2–§10 are written as the work lands.)*

## §2 · Slice A — A1 §3 discharged

**Re-measured at the window `2026-08-24T21:35Z`.** Both headline figures **reproduce exactly**:
18/19 Codeberg, 3/4 GitHub-public, **21 of 23** published repos unlicensed. SPDX ids re-read at the
object (`git show HEAD:LICENSE`): `Exchange` MIT · `aDNA` MIT · `Astro` BSL-1.1. Recorded as
**MEASURED-AND-UNCHANGED**, and appended as **§7** — the `03:52Z` reading is preserved unedited,
because it is still the reading ADR-013 A1 was signed against.

⭐ **§6 of that document had already stated the requirement I was following** — *"re-measure
immediately before, never from this document."* The re-measurement was not extra diligence; it was the
document's own instruction, which nobody had executed.

**§6's divergence caveat CLOSED for the last-known remote state.** The predicate was run at each
**tracking ref** as well as at local `HEAD`: **all 22 repos with upstreams agree** (`0|0` ×20, `1|1` ×2);
none is `behind`. ⛔ Residual limit stated rather than glossed: a `LICENSE` added server-side *since the
last fetch* is invisible to both refs, some tracking refs are weeks stale, and **no fetch was performed**
(non-outward). The *fetched-but-unmerged* class is excluded; the *never-fetched* class is not.

⛔ **New denominator defect — `Oration.aDNA` has a Codeberg `origin` and NO tracking branch**, so any
sweep keyed on `@{upstream}` drops it silently. ⭐ Same class as §3's `Videos.aDNA` (no remotes at all),
found by a *different* probe — **two instruments, two blind spots, and neither would have found the
other's case.** Carried on its roster row as `upstream: none` rather than dropped or assumed.

**Roster landed**: 23 rows · 21 `unlicensed` · 2 `licensed:<SPDX>` · **0 rows without a value**.
`pending_declaration` is declared at **n=0** (ADR-014 A4 §1a's discipline — *a value that only exists
once someone needs it is a value nobody writes*). `Astro.aDNA` recorded as the **licensed control**, not
one of the 23. `Git.aDNA` listed **by name** rather than found in the set.

⚠ **Finding against my own plan's verifier.** The approved verification criterion was
`grep -c license_state … → 23`. It returns **6**, and would return 6 for *any* number of rows —
`grep -c` counts matching **lines**, and the token appears only in headers and prose. ⛔ **A criterion
keyed on the presence of a NAME rather than the MECHANISM it claims to measure — ADR-011 A6, one
sitting after A6 was ratified, inside the plan that discharges A1 §3.** Replaced with a row count **plus
a count of rows carrying NO value**, ⭐ *the second being the load-bearing half: a roster's defect is a
row with no value, and a check that counts only values present cannot see a row that has none.*

## §3 · Slice B — the contract gets an owner

⭐⭐ **The root cause is one layer deeper than the debt register recorded.** `federation_ref.version`,
`version_policy`, `pinned_at_commit` entered the **spec** at P3 — **ADR-004 D4's binding schema has no
version field at all.** *A spec field with no ADR behind it has nobody obliged to operate it*, so
"never bumped" is not an oversight that befell a rule; it is what an unbound field does by default.

⭐ **And the template we cited already contained the half we dropped.** ADR-004's Consequences say
*"the III `iii/` wrapper is the template."* `III.aDNA`'s ADR-002 **binds** its version policy in a
decision, defines `minor` as *"consumer reviews when III bumps… reads the CHANGELOG diff"*, and keeps
its amendment history as the audit log — and its Context names the problem it solved: ⛩ ***"consumers
can't tell when III changes"* — verbatim the condition of our 35.** We copied two schema lines and left
behind the decision, the signal, and the review obligation.

**Shipped**: **ADR-004 Amendment A1 `accepted`** (5 clauses; **3 deletions, all frontmatter**; D1–D6
**md5-identical** `0c421b75…`) · **release ledger** `0.2.0` · **`skill_git_wrapper_refresh`** ·
**`census_wrapper_copy.sh --vault`** · spec **§7.1 + §10** · doctrine **item 9** (`0.2.0`→`0.3.0`).

⛔ **A1 §5 wires NO blocking gate** — the applied correction of ADR-013 A1's own Consequences finding
that a check shipped ahead of its ratification inverts the order §7.7 exists to impose.

### ⛔ F-P7b-p — the SHIPPED hook asserts a denominator that does not exist

`pre-push.gitleaks.sh:24`: *"44/44 wrapper-carrying vaults still hold that shim, so nothing was
dangling."* Measured: **59–61 wrapper-carrying vaults, 54 with the shim, 5 without** — `Emacs` ·
`Fluxer` · `GOTFN` · `RealityScan` · **`WGS`**. ⭐ **`WGS` is on that list because they fixed it** — the
vault that most conclusively disproves the sentence is the one that solved the problem it describes.

⛔ **The defect is the inference, not the arithmetic**: a universal claim licenses a *safety*
conclusion, and the conclusion's real evidence is a **different instrument** (`census_secret_gate`'s
independent 0-dangling). *A number that does not establish the claim beside it is decoration that reads
as support.*

⛔⛔ **And the correction is BLOCKED — the more important half.** The hook's md5 is recorded as
**evidence inside ratified text** (ADR-011 A6's Consequences: `a1288f73… → 04e6a745…`). Editing **one
comment character** changes the digest and falsifies a ratified record. ⛩ **Nobody designed this
coupling**: A6 pinned a digest to make a fix verifiable and thereby made the artifact *immutable in
practice*. Three exits recorded (amend · digest-as-role · carry); **held at C, said out loud**, on the
debt register as ours. It is an operator/ADR call, not a tooling one.

## §4 · Slice C — the harness, and two false results caught in it

**73 → 93**, both arms: sabotage required to fail (R1/R2/R3), controls required to pass (R4/R5), a
meta-control that the skeleton fixture is *genuinely* fail-open (R9), and R6 separating **NOT_A_CONSUMER
from COPY_ABSENT** — *reporting a non-consumer as a missing copy would inflate the refresh population
with vaults that owe nothing.*

⚠ **False red #1 — the instrument reported its own owner as out of date.** A naive
`grep federation_ref:` matched the **consumer template** inside `Git.aDNA`'s own wrapper. ⭐ *"Inside a
fenced block" does not discriminate* — verified across `aDNA`/`Jupyter`/`aDNALabs`, all of which fence
their **live** declarations identically. Keyed on mechanism instead: **the source vault is the one whose
wrapper dir IS the canonical artifact.** R7 is the regression guard.

⛔⛔ **False GREEN #2 — my first discrimination proof was worthless and looked overwhelming (19 red vs
0).** The regressed copy was placed in a **temp dir**, and the instrument derives `$CANON`/`$LEDGER`
from its own location ⇒ it bailed at *"canonical artifact not readable"* **before classifying anything.**
Every wrapper-refresh case failed for one irrelevant reason. ⭐ **F-P7b-d's exact shape** — sabotage
cases "failing" because the check was never reached — ⛩ **and the tell was that R1 went red although the
regression never touched skeleton classification.** *A discrimination result that is too uniform is
evidence about the harness, not about the mechanism.* Rebuilt **beside the original** so `$HERE`
resolves identically, with a guard requiring the regressed copy to **reach classification**.

**True result: 6 red** — R2 · R3 · R3b · R6 · R6b · R7, precisely the cases guarding the four removed
mechanisms; real instrument stays **93/0**. ⚠ **R2b survived** (exit non-zero) because a skeleton still
yields `rc=1` by a *different* route — ⭐ *an exit code is a proxy; the output is the measurement*, the
third sitting running to earn that line, now on a third instrument.

⚠ **Also folded**: `WCEN_OVERRIDE` (so the proof is repeatable without mutating the file under test) and
`_VAULTROOT` derived from `BASH_SOURCE` — `_HOMEDIR` is `$PWD`, so a harness run from elsewhere would
have pointed R7 at the wrong vault. *A test that silently examines the wrong object is worse than no test.*

## §5 · Verification (numbers, not adjectives)

| Check | Result |
|---|---|
| `dryrun_gitops.sh` | **93 pass / 0 fail** (was 73) |
| `census_wrapper_copy.sh --meta` | 9/9, both arms |
| discrimination vs regressed copy | **6 red**, exactly the guarded mechanisms |
| ⚠ first discrimination attempt | **19 red — INVALID**, recorded not discarded |
| `--vault` × 5 states | `V2_1_0`/skeleton/`V2_0_0`/absent/non-consumer → rc `0·1·1·1·3` |
| `census_secret_gate.sh` | **0 dangling · 0 UNCLASSIFIED — unchanged** |
| licence re-measure | 18/19 · 3/4 · **21/23 — reproduces** |
| roster completeness | **23 rows · 21 · 2 · 0 without a value** |
| `preflight_context_sync.sh` | **7 PASS / 1 BLOCK** — `clean_tree` on this sitting's own 11 declared paths |
| close-end inbound sweep | **0**, measured not inherited |
| **outward acts** | **ZERO — 0 files modified outside `Git.aDNA` in the session window**, by mtime |

## §6 · AAR

- **Worked** — reading at the object twice beat the register: A1 §3's data already existed, and the
  distribution "gap" was an *unoperated* mechanism, not a missing one.
- **Didn't** — my own plan shipped a name-keyed verifier; my first discrimination proof was a false
  green; my first `--vault` reported the source vault as stale.
- **Finding** — **F-P7b-p**: a shipped artifact carries a false universal, **and a digest recorded as
  evidence in ratified text has made that artifact un-editable without an amendment.**
- **Change** — contract version now has an owner, a trigger, a signal, a procedure, and a verifier;
  doctrine item 9 carries it to the fleet; two falsified figures corrected in the propagatable artifact.
- **Follow-up** — **ours**: F-P7b-p's three exits need an operator call; the 35 still need to refresh
  (theirs to perform, now performable). **Theirs**: Berthier's re-keying, Hestia's registry amendment,
  Pythia's cc.

## §7 · Next Session Prompt

> Read `CLAUDE.md` and `STATE.md`. R3/P7b. **ADR-004 A1 is ratified and the wrapper contract is now
> operable at `0.2.0`** — 35 vaults have something to refresh *to*. **Ours and newly named**: **F-P7b-p**
> — the shipped hook asserts `44/44` when 5 wrapper-carrying vaults have no shim, and the obvious fix is
> **blocked** because the hook's md5 is evidence inside ratified ADR-011 A6 text; three exits are
> recorded and the choice is the operator's. Also ours: routing `0.2.0` to the fleet (a memo to Hestia
> and Berthier now that we hold a remedy rather than a plan for one — the previous sitting told them the
> hold had no exit; it now has one). **The P7a flip remains the campaign's critical path and every open
> precondition on it is another lane's.**
