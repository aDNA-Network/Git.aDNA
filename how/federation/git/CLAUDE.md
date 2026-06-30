---
type: wrapper
wrapper: git
created: 2026-06-20
updated: 2026-06-21
status: draft
last_edited_by: agent_stanley
tags: [wrapper, git, federation, git_provider, dogfood, draft, phase_3]
---

# `git/` — Git.aDNA consumer wrapper (dogfood exemplar)

This is **Git.aDNA's own `git/` wrapper** — the dogfood instance (Git.aDNA is itself a code-home that gets a remote at P5) **and** the **reference exemplar** every other code-home copies. The wrapper mirrors the III `iii/` pattern (a Framework consumer-wrapper). Canonical schema: [[spec_gitops_provider_abstraction]] §7. Companion files in this dir: `hooks/pre-push.gitleaks.sh` (ADR-011 D2), `.gitleaks.toml` (scan config).

> **Source-vault note:** Git.aDNA *is* the standard, so its own wrapper carries `git_provider` only (no self-referential `federation_ref`). **Consumers** add the `federation_ref` block from the template below.

## Git.aDNA's own declaration (ADR-004 D4)

```yaml
git_provider:
  host: github.com            # public home (ADR-013 D3 — GitHub is the public home for released FOSS; reverses SD-1)
  backend: github             # derived from host
  org: aDNA-Network
  visibility: public
  class: P                    # public FOSS, P-released (open standard, like III) — GitHub-public home
  lfs: false
  remotes:
    origin: https://github.com/aDNA-Network/Git.aDNA.git   # set at the P5 dogfood (2026-06-20, ADR-013 D3)
    mirror:                   # n/a — GitHub IS the public home (no Codeberg mirror; ADR-013 D3)
    upstream:                 # n/a (no external upstream)
```

> **ADR-013 D3 (operator-ratified 2026-06-20, R1/P5) — reverses SD-1:** Git.aDNA's own repo is **public FOSS on `github.com`, class P (P-released)** — GitHub is its public home (the network effect for an open standard). This **reverses SD-1** (which had pinned it to Codeberg-public) under the [[adr_013_host_role_inversion|host-role inversion]] (**GitHub-public-home / Codeberg-private-FOSS-dev**). `origin` is set at the P5 dogfood (2026-06-20); the earlier genesis private/GitHub/class-I assumption and the interim SD-1 Codeberg pin are both retired.

Git-ops doctrine for this graph: see the [[doctrine_gitops_block|git-ops doctrine block]] (also inherited into `CLAUDE.md`).

## Consumer wrapper template (copy into `<vault>.aDNA/git/CLAUDE.md`)

A consuming code-home federates Git.aDNA by adding this `federation_ref` **plus** its own `git_provider` block:

```yaml
federation_ref:
  source_vault: Git.aDNA
  source_skill: how/skills/skill_git_provider_config.md   # entry skill
  version: "0.1.0"            # Git.aDNA release pinned at wrapper creation
  version_policy: minor       # minor (review on bump) | locked (manual)
  pinned_at_commit: "<sha>"
  binds_adrs: [adr_004, adr_006, adr_007, adr_008, adr_009, adr_011, adr_013]   # adr_013 = host policy (supersedes adr_005)
  verbs_exposed: [create-repo, set-remote, push, open-pr, cut-release, configure-mirror, port-ci]
  local_extensions: []        # optional: kind: doctrine_override | local_skill | hooks
git_provider:
  host: github.com            # or codeberg.org (FOSS) / git.<subnet>.adna.network (self-hosted)
  backend: github             # derived
  org: aDNA-Network
  visibility: private
  class: I                    # I | P | R | L (ADR-005 D2)
  lfs: false
  remotes: { origin: , mirror: , upstream: }
```

Then paste the [[doctrine_gitops_block|doctrine block]] into the consumer's `CLAUDE.md`, install `hooks/pre-push.gitleaks.sh`, and run [[skill_git_provider_config]] to validate. (Authored P3; the wrapper + skills ship to `.adna/` via `aDNA.aDNA` at P4.)
