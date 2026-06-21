---
type: coordination
created: 2026-06-19
updated: 2026-06-20
status: delivered
last_edited_by: agent_stanley
to: "aDNA.aDNA (Rosetta)"
deliver_at: "P4 (Upstream Coordination)"
delivered_on: 2026-06-20
mirror: /Users/stanley/aDNA/aDNA.aDNA/who/coordination/coord_2026_06_20_git_skill_upstreaming.md
tags: [coordination, delivered, git, adna, skill_upstreaming, operation_free_harbor]
---

# Coord Draft → aDNA.aDNA (Rosetta): Agnostic Git-Ops Skill Upstreaming

**Status**: **DELIVERED to aDNA.aDNA 2026-06-20** (mirror note dropped into Rosetta's `who/coordination/`; this is the source-of-record). The 4 alignment decisions are **resolved with Git.aDNA recommendations** (below). **The release itself is NOT fired** — `skill_template_release` is an *outward* public-face push + standard version-bump, and aDNA.aDNA has no open release gate; the ask is now **queued for Rosetta's next release gate** (operator-gated, outward). Tracked in [[coord_delivery_queue]] (row #1 → DELIVERED, awaiting release gate).

> **⚠ Finding (2026-06-20).** `skill_template_release` ships to `github.com/aDNA-Network/aDNA` (public face) and bumps the standard version; the node-local `.adna/` sync is the *tail* of that push (step e). So "release into `.adna/`" is **outward** and is a Rosetta-governance event — it cannot complete under a non-outward authorization. Delivering this ask + resolving the decisions is the non-outward portion; the firing is a future gate.

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

## Decisions — RESOLVED (Git.aDNA recommendation; Rosetta ratifies at the release gate)

1. **Release sequencing → ONE coherent batch.** Ship all 5 skills + `gitops_dispatch.sh` lib + dry-run harness + `doctrine_gitops_block` + `git/` wrapper pattern + `gitleaks` hook/`.gitleaks.toml` + dual-backend CI templates + advisory layer **in a single `skill_template_release` leg** (proposed tag continues the line, e.g. `v7.3`). Rationale: the artifacts are interdependent (skills call the lib; the wrapper references the skills; the doctrine cites the hook) — a partial release would ship dangling references. The batch is self-contained and dry-run-verified (19/19).
2. **Back-compat for the 2 hardcoded originals → supersede-in-place, non-breaking.** The agnostic `skill_git_remote_setup` + `skill_vault_publish` keep the **same filenames** (no consumer-path breakage). They are provider-parametrized with `github.com` as a fully-supported backend, so existing GitHub graphs behave identically by default (the GitHub path is preserved, not removed). Release notes flag the behavior delta (host now resolved from the `git/` wrapper's `git_provider`, default GitHub when absent). Originals archived per archive-never-delete in aDNA.aDNA skill history. **No mid-migration breakage.**
3. **`git/` wrapper as fork-time inheritance → YES, but as a non-breaking fast-follow (separate from this release).** Recommend `skill_project_fork` scaffold a default `git/` wrapper for new graphs, defaulting per **Path B** ([[adr_005_visibility_host_policy|ADR-005]]: FOSS→Codeberg / private→GitHub-interim) **and** honoring the **lighthouse-operator default** ([[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]]: a lighthouse subnet → its own Forgejo). Gate this **after** the skill batch lands (it depends on the skills existing in `.adna/`); it is itself non-breaking (additive scaffold). *(Not "Codeberg-private" — that pre-ToS default was superseded by Path B.)*
4. **Advisory layer → YES, ships in the batch (Decision 1).** `context_gitops_options` + `skill_gitops_advisor` ride along so a freshly-installed node can choose/interoperate/refactor its git-ops at install time.

> **Net:** one release leg (Decisions 1+2+4) + one additive fork-skill fast-follow (Decision 3). Both non-breaking. **Both are outward Rosetta release gates** — operator-authorized, not fired here.

## Coordinated by
Git.aDNA (Hopper) ↔ aDNA.aDNA (Rosetta). Decision Point 3. **Delivered** 2026-06-20 (`session_stanley_20260620_git_p5_prereq_delivery`).
