---
type: session
created: 2026-06-23
updated: 2026-06-23
status: active
last_edited_by: agent_stanley
persona: hopper
tags: [session, git, hygiene, fleet_sync, provider_agnostic, operation_free_harbor]
---

# Session — Fleet Git-Hygiene Pass (Review + Sync to Current Remotes)

> **Operator ask:** "review our git ops / patterns for this graph and all our graphs … make sure we are pushing our graphs to github until we are ready to fully cut over … `/aDNA/`-wide review of current practices and make sure our gits are up to date for our core development graphs."
>
> **Not a campaign wave.** Hygiene pass: review current practices + sync committed-but-unpushed work to each graph's **existing remote** (no host moves, no `git/` wrapper installs — that's the gated Wave 3 touch). Resume-Here unchanged = **R2/P6**. Plan: `~/.claude/plans/please-read-the-claude-md-virtual-quasar.md`.

## Decisions (operator, AskUserQuestion)
- **Host:** sync each graph to its **current remote** (GitHub→GitHub; the 10 Codeberg graphs stay on Codeberg). No host moves. (Reconciles the "cut over" phrasing with ADR-013's *permanent split*.)
- **Scope:** core dev graphs with pending state.
- **Uncommitted:** commit only obvious self-owned housekeeping; HOLD large / live-session trees.

## Practices review (current state)
**Healthy:** provider-agnostic tooling (`how/skills/lib/gitops_dispatch.sh`, 7-verb contract + `gitops_set_visibility`); `git/` consumer-wrapper + `federation_ref`; `gitleaks` pre-push hook + per-graph allowlists; 7-item Git-Ops doctrine block; CI parity templates. Findings F1/F2/F-Astro/F-W3-a/-c logged + folded.
**Gaps this pass addresses:** the actively-developed GitHub majority had drifted **behind its remotes** (backup risk); the `git/` hook is only on the ~12 Wave-1/2/3a graphs, so non-touched graphs need a manual `gitleaks` scan before push (substituted here).
**gitleaks gate:** `( cd <g> && gitleaks git --log-opts="@{u}..HEAD" [-c $PWD/git/.gitleaks.toml | $PWD/.gitleaks.toml] --no-banner --redact . )` — abs config path required; RC=1 ⇒ HOLD.

## Per-graph ledger
*(filled during execution)*

| Graph | Host | Before (dirty/ahead) | Scan | Committed | Pushed | After | Note |
|---|---|---|---|---|---|---|---|

## AAR
*(filled at close)*
