---
type: runbook
title: "P7b obj 5 — mirror-mesh federation runbook (R&D forge → Codeberg)"
created: 2026-08-23
updated: 2026-08-23
status: staged            # ⛔ NOTHING IN THIS DOCUMENT HAS FIRED. Authored non-outward. §2 carries three preconditions that are NOT satisfied, one of which was discovered by writing this document.
last_edited_by: agent_stanley
mission: p7_mesh_git_spike
objective: 5
executes: adr_004_provider_contract_interface   # D5 — the configure-mirror contract
shape: "A · Forgejo → Codeberg (operator-chosen, 2026-08-23)"
measured_against: what/inventory/foss_predicate_measurement.md   # measured_at 2026-08-24T03:52Z
tags: [runbook, p7b, obj_5, mirror_mesh, federation, configure_mirror, codeberg, staged, non_outward_authored, f_p7b_j, f_p7b_k]
---

# Mirror-mesh federation — runbook

> ## ⛔ §0 · This document fires nothing
>
> Authored in a **non-outward** sitting (operator gate, 2026-08-23). No command below has been run. It
> is **not** a standing authorisation: firing §4 takes its own operator gate, and that gate must be
> taken against a **fresh** §2, never against the table as written here.
>
> **Why staged before executed, deliberately** — the same reason `context_sync_runbook` was, and it has
> already paid for itself twice in this document. Writing the preconditions down as things to be
> **measured** rather than asserted surfaced **F-P7b-j** (the FOSS predicate) at the gate rather than at
> the act; and writing the §4 commands out in full surfaced **F-P7b-k** — that obj 5 would put a
> third-party credential through a plaintext endpoint — which no amount of planning-in-prose had found.
>
> ⭐ **Both findings are reasons *not* to fire, discovered by the act of preparing to fire.** That is
> what staging is for. Obj 4's staging found two checks that could not pass; this one found two
> preconditions that are not met.

---

## §1 · What obj 5 actually is — corrected against measurement

The mission card reads as build-work: *"mirror-mesh between the lighthouse forge and another forge;
ForgeFed experiment + watch-item note."* **Measured, the verb already exists and is implemented.**

`gitops_configure_mirror` — `how/skills/lib/gitops_dispatch.sh:295`:

- Forgejo-origin → `POST {apibase}/repos/{org}/{repo}/push_mirrors` with
  `{"remote_address": …, "sync_on_commit": true}`, passed `--idempotent`;
- GitHub-origin → **refuses**, via `_gitops_mirror_note` (`:168`), because a GitHub-origin push-mirror
  is not a Forgejo operation (ADR-008). The refusal is a real code path, not a comment;
- covered by the dry-run harness — **31/31 PASS**, measured `2026-08-24T03:45Z`.

⇒ **Obj 5 is not "build the mirror verb." It is "prove it federates, and measure what that proves."**
A runbook written against the build-work reading would have re-implemented a working verb and proved
nothing about federation.

**The property under test**, stated before any command is run:

> A repository resident on the subnet's own forge is **continuously replicated to an independently
> operated forge**, by the forge itself rather than by an operator's workstation, such that the second
> forge's copy converges on the first **without a human in the loop** — and the mechanism is the
> **same provider contract** that serves every other host.

The clause *"by the forge itself"* is the whole objective. A cron job on this laptop that pushes to two
remotes would satisfy a naive reading and prove **nothing** about federation: it would prove that a
workstation can push twice. Mirror-mesh means **forge-to-forge**, with the workstation absent.

---

## §2 · Preconditions — with owners, and with what is already true

> ⚠ Every row is a measurement **with an expiry**. §4.1 re-takes them. This table is evidence for a
> gate decision, never the gate.

