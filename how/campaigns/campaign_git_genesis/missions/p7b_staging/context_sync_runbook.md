---
type: runbook
title: "P7b obj 4 — context-sync round-trip runbook (mesh git lane)"
created: 2026-08-21
updated: 2026-08-21
status: staged            # ⛔ FIRES NOTHING. Every section needs its own operator gate (Rule 10).
last_edited_by: agent_stanley
mission: p7_mesh_git_spike
objective: 4
executes: adr_015_d3      # ratified accepted rev 4, 2026-08-21
measured_against: what/inventory/context_sync_lane_assignment.md   # measured_at 2026-08-21T23:49Z
tags: [runbook, p7b, obj_4, context_sync, round_trip, mesh, staged, non_outward_authored]
---

# Context-sync round-trip — runbook

> ## ⛔ §0 · This document fires nothing
>
> Authored in a **non-outward** sitting (operator gate, 2026-08-21). No repo was created, nothing was
> pushed, no peer vault was written. Every section below is **staged** and takes its own operator gate.
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
| P1 | Subject vault passes `preflight_context_sync.sh` with **0 BLOCK, 0 UNKNOWN** | Hopper | ⚠ `Git.aDNA`: 7 PASS / 1 BLOCK — `clean_tree` only, clears at session commit |
| P2 | Forge reachable, anonymous surface behaves | Ilmarinen | ✅ `200`/`303`+`Location`/`401` all measured live (§5) |
| P3 | SSH leg usable — alias form, dedicated key | Hopper | ✅ `rd-forge` alias present, `IdentitiesOnly yes`, `~/.ssh/id_ed25519_rd_forge` |
| P4 | A **far side** that is genuinely far | operator | ⛔ **NOT SATISFIED** — see below |
| P5 | Outward-action gate open for push + clone | operator | ⛔ closed (this sitting is non-outward by ruling) |
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
diff -r --no-dereference ~/aDNA/Git.aDNA "$DST/Git.aDNA" -x .git
```
**PASS requires all three**: HEAD equal **and** tree-hash equal **and** `diff -r` empty.
**Fails if** any differ. `--no-dereference` is load-bearing: without it `diff` follows the `git →
how/federation/git` symlink and compares targets, so a **broken link would compare equal**. That is a
check that could not fail, in a runbook whose subject is checks that cannot fail.

Then, the clause a hash equality does not cover:

```bash
test -L "$DST/Git.aDNA/git" && readlink "$DST/Git.aDNA/git"   # resolves inside the clone?
grep -rl 'git-lfs.github.com/spec/v1' "$DST/Git.aDNA" | head  # must be empty
```
**Fails if**: the symlink dangles, or any pointer file survived — *usable as context*, not merely present.

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

## §7 · Non-goals — named so a later reader does not widen this

- **Obj 5 (mirror-mesh federation) is NOT in this runbook.** It touches a second forge and is its own gate.
- **No `.adna/` edit** (Standing Rule 1).
- **No peer-vault write.** `Network.aDNA` and `Home.aDNA` are read-only sources throughout.
- **`LAVentureGraph.aDNA`'s `origin`-on-spike is NOT repaired here** — flagged, not edited; it belongs to
  the owning graph and to Venus's placement lane.
- **The 10 ungated `FAIL_NOOP` wrappers are NOT touched** — that is `gate_repoint_runbook`, separately gated.
- **`freshness_mode` is NOT declared here** — the conf shape is Berthier's pen (ADR-014 A4 §1a).
