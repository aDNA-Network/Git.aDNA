---
type: coordination
coord_id: coord_2026_06_24_git_wave3b_hestia_redirect_shims
title: "Hopper → Hestia: register §C native-rename/transfer redirect notes for 7 Wave-3b graphs (5 in-org renames + 2 cross-org transfers)"
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
| `Lab.aDNA` | `aDNA-Network/lab-adna` | `aDNA-Network/Lab.aDNA` | `main` | `1928fd1` | I (private) |
| `ContextCommons.aDNA` *(cross-org transfer)* | `LatticeProtocol/ContextCommons.aDNA` | `aDNA-Network/ContextCommons.aDNA` | `main` | `568b94d` | I (private) |
| `TappProtocol.aDNA` | `aDNA-Network/TappInterface.aDNA` | `aDNA-Network/TappProtocol.aDNA` | `master` | `8ab5e7c` | I (private) |
| `LAVentureGraph.aDNA` *(cross-org transfer, personal→org)* | `ScienceStanley/LAStartupLattice` | `aDNA-Network/LAVentureGraph.aDNA` | `main` | `eaa61f0` | I (private) |

> **Added 2026-06-24 by `session_stanley_20260624_git_p6_wave3b_tapp_lavg`** (DP5 gate, scope = TappProtocol + LAVentureGraph). `TappProtocol` = in-org drift rename `TappInterface.aDNA`→`TappProtocol.aDNA` (same sub-class as the first 4); cleared the prior live-Mentor hold. `LAVentureGraph` = the campaign's **first transfer from a personal account** (`ScienceStanley/LAStartupLattice` → org, + rename) — same redirect sub-class as ContextCommons/Astro; **rollback = re-transfer** (`gh api -X POST repos/aDNA-Network/LAVentureGraph.aDNA/transfer -f new_owner=ScienceStanley` then re-rename). Both **class I (stay private)**. **→ Wave 3b: drift 5/5 · cross-org 2/2 complete; only partner `WilhelmAI` remains.**

> **Added 2026-06-24 by `session_stanley_20260624_git_p6_wave3b_continue`** (DP5 gate, scope = Lab + ContextCommons). `Lab` = in-org drift rename (same sub-class as the 3 above). `ContextCommons` = the campaign's **first non-Astro cross-org transfer** (`LatticeProtocol`→`aDNA-Network`, name unchanged) — same redirect sub-class as Astro; **rollback = re-transfer** (`gh api -X POST repos/aDNA-Network/ContextCommons.aDNA/transfer -f new_owner=LatticeProtocol`), not re-rename. Classified **I at the gate** — stays private though the deployed site `contextcommons.vercel.app` is public. Nested `Lab/what/lab`+`lab-workspace` = Wave 4, untouched.

- **Retire condition:** none (redirect is permanent on GitHub; no `rollback` remote to retire). Register for audit, not for a window-close action.
- **Rollback:** `gh repo rename <Old> --repo aDNA-Network/<New>.aDNA` (re-rename); local `git remote set-url origin …` back.
- **Note:** `LatticeProtocol.aDNA` entry is the **vault** repo only. The nested code repo `aDNA-Network/lattice-protocol` (`what/latticeprotocol/`) is **Wave 4**, untouched.

## Not in this batch (held)

- `WilhelmAI.aDNA` — partner-org (`Wilhelm-Foundation`), **stays**; touch-only, partner coord before any rename. Separate later 3b step (held-live 2026-06-24: 11 active Lighthouse sessions). **No redirect entry** — touch-only, no host move.

*(`TappProtocol` + `LAVentureGraph` cleared 2026-06-24 — now registered above.)*
