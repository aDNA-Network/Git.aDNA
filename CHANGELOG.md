# Changelog — Git.aDNA

All notable changes to the **Git.aDNA** graph are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Governance version lives in `CLAUDE.md` frontmatter.

> This graph tracks **git/forge/CI-CD** doctrine + tooling for the aDNA fleet. The aDNA *standard's* changelog lives in `aDNA.aDNA` (this file was reset from the inherited template changelog at genesis).

---

## [v0.9] — 2026-06-20 — Governance doc-sync (CLAUDE/MANIFEST reconciled to P4-exit)

> Doc-only reconciliation. `CLAUDE.md` + `MANIFEST.md` had lagged at **v0.7** ("P0–P3 ✅ … at the P4-exit gate") — the v0.8 P4-exit-close commit updated STATE/CHANGELOG/charter but not them. Brought every governance surface into agreement: **P0–P4 ✅ · `campaign_gitops_rollout` ratified (P4-exit closed) · Resume-Here = R1/P5**. **No outward actions / no `.adna/` edits / no cross-vault writes.**

### Changed
- **`CLAUDE.md`** — top Status line, First-Run pointer, Genesis-Campaign phase table (P1–P4 → ✅; P7 → "Integrated Lighthouse Forge + Context-Sync" P7a/P7b per ADR-012; P5 marked Resume-Here), Resume-Here paragraph, and the workspace-router note (row **inserted** 2026-06-19, not "staged"); frontmatter `version 0.1→0.9` + `updated`.
- **`MANIFEST.md`** — Status section: "Phase 3 → P4 … P4 is Resume-Here" → "Phase 4 complete → R1/P5 is Resume-Here".
- **`how/campaigns/campaign_git_genesis/campaign_git_genesis.md`** — P4 mission-row status: `proposed → ratified (P4-exit closed)` (resolves the in-file contradiction with the gate line).
- **`STATE.md`** — frontmatter `last_session` + `tags` (phase_4→5) + one append-only intake-log line (body already current).

### Noted (follow-up, not in scope)
- `CLAUDE.md` Framework-Identity table still cites the superseded **ADR-002/003** ("Codeberg-private / GitHub-public") rather than **Path B (ADR-004/005)** — a pre-existing doctrine-reference drift, separate from the phase-pointer sync; flagged for a later pass.

---

## [v0.8] — 2026-06-20 — P4-exit closed (rollout charter ratified) + hand-offs queued

> Operator "make it so": **`campaign_gitops_rollout` ratified** (`proposed→accepted`, two-cycle) — the P4-exit gate is closed on our side; the genesis-planning campaign (P0–P4) is complete. Cross-vault hand-offs **queued, not delivered** (Rule 10). **No outward actions, no `.adna/` edits.** Next: R1/P5 (first outward) — gated on Rosetta release + Hestia `CODEBERG_TOKEN` + Decision Point 4.

### Changed
- **`campaign_gitops_rollout` → `accepted`** (DP1 done) — now the live execution charter (R1–R5).
- Rosetta + Hestia coord memos → **QUEUED for delivery**.

### Added
- `who/coordination/coord_delivery_queue.md` — the cross-vault hand-off delivery queue (Rosetta · Hestia · Berthier · Venus · Lighthouse) with triggers, what each unblocks, and the R1/P5 critical path.

---

## [v0.7] — 2026-06-20 — Re-Elevation Ratified + P4 (Upstream Coordination & Execution Charter)

> Operator ratified the re-elevation; opened + executed P4. Design/coordination only — **no outward actions, no `.adna/` edits**. Resume-Here → P4-exit gate (ratify the rollout charter + deliver the Rosetta memo) → R1/P5.

### Changed
- **ADR-012 → `accepted`** (lighthouse-operator default + git-as-context-sync + §8 forge-placement correction + Lighthouse.aDNA-now). Charter DP8 ratified; vision section marked ratified.
- **Root workspace router** (`~/aDNA/CLAUDE.md`): **`Lighthouse.aDNA` row inserted** (Project Discovery + Workspace Layout + Platform Ecosystem); **Git.aDNA row refreshed** to Path B + P0–P3 + Lighthouse-forked (`#needs-human` Hestia/PT). `Lighthouse.aDNA/STATE.md`: router row → inserted.
- **P4 executed**: Rosetta upstreaming memo finalized + staged (`coord_draft_adna_skill_upstreaming`); P4 mission → completed + AAR. Git.aDNA `CLAUDE.md` status refreshed (P0–P3 ✅ + re-elevation ratified).

