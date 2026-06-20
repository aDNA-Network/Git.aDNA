---
plan_id: p1_research_fleet_inventory
type: plan
title: "P1 — Research & Fleet Git-State Inventory"
owner: stanley
status: completed
campaign_id: campaign_git_genesis
campaign_phase: 1
campaign_mission_number: 1
mission_class: reconnaissance
created: 2026-06-19
updated: 2026-06-19
last_edited_by: agent_stanley
tags: [plan, campaign, git, genesis, reconnaissance, operation_free_harbor]
---

# Mission: P1 — Research & Fleet Git-State Inventory

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 1 — Research & Fleet Git-State Inventory · **Mission**: 1 of 8

## Goal
Produce the two inputs P2 binds against: (a) a **state-of-the-art survey** of multi-provider git tooling, and (b) a **complete inventory** of the fleet's current git state. No architecture yet — gather ground truth.

## Exit Gate
`what/inventory/fleet_git_state.md` complete (every `.aDNA` graph **and** code-as-WHAT nested repo: host · org · visibility · class · LFS · CI · live consumers); provider-tooling SOTA filed in `what/context/`; draft provider/visibility classification per graph staged for the operator's P2-entry review; coexistence map vs `aDNALabs.aDNA`'s GitHub `aDNA-Network` population.

## Objectives (sketch — expand when phase opens)
1. **Provider-tooling SOTA** — Forgejo/Gitea REST + `tea` CLI (vs raw REST / `berg` / git-remote-helpers); `gh`; **ForgeFed** federation; Forgejo push-mirror; sops/age; LFS + package-registry + Actions parity GitHub↔Forgejo. Paraphrase, cite (SO#11). → `what/context/`.
2. **Fleet `git remote -v` walk** — every graph + nested code repo; capture host/org/visibility/class/LFS/CI/consumers. → `what/inventory/fleet_git_state.md` (feeds a future `repos` Base).
3. **Seed-REQ triage** — which of the 56 `requirements_forge_seed.md` REQs are in-scope for Git.aDNA vs the deferred Lighthouse deployable.
4. **Draft classification** — propose Codeberg-private / GitHub-public / Class-R per graph (operator ratifies at P2 entry).
5. **Homecoming coexistence** — map which repos `aDNALabs.aDNA` already placed on GitHub `aDNA-Network`; flag any collision risk for ADR-003 D5.

## Campaign Context
- **Prev (M0)**: ratified ADRs + the `STATE.md` "live git landscape" table (seed for objective 2).
- **Next (M2)**: the inventory + SOTA become the evidence base for the binding architecture ADRs.

## Completion Summary (2026-06-19)

### Deliverables
- `what/inventory/fleet_git_state.md` — fleet ledger (44 graphs + 25 nested repos + edge cases; **visibility resolved** via `gh repo list`; draft classification embedded).
- `what/context/context_provider_tooling_sota.md` — Forgejo/`tea`/ForgeFed SOTA (verbs verified vs the live OpenAPI spec); **tool-of-record = raw Forgejo REST API**.
- `what/requirements/req_triage_inscope.md` — 14-domain seed-REQ triage (IN: FRG·MIG·GOV·AGT·SEC·DOC; DEFER: the node-stack).
- Homecoming coexistence map (appended to the aDNALabs coord memo) — clean/complementary.

### Key findings → P2-entry gate
1. 🚨 **Codeberg ToS blocks private proprietary repos** — *amends* [[adr_003_visibility_split_policy]]; corrected model = Codeberg(FOSS) / self-hosted-Forgejo(private — north star pulled forward) / GitHub(interim-private + public).
2. Fleet is **~95% PRIVATE** on GitHub (only the template is public) — the intended-public OSS set must be *flipped* public.
3. **Name-drift** (~14 origins ≠ dirname) + **cross-org stragglers** (3 already aDNALabs's tracked item) → migration ledger.
4. **ForgeFed experimental** (federated stars only) → near-term mesh = mirroring + REST, not federation.

## AAR

- **Worked**: `gh repo list` resolved fleet-wide visibility in 3 calls; the recon sweep + this pass produced an authoritative ledger fast; the SOTA verified verb coverage against the live OpenAPI spec.
- **Didn't**: The **Codeberg ToS blocker** invalidates the approved ADR-003 "private→Codeberg" default — a load-bearing surprise that needs an operator amendment before P5/P6.
- **Finding**: Codeberg-is-FOSS-only is *clarifying* — it makes the **self-hosted-Forgejo north star the private-home answer** (pulled forward), and the identical `/api/v1` surface means one abstraction serves Codeberg + self-hosted unchanged.
- **Change**: Make **provider-ToS constraints** a standing P1-research item for any future provider (never assume a host accepts our content shape/scale).
- **Follow-up**: Operator **P2-entry gate** — amend ADR-003 (private-home path) · ratify the classification table · confirm the intended-public set.
