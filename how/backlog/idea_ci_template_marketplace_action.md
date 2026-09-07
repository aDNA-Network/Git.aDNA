---
type: idea
title: "F-P7b-at — the canonical CI template uses a marketplace action its own header forbids"
created: 2026-09-07
updated: 2026-09-07
status: open
last_edited_by: agent_stanley
raised_at: session_stanley_20260907_git_p7b_the_gate_that_cannot_read_its_own_instruments
relates: [f_p7b_at, adr_008_ci_cd_parity]
executor_tier: sonnet
tags: [idea, backlog, f_p7b_at, ci, template, self_contradiction]
---
# The template forbids, in its header, what it then does

**F-P7b-at**, carried since 2026-09-06, untouched.

The canonical CI template uses a **marketplace action that its own header forbids**. Both halves are in
one artifact, and neither reads the other.

⛩ Same shape as F-P7b-ay (the right predicate and the defective one adjacent in one file, unconnected)
and as the 4.2.0 drift paragraph that had to be rewritten because its own text said it must be. **A rule
stated in a comment beside code that breaks it is not a rule; it is a decoration.**

## Why it matters beyond tidiness

ADR-008 is CI/CD **parity** across GitHub and Forgejo. A marketplace action is **GitHub-specific by
construction** — so this is not only a self-contradiction, it is a **portability** defect in the vault
whose entire thesis is that git-ops must run on any host. Standing Order #4: a GitHub-only pattern is a
finding, not a default.

## Not yet measured

- Which template, which action, and whether the forbidding line is normative or aspirational.
- Whether the Forgejo counterpart (`.forgejo/`) has the same or a diverged shape.
- Whether any consumer vault has copied it.
