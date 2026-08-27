---
type: decision
adr_id: adr_016
title: "ADR-016 — Publication Boundary (a content predicate on the public repo class)"
status: proposed   # ⛔ NOT ratified. Authored 2026-08-26; awaiting operator §7.7. See §Ratification — the 4-field block is deliberately EMPTY.
revision: 2        # rev 2 (2026-08-27): §Context finding #1 STRUCK as false — census corrected, D6 added. See §Correction.
created: 2026-08-26
updated: 2026-08-27
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

**Status**: ⛔ **`proposed`** — authored 2026-08-26, **not ratified**. The Ratification block below is
empty by construction; nothing here is binding until the operator signs it (§7.7).

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
| `Git.aDNA` | `master` | **57 / 17 files** | **31 / 13** ✅ reproduces | **62 / 20** |
| `aDNA.aDNA` | `main` | **1 / 1** | 0 | 15 / 9 |
| `Canvas.aDNA` | `master` | **2 / 2** | 0 | 11 / 8 |
| `III.aDNA` | `main` | 0 | 0 | 2 / 2 |
| `aDNA` | `main` | 0 | 0 | 1 / 1 |
| `adna-legacy` | `main` | 0 | 0 | 1 / 1 |
| `community-policies` · `spacemacs` · `world-genome` | `main`·`develop`·`main` | 0 | 0 | 0 |

⇒ **three public carriers of the address, not one** — and under **R8's own predicate, six.**

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
predicate (any RFC1918 address). Under the gate's own predicate this repo carries **62 occurrences
over 20 files**, and **six** public repos match rather than one. **A reader of this ADR cannot
predict what R8 will do from the figures in this ADR.** Recorded here, at `proposed`, because it
bears on the allowlist decision that follows ratification — an allowlist scoped to the 31 would
not cover what the gate actually stops.

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

⛔ **NOT RATIFIED.** The 4-field block is empty pending the operator's §7.7 ruling:

- **decision** — *(unsigned)*
- **ratified-by** — *(unsigned)*
- **date** — *(unsigned)*
- **status** — `proposed`

Packet scope **at rev 2**: **D1 · D2 (incl. D2.4) · D3 · D4 (incl. D4.1) · D5 · D6 (NEW at rev 2)**,
plus the framing question in D1 (own ADR vs. ADR-013 Amendment A2).

⚠ **What changed between rev 1 and rev 2, stated so the operator signs knowing it.** Rev 1's
§Context finding #1 was **false** and is struck in place rather than rewritten away: the census
counted a roster instead of an enumerated population, and reported a `host:port` figure under the
words *"carries the address."* **Three** public repos carry it, not one, and this vault carries
**57/17**, not 31/13. The correction was **filed by a peer before ratification, not discovered
after** — the packet is stronger for having been wrong in public. **No decision is withdrawn**;
D1–D5 stand, and **D6 is added** because the struck sentence's *"the remedy is this vault's alone"*
clause was load-bearing for D4's scope and is now known to bind three graphs.

⛔ **Two items are downstream of this signature and are NOT in the packet**: (a) the **R8 allowlist**
scoping — and §C3 now shows an allowlist sized to *31* would not cover what the gate stops at *62*;
(b) the **D6.5 notifications** owed to `aDNA.aDNA` (Rosetta) and `Canvas.aDNA` (Mondrian), staged
this sitting under an outward lane that authorised Ilmarinen only.
