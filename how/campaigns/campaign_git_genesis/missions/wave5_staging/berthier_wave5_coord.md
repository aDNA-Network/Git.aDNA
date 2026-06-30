---
type: coordination
coord_id: berthier_wave5_coord
title: "Git.aDNA → Berthier (aDNALabs) + Wilhelm-Foundation-facing personas: Wave-5 client/I-strict boundary + RareArchive partner ack"
created: 2026-06-29
updated: 2026-06-29
status: staged          # STAGED in Git.aDNA (Rule 10) — delivered at the 5d gate / when aDLabs quiet; partner ack required before the RareArchive touch
last_edited_by: agent_stanley
from_persona: hopper      # Git.aDNA
to_persona: berthier      # aDNALabs.aDNA — the GitHub-org migration program (Operation Homecoming / WS-1)
also_for: [mnemosyne, hygieia, hestia]   # RareArchive.aDNA + WilhelmAI.aDNA (Wilhelm-Foundation-facing) + Home.aDNA (origins, Rule 9)
campaign: campaign_git_genesis
phase: P6
wave: 5
tags: [coordination, git, wave5, client, i_strict, partner_org, wilhelm_foundation, ownership_boundary, staged, operation_free_harbor]
---

# Git.aDNA → Berthier (+ Wilhelm-Foundation-facing personas) — Wave-5 client/I-strict boundary

**TL;DR.** Git.aDNA's R2/P6 **Wave 5** is the **client / clinical / vendor-founding** set — **all class I-strict** → **GitHub-private → self-hosted post-P7; NEVER Codeberg** (ADR-013 D2), each gated on a **fresh full-history scan + operator sign-off** (ADR-011 D4). Most of it Git.aDNA fires directly at the gate (greenfield first-remotes + in-place touches on `aDNA-Network`). The **one cross-vault / partner ask** is **5d `RareArchive`** — our vault lives in the **`Wilhelm-Foundation`** partner GitHub org, so the federation touch needs a **partner ack** first (the `WilhelmAI` precedent; ADR-001). This memo records the boundary, asks for that ack, and lists the records for Home (Rule 9).

## Wave-5 set (live ground truth, 2026-06-29) — what Git.aDNA fires vs what needs you
| Graph | Sub | Live host | Git.aDNA action | Needs Berthier / partner? |
|---|---|---|---|---|
| `CakeProtocol` | 5a | local-only | first-remote → `aDNA-Network/CakeProtocol.aDNA` (private) | no (greenfield; record origin) |
| `MagnaPetra` | 5a | local-only | first-remote → `aDNA-Network/MagnaPetra.aDNA` (private) | no (greenfield; record origin) |
| `SuperLeague` | 5b | `aDNA-Network` | in-place touch + push (existing origin) | no |
| `CakeHealth` | 5b | `aDNA-Network` (ssh) | in-place touch + push (existing origin) | no |
| `PercySleep` | 5c | `aDNA-Network` | in-place touch when quiet (HELD: dirty + 2 sessions) | no |
| **`RareArchive`** | **5d** | **`Wilhelm-Foundation/rare-archive-vault`** | **touch-only / keep host + keep name** | **YES — partner ack** |

## Ownership boundary (per Git.aDNA charter: "we supply patterns; you run the org-level program")
- **Git.aDNA / Hopper supplies:** the federation pattern (in-vault `git/` wrapper + `## Git-Ops` + gitleaks hook + CI-parity), the full-history scan gate (I-strict: + operator sign-off), the dispatch lib. 5a/5b/5c are direct fires at the per-graph DP5 gate (no org-program dependency).
- **Berthier / WS-1 (+ the Wilhelm-Foundation-facing personas Mnemosyne/Hygieia) owns:** the **partner-org relationship**. Git.aDNA does **not** touch a `Wilhelm-Foundation`-owned repo without ack — same posture as `WilhelmAI` (Wave 3b, held partner).

## Ask #1 — partner ack for the `RareArchive` touch (5d)
`RareArchive.aDNA` → `github.com/Wilhelm-Foundation/rare-archive-vault` (private, 97c, scan clean). Proposed: a **touch-only** federation pass — **keep host, keep name** (no rename, no transfer, no host move) — `git/` wrapper (`org: Wilhelm-Foundation`) + `## Git-Ops` + gitleaks hook + CI-parity, pushed to the existing partner origin. **No change to partner ownership or visibility.** Requesting the partner ack (via your program / the Wilhelm-Foundation interface) before the touch fires at its gate. The nested external upstream `what/rare-archive` → `Wilhelm-Foundation/rare-archive` (PUBLIC) is **out-of-scope** (ADR-001 / ADR-005 D7 — never re-homed) and stays untouched.

## Ask #2 — record the 5a first-remotes (when they fire)
Two greenfield first-remotes will appear: `aDNA-Network/CakeProtocol.aDNA` + `aDNA-Network/MagnaPetra.aDNA` (both private, class I-strict). Record in the Home origins registry (Rule 9) at fire-time. **No `legacy`/rollback remotes** (greenfield), **no §C shims** (origins unchanged elsewhere).

## §Home (Hestia, Rule 9 — origins, NOT new shims)
- 5a first-remotes (records, when fired): `CakeProtocol.aDNA` + `MagnaPetra.aDNA` → `aDNA-Network` (private).
- External nested repos **never re-homed** (record-only; ADR-005 D7): `percysleep/Percy_Firmware`, `percysleep/percy-adapter` (PercySleep), `Wilhelm-Foundation/rare-archive` (RareArchive). Each a separate `.git` with its own origin — out of campaign scope.
- **No new §C shim** anywhere in Wave 5 (greenfield / origin-unchanged / keep-host-keep-name).

## Status
**STAGED in Git.aDNA** (Rule 10 — not written into aDNALabs / Home / the partner). Deliver into aDNALabs when it is quiet (the Wave-4 cadence); the **`RareArchive` 5d touch does not fire until the Wilhelm-Foundation partner ack is in hand**. 5a/5b/5c fire at their own per-graph DP5 gates with operator scan sign-off (no dependency on this memo). Cross-persona ack at the 5d gate = operator approval + recorded partner ack.