| # | Precondition | Owner | State at `2026-08-24T03:52Z` |
|---|---|---|---|
| P1 | Subject repo passes `preflight_context_sync.sh` — 0 BLOCK, 0 UNKNOWN | Hopper | ✅ **8 PASS / 0 warn / 0 BLOCK / 0 UNKNOWN** @ `a2fc74d` |
| P2 | R&D forge reachable; anonymous API surface behaves | Ilmarinen | ✅ measured live at obj 4 (`303`+`Location` · `401` · `200`) — ⚠ **re-fire, a stale control is not a control** |
| P3 | `configure-mirror` implemented + harness-covered | Hopper | ✅ `gitops_dispatch.sh:295`; dry-run **31/31** |
| P4 | `CODEBERG_TOKEN` brokered, scoped `write:repository` | Hestia | ✅ provisioned 2026-06-20 (Keychain) — **name only; the value is never read into this document** (ADR-007 D3) |
| P5 | Outward-action gate open for a live forge write | operator | ⛔ **CLOSED.** The 2026-08-23 gate authorised **staging only**, in those words |
| **P7** | **The mirrored content is demonstrably FOSS** | **operator + Berthier** | ⛔ **NOT SATISFIED — F-P7b-j.** 18 of 19 Codeberg repos and 3 of 4 GitHub-public repos carry **no license at `HEAD`**. See [[../../../../../what/inventory/foss_predicate_measurement\|the measurement]] |
| **P8** | **Codeberg accepts this *use*, not merely this *content*** | **operator** | ⛔ **UNKNOWN** — see below. *An unknown reading is never a silent pass* (ADR-011 A4 §2(a)) |
| **P9** | **The forge speaks TLS before a third-party PAT is handed to it** | **Portunus + Ilmarinen** | ⛔ **NOT SATISFIED — F-P7b-k.** The forge is `http://10.43.0.28:3300`, **plain HTTP** |

### ⛔ P7 — the predicate ADR-013 is keyed on does not currently hold

ADR-013 permits the Codeberg lane **only** for FOSS work — 🚩 *"This ToS line is exactly what separates
row 2 from row 3."* Measured, the artifacts do not carry the licenses that predicate names. The root
cause is `.adna/how/skills/skill_project_fork.md:100` — `rm -f LICENSE  # R4: no template LICENSE
(project picks own license)` — a rule that removes the license at fork and is **never paired with
anything that asks the project to pick one**.

**Not ours to clear.** Which license is org/legal (**Berthier**); R4 is in `.adna/` (**Rosetta**,
Standing Rule 1). Both are memo'd, both undelivered as of this writing.

### ⛔ P8 — content-is-FOSS does not answer use-is-permitted

A second, **independent** question, and it is not a rephrasing of P7. Codeberg is a FOSS **development
host**; it has been explicit that it is not a general-purpose mirror or backup target. Obj 5's shape A
proposes exactly a **push-mirror into Codeberg** — i.e. Codeberg as the *destination* of automated
replication whose canonical home is elsewhere.

⇒ **P7 could be fully cleared — every repo licensed MIT tomorrow — and P8 would still be open**, because
the question is about the *use*, not the *content*. ⛔ **It is UNKNOWN, and it is recorded as UNKNOWN.**
Answering it means reading Codeberg's current ToS and, if it is genuinely ambiguous, **asking them** —
neither of which this document does or should guess at.

### ⛔ P9 — F-P7b-k: obj 5 would put a third-party PAT through a plaintext endpoint

**This is the one that writing §4 discovered, and it is the strongest reason not to fire.**

Forgejo push-mirror authentication is carried **in the request body** — the remote address embeds
credentials, or the equivalent `remote_username`/`remote_password` fields do. ADR-004 **D5** further
requires that **LFS repos mirror over HTTPS + PAT, never SSH + deploy-key**. So §4's call is:

```
POST http://10.43.0.28:3300/api/v1/repos/{org}/{repo}/push_mirrors
Authorization: token $FORGEJO_TOKEN                    ← credential #1, in a header
{"remote_address": "https://…:$CODEBERG_TOKEN@codeberg.org/…"}   ← credential #2, in the body
```

