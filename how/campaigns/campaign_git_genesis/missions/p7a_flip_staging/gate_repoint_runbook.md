---
type: runbook
title: "Secret-Gate Repoint Runbook — the 10 wrapper files behind 14 ungated repos"
created: 2026-08-20
updated: 2026-08-20
status: staged            # ⛔ FIRES NOTHING. Each section needs its own operator gate (Rule 10).
last_edited_by: agent_stanley
campaign_id: campaign_git_genesis
campaign_phase: 7a
executor_tier: sonnet     # mechanical per-row; the adjudication was opus and is already done
implements: adr_011 (A2 §4, A3 §1–§2, A4 §3–§5)
source_measurement: what/inventory/secret_gate_census.md @ 2026-08-21T02:26Z
tags: [runbook, staged, adr_011, secret_gate, repoint, cross_vault, rule_10, p7a]
---

# Secret-Gate Repoint Runbook

> **⛔ THIS RUNBOOK FIRES NOTHING.** It is staged against a `proposed` amendment **by design** — the
> same discipline as the flip runbook: ratification should know what A4 costs to execute. Every
> section is a **cross-vault write** and takes its own operator gate (Rule 10). Nothing here is
> pre-authorized by the census having been approved.

**Source of truth**: [[../../../../what/inventory/secret_gate_census|the census]] §3a. **Re-run
`how/tests/census_secret_gate.sh` before firing any row** — the census is a timestamped measurement,
not a standing fact, and rows 1–10 below may have changed under it (F-W3-e: verify at use).

---

## §0 — The repair, stated once

Each target is a wrapper file whose content is the **retired v1 no-op** `216aaca2…` — it scans the
*staged* diff (empty at push time) and exits clean having examined nothing. Thirteen of the fourteen
ungated repos reach it **by symlink**, so repointing the wrapper repairs every consumer behind it at
once.

**Replacement**: `Git.aDNA/how/federation/git/hooks/pre-push.gitleaks.sh` (skeleton v2,
`a1288f7371afa187cb1cfd8b9810a669`, 138 lines) — range-scanning, fail-closed, config search order
preserved (`$GITLEAKS_CONFIG` → `git/.gitleaks.toml` → root), per ADR-011 A2 §1–§3.

## §0a — Per-row procedure (identical for every section)

1. **Collision check #1** — target vault tree clean **and** `how/sessions/active/` empty. A non-empty
   peer session means *do not co-write its files* (single-writer lease).
2. **Read the current wrapper** and confirm it is still `216aaca2…`. If the digest has moved, **stop**
   and re-adjudicate — do not repoint a file whose content you have not just read.
3. **Copy v2 over the wrapper.** Do not touch the consumer's `.git/hooks/pre-push` symlink; the whole
   point is that the symlink already resolves correctly.
4. **Verify the resolution** — `census_secret_gate.sh --root <workspace>` and confirm every consumer
   behind this wrapper flipped `FAIL_NOOP` → `PASS`. Confirm the `+x` bit survived the copy (A4 §5).
5. ⛔ **Induced positive (A2 §4 — the gate that actually retires the caveat).** Plant a fake secret in
   a **pushed-range commit** on a scratch branch and confirm the hook **blocks** (exit 1). Delete the
   scratch branch. **No row is recorded done on an md5** — md5 is evidence of a file, not of a control.
   A gate that has never been shown to fail is a monitor that has never fired.
6. **Collision check #2** — re-check clean + sessionless **before committing** (F-W3-d: the tree that
   was clean at apply has twice gone dirty by commit time in this campaign).
7. **Commit stage-only-mine** — explicit paths, never `git add -A`.
8. **Record** the induced-positive date in [[../../../../what/inventory/disposition_ledger|ledger]]
   §Secret-gate install roster, and re-run the census to update coverage.

**Rollback (every row)**: restore the prior wrapper content from git. The consumer symlink is never
touched, so rollback is a single-file revert with no remote or config side effects.

---

## §1 — Rows, ordered lowest-exposure first

Ordering is deliberate: the first rows are ours or quiet, so the procedure is proven on cheap targets
before it reaches a partner-adjacent or multi-consumer one.

