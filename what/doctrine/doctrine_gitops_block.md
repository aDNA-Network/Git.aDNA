---
type: doctrine
doctrine_id: doctrine_gitops_block
title: "Git-Ops Doctrine Block (host-neutral; propagatable)"
status: draft
version: "0.1.0"
created: 2026-06-20
updated: 2026-06-20
last_edited_by: agent_stanley
binds_adrs: [adr_005, adr_006, adr_007, adr_008, adr_009, adr_011]
tags: [doctrine, git, doctrine_block, federation, draft, phase_3]
---

# Git-Ops Doctrine Block (host-neutral)

The **canonical, provider-neutral git-ops doctrine block** every aDNA code-home carries in its `CLAUDE.md` (ADR-009 D6). It replaces the seed §7 block (which baked in `harbor`/GitHub specifics + a self-hosted-canonical stance). Consumers inherit it via their `git/` wrapper (P3 authors; propagated fleet-wide in gated waves at P6; the canonical copy ships to `.adna/` via `aDNA.aDNA` at P4).

> **Usage:** paste the fenced block below into a code-home's `CLAUDE.md` under a `## Git-Ops` heading, then fill the graph's `git/` declaration ([[spec_gitops_provider_abstraction]] §3). The block is **host-neutral** — it reads the same whether the graph lives on GitHub, Codeberg, or a self-hosted Forgejo lighthouse.

```markdown
## Git-Ops (federates Git.aDNA via `git/`)

1. **Remotes** follow Git.aDNA ADR-006 — `origin` (canonical home) · `mirror` (outbound release/discovery) · `upstream` (external, never pushed) · `rollback` (temporary, during a host move). Host & visibility per the `git/` declaration (ADR-005: public/FOSS→Codeberg, private→GitHub-interim→self-hosted; **Codeberg is FOSS-only**).
2. **Local-first; HEAD is truth; commit after significant edits.** Read before write; never batch a phase into one mega-commit.
3. **Outward actions are gated** — creating remotes, pushing, cutting releases, configuring mirrors, and migrating hosts require operator confirmation. Never improvised.
4. **Credentials via the Home.aDNA broker; never inlined** — host→env-var (`GITHUB_TOKEN`/`CODEBERG_TOKEN`/`FORGEJO_TOKEN`); tokens never transit the conversation (ADR-007).
5. **CI is portable-first** — author workflows in `.github/workflows/` syntax (Forgejo falls back to it); add a `.forgejo/workflows/` variant only where a delta requires it (ADR-008).
6. **Cross-graph writes are staged as coord memos** — never silently write into another vault (workspace Rule 10).
7. **Secret hygiene** — `gitleaks` pre-push hook on every push; a **full-history scan is a hard gate before any host move** (ADR-011); a finding blocks the move until purged + the credential is rotated.
```

## Provenance & deltas from the seed §7 block
- `harbor` remote → generalized to **`rollback`** (ADR-006) — host-neutral.
- "no new internal repos on GitHub" / "git.aDNA canonical" → replaced by the **visibility-driven host policy** (ADR-005, Path B).
- Added **secret-hygiene** (item 7, ADR-011) and **CI portable-first** (item 5, ADR-008) — absent from the seed block.