over an endpoint whose scheme is **`http://`**. And the second credential is then **stored at rest on
the forge**, so it must be revocable independently — a fact with no owner today.

> ⭐ **This is F-C36's coherence item acquiring the limb that makes it bite.** Pandora's finding recorded
> that `insecure = true` against **this exact endpoint** is *"consistent today — declared, group-gated,
> plain HTTP, **zero pulls ever**."* The "zero pulls ever" clause is what made it tolerable. **Obj 5
> would be the first act to send a live third-party secret through it.** The mitigation that made the
> inconsistency survivable stops being true at the moment obj 5 fires — and it stops being true
> *silently*, because nothing measures it.
>
> ⛔ **And it collides with the P7a flip runbook's own P2 criterion — *"no per-client insecure-skip
> flags, ever"*.** ⇒ **obj 5 is transitively gated on the P7a flip's TLS preconditions.** That
> sequencing was not written down anywhere before this document; it was found by writing the request
> out in full instead of describing it.

⚠ **The mesh is not the answer to this.** Nebula encrypts the transport, and that is real. It does not
make it correct to hand a *third-party* credential to a service over a plaintext application-layer
channel, where it is logged by anything in the path and stored by the receiver. **ADR-007's whole model
is name→env-var precisely so a value never lands somewhere it cannot be withdrawn from.**

---

## §3 · The lawful shapes, and the sentence each licenses

The operator chose **A** at the 2026-08-23 gate. Recorded here with what it buys **and what it does
not**, because obj 4 closed on its weaker shape and saying so in advance is why its report is
trustworthy.

| | **A · R&D Forgejo → Codeberg** *(chosen)* | **B · R&D Forgejo → a second self-hosted Forgejo** |
|---|---|---|
| Second forge | hosted Codeberg, independently operated | a second lighthouse instance |
| Proves | the `configure-mirror` verb drives a **real** forge-to-forge replication to an operator we do not control | **mirror-mesh** as ADR-012 means it: subnet-to-subnet, both ends ours, neither centrally hosted |
| Needs | P1–P5 **+ P7 + P8 + P9** | P1–P5 **+ P9** + **a second forge instance (unbuilt)** |
| Available now | ⛔ no — three preconditions unmet | ⛔ no — no second instance exists |
| Licenses the sentence | *"the provider contract federates the R&D forge to an independent Forgejo, forge-to-forge"* | *"cross-subnet mirror-mesh federation"* |

⛔ **Reporting A's result in B's language is the transcribed-status class this campaign has now filed
six times.** [[../../../../../what/decisions/adr_012_lighthouse_operator_default_and_context_sync|ADR-012]]
defines the north star as *"a federation of **willing lighthouse-Forgejo nodes**"* — **both ends
self-hosted**. Shape A's far end is a centrally hosted public service. It is a **genuine and valuable**
federation test — an independently operated forge, foreign credentials, a real network boundary — and
it is **not the decentralization claim**. Whichever runs, §6a must name **which**, in these words.

⚠ **A is also the only shape available without new construction**, which is exactly why it is the one
whose report is most likely to be over-read later.

---

## §4 · The trip — commands, each with its failure condition stated first

> ⛔ **Nothing below has been run.** Every block is gated on P5 **and** on P7/P8/P9 being cleared or
> **explicitly waived in writing by the operator**. A waiver is lawful; a silent pass is not.

**Origin forge**: R&D node, Forgejo `15.0.6` @ `10.43.0.28:3300`. **Target**: `codeberg.org/aDNA-Network`.
**Subject**: chosen at the gate — see §4.0.

### 4.0 — Choose a subject that can actually answer the question

**Fails if**: the subject is unlicensed (P7), or is not already resident on the R&D forge, or is a repo
whose Codeberg copy is its `origin` — mirroring a repo back onto its own canonical home proves nothing
and risks a force-overwrite of the authoritative copy.

⭐ **The only currently-lawful candidate is `Exchange.aDNA`** — the **one** licensed graph (MIT), and the
one whose Codeberg repo already exists. Every other candidate fails P7 on the spot. *This is the
measurement narrowing the work, which is what a measurement is for.*

