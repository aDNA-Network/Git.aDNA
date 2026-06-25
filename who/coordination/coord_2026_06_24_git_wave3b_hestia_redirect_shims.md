---
type: coordination
coord_id: coord_2026_06_24_git_wave3b_hestia_redirect_shims
title: "Hopper → Hestia: register §C native-rename/redirect notes for 3 Wave-3b drift renames"
from: Git.aDNA (Grace Hopper)
to: Home.aDNA (Hestia)
created: 2026-06-24
updated: 2026-06-24
status: staged
last_edited_by: agent_stanley
tags: [coordination, p6, wave_3b, shim_registry, redirect, drift_rename, operation_free_harbor, needs_human]
---

# Wave 3b — §C shim-registry entries for 3 GitHub-native drift renames

> **Staged per Standing Rule 10 + Rule 9** (Git.aDNA does not write into Home). Deliver/accept from a Home session. These are **native-rename/redirect** entries (the Astro sub-class) — **no `rollback` remote, no window**; the redirect *is* the safety net (rollback = re-rename). Register them in the standing shim ledger (`Home.aDNA/.../disposition_ledger_v2.md` §C / WI-11) for audit completeness.

## Context

Git.aDNA **R2/P6 Wave 3b** (2026-06-24, DP5-gated; operator approval = Berthier cross-persona ack) reconciled 3 of the 5 in-org name-drift graphs: each was touched (git/ wrapper + `## Git-Ops` doctrine + gitleaks hook + host-fact), dogfood-pushed to its current origin, then **GitHub-native `gh repo rename`** to its canonical `<Vault>.aDNA` name. All stayed **GitHub-private** throughout; GitHub installs an automatic redirect from the old path. Mirrors the Wave-1b `Molecules`/`Oration` drift renames and the Astro native-transfer sub-class.

## §C entries to register (native-rename/redirect; no rollback remote; no window)

| Vault | Old repo (redirects) | New canonical repo | Branch | New HEAD | Class |
|---|---|---|---|---|---|
| `Operations.aDNA` | `aDNA-Network/TaskForge.aDNA` | `aDNA-Network/Operations.aDNA` | `master` | `99f2750` | I (private) |
| `VAAS.aDNA` | `aDNA-Network/VAASLattice.aDNA` | `aDNA-Network/VAAS.aDNA` | `main` | `b9593c0` | I (private) |
| `LatticeProtocol.aDNA` (vault) | `aDNA-Network/latticeprotocol-adna` | `aDNA-Network/LatticeProtocol.aDNA` | `main` | `adf62cb` | I (private) |

- **Retire condition:** none (redirect is permanent on GitHub; no `rollback` remote to retire). Register for audit, not for a window-close action.
- **Rollback:** `gh repo rename <Old> --repo aDNA-Network/<New>.aDNA` (re-rename); local `git remote set-url origin …` back.
- **Note:** `LatticeProtocol.aDNA` entry is the **vault** repo only. The nested code repo `aDNA-Network/lattice-protocol` (`what/latticeprotocol/`) is **Wave 4**, untouched.

## Not in this batch (held)

- `TappProtocol.aDNA` (`TappInterface.aDNA`→) — **held** (live concurrent Mentor P9/i3 session at fire time; backed out cleanly). Refire when quiet → adds a 4th §C redirect entry.
- `Lab.aDNA` (`lab-adna`→) — held (dirty notebook WIP).
- Cross-org transfers (`ContextCommons`, `LAVentureGraph`) + partner `WilhelmAI` — separate later 3b steps.
