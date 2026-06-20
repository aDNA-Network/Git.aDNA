> ⚠️ **REFRAME BANNER — Git.aDNA genesis, 2026-06-19.** This is an original *Lighthouse.aDNA* seed-set document (authored 2026-06-11) carrying the **self-hosted-Forgejo-first** thesis: *"git.aDNA is canonical; GitHub is the harbor."* Git.aDNA **adopts it as source material**, but its top-level thesis is **reframed to provider-agnostic** per [[adr_001_seed_docs_reframe]]: GitHub / Codeberg / self-hosted Forgejo are all first-class profiles, and self-hosted **mesh-git is the strategic north star — not the mandated canonical home**. Read it for substance (architecture · requirements · repo-class P/I/R model · migration mechanics), **not** for the canonical-host stance. The *binding* version is authored at genesis **P2**. Live phase: `STATE.md`.

---
adna: Lighthouse.aDNA
type: doctrine
version: 0.1.0
status: draft-for-ratification
date: 2026-06-11
campaign: FIRST LIGHT
depends_on: [00_CHARTER.md, 01_ARCHITECTURE.md, 02_REQUIREMENTS.md]
---

# Migration Doctrine — GitHub → git.aDNA

> *git.aDNA is canonical. GitHub is the harbor — public-facing surfaces only.*

## 1. Repo Classification

| Class | Definition | Canonical home | GitHub role | Remote names |
|---|---|---|---|---|
| **P — Public-primary** | Community-facing projects where GitHub's network effects are the asset: stars, discovery, external PRs, grant traction. | GitHub | Primary | `origin` → GitHub; pull-mirror lives in `public-mirrors/` on git.aDNA (no local remote needed) |
| **R — Release** | Work authored internally but published outward: open-source releases, site sources, papers' artifacts. | git.aDNA | Push-mirror on tags/releases | `origin` → git.aDNA; `harbor` → GitHub |
| **I — Internal** | Everything else. **The default.** Vaults, infra, client work, agent harnesses, experiments. | git.aDNA | **None** | `origin` → git.aDNA only |

**Decision tree:** Does the community contribute or discover here today? → **P**. Will it be published but authored internally? → **R**. Otherwise → **I**. When in doubt: **I** (promotion to R is one mirror config; demotion is history surgery).

## 2. Default Assignments (review at Phase 0 gate)

| Property | Class | Note |
|---|---|---|
| `Wilhelm-Foundation/rare-archive` | **P** | Grant traction anchor; community workflow must be undisturbed. Pull-mirror only. |
| adna.network site source (SiteForge) | **R** | Canonical on git.aDNA; published artifact. |
| All `*.aDNA` vaults | **I** | TaskForge, Cmux, Canvas, LatticeAgent, RareHarness, SiteForge, VideoForge, RemoteControl, SuperLeague, Lighthouse itself. |
| `sws/*` client repos (incl. SuperLeague) | **I — strict** | Client confidentiality; rehome immediately after restore drill passes. History audit mandatory (REQ-MIG-006). |
| Wilhelm internal repos | **I** | |
| Anything unrecognized at inventory | mark `UNCLASSIFIED` | Steward assigns at gate. |

## 3. Campaign FIRST LIGHT — Phases

**Phase 0 — Inventory** *(gate: Steward sign-off on classification table)*
Agent enumerates: (a) GitHub repos via `gh repo list` across orgs/accounts; (b) every local remote across `/lattice/` (`git remote -v` walk); (c) LFS presence, submodules, Actions workflows, open issues/PRs worth migrating. Output: `WHAT/doctrine/repo-inventory.md` + per-repo records feeding the `repos` Base (migration tracker).

**Phase 1 — Flagship genesis** *(gate: restore drill passed — REQ-BCK-003/MIG-007)*
Deploy `core` on chosen hardware; DNS for `git.adna.network` + `id.adna.network`; identity plane up; org layout created; the Chart initialized with `pharos`; backup targets configured; **full restore drill executed and reported before anything migrates.**

**Phase 2 — Net-new freeze** *(immediate at D+0)*
All new internal repos are created on git.aDNA. The doctrine block (§7 below) lands in every sibling vault's agent contract via the genesis patch set. This stops the bleeding while migration proceeds deliberately.

**Phase 3 — Vault rehoming** *(order of march)*
1. Low-risk first: `SiteForge.aDNA`, `VideoForge.aDNA` (LFS rehearsal — REQ-MIG-009).
2. Daily-drivers: `TaskForge.aDNA`, `Cmux.aDNA`, `Canvas.aDNA`.
3. Agent infrastructure: `LatticeAgent.aDNA`, `RareHarness.aDNA`, `RemoteControl.aDNA`.
4. Client material: `sws/superleague-*` and successors — only after the drill report is filed; history audit per repo.
5. Wilhelm internal.

**Phase 4 — Mirrors & public posture**
Pull-mirrors for Class P into `public-mirrors/`; push-mirrors configured for Class R; READMEs and badges updated to state canonical home; adna.network gains a "running on our own light" note if desired.

**Phase 5 — Decommission posture** *(gate: campaign review at D+90)*
GitHub tokens descoped to read-only for Class I originals; `harbor` remotes verified push-disabled; rollback window closes; review filed in `OPS/`; standing missions (quarterly drill, monthly patch) confirmed in TaskForge.

## 4. Mechanics

**Rehome a repo (Class I):**
```bash
git lfs fetch --all                      # if LFS-bearing — full object set first (REQ-MIG-009)
git remote rename origin harbor          # preserve rollback path
git remote add origin ssh://git@git.adna.network/<org>/<repo>.git
git push origin --all && git push origin --tags
# Class I: after verification window → git remote remove harbor
```

