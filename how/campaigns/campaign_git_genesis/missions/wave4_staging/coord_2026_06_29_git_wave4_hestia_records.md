---
type: coordination
coord_id: coord_2026_06_29_git_wave4_hestia_records
title: "Git.aDNA → Hestia (Home.aDNA): Wave-4 nested-repo origin/legacy/ssh records (Rule 9)"
created: 2026-06-29
updated: 2026-06-29
status: staged           # STAGED in Git.aDNA — deliver to Home/who/coordination when Home is quiet (Hestia registers at her cadence)
last_edited_by: agent_stanley
from_persona: hopper      # Git.aDNA
to_persona: hestia        # Home.aDNA — shim/origins registry (Standing Rule 9)
campaign: campaign_git_genesis
phase: P6
wave: 4
ack_required: false
tags: [coordination, git, wave4, hestia, origins_record, rule9, no_new_shim, operation_free_harbor]
---

# Git.aDNA → Hestia — Wave-4 nested-repo records (Rule 9; records, NOT new shims)

**Context.** R2/P6 Wave-4 federation-touched 3 nested code-as-WHAT repos + declared 1 class-L (2026-06-29, `session_stanley_20260629_git_p6_wave4_fire_full`). **No host moves, no new remotes, no visibility flips ⇒ NO new §C shim.** This memo records origin/transport facts for the shim/origins registry only.

## Records to register (Rule 9)
| Repo | Origin (unchanged) | `legacy` remote | Transport | Note |
|---|---|---|---|---|
| `Context.aDNA/what/contextscope` | `aDNA-Network/contextscope` | — (none) | https | federation-touched `3b34c92`; placed directly on aDNA-Network (no LatticeProtocol rollback) |
| `Lab.aDNA/what/lab-workspace` (`latlab-lab`) | `aDNA-Network/latlab-lab` | — (none) | **ssh** (`git@github.com:aDNA-Network/latlab-lab.git`) | federation-touched `cb0896a`; **F-W4-d** — push used a transient `ghhttps` https remote (token auth), origin-ssh untouched. Record the ssh transport. |
| `DataRoom.aDNA/what/dataroom` | **NONE (class L)** | — | n/a | class-L declaration `9ae18b7`; **never-push** legal/privileged IP; refuse-all pre-push hook; a remote is **counsel-gated**, not operator-only. Record as never-push. |

## Already on the registry (Wave-4 context — no action, just confirm)
- `legacy` remotes from Berthier's WS-1 pilot (rollback convention; WS-1 owns retirement): `lattice-protocol` · `latlab` · `moleculeforge` each carry `legacy → github.com/LatticeProtocol/<repo>`. (`latlab` + `moleculeforge` are HELD this session — `latlab` 5-dirty, `moleculeforge` live collision F-W4-g.)

## Ask
Register the three records above (origins/transport/never-push). **No retire-conditions to set** (no new shims). `ack_required: false`.
