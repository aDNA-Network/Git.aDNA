---
type: decision
adr_id: adr_016
title: "ADR-016 — Publication Boundary (a content predicate on the public repo class)"
status: accepted   # ✅ RATIFIED at rev 3, 2026-08-27, operator §7.7 (plan gate), as a STANDALONE ADR. See §Ratification.
revision: 3        # rev 3 (2026-08-27): rev 2's own correction was wrong — F-P7b-af (the guards excluded `.`, in the census AND in R8's shipped pattern). Figures STRUCK and replaced by a citation to how/tests/census_public_carriers.sh. No decision withdrawn. See §Correction (rev 3).
created: 2026-08-26
updated: 2026-08-27
ratified_by: "operator (Stanley, §7.7, plan gate)"
ratified_on: 2026-08-27
ratified_scope: "D1 · D2 (incl. D2.4) · D3 · D4 (incl. D4.1) · D5 · D6 — standalone ADR; the ADR-013 Amendment A2 framing was offered and NOT taken"
last_edited_by: agent_stanley
joint_with: []
ratifies_at: "operator §7.7 gate"
depends_on: [adr_011, adr_013]
amends: []
supersedes: []
relates: [f_f78, f_f77, adr_007, adr_045]
tags: [decision, adr, adr_016, git, publication_boundary, content_predicate, exposure, f_f78, proposed, p7b, operation_free_harbor, fix_forward, graph_not_instance,
  rev2_correction, struck_not_rewritten, predicate_narrowing, wrong_population, enumerate_dont_roster,
  three_carriers, unfalsified_zero, d6, codeberg_vantage_unknown, branch_hypothesis_falsified]
---

# ADR-016 — Publication Boundary

**Status**: ✅ **`accepted`** — authored 2026-08-26, **ratified 2026-08-27 at rev 3** by the operator
under §7.7, as a **standalone ADR**. D1–D6 are binding. See §Ratification for what changed between
each revision and the signature — twice a peer refuted a figure in the interval before signing, and
both refutations are recorded rather than smoothed away.

> ⚖ **This ADR carries no literal address, and that is the decision demonstrating itself.**
> Every host address in this document is written `<forge-overlay-addr>`, `<mesh-host-b>`, etc. The
> file is committed to a repo that publishes; writing the literal here would add occurrences to the
> very count the ADR exists to stop growing. D4 says the boundary binds the *next* write — this is
> the next write.

## Context

