---
type: inventory
title: "Fleet Secret-Gate Census — every push-capable repo, adjudicated"
created: 2026-08-20
updated: 2026-08-20
status: active
last_edited_by: agent_stanley
measured_at: 2026-08-21T02:26Z
measured_commit: 847bccb          # Git.aDNA HEAD at measurement
measured_by: how/tests/census_secret_gate.sh
supersedes: "disposition_ledger.md §Secret-gate install roster (as a COVERAGE instrument only; that roster remains the per-vault caveat-retirement record)"
implements: adr_011 (A4)
tags: [inventory, census, adr_011, a4, secret_scan, coverage, denominator, f_p7a_e, hooks_path, worktree, instrument]
---

# Fleet Secret-Gate Census

> **Measured, not transcribed.** Every row below was produced by
> [`how/tests/census_secret_gate.sh`](../../how/tests/census_secret_gate.sh) against the live
> workspace at `measured_at`, not copied from a prior table. The script is read-only and re-runnable;
> **re-run it before citing this file.** A measurement recorded without its timestamp is a claim with
> a hidden expiry (F-DECL-03, Pythia) — so the timestamp and the commit are in the frontmatter, and
> this document's shelf life is exactly as long as the fleet holds still.

**Answers [[disposition_ledger|F-P7a-e]]** — *the roster's denominator is the enrollment list, not the
population the gate claims.* It is now measured. The answer is worse than the finding assumed.

---

## §1 — Coverage

**Claimed population** (ADR-011 A4 §1): every push-capable git repo in the workspace, minus the
exemptions enumerated in §4 — **not** the `enrolled_vaults.conf` roster, which is a *scheduling*
artifact and was never a coverage denominator.

| | Count |
|---|---|
| Repos enumerated (root **and** nested, worktrees included) | **124** |
| Exempt, by name in §4 | **7** |
| **Claimed population** | **117** |
| **Gated** — a control git will actually execute | **70** |
| **Ungated** | **47** |

### **Coverage = 70 / 117 (60%).**

The roster reported **8/10 (80%)**. Both numbers are arithmetically correct. They describe different
populations, and only one of them is the population the gate claims to cover.

| Verdict | n | Meaning |
|---|---|---|
| `PASS_EQUIV` | 68 | Venus's script (`f255e2a0…`) — range-scanning + fail-closed |
| `PASS` | 1 | shipped skeleton v2 (`a1288f73…`) |
| `PASS_STRONGER` | 1 | class-L refuse-all (`280056d3…`) — stronger than the gate looks for |
| `FAIL_NOOP` | 14 | the retired v1 no-op (`216aaca2…`) — **appears installed, does not gate** |
| `FAIL_LEGACY_SANITIZE` | 2 | legacy publish-sanitize hook (`3f4bb7f6…`) — a *different* control |
| `FAIL_NONE` | 31 | no hook git will run at all — the worst state |

> **The shipped skeleton v2 has exactly one live installation in the entire fleet: `aDNALabs.aDNA`.**
> Git.aDNA — which authored v2, validated it against an induced positive, and issued the install
> notice — is itself on `f255e2a0…`. That is *behaviourally fine* (A3 §1: v2 is a version bump there,
> not a repair) and it is worth saying out loud, because "we shipped v2" and "v2 is deployed" have
> been used interchangeably and they differ by 116 repos.

---

## §2 — Rows

Full machine-readable output: re-run `bash how/tests/census_secret_gate.sh` (TSV:
`repo · hooks_source · hook_state · digest · verdict · exec · link · remote · exempt`).
The narrative groupings below are what a repairer needs; §3 is the actionable unit.

---

## §3 — The FAIL set, grouped by the file that fixes it

### 3a — `FAIL_NOOP` (14 consumers · **10 wrapper files**) — the repair unit is the wrapper

Every one of these has a **live remote** and pushes ungated today. Thirteen resolve *through* a
wrapper by symlink, so repointing one wrapper file fixes every consumer behind it at once. **One is a
copy** and must be repaired in place.

| Wrapper file to repoint | Consumers | Owner |
|---|---|---|
| `Jupyter.aDNA/what/lab/git/hooks/pre-push.gitleaks.sh` | **5** — `what/lab` + worktrees `adna-lab-h2d-l9`, `latlab-fencing-token`, `latlab-m-l13_5`, `latlab-ws1-ledger` (+ the root `latlab` shim) | Galileo |
| `aDNA.aDNA/how/federation/git/hooks/pre-push.gitleaks.sh` | 1 — the **standard-bearer** | Rosetta |
| `ComfyUI.aDNA/how/federation/git/hooks/pre-push.gitleaks.sh` | 1 — pushes to a **peer node's** bare repo | Vulcan |
| `Context.aDNA/what/contextscope/git/hooks/pre-push.gitleaks.sh` | 1 | Prometheus |
| `Harness.aDNA/what/harness/git/hooks/pre-push.gitleaks.sh` | 1 | Stanley (Harness) |
| `Jupyter.aDNA/what/lab-workspace/git/hooks/pre-push.gitleaks.sh` | 1 | Galileo |
| `LatticeProtocol.aDNA/what/latticeprotocol/git/hooks/pre-push.gitleaks.sh` | 1 | Noether |
| `ScienceStanley.aDNA/how/federation/git/hooks/pre-push.gitleaks.sh` | 1 — reached via **`core.hooksPath`**, see §5 | ScienceStanley |
| `Archive.aDNA/VideosOld.aDNA/how/federation/git/hooks/pre-push.gitleaks.sh` | 1 (+ the `VideoForge.aDNA` / `VideosOld.aDNA` root shims) — **archived vault, live Codeberg origin** | Iris |
| `Operations.aDNA/what/operations-bridge/.git/hooks/pre-push` | 1 — **a copy, not a symlink**; no wrapper to repoint | Berthier / Operations |

