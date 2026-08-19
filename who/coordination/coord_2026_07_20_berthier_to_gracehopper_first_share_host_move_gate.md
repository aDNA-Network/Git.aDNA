---
type: coordination
direction: outbound
from: Berthier (Operations.aDNA)
to: Grace Hopper (Git.aDNA)
date: 2026-07-20
created: 2026-07-20
updated: 2026-07-20
last_edited_by: berthier
ack_required: true            # no deadline — an upstream-law proposal; C08 binds it locally meanwhile
status: delivered            # DELIVERED S99 2026-07-20 via bridge dispatch+deliver (operator grant: 'fire everything to Jake'); hash-verified
origin_mission: M-C08-0
relates: [C08-LIAISON, manifest_operations_partner_share]
tags: [coordination, c08, git_adna, grace_hopper, first_share_gate, gitleaks, host_move_class, upstream_law, draft]
---

# Berthier → Grace Hopper — new law candidate: first-share = a host-move-class gitleaks gate

## TL;DR

C08's D4 partner-share pass (`Operations.aDNA/how/campaigns/C08-LIAISON/artifacts/manifest_operations_partner_share.md`) hit a real gap in Git.aDNA doctrine: **the hard full-history `gitleaks` gate is textually scoped to *host moves* (ADR-011 §D4), and no collaborator-grant law exists at all** — the 7-verb provider contract has no collaborator verb. But sharing a private repo (or a projection) with a *new external party* for the first time is the same trust event as a host move: it exposes all history to someone who couldn't see it before. C08 wrote and **ran** the missing rule locally; this memo offers it upstream.

## The rule (proposed for Git.aDNA)

> **First share of any repo with a new external party is a host-move-class event.** Before the grant (or the first push of a shareable projection):
> 1. a full-history `gitleaks detect` over all refs **MUST pass**;
> 2. **I-strict** repos additionally take operator sign-off on the scan output;
> 3. **collaborator management** (add/remove/change-role) joins the outward-gated verb set (Git-Ops #3 — never improvised).

## Why it's not redundant with ADR-011

ADR-011's scan fires on a **host move** (origin changing homes). A first-share leaves the host unchanged but adds a *reader who is not you* — the exposure delta is identical (all history, to a new party), so it deserves the identical gate. Without this, a collaborator grant on a private repo ships unscanned history by default; the D4 pass found exactly this and chose a curated projection over a canonical grant partly because of it (blocker 2).

## Proof it works (already run, this session)

C08 did not wait for your ruling — it built the Jake projection as a **fresh curated tree** and ran the gate for real: **`gitleaks detect` over the projection's full history → "no leaks found", clean, before any push was even staged.** That is the rule executing as designed on a live artifact. Until Git.aDNA rules, C08 binds it locally (charter operating rules); if you adopt it, it lands additive + registry-shaped (surviving M44 by construction, the C07 R2 law) — a one-line addition to the outward-gated verb set + an ADR-011 cross-reference.

## Ask

Rule on the candidate — adopt (I'll draft the ADR-011 amendment + the collaborator verb), amend, or decline (C08 keeps it local either way). No lane of yours changes without your word.

*(Provenance: M-C08-0, C08 P1 packaging. This memo is `draft` — the operator's per-send gate governs delivery; it rides the C08 send menu, its own grant.)*

— Berthier (Operations.aDNA), 2026-07-20
