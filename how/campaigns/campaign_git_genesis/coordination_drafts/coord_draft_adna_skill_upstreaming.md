---
type: coordination
created: 2026-06-19
updated: 2026-06-20
status: draft
last_edited_by: agent_stanley
to: "aDNA.aDNA (Rosetta)"
deliver_at: "P4 (Upstream Coordination)"
tags: [coordination, draft, git, adna, skill_upstreaming, operation_free_harbor]
---

# Coord Draft → aDNA.aDNA (Rosetta): Agnostic Git-Ops Skill Upstreaming

**Status**: **FINALIZED (staged)** 2026-06-20 — P3 drafts complete + **dry-run-verified (harness 19/19)**; **ready for delivery at P4**. Kept **staged** (Rule 10 — Git.aDNA does not write into `.adna/` or `aDNA.aDNA`; Rosetta releases).

## The ask
Ship Git.aDNA's **provider-agnostic git-ops skills** into the `.adna/` base template via `skill_template_release`. `.adna/` is do-not-modify (Standing Rule 1) — Git.aDNA authors the skill *content*; **aDNA.aDNA owns the release** into the template.

## Why (context)
The current `.adna/how/skills/skill_git_remote_setup.md` + `skill_vault_publish.md` are **GitHub-hardcoded** (`gh repo create`, `https://github.com/$org/$repo.git` @ L135/144, `gh release create`). The Operation Free Harbor mandate makes git-ops platform-agnostic (GitHub + Codeberg + self-hosted Forgejo). The replacements are provider-parametrized over a 2-backend contract (GitHub-API + Forgejo-API; [[adr_002_provider_abstraction]]).

## What's ready to upstream (P3 delivered — dry-run-verified)
- **5 agnostic skills**: `skill_git_remote_setup` (supersedes the hardcoded one) · `skill_vault_publish` · `skill_git_provider_config` · `skill_repo_migrate` · `skill_release_mirror`.
- **Shared dispatch lib** `gitops_dispatch.sh` (the "gh api for Forgejo"; `--dry-run` plan mode) + the **dry-run harness** (19/19).
- **Doctrine block** (`doctrine_gitops_block.md`, ADR-009 D6) + the **`git/` consumer-wrapper** pattern (mirrors III's `iii/`).
- **Secret-scan**: `gitleaks` pre-push hook + `.gitleaks.toml` (ADR-011); **CI templates** (both backends, ADR-008).
- **Advisory layer**: `context_gitops_options.md` (decision guide) + `skill_gitops_advisor.md` (choose/interoperate/refactor) — the install-time UX.
- Reference spec: `spec_gitops_provider_abstraction.md` (binds ADR-004…012).

## Decisions to align at P4
1. Release sequencing (which skills in which `skill_template_release`).
2. **Back-compat / deprecation** path for the GitHub-hardcoded originals (don't break existing graphs mid-migration).
3. Whether the `git/` wrapper becomes **standard inheritance** at fork time — new graphs default per **Path B** ([[adr_005_visibility_host_policy|ADR-005]]: FOSS→Codeberg / private→GitHub-interim) **and** the **lighthouse-operator default** ([[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]]: a lighthouse subnet → its own Forgejo). *(Not "Codeberg-private" — that pre-ToS default was superseded by Path B.)*
4. The **advisory layer** (`context_gitops_options` + `skill_gitops_advisor`) ships too, so a freshly-installed node can choose/interoperate/refactor its git-ops.

## Coordinated by
Git.aDNA (Hopper) ↔ aDNA.aDNA (Rosetta). Decision Point 3.
