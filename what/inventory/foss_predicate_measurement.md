---
type: inventory
title: "F-P7b-j — the FOSS predicate, measured"
created: 2026-08-23
updated: 2026-08-24   # §4.1–§4.4 APPENDED — the public lane RE-DERIVED FORGE-SIDE (20/16, not 4/3) after Berthier's correction; §6 gains the denominator class. NO prior reading overwritten.
status: active
last_edited_by: agent_stanley
finding: F-P7b-j
measured_at: 2026-08-24T03:52Z      # ⛔ FIRST reading. Still the reading ADR-013 A1 was signed against.
remeasured_at: 2026-08-24T21:35Z    # SECOND reading — §7. Agrees exactly, and closes §6's divergence caveat.
forge_read_at:                      # THIRD instrument — GitHub org enumeration, §4.1. Straddles this vault's own LICENSE act.
  - 2026-08-25T01:15:19Z            # pre-act:  20 public / 16 unlicensed  (reproduces Berthier's correction exactly)
  - 2026-08-25T01:16:13Z            # post-act: 20 public / 15 unlicensed  (Git.aDNA out of the null set — the delta IS the proof of the push)
instrument: inline (commands reproduced verbatim in §2 and §4.1 — re-runnable, read-only)
population: |
  ⛔ TWO POPULATIONS, and conflating them is the defect §4.1 records. Stated separately (§4.2):
  · GOVERNED  — every vault at ~/aDNA whose `origin` resolves to codeberg.org, deduplicated to distinct
    repos · plus the GitHub-public graphs of ADR-013 row 1. LOCAL-TREE enumeration. This is what §3/§4
    measured, and it is correct FOR THIS POPULATION.
  · FORGE     — every public repo at the `aDNA-Network` GitHub org, enumerated at the forge (§4.1).
    20 repos, of which 13 have no local directory at all and are invisible to the governed walk.
  ⚠ The Codeberg lane has NOT been re-derived forge-side and inherits the identical exposure (§6).
bears_on: [adr_013_host_role_inversion, adr_003_visibility_split_policy, doctrine_gitops_block]
tags: [inventory, measurement, f_p7b_j, foss, licensing, tos, codeberg, adr_013, p7b, obj_5]
---

# F-P7b-j — the FOSS predicate is declared everywhere and licensed nowhere

> **What this document is.** A measurement, taken 2026-08-24T03:52Z, of whether the artifacts on each
> side of [[../decisions/adr_013_host_role_inversion|ADR-013]]'s host-policy table satisfy the
> **FOSS predicate that table is keyed on**. It was taken while staging P7b **obj 5**, whose operator-
> chosen shape mirrors into the FOSS-only org. **It is a dated reading, not a standing status.**

## §1 · The predicate, quoted

ADR-013's policy table conditions two of its three rows on a licensing fact:

| Source | Clause |
|---|---|
| ADR-013 row 2 | *"develop privately; **Codeberg-private is ToS-OK only for FOSS-bound work**"* |
| ADR-013 line 39 | 🚩 *"**Codeberg = FOSS-only.** Codeberg-private is permitted only for FOSS work that will be opened — **never** for proprietary/closed code. **This ToS line is exactly what separates row 2 from row 3.**"* |
| ADR-013 row 1 | *"public / released **FOSS** → GitHub (`aDNA-Network`, public)"* |

⇒ **"FOSS" is not decoration in ADR-013. It is the load-bearing discriminator** between row 2
(Codeberg-private, permitted) and row 3 (proprietary, forbidden on Codeberg). If the predicate does not
hold, the row assignment does not hold either.

## §2 · The command — reproduced so this can be re-run, not trusted

```bash
cd ~/aDNA
for d in */; do v="${d%/}"; [ -d "$v/.git" ] || continue
  o=$(git -C "$v" remote get-url origin 2>/dev/null)
  case "$o" in *codeberg.org*)
    n=$(git -C "$v" ls-tree --name-only HEAD 2>/dev/null | grep -icE '^(license|licence|copying)')
    echo "$o|$v|$n" ;;
  esac
done | sort -t'|' -k1,1
```

