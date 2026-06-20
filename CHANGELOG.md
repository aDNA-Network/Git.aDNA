# Changelog — Git.aDNA

All notable changes to the **Git.aDNA** graph are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Governance version lives in `CLAUDE.md` frontmatter.

> This graph tracks **git/forge/CI-CD** doctrine + tooling for the aDNA fleet. The aDNA *standard's* changelog lives in `aDNA.aDNA` (this file was reset from the inherited template changelog at genesis).

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