| # | Wrapper file | Consumers | Owner | Exposure | Notes |
|---|---|---|---|---|---|
| 1 | `Archive.aDNA/VideosOld.aDNA/how/federation/git/hooks/pre-push.gitleaks.sh` | 1 (+2 root shims) | Iris | **low** — archived vault | **Canary.** Archived + quiet. ⚠ Its origin is the *successor's* live Codeberg repo (`Videos.aDNA`) — flag to Iris; an archived predecessor holding a live push path to its successor is its own question. |
| 2 | `Context.aDNA/what/contextscope/git/hooks/pre-push.gitleaks.sh` | 1 | Prometheus | low | Code-as-WHAT; standard shape. |
| 3 | `LatticeProtocol.aDNA/what/latticeprotocol/git/hooks/pre-push.gitleaks.sh` | 1 | Noether | low | Code-as-WHAT; root `lattice-protocol` shim resolves here. |
| 4 | `Harness.aDNA/what/harness/git/hooks/pre-push.gitleaks.sh` | 1 | Stanley (Harness) | low-med | Live GitHub origin `aDNA-Network/adna-harness`. |
| 5 | `aDNA.aDNA/how/federation/git/hooks/pre-push.gitleaks.sh` | 1 | Rosetta | **med** | **The standard-bearer.** Pairs with the `.adna/` template question (§2) — the local fix does not fix the template. |
| 6 | `ScienceStanley.aDNA/how/federation/git/hooks/pre-push.gitleaks.sh` | 1 | ScienceStanley | **med** | ⛔ **Reached via `core.hooksPath=how/governance/hooks`**, whose `pre-push` symlinks to this file. **Verify by executing a push in a scratch clone, not by reading `.git/hooks/`** — this vault is the reason A4 §3 exists. Historically collision-prone (live site-dev sessions); needs a genuinely quiet window. |
| 7 | `ComfyUI.aDNA/how/federation/git/hooks/pre-push.gitleaks.sh` | 1 | Vulcan | **med-high** | Pushes to **a peer node's** bare repo (`luke-l1-sovereign:.mesh-git/`). An ungated push here lands on someone else's machine. |
| 8 | `Jupyter.aDNA/what/lab-workspace/git/hooks/pre-push.gitleaks.sh` | 1 | Galileo | med | ssh origin — the F-W4-d ssh-remote handling applies. |
| 9 | `Jupyter.aDNA/what/lab/git/hooks/pre-push.gitleaks.sh` | **5** | Galileo | **high** | ⛔ **One wrapper, five consumers**: `what/lab` + worktrees `adna-lab-h2d-l9` · `latlab-fencing-token` · `latlab-m-l13_5` · `latlab-ws1-ledger` (+ the root `latlab` shim). **Verify all five**, not the one you edited. Largest single win in the runbook. |
| 10 | `Operations.aDNA/what/operations-bridge/.git/hooks/pre-push` | 1 | Berthier / Operations | med | ⛔ **A copy, not a symlink — there is no wrapper to repoint.** Repair in place at the realpath, and consider installing a wrapper so the next repair is one file. Berthier's lane; coordinate, do not unilaterally restructure. |

---

## §2 — Explicit non-goals (things this runbook must NOT do)

- ⛔ **`.adna/` is not touched.** Standing Rule 1. Its `FAIL_NONE` is a **standard-side** question for
  Rosetta, fixed in the template and shipped via `skill_template_release` — patching it locally would
  put the workspace out of sync with the standard and violate the rule in the same stroke.
- ⛔ **git-lfs slots are composed, never overwritten.** Where a foreign hook occupies `pre-push`
  (A4 §2), installing over it silently breaks LFS. No such live row exists today —
  `Archive.aDNA/lattice-labs`'s lfs hook is dead behind a defunct `core.hooksPath` — but the rule
  binds if one appears.
- ⛔ **`dataroom` is not touched.** Its refuse-all hook is `PASS_STRONGER`; "upgrading" it to a
  gitleaks gate would *weaken* a never-push repo from refusing everything to permitting clean pushes.
- ⛔ **Exempt repos are not touched** (census §4) — third-party and upstream, not our authority.
- ⛔ **`WGS.aDNA` / `WilhelmAI.aDNA` are out of scope here.** They are `FAIL_NONE`, not `FAIL_NOOP` —
  a fresh install, not a repoint, with asymmetric exposure (WilhelmAI: partner org, push into another
  operator's home dir, nightly replication). Separate gated act, per the 08-19 liveness table.
- ⛔ **The archived-vault set is out of scope** — census §6 proposes the refuse-all disposition and it
  needs the archive owner's concurrence first.

## §3 — Exit condition

All 10 rows fired, each with a **dated induced positive** in the ledger roster, and a re-run census
showing `FAIL_NOOP = 0`. Coverage rises 70/117 → 84/117 (**72%**). The remaining gap is the
`FAIL_NONE` set (§3c of the census), which is a different campaign with different owners — **naming
that here so the coverage number is never read as "done" when the no-op class closes.**