**Three properties of this predicate, stated because the campaign has now been bitten in all four
directions by predicates whose properties were left implicit:**

- ⛔ It reads **`ls-tree HEAD`**, not the working directory. An untracked `LICENSE` sitting in someone's
  tree is not published and does not satisfy a ToS; a committed one does. *(The working-dir reading was
  what planning used, and it happened to agree — agreement is not validation.)*
- ⛔ It is **anchored to the start of the path** (`^`). Un-anchored it would match
  `who/coordination/…licensing….md` and report a license where there is prose about one — the exact
  defect of **F-P7b-e** (LFS signature) and **F-P7b-h** (its uncorrected copy).
- ⛔ It **can return non-zero** — `Exchange.aDNA` returns `1` below. A check that returned 0 for every
  input would be indistinguishable from a broken one, and this one is not.

## §3 · Codeberg lane — 19 distinct repos, 18 unlicensed

Deduplicated to **distinct repos**: three canonical directories share a Codeberg repo with a
back-compat shim (`Molecules`/`MoleculeForge` · `Videos`/`VideoForge`+`VideosOld` ·
`WebForge`/`Websites`), so 22 directories resolve to **19 repos**. Counting directories would have
inflated the denominator.

| # | Codeberg repo | Local dir(s) | `LICENSE` at HEAD |
|---|---|---|---|
| 1 | `Caddy.aDNA` | `Caddy.aDNA` | ⛔ none |
| 2 | `Container.aDNA` | `Container.aDNA` | ⛔ none |
| 3 | `D3.aDNA` | `D3.aDNA` | ⛔ none |
| 4 | `Emacs.aDNA` | `Emacs.aDNA` | ⛔ none |
| 5 | **`Exchange.aDNA`** | `Exchange.aDNA` | ✅ **MIT** — *"Copyright (c) 2026 aDNA Labs"* |
| 6 | `Forgejo.aDNA` | `Forgejo.aDNA` | ⛔ none |
| 7 | `Groupware.aDNA` | `Groupware.aDNA` | ⛔ none |
| 8 | `Lighthouse.aDNA` | `Lighthouse.aDNA` | ⛔ none |
| 9 | `Molecules.aDNA` | `Molecules.aDNA` + `MoleculeForge.aDNA` | ⛔ none |
| 10 | `Nebula.aDNA` | `Nebula.aDNA` | ⛔ none |
| 11 | `Nextcloud.aDNA` | `Nextcloud.aDNA` | ⛔ none |
| 12 | `Oration.aDNA` | `Oration.aDNA` | ⛔ none |
| 13 | `Spacemacs.aDNA` | `Spacemacs.aDNA` | ⛔ none |
| 14 | `Tailwind.aDNA` | `Tailwind.aDNA` | ⛔ none |
| 15 | `ThreeJS.aDNA` | `ThreeJS.aDNA` | ⛔ none |
| 16 | **`TypeScript.aDNA`** | `TypeScript.aDNA` | ⛔ none — **the P5 beachhead pilot, live since 2026-06-20** |
| 17 | `Videos.aDNA` | `VideoForge.aDNA` + `VideosOld.aDNA` ⚠ | ⛔ none |
| 18 | `VisualDNA.aDNA` | `VisualDNA.aDNA` | ⛔ none |
| 19 | `WebForge.aDNA` | `WebForge.aDNA` + `Websites.aDNA` | ⛔ none |

**18 / 19 unlicensed.**

### ⚠ Incidental finding while deduplicating — `Videos.aDNA` has no remotes at all

The **canonical** directory `~/aDNA/Videos.aDNA` returns **empty** for `git remote -v`. Its two
back-compat shim directories (`VideoForge.aDNA`, `VideosOld.aDNA`) still carry the Codeberg `origin`
from the Wave-1b host-move. ⇒ **the canonical working copy cannot push or pull**, and any sweep that
reads the canonical dir reads *"no origin"* while two shims read Codeberg.

