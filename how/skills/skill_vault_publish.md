---
type: skill
skill_type: agent
created: 2026-05-18
updated: 2026-06-20
status: draft
category: operations
trigger: "Publish a code-home to its remote (push commits; optionally tag + cut a release) on any host"
last_edited_by: agent_stanley
tags: [skill, publish, vault, git, provider_agnostic, draft]
requirements:
  tools: [git, "gh (GitHub backend)", "curl (Forgejo backend)", how/skills/lib/gitops_dispatch.sh, gitleaks]
  context: [what/specs/spec_gitops_provider_abstraction.md, "the graph's git/ declaration"]
  permissions: ["push to origin; release-create scope (P5+); outward — operator-gated"]
---

# Skill: Vault Publish (provider-agnostic)

## Overview
Provider-agnostic publish. **Supersedes** the GitHub-hardcoded original (inherited v7.0: `git push origin` @L109, `gh release create` @L122). Dispatches `push` + (optional) `cut-release` to the GitHub **or** Forgejo backend per the graph's declared `host`. Draft; upstreamed at P4.

## Trigger
`/vault-publish [--branch <b>] [--tag <t> [--notes <msg>]]`

## Parameters
| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| branch | string | no | current | branch to push |
| tag | string | no | — | if set, cut a release for this tag |
| notes | string | no | tag | release notes |

## Requirements
- Tools: `git`; `gh`/`curl`; `gitleaks`; source `how/skills/lib/gitops_dispatch.sh`.
- Permissions: push + release scope via Home.aDNA token (ADR-007); **outward — operator-gated**.

## Implementation
1. **Secret scan** — the [[adr_011_secret_scanning|ADR-011]] pre-push hook runs first; a finding **blocks** the publish.
2. **push** — `gitops_push "$branch"` (resolves backend from the declared `host`).
3. **cut-release** *(if `--tag`)* — `gitops_cut_release "$host" "$org" "$repo" "$tag" "$notes"`; then upload assets (Forgejo: a second `/releases/{id}/assets` POST; GitHub: `gh release upload`). Note the GitHub-vs-Forgejo release-model delta.
4. **Class R** — if the graph is release-mirrored, the public face updates via [[skill_release_mirror]] (do not double-publish).

> **Dry-run:** `GITOPS_DRY_RUN=1` prints the push + release PLAN (no writes). P3 mode; live = P5+.

## Outputs
| Output | Type | Description |
|---|---|---|
| pushed branch | git | history + tags on `origin` |
| release | provider release | (optional) tag-anchored release + assets |

## Error Handling
| Error | Cause | Resolution |
|---|---|---|
| scan-blocked | gitleaks finding | remediate (ADR-011 D5); never `--no-verify` past a real secret |
| non-fast-forward | remote ahead | pull/rebase; never force without operator sign-off |
| release-exists | tag already released | idempotent — skip or update assets |

## Related
- [[spec_gitops_provider_abstraction]] · [[skill_git_remote_setup]] · [[skill_release_mirror]] · [[adr_011_secret_scanning]]