### Added
- **`campaign_gitops_rollout`** (execution charter, `proposed`) — R1 Codeberg-FOSS beachhead · R2 fleet Path-B waves · R3 integration architecture (joint Network) · R4 integrated forge + context-sync spike · R5 adoption.

---

## [v0.6] — 2026-06-20 — Strategic Re-Elevation + Wind-Down

> Post-P3 review: captured the operator's elevated end-state (lighthouse-operator default · git-as-context-sync · decentralized-git-for-agentic-context) + 2 findings; forked the `Lighthouse.aDNA` stub. **Design/context only — no outward actions, no `.adna/` edits, no infra.** Resume-Here stays **P4**; the re-elevation (incl. ADR-012) awaits an operator ratification gate.

### Added
- `what/context/context_north_star_vision.md` (4 threads + triad + incremental path) + `what/context/context_gitops_options.md` (advisory decision guide).
- `what/decisions/adr_012_lighthouse_operator_default_and_context_sync.md` (`proposed`) — lighthouse-operator default + git-as-context-sync thesis + §8 forge-placement correction + Lighthouse.aDNA-now + decentralized-git objective.
- `how/skills/skill_gitops_advisor.md` (draft) — choose/interoperate/refactor advisory.
- `how/campaigns/campaign_git_genesis/missions/p7a_integration_architecture.md` (joint Network mission; precedes the spike).
- `who/coordination/coord_2026_06_20_git_lighthouse_handoff.md`; `how/backlog/idea_decentralized_git_for_agentic_context.md`.
- **`Lighthouse.aDNA`** genesis-planning stub forked (sibling vault — the deployable home; its own local git, no remote).
- Project memory: the elevated north-star vision.

### Changed
- Campaign charter: **Goal elevated** (+ fixed stale pre-Path-B wording) + North-Star vision section; risk register += §8 + scope-balloon; decision points += DP7-timing-amend, DP8 (default), DP9 (spike auth); **Phase 7 → P7a (integration arch, joint Network) + P7b (integrated forge + context-sync spike)**; timeline → 10 missions; Progress AAR (P0–P3) filed.
- `adr_010_mesh_git_north_star` — amendment pointer to ADR-012 (D1/D4 §8 forge-placement; D5 timing). `spec_gitops_provider_abstraction` + `skill_git_provider_config` — lighthouse-operator default encoded (policy + fork-hook).
- STATE — carried-facts (elevated vision · §8 finding · Lighthouse.aDNA fork) + P7 ladder row + intake entry.

### Findings
- 🚨 ADR-010 D1 collided with Network `ADR-016 §8` (forge ≠ lighthouse host) — corrected via ADR-012.
- Network already prototypes git-over-mesh context exchange (`adna-exchange` "drill #7") — P7 builds on it.

---

## [v0.5] — 2026-06-20 — P3 Specs & Tooling Skeleton

> Drafts only (Git.aDNA-local `how/`+`what/`); **no `.adna/` edits, no outward actions** (dry-run = plan-mode). Exit gate green: harness 19/19. P4 (Upstream Coordination) opens next.

### Added
- **Spec** `what/specs/spec_gitops_provider_abstraction.md` — consumer-facing contract (7 verbs + dispatch · `git_provider` schema · remote-naming · mirror gotchas · `git/` wrapper + `federation_ref` · dispatch-lib contract).
- **5 agnostic skill drafts** `how/skills/skill_{git_remote_setup,vault_publish,git_provider_config,repo_migrate,release_mirror}.md`.
- **Shared dispatch lib** `how/skills/lib/gitops_dispatch.sh` (the "`gh api` for Forgejo"; `--dry-run` plan mode; live refused without `GITOPS_ALLOW_LIVE`).
- **Doctrine block** `what/doctrine/doctrine_gitops_block.md` (ADR-009 D6); **gitleaks** pre-push hook `git/hooks/pre-push.gitleaks.sh` + `git/.gitleaks.toml` (ADR-011).
- **`git/` wrapper** `git/CLAUDE.md` (dogfood + consumer template); **CI templates** `what/templates/ci/{github,forgejo}/ci.yml` (ADR-008).
- **Dry-run harness** `how/tests/dryrun_gitops.sh` — 19/19 PASS.

