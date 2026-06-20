---
adna: Lighthouse.aDNA
type: build-prompt
version: 0.1.0
date: 2026-06-11
campaign: FIRST LIGHT
mission: LIGHTHOUSE-GENESIS
executor: LatticeAgent (Claude Code)
---

# MISSION PROMPT — LIGHTHOUSE-GENESIS

*Hand this document to the builder agent verbatim. Everything below the line is the prompt.*

---

You are **LatticeAgent**, operating under **Campaign FIRST LIGHT, Mission LIGHTHOUSE-GENESIS**, for Stanley Bishop (the Steward/Keeper). Your task: construct the **Lighthouse.aDNA** context graph — the vault that specifies, deploys, and operates an aDNA network lighthouse node — and stage its integration across the entire aDNA system, establishing **git.aDNA as the replacement for GitHub for all internal work** (GitHub retained only for public-facing repositories).

## 0. Orientation

The aDNA network runs on the Lattice Protocol. A lighthouse is the unit of presence on the network: one site, one stack, one repo. Lighthouse.aDNA is itself a context graph whose `HOW/infra/` deploys the node it documents — *the repo is the node*. The subnet registry is the repo `network/chart` on git.aDNA — *the Chart is the subnet*; lighthouses join by pull request. The forge function (Forgejo at `git.adna.network`, flagship site `pharos`) becomes the canonical origin for every internal repository; GitHub remains only as **the harbor** for public-facing surfaces.

## 1. Inputs

The seed set sits at `./_seed/` relative to your working directory:

- `00_CHARTER.md` — mission, scope, terms, locked defaults, success criteria
- `01_ARCHITECTURE.md` — node anatomy, profiles, forge spec, replication, tiers, security
- `02_REQUIREMENTS.md` — REQ-* with acceptance criteria; your test plan
- `03_MIGRATION_DOCTRINE.md` — repo classes, campaign phases, mechanics, the doctrine block, integration touchpoints
- `04_VAULT_SPEC.md` — the graph structure you will build, schemas, Bases, agent contract

Read all five in full before writing anything. The requirements document is normative; build to its acceptance criteria.

## 2. Pre-Flight (mandatory, before any writes)

1. **House dialect:** inspect `TaskForge.aDNA`, `LatticeAgent.aDNA`, and `Canvas.aDNA` under `/lattice/`. Record the prevailing conventions: directory casing, frontmatter keys, WHO/WHAT/HOW realization, TaskNotes format, cross-vault link style, installed Bases syntax. **Where 04 conflicts with dialect, dialect wins** — log each deviation as an ADR with one-line rationale.
2. **Inventory:** enumerate (a) GitHub repositories via `gh repo list` across all accessible orgs/accounts, and (b) every git remote across `/lattice/` (`git remote -v` walk). Capture per repo: LFS presence, submodules, Actions workflows, open issues/PRs worth migrating. Use **read-only** GitHub calls exclusively.
3. Emit `OPS/sessions/<date>-preflight.md` summarizing both, then **STOP — Gate 0:** present the repo classification table (per 03 §1–2 defaults; unknowns marked `UNCLASSIFIED`) for the Steward's sign-off before proceeding.

## 3. Construction Phases

Each phase = one signed commit (`genesis(phase-N): …`), one session log, verification gate passed before the next begins.

**Phase 1 — Scaffold.** Create the vault at `/lattice/Lighthouse.aDNA/` exactly per 04 §2 (dialect-adjusted). Empty notes carry correct frontmatter from day one.

**Phase 2 — Author the graph.** Land seed content at its canonical homes (04 §2 mapping): charter → `_meta/charter.md`; architecture sections → `WHAT/architecture/*`; requirements → `WHAT/requirements/requirements.md`; doctrine → `WHAT/doctrine/*` including `doctrine-block.md` verbatim from 03 §7. Single-source rules apply (04 §3): transclude, never duplicate. Write `README.md` carrying the four canonical statements verbatim (REQ-DOC-002). Seed `WHO/`: roles, agents (accounts/scopes/rotation from 03 §5), and `sites/pharos.md` per schema 4.1.

**Phase 3 — Infra skeleton.** Under `HOW/infra/`: `compose.yaml` with profiles `core`/`collab`/`inference`/`ops` per 01 §3 — every image version-pinned (REQ-DEP-006), healthchecks on all services; `env/site.env.example` covering every variable; `.sops.yaml` + age scaffolding with **zero plaintext secrets** (REQ-DEP-002 — placeholder ciphertext structure only; the Keeper seals real values); `Makefile` targets: `up`, `down`, `status`, `backup`, `drill`, `mirror-status`. Validate: `docker compose config` passes per profile; CI lint workflow (`.forgejo/workflows/`) included.

**Phase 4 — Runbooks.** Author all nine runbooks listed in 04 §2, schema 4.2, every step ending in **Verify:** with an observable condition. `RB-genesis` encodes the seed-bootstrap paradox resolution (01 §8) step-for-step. `RB-restore-drill` is written to gate migration (REQ-MIG-007). High-risk runbooks open with a STOP gate naming the authorizer.

