---
type: coordination
created: 2026-06-19
updated: 2026-06-19
status: draft
last_edited_by: agent_stanley
to: "aDNA.aDNA (Rosetta)"
deliver_at: "P4 (Upstream Coordination)"
tags: [coordination, draft, git, adna, skill_upstreaming, operation_free_harbor]
---

# Coord Draft → aDNA.aDNA (Rosetta): Agnostic Git-Ops Skill Upstreaming

**Status**: DRAFT — staged at genesis P0; **deliver at P4** (after the skills are drafted + dry-run-verified at P3). Not yet sent.

## The ask
Ship Git.aDNA's **provider-agnostic git-ops skills** into the `.adna/` base template via `skill_template_release`. `.adna/` is do-not-modify (Standing Rule 1) — Git.aDNA authors the skill *content*; **aDNA.aDNA owns the release** into the template.

## Why (context)
The current `.adna/how/skills/skill_git_remote_setup.md` + `skill_vault_publish.md` are **GitHub-hardcoded** (`gh repo create`, `https://github.com/$org/$repo.git` @ L135/144, `gh release create`). The Operation Free Harbor mandate makes git-ops platform-agnostic (GitHub + Codeberg + self-hosted Forgejo). The replacements are provider-parametrized over a 2-backend contract (GitHub-API + Forgejo-API; [[adr_002_provider_abstraction]]).

## What's coming (P3 drafts → P4 release)
- `skill_git_remote_setup` (provider-parametrized; supersedes the hardcoded one)
- `skill_vault_publish` (provider-aware)
- `skill_git_provider_config` (NEW — per-graph host declaration)
- `skill_repo_migrate` (NEW — move a graph between hosts)
- `skill_release_mirror` (NEW — Codeberg→GitHub on tags)
- the agnostic **git-ops doctrine block** + the **`git/` consumer-wrapper** pattern (mirrors III's `iii/`)

## Decisions to align at P4
1. Release sequencing (which skills in which `skill_template_release`).
2. **Back-compat / deprecation** path for the GitHub-hardcoded originals (don't break existing graphs mid-migration).
3. Whether the `git/` wrapper becomes a **standard inheritance** at fork time (new graphs default Codeberg-private).

## Coordinated by
Git.aDNA (Hopper) ↔ aDNA.aDNA (Rosetta). Decision Point 3.
