---
type: inventory
title: "The `git/` wrapper contract — release ledger"
created: 2026-08-24
updated: 2026-08-24
status: active
last_edited_by: agent_stanley
binds_adrs: [adr_004]        # ADR-004 Amendment A1 §1 — this file is the ONE place a bump is recorded
current_contract_version: "0.2.0"
pinned_at_commit: b321223f0ddd47af6bfc82c55c78cae5433ab75c   # HEAD at the cut; the commit a consumer refreshes FROM
supersedes_nothing: true      # first release ledger; the 0.1.0 row below is RECONSTRUCTED, and says so
tags: [inventory, git, wrapper, federation, contract_version, distribution, adr_004_a1, f_p7b_o, release_ledger]
---

# The `git/` wrapper contract — release ledger

> **What this file is.** The **single place** a `git/` wrapper-contract bump is recorded
> ([[../decisions/adr_004_provider_contract_interface|ADR-004]] **Amendment A1 §1**). A consumer vault
> reads the current row, performs [[../../how/skills/skill_git_wrapper_refresh|`skill_git_wrapper_refresh`]]
> in **its own** vault (Standing Rule 10), and sets its `federation_ref.version` to the row's version.
>
> ⛔ **This ledger gates nothing.** A1 §5 deliberately wires **no blocking check** to a contract version:
> *an enforcing check is a stronger claim on the world than a written clause, so shipping the check first
> inverts the order §7.7 exists to impose.* Gating on contract version would be a **new** amendment.

## Three version scales — kept separate on purpose

⛔ They are routinely conflated, and conflation is what produced F-P7b-o's two irreproducible counts.

| Scale | Lives in | Answers | Now |
|---|---|---|---|
| **Contract version** | `federation_ref.version` in each consumer wrapper · this ledger | *Which revision of the whole `git/` wrapper is this copy?* | **`0.2.0`** |
| **Hook contract version** | `HOOK_CONTRACT_VERSION=` inside the hook file | *Which revision of the pre-push hook is this file?* | `2.1.0` |
| **Vault version** | `Git.aDNA/MANIFEST.md` | *Which revision of the graph?* | unrelated — never a refresh signal |

⭐ A consumer at contract `0.1.0` carrying hook `2.1.0` is **possible and fine** — they took the hook and
not the schema. The two scales answer different questions, which is exactly why one number cannot serve both.

---

## Releases

### `0.2.0` — 2026-08-24 · the install surface, and the first bump ever cut

| | |
|---|---|
| **Pinned at** | `b321223f0ddd47af6bfc82c55c78cae5433ab75c` |
| **Hook** | `2.1.0` · md5 `04e6a745d1871da0bf1df97cb079b308` |
| **Scan config** | `.gitleaks.toml` · md5 `f36a0af201367f924308917aabc766b0` |
| **Refresh required?** | **Yes** for any consumer below `0.2.0` |
| **Breaking?** | No. The scan path is unchanged from `2.0.0`; the repairs are to the **install surface**. |

**What changed**

1. **The documented install line no longer assumes a pre-ADR-045 layout.** `2.0.0` documented
   `ln -sf ../../git/hooks/… .git/hooks/pre-push`, which resolves only where a root `git/` shim exists.
   ⛔ `ln -sf` **succeeds against a non-existent target** and git **silently skips** a hook it cannot
   execute ⇒ *the repo reads installed while behaving ungated.* `2.1.0` derives both ends
   (`--git-common-dir` + the script's own location): no shim, and no machine-absolute path.
2. **`--self-test` now asserts the install RESOLVES.** Until `2.1.0` it probed only the engine and
   therefore **passed on a dangling install** — absence indistinguishable from health.
3. **ADR-011 A6 is the classification rule** the verifier is built on: test for the presence of the
   **fix's mechanism**, never the absence of the **defect's name**.

**How a consumer refreshes** — [[../../how/skills/skill_git_wrapper_refresh|`skill_git_wrapper_refresh`]].
**How a consumer proves it landed** — `bash census_wrapper_copy.sh --vault <their-vault>` ⇒ expect `V2_1_0`.

---

### `0.1.0` — 2026-06-20 · ⚠ RECONSTRUCTED, not recorded at the time

| | |
|---|---|
| **Pinned at** | not recorded — no ledger existed |
| **Hook** | the **P3 skeleton**, md5 `216aaca254b97d69819562d506afca29` |
| **Status** | ⛔ **superseded and fail-open** — no push-range scan; **exits 0 when `gitleaks` is absent** |

⚠ **This row is reconstructed from the fleet's own copies, not from a record.** It is the version spec §7
has carried since P3, and it is the version **38 of 38 wrapper copies were placed at.** Written as a
reconstruction because *a row inferred after the fact is a different kind of claim from one recorded at
the time*, and the difference must survive into the ledger.

---

## ⛔ The gap this ledger opens by recording — the un-cut `2.0.0` interval

**2026-08-19 → 2026-08-24.** The hook was hardened to `2.0.0` (range-scanning, fail-closed — the repair
of F-S158-01) and **no contract bump was cut**, because there was no ledger to cut one in and no clause
obliging anyone to. The contract stayed at `0.1.0` while the artifact it names changed underneath it.

⭐ **Recorded as the gap it was rather than backdated into a tidy `0.2.0`-supersedes-`0.1.5` history.**
Inventing a release row for a release nobody cut would make this ledger's *first act* a false entry —
and the whole reason F-P7b-o exists is that two published counts were produced by instruments nobody
could reproduce.

⛩ **The consequence is the finding.** Because no bump was cut and no signal was sent, **every consumer
that took the hook before 2026-08-19 still holds a fail-open skeleton**, and Hestia's §C retirement
condition — keyed to *"consumers re-install at contract 2.1.0"* — **had no reachable exit**: the file
they would re-install *from* was never 2.1.0. This ledger is the half of that repair which is **ours**.

---

## Fleet state at the `0.2.0` cut

Measured `2026-08-24T19:16Z` — [[secret_gate_census]] §7, instrument `census_wrapper_copy.sh`:

| Class | n | Refresh action |
|---|---|---|
| `V2_1_0` | **1** | none — `Git.aDNA` (the source) |
| `V2_0_0` | **2** | refresh to `0.2.0` — `aDNALabs.aDNA` · `Jupyter.aDNA` |
| `P3_SKELETON_FAIL_OPEN` | **35** | ⛔ refresh to `0.2.0` — **the fail-open population** |
| `COPY_ABSENT` | **23** | ⚠ **a different repair** — place a copy, or declare the wrapper hook-less |

⚠ **The 23 are not folded into the 35** (A1 §C3 / ADR-011 A4 §5): absence is **honest** and already
legible as missing; the skeleton is **deceptive** and reads installed. One number over two defects is
the conflation F-P7b-o was filed for.

⛔ **None of the 60 is repaired by this ledger.** Under Standing Rule 10 the act is each vault's.
What changed is that the act now has a version to refresh *to*, a procedure to follow, and an
instrument to prove it — which is the half that had no owner.

---

## How to cut the next bump

1. Change a **distributed artifact** under `how/federation/git/` (hook · `.gitleaks.toml` · wrapper schema) — A1 §2's trigger.
2. Add a row here: version · `pinned_at_commit` · artifact digests · what changed · refresh-required · breaking.
3. Add the `CHANGELOG.md` line — **that is the signal consumers read** (A1 §2, adopted from `III.aDNA` ADR-002 §3 with credit).
4. Re-run `census_wrapper_copy.sh` and update the fleet-state table so the new row's population is measured, not assumed.

⛔ **Do not** gate a placement verb on the result (A1 §5).