⛔ **`Git.aDNA` is NOT a lawful subject for shape A**, despite the dogfooding instinct that has served
this campaign well: it is unlicensed (P7) and its canonical `origin` is GitHub-public, so its Codeberg
presence would be new and would need its own host-policy ruling under ADR-013.

### 4.1 — Re-measure immediately before, never from this document

```bash
bash how/tests/preflight_context_sync.sh
bash how/tests/dryrun_gitops.sh                 # expect the harness's own count, all PASS
```
**Abort if**: any BLOCK or UNKNOWN, or any dry-run failure. *§2's numbers are from `2026-08-24T03:52Z`
and are a claim with an expiry (F-DECL-03). The gate is the fresh run.*

### 4.2 — Re-measure P7 at the object, not from the table

```bash
git -C ~/aDNA/<Subject>.aDNA ls-tree --name-only HEAD | grep -iE '^(license|licence|copying)'
```
**Fails if**: empty. **Anchored `^` on purpose** — un-anchored this matches prose *about* licensing and
reports a license where there is none (**F-P7b-e**, and **F-P7b-h**, which was the same defect copied
into a runbook and left there — this line exists so it is not copied a third time).

⚠ **And confirm at the remote, not only locally.** [[../../../../../what/inventory/foss_predicate_measurement|The measurement]]
§6 states plainly that 18 of 19 rows were **not** divergence-checked against Codeberg. A license added
through the web UI and never fetched would be invisible to the local reading.

### 4.3 — Record the pre-state on **both** forges

```bash
git ls-remote rd-forge:aDNA-Network/<Subject>.aDNA.git refs/heads/master     # origin forge tip
git ls-remote https://codeberg.org/aDNA-Network/<Subject>.aDNA.git refs/heads/master   # target tip
```
**Fails if**: either returns nothing → the endpoint is unreachable or the repo does not exist. **Stop.**
This is not a mirror problem and configuring a mirror will not diagnose it.

⭐ **The two tips must differ**, or the trip cannot demonstrate convergence — an already-converged pair
would report success having replicated nothing. *A check that cannot distinguish success from a no-op is
the F-P7a-f class, and it is the class this campaign has filed most often.*

### 4.4 — Configure the mirror *(OUTWARD — gate P5; blocked on P9)*

```bash
GITOPS_DRY_RUN=1 gitops_configure_mirror 10.43.0.28:3300 aDNA-Network <Subject>.aDNA \
    "https://codeberg.org/aDNA-Network/<Subject>.aDNA.git"     # read the PLAN line first
```
**Then, and only after the plan line has been read**, re-run with the live flag.

**Fails if**: a non-2xx returns, **or** a 2xx returns while `push_mirrors` `GET` shows no new entry —
`--idempotent` must not be allowed to mask a create that did not happen.

⛔ **ADR-004 D5's three gotchas are binding, and each is a way to fail *silently*:**
1. **No in-place update.** A mirror config **cannot be edited**. Changing it is `repoDeletePushMirror`
   → `repoAddPushMirror`. Anything shaped like an update is a bug.
2. **No tags-only toggle.** The filter is **branch-glob only**; a **blank filter means
   `git push --mirror` — all branches *and* tags, force**. ⚠ **Blank is not "default", it is
   "force-mirror everything"**, and against a repo with any independent history on the far side that is
   destructive. A release-only mirror is branch-filter + tag discipline, never a switch.
3. **LFS does not mirror over SSH.** LFS repos mirror **HTTPS + PAT**. This is the clause that drags
   the credential into the request body and thereby creates **P9**.

### 4.5 — Verify convergence, on a named object set

**Fails if** *(each stated before it is run)*:

