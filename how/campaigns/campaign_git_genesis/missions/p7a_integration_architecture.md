---
plan_id: p7a_integration_architecture
type: plan
title: "P7a — Integration Architecture (joint Network.aDNA)"
owner: stanley
status: completed
chartered: 2026-08-07
completed: 2026-08-21
campaign_id: campaign_git_genesis
campaign_phase: 7
campaign_mission_number: "7a"
mission_class: architecture
created: 2026-06-20
updated: 2026-08-21
last_edited_by: agent_stanley
tags: [plan, campaign, git, integration, context_sync, network, lighthouse, adr_015, ratified, gate_closed, operation_free_harbor]
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

> **🟡 2026-08-19 (same day, fifth sitting) — ADR-015 at rev 3; the gate is open on both limbs and neither is ours to fire** (`session_stanley_20260819_git_p7a_the_precondition`). **Hermes (Exchange) read D1.5 off our `STATE.md` on his own recon sweep, checked his vault's code, and found the clause unsatisfiable** — the egress guard consults the host allowlist **before** the private-address check and grants no exemption from it, so restoring `allow_private = False` for the mesh-internal name D1.1 *requires* would reject the very name the retirement exists to reach. D1.5 is now **three-part-plus-one**: three controls retire with the flip, `allow_private` waits on an Exchange-owned, **undated** name-allowlist exemption ([[p7a_flip_staging/flip_runbook|runbook]] **P5**). ⛔ **The instructive part is the failure shape**: the fetcher-shaped probe this mission specified runs *pre*-restore, so it would have **passed**, and the breakage would have landed after the flip and presented as a Caddy fault. **This clause is the one part of ADR-015 neither gating party could have checked** — the failure lives in a third vault's implementation, and it was caught only because that vault reads other graphs' state files. Also this sitting: his `ack_required` memo turned out to have been **committed without being read** (finding **F-P7a-d**), and Venus was re-notified a second time — to concur against **rev 3**.

> **⛩ 2026-08-21 (eighth sitting) — P7a CLOSES** (`session_stanley_20260821_git_p7a_closes`). Operator plan gate: ratify **ADR-015 rev 4 only**, work scope = the two items the previous sitting recorded OWED. **Both limbs of the joint gate are now closed** — Venus's concurrence delivered (S392, extended to rev 4, read at the object `847bccb`, both moved clauses verified by her independently before extending) + **operator §7.7, 2026-08-21**. ⛔ **The open sweep found the gate document understating its own gate**: ADR-015's Ratification block still read *"held `staged` … never delivered … the gate is **not** half-closed"* — true when written on 08-20, stale within the day, and sitting on the one field where being wrong costs a phase. Corrected before stamping, filed **F-P7a-l**. **Ratification moved no decision text** — D1–D5 stand exactly as at rev 4, verified by diff against `847bccb` (two hunks: frontmatter + the Ratification block; decisions begin at line 34 and are untouched). Also folded: Venus's **E2** → the flip runbook's new **§1d** (the CA fallback is *gated*, not merely expensive), and her **E3** → an `ack_required` memo to **Hestia**, whose channel D1.3 assigns without her word — **authored, and its send REFUSED by the peer-lease probe** (her vault went `active` between our open and our copy), so **E3 stays owed**; ⚠ the memo had also been pre-stamped `outbound_delivered` before any copy — **F-DEL-01, by the vault that keeps filing it** — corrected and disclosed in the memo's own §0.

## Exit Gate
An **integration ADR** (co-authored/ratified with Network.aDNA) fixing forge-placement, the context-sync protocol, the identity bridge, and addressing; the Network coord memo updated + delivered; inputs ready for P7b + the `Lighthouse.aDNA` deployable. ✅ **MET 2026-08-21** — [[../../../../what/decisions/adr_015_lighthouse_integration_architecture|ADR-015]] `accepted` at **rev 4**, both gate limbs closed (Venus concurrence S392 · operator §7.7 2026-08-21). All four seams ADR-012 routed here are decided: **D1** addressing/TLS (two-leg contract + the §D1.5b falsifiable probe) · **D2** identity bridge · **D3** context-sync coexist-now-converge-by-lane · **D4** production placement + `forge` service class · plus **D5** fleet host-move sequencing, which **unblocks the fleet host-move wave**. The flip itself remains gated on eight runbook preconditions ([[p7a_flip_staging/flip_runbook|runbook]] §1) — **those block execution, not the binding**, which is why they live there and not in the ADR.

## Campaign Context
- **Prev**: P5 (beachhead proves the agnostic tooling vs Forgejo) — can run in parallel with P4–P6.
- **Next (P7b)**: the integrated forge + context-sync spike on Network's substrate.
- **Findings driving this**: Network `ADR-016 §8` (forge ≠ lighthouse host); Network's drill-#7 prototype (build on it). See [[context_north_star_vision]].

## AAR

*(Closed 2026-08-21 — `session_stanley_20260821_git_p7a_closes`.)*

- **Worked**: Staging the flip runbook **before** ratification meant the operator ratified D1 knowing what executing it costs — and the four revisions were each driven by a peer checking our text against their own vault's ground truth (Ilmarinen's instance audit · Hermes's `egress.py` read · Venus's CA inventory · Pythia's read-back), which is the only reason a joint ADR binding three vaults' runtimes is worth trusting.
- **Didn't**: **Four capabilities were assigned to other vaults in prose** — a mesh-internal resolver, a fabric-id registry, a `forge` service class, and Hestia's trust-anchor channel. Three did not exist; the fourth belonged to a vault that never saw the document. Two consecutive revisions were caused by it, and the fourth reached ratification uncaught by us.
- **Finding**: **A measurement that cannot fail is not a control** (F-P7a-f) — and its sibling, **a status field is a claim with a hidden expiry** (F-P7a-l): the §D1.5a redirect-chain column passed by construction on exactly the failure it existed to catch, and this ADR's own Ratification block described a blocker that had already cleared. Both were found by asking *can this ever report the thing it is for?* rather than by reading it.
- **Change**: **Prose does not assign capability.** A clause naming another vault's channel, registry, or service class needs that vault's word before it binds — and every probe must state its failure condition at the point of definition, not in the runbook that transcribes it.
- **Follow-up**: **deliver** the staged Hestia memo when her lease clears, *then* her ruling on D1.3's channel ([[../../../../who/coordination/coord_2026_08_21_hopper_to_hestia_adr015_d13_trust_anchor_assignment|memo]], `ack_required`, **send refused by the probe 2026-08-21**) · the eight flip preconditions, of which **P2/P6/P7/P8 are unbuilt capabilities on Venus's lane** and **P5 is undated on Hermes's** · **P7b obj 4–5** now executes D3 against the live instance · D5 unblocks the fleet host-move wave.
