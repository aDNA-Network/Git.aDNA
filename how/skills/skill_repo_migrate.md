---
type: skill
skill_type: agent
created: 2026-06-20
updated: 2026-06-20
status: draft
category: operations
trigger: "Move a code-home's canonical home between hosts (e.g. GitHub-interim → self-hosted Forgejo)"
last_edited_by: agent_stanley
tags: [skill, git, migration, host_move, secret_scan, rollback, draft]
requirements:
  tools: [git, "git-lfs (if lfs:true)", gitleaks, "git-filter-repo (remediation)", how/skills/lib/gitops_dispatch.sh]
  context: [what/specs/spec_gitops_provider_abstraction.md, "ADR-006 D3 sequence; ADR-011 D4 gate"]
  permissions: ["OUTWARD + history-touching — operator-gated (P6/post-P7); I-strict needs operator sign-off"]
---

# Skill: Repo Migrate (host move, scan-gated)

## Overview
Moves a graph's `origin` to a new host, **rollback-preserving** (ADR-006 D3) and **gated on a full-history secret scan** (ADR-011 D4). The core of P6 fleet alignment + the post-P7 private→self-hosted waves. Heavily gated; **dry-run only until its wave is authorized**.

## Trigger
`/repo-migrate --to-host <h> [--org <o>] [--keep-rollback-days 30]`

## Parameters
| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| to-host | string | yes | — | new canonical host |
| org | string | no | current | new org if changing |
| keep-rollback-days | int | no | 30 | rollback-window before `rollback` remote removal |

## Implementation (ADR-006 D3 order)
0. **🚦 PRE-MOVE SECRET-SCAN GATE (ADR-011 D4, binding):** run `gitleaks detect` over **full history**. **I-strict** client repos (CakeHealth/PercySleep/SuperLeague/CakeProtocol/MagnaPetra) require **operator sign-off** on the result. **A finding blocks the move** — remediate (`git-filter-repo` → rotate credential via Home → re-scan) before proceeding.
1. **LFS** — if `lfs: true`, `git lfs fetch --all` first (ADR-004 D5).
2. `git remote rename origin rollback` — preserve the old home.
3. **set-remote** — `gitops_set_remote "$to_host" "$org" "$repo" origin`.
4. **push** — `gitops_push <integration-branch>` (`--all --tags`); verify.
5. **Register** the re-point in the Home.aDNA shim registry (ADR-006 D4): class · window · retire-condition · owner.
6. **Window close** — after `keep-rollback-days` **and** a verified sweep, `git remote remove rollback`.

**Rollback** (any time before close): re-point `origin` to `rollback`'s URL.

> **Dry-run:** `GITOPS_DRY_RUN=1` prints the full plan incl. the scan-gate step (no writes). Live = its authorized P6/post-P7 wave only (`GITOPS_ALLOW_LIVE=1` + operator gate).

## Outputs
| Output | Type | Description |
|---|---|---|
| migrated `origin` | git remote | new canonical home |
| `rollback` remote | git remote (temp) | revert path until window close |
| shim entry | registry record | Home.aDNA ledger |

## Error Handling
| Error | Cause | Resolution |
|---|---|---|
| scan-finding | secret in history | **blocked** — purge + rotate (ADR-011 D5); never bypass |
| lfs-missing-objects | LFS not fetched | `git lfs fetch --all` before push; HTTPS+PAT for LFS mirrors |
| push-rejected | new host policy / protected branch | reconcile; check branch protection (ADR-009 D3) |

## Related
- [[spec_gitops_provider_abstraction]] · [[adr_006_remote_naming]] · [[adr_011_secret_scanning]] · [[skill_release_mirror]]
