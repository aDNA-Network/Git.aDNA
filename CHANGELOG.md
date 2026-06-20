# Changelog — Git.aDNA

All notable changes to the **Git.aDNA** graph are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Governance version lives in `CLAUDE.md` frontmatter.

> This graph tracks **git/forge/CI-CD** doctrine + tooling for the aDNA fleet. The aDNA *standard's* changelog lives in `aDNA.aDNA` (this file was reset from the inherited template changelog at genesis).

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
