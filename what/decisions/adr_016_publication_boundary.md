---
type: decision
adr_id: adr_016
title: "ADR-016 — Publication Boundary (a content predicate on the public repo class)"
status: proposed   # ⛔ NOT ratified. Authored 2026-08-26; awaiting operator §7.7. See §Ratification — the 4-field block is deliberately EMPTY.
revision: 1
created: 2026-08-26
updated: 2026-08-26
last_edited_by: agent_stanley
joint_with: []
ratifies_at: "operator §7.7 gate"
depends_on: [adr_011, adr_013]
amends: []
supersedes: []
relates: [f_f78, f_f77, adr_007, adr_045]
tags: [decision, adr, adr_016, git, publication_boundary, content_predicate, exposure, f_f78, proposed, p7b, operation_free_harbor, fix_forward, graph_not_instance]
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

1. ⭐ **`Git.aDNA` is the only public repo in the fleet carrying the address.** `Network.aDNA` (12
   files) and `aDNALabs.aDNA` (20) are **private**; `Forgejo.aDNA` (44) and `Container.aDNA` (26) are
   on Codeberg; `Home.aDNA` (1) has no remote at all; `aDNA.aDNA` is public and carries **0**. So the
   remedy is this vault's alone, and the reciprocal worry — that our outbound memos published the
   address into peers' repos — is **false**. *(Vantage: current visibility measured 2026-08-26. A repo
   private today may have been public earlier; this is not a history survey.)*
2. ⛔ **The `gitleaks` A1 gate passed correctly, and should not be "fixed" for this.** There are no
   secrets in these files. `$<TOKEN_NAME>@codeberg.org` is [[adr_007_credential_model|ADR-007]]'s
   broker discipline working exactly as designed — the name transits, the value never does.

⛩ **The gap is that the rule governing the decision is a *publication-boundary* rule, and no
instrument evaluated one because no doctrine stated one.** [[adr_013_host_role_inversion|ADR-013]]
D1–D7 classify repos along two axes — **host** and **visibility** — and carry **no content axis at
all**. The predicate was never missing from the check. It was missing from the doctrine, so there was
nothing for a check to evaluate. That is the durable finding; the 31 occurrences are its first
instance.

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

Packet scope: **D1 · D2 (incl. D2.4) · D3 · D4 (incl. D4.1) · D5**, plus the framing question in D1
(own ADR vs. ADR-013 Amendment A2).
