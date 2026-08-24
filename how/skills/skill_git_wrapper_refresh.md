---
type: skill
skill_type: agent
created: 2026-08-24
updated: 2026-08-24
status: draft
category: maintenance
trigger: "Refresh this vault's git/ wrapper copy to the current Git.aDNA wrapper-contract version"
last_edited_by: agent_stanley
binds_adrs: [adr_004, adr_011, adr_045]   # adr_004 A1 = owner + trigger · adr_011 A4/A5/A6 = the adjudication rules · adr_045 = wrapper placement
upstream_target: ".adna/how/skills/  — via aDNA.aDNA skill_template_release (Standing Order #3). NOT written to .adna/ from here."
tags: [skill, git, wrapper, refresh, distribution, contract_version, adr_004_a1, f_p7b_o, host_neutral, draft]
requirements:
  tools: [git, "gitleaks >= 8.19 (for the post-refresh validation only)"]
  context: [what/inventory/wrapper_contract_releases.md, what/specs/spec_gitops_provider_abstraction.md]
  permissions: ["writes ONLY inside the vault it is run in. No outward action, no network, no forge call."]
---

# Skill: Git Wrapper Refresh

## Overview

Brings **this vault's** `how/federation/git/` wrapper copy up to the current `Git.aDNA` wrapper-contract
version, and **proves it landed**. Run by the consuming vault, in the consuming vault.

⛩ **Why this skill exists.** Spec §7 has carried `federation_ref.version` since P3 and it had never been
bumped, so no consumer had a version to refresh *to* or a procedure to follow. Measured 2026-08-24: **35
of 38 fleet wrapper copies are the fail-open P3 skeleton.** Under Standing Rule 10 the replacing act is
each vault's own — but making it **performable and verifiable** was `Git.aDNA`'s, and that half had no
owner ([[../../what/decisions/adr_004_provider_contract_interface|ADR-004]] **A1 §4**).

## Trigger

`/git-wrapper-refresh [--check-only] [--source <path-to-Git.aDNA>]`

Run it when: the `Git.aDNA` `CHANGELOG.md` records a wrapper-contract bump (**that is the signal** — A1
§2) · your `federation_ref.version` is below
[[../../what/inventory/wrapper_contract_releases|the current release]] · or a census reports this vault
below `V2_1_X`.

## What this skill does NOT do

- ⛔ **No outward act.** No push, no fetch, no forge API call. It copies local files and edits local YAML.
- ⛔ **Never writes into another vault.** Standing Rule 10. If run from `Git.aDNA` against a peer, **stop** —
  that is the peer's act, not ours.
- ⛔ **Never edits `.adna/`** (Standing Rule 1). This skill is authored in `Git.aDNA` and shipped upstream
  by `aDNA.aDNA`'s `skill_template_release`.
- ⛔ **Does not gate anything.** Being out of date is **not** an error state (A1 §3 binds prospectively).

## Preconditions

| # | Check | Why |
|---|---|---|
| 1 | You are in the vault you intend to change (`git rev-parse --show-toplevel`) | the commonest way a Rule-10 violation happens is a wrong `cd` |
| 2 | Working tree clean, or your changes are declared | the refresh replaces tracked files |
| 3 | A `how/federation/git/` dir exists | if absent, this vault has no wrapper — see **Path C** |

## Procedure

### Step 1 — Read the current contract version (never assume it)

```bash
SRC="${SRC:-$HOME/aDNA/Git.aDNA}"                       # --source overrides
grep -m1 '^current_contract_version:' "$SRC/what/inventory/wrapper_contract_releases.md"
```

### Step 2 — Classify what you have BEFORE changing it

```bash
bash "$SRC/how/tests/census_wrapper_copy.sh" --vault "$(git rev-parse --show-toplevel)"
```

⭐ **Read the class, then take the matching path.** They are different repairs and must not be merged
(ADR-011 **A4 §5**):

| Class | What it means | Path |
|---|---|---|
| `V2_1_X` | already current (any 2.1 patch release) | **stop** — bump only the version pin if it lags (Step 4) |
| `V2_0_X` | behaviourally correct; stale **install surface** | **Path A** |
| `P3_SKELETON_FAIL_OPEN` | ⛔ no push-range scan, **exits 0 when `gitleaks` is absent** | **Path A** |
| `COPY_ABSENT` | ⚠ no copy — **honest**, not deceptive | **Path C** |
| `UNCLASSIFIED_*` | unknown | ⛔ **BLOCK** — A4 §2(a): an undeterminable reading is never a silent pass. Ask before writing. |

### Path A — replace the copy

```bash
W="$(git rev-parse --show-toplevel)/how/federation/git"
cp "$SRC/how/federation/git/hooks/pre-push.gitleaks.sh" "$W/hooks/pre-push.gitleaks.sh"
cp "$SRC/how/federation/git/.gitleaks.toml"             "$W/.gitleaks.toml"    # ⚠ see the caveat below
chmod +x "$W/hooks/pre-push.gitleaks.sh"
```

