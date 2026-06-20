---
type: state
created: 2026-06-19
updated: 2026-06-20
status: genesis
last_edited_by: agent_stanley
last_session: session_stanley_20260620_git_genesis_p2
persona: hopper
display_name: "Git"
tags: [state, git, genesis, operation_free_harbor, phase_2, provider_agnostic]
---

# Operational State — Git.aDNA

## ⏭ QUEUED — Next Live Session (READ THIS FIRST)

**P0 ✅ · P1 ✅ · P2 (Architecture & Binding ADRs) authored 2026-06-20 — ⛳ P2-EXIT RATIFICATION GATE (operator APPROVE/REVISE/HOLD of ADRs 004–010).**

The **P2-entry gate was cleared** this session (operator): **D1 = Path B** (GitHub-interim private + Codeberg-FOSS; self-hosted Forgejo = the eventual private home, post-P7) · **D2 = classification approve-in-principle** (re-confirm per-wave). P2 then authored **7 binding ADRs**, architecture-only (**no outward actions** — no remotes/pushes/`.adna` edits):

- [[adr_004_provider_contract_interface]] — provider-contract interface (binding; **supersedes 002**): 7 verbs · GitHub-API + **raw Forgejo REST** · per-graph schema · mirror gotchas.
- [[adr_005_visibility_host_policy]] — visibility/host policy (binding; **supersedes 003**): **Codeberg-ToS amendment + Path B** · classification-in-principle · intended-public set.
- [[adr_006_remote_naming]] — `origin`/`mirror`/`upstream`/`rollback` + migration sequence + shim tie-in.
- [[adr_007_credential_model]] — multi-provider credential model (Home.aDNA broker; provision at P5).
- [[adr_008_ci_cd_parity]] — CI/CD parity (`.github` ↔ `.forgejo`; portable-first).
- [[adr_009_dev_process_doctrine]] — dev-process git doctrine (branch/commit/sign/PR + multi-graph coordination + doctrine block).
- [[adr_010_mesh_git_north_star]] — mesh-git north-star (+ **DP7 resolved: separate `Lighthouse.aDNA`**, trigger at P7).