`aDNA-Network/Git.aDNA` has been a **public** GitHub repo since the R1/P5 beachhead, by ratified
decision ([[adr_013_host_role_inversion|ADR-013]] D3 — the open standard's public home). On
2026-08-26 Ilmarinen (`Forgejo.aDNA`) measured it from outside, found it carries the R&D forge's mesh
overlay address, and filed **F-F78**.

**Reproduced here independently against the published commit `b6c070c`, not adopted from his summary:**

| measurement | result |
|---|---|
| occurrences of `<forge-overlay-addr>:<forge-port>` | **31, over 13 files** — his figures exactly |
| repo state | `private=false` · `visibility=public` · **`forks=0`** |
| distinct hosts published | **2** RFC1918 `10/8` · 1 RFC1918 `192.168/16` · 1 loopback · 1 `0.0.0.0` |
| distinct service ports on those hosts | **3** — the forge HTTP port (×31), its SSH port (×5), one app port (×1) |
| key material · tokens · publicly-routable addresses · `ssh user@host` forms | **0 · 0 · 0 · 0** |
| the one credential-shaped string | `$<TOKEN_NAME>@codeberg.org` — **a name, not a value** |

Two findings frame the decision:

1. ⛔ ~~⭐ **`Git.aDNA` is the only public repo in the fleet carrying the address.** `Network.aDNA` (12
   files) and `aDNALabs.aDNA` (20) are **private**; `Forgejo.aDNA` (44) and `Container.aDNA` (26) are
   on Codeberg; `Home.aDNA` (1) has no remote at all; `aDNA.aDNA` is public and carries **0**. So the
   remedy is this vault's alone, and the reciprocal worry — that our outbound memos published the
   address into peers' repos — is **false**.~~ **STRUCK at rev 2 — FALSE. See §Correction (rev 2)
   below.** The count was right and the sentence it supported was not: **three** public repos carry
   the address, and this vault carries **57 occurrences over 17 files**, not 31/13. *(Vantage,
   unchanged and still binding: current visibility measured 2026-08-26/27. A repo private today may
   have been public earlier; this is not a history survey.)*
2. ⛔ **The `gitleaks` A1 gate passed correctly, and should not be "fixed" for this.** There are no
   secrets in these files. `$<TOKEN_NAME>@codeberg.org` is [[adr_007_credential_model|ADR-007]]'s
   broker discipline working exactly as designed — the name transits, the value never does.

⛩ **The gap is that the rule governing the decision is a *publication-boundary* rule, and no
instrument evaluated one because no doctrine stated one.** [[adr_013_host_role_inversion|ADR-013]]
D1–D7 classify repos along two axes — **host** and **visibility** — and carry **no content axis at
all**. The predicate was never missing from the check. It was missing from the doctrine, so there was
nothing for a check to evaluate. That is the durable finding; the 31 occurrences are its first
instance.

## Correction (rev 2, 2026-08-27) — the census counted the wrong population, and asked a narrower question than the sentence it supported

⭐ **Caught by Ilmarinen (`Forgejo.aDNA`) before ratification, not after**
([[coord_2026_08_26_ilmarinen_to_hopper_your_census_has_two_false_zeros|his memo]]). He re-measured
at the public remote on each repo's **own default branch** and found `aDNA.aDNA` carries **1** where
we recorded **0**, and `Canvas.aDNA` carries **2** while being **absent from our table entirely**.

**Re-derived here independently, anonymously, at each repo's own default branch — not adopted from
his summary.** His three rows reproduce **exactly**, down to the file paths.

### C1 — The corrected census

Population **enumerated**, not rostered: every public repo in `aDNA-Network`, both forges.
Three predicates are reported separately because **they are not the same question**, and conflating
them is what produced the error:

| repo | branch | **carries the address** (host) | host **:forge-port** | **RFC1918 class** (= R8's own predicate) |
|---|---|---|---|---|
| `Git.aDNA` | `master` | ~~**57 / 17 files**~~ ⛔ **STRUCK at rev 3 — see §Correction (rev 3)** | **31 / 13** ✅ reproduces | ~~**62 / 20**~~ ⛔ **STRUCK at rev 3** |
| `aDNA.aDNA` | `main` | **1 / 1** | 0 | 15 / 9 |
| `Canvas.aDNA` | `master` | **2 / 2** | 0 | 11 / 8 |
| `III.aDNA` | `main` | 0 | 0 | 2 / 2 |
| `aDNA` | `main` | 0 | 0 | 1 / 1 |
| `adna-legacy` | `main` | 0 | 0 | 1 / 1 |
| `community-policies` · `spacemacs` · `world-genome` | `main`·`develop`·`main` | 0 | 0 | 0 |

⇒ **three public carriers of the address, not one** — and under **R8's own predicate, six.**
*(That conclusion is unchanged at rev 3. The two struck cells are this vault's own row; the carrier
count and the peer rows are unaffected — see §Correction (rev 3) C6.)*

## Correction (rev 3, 2026-08-27) — the corrected census was itself wrong, and the defect was in the gate's own pattern

⭐ **Caught again by Ilmarinen, again before ratification** — he could not reproduce our `57 / 17`,
measuring **66 lines / 20 files** at **our own published commit** with drift and branch-error ruled
out. He declined to theorise a cause and sent the raw per-file table instead. Re-derived here: **his
figure is right, ours was wrong, and the true figure is worse than his correction.**

### C6 — Root cause: the guards excluded `.`, and the pattern went blind (F-P7b-af)

The census predicate was `(^|[^0-9.])<host>([^0-9.]|$)`. Excluding an adjacent **digit** is correct
and necessary — it stops the host matching inside a longer quad. Excluding an adjacent **dot** was
never needed for that, and it failed in three separate directions, all measured:

| defect | mechanism | effect |
|---|---|---|
| **undercount** | the trailing guard **consumes the separator**, so under `grep -o` two occurrences on one line score **1** | occurrences under-reported |
| **false negative (leading)** | a host **preceded by a dot** cannot match | ⛔ **3 files in this tree were invisible** — all three coordination memos, the D3 class exactly |
| **false negative (trailing)** | a host **ending a prose sentence** (`…runs at <addr>.`) cannot match | prose is what memos are made of |

⛔ **And the same guards ship in `sanitize_deny_content.txt` pattern 1 — R8's own predicate.** The
gate D5 creates could not have stopped three of the files it exists to stop. Corrected 2026-08-27 in
the fail-safe direction (guards exclude digits only; the change can add matches, never remove them),
with an 8-arm control in `how/tests/test_sanitize_content_gate.sh`: 4 must-match including both
recovered shapes, 4 must-NOT-match including the longer-quad, loopback, `0.0.0.0` and RFC5737.

### C7 — ⛔ Two units in one table, unlabelled — inside the correction that added D6.3

The rev-2 table above reported `31 / 13` as **lines**/files beside `62 / 20` as **occurrences**/files.
Both were internally correct; neither said which it was, and no reader could tell. **That is D6.3's
own defect, committed in the section that introduced D6.3.** The promoted instrument now reports
occurrences, lines and files as **three columns** and never collapses them.

### C8 — ⇒ The figures leave this document

The allowlist number moved **three times in one sitting** — 31 (rev 1's predicate), 62 (rev 2's), 75
(the corrected gate predicate). Each was produced by a script no other desk could run.

⇒ **Ruled at the operator's §7.7 gate: this ADR cites the instrument, not the numbers.** The census
is [[how/tests/census_public_carriers|`how/tests/census_public_carriers.sh`]] — promoted from a
scratchpad to a vault instrument at this revision, with a `--meta` control it never had, carrying the
D6.4 known-positive control and the redaction discipline. **Re-run it; do not quote this table.**
The rev-1 and rev-2 figures stay struck-and-visible above because they are the record of two errors,
not a source to cite.

⚠ **What survives untouched:** `31 / 13` for the `host:port` predicate reproduces at both desks and
at both commits — it was **never** the wrong number, only the wrong number *for the sentence it
supported* (C2). The carrier count of **three**, the six-under-R8 figure, Ilmarinen's separately
sustained narrower claim, the `adna-legacy` negative result, and the Codeberg `UNKNOWN` are all
unaffected: none of them depended on this vault's own row.

### C2 — Two root causes, and only one of them is a measurement error

1. ⛔ **Predicate narrowing.** The measurement asked *"who carries `<forge-overlay-addr>:<forge-port>`"*
   — see the table above at §Context — and the conclusion generalised to *"who carries the address."*
   Both other repos carry the **bare host with no port attached**, so under the stated predicate their
   **0 is arithmetically correct**. ⛩ **The number was right; the sentence it supported was not.** A
   correct measurement answering a narrower question than the claim it is cited for leaves no residue
   for a reviewer to catch — which is precisely why it survived to a ratification packet.
   - ⚠ **A branch-mismatch hypothesis was raised and FALSIFIED, and is recorded because it was wrong**:
     `aDNA.aDNA` has only `main` and `Canvas.aDNA` only `master`, so a mis-branched query would have
     **errored**, not returned a quiet zero. This was not the `\b`-grep class recurring.
2. ⛔ **Wrong population.** The censused set was the **destination roster of seven inbound memos**,
   never an enumeration of public repos. `Canvas.aDNA` was not measured wrongly — it **was never in
   the set**. ⛩ **Better measuring cannot fix this.** A census over the wrong population is wrong at
   full precision, and reports its wrongness with the same confidence as a right answer.

### C3 — ⛔ The ADR's number and its gate's number are different measurements

§Context reports an **instance:port** count (31). `sanitize_deny_content.txt` ships a **class**
predicate (any RFC1918 address). Under the gate's own predicate this repo carries ~~**62 occurrences
over 20 files**~~ ⛔ **STRUCK at rev 3 — the gate's pattern was itself defective (C6); re-measured
at 75/23 after repair, and superseded entirely by C8's ruling that this document cites the
instrument rather than a figure** — and **six** public repos match rather than one. **A reader of
this ADR cannot predict what R8 will do from the figures in this ADR.** Recorded here, at
`proposed`, because it bears on the allowlist decision that follows ratification — an allowlist
scoped to the 31 would not cover what the gate actually stops.

⭐ **Rev 3 sharpens this rather than softening it.** The sentence above was written as a warning
about *two predicates disagreeing*. The real case was worse: the gate's predicate was **wrong**, so
the allowlist would have been sized to a number that was neither of the two on offer. The warning
was right and its stated reason was incomplete — which is C6's finding applied to C3 itself.

### C4 — What survives unchanged

- ⭐ **Ilmarinen's narrower claim is sustained, and separately**: none of the three non-`Git.aDNA`
  occurrences is his. `aDNA.aDNA`'s is Rosetta's own cohort manifest; Canvas's two are a federation
  wrapper and **Vulcan's** memo to Mondrian. **His mail published nothing anywhere else** — the
  finding about his correspondence stands exactly as written, and is not damaged by the census being
  false. He asked for that split explicitly and he is right to.
- **`forks=0` holds where it matters.** `adna-legacy` carries **3 forks** — the only forked repo in
  the population — and **0** occurrences of the address. Negative result, recorded as one: the fork
  worry is empty for this instance.
- ⚠ **Codeberg is NOT measured, and must not be recorded as zero.** `orgs/aDNA-Network` returns
  **404 `HasOrgOrUserVisible`** anonymously, while `orgs/aDNA-Network/repos` returns **HTTP 200 with
  an empty array**. Read naively that is "0 public repos"; the truthful reading is **"the population
  is not visible from this vantage."** A control org returns 5 on the same endpoint, so the
  instrument works. *Empty-because-none and empty-because-invisible are different claims, and this
  endpoint renders them identical.* The prior 404-anonymous readings of `Forgejo.aDNA` and
  `Container.aDNA` are consistent with this and stand.

### C5 — Consequence for the decisions below

**D1–D5 stand.** The doctrine gap they close is *unaffected* — ADR-013 still carries no content
axis, and that finding never depended on the count. But the struck sentence's clause *"the remedy is
this vault's alone"* is **false**, and two decisions inherit from it:

- **D4** (fix-forward on already-published content) now binds **three graphs**, not one. Each
  carrying graph owns its own remedy; this vault cannot discharge `aDNA.aDNA`'s or `Canvas.aDNA`'s.
- **D2.4** (*a boundary declared by the graph that owns the fact binds every graph that quotes it*)
  is **strengthened, not weakened**: it was authored against a single quoting graph and the corrected
  census shows three. The clause was right for a reason wider than its author knew.

⇒ **D6 is added below** to make that explicit rather than leave it inferred from a struck sentence.

## Decisions

### D1 — A host class says where a repo lives, not what may be in it (binding)

ADR-013's classes (`P-released` · `P-dev` · `I` · `I-strict` · `R` · `L`) are **placement**
decisions. They are hereby declared **silent on content**, and the public class (`P-released`, and any
repo with `private=false` on any provider) gains a **content predicate**: material in an unpublishable
class (D2) must not be written into a repo that publishes.

This is additive. **No ADR-013 decision text is edited, and no ADR-013 classification changes.**

*(Framing alternative, left to the §7.7 ruling: this could equally be authored as ADR-013 Amendment
A2. It is filed as its own ADR because it introduces an axis ADR-013 does not have, and because a
content rule will bind graphs that never read a host-policy ADR. If the operator prefers the
amendment form, the text below transposes unchanged.)*

### D2 — The unpublishable classes, generalised from the instance (binding)

Not publishable into a public repo:

1. **Infrastructure addressing** — overlay/mesh host addresses, service ports, and the host↔service
   mapping between them. ⚖ Calibrated: RFC1918 on a private overlay is **not** internet-routable and
   is **not** a credential. It is *reconnaissance material* — it tells a reader which hosts exist,
   which services they run, and on which ports. The class is service-topology disclosure, and the
   present instance publishes **two hosts and three ports**, which is wider than the single
   address-and-port F-F78 named.
2. **Instance inventory** — repo/user/container counts, image versions and deployment layout of a
   named live instance, as distinct from the architecture that instance implements.
3. **Operator-identifying detail** — home paths, local usernames, machine names, beyond what the
   published account already discloses.

⭐ **D2.4 — A boundary declared by the graph that owns the fact binds every graph that quotes it.**
`Forgejo.aDNA`'s MANIFEST declares `publishable: graph_only` and enumerates what a pull may not
publish — the instance, its address, its ports, its counts. That declaration is **authoritative for
that graph's facts wherever they appear**, including in this vault's tree, including when they arrive
as inbound mail.

This is the clause that would have caught the case. **Seven of the thirty-one occurrences arrived in
Ilmarinen's own memos**, written by the graph whose MANIFEST forbids publishing them, delivered into a
repo whose declared class is public, and published by the ordinary operation of a correctly configured
`origin`. Neither end was doing anything wrong by its own rules. **The rule that binds them jointly
did not exist.**

### D3 — Correspondence and session history are in scope, by construction (binding)

`who/coordination/` and `how/sessions/history/` are **not exempt**. They are the *most* likely
carriers, because carrying other graphs' operational detail is their normal content — a coordination
memo exists to convey exactly the facts D2 governs. **10 of the 13 affected files are correspondence
or session history.**

They are equally **not silently included**: a repo whose public class was decided without anyone
asking what its `who/` tree contains has not made a decision about its `who/` tree. D3 forces the
question to be asked once, explicitly, per repo.

### D4 — Remedy is fix-forward; published history is not rewritten (binding)

For material already published:

- **No history rewrite, no force-push over a public default branch.** Rewriting does not retract what
  has been fetched, cached, or indexed. ⚖ Measured here: `forks=0`, which narrows the blast radius of
  a rewrite but does not change that the content has been publicly fetchable.
- **No retroactive content edit.** A working-tree edit cannot reach pushed history; it would produce
  the *appearance* of remedy without the substance — the failure mode this vault has filed repeatedly.
- **SO#6 — archive, never delete.** The record stands, including the part that records the mistake.
- **The boundary binds the next write.** The count stops growing; it does not shrink.

⛔ **Stated plainly rather than smoothed: this leaves 31 occurrences across 13 files published, and
they stay published.** That is the ruling, not an oversight in it.

**D4.1 — the three states of a leak, because the two-state version is wrong.** F-F78 §4 reasons in
two states — *untracked* (a working-tree edit works) and *committed* (it cannot). There is a **third**,
and it is the only one where a complete remedy is cheap:

| state | remedy available | cost |
|---|---|---|
| **untracked** | edit the file | none — no history exists to miss |
| **committed, not pushed** | rebase / amend | low — **no force-push over a public branch** |
| **pushed** | none that retracts | — fix-forward is the only honest option |

⚠ **This instance sits in neither early state.** The 7 commits ahead of remote `master` add **zero**
new occurrences; the exposure is entirely in published history. The middle state is a real category
and an **empty** one here — recorded as empty rather than presented as an opportunity.

### D5 — The predicate needs an instrument, and a path rule cannot be it (binding)

The boundary is enforced at push. The `.adna/`-shipped `pre-push-sanitize.sh` already carries the
right *shape* — **R1** (private-path leakage) and **R7** (operator-defined deny list) — but both match
on **file paths**: R7's `re:` and prefix branches each test the filename. **R2** matches content, but
only against a fixed set of secret regexes.

⛔ **No path rule can express this boundary.** The affected files span `who/`, `what/`, `how/`, and
two repo-root files. The rule is about a *string*, not a location.

⇒ The gate gains **R8 — an operator-defined content deny-list**: R2's scanning mechanics driven by a
pattern file, honouring the same `pragma: allowlist` escape, reporting matches **redacted** through
R2's existing redactor. Fail-closed per [[adr_011_secret_scanning|ADR-011]] A4 §2(a): a malformed or
unreadable pattern file is a **BLOCK**, never a pass.

⚠ **R8 will block this vault's own next push, and that is correct.** `STATE.md` and `CHANGELOG.md`
carry the address at HEAD. The collision is resolved by an explicit, recorded allowlist decision —
**never** by weakening R8. Where that decision has not been taken, R8 ships **uninstalled with the
reason recorded**, because a gate that is quietly permissive is worse than one that is honestly absent.

*(Authored here per Standing Order #3; `.adna/` is never edited directly. The upstream ships via
Rosetta's `skill_template_release`.)*

### D6 — Every carrying graph owns its own remedy; the census is enumerated, never rostered (binding)

*Added at rev 2. It exists because the struck §Context sentence had this backwards, and an inference
left implicit is the thing that goes unread at a ratification gate.*

**D6.1** — Where more than one graph carries material across a publication boundary, **each carrying
graph owns its own remedy.** No graph can discharge another's, and this one does not claim to. The
boundary binds **every** carrier; D4's fix-forward posture applies to each independently.

**D6.2** — A publication census is **enumerated from the forge, never assembled from a roster.** The
population is *"every repo the provider reports as public"*, obtained by enumeration; a set derived
from correspondence, memory, or a vault list is **not a census** and may not be reported as one.

**D6.3** — Every predicate is **stated with its result**, and a result may only be cited for the
question its predicate asked. Reporting a `host:port` count under the words *"carries the address"*
is the rev-1 error, and it is prohibited rather than merely regretted.

**D6.4** — ⛔ **A zero must be falsified before it is recorded.** A count of `0`, an empty list, or an
empty result set is recorded only once the same instrument has been shown to return non-zero against
a known-positive control. **`HTTP 200` with an empty body is not evidence of an empty population** —
see §C4's Codeberg vantage, where the org is `404`-invisible and its repo list is `200 []`. Absent a
control, the honest verdict is **`UNKNOWN`**, never `0`.

**D6.5** — Where this vault's census finds another graph carrying the material, that graph is
**notified with the measurement attached** — path, branch, count, predicate, and vantage — so it can
refute rather than accept. Notification is owed; adoption of our figures is not.

## Amendment A1 — The gate enforces D4: it refuses new occurrences and never re-litigates published ones — **proposed 2026-09-02**

*Authored when R8 was installed for the first time (2026-09-02, 29th sitting). Ratification:
**decision** = A1 as written · **ratified-by** = _pending operator_ · **date** = _pending_ ·
**status** = `proposed`.*

### §1 — The scope rule (binding once ratified)

The push-time content gate (R8, `pre-push-sanitize.sh` ≥ 4.2.0) evaluates **the lines a push would
add**, not the whole content of the files it touches. Where a push has no remote history to diff
against — a first push of a branch — **every line is new and the whole file is in scope**.

⛔ **This is a restatement of D4, not a relaxation of it.** D4 already rules: *"The boundary binds the
next write. The count stops growing; it does not shrink."* A whole-file scan **exceeded** that — it
refused a push over lines D4 had already ruled are not to be touched, which makes the only available
remedies either a rewrite (D4 forbids it) or an exemption (see §2).

### §2 — Therefore no allowlist exists, and that is the point (binding once ratified)

⛔ **No file-scoped or path-scoped exemption may be added to the content gate.** The historical body
is out of scope **by doctrine**, not by exemption, and the difference is the whole value:

- an **exemption** names files, and a *new* occurrence added to an exempted file passes — which is a
  gate reporting green on precisely the case it exists to catch, and `STATE.md` (this vault's
  heaviest carrier) would have been on that list;
- **D4 scoping** names no files at all, so there is nothing to go stale, nothing to review, and a new
  occurrence blocks **anywhere**, including in the files that already carry the string.

⭐ **Measured at the change, which is why this could be ruled rather than argued**: 70 matching lines
across 23 files, **all** already on `origin/master`, and 24 unpushed commits adding **zero**. The gate
installs **green with no exemption of any kind** — honestly, not by allowlist. Had the measurement
gone the other way, D4.1's middle state (committed-not-pushed ⇒ rebase, cheap and complete) would
have applied, and that remains the remedy for any future occurrence caught before it is pushed.

⚠ **A rename presents as all-new and blocks.** Known over-refusal, stated here rather than left to be
discovered; the cure is a `pragma: allowlist` on the moved line or a rebase, never a pattern change.

### §3 — What is NOT amended

D1–D6 are unchanged. ⛔ **Resolution (c) — weaken the pattern until it passes — stays refused and
stays named.** A1 changes *what the gate is asked about*; it changes nothing about *what the answer
must be*.

### A1 provenance

- ⛩ **The instrument was more conservative than the doctrine, and that is a defect in the same family
  as being more permissive.** The whole-file scan looked stricter and was therefore never questioned;
  what it actually produced was a gate that **could not be installed at all** — held back for four
  sittings while `Git.aDNA` remained the fleet's only public carrier with **R1–R8 never once run on a
  real push** (F-P7b-ag). *A control too strict to install protects nothing, and it does it while
  looking rigorous.*
- ⚠ **This amendment is authored AFTER the install, in the same sitting, and says so.** The install
  was not gated on it: 4.2.0 brings the instrument **into line with** ratified D4, which is the
  inverse of the ADR-013 A1 enforce-before-ratify interval. A1 exists because ADR-017's whole lesson
  is that a discipline held in prose — here, in a code comment — propagates as an absolute and is not
  held at all. The reasoning deserved a clause, so it has one.

## Consequences

- Every repo with `private=false` now has a content question attached to it, answerable per repo.
- **A cost, stated**: D2.4 means a graph can constrain what its correspondents may publish. That is
  the intent — the graph that owns a fact is the one that knows its sensitivity — but it couples
  publication decisions to peers' MANIFEST declarations, and a graph that declares nothing declares
  nothing. D2.4 binds where a declaration exists; it does not manufacture one.
- **A cost, stated**: R8 reads file *contents* at push time on every outgoing file. On this vault's
  size that is unmeasurable; on a large repo it is not free.
- ADR-013's classifications are untouched. No repo changes host or visibility because of this ADR.

## Alternatives considered

- **Structural split of the published tree** — keep the standard public; move `who/coordination/` and
  `how/sessions/history/` to a private sibling or excluded tree. ⭐ This addresses the *class* rather
  than the instance, and D3 is the argument for it. **Deferred, not rejected**: it splits the vault's
  provenance across two repos, breaks every `[[wikilink]]` that crosses the boundary, and forfeits the
  dogfooding value of a single public graph. Recorded so a later reader sees it was weighed.
- **Flip `Git.aDNA` private** — reverses ADR-013 D3 and undoes the R1/P5 beachhead. Rejected: the
  vault's thesis is open standards, and its public home is the thesis in practice. Would require a
  superseding ADR, not this one.
- **History rewrite + force-push** — rejected per D4.
- **Harden the `gitleaks` A1 gate to catch RFC1918 addresses** — rejected. A1 is a *secret* scanner
  and it was right. Overloading it would make every legitimate architecture document that names an
  address a false positive, and would still not encode the boundary rule.

## Provenance

Filed against **F-F78** (Ilmarinen, `Forgejo.aDNA`, 2026-08-26), which reversed the tense of its own
predecessor **F-F77** (the material was not *pending* publication; it was published). Ilmarinen
declined to prescribe a remedy under Rule 10, having contributed 7 of the 31 occurrences — the routing
is recorded because it is the reason this ADR is authored here rather than there.

## Ratification

✅ **RATIFIED at rev 3.**

- **decision** — **D1 · D2 (incl. D2.4) · D3 · D4 (incl. D4.1) · D5 · D6**, as filed at rev 3, **as
  a standalone ADR**. The framing alternative D1 itself offered — authoring this as ADR-013
  Amendment A2 — was put to the operator and **not taken**. That question is now **closed**, not
  left open: this is its own ADR because it introduces an axis ADR-013 does not have, and a content
  rule binds graphs that never read a host-policy ADR.
- **ratified-by** — operator (Stanley, §7.7, plan gate)
- **date** — 2026-08-27
- **status** — `accepted`

### ⚠ What changed between the rulings and the signature, stated so the record shows it

**Rev 1 → rev 2.** §Context finding #1 was **false** and is struck in place rather than rewritten
away: the census counted a roster instead of an enumerated population, and reported a `host:port`
figure under the words *"carries the address."* **Three** public repos carry it, not one. Caught by a
peer **before** ratification. **No decision withdrawn**; D1–D5 stood and **D6 was added**, because
the struck clause *"the remedy is this vault's alone"* was load-bearing for D4's scope and is now
known to bind three graphs.

**Rev 2 → rev 3 (this signature).** ⛔ **The correction was itself wrong, and the operator was told
before signing.** The same peer could not reproduce `57 / 17`. Root cause **F-P7b-af**: the census
guards excluded `.`, which both undercounted occurrences and made a host **preceded by a dot** or
**ending a prose sentence** invisible — ⛔ **and the identical guards shipped in R8's own pattern**,
so the gate D5 creates could not have stopped three of the files it exists to stop. Pattern repaired
in the fail-safe direction with an 8-arm control; the census promoted to a vault instrument with the
`--meta` control it never had.

⇒ **The operator ruled that this ADR cites the instrument rather than transcribing figures** (C8).
The allowlist number had moved three times in one sitting. **No decision is withdrawn at rev 3
either** — D1–D6 stand exactly as written. What changed is that the *evidence* now lives in a
runnable, controlled, re-derivable instrument instead of a table two desks could not reconcile.

⭐ **The pattern across both revisions is the argument for §7.7 itself.** Twice, an agent-authored
document reached the signature line carrying a false number, and twice a peer caught it in the
interval. Ratification is not a formality on this desk; it is the only place where a claim gets read
by someone who did not write it.

### Downstream of this signature, and NOT in the packet

- **The R8 allowlist.** Now sized against the **repaired** predicate (75 occurrences / 23 files at
  `b6c070c`), not the 31 or the 62 that preceded it — and re-derived from
  `how/tests/census_public_carriers.sh` at the moment it is written, never quoted from this file.
- ⛔ **The gate has nowhere to run yet.** D5 opens *"The boundary is enforced at push."* Measured
  2026-08-27 (**F-P7b-ag**): `.git/hooks/pre-push` is the gitleaks scanner, `core.hooksPath` is
  unset, and R1–R8 have never run on a real push in this vault. D5's decision is unaffected — a path
  rule still cannot express this boundary — but a reader must not take that sentence as a statement
  about today. Installation was offered at the plan gate and **declined**: a gate installed ahead of
  its allowlist is the enforce-before-ratify interval ADR-013 A1 already had to annotate against
  itself.
- **The D6.5 notifications** owed to `aDNA.aDNA` (Rosetta) and `Canvas.aDNA` (Mondrian) — authored,
  and delivered this sitting under the lane the operator opened at the same gate.
