---
type: skill
skill_type: agent
created: 2026-06-20
updated: 2026-06-22
status: draft
category: setup
trigger: "Create or edit a code-home's git/ provider declaration; or set the default at fork-time"
last_edited_by: agent_stanley
tags: [skill, git, provider_config, git_wrapper, fork_hook, draft]
requirements:
  tools: [git, "yaml-aware editor", how/skills/lib/gitops_dispatch.sh]
  context: [what/specs/spec_gitops_provider_abstraction.md, "ADR-004 D4 schema; ADR-005 D5 defaults"]
  permissions: ["writes the consumer's git/ wrapper (local file); no outward action"]
---

# Skill: Git Provider Config

## Overview
Creates/edits a code-home's **`git/` wrapper** — the `federation_ref` block + the `git_provider` declaration ([[spec_gitops_provider_abstraction]] §3, §7) that every other git-ops skill reads. Also the **new-graph fork-hook**: at fork-time it sets the visibility-appropriate default ([[adr_005_visibility_host_policy|ADR-005]] D5). No outward action — it only writes local declaration files.

## Trigger
`/git-provider-config [--host <h>] [--visibility private|public] [--class I|P|R|L] [--org <o>]` — or auto-invoked by `skill_project_fork` (the fork-hook).

## Parameters
| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| host | string | no | derived | overrides the visibility-default host |
| visibility | enum | at fork | — | `private`\|`public` |
| class | enum | no | derived | `I`\|`P`\|`R`\|`L` (ADR-005 D2) |
| org | string | no | `aDNA-Network` | owning org |

## Implementation
1. **Default by persona + visibility (fork-hook):** **if this node operates an L1 lighthouse subnet → `host=git.<subnet>.adna.network, backend=forgejo`** (the subnet's own forge — [[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]]); else by visibility (ADR-005 D5): `public/FOSS → host=codeberg.org, class=P` (+ optional GitHub discovery mirror); `private → host=github.com (interim), class=I`; never-push → `class=L` (no remote). Operator may override (host-choice preserved).
2. **Derive** `backend = gitops_backend_for_host $host`.
3. **Write** `<vault>.aDNA/how/federation/git/CLAUDE.md` with the `federation_ref` block (source_vault `Git.aDNA`, pinned version, `binds_adrs`, `verbs_exposed`) + the `git_provider` block (host/backend/org/visibility/class/lfs/remotes). Mirror the `iii/` wrapper layout (consumer wrappers live under `how/federation/` per **ADR-045** in `aDNA.aDNA`).
4. **Doctrine** — ensure the consumer's CLAUDE.md carries the [[doctrine_gitops_block|git-ops doctrine block]] (paste once).
5. **Install the secret-scan hook (ADR-011 D2) — `core.hooksPath`-aware:** copy `how/federation/git/hooks/pre-push.gitleaks.sh` into `<vault>.aDNA/how/federation/git/hooks/`, then wire it as the repo's `pre-push`. **First read `git config --get core.hooksPath`** and branch — a blind `.git/hooks/pre-push` symlink is **not** always honored:
   - **Stale absolute path** that doesn't resolve into the repo (F-Astro — a pre-Homecoming `~/lattice/…` path) → `git config --unset core.hooksPath`, then symlink `.git/hooks/`.
   - **Set to an in-repo relative dir** (F-W3-c — e.g. ScienceStanley's `how/governance/hooks`) → **place/chain at that dir** (`<hooksPath>/pre-push` → `how/federation/git/hooks/pre-push.gitleaks.sh`), **not** `.git/hooks/` — git reads hooks only from the configured dir, so the standard symlink **silently no-ops**. If a `pre-push` already exists there, **chain** (run the existing hook, then the gitleaks scan).
   - **Unset** (the common case) → symlink `.git/hooks/pre-push → ../../how/federation/git/hooks/pre-push.gitleaks.sh`.
   - Config resolves `$GITLEAKS_CONFIG → <repo>/how/federation/git/.gitleaks.toml → <repo>/.gitleaks.toml → default`. A graph that **self-manages a mature root `.gitleaks.toml`** keeps it — do **not** stage a shadowing `how/federation/git/.gitleaks.toml` (F-W3-a); the hook falls through to root. **Dogfood-verify the hook actually fires** (`pre-push: gitleaks clean ✓`) — never assume install-by-file-presence (the F-W3-c lesson).
6. **Validate** — schema-check the YAML; assert visibility legal for host (ADR-013 host-role inversion; supersedes ADR-005); `remotes.origin` may be blank until `skill_git_remote_setup` runs.

## Outputs
| Output | Type | Description |
|---|---|---|
| `how/federation/git/CLAUDE.md` | wrapper | the consumer's federation_ref + git_provider declaration |
| doctrine block | CLAUDE.md edit | inherited git-ops doctrine (idempotent) |

## Error Handling
| Error | Cause | Resolution |
|---|---|---|
| illegal-visibility-host | private + Codeberg | switch to GitHub-interim / self-hosted (ADR-005) |
| schema-invalid | malformed `git_provider` | fix against [[spec_gitops_provider_abstraction]] §3 |

## Related
- [[spec_gitops_provider_abstraction]] · [[skill_git_remote_setup]] · [[doctrine_gitops_block]] · III `iii/` wrapper (pattern)
