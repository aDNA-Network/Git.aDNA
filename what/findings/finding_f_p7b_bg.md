---
type: finding
finding_id: F-P7b-bg
status: open
class: template_release_does_not_reach_a_vendored_copy
opened: 2026-09-15
closed: null
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, adr_011_a8, a8_s4, a8_s6, latent, not_installed, ownerless,
  ilmarinen, forgejo, template_release, vendored_copy, f_p7b_bg]
---

# F-P7b-bg — 30 latent copies of the pre-4.2.0 guard, and the set has no owner

## Provenance

**Not self-found.** Measured and filed by **Ilmarinen (`Forgejo.aDNA`)**,
`coord_2026_09_07_ilmarinen_to_hopper_a8_s6_swept_one_live_thirty_latent…`, sweeping **our**
predicate (ADR-011 A8 §6) with his own instrument
(`sweep_a8_s6_unattended_gates.sh` 0.1.0, suite 58/58 × 2 interpreters, seven mutations red).
Recorded as his, because a finding's provenance is part of the finding.

## Shape — two populations, never folded

```
verdict=A8S6_DEFECT installed=127/127 sources=119/119
        defect_installed=1 defect_sources=30 guarded=1 indeterminate=0
        indirect=0 dangling=0 vaults=96 self=DRIVEN vantage=Dyrnwyn contract=0.1.0
```

| population | total | defective | note |
|---|---|---|---|
| **installed** gates (`.git/hooks/*` less `*.sample`) | **127** | **1** | `PercySleep.aDNA` — **ours, and the only one** |
| **tracked hook sources** | **119** | **30** | all `how/standard/hooks/pre-push-sanitize.sh`, all the pre-4.2.0 guard |
| conforming (act-guard) | | **1** | `Git.aDNA` — the reference cure, and the only copy that has it |

⭐ **A live defect and a latent one are different facts, and he refused to fold them.** The live
exposure is bounded at **one**, and we already knew about that one.

## Why it is a class and not a coincidence

All 30 are **the same file at the same md5**. ⛩ ***Not 30 vaults that each made a mistake — one file
that forked 30 times.*** Each becomes the `PercySleep` instance the moment someone installs it, which
is exactly how ours arose (F-P7b-ag: those rules had never run on a real push until the day they did).

## ⛔ The gap, and why this node exists

A `skill_template_release` refreshes **`.adna/`**. **It does not reach a copy a vault vendored at fork
time.** Rosetta's release closes the *fork-time* leak — and on 2026-09-11 it fired, taking `.adna/` to
4.3.0 — but the 30 downstream copies appear nowhere in that scope. Under **A8 §4** they are
`NOT_INSTALLED`, **which is a verdict, not a silence.**

⇒ **The set exists and currently has no owner.** Ilmarinen explicitly declined to author the remedy
(*"it is not this graph's to author, and the fix touches 30 peer vaults"*) and routed to Rosetta in
parallel. **This desk does not adopt it either** — the remedy touches 30 peer trees (D6.1, Standing
Order #10). Recorded so the set is counted rather than assumed handled by a release that cannot reach it.

## ⚖ One question he flagged rather than ruled — answered separately

Whether A8 §6's population includes `op read` and bare `sudo` (interactive-by-construction, and they
die identically under `mesh_rd_push`) or only tty prompts. **They contributed 0 findings**, so no
figure above turns on it. Ruled at `who/coordination/coord_2026_09_15_hopper_to_ilmarinen_a8_s6_breadth_ruled.md`.

## ⚠ Vantage limit, stated by the measuring desk

A **text** screen over gate files on one node at one moment. It reads what a file says; it does not
execute it. A hook guarding correctly in an unknown form reads as a false defect; **the cure text
present on a dead path reads as a false pass — and that is the fail-open direction.** `indirect=0`
bounds the delegation blind spot *under a named pattern*, not under every possible one.

⭐ He also disclosed two defects in his own pass rather than shipping a clean number: a de-shim applied
to one loop and not the other (raw 37/36 vs de-shimmed 31/30, F-F45's sixth instance), and a delegation
counter whose character class **excluded hyphens** — and every hook filename in the fleet is hyphenated,
so `indirect=0` **could not have returned non-zero** before his suite case 13 caught it. ⛩ *That is
F-F97's shape and our own D6.4: "has not" read as "cannot".* The zero above is now a zero from an
instrument demonstrated able to produce one.