⚠ **The `.gitleaks.toml` caveat — read before overwriting.** If this vault has a **scoped allowlist** of
its own (e.g. `III.aDNA`'s vendored-plugin rules, `Molecules.aDNA`'s verdict-enum false positives),
**merge; do not overwrite.** Blowing away a local allowlist turns a clean scan into a wall of false
positives, and the predictable next act is someone disabling the hook. ⭐ *A refresh that makes the gate
unusable removes the gate as surely as deleting it.*

### Path C — the wrapper carries no hook copy

**A different repair, and possibly not a defect.** Either:
- **place a copy** (Path A's `cp` into a fresh `hooks/` dir), **or**
- **declare the wrapper hook-less** in its `CLAUDE.md`, if this vault's gate is installed from elsewhere
  (e.g. a Network-provided script) — then say so, so the absence is a **recorded decision** rather than a
  gap someone later reads as an oversight.

⛔ Do **not** let the count of `COPY_ABSENT` vaults be reported alongside fail-open ones as one number.

### Step 3 — Install / re-install, deriving both ends

```bash
HOOK="$(git rev-parse --path-format=absolute --git-common-dir)/hooks/pre-push"
ln -sfn "$W/hooks/pre-push.gitleaks.sh" "$HOOK"
"$HOOK" --self-test
```

⛔ **`--git-common-dir`, not the alternatives** (ADR-011 **A5 §3**): `--git-path` **resolves symlinks**
and returns the link's target; `--absolute-git-dir` on a **linked worktree** returns a dir with **no
`hooks/`** at all. `-n` on `ln` matters when the target is an existing symlink-to-directory.

⭐ **`--self-test` must be read, not merely run.** At `2.1.0` it asserts the installed hook **resolves to
an existing executable** — the check that was missing while `2.0.0` printed green on a dangling install.

### Step 4 — Bump the pin (the bookkeeping half)

In `how/federation/git/CLAUDE.md`:

```yaml
federation_ref:
  version: "0.2.0"                                            # <- the release ledger's current version
  pinned_at_commit: "b321223f0ddd47af6bfc82c55c78cae5433ab75c" # <- that row's pinned_at_commit
```

⛔ **The two halves must move together.** A copy refreshed without the pin bumped, or a pin bumped
without the copy refreshed, produces a vault whose **record and object disagree** — and this fleet has
now been bitten in *both* directions. The harness carries a sabotage case for each.

### Step 5 — Validate on BOTH arms, or it is not a validation

ADR-011 **A2 §4 as amended by A5 §1–2**. Neither arm alone is evidence:

- **Induced positive** — plant a **synthetic, non-allowlisted** secret in a **pushed** (not staged)
  commit; it must **BLOCK**. ⛔ Do **not** use a canonical documentation example (the AWS sample is
  **allowlisted** and will sail through — this exact mistake was made by A5's own author inside the drill
  validating A5). ⛔ Do **not** assemble the string at runtime believing that makes it synthetic: that
  protects the *harness source*, not the *plant*.
- **Known-good control** — an ordinary commit must **PASS**. *A gate stuck at BLOCK is as useless as one
  stuck at PASS.*

### Step 6 — Re-classify, and prove the change

```bash
bash "$SRC/how/tests/census_wrapper_copy.sh" --vault "$(git rev-parse --show-toplevel)"   # expect V2_1_X
```

Record in this vault's `STATE.md`: class before → class after · contract version · the induced-positive
date. ⭐ *The before-class is the load-bearing half — "it says `V2_1_X` now" is not a change unless you
know what it said before.*

## Failure modes this skill exists to prevent

| Symptom | Cause | Guard |
|---|---|---|
| hook reads installed, never runs | `ln -sf` onto a missing target; git skips silently | Step 3 + `--self-test` at `2.1.0` |
| self-test green, repo ungated | `2.0.0` self-test probed the engine only | refresh to `2.1.0` |
| refresh reported done, nothing changed | pin bumped, copy not replaced | Step 4 + Step 6 re-classify |
| clean scan becomes a false-positive wall | local allowlist overwritten | Path A caveat |
| "35 vaults ungated" | `COPY_ABSENT` folded into `P3_SKELETON_FAIL_OPEN` | Step 2's per-class paths |
| ⭐ a class read as a verdict | a class **name** is a claim; the 35 **do** scan and **do** block on a finding — what they lack is a push-range scan and a fail-closed path | say what was measured, not what the label suggests |

## Cross-references

- [[../../what/decisions/adr_004_provider_contract_interface|ADR-004 A1]] — owner, bump trigger, and §5's *no blocking gate*
- [[../../what/inventory/wrapper_contract_releases|Release ledger]] — the current version and what changed
- [[../../what/decisions/adr_011_secret_scanning|ADR-011]] **A4 §5** (honest-vs-deceptive) · **A5 §1–3** (validation + `--git-common-dir`) · **A6** (classify by mechanism, never by the defect's name)
- `how/tests/census_wrapper_copy.sh` — the classifier, `--meta` carrying both arms
