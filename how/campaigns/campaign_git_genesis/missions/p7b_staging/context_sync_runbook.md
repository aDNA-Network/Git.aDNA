---
type: runbook
title: "P7b obj 4 — context-sync round-trip runbook (mesh git lane)"
created: 2026-08-21
updated: 2026-08-21
status: executed          # ✅ SHAPE A FIRED 2026-08-22T01:17–01:20Z under an operator outward window. §6a carries the spike report. §3 shape B remains UNRUN (P4 unbuilt). §7 non-goals still fire nothing.
last_edited_by: agent_stanley
mission: p7_mesh_git_spike
objective: 4
executes: adr_015_d3      # ratified accepted rev 4, 2026-08-21
measured_against: what/inventory/context_sync_lane_assignment.md   # measured_at 2026-08-21T23:49Z
tags: [runbook, p7b, obj_4, context_sync, round_trip, mesh, staged, non_outward_authored]
---

# Context-sync round-trip — runbook

> ## ✅ §0 · This document FIRED — shape A, `2026-08-22T01:17–01:20Z`
>
> ~~*This document fires nothing.*~~ **Superseded, not rewritten.** Authored in a **non-outward**
> sitting (operator gate, 2026-08-21); **fired the next sitting** under an operator-opened outward
> window, in the shape §3 recommended. **Result: [[#⭐ §6a · SPIKE REPORT — the trip ran, 2026-08-22T01:17–01:20Z|§6a]] — PASS.**
>
> ⛔ **What fired is §4 only, once, as shape A.** §3 shape B is **unrun** (P4 unbuilt). §7's non-goals
> are untouched. **This is not a standing authorisation**: the next outward act takes its own gate.
>
> **Why staged before executed, deliberately:** the same reason `flip_runbook` was staged against an
> unratified ADR — *so ratification knows what execution costs.* It paid twice over. The preconditions
> were **measured** before the window opened, so the operator knew which were already satisfied and
> which were somebody else's; and writing the checks down in advance is what made it possible to
> discover, **at execution**, that two of them could not have passed (**F-P7b-g**, **F-P7b-h**).
>
> **Why staged before executed, deliberately:** the same reason `flip_runbook` was staged against an
> unratified ADR — *so ratification knows what execution costs.* Here it is one step further: the
> preconditions in §2 are **measured**, so the operator opening an outward window knows which of them
> are already satisfied and which are somebody else's to clear.

---

## §1 · What obj 4 actually is — corrected against measurement

The mission card reads as greenfield: *"point a graph's `git/` at `git.<subnet>.adna.network`… sync a
vault as the subnet's context."* **Measured, the lane is already live** — 20 distinct vaults carry a
mesh remote across three fabrics; 11 are enrolled on the R&D forge; `Git.aDNA` is one of them
(`mesh-rd → rd-forge:aDNA-Network/Git.aDNA.git`). See [[../../../../../what/inventory/context_sync_lane_assignment|lane assignment]] §3 (**F-P7b-b**).

⇒ **Obj 4 is not "make the lane exist". It is "prove the round-trip and measure what is true of it."**
A runbook written against the greenfield reading would have staged the wrong work — enrolling a vault
that is already enrolled, and proving nothing about the property under test.

**The property under test**, stated before any command is run:

> A vault pushed to the subnet forge and cloned from it **on the far side** yields a tree that is
> **byte-identical at a named object set** to the source at the pushed commit — and the clone is
> **usable as context**, not merely present.

The second clause is not decoration. LFS pointers, dangling symlinks, and case-folded paths all produce
a clone that *exists* and is *incomplete*, and every one of them passes a naive "did the clone succeed?"
check. §4 is written so each can fail.

---

## §2 · Preconditions — with owners, and with what is already true

| # | Precondition | Owner | State at `2026-08-21T23:49Z` |
|---|---|---|---|
| P1 | Subject vault passes `preflight_context_sync.sh` with **0 BLOCK, 0 UNKNOWN** | Hopper | ✅ **satisfied at `2026-08-22T00:0xZ`, HEAD `b5da2b9` — 8 PASS / 0 BLOCK / 0 UNKNOWN.** *(Earlier in the sitting this row read 7 PASS / 1 BLOCK and predicted the `clean_tree` BLOCK would clear at commit. It did — and the post-commit run then surfaced **F-P7b-e**, a false BLOCK on the instrument's own documentation, since untracked files are invisible to `git grep HEAD`. Both are fixed and the row is trued up rather than left reading its prediction.)* ⚠ **Still re-run at §4.1** — this row is a measurement with an expiry, not a gate. |
| P2 | Forge reachable, anonymous surface behaves | Ilmarinen | ✅ `200`/`303`+`Location`/`401` all measured live (§5) |
| P3 | SSH leg usable — alias form, dedicated key | Hopper | ✅ `rd-forge` alias present, `IdentitiesOnly yes`, `~/.ssh/id_ed25519_rd_forge` |
| P4 | A **far side** that is genuinely far | operator | ⛔ **STILL NOT SATISFIED** — unchanged by the trip. **Shape A ran instead**; §3 records what that costs in the sentence it licenses. |
| P5 | Outward-action gate open for push + clone | operator | ✅ **OPENED 2026-08-21** (AskUserQuestion). Fired §4 once, shape A. **Not a standing window** — the next outward act takes its own gate. |
| P6 | `freshness_mode` declared for the subject's enrollment | Berthier (conf patch) | ⛔ **field exists in no conf** (ADR-014 A4 §1a) |

### ⛔ P4 is the one that is not merely ungated — it is unbuilt

A round-trip cloned **back onto this same node** proves the forge stored the bytes. It does **not**
prove context-sync, because the thing context-sync is for is *another node reading the vault*. Cloning
to `/tmp` on the machine that pushed exercises none of: mesh routing from a different peer, that peer's
credentials, that peer's `git-lfs` presence, or symlink resolution in a different filesystem layout.

**A same-node clone is the strongest test available without a second node, and it is a weaker claim than
obj 4's exit gate.** Which of the two the operator authorises is a real choice, so it is §3, not a
footnote — and whichever runs, the spike report must say **which one**, because they license different
sentences.

### ⚠ P6 is the precondition that a push does not clear

`Git.aDNA`'s replica is 2 commits behind and does not carry ADR-015's ratification (**F-P7b-c**).
Pushing turns that row green and leaves the other ten unanswerable, because *whether a lag is a defect*
depends on a declared freshness mode that exists in no conf. **Do not let a green row on the subject
vault be read as the lane being healthy.** The lane cannot currently be adjudicated at all.

---

## §3 · Two lawful shapes for the trip — the operator picks one

| | **A · same-node round-trip** | **B · true far-side round-trip** |
|---|---|---|
| Far side | scratch clone on this node | a second mesh peer |
| Proves | the forge stored and returns the bytes | context-sync as D3 means it |
| Needs | P1 P2 P3 P5 | P1 P2 P3 P5 **+ a reachable second peer** |
| Available now | yes, when P5 opens | **no** — `luke-mesh` + `mesh` fabrics both unreachable from here (11 rows) |
| Licenses the sentence | *"the git lane round-trips on the R&D forge"* | *"the git lane carries subnet context"* |

**Recommendation: A now, B at the D4 production revisit** — and the spike report says **A**, in those
words. Reporting A's result in B's language is the transcribed-status class this campaign has filed
five times; it would be worse here because obj 4's *whole point* is the far side.

---

## §4 · The trip — commands, each with its failure condition stated first

> ⛔ **Nothing below has been run.** Every block is gated on P5.

**Subject**: `Git.aDNA` (dogfood — *we run on what we ship*). **Remote**: `mesh-rd`. **Branch**: `master`.

### 4.1 — Re-measure immediately before (never from this document)

```bash
bash how/tests/preflight_context_sync.sh --vault ~/aDNA/Git.aDNA
```
**Abort if**: any BLOCK or UNKNOWN. *The numbers in §2 are from `2026-08-21T23:49Z` and are a claim with
an expiry (F-DECL-03); the gate is the fresh run, never the table.*

### 4.2 — Record the pre-state

```bash
SRC=$(git -C ~/aDNA/Git.aDNA rev-parse HEAD)
git -C ~/aDNA/Git.aDNA ls-remote mesh-rd refs/heads/master   # replica tip BEFORE
```
**Fails if**: `ls-remote` returns nothing → the remote is unreachable; stop, this is not a push problem.

### 4.3 — Push *(OUTWARD — gate P5)*

```bash
git -C ~/aDNA/Git.aDNA push mesh-rd master
```
**Fails if**: the pre-push secret gate refuses (correct behaviour — do not bypass), or auth fails.
⚠ **Never `--force`.** The replica is a peer-readable artifact; a force-push rewrites what other nodes
may already hold, and the campaign's own doctrine is that provenance is sacred.

### 4.4 — Clone the far side *(shape A)*

```bash
DST=$(mktemp -d); git clone rd-forge:aDNA-Network/Git.aDNA.git "$DST/Git.aDNA"
```
**Fails if**: clone errors, or completes with warnings about LFS/symlinks — **a warning here is a
failure**, because it is exactly the "present but incomplete" state §1 named.

### 4.5 — Verify, on a named object set

```bash
git -C "$DST/Git.aDNA" rev-parse HEAD                      # must equal $SRC
git -C ~/aDNA/Git.aDNA  rev-parse "$SRC^{tree}"
git -C "$DST/Git.aDNA"  rev-parse "HEAD^{tree}"            # must be equal
git -C "$DST/Git.aDNA" status --porcelain                  # must be EMPTY — the checkout matches the tree it claims
while IFS= read -r f; do [ -e "$DST/Git.aDNA/$f" ] || echo "MISSING: $f"; done \
  < <(git -C ~/aDNA/Git.aDNA ls-files)                     # must print nothing
```
**PASS requires all four**: HEAD equal **and** tree-hash equal **and** the clone's own `status`
empty **and** zero missing tracked files.

> ### ⛔ §4.5's first version shipped a check that could not SUCCEED — **F-P7b-g**, found by running it
>
> ~~`diff -r --no-dereference ~/aDNA/Git.aDNA "$DST/Git.aDNA" -x .git`~~ … ~~*`diff -r` empty*~~.
> **Struck, not rewritten.** On the live run it returned three lines — `.DS_Store`,
> `.obsidian/graph.json`, `.obsidian/workspace.json` — every one **untracked *and* gitignored**.
>
> It compares a **working tree**, which accumulates local editor and Finder state, against a **fresh
> clone**, which by construction can hold only tracked content. ⇒ **that check can never be empty on
> any working tree that has been opened in Finder or Obsidian**, and it would have reported a
> **BLOCK on a round-trip that passed** (554 tracked files, **0** missing; clone `status` clean).
>
> **The exact mirror of the defect the struck line was reasoning about.** The `--no-dereference`
> clause below is correct and is kept — it guards a false *pass*. Two clauses later the same paragraph
> shipped a false *fail*. Both have one root: **the check did not state precisely what it measures.**
> Third instance in 48 hours (**F-P7b-e** could not fail · **F-P7b-f** matched documentation · this
> could not succeed), and the second authored here.
>
> **`--no-dereference` remains load-bearing** wherever `diff` is used against this tree: without it
> `diff` follows the `git → how/federation/git` symlink and compares targets, so a **broken link
> compares equal**. Its replacement, the clone's own `git status --porcelain`, catches that case
> directly — a dangling tracked symlink shows as modified.

Then, the clauses a hash equality does not cover:

```bash
test -L "$DST/Git.aDNA/git" && readlink "$DST/Git.aDNA/git" && test -e "$DST/Git.aDNA/git" \
  && ls "$DST/Git.aDNA/git/"                                  # resolves inside the clone, with content?

# LFS: a pointer is the signature ON LINE 1 — never the string anywhere in the file (F-P7b-e)
for f in $(grep -rl 'git-lfs.github.com/spec/v1' "$DST/Git.aDNA" | grep -v '/\.git/'); do
  head -1 "$f" | grep -q '^version https://git-lfs' && echo "REAL POINTER: $f"
done                                                          # must print nothing
```
**Fails if**: the symlink dangles or resolves to an empty directory, or any **line-anchored** pointer
survived — *usable as context*, not merely present.

> ### ⛔ The LFS check was **F-P7b-e's third instance, left standing in this document** — **F-P7b-h**
>
> ~~`grep -rl 'git-lfs.github.com/spec/v1' "$DST/Git.aDNA" | head  # must be empty`~~ — struck.
> On the live run it matched **2** files and would have failed the round-trip. The two files were
> **`preflight_context_sync.sh` and this runbook** — *precisely the pair F-P7b-e named last night*,
> which merely **quote** the signature. Line-anchored: **0** real pointers.
>
> F-P7b-e was fixed in the **script** and the identical un-anchored predicate was **copied into this
> runbook and left there**. ⚠ **A finding closed at its instance is not a finding closed** — the
> sentence ADR-011 **A4 §3** wrote about F-Astro, earned again here by its author, one day later.

### 4.6 — Post-state + teardown

```bash
git -C ~/aDNA/Git.aDNA ls-remote mesh-rd refs/heads/master   # replica tip AFTER == $SRC
rm -rf "$DST"
```

---

## §5 · Instrument controls — both fired live, `2026-08-21T23:37Z`

Per ADR-015 **§D1.5b**, a capture whose positive control did not fire is unproven. Both fired **before**
this runbook was written:

| Control | Expect | Measured |
|---|---|---|
| `GET /aDNA-Commons/exchange-proof/raw/main/README.md` | `303` **with** `Location` | ✅ `303`, `Location: …/raw/branch/main/README.md`, `num_redirects=0` |
| `GET /api/v1/user` (anonymous) | `401` | ✅ `401` |
| `GET …/raw/branch/main/README.md` | `200`, no `Location` | ✅ `200` |

⭐ The `303` row is the one that matters: `num_redirects=0` **while a `Location` header is present** —
the struck "redirect chain empty" column reading *empty* on a live redirect, exactly as **F-F25** said.
Re-fire both at the window; a stale control is not a control.

---

## §6 · Rollback

The trip creates **no new repo** and **no new remote** — the subject is already enrolled. There is
therefore nothing to un-create, and rollback is **not** "delete the repo":

- **If the push lands and the trip fails**: the replica now carries commits it did not before. That is
  **not** damage — it is the replica catching up to a local `HEAD` that was already public-facing. Leave
  it. Do **not** force-push it backwards.
- **If the push is rejected**: nothing changed anywhere. Record the rejection and stop.
- **The scratch clone**: `rm -rf "$DST"`. It is a temp dir and holds nothing authoritative.

---

---

## ⭐ §6a · SPIKE REPORT — the trip ran, `2026-08-22T01:17–01:20Z`

> **Shape A ran.** Same-node scratch clone. It licenses the sentence *"the git lane round-trips on the
> R&D forge"* — and **not** *"the git lane carries subnet context."* Written in those words on purpose:
> P4 is unbuilt, shape A exercises no mesh routing, no second peer's credentials, no foreign
> filesystem layout, and obj 4's whole point is the far side. **B remains owed at the D4 revisit.**

| Step | Gate | Measured |
|---|---|---|
| §4.1 preflight, fresh | 0 BLOCK / 0 UNKNOWN | ✅ **8 PASS / 0 warn / 0 BLOCK / 0 UNKNOWN** @ `aefcfb3` |
| §5 control — raw/main | `303` **with** `Location` | ✅ `303`, `Location: …/raw/branch/main/README.md`, `num_redirects=0` |
| §5 control — `/api/v1/user` | `401` anonymous | ✅ `401` |
| §5 control — canonical raw | `200`, **no** `Location` | ✅ `200`, `location` headers **0** |
| §4.2 replica tip BEFORE | reachable | ✅ `169eff4` — **7 commits behind** |
| §4.3 push | gate must not be bypassed | ✅ `169eff4..aefcfb3  master -> master` |
| §4.4 clone | no errors, **no warnings** | ✅ exit 0, zero warnings (re-run to confirm) |
| §4.5 HEAD | == `$SRC` | ✅ `aefcfb3e…dd7f` both sides |
| §4.5 tree-hash | equal | ✅ `77926c93…cfdb` both sides |
| §4.5 clone `status` | empty | ✅ empty |
| §4.5 tracked files | 0 missing | ✅ **554 tracked · 0 missing** |
| §4.5 symlink | resolves **inside** the clone | ✅ `git → how/federation/git`, target holds `CLAUDE.md`, `hooks` |
| §4.5 LFS, line-anchored | 0 real pointers | ✅ **0** (2 signature-quoting files, both expected) |
| §4.6 replica tip AFTER | == `$SRC` | ✅ `aefcfb3e…dd7f` |
| §4.6 teardown | scratch gone | ✅ |

### ⭐ The push output is itself a measurement

```
pre-push: gitleaks scanning outgoing range — refs/heads/master (169eff4…..aefcfb3…)
pre-push: gitleaks clean across 1 outgoing range(s) ✓
```

It **names the range it scanned**. Rosetta reported the retired no-op's output the same day: bare
`pre-push: gitleaks clean ✓`, no range, *having scanned nothing*. **The two outputs differ exactly
where the behaviour differs** — a third, behavioural corroboration that `f255e2a0…` is `PASS_EQUIV`
and that **F-P7b-f's rejection is right**, obtained in live operation rather than by inspection.

### What this does NOT license

- ⛔ **Not "the lane is healthy."** 11 mesh rows are **UNREACHABLE from here** — *unmeasured, not
  healthy* (**A4 §4**, one level up). One green row on the subject vault is one row.
- ⛔ **Not "the lag was a defect that is now fixed."** **F-P7b-c** closes *as an observation* — the
  replica now carries ADR-015's ratification, so a peer no longer reads our P7a gate as `proposed`.
  But **whether a 7-commit lag was a defect is still unadjudicable**: `freshness_mode` exists in no
  conf (**ADR-014 A4 §1a**, Berthier's pen). The push made **our** row green and left the other ten
  exactly as unanswerable as before. That is **F-A4-01's cost, paid rather than argued.**
- ⚠ **The replica is one commit behind again at session close** — this sitting's close commit lands
  after the trip. **Expected, not a defect.** Stated here so the next reader does not file it.

### Findings raised by running it

**F-P7b-g** (§4.5 `diff -r` could not succeed) and **F-P7b-h** (§4.5 LFS grep un-anchored — F-P7b-e's
third instance, copied into this document and left). **Both would have produced a false BLOCK on a
round-trip that passed**, and both sit in the §4.5 that reasons, correctly, about a check that could
not fail. ⇒ **the runbook's own §1 property statement was right and its instrument was not**: LFS
pointers and dangling symlinks *do* produce a clone that exists and is incomplete — and the checks
written to catch that caught the documentation instead.

## §7 · Non-goals — named so a later reader does not widen this

- **Obj 5 (mirror-mesh federation) is NOT in this runbook.** It touches a second forge and is its own gate.
- **No `.adna/` edit** (Standing Rule 1).
- **No peer-vault write.** `Network.aDNA` and `Home.aDNA` are read-only sources throughout.
- **`LAVentureGraph.aDNA`'s `origin`-on-spike is NOT repaired here** — flagged, not edited; it belongs to
  the owning graph and to Venus's placement lane.
- **The 10 ungated `FAIL_NOOP` wrappers are NOT touched** — that is `gate_repoint_runbook`, separately gated.
- **`freshness_mode` is NOT declared here** — the conf shape is Berthier's pen (ADR-014 A4 §1a).