### 3b — `FAIL_LEGACY_SANITIZE` (2) — a different control, not a lesser one

| Repo | Note |
|---|---|
| **`PercySleep.aDNA`** | **Client vault, class I-strict.** Runs the legacy publish-sanitize hook (`LAYER_CONTRACT_VERSION=4.0.1`), which *does* read the outgoing ref list from stdin — it is a real control with a real guarantee. It is **not** the ADR-011 gitleaks gate, and it has never been credited or debited as one. Highest-exposure row in this census. |
| `Archive.aDNA/LiteratureForge.aDNA` | Wound-down vault, live GitHub origin. Same hook. |

### 3c — `FAIL_NONE` (31) — no hook git will run

| Class | n | Rows |
|---|---|---|
| **Active, live remote** | 8 | `WGS.aDNA` (rd-forge) · `WilhelmAI.aDNA` (mesh push into another operator's home dir, **nightly**) · `Molecules.aDNA/what/moleculeforge` · `Operations.aDNA/what/operations-web` · `Operations.aDNA/what/c08-liaison-package` · `Spacemacs.aDNA/.publish-clone` · `Dashboards.aDNA/what/intake/athena/repo` (third-party intake) · **`.adna`** |
| Archived, live remote | 10 | `Archive.aDNA/{CanvasForge,ComfyForge,ContextCompass,LatticeLabs,LPWhitepaper,lattice-labs}` + 4 under `_archive/` |
| No remote (a first push would be ungated) | 13 | incl. `Home.aDNA`, `Bitwarden.aDNA`, `GOTFN.aDNA`, `RareAnthropic.aDNA` |

> **`.adna` is a special case and must not be "fixed" here.** Standing Rule 1: never modify `.adna/`.
> Its gate is a **standard-side** question for Rosetta — it belongs in the template, shipped via
> `skill_template_release`, never patched locally.

> **`WGS.aDNA` + `WilhelmAI.aDNA` were already known** (A3 §4, 08-19). This census does not re-open
> them; it confirms them and places them in a population where they are 2 of 31, not 2 of 10.

---

## §4 — Exemptions (dated, enumerated, printed **with** the coverage number)

An exempt repo is still measured and still emitted by the instrument. It is subtracted **by name**,
never silently dropped — a repo that vanishes from a denominator is indistinguishable from a repo that
passed.

| Repo | Class | Authority |
|---|---|---|
| `llama.cpp` | `upstream_external` | External upstream (`ggml-org`); never our push |
| `PercySleep.aDNA/what/percysleep_code/percy-adapter` (+ `-2549379`, `-hypnos-fork`) | `third_party_client` | ADR-005 D7 / ADR-001 — client's own repos, declared out-of-scope at Wave 5 |
| `PercySleep.aDNA/what/percysleep_code/Percy_Firmware` | `third_party_client` | as above |
| `RareArchive.aDNA/what/rare-archive` | `third_party_partner` | Wilhelm-Foundation upstream; canonical + ownership external |
| `Archive.aDNA/_archive/wilhelm-foundation/rare-archive` | `third_party_partner` | as above |

**Exempt ≠ safe.** All 7 are `FAIL_NONE`. They are outside *our* gate's authority, not outside risk.
The vault-level `PercySleep.aDNA` row is **not** exempt (§3b).

---

## §5 — Instrument blind spots this census corrected

Recorded as **negative knowledge**, deliberately: each of these is a check that *looks* right and
silently cannot fail. Anyone re-deriving a census from scratch will re-derive the naive version unless
these are written down. (The boxed-note discipline from the flip runbook §2 — the clean table is not
worth the lost finding.)

**⛔ 1. `core.hooksPath` wins. Reading `.git/hooks/pre-push` when it is set measures a file git never
executes.** Two live instances, both of which the naive read got backwards:

- **`ScienceStanley.aDNA`** — `.git/hooks/pre-push` resolves to `f255e2a0…` and adjudicates **PASS**.
  But `core.hooksPath=how/governance/hooks`, and *that* `pre-push` resolves to **`216aaca2…`, the
  retired no-op**. The naive column reported health from a file nothing runs.
- **`Archive.aDNA/lattice-labs`** — `core.hooksPath=/Users/stanley/Projects/lattice-labs/.git/hooks`,
  **an absolute path outside the workspace that does not exist**. git therefore runs *no* pre-push
  hook. The `a9399d70…` git-lfs hook sitting in its `.git/hooks/` is **dead** — and an earlier pass
  of this very session characterised it as "git-lfs occupying the slot," which was a reading taken
  from a path git does not consult. Corrected here.

  ⚠ **This is F-Astro's exact mechanism** (2026-06-22: a stale `core.hooksPath` at a defunct
  pre-Homecoming path bypassed the pre-push hook on Astro's first push). It was fixed **in the vault
  where it was found and never swept for.** Two months later the second instance was still live.
  *A finding closed at its instance is not a finding closed.*

**⛔ 2. The enumeration predicate is part of the instrument.** `[ -d .git ]` is false for a linked
worktree or submodule, whose `.git` is a **file**. Four `latlab` worktrees were excluded outright by
the first pass — reported as *absent from the fleet*, which reads as nothing-to-see rather than
**unmeasured**. Ask git for the path (`rev-parse --git-path`); never hand-build `$repo/.git/hooks/…`.

**⛔ 3. A closed digest table mis-reads a control that is *stronger* than the one it looks for.**
`Archive.aDNA/DataRoom.aDNA/what/dataroom` runs the class-L **refuse-all** hook (`280056d3…`), which
blocks *every* push unconditionally — strictly stronger than a gitleaks scan. Adjudicated against
A3 §1's four-row table it is not-a-pass. **This is A3 §3 inverted**: an instrument that cannot
represent a state *better* than the one it expects will report that state as a defect, and defects
that are known-false stop being read.

**⛔ 4. Content is not execution.** A hook with byte-perfect v2 content and no `+x` bit is not run by
git. A digest-only column reports it **PASS**. (No live instance found; caught by fixture D — which
is the point of having fixtures.)

**⛔ 5. A shim and its target are one repo, not two.** Root-level shims (`latlab`,
`lattice-protocol`, `contextscope`, `VideoForge.aDNA`, …) are symlinks; `find` does not descend them,
so each underlying repo is counted **once**, at its real path. Adjudicating both the shim and the
target double-counts a single control — inflating both the numerator and the denominator, which
flatters coverage whenever the shared gate passes.

### The meta-control

Per ADR-015 §D1.5b — *a guard that has only ever passed is untested* — the census was run against six
deliberately-sabotaged fixtures and required to **fail** on each before any fleet reading was trusted:
`core.hooksPath` shadowing a good hook → `FAIL_NONE` ✓ · `.git`-as-file worktree → enumerated, no-op
detected ✓ · unknown digest → `UNCLASSIFIED` ✓ · correct content, no `+x` → `FAIL_NOT_EXECUTABLE` ✓ ·
dangling symlink → `FAIL_DANGLING_SYMLINK` ✓ · known-good control → still `PASS` ✓ (an instrument
stuck at FAIL is as useless as one stuck at PASS).

**The meta-control found a real defect in the instrument.** Fixture E first reported `FAIL_NONE`: the
`FAIL_DANGLING_SYMLINK` branch was **unreachable**, because `[ -e ]` is false for a broken symlink so
the row fell into the `absent` arm. The verdict was still a failure — no false health — but the
*diagnosis* was wrong, and it would have sent a repairer to install a missing hook rather than fix a
broken link. **An unreachable branch in a checker is the same class as a column that cannot fail**
(F-P7a-f), found here only because the fixture existed. Fixed; re-run confirms all six.

---

## §6 — Archived-vault disposition (**proposed, not applied**)

Ten archived repos hold live remotes and no gate. Archive-never-delete (SO-6) means they persist
indefinitely, and a repo nobody watches is precisely where an ungated push is least likely to be
noticed. Three lawful dispositions, costed — **owner's call, not ours**:

1. **Install the gate** — uniform, but pays install + induced-positive cost on repos that should
   never receive another commit.
2. **Install the class-L refuse-all hook** (`280056d3…`) — *stronger*, cheaper, and semantically
   right: an archived vault SHOULD refuse pushes. Reuses a hook already written and in service.
3. **Remove the remote** — strongest, and irreversible-ish; forecloses a legitimate future restore.

**Hopper's recommendation: (2)** for archived vaults with live remotes. It converts 10 `FAIL_NONE`
rows into `PASS_STRONGER` with one already-proven artifact, and it states the vault's actual intent
in a mechanism rather than a banner. Requires the archive owner's concurrence; **not staged in the
repoint runbook**, which is scoped to the no-op set.

---

## Cross-references

- [[../decisions/adr_011_secret_scanning|ADR-011]] **A4** — the instrument corrections this census
  both applied and motivated (`proposed`; awaits operator §7.7).
- [[disposition_ledger]] §Secret-gate install roster — the per-vault **caveat-retirement** record
  (induced-positive dates). Still authoritative for *that*; superseded as a **coverage** number.
- `how/campaigns/campaign_git_genesis/missions/p7a_flip_staging/gate_repoint_runbook.md` — the staged
  repair for §3a. **Fires nothing.**
