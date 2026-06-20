---
plan_id: p3_specs_tooling_skeleton
type: plan
title: "P3 — Specs & Tooling Skeleton"
owner: stanley
status: planned
campaign_id: campaign_git_genesis
campaign_phase: 3
campaign_mission_number: 3
mission_class: implementation
created: 2026-06-19
updated: 2026-06-19
last_edited_by: agent_stanley
tags: [plan, campaign, git, genesis, specs, tooling, operation_free_harbor]
---

# Mission: P3 — Specs & Tooling Skeleton

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 3 — Specs & Tooling Skeleton · **Mission**: 3 of 8

## Goal
Author the binding spec for the provider abstraction and **draft** the agnostic git-ops tooling **as Git.aDNA-local proposals** (NOT in `.adna/` — Standing Rule 1; upstreamed at P4). Build the consumer-wrapper + doctrine-block + CI templates.

## Exit Gate
`what/specs/spec_gitops_provider_abstraction.md` authored; the five agnostic skill drafts + the `git/` wrapper + the git-ops doctrine block + CI templates present in `how/`; every skill draft passes `dry_run` against **both** a GitHub and a Codeberg/Forgejo target (no live writes).

## Objectives (sketch — expand when phase opens)
1. **Spec** — `spec_gitops_provider_abstraction.md` (the binding contract + per-graph declaration + remote-naming).
2. **Skill drafts** (provider-parametrized): `skill_git_remote_setup` (fork the GitHub-hardcoded original) · `skill_vault_publish` (provider-aware) · `skill_git_provider_config` (per-graph declaration) · `skill_repo_migrate` (move a graph between hosts) · `skill_release_mirror` (Codeberg→GitHub on tags).
3. **Doctrine block** — the agnostic successor to the seed set's verbatim forge-doctrine block (for every graph's CLAUDE.md).
4. **`git/` consumer wrapper** — the per-graph wrapper + `federation_ref` (mirror the III `iii/` wrapper).
5. **CI templates** — `.github/workflows/` + `.forgejo/workflows/` parity pair.
6. **Dry-run harness** — prove each skill on both backends without outward writes.

## Campaign Context
- **Prev (M2)**: ratified ADRs (the contract + policy + naming + credentials).
- **Next (M4)**: the drafts are what `aDNA.aDNA` upstreams into `.adna/`.

## Notes
- Drafts live in `how/skills/` (Git.aDNA-local) until P4 upstreams them. **Never edit `.adna/` directly.**

## AAR
*Append before `status: completed`.*
