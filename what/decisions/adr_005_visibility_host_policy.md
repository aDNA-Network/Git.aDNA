---
type: decision
adr_id: adr_005
title: "ADR-005 — Visibility-Driven Host Policy (binding; Codeberg-ToS amended; Path B)"
status: accepted
created: 2026-06-20
updated: 2026-06-20
last_edited_by: agent_stanley
ratifies_at: "authored at genesis P2 (2026-06-20); ratified at the P2-exit gate; per-graph assignments + flips re-confirmed wave-by-wave at P5/P6"
depends_on: [adr_000, adr_001, adr_004]
supersedes: adr_003
tags: [decision, adr, adr_005, git, visibility, codeberg, github, self_hosted, host_policy, path_b, binding, accepted]
---

# ADR-005 — Visibility-Driven Host Policy (binding; Codeberg-ToS amended; Path B)

**Status**: `accepted` (authored at genesis **P2**, 2026-06-20; ratified at the P2-exit gate). **Supersedes [[adr_003_visibility_split_policy]]** — corrects its load-bearing error and binds the operator's P2-entry decision. Depends on [[adr_004_provider_contract_interface|ADR-004]].

## Context

[[adr_003_visibility_split_policy]] (accepted at P0) set **"private/internal → Codeberg."** P1 found this **invalid**: [[context_provider_tooling_sota]] — **Codeberg's ToS prohibits private proprietary repos** (FOSS-only; ~100 MB private-convenience cap; no paid waiver — their FAQ says self-host Forgejo). The fleet is **~95% private** ([[fleet_git_state]]), several with client/clinical data — so the original default cannot stand. At the **P2-entry gate** the operator chose:
- **Path B** — *private repos stay on GitHub (interim); only the FOSS subset moves to Codeberg; self-hosted Forgejo (the north star) is stood up at P7 and becomes the eventual private home once backup/restore/uptime is proven.*
- **Classification: approve-in-principle** — encode the draft now; re-confirm per-graph specifics + authorize flips/moves at each gated wave.

This ADR binds that policy. The permanent architecture is unchanged (ADR-000 D5): provider-agnostic contract; self-hosted Forgejo = north-star private home; Codeberg = FOSS/public home. Path B is the **near-term sequencing**, not a change of destination.

## Decisions

### D1 — The amended split (default host by visibility — binding)

| Visibility / kind | Default **origin** (now) | Eventual home | Public face | Why |
|---|---|---|---|---|
| **public / FOSS** | **Codeberg** (`aDNA-Network`) | Codeberg | **GitHub mirror** (discovery/stars) | Codeberg is *for* FOSS; GitHub keeps the network effect via mirror |
| **private / internal** | **GitHub** (`aDNA-Network`, interim) | **self-hosted Forgejo** (post-P7) | — | Codeberg ToS forbids private proprietary; GitHub is the working interim |
| **release of internal work** (Class R) | private origin (GitHub-interim → self-hosted) | self-hosted | **GitHub/Codeberg mirror on tags** | source-of-truth private; public face auto-updates ([[adr_004_provider_contract_interface|ADR-004]] D5) |

> **🚩 Codeberg = FOSS-only.** No private proprietary repo is ever hosted on Codeberg. This is a ToS constraint, not a preference.

### D2 — Generalized repo classes (P/I/R/L; re-mapped to Path B)

| Class | Meaning | `origin` (now) | `mirror` |
|---|---|---|---|
| **P — Public-primary** | FOSS, community-facing | **Codeberg** (or GitHub-public per wave) | GitHub (discovery) |
| **I — Internal** | private/proprietary dev | **GitHub** (interim) → self-hosted | — |
| **I-strict** | client/sensitive (clinical, contracts) | **GitHub** (interim, strict ACL) → self-hosted | — *(history-scan before ANY move)* |
| **R — Release** | private dev, public releases | private origin | public mirror on tags |
| **L — Local-only** | never-push (Rule 4 / legal IP) | none | none |

**Decision tree** (amended): community discovers/contributes & it's FOSS? → **P** (Codeberg origin + GitHub discovery). Client/sensitive? → **I-strict** (GitHub-interim, history-scan-gated). Authored internally, published outward? → **R**. Local-by-default / never-push? → **L**. Otherwise → **I** (GitHub-interim). When in doubt → **I** (promotion is one mirror config; demotion is history surgery).

### D3 — Release mirroring (Class R; Path B)
Public releases of internal work ride a **Forgejo-native push-mirror** from the private origin to the public face, on tags ([[adr_004_provider_contract_interface|ADR-004]] D5 mechanics: get-or-create idempotency, branch-filter + tag discipline, LFS→HTTPS+PAT). Near-term the private origin is GitHub-interim; post-P7 it becomes self-hosted Forgejo — the verb and naming ([[adr_006_remote_naming|ADR-006]]) are unchanged across that move.

