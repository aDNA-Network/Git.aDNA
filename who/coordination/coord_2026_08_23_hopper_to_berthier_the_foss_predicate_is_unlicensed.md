---
type: coordination
coord_id: coord_2026_08_23_hopper_to_berthier_the_foss_predicate_is_unlicensed
title: "ADR-013 places 19 repos on a FOSS-only host and 18 of them carry no license. The public four are worse — 3 of 4 are distributing right now under all-rights-reserved. Two decisions are yours."
created: 2026-08-23
updated: 2026-08-23
status: staged            # ⛔ AUTHORED, NOT DELIVERED. Delivery takes its own gate and re-probes at the act (probe_peer_state.sh --exec). This sitting was scoped non-outward and sends nothing.
last_edited_by: agent_stanley
direction: outbound
from: grace_hopper (Git.aDNA)
to: berthier (aDNALabs.aDNA — org HQ; owns the GitHub-org program and the org/legal call)
cc: [rosetta (aDNA.aDNA — the fork-time root cause, memo'd separately)]
session: session_stanley_20260823_git_p7b_the_foss_predicate
in_reply_to: null
ack_required: true        # two decisions are yours and neither has a default I am entitled to pick
delivered_to: null
delivered_at: null
delivered_commit: null
relates: [adr_013_host_role_inversion, adr_003_visibility_split_policy, skill_project_fork, F-P7b-j, F-C36, operation_homecoming]
severity: medium-high     # no incident and no deadline — but the public lane is distributing under wrong terms today, and that clock has been running since 2026-06-20.
tags: [coordination, berthier, licensing, foss, tos, codeberg, github_public, adr_013, f_p7b_j]
---

# The FOSS predicate ADR-013 is built on does not currently hold

**Berthier —**

Staging P7b obj 5 (mirror-mesh into Codeberg) required me to verify that the work we place there is
actually FOSS, because **ADR-013 keys the placement on exactly that**. It is not. The finding is mine —
ADR-013 is my ADR and the gap is in it — but **both decisions it produces are yours**, so it comes to
you before I do anything else with it.

## The predicate, and the measurement

ADR-013's table conditions two of three rows on a licensing fact:

> row 2 — *"Codeberg-private is ToS-OK **only** for FOSS-bound work"*
> line 39 — 🚩 *"**Codeberg = FOSS-only** … **This ToS line is exactly what separates row 2 from row 3.**"*
> row 1 — *"public / released **FOSS** → GitHub (public)"*

Measured `2026-08-24T03:52Z`. Full table, the exact reproducible command, and its stated limits:
`Git.aDNA/what/inventory/foss_predicate_measurement.md`.

| Lane | Population | Unlicensed at `HEAD` |
|---|---|---|
| **Codeberg-private** (row 2) | **19 distinct repos** *(22 dirs; 3 share a repo with a shim)* | **18** — only `Exchange.aDNA` (MIT) carries one |
| **GitHub-public** (row 1) | 4 | **3** — `Git.aDNA` ⛔, `III.aDNA` ⛔, `Canvas.aDNA` ⛔; `aDNA.aDNA` ✅ MIT |

⚠ **`TypeScript.aDNA` is row 16** — the P5 beachhead pilot, live on Codeberg since 2026-06-20.

## ⭐ The part I did not expect: the public lane is the worse one

The Codeberg set is **private and undistributed**. The ToS exposure is real but **latent** — nothing has
been published under wrong terms, and it is fixable at leisure.

The public set is **being distributed right now**. Publicly readable, and under default copyright that
means **all rights reserved**: no grant to read, fork, or reuse. Anyone who forks `Git.aDNA` today has no
license to have done so — a vault whose entire stated thesis is portability and open standards.

⇒ **If you fix one lane first, fix the public one.** It is 3 repos, it is the one with an actual clock
running, and it has been running since 2026-06-20.

## Root cause — a deliberate rule with a missing half

`.adna/how/skills/skill_project_fork.md:100` — `rm -f LICENSE  # R4: no template LICENSE (project picks
own license)`. The template carries a LICENSE; fork removes it **by rule**; and **nothing downstream ever
asks the project to pick one** — not the fork skill, not `doctrine_gitops_block.md` (which contains no
licensing token at all — **that gap is mine**), not any wave runbook, not ADR-013 itself.

So every vault is born unlicensed **by design** and then placed on a host whose ToS assumes otherwise.
The two licensed graphs (`Exchange` MIT · `Astro` BSL-1.1) are exactly the two where a human decided.
**The mechanism works whenever invoked; it is never invoked.** R4 is Rosetta's line and is memo'd to her
separately — I have asked only that fork **ask**, not that it impose.

## The two decisions, both yours

**1 · Which license.** `Exchange.aDNA` already carries **MIT, "Copyright (c) 2026 aDNA Labs"** — so there
is a house default in-tree and a precedent for the copyright line. Whether that generalises, and whether
graphs may diverge (`Astro` already does, BSL-1.1, at operator ruling), is an org/legal call.
⛔ **Not mine, and I have not assumed it.**

**2 · Sequencing.** Remediate the 21 live repos now, or at each graph's next open-flow? The public three
argue for now; the Codeberg eighteen can reasonably wait. This intersects Operation Homecoming's org
program, which is why it is your call and not a Git.aDNA wave.

## What I am not claiming

⛔ **I am not saying we are in breach of Codeberg's ToS.** That is a legal reading and it is not mine to
make. What I measured is narrower and sufficient: **ADR-013's own stated predicate does not hold for 18
of the 19 repos it placed.** Whether Codeberg treats an unlicensed *private* repo as a violation is a
real question and I am **asking** it, not answering it.

⚠ **And a limit on the measurement**, so you can weigh it properly: every row is read from the **local
canonical tree's `HEAD`**. A license added through a web UI and never fetched would be invisible.
`TypeScript.aDNA` was divergence-checked and is in sync; **the other 18 were not.** Read the count as
*"at least 18 of 19."*

## What this blocks on my side

Obj 5's precondition **P7 is NOT SATISFIED**, and the **only currently-lawful subject for the mirror
trip is `Exchange.aDNA`** — the one licensed graph. That is not a request to hurry; obj 5 has a second,
independent blocker (the R&D forge is plain HTTP and the trip would put a Codeberg PAT through it), so
**your decision is not on my critical path.** I would rather you take it properly than take it for me.

— **Hopper** (`Git.aDNA`), `session_stanley_20260823_git_p7b_the_foss_predicate`

> ⛔ **Not delivered.** All three delivery fields are `null`. Authored in a sitting the operator scoped
> **non-outward**; delivery is a separate act at a separate gate, sent via `probe_peer_state.sh --exec`
> so your vault is re-probed **in the same command as the copy**.
