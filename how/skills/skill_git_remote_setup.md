---
type: skill
skill_type: agent
created: 2026-05-18
updated: 2026-06-20
status: draft
category: setup
trigger: "First-time remote setup for a code-home, on any host (GitHub / Codeberg / self-hosted Forgejo)"
last_edited_by: agent_stanley
tags: [skill, git, remote_setup, provider_agnostic, draft]
requirements:
  tools: [git, "gh (GitHub backend)", "curl (Forgejo backend)", how/skills/lib/gitops_dispatch.sh]
  context: [what/specs/spec_gitops_provider_abstraction.md, "the graph's git/ declaration (ADR-004 D4)"]
  permissions: ["provider token via Home.aDNA broker (P5+); outward action — operator-gated"]
---

# Skill: Git Remote Setup (provider-agnostic)

## Overview
Provider-agnostic first-time remote configuration. **Supersedes** the GitHub-hardcoded original (inherited v7.0: `gh repo create` @L135, `https://github.com/...` @L144, push @L171). Dispatches the `create-repo · set-remote · push` verbs to the GitHub **or** Forgejo backend per the graph's declared `host`. Draft; upstreamed to `.adna/` via `aDNA.aDNA` at P4 (SO#3).

## Trigger
`/git-remote-setup --host <h> --org <o> --repo <r> [--visibility private|public] [--branch main]` — or invoked by the new-graph fork-hook ([[skill_git_provider_config]]).

## Parameters
| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| host | string | yes | — | `github.com` \| `codeberg.org` \| `git.<subnet>.adna.network` (drives backend, ADR-004 D2) |
| org | string | yes | — | owning org (e.g. `aDNA-Network`) |
| repo | string | yes | dirname | remote repo name |
| visibility | enum | no | per ADR-005 | `private`\|`public` — must respect ADR-005 (Codeberg = FOSS-only) |
| branch | string | no | current | branch to push + set upstream |

## Requirements
- Tools: `git`; `gh` (GitHub) or `curl` (Forgejo); source `how/skills/lib/gitops_dispatch.sh`.
- Context: the graph's `git/` declaration; [[spec_gitops_provider_abstraction]].
- Permissions: token brokered by Home.aDNA (ADR-007); **outward — operator-gated** (genesis: dry-run only until P5).

## Implementation
1. **Resolve** `backend = gitops_backend_for_host $host`; token-env `gitops_token_env_for_host $host` (never read the value).
2. **Policy check** — assert `visibility` legal for `host` (ADR-005: no private-proprietary on Codeberg). Abort with guidance if violated.
3. **Secret scan** — run the [[adr_011_secret_scanning|ADR-011]] pre-push hook before any push.
4. **create-repo** — `gitops_create_repo "$host" "$org" "$repo" "$visibility"` (idempotent get-or-create).
5. **set-remote** — `gitops_set_remote "$host" "$org" "$repo" origin`.
6. **push** — `gitops_push "$branch"`.
7. **Register** the new `origin` in the Home.aDNA shim registry (ADR-006 D4) — Git emits, Home holds.

> **Dry-run:** with `GITOPS_DRY_RUN=1` every step prints its PLAN (no network/secrets/writes) — the P3 mode. Live setup is P5+ (`GITOPS_ALLOW_LIVE=1`, operator-gated).

## Outputs
| Output | Type | Description |
|---|---|---|
| remote `origin` | git remote | points at `https://<host>/<org>/<repo>.git` |
| shim entry | registry record | emitted to the Home.aDNA disposition ledger |

## Error Handling
| Error | Cause | Resolution |
|---|---|---|
| visibility-illegal-on-host | private repo targeted at Codeberg | choose GitHub-interim (ADR-005) or self-hosted |
| token-missing | broker env-var unset | provision via Home.aDNA (ADR-007); P5 |
| repo-exists | get-or-create hit existing | idempotent — proceed to set-remote |

## Related
- [[spec_gitops_provider_abstraction]] · [[skill_vault_publish]] · [[skill_git_provider_config]] · `how/skills/AGENTS.md`