### D4 — Classification ratified-in-principle ([[fleet_git_state]] is the source-of-record)
The per-graph classification in [[fleet_git_state]] (~43 graphs + nested code-as-WHAT repos) is the **binding assignment ledger**; this ADR carries the *rules*, not the rows (no duplication). Per the operator decision, it is **approved in principle now**; per-graph specifics — name-drift reconciliation (~14 repos), cross-org stragglers (on `LatticeProtocol` + a personal account — see [[fleet_git_state]]; aDNALabs' lane), and confirm-intent graphs (ComfyUI, VisualDNA, Datasets, TypeScript) — and **the actual public-flips/migrations are re-confirmed and authorized at each gated P5/P6 wave** (no move is ever silent). The **intended-public OSS set** is recorded as the target **P-class**: `aDNA · III · Canvas · Astro · Videos · Molecules · Oration · TypeScript` (+ `ComfyUI` pending intent-confirm) — all currently private on GitHub; their flip/relocation is wave-gated.

### D5 — Default for new graphs (amended)
- **New FOSS graph** → **Codeberg-public** origin (+ GitHub discovery mirror).
- **New private graph** → **GitHub-interim** origin (eventual self-hosted).
- The old "Codeberg-private default" ([[adr_003_visibility_split_policy]] D6) is **retired** — ToS-invalid. The `git/` wrapper sets the visibility-appropriate default at fork.

### D6 — Coexistence with Operation Homecoming (aDNALabs / Berthier)
Under Path B the partition is *cleaner* than ADR-003 foresaw — **no private repos are pulled off GitHub near-term**, so Homecoming's work is preserved, not undone:
- **GitHub `aDNA-Network`** = private-interim home (stays) **+** public discovery for the OSS set.
- **Codeberg `aDNA-Network`** = the **FOSS subset only**.
- **Self-hosted Forgejo** = eventual private home (post-P7).

Git.aDNA owns patterns + tooling + per-graph execution; aDNALabs owns the org-level program (incl. `admin:org` repo-renames + straggler org-batch). **Operator + Berthier jointly gate before any wave.** ([[coord_draft_adnalabs_migration_coexistence|coord memo]].)

### D7 — Migration posture (gated waves, re-scoped for Path B)
- **Near-term (P5/P6):** the only outward host move is **FOSS subset → Codeberg** (+ GitHub discovery) — the low-risk dogfood. Private repos **stay on GitHub** (no churn).
- **Post-P7:** once the self-hosted spike proves backup/restore/uptime, private repos migrate **GitHub-interim → self-hosted Forgejo** in gated waves, lowest-risk first; **I-strict client repos require a full-history secret scan before any move** ([[adr_011_secret_scanning|ADR-011]]) and go last.
- **External upstreams** (`ggml-org/llama.cpp`, `Wilhelm-Foundation/rare-archive`) are **never re-homed**.
- Every re-point is registered in the **Home.aDNA shim registry** (Rule 9; [[adr_006_remote_naming|ADR-006]]).

## Consequences
- The fleet becomes **multi-host** deliberately: FOSS on Codeberg (discoverable on GitHub), private on GitHub-interim, a few Class-R with both; local-only stays dark.
- The campaign's near-term outward deliverable is modest by design (FOSS→Codeberg); the big private-repo decentralization is **earned** by the P7 spike, not rushed.
- [[fleet_git_state]] + a `disposition_ledger` (P6) + the shim registry keep drift visible; each wave is gated.
- The credential model ([[adr_007_credential_model|ADR-007]]) needs a Codeberg/Forgejo token now and a self-hosted token later — same broker pattern.

## Open questions carried forward (→ P5/P6/P7)
- Per-graph origin direction for the OSS set: flip-public-on-GitHub-and-add-Codeberg vs move-origin-to-Codeberg-and-mirror-GitHub (→ per-wave).
- Whether any public graph also keeps a Codeberg/GitHub resilience mirror (→ P6).
- Codeberg org/team topology (→ P5 beachhead).
- Self-hosted readiness gates (restore drill) before any private migration (→ P7 → post-P7 waves).

## Alternatives considered (the P2-entry gate options)
- **Path A — self-host Forgejo now** as the private home. Rejected by the operator: front-loads production-forge infra (backups/restore/uptime) ahead of the specs (P3), credentials (P5), and before ~42 repos incl. client clinical data can be safely trusted to it; inverts dependency order.
- **Path C — hybrid by sensitivity** (self-host I-strict now, GitHub for the rest, Codeberg FOSS). Rejected by the operator: partial self-host infra now for limited near-term benefit; a split policy to maintain.
- **Keep ADR-003 as written** (private→Codeberg) — impossible; ToS-invalid for proprietary repos.
