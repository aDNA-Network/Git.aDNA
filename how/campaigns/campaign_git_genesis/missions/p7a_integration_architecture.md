---
plan_id: p7a_integration_architecture
type: plan
title: "P7a — Integration Architecture (joint Network.aDNA)"
owner: stanley
status: active
chartered: 2026-08-07
campaign_id: campaign_git_genesis
campaign_phase: 7
campaign_mission_number: "7a"
mission_class: architecture
created: 2026-06-20
updated: 2026-08-19
last_edited_by: agent_stanley
tags: [plan, campaign, git, integration, context_sync, network, lighthouse, operation_free_harbor]
---

# Mission: P7a — Integration Architecture (joint Network.aDNA)

> **⛩ CHARTERED 2026-08-07 — operator GO (plan approval, Forgejo.aDNA session).** The operator's direction ("set up a Forgejo server on the Ubuntu box at the aDNA Lab as the R&D lighthouse, core repo system for the research group + Exchange graph-sharing until ledger") is the P7 charter Berthier's 2026-07-27 escalation asked for. **Joint with Venus — her side opened the same day**: the scoped §8 R&D ruling (`Network.aDNA/who/governance/ruling_2026_08_07_scoped_s8_rd_forge.md`) resolves objective 1's placement question *for the R&D window* (data-plane box, two mesh-only listeners, Am6 hardening, revisit-at-production); objectives 2–4 (context-sync protocol, identity bridge, addressing/DNS+TLS) remain this mission's open design work toward the full integration ADR. Interim identity note: Forgejo OAuth2 has no scope enforcement (Forgejo.aDNA D12 §D.6) — first-party-apps-only posture until upstream ships scopes.

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 7 — Integrated Lighthouse Forge + Context-Sync · **Mission**: 7a (precedes P7b)

## Goal
Design the seam between the self-hosted **Forgejo forge**, Network.aDNA's **mesh/identity substrate**, and **context-sync** — so the P7b spike + the eventual `Lighthouse.aDNA` deployable build on a ratified architecture. **Joint with Venus**; design only, no deployment, no infra.

## Objectives (sketch — expand when phase opens)
1. **§8 forge-placement** ([[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]] D3): forge on a dedicated **data-plane node** the lighthouse coordinates vs. a Network-blessed "forge hub" class. Co-decide with Venus (Network `ADR-016`).
2. **Forgejo-as-context-sync** (ADR-012 D2): design vault-as-repo sync over the mesh, building on Network's `adna-exchange` "drill #7"; reconcile with Network's tarball-transmission ceremony (converge or coexist).
3. **Identity bridge**: Forgejo user-auth ↔ Network node DIDs / federation-signing keys (Network owns *node* identity, not *user* auth).
4. **Addressing**: `git.<subnet>.adna.network` DNS + mesh-internal TLS policy.

> **🟢 2026-08-19 — "Lighthouse Addressing" design block EXECUTED (`session_stanley_20260819_git_p7a_lighthouse_addressing`): [[../../../../what/decisions/adr_015_lighthouse_integration_architecture|ADR-015]] drafted `proposed` covering all four objectives** (1 = D4 production-placement revisit [R&D half was Venus's 08-07 ruling] · 2 = D3 coexist-now-converge-at-production · 3 = D2 mapping-registry bridge · 4 = D1 two-leg addressing/TLS + dated §2.7 retirement), **+ D5 fleet host-move sequencing**. Companion [[../../../../what/doctrine/doctrine_cross_node_mesh_mirror|pattern doc]] shipped (§6 = Venus A2 advisories). Venus concurrence memo delivered `ack_required`; **the exit gate = her concurrence + operator §7.7 — both pending.**

> **🟡 2026-08-19 (same day, fourth sitting) — ADR-015 at rev 2; the gate is still open, and that is a fact rather than a choice** (`session_stanley_20260819_git_p7a_flip_runbook`). Ilmarinen's read-only instance audit answered the one sanity-check this mission asked for before the flip runbook could be written, and it **corrected D1**: four `app.ini` keys move rather than three (`PROTOCOL` omitted), the runner↔`ROOT_URL` coupling is **inverted** (registration is against the compose service name), and a finding nobody had named — `NO_REPLY_ADDRESS` derives from `DOMAIN` and is already written into immutable git objects, so the flip breaks three users' author map **permanently** unless the suffix is pinned in or before the window. D1.2's bind clause was likewise an assumption (Caddy binds all interfaces by default) and is now an explicit requirement. **Venus was re-notified to concur against rev 2, not the 17:31 draft** — a proposal awaiting concurrence is a moving target, and letting her ratify known-wrong text would have put the error inside the gate (finding F-P7a-b). [[p7a_flip_staging/flip_runbook|The flip runbook]] is staged behind it: §0–§8, four lanes, fires nothing.

## Exit Gate
An **integration ADR** (co-authored/ratified with Network.aDNA) fixing forge-placement, the context-sync protocol, the identity bridge, and addressing; the Network coord memo updated + delivered; inputs ready for P7b + the `Lighthouse.aDNA` deployable. **Status: ADR-015 at rev 2 (D1 corrected against the live instance 2026-08-19); gate = Venus concurrence + operator §7.7, both against rev 2 (pending).**

## Campaign Context
- **Prev**: P5 (beachhead proves the agnostic tooling vs Forgejo) — can run in parallel with P4–P6.
- **Next (P7b)**: the integrated forge + context-sync spike on Network's substrate.
- **Findings driving this**: Network `ADR-016 §8` (forge ≠ lighthouse host); Network's drill-#7 prototype (build on it). See [[context_north_star_vision]].

## AAR
*Append before `status: completed`.*