Sketches 002/003 → `superseded` (banners + pointers; provenance kept, SO#6). Coord memos (Home, aDNALabs) finalized + **staged** (Rule 10). Committed locally; **no remote/push/`.adna` edits**.

**⛳ Resume-Here = the P2-EXIT ratification gate**: review ADRs 004–010 → **APPROVE** (flip `proposed→accepted`; P3 Specs & Tooling Skeleton opens) / **REVISE** / **HOLD**. Nothing auto-advances (Standing Order #1).

## Genesis phase ladder (Operation Free Harbor)

| Phase | Scope | Exit gate | Status |
|---|---|---|---|
| **P0** Meta-Planning & Charter | Genesis; ADR-000/001/002/003 (proposed); campaign charter + P1–P8 stubs; coord drafts | Operator charter gate (approve/revise/hold) | **✅ complete + ratified 2026-06-19** |
| **P1** Research & Fleet Git-State Inventory | SOTA on provider tooling (`tea`/Forgejo API · `gh` · git-remote-helpers · ForgeFed · push-mirroring · sops/age); `git remote -v` walk across all ~40 graphs + code-as-WHAT repos → `fleet_git_state.md` | Inventory complete; provider/visibility/class drafted | **✅ complete 2026-06-19** |
| **P2** Architecture & Binding ADRs | Provider-contract interface; `(visibility×provider)` policy; remote-naming; multi-provider credential model; CI/CD parity; dev-process git doctrine; mesh-git north-star architecture | All P2 ADRs `proposed→accepted` | **✅ authored 2026-06-20 (ADRs 004–010, `proposed`) — ⛳ P2-EXIT ratification gate (Resume-Here)** |
| **P3** Specs & Tooling Skeleton | Agnostic skill drafts (remote-setup · publish · provider-config · repo-migrate · release-mirror); git-ops doctrine block; `git/` consumer wrapper; CI templates (both backends) | Specs authored; skill drafts dry-run-clean | planned |
| **P4** Upstream Coordination & Execution Charter | Coordinate `aDNA.aDNA` skill upstreaming (`skill_template_release`); author `campaign_gitops_rollout` execution charter | Execution charter ratified (two-cycle) | planned |
| **P5** Codeberg Beachhead *(outward — gated)* | Stand up Codeberg `aDNA-Network` org/teams; migrate pilot graphs; verify agnostic skills vs Forgejo; wire one release-mirror; rollback drill | Pilot verified; drill passes | planned |
| **P6** Fleet Alignment *(waved)* | Roll the visibility split across all graphs in gated waves; doctrine block + STATE/MANIFEST per graph; `disposition_ledger.md` + shim registry | Each wave gated; fleet converged | planned |
| **P7** Mesh-Git North-Star Spike *(strategic)* | Prototype lighthouse-run Forgejo on a Nebula node (coord Network.aDNA); ForgeFed experiment | Spike report; may spin `Lighthouse.aDNA` | planned |
| **P8** Closeout & AAR | Campaign review; AAR; STATE trim; standing missions → Operations.aDNA | Genesis `completed` | planned |

## Carried facts (standing)

- **Thesis (LOAD-BEARING):** provider-agnostic abstraction = **permanent architecture** (user host-choice preserved forever); self-hosted mesh-git = **strategic north star** (decentralized competitor to centralized git). Both, not either. (ADR-000 D5.)
- **Default host policy (Path B — [[adr_005_visibility_host_policy|ADR-005]], supersedes ADR-003):** Codeberg is **FOSS-only** (ToS — no private proprietary); **private/proprietary → GitHub interim** (eventual home = self-hosted Forgejo, post-P7); **public/FOSS → Codeberg** + GitHub discovery mirror; release-mirror private→public on tags. Near-term outward move = **FOSS→Codeberg only**; private repos stay on GitHub (no churn). Classification approved-in-principle ([[fleet_git_state]]); flips/migrations gated per-wave.
- **Key reconciliation:** Codeberg *runs Forgejo* → one Forgejo backend covers hosted Codeberg **and** future self-hosted lighthouse; the abstraction is a **2-backend** problem (GitHub-API + Forgejo-API).
- **Scope:** git / forge / CI-CD **only**. The broader Lighthouse node stack (identity/mesh→Network.aDNA, node→Home.aDNA, collab/inference) is **out of scope**; the self-hosted *forge* deployable, if built, spins a separate **`Lighthouse.aDNA`** (ADR-000 D2/D4, ADR-001 D3).
- **Category: Framework.aDNA — confirmed at the P0 gate** (2026-06-19; reframed from router's provisional Platform.aDNA; consumed via a `git/` wrapper like III; skills upstreamed via aDNA.aDNA).
- **Persona Grace Hopper** — working-pin (portability/standards = the agnostic thesis); ratified at gate with a fleet ruled-out check. Alt: harbor-keeper/Pharos.
- **Hard coordination dependency:** the agnostic skills live in `.adna/` (do-not-modify, Standing Rule 1) → authored here, **upstreamed via `aDNA.aDNA`'s `skill_template_release`** (P4).
- **Migration-program coexistence:** `aDNALabs.aDNA` (Operation Homecoming) just populated GitHub `aDNA-Network`; the Codeberg split partitions by visibility — coordinate before any wave (ADR-003 D5).
- **Git: local-only** at genesis (Workspace Rule 4 posture; the first remote is a P5 gated decision — and itself the first dogfood of the agnostic tooling).
- **Router row — INSERTED** into root `~/aDNA/CLAUDE.md` 2026-06-19 (operator-authorized override of the PT freeze); `#needs-human` Hestia/PT to reconcile into `disposition_ledger_v3`. Provenance: `who/coordination/coord_2026_06_19_fork_provenance.md`.

## Live git landscape (known facts, captured 2026-06-19; full inventory = P1)

| Item | State |
|---|---|
| This graph (`Git.aDNA`) | local-only git repo; **no remote** (first push = P5 dogfood) |
| Agnostic-blocking tooling | `.adna/how/skills/skill_git_remote_setup.md` (`gh repo create`, `https://github.com/$org/$repo.git` @ L135/144) + `skill_vault_publish.md` (`gh release create`) — GitHub-hardcoded; `skill_update_all_vaults.md` already host-neutral (`pull --ff-only`) |
| GitHub org | `aDNA-Network` (~23 repos, populated by Operation Homecoming) + legacy `LatticeProtocol` (transitional) + partner `Wilhelm-Foundation` (external) |
| **Codeberg org** | `codeberg.org/aDNA-Network` — **NEW**; **FOSS/public-home** target (ToS: no private proprietary — [[adr_005_visibility_host_policy|ADR-005]]); **empty / unverified** (P5 stands up) |
| Code-as-WHAT nested repos | separate `.git` per nested code tree (`lattice-protocol`, `contextscope`, `harness`, `rare-archive`) — own remotes; handled at P6 wave 3 |
| External upstreams (never moved) | `ggml-org/llama.cpp` (MIT), `Wilhelm-Foundation/rare-archive` (partner-canonical) |
| Mesh substrate (north-star host) | `Network.aDNA` — dual Tailscale + Nebula; "lighthouse" is a Nebula role; **no self-hosted git deployed yet** (P7 spike) |

## Intake log (append-only)

- **2026-06-19** — Vault genesis'd from `.adna/` and direct-authored (CLAUDE/MANIFEST/STATE/CHANGELOG) per the approved plan (`~/.claude/plans/please-read-the-claude-md-buzzing-treehouse.md`); onboarding suppressed (nature fully known; Warp/Obsidian precedent). **Triaged** the pre-genesis seed-staging dir: the mislabeled `AGENTS.md` was a **zip blob** (byte-redundant with `files.zip`); both preserved as intake provenance at `how/campaigns/campaign_git_genesis/_seed_intake/`; the 6 extracted seed docs folded into `what/` canonical homes with reframe banners (04/05 kept in `what/architecture/_seed/`). Inherited template ADRs (Obsidian/YAML/system-config) archived → `what/decisions/_archive/`. Authored 4 framing ADRs (proposed), the `campaign_git_genesis` charter + P0 mission + P1–P8 stubs, and 4 staged coord memos. Router row staged (not inserted). Local `git init`; **no remote, nothing pushed; `.adna/` untouched.** Session: `session_stanley_20260619_git_genesis_p0`. STATE → P0 authored, awaiting charter gate.
- **2026-06-19 (P0 ratified + P1 opened)** — Operator **APPROVE** at the charter gate. ADRs 000–003 → `accepted`; **category Framework.aDNA confirmed**; **persona Grace Hopper ratified**; codename **Operation Free Harbor**. Router row **inserted** into root `~/aDNA/CLAUDE.md` (operator-authorized; `#needs-human` Hestia/PT to reconcile into the PT ledger). P0 mission → `completed`. **P1 (Research & Fleet Git-State Inventory) opened** — read-only fleet inventory + provider-tooling SOTA. Recon pre-seeded the inventory: 44 graphs + 25 nested code-as-WHAT repos + 5 worktrees; 36 GitHub / 12 local-only; `tea` (Forgejo CLI) absent; no Codeberg creds yet. Session: `session_stanley_20260619_git_genesis_p0` (continued).
- **2026-06-19 (P1 complete)** — Read-only fleet inventory + provider SOTA delivered: `fleet_git_state.md` (visibility resolved via `gh repo list` — **fleet is ~95% PRIVATE**; only the template is public), `context_provider_tooling_sota.md` (**tool-of-record = raw Forgejo REST API**; ForgeFed experimental — stars only), `req_triage_inscope.md`, + the Homecoming coexistence map (clean/complementary). 🚨 **Load-bearing finding: Codeberg ToS prohibits private proprietary repos** → amends ADR-003; private-home path is a P2-entry operator decision (self-host-Forgejo / GitHub-interim / hybrid). **No outward writes.** P1 mission → `completed`; STATE → P2-entry gate.
- **2026-06-20 (P2 authored)** — P2-entry gate cleared (operator: **D1 = Path B** [GitHub-interim private + Codeberg-FOSS; self-host eventual], **D2 = classification approve-in-principle**). Authored **7 binding ADRs** ([[adr_004_provider_contract_interface|004]] contract · [[adr_005_visibility_host_policy|005]] host-policy + ToS-amendment · [[adr_006_remote_naming|006]] remotes · [[adr_007_credential_model|007]] credentials · [[adr_008_ci_cd_parity|008]] CI parity · [[adr_009_dev_process_doctrine|009]] dev-process · [[adr_010_mesh_git_north_star|010]] mesh-git north-star + **DP7 → separate `Lighthouse.aDNA`**). Superseded sketches 002/003 (provenance kept). Finalized + staged the Home + aDNALabs coord memos (Rule 10). DP2 + DP7 resolved in the charter; P2 mission → `completed` + AAR. **No outward writes** (local commit only; no remote/push/`.adna`). Session: `session_stanley_20260620_git_genesis_p2`. STATE → **P2-exit ratification gate**.
