---
type: state
created: 2026-06-19
updated: 2026-06-19
status: genesis
last_edited_by: agent_stanley
last_session: session_stanley_20260619_git_genesis_p0
persona: hopper
display_name: "Git"
tags: [state, git, genesis, operation_free_harbor, phase_0, provider_agnostic]
---

# Operational State — Git.aDNA

## ⏭ QUEUED — Next Live Session (READ THIS FIRST)

**Genesis Phase 0 (Operation Free Harbor) — Meta-Planning & Charter authored 2026-06-19. ⛳ AWAITING THE OPERATOR CHARTER GATE.**

This session genesis'd the graph from `.adna/` and authored the full P0 package **plan-first / gated-execution** (no outward actions — no remotes, no pushes, no `.adna/` edits):
- **4 framing ADRs (proposed)**: [[adr_000_project_identity]] (name · **Framework.aDNA reframe** · persona **Grace Hopper** · scope · *Operation Free Harbor*) · [[adr_001_seed_docs_reframe]] (Lighthouse seed → adopt-and-generalize) · [[adr_002_provider_abstraction]] (provider-contract over GitHub-API + Forgejo-API; Forgejo covers Codeberg **and** self-hosted) · [[adr_003_visibility_split_policy]] (Codeberg-private / GitHub-public / release-mirror).
- **Campaign** `campaign_git_genesis` ("Operation Free Harbor") — 9-phase ladder (P0–P8), risk register, P0 mission + **P1–P8 mission stubs** (the "multiple sessions").
- **4 coordination memos staged** (drafts, not delivered): aDNA.aDNA · aDNALabs.aDNA · Network.aDNA · Home.aDNA.
- Seed docs folded into `what/` with reframe banners; router row staged.

