---
type: decision
adr_id: adr_004
title: "ADR-004 — Git-Ops Provider-Contract Interface (binding)"
status: proposed
created: 2026-06-20
updated: 2026-06-20
last_edited_by: agent_stanley
ratifies_at: "authored at genesis P2 (2026-06-20); ratified at the P2-exit gate (proposed → accepted)"
depends_on: [adr_000, adr_001]
supersedes: adr_002
tags: [decision, adr, adr_004, git, provider_abstraction, forgejo, github, rest_api, binding, proposed]
---

# ADR-004 — Git-Ops Provider-Contract Interface (binding)

**Status**: `proposed` (authored at genesis **P2**, 2026-06-20; ratified at the P2-exit gate). **Supersedes [[adr_002_provider_abstraction]]** (the P0 sketch) — promotes it to the binding interface using P1 evidence. Depends on [[adr_000_project_identity]] (D5), [[adr_001_seed_docs_reframe]].

## Context

[[adr_002_provider_abstraction]] sketched a git-ops **provider contract** (verbs over two backends) and left five questions for P1. P1 answered them — [[context_provider_tooling_sota]] fixed the **tool-of-record = raw Forgejo REST `/api/v1`** (not `tea`/`fj`), enumerated the mirror mechanics + their gotchas, and confirmed `gh` already wraps REST on the GitHub side. This ADR makes the contract **binding** so P3 can author skills against a stable interface.

## Decisions

### D1 — The verb set (binding; host-neutral)
A graph's git-ops are exactly these seven verbs. Skills and doctrine call the **verb**; the verb dispatches to a **backend**. A pattern that names a provider instead of a verb is a defect (Standing Order #4).

| Verb | Contract semantics (host-neutral) | GitHub backend | Forgejo backend *(Codeberg + self-hosted)* |
|---|---|---|---|
| `create-repo` | get-or-create a remote repo for `{org, name, visibility}` (idempotent) | `gh api /orgs/{org}/repos` | `POST /api/v1/orgs/{org}/repos` |
| `set-remote` | point a named local remote at a provider URL | `git remote …` | `git remote …` (same git) |
| `push` | publish history + tags | `git push` | `git push` |
| `open-pr` | propose `head → base` | `gh api …/pulls` | `POST /api/v1/repos/{o}/{r}/pulls` |
| `cut-release` | tag-anchored release (+ optional assets) | `gh api …/releases` | `POST /api/v1/repos/{o}/{r}/releases` + asset upload |
| `configure-mirror` | get-or-create a push-mirror `origin → target` (idempotent) | (GitHub is usually the mirror *target*, not origin) | `POST /api/v1/repos/{o}/{r}/push_mirrors` (Forgejo-native) |
| `port-ci` | place/sync the CI surface for the host | `.github/workflows/` | `.forgejo/workflows/` (GH-compatible syntax — [[adr_008_ci_cd_parity\|ADR-008]]) |

### D2 — Two backends cover three profiles (no third backend)
Because **Codeberg runs Forgejo**, one Forgejo backend serves **hosted Codeberg and any future self-hosted lighthouse** — the abstraction is a **2-backend** problem (GitHub-API + Forgejo-API). `backend` is *derived* from `host`: `github.com → github`; everything else (`codeberg.org`, `git.<subnet>.adna.network`) `→ forgejo`.

### D3 — Tool-of-record (binding; P1-resolved)
The Forgejo backend is the **raw REST API `/api/v1`**, driven `gh api`-style (`Authorization: token <PAT>`) — *not* `tea`/`fj`. Rationale ([[context_provider_tooling_sota]]): only REST covers the critical path (`push_mirror`/`pull_mirror`/webhook/deploy-key are REST-only; `tea` exposes workflow surface only); the API is pinned Gitea-1.22-compatible (survived the hard fork — durability); REST exposes the status/payloads idempotency needs; and it is **symmetric** with the GitHub side (`gh` is already a REST wrapper) — one pattern, two endpoints (swap base URL + token). `tea`/`fj` are **optional human-convenience adjuncts only, never the automation path**.