**Metadata-bearing repos:** use Forgejo's built-in GitHub migrator (repo + issues + PRs + releases + wiki) instead of bare push; then re-point local clones.

**Push-mirror (Class R):** configure in Forgejo repo settings → push mirror to GitHub with a fine-scoped PAT; trigger on tags/releases; verify ≤ 15 min propagation (REQ-MIG-004).

**Actions porting:** Forgejo Actions consumes GitHub-compatible workflow syntax — port `.github/workflows/` → `.forgejo/workflows/`; re-provision secrets from sops into forge secrets; common actions (`actions/checkout`, setup-*) resolve from mirrors. One sample workflow must pass before declaring a repo rehomed (REQ-FRG-002).

**Pre-push secret scan:** install hook on every Class R repo; full-history scan on every rehomed client repo before it touches the forge.

## 5. Agent Identity Provisioning

One machine account per agent function with fine-scoped token (90-day rotation) and SSH signing key:

| Account | Scope |
|---|---|
| `agent-lattice` | `vaults/*`, `network/*` (PR-only on protected) |
| `agent-siteforge` | `vaults/SiteForge.aDNA`, `forge/` deploy workflows |
| `agent-cmux` | `vaults/Cmux.aDNA` |
| `agent-ops` | runner registration, backup verification |

Commit convention: SSH-signed, trailer `Agent: <account>` (+ `Co-authored-by:` when pairing with the Keeper). Human and agent authorship must be distinguishable forever in history (REQ-IDN-003).

## 6. Backup Doctrine (operative summary)

Git data replicates by nature; **forge metadata does not.** Nightly `forgejo dump` + Postgres dump + Garage snapshot → Restic → peer lighthouse **and** offsite. Quarterly restore drill is a standing mission; the first drill gates Phase 3. The forge is the campaign's single point of failure — treat it accordingly.

## 7. The Doctrine Block (propagates verbatim)

The following block is embedded into the agent contract (CLAUDE.md or dialect equivalent) of **every** sibling vault during genesis:

```markdown
## Forge Doctrine — git.aDNA
git.aDNA (git.adna.network) is the canonical origin for all internal (Class I)
and release (Class R) repositories. GitHub is the harbor: Class P public homes
and Class R push-mirrors only.
- Never create internal repositories on GitHub.
- New repos: `ssh://git@git.adna.network/<org>/<repo>.git` — default class I.
- Remotes: `origin` → git.aDNA; `harbor` → GitHub (Class R only).
- Client material, secrets, and unpublished research never transit GitHub,
  including in git history.
- Forgejo Issues are for code defects and external collaboration; tasks live
  in TaskForge (TaskNotes). Cross-link by URL.
- Write access is mesh-only. If you cannot reach the forge, you are off-mesh:
  fix that first; do not fall back to GitHub.
```

## 8. Integration Touchpoints (delivered as patch sets, never applied silently)

| Vault | Integration |
|---|---|
| **TaskForge.aDNA** | Campaign FIRST LIGHT structure: missions per phase, standing missions (quarterly drill, monthly patch), TaskNotes-formatted. Doctrine: tasks stay in TaskForge; Forgejo Issues scoped per REQ-COL-003. |
| **LatticeAgent.aDNA** | Machine-account + signing-key provisioning runbook reference; harness default remotes → git.aDNA; mesh reachability pre-flight check. |
| **Cmux.aDNA** | `g` namespace spec stub for the command tree: `g s` status, `g y` sync, `g m` mirror state, `g p` PR — bound to git.aDNA endpoints; forge sync state in tmux status line. |
| **SiteForge.aDNA** | CI target doctrine: build via Forgejo Actions runner → deploy via lighthouse Caddy; adna.network repo classed R. |
| **Canvas.aDNA** | Spec repo rehomed I; canvases version through git.aDNA automatically as vault content. |
| **RareHarness.aDNA** | Configs/eval repos → I; weights via LFS/DVC → Garage; Hugging Face remains the public weights mirror (unchanged). |
| **VideoForge.aDNA** | Media doctrine: git for cut lists/configs; LFS or Garage-backed DVC for assets; nothing >100 MB in plain git. |
| **RemoteControl.aDNA** | Airlock sync runbook cross-reference (signed bundles + OCI archives). |
| **Wilhelm / rare-archive** | Class P confirmation; pull-mirror into `public-mirrors/`; community workflow untouched. |

## 9. Rollback Plan

Trigger: forge unavailability > RTO, data-integrity fault, or Steward call. Action: `harbor` remotes are re-enabled for push (tokens re-scoped), local `origin` re-pointed by inverse of §4, freeze lifted with announcement. Window: 90 days from D+0; after campaign review the path closes by design.

## 10. Top Risks

| Risk | Mitigation |
|---|---|
| Forge becomes single point of failure for everything | Backup doctrine §6; drill gates migration; peer reciprocity in the Chart. |
| LFS divergence during rehome | REQ-MIG-009 full-fetch + parity count per repo. |
| Secret leakage via history on client repos | Full-history scan before forge push; strict `sws/` ACLs. |
| Maintenance fatigue | Monthly agent-executed patch session; pinned versions; ≤ 2 h budget. |
| Half-migrated limbo | Net-new freeze at D+0 + migration tracker Base makes drift visible; Phase 5 gate closes the campaign formally. |

---
*Document 03 of 6 · Lighthouse.aDNA seed set · Mission LIGHTHOUSE-GENESIS*
