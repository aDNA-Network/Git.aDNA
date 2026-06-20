---
plan_id: p3_specs_tooling_skeleton
type: plan
title: "P3 — Specs & Tooling Skeleton"
owner: stanley
status: completed
campaign_id: campaign_git_genesis
campaign_phase: 3
campaign_mission_number: 3
mission_class: implementation
created: 2026-06-19
updated: 2026-06-20
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

## As-built (P3 — 2026-06-20)

All deliverables authored as Git.aDNA-local drafts (**no `.adna/` edits, no outward actions**):

| Deliverable | Path |
|---|---|
| Spec (consumer-facing) | [[spec_gitops_provider_abstraction]] |
| 5 skills (git_remote_setup + vault_publish supersede inherited GH-hardcoded; + git_provider_config · repo_migrate · release_mirror) | `how/skills/skill_*.md` |
| Shared dispatch lib (`--dry-run` plan mode) | `how/skills/lib/gitops_dispatch.sh` |
| Doctrine block (ADR-009 D6) | [[doctrine_gitops_block]] |
| gitleaks pre-push hook + config (ADR-011) | `git/hooks/pre-push.gitleaks.sh`, `git/.gitleaks.toml` |
| `git/` wrapper (dogfood + consumer template) | `git/CLAUDE.md` |
| Dual-backend CI templates (ADR-008) | `what/templates/ci/{github,forgejo}/ci.yml` |
| Dry-run harness | `how/tests/dryrun_gitops.sh` — **19/19 PASS** |

Exit gate met: verb dispatch dry-run-clean for `github.com` **and** `codeberg.org`; live writes refused without `GITOPS_ALLOW_LIVE`. Drafts ship to `.adna/` via `aDNA.aDNA` at P4.

## AAR
- **Worked**: a runnable shared dispatch lib + harness made the "dry-run against both backends" gate a real, deterministic check (19/19), not a hand-wave.
- **Didn't**: no live Forgejo target exists pre-P5, so the dry-run is plan-mode only — true live verification is deferred to the P5 beachhead dogfood.
- **Finding**: Forgejo's native `.github/` fallback means most repos need NO `.forgejo/` file — `port-ci` only emits a delta-variant when required (keeps the CI surface lean).
- **Change**: author the executable substrate (lib + harness) before the markdown skills — it forces the verb contract to be concrete.
- **Follow-up**: P4 — upstream coordination with `aDNA.aDNA` (`skill_template_release`) + author `campaign_gitops_rollout`. Live skill verification → P5.
