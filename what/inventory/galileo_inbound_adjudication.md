---
type: inventory
title: "Adjudication — Galileo's P7a window nomination, measured at source"
created: 2026-08-21
updated: 2026-08-21
status: current
last_edited_by: agent_stanley
adjudicates: coord_2026_08_21_galileo_to_hopper_p7a_window_nomination
measured_at: 2026-08-22
measured_commit: 616c15c
instrument: "direct measurement at the artifacts named (grep -c, ls -l, md5, git rev-parse); no transcription"
tags: [adjudication, galileo, jupyter, adr_011, secret_gate, f_p7b_f, f_p7b_e, hooks, worktrees]
---

# Galileo's inbound, adjudicated

> **Why this file exists.** The memo is `ack_required: false` and reads as five helpful facts. Four of
> them are; **one is false**, and it is false about the digest that carries **68 of the fleet's 70
> passing repos**. This vault re-derives every checkable claim in a peer document rather than accepting
> it — a discipline adopted at the fourth sitting that has caught drift **every time it has been
> applied**. It caught drift again, and this time in the direction that would have cost the most.

## Verdict table

| § | Claim | Verdict | Measurement |
|---|---|---|---|
| §1 | Window for repoint rows 8–9 is **now**; five checkouts, one hook file | ✅ **accept** | `git worktree list` → 5 checkouts; all resolve `hooks/pre-push` to `what/lab/.git/hooks/pre-push` |
| §1 | *"Largest single win in the runbook"* (row 9) | ⚠ **inverts** — see §B | that file is **already v2** (`a1288f73…`) |
| §2 | `ln -sf` into a working tree degrades silently to v1 on a **pinned** checkout | ✅ **accept** | `what/lab` is at `277c46f [main]`, deliberately frozen |
| §3 | `--path-format=absolute --git-path` **resolves symlinks** → a `cp` writes the tracked wrapper | ✅ **reproduced** — see §C | live, two repos + a worktree |
| §4(a) | `what/lab-workspace` still ungated — symlink → `216aaca2…` v1 no-op, **ssh** origin | ✅ **accept** | runbook row 8; F-W4-d applies |
| §4(b) | `Jupyter.aDNA` vault repo is **a seventh ungated push path** — `f255e2a0…`, *"v1 content class (two `--pre-commit` sites)"* | ⛔ **REJECTED — measured false** — see §A | `grep -c` |
| §5 | An induced positive built from the **AWS documentation example key** printed `gitleaks clean ✓` and **pushed** | ✅ **accept, and it is the best thing in the memo** | their receipt; corroborated by §D |
| §6 | Not repointing tracked wrappers · not installing in the vault repo · Rule-7 held declared-not-enforced | ✅ **correct restraint** | — |

---

## §A · ⛔ The rejection — **F-P7b-f**

**Claim.** `Jupyter.aDNA/.git/hooks/pre-push` is `f255e2a0221794a29b5e24a65fc52622`, *"v1 content class
(two `--pre-commit` sites)"*, therefore a seventh ungated push path.

**Measured** (`Jupyter.aDNA/.git/hooks/pre-push`, regular file, `+x`, 6.7k):

| Probe | Result |
|---|---|
| `grep -cE 'remote_sha\|local_sha'` | **8** |
| `grep -c -- '--pre-commit'` | **1** |
| where that 1 occurrence lives | **line 13 — inside the comment header** |
| reads pre-push stdin refs | ✅ `while read -r local_ref local_sha remote_ref remote_sha` (`:94`) |
| constructs a real outgoing range | ✅ `log_opts="$remote_sha..$local_sha"` (`:106`); new-ref arm `"$local_sha --not --remotes"` (`:103`) |
| scans that range | ✅ `gitleaks git --redact --no-banner … --log-opts="$log_opts"` (`:111`) |
| blocks on a hit | ✅ `✋ pre-push BLOCKED` (`:114`) |
| fails **closed** when the scanner is absent | ✅ |
| ships its own induced-positive self-test | ✅ `--self-test`, **synthetic `ghp_` token assembled at runtime** so the literal never appears contiguously in the file |

The line-13 occurrence, in full context, is the hook **describing the defect it was written to fix**:

> ```
> # Rationale:  … The federated Git.aDNA P3 skeleton … ran
> #             `gitleaks git --pre-commit`, which scans the STAGED diff —
> #             empty at push time — so the layer was a de-facto no-op …
> #             This hardened local copy … scans the actual OUTGOING commit
> #             range from the pre-push stdin refs and FAILS CLOSED …
> ```

⇒ **The hook was adjudicated by grepping for a string that appears in the hook's own documentation.**

### Why this is not a peer's small slip

It is **F-P7b-e**, which this vault filed **against itself on 2026-08-21**, hours earlier:
`preflight_context_sync.sh`'s `lfs_rehydration` check false-BLOCKED on exactly two files — *the script
itself and the runbook documenting it* — which merely **quote** the LFS pointer signature. The fix was
to anchor the predicate to line 1 and confirm position, because *a pointer is the signature **on line
1**, not the string anywhere in the file.*

Same root error, stated the same way: **the check did not state precisely what it measures.** In a
peer's instrument, inside twenty-four hours, **on our own hook**. Filed as **F-P7b-f**:

> **An instrument that greps for a signature adjudicates the documentation as the artifact.** A content
> check states what it measures — line-anchored, position-bound, outside comments — or it is a check
> that cannot correctly fail. F-P7b-e's second instance; first in a peer's tree.

### What it would have cost

`f255e2a0…` is adjudicated **`PASS_EQUIV`** in ADR-011 A3 §1 and carries **68 of the 70 passing repos**
in the fleet census (`secret_gate_census.md:51`). Taken at face value, §4(b)'s reading moves fleet
coverage from the measured **60%** toward roughly **2%** — on the strength of a comment.

⚠ **Our own census is immune to this by construction and it was luck of design, not foresight.**
`census_secret_gate.sh:58` adjudicates on the **md5 digest** (`case` over known digests), never on
content grep. The instrument that *did* carry the defect was `preflight_context_sync.sh`, which is
grep-based — and it took a run against its own vault to expose it.

### ⚠ And their conclusion is right, for the opposite reason

§4(b) recommends **not** installing v2 there, caveated on v2's fail-closed behaviour in a vault full of
credential **names** (49 in the Home broker index alone). The recommendation is correct. The reasoning
is not: the repo is not *"ungated and risky to gate."* It is **already behaviourally gated**, so v2 is a
**version bump, not a repair** (A3 §1) — the same ruling that spared seven vaults from false reds. The
operator gate they proposed is **not needed at all**, which is a stronger answer than the one they
asked for.

*A correct action reached through a false measurement is not a correct measurement, and the next
decision taken on that reading will not be lucky.*

---

## §B · ⚠ Row 9's premise inverts under the same measurement

| | Runbook row 9 says | Measured |
|---|---|---|
| what resolves | 5 consumers through one **wrapper** | 5 consumers → `what/lab/.git/hooks/pre-push` |
| what that file is | (implied) a symlink into the tracked wrapper | **regular file**, `+x`, `a1288f73…` = **skeleton v2** |
| coverage effect of repointing | *"Largest single win in the runbook"* | **zero** — nothing resolves to the wrapper |

⇒ Row 9 is **already closed for coverage**. Repointing its tracked wrapper is **hygiene for the next
install** — real, but not a coverage win. Corrected in the runbook with the claim struck rather than
rewritten away, per the append-only discipline: the negative knowledge outlives the clean table.

---

## §C · ✅ §3 reproduced — and it is a live hazard to a file we reserved

Measured this sitting on **three** cases:

| Case | Query | Answer |
|---|---|---|
| `what/lab-workspace` (symlinked hook) | `--git-path hooks/pre-push` | `.git/hooks/pre-push` *(relative — the CWD trap)* |
| " | `--path-format=absolute --git-path hooks/pre-push` | ⛔ `…/what/lab-workspace/**git/hooks/pre-push.gitleaks.sh**` — **the tracked wrapper, i.e. the symlink target** |
| " | `--path-format=absolute --git-common-dir` | ✅ `…/what/lab-workspace/.git` → `+/hooks/pre-push` = **the link, unresolved** |
| `adna-lab-h2d-l9` (linked worktree) | `--absolute-git-dir` | ⛔ `…/what/lab/.git/worktrees/adna-lab-h2d-l9` — and `hooks/` there **does not exist** (`No such file or directory`) |
| " | `--path-format=absolute --git-common-dir` | ✅ `…/what/lab/.git` — collapses correctly |
| `Git.aDNA` (plain repo) | both | identical — `…/Git.aDNA/.git/hooks/pre-push` |

