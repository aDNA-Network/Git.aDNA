---
type: decision
adr_id: adr_006
title: "ADR-006 — Remote-Naming Convention (cross-provider)"
status: accepted
created: 2026-06-20
updated: 2026-06-20
last_edited_by: agent_stanley
ratifies_at: "authored at genesis P2 (2026-06-20); ratified at the P2-exit gate"
depends_on: [adr_004, adr_005]
tags: [decision, adr, adr_006, git, remotes, migration, shim_registry, binding, accepted]
---

# ADR-006 — Remote-Naming Convention (cross-provider)

**Status**: `accepted` (genesis **P2**, 2026-06-20; ratified at the P2-exit gate). Formalizes the convention sketched in [[adr_004_provider_contract_interface|ADR-004]] D4. Depends on [[adr_004_provider_contract_interface|ADR-004]], [[adr_005_visibility_host_policy|ADR-005]].

## Context
The provider contract ([[adr_004_provider_contract_interface|ADR-004]]) and the migration posture ([[adr_005_visibility_host_policy|ADR-005]] D7) both move repos between hosts and keep mirrors. Without a fixed remote vocabulary, `set-remote`/`configure-mirror` and the rollback path are ambiguous, and the Home.aDNA shim registry (Rule 9) cannot track re-points. The seed migration doctrine used `git remote rename origin → harbor` for rollback; this ADR generalizes that to a **host-neutral** naming convention.

## Decisions

### D1 — Four canonical remote names (binding)
| Remote | Role | Set by | Lifetime |
|---|---|---|---|
| **`origin`** | the graph's **canonical home** (per [[adr_005_visibility_host_policy|ADR-005]] visibility/class) | `set-remote` | permanent |
| **`mirror`** | **outbound** push-mirror target (release/discovery — Class R/P) | `configure-mirror` | permanent while the mirror exists |
| **`upstream`** | an **external** upstream we track but don't own (e.g. `ggml-org/llama.cpp`) | `set-remote` | permanent; never pushed-to |
| **`rollback`** | the **previous `origin`**, retained across a host move for revert | migration skill | **temporary** — removed at window close (D3) |

No other remote names are used in fleet tooling. `rollback` replaces the seed's `harbor` (host-neutral; "harbor" implied a specific provider metaphor).

### D2 — Direction & truth
- `origin` is the single **source of truth**. `mirror` is **write-only outbound** from origin — never pulled from, never a truth source.
- `mirror` direction is always **private/canonical → public face** ([[adr_005_visibility_host_policy|ADR-005]] D3): e.g. Codeberg-FOSS → GitHub-discovery, or (post-P7) self-hosted → GitHub/Codeberg on tags.
- `upstream` is **read-only** to us (fetch/track; contribute via `open-pr`, never `push`).

### D3 — Host-move sequence (binding; rollback-preserving)
A `repo-migrate` (P3 skill) — **gated on the pre-move full-history secret-scan ([[adr_011_secret_scanning|ADR-011]] D4)** — performs, in order:
1. `git remote rename origin rollback` — preserve the old home.
2. `set-remote origin <new-host-url>` — point at the new canonical home.
3. `push origin --all && push origin --tags`; verify (and `git lfs fetch --all` **first** if `lfs: true`).
4. **Register the re-point** in the Home.aDNA shim registry (D4) with class + rollback condition + window.
5. After the rollback window closes (window/condition = [[adr_005_visibility_host_policy|ADR-005]] D7 / doctrine [[adr_009_dev_process_doctrine|ADR-009]]) **and** a verified sweep, `git remote remove rollback`.

Rollback at any point before close = re-point `origin` back to `rollback`'s URL. The window never auto-closes (Rule 9).

### D4 — Shim-registry tie-in (Rule 9; Home.aDNA holds)
Every remote mutation that changes a graph's home — `origin` change, `rollback` add/remove, `mirror` add/remove — is registered in the **Home.aDNA shim ledger** (`disposition_ledger §C`) with **class · window · retire-condition · owner**. Git.aDNA's migration skill **emits** the registry entry; Home.aDNA **holds** it (boundary per Rule 6/9). An unregistered re-point is a defect — it makes a half-migrated fleet invisible. ([[coord_draft_home_credentials_shims|coord memo]].)

### D5 — Nested code-as-WHAT repos
Each nested code tree (`what/<code>/` with its own `.git` — e.g. `latticeprotocol`, `contextscope`, `harness`, `rare-archive`) carries its **own** remote set under this same convention, independent of its parent graph's. The parent's `git/` declaration ([[adr_004_provider_contract_interface|ADR-004]] D4) lists nested-repo remotes; they migrate as their own wave (P6 wave 3). External-canonical nested repos (e.g. `rare-archive`) keep their `origin` external and are **never re-homed** ([[adr_005_visibility_host_policy|ADR-005]] D7).

## Consequences
- `set-remote` / `configure-mirror` / `repo-migrate` skills have an unambiguous target vocabulary (P3).
- The rollback path is uniform and registry-tracked — every host move is reversible within its window.
- Doctrine + STATE/MANIFEST language across the fleet uses these four names only.

## Alternatives considered
- **Keep `harbor`** for the rollback remote — rejected: provider-metaphor-laden; `rollback` says what it is.
- **Conflate `mirror` and `rollback`** (as the ADR-002 sketch loosely did) — rejected: they are opposite-direction, different-lifetime concepts (forward-permanent vs reverse-temporary).
- **No rollback remote** (delete old origin immediately) — rejected: removes the revert path the migration risk register requires.
