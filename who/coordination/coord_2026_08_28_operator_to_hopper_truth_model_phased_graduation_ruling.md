---
type: coordination
from: operator (stanley, in-chat AskUserQuestion ruling; authored by the fable session executing the rd-forge source-of-truth plan)
to: hopper (Git.aDNA)
cc: berthier (aDNALabs.aDNA), ilmarinen (Forgejo.aDNA), berthier (Operations.aDNA)
date: 2026-08-28
status: ruling_on_record — ADR-014 amendment authoring is Hopper's lane
---

# Operator ruling: rd-forge truth model = phased replica-first with named graduation triggers

## The ruling (operator, 2026-08-28, in-chat)

Asked directly how "Forgejo as core source of truth" reconciles with ADR-014's
replica semantics, the operator chose **phased replica-first**:

1. **The rd-forge remains the always-fresh team hub under ADR-014 replica
   semantics** — `mesh-rd` non-canonical, keep-fresh push-based
   (Operations-scheduled), PR-return the only re-entry path.
2. **A graph graduates to forge-as-origin only when a named trigger fires:**
   - **T1 — multi-writer:** a second regular writer needs merge authority on the
     graph (replicas whose canonical is the operator's working clone make the
     operator the merge SPOF).
   - **T2 — build-home need:** the graph's CI must run on the forge (a replica is
     never a build home — Ilmarinen's CI_BRICK ruling — so build-home need forces
     graduation).
3. Each graduation runs the full ADR-006 D3 host-move ceremony and mints the
   A2 §1 **off-forge replica obligation** (never single-homed on the forge).
   Batch graduation is rejected.

Explicitly rejected alternatives: graduate-core-graphs-now; replica-only-forever.

## What this means for Hopper's lane

- ADR-014 needs no structural change — this ruling *names the triggers* that fire
  its existing D4 graduation path. If you want it formal, author a small A6
  ("graduation triggers T1/T2") and route it for §7.7 ratification; the operator
  ruling above is the basis.
- First graduation candidates on record: **Inference.aDNA** (regularization — it is
  mesh-rd-only today, so its "replica" has no off-forge canonical; graduating it
  and minting a GitHub-private off-forge replica per ADR-013 fixes an existing
  A2 §1 exposure), then whichever graph first fires T1 in team co-development.

## Ratification block (§7.7 shape)

- decision: phased replica-first truth model + graduation triggers T1/T2
- ratified-by: stanley (operator, in-chat AskUserQuestion)
- date: 2026-08-28
- status: accepted as operating model; ADR-014 A6 formalization = Hopper's lane

## Context

Executed as part of the operator-approved rd-forge source-of-truth plan
(`~/.claude/plans/please-review-our-recent-velvet-honey.md`): declaration sweep
(all `pending_declaration` rows flipped, LAVG converted to `state=graduated` per
A2 §2), Wave-1 enrollment of 13 graphs, read-first team accounts, runner
isolation rework staged ahead of any write grants (F-C10).
