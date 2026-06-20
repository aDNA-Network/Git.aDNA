---
type: decision
adr_id: adr_008
title: "ADR-008 — CI/CD Parity (GitHub Actions ↔ Forgejo Actions)"
status: proposed
created: 2026-06-20
updated: 2026-06-20
last_edited_by: agent_stanley
ratifies_at: "authored at genesis P2 (2026-06-20); ratified at the P2-exit gate; templates land P3"
depends_on: [adr_004, adr_007]
tags: [decision, adr, adr_008, git, ci_cd, actions, forgejo, github, parity, binding, proposed]
---

# ADR-008 — CI/CD Parity (GitHub Actions ↔ Forgejo Actions)

**Status**: `proposed` (genesis **P2**, 2026-06-20; ratified at the P2-exit gate). Binds the `port-ci` verb ([[adr_004_provider_contract_interface|ADR-004]] D1). Depends on [[adr_004_provider_contract_interface|ADR-004]], [[adr_007_credential_model|ADR-007]].

## Context
The `port-ci` verb must place a working CI surface on whichever host a graph lives on. **Forgejo Actions** runs **GitHub-Actions-compatible** workflow YAML (`.forgejo/workflows/`) on a registered `forgejo-runner`, so parity is *high but not free*. P1 ([[fleet_git_state]]) found CI is **sparse** — only ~7 fleet repos carry workflows — so the strategy optimizes for low-maintenance correctness, not a heavy abstraction.

## Decisions

### D1 — Two CI surfaces, one canonical source
| Host | Surface | Engine |
|---|---|---|
| GitHub | `.github/workflows/` | GitHub Actions (GitHub-hosted runners) |
| Codeberg / self-hosted Forgejo | `.forgejo/workflows/` | Forgejo Actions (registered `forgejo-runner`) |

The **canonical source is one workflow authored in GitHub-Actions syntax**; `port-ci` **generates/syncs** the `.forgejo/workflows/` variant by applying the delta list (D2). One source of truth, no hand-maintained divergence.

### D2 — The non-portable delta list (binding checklist for `port-ci`)
What does **not** carry across unchanged — `port-ci` MUST handle each:
1. **`uses:` action references.** GitHub resolves from `github.com`; Forgejo resolves from its configured root/mirrors. **Pin actions to a resolvable source** (full URL or a forge-namespace mirror); never bare `actions/checkout@v4` assuming github.com.
2. **`runs-on:` runner labels.** No GitHub-hosted runners on Forgejo. Use explicit labels backed by a **registered runner**; don't assume `ubuntu-latest` exists.
3. **Secrets.** Re-provisioned as Forgejo repo/org secrets ([[adr_007_credential_model|ADR-007]]) — not auto-carried from GitHub.
4. **`github.*` / context expressions.** Forgejo provides a compatible context but some fields differ — avoid/guard unsupported keys.
5. **GitHub-only features.** Auto-`GITHUB_TOKEN` permissions, OIDC, certain marketplace actions — flag **provider-specific**, gate behind a host check or drop.

### D3 — Portable-first rule (Standing Order #4)
A workflow is authored **portable-first** — resolvable action pins, explicit runner labels, no GitHub-only features — or its non-portable parts are **documented as provider-specific**. `port-ci` validates against D2 and fails loudly on an unhandled GitHub-only construct. A workflow that only runs on GitHub is a *finding*, not a default.

### D4 — Runner provisioning is a host concern (boundary)
`forgejo-runner` registration + the runner host (a Nebula node for self-hosted; Codeberg provides shared runners for FOSS) is **infrastructure** — coordinated with **Network.aDNA** for the self-hosted profile ([[adr_010_mesh_git_north_star|ADR-010]]) and out of Git.aDNA's deploy scope (ADR-001). Git.aDNA owns the **workflow portability contract**; it does not own the runner fleet.

### D5 — Deliverables (P3)
P3 ships, for both backends: a **minimal portable CI template** (lint/test/build in portable syntax) + the **generated `.forgejo/` variant**, dry-run-validated against a GitHub **and** a Codeberg/Forgejo target (the P3 exit gate). Repos with no CI need none — parity is opt-in per graph.

## Consequences
- The FOSS subset (Codeberg origin, [[adr_005_visibility_host_policy|ADR-005]]) gets working CI on Codeberg's runners; private repos keep GitHub Actions on GitHub-interim — no forced migration of CI.
- Class-R release flows can run release CI on the private origin and mirror artifacts outward.
- A self-hosted lighthouse (post-P7) reuses the same `.forgejo/workflows/` + its own runners.

## Open questions carried forward (→ P3 / Network.aDNA / P7)
- The action-mirror namespace (where Forgejo resolves `uses:` for the self-hosted profile) — a `forge`-org concern (seed architecture).
- Whether to stand a **shared** `forgejo-runner` for the FOSS subset vs rely on Codeberg's shared runners — P5/P7.
- Package/OCI-registry parity (GitHub Packages ↔ Forgejo registry) — P3 parity notes if any graph needs it.

## Alternatives considered
- **Hand-maintain both directories** — rejected: guaranteed drift; generation from one source is safer.
- **Forgejo-only or GitHub-only CI fleet-wide** — rejected: violates host-neutrality (SO#4) and Path B's multi-host reality.
- **A CI-abstraction tool (Dagger/Earthly) as the canonical layer** — deferred: heavyweight for ~7 CI repos; revisit if CI density grows.