### D4 — Per-graph declaration (binding schema)
Each graph declares its git-ops posture in machine-readable form (the `git/` consumer wrapper carries it — P3). The schema is **host-neutral**; [[adr_005_visibility_host_policy|ADR-005]] sets the *default* host per visibility, [[adr_006_remote_naming|ADR-006]] governs the remote names.

```yaml
git_provider:
  host: github.com            # github.com | codeberg.org | git.<subnet>.adna.network
  backend: github             # github | forgejo  (derived from host; explicit for clarity)
  org: aDNA-Network
  visibility: private         # private | public
  class: I                    # I internal · P public-primary · R release-mirrored · L local-only (ADR-005)
  lfs: false                  # LFS present? (drives the HTTPS+PAT mirror caveat, D5)
  remotes:
    origin: github.com/aDNA-Network/Git.aDNA       # canonical home (ADR-006)
    mirror:                                          # optional outbound mirror target (Class R/discovery)
    upstream:                                        # optional external-tracked-not-owned
```

A host swap (e.g. GitHub-interim → self-hosted lighthouse) is a **one-field edit + re-point**, not a tooling rewrite — that is the **north-star on-ramp** ([[adr_010_mesh_git_north_star|ADR-010]]).

### D5 — `configure-mirror` contract (P1 gotchas are binding)
The mirror verb MUST encode the P1 findings, or it will silently misbehave:
- **No in-place update.** A push-mirror config cannot be edited — change = **delete + re-add** (`repoDeletePushMirror` → `repoAddPushMirror`). Idempotency pattern is **get-or-create / delete-then-recreate**, never update.
- **No tags-only toggle.** Filter is branch-glob only; blank filter = `git push --mirror` (all branches **+ tags**, force). A "release-only" mirror is achieved by branch-filter + tag discipline, not a tags-only switch.
- **LFS does not mirror over SSH.** LFS repos (`lfs: true`) MUST mirror via **HTTPS + PAT**, never SSH+deploy-key.

### D6 — Implementation form (direction; P3 builds)
The contract is realized as **provider-parametrized skills + a thin shared shell lib** — a "`gh api` for Forgejo" HTTP client wrapping `/api/v1` with the brokered token ([[adr_007_credential_model|ADR-007]]). A dedicated `adna-git` CLI is **deferred** (revisit if the shell lib grows unwieldy) — skills are the unit of distribution because they ship to `.adna/` via `aDNA.aDNA` (ADR-000 D4). Optional backend libraries (Gitea Go SDK / `pyforgejo`) are allowed inside a skill but are not the contract.

## Consequences

- The two GitHub-hardcoded `.adna/` skills (`skill_git_remote_setup`, `skill_vault_publish`) become **verb-dispatching + provider-parametrized** (P3 drafts; P4 upstreams). `skill_update_all_vaults` is already host-neutral.
- A new per-graph **`git/` consumer wrapper** carries the D4 declaration (P3) — the III `iii/` wrapper is the template.
- ForgeFed federation (same Forgejo backend, federated) is the technical substrate of the mesh-git north star ([[adr_010_mesh_git_north_star|ADR-010]]) — experimental today ([[context_provider_tooling_sota]]).
- CI parity (`port-ci`) is a first-class verb with its own ADR ([[adr_008_ci_cd_parity|ADR-008]]).

## Open questions — resolved / carried
- ✅ Tool-of-record (`tea` vs REST) → **REST** (D3).
- ✅ Contract as skills+lib vs CLI → **skills + thin lib**, CLI deferred (D6).
- → Auth UX for the Forgejo token in non-TTY contexts → [[adr_007_credential_model|ADR-007]].
- → `open-pr`/`cut-release` semantic deltas (GitHub vs Forgejo review/release models) → captured per-verb in P3 skill specs.
- → Submodule / package-registry parity across backends → [[adr_008_ci_cd_parity|ADR-008]] + P3 parity notes.

## Alternatives considered
- **`tea`/`fj` as the backend** — rejected (D3): no mirror/webhook/deploy-key coverage; Gitea-org drift risk.
- **Three backends** (Codeberg distinct from self-hosted) — rejected: Codeberg *is* Forgejo; one backend, half the surface.
- **A git-remote-helper / multi-forge wrapper wholesale** — rejected as the contract; may appear as a backend impl detail, but the aDNA verb set + per-graph declaration + broker integration are ours regardless.
