---
plan_id: p2_architecture_binding_adrs
type: plan
title: "P2 — Architecture & Binding ADRs"
owner: stanley
status: completed
campaign_id: campaign_git_genesis
campaign_phase: 2
campaign_mission_number: 2
mission_class: implementation
created: 2026-06-19
updated: 2026-06-20
last_edited_by: agent_stanley
tags: [plan, campaign, git, genesis, architecture, operation_free_harbor]
---

# Mission: P2 — Architecture & Binding ADRs

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 2 — Architecture & Binding ADRs · **Mission**: 2 of 8

## Goal
Turn P1's evidence into **binding** architecture. Promote the ADR-002 sketch to a ratified interface and author the remaining load-bearing decisions. Design-only — no code/skills written here.

## Exit Gate
All P2 ADRs `proposed → accepted` (two-cycle ratification). The provider contract, host policy, credential model, CI parity, dev-process doctrine, and mesh-git north-star architecture are locked; the Lighthouse-separate-vs-code-as-WHAT question is decided.

## Objectives (sketch — expand when phase opens)
1. **Provider-contract interface** (binding) — promote [[adr_002_provider_abstraction]]: the verb set, the GitHub-API + Forgejo-API backends, the per-graph declaration schema, the tool-of-record (`tea` vs REST, decided from P1).
2. **`(visibility × provider)` policy** (binding) — promote [[adr_003_visibility_split_policy]] with the P1 classification table.
3. **Remote-naming convention** — `origin` / `mirror` / `upstream` across providers.
4. **Multi-provider credential model** — Codeberg/Forgejo token via the `Home.aDNA` broker (Rule 6); non-TTY agentic UX.
5. **CI/CD parity** — `.github/workflows/` ↔ `.forgejo/workflows/`; what's portable vs provider-specific.
6. **Dev-process git doctrine** — branch/commit/sign/PR conventions + multi-graph change coordination (the "tracking/operations/process" mandate).
7. **Mesh-git north-star architecture** — lighthouse-run Forgejo + ForgeFed; how it plugs the same contract (coord Network.aDNA).
8. **Lighthouse disposition** — separate `Lighthouse.aDNA` vs `what/<forge>/` code-as-WHAT (Decision Point 7).

## Campaign Context
- **Prev (M1)**: fleet inventory + provider SOTA.
- **Next (M3)**: ratified ADRs become the spec basis for the agnostic skills + wrapper.

## As-built (P2 — 2026-06-20)

**P2-entry gate cleared** (operator): D1 = **Path B** (GitHub-interim private + Codeberg-FOSS; self-hosted Forgejo = eventual private home); D2 = **classification approve-in-principle**. Objectives → ADRs:

| Obj | Deliverable | ADR |
|---|---|---|
| 1 Provider-contract interface (binding) | verbs · 2 backends · REST tool-of-record · per-graph schema · mirror gotchas | [[adr_004_provider_contract_interface\|ADR-004]] (supersedes 002) |
| 2 (visibility×provider) policy (binding) | Codeberg-ToS amendment · Path B · classification-in-principle · intended-public set | [[adr_005_visibility_host_policy\|ADR-005]] (supersedes 003) |
| 3 Remote-naming | origin/mirror/upstream/rollback · migration sequence · shim tie-in | [[adr_006_remote_naming\|ADR-006]] |
| 4 Credential model | Codeberg/Forgejo PAT via Home broker · scopes · env-var map · rotation | [[adr_007_credential_model\|ADR-007]] |
| 5 CI/CD parity | `.github`↔`.forgejo` · delta list · portable-first | [[adr_008_ci_cd_parity\|ADR-008]] |
| 6 Dev-process doctrine | branch/commit/sign/PR · multi-graph coordination · doctrine-block contents | [[adr_009_dev_process_doctrine\|ADR-009]] |
| 7 Mesh-git north-star | lighthouse Forgejo · ForgeFed realism · on-ramp · spike-gates-private-migration | [[adr_010_mesh_git_north_star\|ADR-010]] |
| 8 Lighthouse disposition (DP7) | **separate `Lighthouse.aDNA`**; trigger at P7 | [[adr_010_mesh_git_north_star\|ADR-010]] D5 |
| + (P2-exit review) | secret-scanning & history hygiene — closes the #1 risk (MIG-006/SEC-002) | [[adr_011_secret_scanning\|ADR-011]] |

Sketches 002/003 → `superseded` (banners + pointers; provenance kept, SO#6). Coord memos (Home, aDNALabs) finalized + staged (Rule 10). **No outward actions.**

**P2-exit (2026-06-20):** two independent adversarial reviews → "sound; clears the gate; close a few gaps." Approved **revision pass** added **[[adr_011_secret_scanning\|ADR-011]]** (secret-scan; #1 risk, was only a label), corrected ADR-008 CI framing (*familiar* not compatible + `.github/` fallback), added FRG-003/SEC-004 dispositions + ADR-009 server-side signing. **ADRs 004–011 ratified `proposed → accepted`.**

## AAR
- **Worked**: the P2-entry gate (Path B + approve-in-principle) cleanly unblocked all 7 ADRs; supersession kept 002/003 provenance intact.
- **Didn't**: the local ADR-009 number collides nominally with the aDNA-standard ADR-009 §4 (PascalCase) — disambiguated in-file, but a reader could still conflate them.
- **Finding**: Path B makes P2's binding policy *lower-risk* than ADR-003 foresaw — near-term outward work is only FOSS→Codeberg; private decentralization is earned by the P7 spike ([[adr_010_mesh_git_north_star|ADR-010]] D2).
- **Change**: gate-then-author worked; keep the entry-gate AskUserQuestion pattern for any phase that amends an accepted ADR.
- **Follow-up**: ✅ ratified 2026-06-20 (incl. ADR-011 + CI-framing fix from the two-review pass) → **P3 (specs & tooling skeleton)** next. Self-hosted-token + machine-account model deferred to Home.aDNA.