**Phase 5 — Bases & canvases.** Author the four Bases per 04 §5 in the installed syntax; seed enough records (pharos site note, ≥5 repo records from the Phase 0 inventory, all runbooks, genesis ADRs) that every Base renders non-empty. Author both canvases per 04 §6 as valid JSON Canvas (Canvas.aDNA-conformant).

**Phase 6 — Integration patch set.** *(STOP — Gate 6 before anything leaves this vault.)* Prepare — but do **not** apply — per-vault patches under `OPS/patches/<vault>/`, per 03 §8:

- **Every sibling vault:** insert the doctrine block (03 §7) verbatim into its agent contract (CLAUDE.md or dialect equivalent), with `source:` frontmatter pointing back to `WHAT/doctrine/doctrine-block.md`.
- **TaskForge.aDNA:** Campaign FIRST LIGHT structure — missions per phase, standing missions (quarterly restore drill, monthly patch session), TaskNotes-formatted.
- **Cmux.aDNA:** `g` namespace command-tree spec stub (status / sync / mirror / PR) bound to git.aDNA endpoints; forge sync state in the status line.
- **LatticeAgent.aDNA:** machine-account + signing-key provisioning runbook reference; default remotes → git.aDNA; mesh reachability pre-flight.
- **SiteForge.aDNA:** CI doctrine — Forgejo Actions build → lighthouse Caddy deploy; adna.network repo classed R.
- **RareHarness.aDNA / VideoForge.aDNA / Canvas.aDNA / RemoteControl.aDNA:** the specific lines from 03 §8.

Each patch ships with a one-paragraph rationale and an apply command. Present the set for review; the Steward applies or delegates application explicitly.

**Phase 7 — Mission filing & report.** Write `OPS/campaign-first-light.md` (phases, gates, order of march from 03 §3), `HOW/checklists/genesis-dod.md`, and a closing genesis report: what was built, every ADR/deviation, REQ acceptance-criteria status table (pass / pending-deploy / blocked), and the Steward's next three actions (expected: ratify charter, choose flagship hardware + DNS cutover moment, authorize `RB-genesis`).

## 4. GitHub Replacement Rules (embed everywhere doctrine lands)

1. git.aDNA is the canonical origin for all Class I and Class R repositories.
2. GitHub is retained solely as the public harbor: Class P primary homes and Class R push-mirrors (tags/releases).
3. No new internal repository may be created on GitHub after flagship genesis (D+0).
4. Remotes: `origin` → git.aDNA; `harbor` → GitHub (Class R only); Class I repos have no GitHub remote.
5. Class P repos (e.g., `Wilhelm-Foundation/rare-archive`) keep their GitHub home and community workflow untouched; git.aDNA holds read-only pull-mirrors in `public-mirrors/`.
6. Community contribution flows (issues/PRs) for Class P remain on GitHub; triage may sync inward, never auto-outward.
7. Client material, secrets, and unpublished research never transit GitHub — including in git history. Pre-push scanning on Class R; full-history scan before any client repo touches the forge.
8. Tasks live in TaskForge (TaskNotes); Forgejo Issues serve code defects and external collaboration only.

## 5. Hard Constraints

- **No plaintext secrets**, anywhere, ever — including examples (use `<sops:sealed>` placeholders).
- **Do not execute migrations.** This mission builds and stages; rehoming repos, changing remotes, creating mirrors, and touching DNS are separate missions gated by the restore drill (REQ-MIG-007).
- **Do not modify any GitHub remote or call any non-read-only GitHub API.**
- **Cross-vault writes only as staged patches** (REQ-AGT-003) — nothing applied silently.
- Idempotent: re-running any phase must not duplicate or corrupt.
- Markdown for all documents; valid JSON for canvases; pinned versions in all infra.
- Conform to house dialect (04 §1); log deviations as ADRs.
- When blocked or uncertain, stop at the nearest gate and ask — never improvise around a STOP.

## 6. Definition of Done

- [ ] Vault tree complete and dialect-conformant; conformance checklist in genesis report (REQ-DOC-001)
- [ ] Canonical statements verbatim in README and doctrine block (REQ-DOC-002)
- [ ] `docker compose config` passes for all four profiles; zero `latest` tags; secret scan clean
- [ ] All nine runbooks validate against schema; every step has **Verify:**
- [ ] Four Bases render non-empty; two canvases valid JSON (REQ-DOC-003)
- [ ] Integration patch set staged for every vault in 03 §8, each with rationale + apply command
- [ ] Campaign file, DoD checklist, genesis report, and ≥1 ADR filed
- [ ] Every commit phase-scoped, SSH-signed, `Agent:` trailer; session log per phase
- [ ] REQ acceptance-criteria status table delivered (pass / pending-deploy / blocked — nothing silently omitted)

## 7. Session Protocol

Per the house execution hierarchy (Campaign → Phase → Mission → Session): one session log per working session in `OPS/sessions/`, recording objective, actions, verifications, and hand-off state. Report at every gate. Brevity is respect; precision is doctrine.

*End of mission prompt.*

---
*Document 05 of 6 · Lighthouse.aDNA seed set · Mission LIGHTHOUSE-GENESIS*
