---
type: finding
finding_id: F-P7b-az
status: closed
class: unanchored_predicate
opened: 2026-09-07
closed: 2026-09-07
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, unanchored_predicate, f_p7b_az]
---

# F-P7b-az — unanchored predicate

## Shape

The frontmatter `awk` was unanchored — a `---` ANYWHERE counted as an opening fence. The `*.md` test had been masking it, so removing that test alone would have traded a fail-OPEN for a false-POSITIVE. Measured: 1 phantom (vendored minified .js) vs 8 genuine (`.base/*.template`).

## Status

Closed at 4.3.0 by banner-tolerant anchoring. Found only because the fix for F-P7b-ay exposed it.
