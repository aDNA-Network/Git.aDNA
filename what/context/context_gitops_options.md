---
type: context
context_id: context_gitops_options
title: "Git-Ops Options & Decision Guide — choose · interoperate · refactor"
status: draft
created: 2026-06-20
last_edited_by: agent_stanley
binds_adrs: [adr_004, adr_005, adr_012]
tags: [context, git, options, decision_guide, advisory, provider, draft, phase_3]
---

# Git-Ops Options & Decision Guide

The **advisory layer** an agent loads to help a user *choose · interoperate · refactor* their git-ops — across every option the agnostic standard supports. Companion to [[skill_gitops_advisor]]. Authority = the ADRs; this is the human/agent-facing map. (Thread A of [[context_north_star_vision]].)

## The four options at a glance

| Option | What it is | Best when | aDNA integration | Tradeoffs |
|---|---|---|---|---|
| **GitHub** | hosted, centralized; max network effect | public/OSS discovery; existing community; CI on GitHub-hosted runners; **interim private home** (Path B) | `backend: github` (gh-api); CI `.github/workflows/` | centralized; private = trust + lock-in pull; ToS-fine for proprietary |
| **Codeberg** | hosted Forgejo; FOSS non-profit | **public/FOSS** repos that want off-GitHub; dogfood the Forgejo backend at zero infra | `backend: forgejo` (REST `/api/v1`); `.forgejo` (or `.github` fallback) | **FOSS-only (ToS)** — no private proprietary; shared runners |
| **Self-hosted Forgejo** | your own Forgejo instance | you run infra and want sovereignty over private repos; an org/team home | same `forgejo` backend — *identical contract*, different `host` | you own ops (backup/restore/uptime/TLS) |
| **Lighthouse-subnet forge** | self-hosted Forgejo as your **L1 subnet's core git + context-sync fabric**, coordinated by the lighthouse | you run an aDNA **lighthouse subnet mesh** (the **default** for that persona — ADR-012) | the deployable = `Lighthouse.aDNA`; mesh/identity = `Network.aDNA`; vaults sync *as git* | needs the node stack; forge on a **data-plane** node (Network `ADR-016 §8`), not the lighthouse host |

*One mechanism underneath:* the [[spec_gitops_provider_abstraction|provider contract]] — 7 verbs over 2 backends (GitHub-API + Forgejo-API). **Switching options is a one-field `host` edit + a gated migration** ([[skill_repo_migrate]]), never a tooling rewrite. Host-choice is preserved forever.

## Choosing (decision tree)
1. **Is it FOSS/public and you want community discovery?** → **GitHub** (and/or **Codeberg** as the FOSS home + GitHub discovery mirror).
2. **Is it private/proprietary and you do NOT run infra?** → **GitHub** (interim private home; Codeberg can't host private proprietary).
3. **Do you run your own L1 lighthouse subnet?** → **Lighthouse-subnet forge** (the default — your own Forgejo as core git + context-sync). Hosted stays available per repo.
4. **Do you run infra but not a full lighthouse?** → **Self-hosted Forgejo** (sovereign private home).
5. **Client/sensitive (I-strict)?** → strictest home + **mandatory pre-move secret scan** ([[adr_011_secret_scanning|ADR-011]]) before any host change.

## Interoperate vs. refactor
- **Interoperate** (keep your current setup, add aDNA git-ops): drop a `git/` wrapper declaring your existing `host`; adopt the [[doctrine_gitops_block|doctrine block]]; use the agnostic skills. Nothing moves. Good first step for an existing repo on GitHub.
- **Refactor** (re-home to match your aДNA posture): use [[skill_repo_migrate]] (scan-gated, rollback-preserving) to move `origin`; add a `mirror` for discovery/release; register the re-point in the Home.aDNA shim registry. Right when your visibility/persona changed (e.g. you stood up a lighthouse, or a repo went public).

## How each integrates with aDNA's agentic patterns
- **Vaults are git repos** → your forge choice *is* your context-management/sync substrate. On a lighthouse subnet, the forge becomes the mesh's context-sync fabric (build on Network's `adna-exchange` drill-#7). (Thread C.)
- **Skills are host-neutral** → the same `create-repo`/`push`/`cut-release`/`configure-mirror` work everywhere; agents never special-case a provider.
- **Credentials via the Home.aDNA broker** (never inlined); **secret-scan** before any push/move; **CI portable-first** (both backends).

## Pointers
- Policy: [[adr_005_visibility_host_policy|ADR-005]] (Path B) + [[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]] (lighthouse-operator default).
- Contract + wrapper: [[spec_gitops_provider_abstraction]]. Migration: [[skill_repo_migrate]]. Setup: [[skill_git_remote_setup]] / [[skill_git_provider_config]].
- The deployable lighthouse forge: `Lighthouse.aDNA`. The mesh: `Network.aDNA`.