| Check | `fails_when:` |
|---|---|
| mirror entry exists | `GET …/push_mirrors` returns no entry for the target address |
| a **new** commit propagates | push one commit to the origin forge; the **target** tip does not reach it within the sync interval. ⛔ **This is the actual test.** A mirror that lists correctly and replicates nothing passes every configuration check |
| the workstation was absent | the propagating push was issued **to the origin forge only**; if the laptop also pushed to Codeberg, **the trip proves nothing** — re-run |
| target tip **==** origin tip | `ls-remote` on both, compared by SHA, not by "it looks updated" |
| target tree hash == origin tree hash | clone both at that SHA, compare `rev-parse HEAD^{tree}` |
| no credential leaked into config | `git config --get-all remote.*.url` on the subject shows **no** token; the forge's stored mirror credential is **not** printed into any artifact of this run |

⭐ **Row 3 is the one that makes this obj 5 rather than obj 4 re-run.** Every other row can be satisfied
by a workstation pushing twice. Only "the workstation was absent" distinguishes **federation** from
**scripted duplication**, and it is the objective's entire content.

### 4.6 — Post-state + teardown

Record both tips. **Do not delete the mirror on success** — a mirror that is removed as cleanup proves a
mirror can be created, not that federation runs. Leaving it is the point; **say so at the gate**, because
it means obj 5 leaves standing outward state, which obj 4 did not.

---

## §5 · Instrument controls — to be re-fired, NOT inherited

| Control | Expect | State |
|---|---|---|
| `GET /aDNA-Commons/exchange-proof/raw/main/README.md` | `303` **with** `Location`, `num_redirects=0` | ⚠ measured `2026-08-21T23:37Z` — **stale, re-fire** |
| `GET /api/v1/user` anonymous | `401` | ⚠ stale, re-fire |
| `GET …/raw/branch/main/README.md` | `200`, no `Location` | ⚠ stale, re-fire |
| **NEW** — `GET https://codeberg.org/api/v1/version` | `200` | ⛔ never measured — the **target** forge has no control at all, and a trip with a live control on only one of two endpoints is half-instrumented |

⭐ The `303` row remains the one that matters (**F-F25**): `num_redirects=0` **while a `Location` header
is present** — the reading that made a live redirect look like no redirect.

---

## §6 · Rollback

A push-mirror **cannot be edited — only deleted and re-added** (ADR-004 D5). Rollback is therefore
exact and cheap on the config, and **not cheap at all on what it may have replicated**:

- **Mirror created, replication wrong** → `repoDeletePushMirror`. The config is gone immediately.
- ⛔ **Mirror created with a blank branch-filter** → it ran `push --mirror`: **all branches and tags,
  force**. Deleting the config does **not** undo that on the target. If the target held any ref the
  origin did not, **it is gone**. ⇒ **the branch filter is set before the first sync, never after.**
- **Credential exposure (P9)** → deleting the mirror does **not** rotate the PAT. If §4.4 ran over plain
  HTTP, **`CODEBERG_TOKEN` is treated as disclosed and rotated via Hestia** — that is the rollback, and
  it is an action, not a note.
- **Nothing fired** → nothing to roll back. This is the current state.

---

## §7 · Non-goals — named so a later reader does not widen this

- ⛔ **ForgeFed is not attempted.** ADR-012 D3 adopts it *when production-ready*; it is not. Obj 5's
  ForgeFed deliverable is a **watch-item note**, not an experiment.
- ⛔ **No second forge is built.** Shape B needs one; standing it up is `Lighthouse.aDNA`'s, gated on the
  P7b go/no-go this mission still owes.
- ⛔ **F-P7b-j is not repaired here.** No license is added to any graph. We measured it and routed it;
  choosing a license is not Git.aDNA's call.
- ⛔ **`Videos.aDNA`'s missing remotes are not repaired here** — flagged in the measurement §3, owned by
  Iris and by the shim registry.
- ⛔ **No `.adna/` edit** (Standing Rule 1). R4 is Rosetta's to change.
- ⛔ **The P7a flip is not accelerated by this document.** P9 makes obj 5 *depend* on it; it does not
  give obj 5 any authority over its schedule.