### Changed
- `how/skills/skill_git_remote_setup.md` + `skill_vault_publish.md` — the inherited GitHub-hardcoded v7.0 copies superseded by provider-agnostic drafts (`status: draft`).

---

## [v0.4] — 2026-06-20 — P2 Ratified (+ two-review revision pass)

> P2-exit gate: operator-approved revision pass (closing two independent adversarial reviews' gaps), then **ADRs 004–011 ratified `proposed → accepted`**. Architecture-only; **no outward writes**. P3 (Specs & Tooling Skeleton) opens next.

### Added
- **`adr_011_secret_scanning`** (binding) — `gitleaks` pre-push hook + CI scan + **hard full-history pre-move gate** (I-strict client repos need operator sign-off) + `git-filter-repo` remediation. Closes the campaign's **#1 High risk** (history secret-leakage), previously only a label. Covers MIG-006 / SEC-002.

### Changed
- **ADRs 004–011 → `accepted`** (ratified at the P2-exit gate).
- **`adr_008`** CI framing corrected — Forgejo Actions is *familiar, not byte-compatible* (P1 evidence) + native `.github/` fallback; `port-ci` now emits a `.forgejo/` variant **only where a delta requires it**; new **D6** disposition for package/OCI registry (FRG-003 → provider-managed/per-graph; self-hosted → Lighthouse). **`adr_004`** `port-ci` wording aligned.
- **`adr_009`** D3 — **server-side signing enforcement** (FRG-006, P5+) + secret-scan hook; D6 doctrine block gains a secret-hygiene line. **`adr_010`** D4 — explicit **SEC-004** (audit-retention) disposition.
- **`adr_006`** D3 / **`adr_005`** D7 wired to ADR-011 (pre-move scan gate). **`adr_007`** — decision-point citation fix + SSH-signing-key row.

### Findings
- Two independent adversarial reviews converged: architecture sound, clears the gate; the only must-fixes were the secret-scan mechanism + the CI compatibility framing — both closed before ratification.

---

## [v0.3] — 2026-06-20 — P2 Architecture & Binding ADRs

> Architecture-only. **No outward writes** (local commits; no remotes/pushes/`.adna` edits). P2-entry gate cleared (operator: **Path B** + classification **approve-in-principle**); ends at the **P2-exit ratification gate** (ADRs 004–010 `proposed`).

### Added
- **7 binding ADRs (`proposed`)** — `adr_004_provider_contract_interface` (verbs · GitHub-API + raw Forgejo REST · per-graph schema · mirror gotchas) · `adr_005_visibility_host_policy` (**Codeberg-ToS amendment + Path B**; classification-in-principle; intended-public set) · `adr_006_remote_naming` (origin/mirror/upstream/rollback) · `adr_007_credential_model` (Codeberg/Forgejo PAT via Home broker) · `adr_008_ci_cd_parity` (`.github` ↔ `.forgejo`) · `adr_009_dev_process_doctrine` (branch/commit/sign/PR + multi-graph coordination) · `adr_010_mesh_git_north_star` (lighthouse Forgejo + ForgeFed realism; **DP7 → separate `Lighthouse.aDNA`**).
- P2 session file (`session_stanley_20260620_git_genesis_p2`).

### Changed
- **`adr_002` + `adr_003` → `superseded`** (by `adr_004` / `adr_005`) — banners + `superseded_by` pointers; content preserved (SO#6).
- **Default host policy reframed** — "Codeberg-private / GitHub-public" (ADR-003) → **Path B** (Codeberg FOSS-only; private→GitHub-interim→self-hosted; ADR-005).
- Home + aDNALabs **coord memos finalized + staged** (Rule 10 — not delivered).
- Campaign charter: **DP2 done** (approve-in-principle), **DP7 resolved** (separate `Lighthouse.aDNA`); P1 row → complete; P2 row → authored/awaiting-ratification. P2 mission → `completed` + AAR.

### Findings
- Path B makes near-term outward work **only FOSS→Codeberg**; private-repo decentralization is **earned by the P7 self-hosted spike** (restore-drill gate; ADR-010 D2), not rushed.

---

## [v0.2] — 2026-06-19 — P1 Research & Fleet Git-State Inventory

> Read-only research phase (local inventory + read-only `gh`/web). **No outward writes.**

### Added
- `what/inventory/fleet_git_state.md` — authoritative fleet git-state ledger (visibility resolved via `gh repo list`; draft classification).
- `what/context/context_provider_tooling_sota.md` — Forgejo/Codeberg/ForgeFed SOTA; **tool-of-record = raw Forgejo REST API** (not `tea`).
- `what/requirements/req_triage_inscope.md` — 14-domain seed-REQ in-scope triage.

### Findings (→ P2-entry gate)
- 🚨 **Codeberg ToS prohibits private proprietary repos** → **amends `adr_003_visibility_split_policy`** ("private→Codeberg" invalid); corrected: Codeberg=FOSS / self-hosted-Forgejo=private (north star pulled forward) / GitHub=interim-private+public.
- Fleet ~95% PRIVATE on GitHub; intended-public OSS set must be flipped public.
- ForgeFed experimental (federated stars only); near-term mesh = mirroring + REST.

---

## [v0.1] — 2026-06-19 — Genesis (Operation Free Harbor, P0)

> Governance v0.1. Graph genesis'd from `.adna/`; **direct-authored, not onboarded**. Plan-first / gated-execution — **no outward actions** (no remotes, no pushes, no `.adna/` edits). **P0 charter gate RATIFIED 2026-06-19** (operator APPROVE): ADRs 000–003 → `accepted`; category **Framework.aDNA** confirmed; persona **Grace Hopper** ratified; router row **inserted** into root `~/aDNA/CLAUDE.md` (operator-authorized); **P1** (fleet inventory + provider SOTA) opened.

### Added
- **Genesis scaffold** — forked `.adna/` structure in-place; `who/what/how` legs; local `git init` (no remote).
- **4 framing ADRs (`proposed`)** — `adr_000_project_identity` (name · **Framework.aDNA reframe** from Platform-provisional · persona **Grace Hopper** · scope=git/forge/CI-CD · codename *Operation Free Harbor*) · `adr_001_seed_docs_reframe` (Lighthouse seed → adopt-and-generalize) · `adr_002_provider_abstraction` (git-ops contract over GitHub-API + Forgejo-API; Forgejo covers Codeberg **and** self-hosted) · `adr_003_visibility_split_policy` (Codeberg-private / GitHub-public / release-mirror).
- **Genesis campaign** `campaign_git_genesis` ("Operation Free Harbor") — 9-phase ladder (P0–P8), risk register, verification strategy; P0 mission + **P1–P8 mission stubs**.
- **Operational trio** — `STATE.md` (phase ladder · carried facts · live git landscape · intake log), `CLAUDE.md` (Hopper identity · Standing Orders), `MANIFEST.md` (Framework identity).
- **4 coordination memos staged** — aDNA.aDNA (skill upstreaming) · aDNALabs.aDNA (Homecoming coexistence) · Network.aDNA (mesh-git) · Home.aDNA (credentials + shim registry).
- **Fork-provenance memo** with the staged root-router row (Platform→Framework reframe; pending Hestia/PT ack).

### Changed
- **Seed set folded + reframed** — the 2026-06-11 *Lighthouse.aDNA* seed docs (00–05) relocated into `what/{doctrine,architecture,requirements}/` with agnostic-reframe banners (04/05 kept in `what/architecture/_seed/`). The "git.aDNA-canonical / GitHub-harbor" thesis is generalized to provider-agnostic.
- **CHANGELOG reset** — from the inherited standard changelog to this graph-specific one.

### Triaged / Preserved
- The mislabeled root `AGENTS.md` (a **zip blob**) + `files.zip` preserved as intake provenance at `how/campaigns/campaign_git_genesis/_seed_intake/` (archive-never-delete).
- Inherited template ADRs (Obsidian / YAML / system-config) archived → `what/decisions/_archive/`.
