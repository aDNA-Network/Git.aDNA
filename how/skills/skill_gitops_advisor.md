---
type: skill
skill_type: agent
created: 2026-06-20
updated: 2026-06-20
status: draft
category: onboarding
trigger: "A user/node is setting up or reconsidering their git-ops and wants help choosing/interoperating/refactoring across providers"
last_edited_by: agent_stanley
tags: [skill, git, advisory, onboarding, choose_interoperate_refactor, draft]
requirements:
  tools: [how/skills/skill_git_provider_config.md, how/skills/skill_repo_migrate.md]
  context: [what/context/context_gitops_options.md, what/specs/spec_gitops_provider_abstraction.md]
  permissions: ["reads node/repo state; writes only the git/ declaration; no outward action"]
---

# Skill: Git-Ops Advisor

## Overview
The **advisory front-door** for git-ops (thread A of [[context_north_star_vision]]). On install, an agent uses this to help a user **choose** a git-ops posture across all options (GitHub · Codeberg · self-hosted Forgejo · lighthouse-subnet forge), **interoperate** (keep their setup, add aDNA git-ops) or **refactor** (re-home to match their posture), and **integrate git with aDNA's agentic patterns**. It decides nothing irreversibly — it produces a recommended `git/` declaration + a gated action list. Draft; upstreamed via `aDNA.aDNA` at P4.

## Trigger
`/gitops-advisor` — at new-graph fork, new-node setup, or whenever a user reconsiders their git-ops.

## Parameters
| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| scope | enum | no | repo | `repo` \| `node` \| `subnet` (advise one repo, a whole node, or a lighthouse subnet) |
| intent | enum | no | ask | `choose` \| `interoperate` \| `refactor` (skip the triage if known) |

## Requirements
- Context: [[context_gitops_options]] (the landscape/decision tree) + [[spec_gitops_provider_abstraction]].
- Calls: [[skill_git_provider_config]] (write the declaration), [[skill_repo_migrate]] (if refactoring).
- No outward action — recommends + writes only the local `git/` declaration; moves are separately gated.

## Implementation
1. **Detect context** — is this a **lighthouse-subnet operator** (running their own L1 subnet mesh)? a private/proprietary repo? FOSS/public? client/sensitive (I-strict)? running infra?
2. **Apply the decision tree** ([[context_gitops_options]] §Choosing). **Lighthouse-subnet operator → default = self-hosted Forgejo** (their subnet's core git + context-sync — [[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]]); else Path B ([[adr_005_visibility_host_policy|ADR-005]]). Always present the default as a *recommendation*, with host-choice preserved.
3. **Choose intent**:
   - **choose** (new) → recommend `host`/`visibility`/`class`; hand to [[skill_git_provider_config]].
   - **interoperate** (keep current host) → write a `git/` wrapper for the existing `host`, adopt the [[doctrine_gitops_block|doctrine block]] + the gitleaks hook; nothing moves.
   - **refactor** (re-home) → plan a [[skill_repo_migrate]] run (scan-gated, rollback-preserving); list the gated steps; do **not** execute (operator gate).
4. **Integrate with agentic patterns** — explain that vaults-are-git-repos → the chosen forge is the context-sync substrate (esp. on a lighthouse subnet); wire the doctrine block + credentials-via-Home + CI portable-first.
5. **Output** the recommended `git/` declaration + a gated action list; never perform outward actions.

## Outputs
| Output | Type | Description |
|---|---|---|
| recommendation | report | chosen option + rationale (per the decision tree) |
| `git/` declaration | wrapper (draft) | written via skill_git_provider_config |
| gated action list | plan | setup/migrate steps, each operator-gated |

## Error Handling
| Error | Cause | Resolution |
|---|---|---|
| illegal default (private→Codeberg) | persona/visibility mismatch | fall back to GitHub-interim / self-hosted (ADR-005) |
| lighthouse intent but no subnet | scope=subnet without a lighthouse | recommend self-hosted Forgejo or defer to `Lighthouse.aDNA` setup |

## Related
- [[context_gitops_options]] · [[skill_git_provider_config]] · [[skill_repo_migrate]] · [[doctrine_gitops_block]] · `Lighthouse.aDNA` (the deployable lighthouse forge)