⛔ **Not repaired here** — it belongs to the owning graph (Iris) and to the shim registry (Hestia,
Standing Rule 9). Recorded because a fleet sweep keyed on canonical directories would silently miss
this repo entirely, and **that is a denominator defect, which is the class this whole document is
about.**

## §4 · Public lane — proportionally worse, and actually distributed

The same predicate, applied to ADR-013 **row 1** (public / released FOSS → GitHub-public):

| Graph | GitHub-public since | `LICENSE` at HEAD |
|---|---|---|
| `aDNA.aDNA` | 2026-06-22 (Wave 2 canary) | ✅ MIT |
| **`Git.aDNA`** | **2026-06-20 (P5 beachhead)** | ⛔ **none — this vault** |
| `III.aDNA` | 2026-06-22 | ⛔ none |
| `Canvas.aDNA` | 2026-06-22 | ⛔ none |

**3 / 4 unlicensed.**

> ⭐ **The finding was located in the Codeberg lane and bites hardest in the public one.** The Codeberg
> set is **private and undistributed** — the ToS exposure is real but latent, and nothing has been
> published under wrong terms. The public set is **being distributed right now**, publicly readable,
> under what default copyright makes *all rights reserved*: no grant to read, fork, or reuse. A reader
> who forks `Git.aDNA` today has no license to do so, and this vault's entire thesis is portability and
> open standards.

