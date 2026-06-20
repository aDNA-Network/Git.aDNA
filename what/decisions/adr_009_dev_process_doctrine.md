---
type: decision
adr_id: adr_009
title: "ADR-009 — Dev-Process Git Doctrine (branch · commit · sign · PR · multi-graph coordination)"
status: accepted
created: 2026-06-20
updated: 2026-06-20
last_edited_by: agent_stanley
ratifies_at: "authored at genesis P2 (2026-06-20); ratified at the P2-exit gate; doctrine block ships P3; signing enforced P5+"
depends_on: [adr_004, adr_005, adr_006]
tags: [decision, adr, adr_009, git, dev_process, doctrine, signing, pull_request, coordination, binding, accepted]
---

# ADR-009 — Dev-Process Git Doctrine

> **Disambiguation:** this is **Git.aDNA's local ADR-009**, about the *development process*. It is **not** the **aDNA-standard ADR-009 §4** (the PascalCase workspace-naming rule that authorizes the `Git.aDNA` name itself — see `who/coordination/coord_2026_06_19_fork_provenance.md`). Local per-vault ADR namespaces are independent; the number collision is nominal.

**Status**: `accepted` (genesis **P2**, 2026-06-20; ratified at the P2-exit gate). Binds the "tracking/operations/process for development" mandate (ADR-000 D4). Depends on [[adr_004_provider_contract_interface|ADR-004]], [[adr_005_visibility_host_policy|ADR-005]], [[adr_006_remote_naming|ADR-006]].

## Context
ADR-000 D4 scoped Git.aDNA to own the **dev-process git doctrine** — branch/commit/sign/PR conventions + multi-graph change coordination — generalizing the seed's agent-identity (§5) and doctrine-block (§7) material to be provider-neutral. This ADR binds it; P3 ships the propagatable doctrine block + the skills that enforce it.

## Decisions

### D1 — Branch model (lightweight, host-neutral)
- Each graph has one **integration branch**: `main` canonical for new graphs; existing `master` tolerated until a graph opts to rename (fleet-wide rename is out of scope here). The `git/` declaration may record the name.
- **Non-trivial / shared** work uses short-lived **topic branches** → merged via `open-pr` ([[adr_004_provider_contract_interface|ADR-004]]).
- **Solo / local genesis** work may commit directly to the integration branch (current practice) — *until a graph has a remote with collaborators*, after which PRs are required (D4).
- No GitFlow; no long-lived release branches (releases are tags + mirror, [[adr_005_visibility_host_policy|ADR-005]] D3).

### D2 — Commit conventions
- **Commit after significant edits** (vault SO#9); never batch a phase into one mega-commit.
- Messages are **descriptive + status-first** (Hopper register): a one-line outcome + scope, e.g. `P2 ADRs 004–010 authored (proposed) — Operation Free Harbor`. Conventional-Commits is **not** mandated (the fleet's history is freeform-descriptive).
- **Git HEAD > cached read > memory > assumption** (SO#9). Read before write; set `updated` + `last_edited_by` on every node.

### D3 — Signing & agent attribution
- **SSH-signed commits** (seed §5) — signing key brokered via Home.aDNA. **Adopt now; enforce once remotes exist (P5+)** (local-only genesis commits are unsigned-tolerated).
- Agent-authored commits carry an **`Agent: <account>` trailer** for provenance. The machine-account *model* (one shared key vs per-agent `agent-*` accounts) is Home.aDNA's call ([[adr_007_credential_model|ADR-007]] open question); the *trailer + signing* are dev-process and binding here.
- **Server-side enforcement (P5+, FRG-006):** once a graph has a remote, its integration branch is **protected to reject unsigned pushes** — the forge-side complement to client signing (GitHub branch-protection / Forgejo branch rules).
- **Pre-push secret-scan:** every code-home runs the [[adr_011_secret_scanning|ADR-011]] `gitleaks` pre-push hook (carried by the D6 doctrine block).

### D4 — PR / review model (provider-neutral)
- A change to a graph **with a remote** is proposed via the **`open-pr`** verb — identical whether the backend is GitHub PRs or Forgejo PRs ([[adr_004_provider_contract_interface|ADR-004]]).
- **Self-review** is acceptable for solo work; the verb makes the *process* uniform so multi-author graphs scale without a tooling change.
- **Outward/irreversible git actions** (create-remote · push · cut-release · configure-mirror · repo-migrate) are **operator-gated** (Standing Order #2) — doctrine, not improvisation.

### D5 — Multi-graph change coordination (the fleet "process")
When a change spans graphs — e.g. a skill **authored here**, **shipped to `.adna/` via `aDNA.aDNA`**, and **consumed via `git/` wrappers** elsewhere — it is coordinated as a **staged coord memo** in the originating vault and delivered only when the target vault is touched or by the operator (**Standing Rule 10** — never a silent cross-vault write). Standing cross-graph tasks (mirror-health, drift, rename reconciliation) are handed to **Operations.aDNA** (claim-lease) at P8. This is the binding "tracking/operations/process for development" across the fleet.

### D6 — The provider-neutral git-ops doctrine block (contents; P3 ships text)
Every code-home's CLAUDE.md carries a short, **host-neutral** doctrine block. Its **required contents** (final wording + propagation = P3):
1. Remotes follow [[adr_006_remote_naming|ADR-006]] (`origin`/`mirror`/`upstream`/`rollback`); host/visibility per [[adr_005_visibility_host_policy|ADR-005]].
2. **Local-first; HEAD is truth; commit after significant edits.**
3. **Outward actions are gated** (remotes/push/release/migrate).
4. **Credentials via the Home.aDNA broker; never inlined** ([[adr_007_credential_model|ADR-007]]).
5. **CI portable-first**, both backends ([[adr_008_ci_cd_parity|ADR-008]]).
6. **Cross-graph writes are staged as coord memos** (Rule 10).
7. **Secret hygiene** — `gitleaks` pre-push; full-history scan before any host move ([[adr_011_secret_scanning|ADR-011]]).

This replaces the seed §7 block (which baked in `harbor`/GitHub specifics + self-hosted-canonical assumptions) with a generalized one.

## Consequences
- The fleet gets one development vocabulary regardless of host; the doctrine block is the consumer-facing summary of ADRs 004–008.
- Signing + the `Agent:` trailer give auditable provenance once remotes exist.
- P3's skills (`open-pr`, `repo-migrate`, etc.) implement these conventions; the doctrine block propagates via the `git/` wrapper (the III `iii/` pattern).

## Open questions carried forward
- Per-agent machine accounts vs one shared signing identity → Home.aDNA ([[adr_007_credential_model|ADR-007]]).
- Fleet-wide `master → main` rename — a separate, gated housekeeping decision (not blocking).

## Alternatives considered
- **Mandate Conventional Commits** — deferred: high churn for the existing freeform history; revisit if changelog automation is wanted.
- **GitFlow / long-lived release branches** — rejected: releases are tags + mirror, not branches.
- **No signing** — rejected: provenance is sacred in a git-ops standard (Hopper register).
