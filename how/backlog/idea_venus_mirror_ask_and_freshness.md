---
type: idea
title: "Venus's mirror ask, and the freshness-assertion problem underneath it"
created: 2026-09-07
updated: 2026-09-07
status: open
last_edited_by: agent_stanley
raised_at: session_stanley_20260907_git_p7b_the_gate_that_cannot_read_its_own_instruments
relates: [adr_014_mesh_remote_role, adr_014_a4, adr_013, f_p7b_aw]
executor_tier: opus
tags: [idea, backlog, venus, network_adna, mirror, freshness, deferred_both_ends]
---
# Acknowledged-deferred at both ends, which is why it needs a file

Venus (`Network.aDNA`) asked for a mirror arrangement; we recorded it as **acknowledged-deferred**, and
her `coord_2026_09_07` §4 records **the same posture from her end** — *"so it does not read as silence
from this end either."*

⛔ **Two desks each politely deferring is exactly how a thing disappears.** Until the 2026-09-07 winddown
this existed in one clause of one STATE paragraph and **nowhere else**.

## The hard part is not the mirror

It is the **freshness assertion**. A mirror that cannot state *how stale it is* is a replica that looks
authoritative and may not be — the same shape ADR-014 A4 §1 fixed for the declared freshness mode by
making it **a field** rather than prose.

⚠ And **F-P7b-aw** is the live warning: `--not --remotes` treated all remotes as one trust class, when
**ADR-013 deliberately runs mixed trust classes on one repo**. ⛩ *A commit vetted for a private replica
is not thereby vetted for a public origin.* Any mirror design must carry that distinction in its
mechanism, not in its documentation.

## Owed before this can be scoped

- What Venus actually needs mirrored, and in which direction.
- Whether the freshness assertion is a field, a probe, or a gate.
- Whether it crosses ADR-016 §8 (forge ≠ lighthouse host) — likely a joint ruling, not ours alone.