*(`Astro.aDNA` carries **BSL-1.1** and is correctly **private** and correctly **not** on Codeberg — the
operator's 2026-06-22 ruling. It is the second proof that the mechanism works when invoked.)*

> ⛔ **THE TABLE ABOVE IS SUPERSEDED IN SCOPE. It is preserved unedited** — it is the reading ADR-013 A1
> was signed against, and §7's precedent is that a superseded reading is kept, never overwritten.
> **Its rows are each still correct. Its population is not the population that matters.** See §4.1.

### §4.1 · ⛔ The denominator was wrong, and it was a third party who found it

Berthier (`aDNALabs.aDNA`, 2026-08-24, `severity: medium-high`) re-measured this lane at the forge
before letting ADR-024 rest on it, and reported that the enumeration above **cannot see** public repos
that have no local directory. **Re-derived at this desk rather than adopted** — the operator's ruling at
the plan gate, and the same discipline he applied to us:

```sh
gh api "orgs/aDNA-Network/repos?per_page=100&type=public"   # rows, and rows with .license == null
```

| Reading | Taken | Public repos | `license == null` |
|---|---|---|---|
| **#1 — pre-act** | `2026-08-25T01:15:19Z` | **20** | **16** |
| **#2 — post-act** | `2026-08-25T01:16:13Z` | **20** | **15** |

**Berthier's 20 / 16 reproduces exactly**, independently, before any of it was written down.

⛩ **His sentence is the transferable half, and it is aimed at §6 of this very document:**

> **A caveat on the numerator is not a caveat on the denominator.** An enumeration anchored to the local
> workspace cannot see what exists only on the forge, and no amount of care about *what you counted*
> protects you from *what you never walked past*.

⭐ **The sharp form is that §6 already carried the right instinct pointed at the wrong quantity.** It
says *"not a remote reading"* and then guards only the numerator — a license added server-side and never
fetched. It never occurred to the author that the *set of repos* was equally a remote fact. **The
caveat was present, correct, and useless against this.**

### §4.2 · ⚠ Two populations, not one wrong number — stated because the correction must not overclaim

Re-derivation surfaced something the reporting table did not carry: **20 and 4 answer different
questions.** The licensed complement at the forge is `aDNA` [MIT] · `adna-legacy` [MIT] ·
`aDNA.aDNA` [MIT] · `spacemacs` [GPL-3.0] — and `adna-legacy` is the archived template, `spacemacs` a
fork carrying **upstream's** GPL, `community-policies` not a graph at all.

| Population | Question it answers | Reading |
|---|---|---|
| **Governed** — ADR-013 row 1 graphs | of the graphs this policy *placed* public, how many lack a license | **3 / 4** (§4, correct for its scope) |
| **Forge** — everything public at `aDNA-Network` | how many *publicly distributed artifacts* lack a license | **16 / 20** (pre-act) |

⛔ **This does not soften the finding; it sharpens it.** The gap between the populations is **13 public
repos that the governed enumeration could not discover** — twelve pushed in one batch 2026-07-13, plus
`community-policies` (2026-08-22), all non-empty and pushed, all absent from both Berthier's vault and
the workspace router. *The defect was never that we counted 4 badly. It is that governance did not know
there were 20.*

⛔ **The 13 are NOT ours to license or to judge.** ADR-024 §6 carries them as an open disposition —
*investigate before deciding* — because under ADR-013 public is for **released** FOSS and nothing in
that batch was released, so "add MIT" would ratify a placement while appearing to fix it. **We record
the count and propose no remedy.**

### §4.3 · ⚠ Stated limits of the NEW instrument — it must not repeat the class it corrects

- ⛔ **Denominator.** Page-completeness is **asserted, not assumed**: `per_page=100` returned **20** rows
  on both readings, and 20 < 100 proves a single unpaginated page. Were it ever to return exactly 100,
  the read is truncated and must paginate before the number is used.
- ⛔ **Numerator.** GitHub's `license` field is populated by **detection** over a recognised LICENSE file
  at the repo root. A repo carrying custom terms, or license text under an unrecognised filename,
  reports `null` while being licensed in fact. ⇒ read this as ***at most* 16 unlicensed** — the exact
  mirror of §3's *"at least 18 of 19"*, and stated in that shape deliberately.
- ⚠ **Still only two lanes.** This instrument enumerates the **GitHub** org. The Codeberg lane of §3
  remains locally-enumerated and inherits the identical denominator exposure — **it has not been
  re-derived forge-side and is not claimed to be.**

### §4.4 · ⭐ This vault's own row is closed, and the delta is the proof

`Git.aDNA` was public since 2026-06-20 and unlicensed — the row this document named against itself.
**`LICENSE` (MIT, `Copyright (c) 2026 aDNA Labs`, byte-identical to `Exchange.aDNA/LICENSE`, md5
`b189a964…`) committed `b6c070c` and pushed to `origin` at `2026-08-25T01:16Z`** under ADR-024, which
made the choice performable for the first time — ADR-013 places repos, it never licensed them.

⭐ **The two readings straddle the act, and that is the verification, not bookkeeping.** Unlicensed went
**16 → 15**; `Git.aDNA` left the null set; the forge's own view reports `license=MIT`, `private=false`;
anonymous `ls-remote` returns `b6c070c`. *A push that reports success is an assertion. A denominator
that moves by exactly the repo you touched is a measurement, taken by an instrument that knows nothing
about your exit code.*

⚠ **`III.aDNA` and `Canvas.aDNA` remain public and unlicensed.** They are Rule-10 theirs; the asks are
**owed and unsent** — the memo lane was declined at this sitting's gate. Recorded so a reader does not
mistake 15 for progress on their behalf.

## §5 · Root cause — a deliberate rule, doing exactly what it says

`.adna/how/skills/skill_project_fork.md:100`:

```
rm -f LICENSE            # R4: no template LICENSE (project picks own license)
```

The template `.adna/` **does** carry a `LICENSE`. Fork **removes it, by rule**. And **no subsequent
step ever asks the project to pick one**:

- `what/doctrine/doctrine_gitops_block.md` — the per-graph doctrine every aligned graph inherits —
  contains **no `licen*` / `foss` / `tos` token whatsoever**;
- no P6 wave runbook carried a license precondition;
- no `git/` wrapper field declares a license;
- ADR-013 states the predicate and never assigns anyone to establish it.

> ⛔ **R4 is defensible in isolation and incoherent in composition.** It keys the license to a **phase**
> — *"the project picks own license"*, later, by someone — while ADR-013 keys **host placement** to an
> **observable it assumes already exists**. Nothing bridges the two, so "later" never arrives, because
> nothing is watching for it.
>
> ⭐ **This is verbatim the rule Pandora paid for and this vault recorded at F-C36 on 2026-08-23:
> *key a retirement condition to the observable it waits for, never to a phase expected to deliver
> it — a phase can complete by deciding.* We wrote that sentence down and then found its own instance
> sitting in our tree the same week.**

The two licensed graphs are exactly the two where a human made an explicit licensing decision
(`Exchange` MIT · `Astro` BSL-1.1). **The mechanism works whenever it is invoked. It is simply never
invoked.**

## §6 · What this measurement does NOT license

- ⛔ **Not "we are in breach of Codeberg's ToS."** That is a legal reading and it is not ours to make.
  What is measured is narrower and sufficient: **ADR-013's own stated predicate does not hold for 18 of
  19 repos it placed.** Whether Codeberg treats an unlicensed private repo as a violation is a question
  for the operator and Berthier, and it is **asked**, not answered, in the memo.
- ⛔ **Not a remote reading.** Every row is measured at the **local canonical tree's `HEAD`**. A license
  added server-side through the Codeberg web UI and never fetched would not appear here. `TypeScript.aDNA`
  was checked for divergence (`## master...origin/master`, no ahead/behind marker) and is in sync; **the
  other 18 were not divergence-checked.** ⇒ **the confirming read is a re-measure at the act**, exactly
  as `context_sync_runbook` §4.1 requires — *"re-measure immediately before, never from this document."*
- ⛔ **Not a forge-side population — and the caveat above does NOT cover this.** *(Added 2026-08-24 after
  Berthier's correction; see §4.1.)* The bullet above guards the **numerator**: what a row might say. It
  says nothing about the **denominator**: which rows exist at all. §3 and §4 both enumerate from **local
  vault directories**, so a repo that exists only at the forge is not measured-wrong — **it is never
  measured.** The GitHub lane has since been re-derived forge-side (**20 public, not 4**; 13 repos
  invisible to the local walk). **The Codeberg lane of §3 has not been, and inherits the same exposure.**
  ⇒ any future fleet census must state the enumeration's **source of truth**, not only its precision.

  ⭐ **Recorded as a class, not a slip, because it turned up twice in one day one lane apart**: Hestia's
  independent probe measured **69** wrapper-carrying graphs where this desk had measured **44**, by the
  identical mechanism. Two desks, two instruments, same direction, same week ⇒
  **local-tree enumeration standing in for a forge-side (or fleet-side) population.**

  ⚠ **What reproduced in both cases is the number that governs.** Hers: `0 dangling`. Ours: the Codeberg
  count, re-run at `21:35Z` and again by Berthier. **The disagreement is in scope; the agreement is in
  safety.** Neither correction reverses either finding — the public lane is *worse* than this document
  said, not better.
- ⛔ **Not a remediation plan.** Which license, and whether the 21 live repos are fixed now or at each
  graph's next open-flow, are **Berthier's** to decide. R4 itself is **Rosetta's** — it lives in
  `.adna/`, which we do not edit (Standing Rule 1).
- ⛔ **Not a blocker on obj 5 by itself.** It makes obj 5's precondition **P7 measurably NOT SATISFIED**.
  Whether to clear it, waive it in writing, or re-choose the mirror shape is the operator's call at the
  outward gate — and it is now a call made **against a number** instead of an assumption.

---

## §7 · Second reading — `2026-08-24T21:35Z` (appended, not substituted)

> **Why a second reading exists.** §6 of this document states its own confirming requirement:
> *"the confirming read is a re-measure at the act — re-measure immediately before, never from this
> document."* The [[disposition_ledger]]'s **License-state roster** (ADR-013 A1 §3) is being built
> **from** these figures, which makes writing the roster an *act* in exactly that sense. ⭐ *A baseline
> captured before the window is a claim; one captured at the window is a control.* The 03:52Z reading
> is preserved above unedited — **it is still the reading ADR-013 A1 was signed against**, and a
> historical measurement is falsified, not improved, by editing it.

### §7a · Both headline figures reproduce exactly

| Lane | 03:52Z | 21:35Z | verdict |
|---|---|---|---|
| Codeberg — distinct repos | 19 | **19** | unchanged |
| Codeberg — unlicensed | 18 | **18** | ✅ reproduces |
| GitHub-public (row 1) | 4 | **4** | unchanged |
| GitHub-public — unlicensed | 3 | **3** | ✅ reproduces |
| **Published total unlicensed** | **21 / 23** | **21 / 23** | ✅ reproduces |

The licensed set is unchanged and its SPDX ids were re-read **at the object** (`git show HEAD:LICENSE`)
rather than carried from prose: `Exchange.aDNA` **MIT** · `aDNA.aDNA` **MIT** · `Astro.aDNA`
**BSL-1.1** (private, correctly not on Codeberg — the licensed control, not one of the 23).

⭐ **Recorded as MEASURED-AND-UNCHANGED, not as "nothing happened."** *No change is only a finding if
someone looked* — and on the day A1 §3's clause is discharged, the alternative was to enumerate a
ledger from a figure nobody had re-checked.

### §7b · ⭐ §6's divergence caveat is now CLOSED for the last-known remote state

§6 recorded a real limit: *"`TypeScript.aDNA` was checked for divergence… **the other 18 were not**"* —
so a license sitting in a fetched-but-unmerged remote commit would have been invisible. Closed by
measuring the predicate **at the tracking ref as well as at local `HEAD`**:

```bash
h=$(git -C "$v" ls-tree --name-only HEAD      | grep -icE '^(license|licence|copying)')
r=$(git -C "$v" ls-tree --name-only "@{upstream}" | grep -icE '^(license|licence|copying)')
```

**All 22 repos carrying an upstream agree between the two refs** (`0|0` × 20, `1|1` × 2). No repo is
`behind`; every divergence is `ahead` (largest: `WebForge.aDNA` +677, `Container.aDNA` +146,
`Spacemacs.aDNA` +58, `Forgejo.aDNA` +62, `Git.aDNA` +25).

⛔ **The residual limit, stated rather than glossed.** This is still **not a remote reading**. A
`LICENSE` added server-side through a web UI *since the last fetch* would appear in neither ref, and
some tracking refs are stale by weeks (`WebForge.aDNA` 2026-07-04, `Molecules.aDNA` /
`VisualDNA.aDNA` / `Spacemacs.aDNA` 2026-07-05, `III.aDNA` 2026-07-07). **No fetch was performed** —
this sitting is non-outward by ruling. ⇒ what is now excluded is the *fetched-but-unmerged* class;
what remains open is the *never-fetched* class, and the roster says so per-row rather than implying a
freshness it does not have.

### §7c · ⛔ NEW denominator defect — `Oration.aDNA` has a remote and no upstream

`Oration.aDNA` returns a Codeberg `origin` (so it enters this population by the §2 predicate) but its
local `master` has **NO TRACKING BRANCH** — `rev-parse --abbrev-ref @{upstream}` fails. It therefore
cannot be divergence-checked at all, and any sweep keyed on `@{upstream}` **drops it silently**.

⭐ **This is the same class as §3's `Videos.aDNA` finding, found by a different probe.** There the
canonical directory had *no remotes*; here it has a remote and *no tracking ref*. Both are **denominator
defects** — a repo that a reasonable sweep does not count — and both were invisible to the predicate
that found the other. ⛩ *Two instruments, two blind spots, and neither would have found the other's
case.* Recorded as `unlicensed` with an explicit `upstream: none` marker on its roster row rather than
being quietly dropped or quietly assumed.

⛔ **Not repaired here** — it belongs to the owning graph (Robert Kennedy) under Rule 10, and the
`ahead`-count backlogs above belong to their own graphs. Recorded because **a roster built on a sweep
that silently drops rows is the exact defect this document exists to document.**
