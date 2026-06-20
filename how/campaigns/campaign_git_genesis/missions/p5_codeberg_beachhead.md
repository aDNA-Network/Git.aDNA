---
plan_id: p5_codeberg_beachhead
type: plan
title: "P5 — Codeberg Beachhead"
owner: stanley
status: planned
campaign_id: campaign_git_genesis
campaign_phase: 5
campaign_mission_number: 5
mission_class: implementation
created: 2026-06-19
updated: 2026-06-19
last_edited_by: agent_stanley
tags: [plan, campaign, git, genesis, codeberg, beachhead, outward, operation_free_harbor]
---

# Mission: P5 — Codeberg Beachhead

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 5 — Codeberg Beachhead · **Mission**: 5 of 8

## Goal
First **outward** phase (Decision Point 4 — operator authorizes). Stand up the Codeberg private home and prove the agnostic tooling end-to-end by migrating pilots — Git.aDNA dogfooding its own first remote.

## Exit Gate
Codeberg `aDNA-Network` org/teams stood up (mirroring the GitHub layout); pilot graphs (Git.aDNA + 1–2 low-risk internal) migrated + verified (clone/push round-trip); agnostic skills proven against Forgejo; one release-mirror Codeberg→GitHub round-trips on a tag; rollback drill passes (repoint + restore verified).

## Objectives (sketch — expand when phase opens)
1. **Credentials** — provision the Codeberg/Forgejo token via `Home.aDNA` broker (Rule 6); register in the shim/credential index.
2. **Org/teams** — create Codeberg `aDNA-Network` structure (coord aDNALabs to mirror the GitHub layout, partitioned by visibility).
3. **Dogfood** — `skill_git_remote_setup` (agnostic) gives Git.aDNA its first remote on Codeberg; push.
4. **Pilots** — migrate 1–2 low-risk internal graphs; verify with the agnostic skills.
5. **Release-mirror** — wire a Forgejo push-mirror Codeberg→GitHub for one Class-R graph; verify tag propagation.
6. **Rollback drill** — exercise the repoint-back path; file the drill report (gates fleet alignment).

## Campaign Context
- **Prev (M4)**: execution charter + upstreamed/draft skills.
- **Next (M6)**: a proven beachhead + drill report gate the fleet waves. **Also unblocks M7** (north-star spike, in parallel).

## Notes
- **Outward + irreversible** — every objective here is operator-gated. History-scan any pilot before its host move.

## AAR
*Append before `status: completed`.*
