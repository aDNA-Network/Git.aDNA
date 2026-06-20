---
type: skill
skill_type: agent
created: 2026-06-20
updated: 2026-06-20
status: draft
category: operations
trigger: "Configure a Class-R push-mirror from a private origin to a public face (on tags)"
last_edited_by: agent_stanley
tags: [skill, git, mirror, release, class_r, forgejo, draft]
requirements:
  tools: [curl, how/skills/lib/gitops_dispatch.sh]
  context: [what/specs/spec_gitops_provider_abstraction.md, "ADR-004 D5 mirror gotchas; ADR-005 D3"]
  permissions: ["mirror-config scope on the origin token (P5+); outward — operator-gated"]
---

# Skill: Release Mirror (Class R)

## Overview
Configures a **Forgejo-native push-mirror** from a private origin (Codeberg or, post-P7, self-hosted) to a public face (GitHub/Codeberg), so the source of truth stays private and the public face updates on tags ([[adr_005_visibility_host_policy|ADR-005]] D3). Encodes the [[adr_004_provider_contract_interface|ADR-004]] D5 mirror gotchas. Draft; live at P5.

## Trigger
`/release-mirror --origin-host <h> --target <url> [--branch-filter <glob>]`

## Parameters
| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| origin-host | string | yes | — | the **Forgejo** origin host (Codeberg / self-hosted) |
| target | string | yes | — | public mirror URL (e.g. `https://github.com/aDNA-Network/<repo>.git`) |
| branch-filter | string | no | (all) | branch glob; blank ⇒ `--mirror` (all branches + tags) |

## Implementation
1. **configure-mirror** — `gitops_configure_mirror "$origin_host" "$org" "$repo" "$target"` → `POST /api/v1/repos/{o}/{r}/push_mirrors` with `sync_on_commit:true`.
2. **Idempotency (ADR-004 D5):** there is **no in-place update** — to change a mirror, **delete then re-add** (`repoDeletePushMirror` → `repoAddPushMirror`). Treat as get-or-create.
3. **No tags-only toggle:** the filter is branch-glob only; blank = all branches + tags, force. A "release-only" mirror = a tag-discipline + branch-filter, not a switch.
4. **LFS:** if `lfs: true`, the mirror MUST use **HTTPS + PAT** (LFS does not mirror over SSH).
5. **Verify** propagation: push a tag to origin → confirm it appears on the target within the propagation budget.

> **Dry-run:** `GITOPS_DRY_RUN=1` prints the `push_mirrors` PLAN (no writes). Live = P5 (`GITOPS_ALLOW_LIVE=1`, operator-gated). GitHub-origin repos: see the `configure-mirror` note (use a sync Action, not a Forgejo push_mirror).

## Outputs
| Output | Type | Description |
|---|---|---|
| push-mirror | forgejo config | origin → target, sync-on-commit |
| verification | log | tag round-trip confirmed |

## Error Handling
| Error | Cause | Resolution |
|---|---|---|
| mirror-exists | get-or-create hit existing | delete + re-add to change (no in-place update) |
| lfs-over-ssh-fail | LFS repo using SSH mirror | switch to HTTPS+PAT (ADR-004 D5) |
| github-origin | tried push_mirror on GitHub origin | GitHub is a mirror *target* — use a sync Action (ADR-008) |

## Related
- [[spec_gitops_provider_abstraction]] · [[adr_004_provider_contract_interface]] · [[skill_vault_publish]] · [[adr_010_mesh_git_north_star]]