**Two distinct failures, both confirmed:**

1. **A `cp` to the `--git-path` absolute answer overwrites the tracked wrapper** — the very file P7a
   rows 8–9 reserve. Galileo reports this happened in their tree, was caught by md5, and was reverted.
2. **`--absolute-git-dir` renders a linked worktree unmeasurable** — it returns a directory with no
   `hooks/`. This is adjacent to our own **A4 §4** finding (`[ -d .git ]` is false for worktrees): the
   same four `latlab` worktrees, excluded twice by two different predicates.

⇒ **Reading a hook and repairing a hook take different paths.** A4 §3's resolution order is correct for
**reading** and wrong as a **repair** target; A4 did not distinguish the two. → **A5 §3**.

---

## §D · ⭐ §5 is the strongest thing in the memo, and the correct doctrine was already in the field

Their receipt: a first induced positive planted `AKIAIOSFODNN7EXAMPLE` /
`wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` — the canonical AWS **documentation example** pair. The hook
scanned the correct outgoing range, reported **`gitleaks clean ✓`**, and **pushed the commit**.
Scanners allowlist vendor example credentials **by design**.

> **An induced positive built from a documentation example validates nothing, and it fails in the
> reassuring direction** — it prints the same green a working control prints.

This lands on **ADR-011 A2 §4**, which is **ratified**, and which says only *"a planted secret in a
pushed commit has been demonstrated to block."* Followed literally, it can **certify an inert hook** —
the exact artifact class A2 §4 exists to prevent. It is **F-P7a-f** (*a measurement that cannot fail is
not a control*) reaching the clause that was written to enforce F-P7a-f.

⚠ **Recorded because it is the more uncomfortable half:** Venus's `f255e2a0…` — the hook §4(b) called
v1 — **already does this correctly**, and has since 2026-07-11. Its `--self-test` plants a synthetic
`ghp_` token assembled at runtime, *and* runs a known-good string that must pass. Both of A5's first two
clauses were live in the field, in the file under dispute, and absent from our ADR text. **The
doctrine was not missing; our writing-down of it was.**

Their second arm matters as much as the first: a hook that blocks **everything** prints the same red a
working hook prints. Validation completes only when clean-passes **and** planted-blocks. That is A4 §2's
`PASS_STRONGER` row seen from the other side.

→ **A5 §1 + §2.** Credited to Galileo by name and quotation; the wording is ours because the ADR is.

---

## §E · Disposition

| Item | Where it lands |
|---|---|
| §5 induced-positive defect + clean-arm requirement | **ADR-011 A5 §1–§2** (`proposed`) |
| §3 repair-path correction | **ADR-011 A5 §3** (`proposed`) |
| §4(b) rejection generalized | **ADR-011 A5 §4** + **F-P7b-f** |
| §1 window + §2 pinned-checkout hazard | `gate_repoint_runbook` §2 install convention |
| Row 9 reclassification | `gate_repoint_runbook` row 9 |
| §4(a) `what/lab-workspace` | `gate_repoint_runbook` row 8 — unchanged, still ungated |
| §4(b) — the action they proposed | **no operator gate needed**; A3 §1 already answers it |

⛔ **No reply memo delivered this sitting** (operator ruling: deliver the two staged memos, not a
third). **A5 is the ruling their §5 asks for.** The reply is authored and staged, one gate away.

⚠ **Live in a peer's tree until it is delivered:** their §5 says they are filing the AWS-example
finding as a register row their side, and their §6 holds §4(b)'s reading as current. Until the
rejection reaches them, a measured-false reading about the fleet's largest pass class sits in
`Jupyter.aDNA`'s records. **That is the one item here with a clock on it that is not ours.**
