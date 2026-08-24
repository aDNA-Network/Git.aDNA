---
type: directory_index
created: 2026-02-17
updated: 2026-08-23
last_edited_by: agent_stanley
tags: [directory_index, sessions, both_ends_sweep, f_intake_04, f_p7b_i]
---

# Session Protocol

## Purpose

Every agent session creates a tracking file before modifying project files. Sessions provide audit trail, conflict detection, and handoff continuity across multiple users and machines.

## Directory Structure

```
how/sessions/
├── AGENTS.md                  # This file (session protocol)
├── active/                    # One file per running session
│   └── session_{user}_{YYYYMMDD}_{HHMMSS}_{descriptor}.md
└── history/
    └── YYYY-MM/               # Completed sessions bucketed by month
        └── session_{user}_{YYYYMMDD}_{HHMMSS}_{descriptor}.md
```

## Two-Tier System

### Tier 1 — Lightweight (default for all sessions)

Every agent session MUST create a session file before modifying project files.

**On start:**
1. Generate session ID: `session_{user}_{YYYYMMDD}_{HHMMSS}_{descriptor}`
2. Create session file in `how/sessions/active/` with minimal frontmatter

**During work:**
3. Follow collision prevention rules (read-before-write, check `updated`, set `last_edited_by`)
4. Append file paths to `files_modified` / `files_created` as work happens

**On end:**
5. Write SITREP + Next Session Prompt
6. Set `status: completed` and `completed: {ISO_TIMESTAMP}`
7. Move file from `sessions/active/` to `sessions/history/YYYY-MM/`

### Tier 2 — Full (opt-in for shared config edits)

Use Tier 2 **only when** editing shared configs (governance files, plugin configs) or performing project-wide bulk operations.

Adds to Tier 1:
- **Scope declaration**: List directories and files the session will touch in frontmatter
- **Conflict scan**: Before starting, scan `how/sessions/active/` for overlapping scopes
- **Heartbeat**: Update `heartbeat` field every ~10 minutes
- **Stale detection**: Sessions with heartbeat >30 min old are considered potentially stale; >8 hours auto-abandoned

When scope overlap is detected, warn the user before proceeding.

## The both-ends sweep (F-INTAKE-04 · F-P7b-i) — binding on every session

**A clean sweep at open is not a clean sweep at close.** This applies to *every* fact read out of
another vault — **inbound mail and peer leases alike**. Both are the same kind of thing: another
vault's state, read once, acted on later. For a long time only one of them was guarded.

| | |
|---|---|
| **At open** | Sweep untracked inbound (`git ls-files --others --exclude-standard who/coordination/`) **and** peer leases. Record both in frontmatter. |
| **In the frontmatter** | The open-end reading is written as **provisional**, never as a measurement. `leases_at_open: 0` is a claim with a hidden expiry. |
| **At the act** | Re-probe **in the same command as the act**. Use `how/tests/probe_peer_state.sh --exec` — it runs the command only on a GO, which makes "probe at the moment" a property of the tool rather than a discipline someone has to remember. |
| **Before the closing commit** | Re-sweep both. Every inbound found at the close end is dispositioned **by name** before the commit. |

⭐ **A number a gate's authorization rests on is measured at the moment it is relied upon, or it is
not a measurement.** F-INTAKE-04 has fired five consecutive times and been load-bearing twice —
once catching an operator signature that arrived mid-authoring on the very clause being written.
F-P7b-i is the same rule for leases: a sitting recorded `leases_at_open: 0`, took an authorization
against it, and found at the act that both target peers had taken leases in the interval.

⚠ **The rule cuts both ways, and the benign direction is not the safe one.** On 2026-08-23 the probe
read a peer as **clear** where the open sweep had read it **active** — the lease had closed mid-sitting.
A stale reading that happens to be permissive is still stale; what changed is only whether anyone
would have noticed.

⛔ **A lease that merely exists is not a refusal.** The predicate is whether a live lease *declares*
the directory being written — read from its `declared_files:` block or its `Files declared` row, and
**never** by grepping the lease body. Leases are full of paths in prose; grepping one refuses correct
sends for a string in a comment. That failure mode has cost this vault twice this month.

## Session File Format

### Tier 1 (minimum)

```yaml
---
type: session
session_id: session_{user}_{YYYYMMDD}_{HHMMSS}_{descriptor}
user: {username}
started: {ISO_TIMESTAMP}
status: active
intent: "Brief description of what this session will do"
files_modified: []
files_created: []
completed:
---

## Activity Log

- HH:MM — Session started
```

### Tier 2 (adds scope + heartbeat)

```yaml
---
session_id: session_{user}_{YYYYMMDD}_{HHMMSS}_{descriptor}
user: {username}
machine: {machine_name}
started: {ISO_TIMESTAMP}
status: active
tier: 2
intent: "Editing CLAUDE.md and shared config"
scope:
  directories:
    - {dir1}
  files:
    - {file1}
heartbeat: {ISO_TIMESTAMP}
files_modified: []
files_created: []
completed:
---

## Activity Log

- HH:MM — Session started
```

## History & Archiving

- Completed sessions move to `how/sessions/history/YYYY-MM/`
- No auto-deletion — files are ~1 KB each, accumulation is negligible
- History enables: audit trails, pattern detection, debugging, session analytics
- Manual cleanup of folders older than 6 months if desired

## Session Closure (SITREP)

Every session ends with a structured status report:

```markdown
## SITREP

**Completed**: [what was finished]
**In progress**: [what was started but not finished, with handoff notes]
**Next up**: [recommended next actions]
**Blockers**: [anything preventing progress]
**Files touched**: [created, modified, moved]
```

## Next-Session Prompt

Every session MUST include a next-session prompt after the SITREP:

```markdown
## Next Session Prompt

[Self-contained paragraph that a fresh agent can read to continue this work.
Include: what was accomplished, what remains, key context, recommended approach.]
```

The next-session prompt ensures continuity. A fresh agent reading this prompt and STATE.md should be able to continue the work without reading the full session history.

Template: `how/templates/template_session.md`

## Load/Skip Decision

**Load this directory when**:
- Creating a new session file at the start of agent work (startup checklist step 9)
- Checking `how/sessions/active/` for conflicting sessions (startup checklist step 4)
- Debugging session protocol issues — stale sessions, missing SITREPs, broken handoffs
- Closing a session — writing SITREP and moving file to history

**Skip when**:
- Mid-session and not creating, checking, or closing sessions
- Reading session history for analytics (scan `history/` directly)
- Already created the session file and remember the Tier 1/Tier 2 rules

**Token cost**: ~1,100 tokens (this AGENTS.md)
