---
type: decision
adr_id: adr_002
title: "ADR-002 — Git-Ops Provider Abstraction (sketch)"
status: accepted
created: 2026-06-19
updated: 2026-06-19
last_edited_by: agent_stanley
ratifies_at: "sketch ratified at P0 charter gate; BINDING form authored + ratified at genesis P2"
depends_on: [adr_000, adr_001]
tags: [decision, adr, adr_002, git, provider_abstraction, forgejo, github, sketch, accepted]
---

# ADR-002 — Git-Ops Provider Abstraction (sketch)

**Status**: `accepted` **(sketch)** — direction ratified at the P0 charter gate (operator APPROVE, 2026-06-19); the **binding interface** is authored + ratified at genesis **P2** after the P1 tooling/SOTA research. Depends on [[adr_000_project_identity]], [[adr_001_seed_docs_reframe]].

## Context

Today every `.aDNA` graph does git through **GitHub-hardcoded** tooling — `.adna/how/skills/skill_git_remote_setup.md` bakes in `gh repo create` and `https://github.com/$org/$repo.git` (lines 135/144); `skill_vault_publish.md` uses `gh release create`. There is no seam to swap hosts. The mandate (ADR-000 D5) requires a **provider abstraction** so a graph's git-ops are identical whether its host is GitHub, Codeberg, or a self-hosted lighthouse forge. This ADR sketches that abstraction so the campaign has a shared mental model; P2 makes it binding.

## The abstraction (sketch)

### A git-ops **provider contract** — verbs, not hosts
A small, host-neutral set of operations every graph needs. Skills and doctrine call the **contract**; the contract dispatches to a **backend**.

| Verb | Meaning | GitHub backend | Forgejo backend |
|---|---|---|---|
| `create-repo` | make the remote repo | `gh repo create` | `tea repo create` / Forgejo REST |
| `set-remote` | point `origin` (+ named remotes) | `git remote …` + provider URL | same git; provider URL |
| `push` | push history/tags | `git push` | `git push` |
| `open-pr` | propose a change | `gh pr create` | `tea pr create` / REST |
| `cut-release` | tag + release artifacts | `gh release create` | `tea release create` / REST |
| `configure-mirror` | push/pull mirror | GitHub mirror / Action | **Forgejo native push-mirror** |
| `port-ci` | the CI surface | `.github/workflows/` | `.forgejo/workflows/` (GH-compatible syntax) |

### Two backends cover three profiles
Because **Codeberg runs Forgejo**, the **Forgejo backend serves both hosted Codeberg and any self-hosted lighthouse forge** — so the whole abstraction is a **2-backend** problem:

| Profile | Backend | `host` value (example) | Role |
|---|---|---|---|
| **GitHub** | GitHub API | `github.com` / `aDNA-Network` | public graphs, releases, community |
| **Codeberg** | Forgejo API | `codeberg.org` / `aDNA-Network` | **private/internal dev (default now)** |
| **Self-hosted lighthouse** | Forgejo API | `git.<subnet>.adna.network` | **north star** — per-subnet mesh forge, ForgeFed |

### Per-graph declaration
Each graph declares its git-ops posture in machine-readable form (frontmatter or a small `git/config.yaml` in the consumer wrapper):

```yaml
git_provider:
  host: codeberg.org          # github.com | codeberg.org | git.<subnet>.adna.network
  backend: forgejo            # github | forgejo  (derived from host; explicit for clarity)
  org: aDNA-Network
  visibility: private         # private | public  (drives the default host — ADR-003)
  remotes:
    origin: codeberg.org/aDNA-Network/Git.aDNA
    mirror: github.com/aDNA-Network/Git.aDNA   # optional; release-mirror target (Class R)
```

The provider contract reads this; a host swap (e.g. Codeberg → lighthouse) is a **one-field edit + re-point**, not a tooling rewrite — that is the **north-star on-ramp**.

### Remote-naming convention (proposed)
- `origin` → the graph's canonical home (per visibility/policy).
- `mirror` → an outbound release mirror target (replaces the seed set's `harbor`, generalized; ADR-003 Class R).
- `upstream` → an external upstream we track but don't own (e.g. `ggml-org/llama.cpp`) — unchanged.

### Credentials
Provider-scoped tokens via the **`Home.aDNA` broker** (Standing Rule 6) — a Codeberg/Forgejo token alongside the GitHub token, Keychain-primary + 1P-backup, never inlined. P2 + a Home coord memo specify the entries.

## Decisions (sketch-level; operator ratifies the direction)

1. **Contract-over-backend** is the architecture (verbs dispatch to GitHub-API or Forgejo-API).
2. **Two backends** (GitHub, Forgejo); Forgejo covers Codeberg **and** self-hosted — no third backend for the north star.
3. **Per-graph machine-readable declaration** drives dispatch; host-swap is a field edit.
4. **`tea`** (the Gitea/Forgejo CLI) is the *candidate* Forgejo-backend tool; **P1 verifies** (vs. raw REST / `berg` / git-remote-helpers) before P2 binds it.
5. The abstraction lives in **doctrine + skills authored here**, shipped to `.adna/` via `aDNA.aDNA` (ADR-000 D4).

## Consequences

- The two hardcoded skills become **provider-parametrized** (P3 drafts; P4 upstreams).
- A new per-graph **`git/` consumer wrapper** carries the declaration (P3) — the III `iii/` wrapper is the template.
- ForgeFed federation (Forgejo-native) becomes the **technical substrate of the mesh-git north star** (P7) — the same backend, federated.
- CI parity (`.github/` ↔ `.forgejo/`) is a first-class workstream, not an afterthought.

## Open questions carried forward (→ P1 research, P2 binding)

- Forgejo-backend tool of record: `tea` vs. REST vs. helper (→ P1).
- Whether to implement the contract as **skills + a thin shared shell lib**, or a small **CLI** (`adna-git`?) — P2.
- Auth UX for Codeberg/Forgejo tokens in non-TTY agentic contexts (mirror the Rule 5/6 pattern) — P2 + Home coord.
- `open-pr` / `cut-release` semantic differences (GitHub Releases vs. Forgejo Releases; PR review models) — P1 parity notes.
- Submodule / LFS / package-registry parity across backends — P1.

## Alternatives considered

- **Three backends** (GitHub, Codeberg, self-hosted as distinct) — rejected; Codeberg *is* Forgejo, so one Forgejo backend serves both — half the surface.
- **Stay GitHub-only + add Codeberg ad hoc** — rejected; reproduces the hardcoding one host over, no path to the north star.
- **Adopt an existing multi-forge tool wholesale** (e.g. a git-remote-helper or `git-town`-style layer) — *deferred to P1 evaluation*; may become the backend impl, but the aDNA contract + per-graph declaration + credential-broker integration are ours regardless.