**Next action (operator gate, Standing Order #1):** review the charter (`how/campaigns/campaign_git_genesis/campaign_git_genesis.md`) + the 4 ADRs, then **APPROVE / REVISE / HOLD**. On **APPROVE**: ADRs 000–003 flip `proposed → accepted`, the router row inserts (Platform→**Framework** reframe), and **P1 — Research & Fleet Git-State Inventory** opens. Confirm at the gate: (1) the **Framework.aDNA category reframe** (router says Platform-provisional); (2) **persona Grace Hopper** (alt: harbor-keeper/Pharos); (3) **codename** Operation Free Harbor (alt: Lodestar).

Nothing is auto-advanced. The agent waits at the P0 charter gate.

## Genesis phase ladder (Operation Free Harbor)

| Phase | Scope | Exit gate | Status |
|---|---|---|---|
| **P0** Meta-Planning & Charter | Genesis; ADR-000/001/002/003 (proposed); campaign charter + P1–P8 stubs; coord drafts | Operator charter gate (approve/revise/hold) | **authored 2026-06-19 — awaiting gate** |
| **P1** Research & Fleet Git-State Inventory | SOTA on provider tooling (`tea`/Forgejo API · `gh` · git-remote-helpers · ForgeFed · push-mirroring · sops/age); `git remote -v` walk across all ~40 graphs + code-as-WHAT repos → `fleet_git_state.md` | Inventory complete; provider/visibility/class drafted | planned (Resume-Here on APPROVE) |
| **P2** Architecture & Binding ADRs | Provider-contract interface; `(visibility×provider)` policy; remote-naming; multi-provider credential model; CI/CD parity; dev-process git doctrine; mesh-git north-star architecture | All P2 ADRs `proposed→accepted` | planned |
| **P3** Specs & Tooling Skeleton | Agnostic skill drafts (remote-setup · publish · provider-config · repo-migrate · release-mirror); git-ops doctrine block; `git/` consumer wrapper; CI templates (both backends) | Specs authored; skill drafts dry-run-clean | planned |
| **P4** Upstream Coordination & Execution Charter | Coordinate `aDNA.aDNA` skill upstreaming (`skill_template_release`); author `campaign_gitops_rollout` execution charter | Execution charter ratified (two-cycle) | planned |
| **P5** Codeberg Beachhead *(outward — gated)* | Stand up Codeberg `aDNA-Network` org/teams; migrate pilot graphs; verify agnostic skills vs Forgejo; wire one release-mirror; rollback drill | Pilot verified; drill passes | planned |
| **P6** Fleet Alignment *(waved)* | Roll the visibility split across all graphs in gated waves; doctrine block + STATE/MANIFEST per graph; `disposition_ledger.md` + shim registry | Each wave gated; fleet converged | planned |
| **P7** Mesh-Git North-Star Spike *(strategic)* | Prototype lighthouse-run Forgejo on a Nebula node (coord Network.aDNA); ForgeFed experiment | Spike report; may spin `Lighthouse.aDNA` | planned |
| **P8** Closeout & AAR | Campaign review; AAR; STATE trim; standing missions → Operations.aDNA | Genesis `completed` | planned |

## Carried facts (standing)

- **Thesis (LOAD-BEARING):** provider-agnostic abstraction = **permanent architecture** (user host-choice preserved forever); self-hosted mesh-git = **strategic north star** (decentralized competitor to centralized git). Both, not either. (ADR-000 D5.)
- **Default host policy:** **Codeberg-private / GitHub-public**, release-mirror Codeberg→GitHub on tags; existing GitHub-private migrate to Codeberg in gated waves. (ADR-003.)
- **Key reconciliation:** Codeberg *runs Forgejo* → one Forgejo backend covers hosted Codeberg **and** future self-hosted lighthouse; the abstraction is a **2-backend** problem (GitHub-API + Forgejo-API).
- **Scope:** git / forge / CI-CD **only**. The broader Lighthouse node stack (identity/mesh→Network.aDNA, node→Home.aDNA, collab/inference) is **out of scope**; the self-hosted *forge* deployable, if built, spins a separate **`Lighthouse.aDNA`** (ADR-000 D2/D4, ADR-001 D3).
- **Category reframe proposed:** router's `Platform.aDNA (provisional)` → **Framework.aDNA** (consumed via a `git/` wrapper like III; skills upstreamed via aDNA.aDNA). Operator confirms at gate.
- **Persona Grace Hopper** — working-pin (portability/standards = the agnostic thesis); ratified at gate with a fleet ruled-out check. Alt: harbor-keeper/Pharos.
- **Hard coordination dependency:** the agnostic skills live in `.adna/` (do-not-modify, Standing Rule 1) → authored here, **upstreamed via `aDNA.aDNA`'s `skill_template_release`** (P4).
- **Migration-program coexistence:** `aDNALabs.aDNA` (Operation Homecoming) just populated GitHub `aDNA-Network`; the Codeberg split partitions by visibility — coordinate before any wave (ADR-003 D5).
- **Git: local-only** at genesis (Workspace Rule 4 posture; the first remote is a P5 gated decision — and itself the first dogfood of the agnostic tooling).
- **Router row** — staged at `who/coordination/coord_2026_06_19_fork_provenance.md`; inserts at the gate (root router frozen under Operation Production Tidy → Hestia/PT ack needed).

## Live git landscape (known facts, captured 2026-06-19; full inventory = P1)

| Item | State |
|---|---|
| This graph (`Git.aDNA`) | local-only git repo; **no remote** (first push = P5 dogfood) |
| Agnostic-blocking tooling | `.adna/how/skills/skill_git_remote_setup.md` (`gh repo create`, `https://github.com/$org/$repo.git` @ L135/144) + `skill_vault_publish.md` (`gh release create`) — GitHub-hardcoded; `skill_update_all_vaults.md` already host-neutral (`pull --ff-only`) |
| GitHub org | `aDNA-Network` (~23 repos, populated by Operation Homecoming) + legacy `LatticeProtocol` (transitional) + partner `Wilhelm-Foundation` (external) |
| **Codeberg org** | `codeberg.org/aDNA-Network` — **NEW**; private-home target; **empty / unverified** (P1 confirms, P5 stands up) |
| Code-as-WHAT nested repos | separate `.git` per nested code tree (`lattice-protocol`, `contextscope`, `harness`, `rare-archive`) — own remotes; handled at P6 wave 3 |
| External upstreams (never moved) | `ggml-org/llama.cpp` (MIT), `Wilhelm-Foundation/rare-archive` (partner-canonical) |
| Mesh substrate (north-star host) | `Network.aDNA` — dual Tailscale + Nebula; "lighthouse" is a Nebula role; **no self-hosted git deployed yet** (P7 spike) |

## Intake log (append-only)

- **2026-06-19** — Vault genesis'd from `.adna/` and direct-authored (CLAUDE/MANIFEST/STATE/CHANGELOG) per the approved plan (`~/.claude/plans/please-read-the-claude-md-buzzing-treehouse.md`); onboarding suppressed (nature fully known; Warp/Obsidian precedent). **Triaged** the pre-genesis seed-staging dir: the mislabeled `AGENTS.md` was a **zip blob** (byte-redundant with `files.zip`); both preserved as intake provenance at `how/campaigns/campaign_git_genesis/_seed_intake/`; the 6 extracted seed docs folded into `what/` canonical homes with reframe banners (04/05 kept in `what/architecture/_seed/`). Inherited template ADRs (Obsidian/YAML/system-config) archived → `what/decisions/_archive/`. Authored 4 framing ADRs (proposed), the `campaign_git_genesis` charter + P0 mission + P1–P8 stubs, and 4 staged coord memos. Router row staged (not inserted). Local `git init`; **no remote, nothing pushed; `.adna/` untouched.** Session: `session_stanley_20260619_git_genesis_p0`. STATE → P0 authored, awaiting charter gate.
