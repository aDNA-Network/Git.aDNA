---
adna: Lighthouse.aDNA
type: vault-spec
version: 0.1.0
status: draft-for-ratification
date: 2026-06-11
depends_on: [00_CHARTER.md, 01_ARCHITECTURE.md]
---

# Lighthouse.aDNA — Vault Specification

## 1. House-Dialect Conformance (governing rule)

Before scaffolding, the builder **inspects 2–3 sibling vaults** (recommended: `TaskForge.aDNA`, `LatticeAgent.aDNA`, `Canvas.aDNA`) and conforms to the prevailing house dialect: directory casing, frontmatter key names, WHO/WHAT/HOW realization, TaskNotes conventions, cross-vault link style, Bases syntax for the installed version. **Where this spec conflicts with house dialect, dialect wins**; every deviation from this spec is logged as an ADR with one-line rationale. This document specifies *intent and minimum structure*, not letter.

## 2. Vault Tree

```
Lighthouse.aDNA/
├── CLAUDE.md                      # agent operating contract (see §7)
├── README.md                      # orientation; carries canonical statements verbatim
├── _meta/
│   ├── charter.md                 # 00 lands here
│   ├── glossary.md                # terms table from charter §4, expanded
│   └── decisions/                 # ADR-0001-forge-selection.md, ADR-0002-…
├── _bases/                        # Obsidian Bases (see §5)
│   ├── sites.base
│   ├── repos.base                 # the migration tracker
│   ├── runbooks.base
│   └── adrs.base
├── WHO/
│   ├── roles.md                   # Keeper, Steward, agents — duties and authority
│   ├── agents.md                  # machine accounts, scopes, signing keys, rotation
│   └── sites/                     # one note per lighthouse (schema §4.1)
│       └── pharos.md
├── WHAT/
│   ├── architecture/
│   │   ├── system-overview.md     # 01 §1–2 lands here
│   │   ├── profiles.md            # 01 §3
│   │   ├── network.md             # 01 §4
│   │   ├── identity.md            # 01 §5
│   │   ├── forge.md               # 01 §6 — the git.aDNA service spec
│   │   ├── replication.md         # 01 §7–8
│   │   └── tiers.md               # 01 §9
│   ├── requirements/
│   │   └── requirements.md        # 02 lands here, canonical single source
│   ├── doctrine/
│   │   ├── repo-classes.md        # 03 §1–2
│   │   ├── migration.md           # 03 §3–5, §9–10
│   │   ├── doctrine-block.md      # 03 §7 — the verbatim propagation block
│   │   ├── backup.md              # 03 §6 expanded
│   │   └── airgap.md
│   └── canvas/
│       ├── system-map.canvas      # node anatomy + subnet topology
│       └── migration-map.canvas   # campaign phases × vault order of march
├── HOW/
│   ├── runbooks/                  # schema §4.2 — all agent-executable
│   │   ├── RB-genesis.md          # seed bootstrap, 01 §8
│   │   ├── RB-join-subnet.md      # Chart PR procedure
│   │   ├── RB-rehome-repo.md      # 03 §4 mechanics
│   │   ├── RB-mirror-setup.md     # pull/push mirror config
│   │   ├── RB-backup.md
│   │   ├── RB-restore-drill.md    # gates migration
│   │   ├── RB-upgrade.md          # monthly patch session
│   │   ├── RB-restore-identity.md # break-glass
│   │   └── RB-airgap-sync.md      # signed bundles + OCI archives
│   ├── infra/
│   │   ├── compose/               # compose.yaml + profile overrides
│   │   ├── env/site.env.example
│   │   ├── secrets/               # sops-age ciphertext only (+ .sops.yaml)
│   │   └── Makefile               # up/down/status/backup/drill targets
│   └── checklists/
│       └── genesis-dod.md         # definition-of-done, from 05 §9
└── OPS/                           # execution layer — Campaign → Phase → Mission → Session
    ├── campaign-first-light.md
    ├── missions/
    ├── sessions/
    └── patches/                   # cross-vault integration patch sets (REQ-AGT-003)
```

Execution tracking integrates with TaskForge.aDNA (tasks as TaskNotes referencing this vault); `OPS/` here holds campaign documents, session logs, and staged patches. If house dialect locates campaigns elsewhere, follow dialect (§1).

## 3. Single-Source & Transclusion Rules

Charter, architecture, requirements, and doctrine exist **once** at the paths above. Other notes embed (`![[...]]`) or link — never duplicate. The doctrine block (`WHAT/doctrine/doctrine-block.md`) is the only intentionally duplicated text in the network, and it is duplicated *verbatim*, by patch, with a `source:` frontmatter pointer back to this vault.

## 4. Frontmatter Schemas

### 4.1 Site note (`WHO/sites/<site_id>.md`)
```yaml
---
adna: Lighthouse.aDNA
type: site
site_id: pharos
tier: L2            # L1 | L2 | L3
status: genesis     # genesis | active | dark | retired
keeper: Stanley Bishop
services: [core, collab, inference, ops]
mesh_addr: ts-pharos
backup_peer: <site_id>      # REQ-BCK-004 reciprocity
joined: 2026-06-11
chart_pr: <url>
---
```

### 4.2 Runbook (`HOW/runbooks/RB-*.md`)
```yaml
---
adna: Lighthouse.aDNA
type: runbook
id: RB-restore-drill
trigger: quarterly | gate:phase-3
executor: agent      # human | agent | either
risk: high           # low | medium | high
last_drilled: null
verified_by: null
---
```
Body convention: numbered steps; each step ends with **Verify:** and an observable condition. High-risk runbooks open with a STOP gate naming who must authorize.

### 4.3 ADR (`_meta/decisions/ADR-NNNN-*.md`)
```yaml
---
type: adr
id: ADR-0001
status: accepted     # proposed | accepted | superseded
date: 2026-06-11
decision: Forgejo selected as forge engine
supersedes: null
---
```

### 4.4 Repo record (feeds the migration tracker)
```yaml
---
type: repo-record
repo: vaults/TaskForge.aDNA
class: I             # P | I | R | UNCLASSIFIED
origin: ssh://git@git.adna.network/vaults/TaskForge.aDNA.git
harbor: null         # GitHub URL for P/R; null for I
lfs: false
metadata_migration: none   # none | forgejo-migrator
status: pending      # pending | mirrored | rehomed | verified
phase: 3.2
---
```

## 5. Bases (intent specification)

Author per the installed Bases version (§1). Required views:

| Base | Source | Columns | Default filter/sort |
|---|---|---|---|
| `sites.base` | `WHO/sites/` | site_id, tier, status, keeper, services, backup_peer, joined | status ≠ retired; sort tier |
| `repos.base` | repo records | repo, class, status, phase, lfs, harbor | group by status; sort phase — **this is the migration tracker** |
| `runbooks.base` | `HOW/runbooks/` | id, trigger, executor, risk, last_drilled | sort risk desc |
| `adrs.base` | `_meta/decisions/` | id, status, date, decision | sort id desc |

## 6. Canvases (Canvas.aDNA-conformant JSON Canvas)

- **system-map.canvas** — node groups: *Edges* (mesh/public planes) → *Identity* → *Forge* → *Collab* → *Inference* → *Ops*; second cluster for subnet topology (flagship, sites, airlock, harbor). Mirrors 01 §2 and §7.
- **migration-map.canvas** — lanes per campaign phase; cards per vault from §2 of doctrine; card color by repo-record status.

## 7. CLAUDE.md — Agent Operating Contract (minimum content)

**Autonomous (no gate):** read everything; create/edit `OPS/sessions/`; update repo-record statuses after verified actions; run runbooks marked `risk: low, executor: agent`; lint/validate; draft patches into `OPS/patches/`.

**Gated (explicit Keeper go, per action):** any change under `HOW/infra/`; any change to git remotes anywhere; executing `risk: medium|high` runbooks; anything touching `HOW/infra/secrets/`; applying patches outside this vault; any GitHub API call that is not read-only.

**Prohibited:** plaintext secrets in any file; deleting repos or history; creating internal repos on GitHub (doctrine block); silent cross-vault writes (REQ-AGT-003).

**Session protocol:** every working session logs `OPS/sessions/<date>-<slug>.md` (objective, actions, verifications, hand-off); commits are phase-scoped, conventional (`genesis(phase-N): …`), SSH-signed, `Agent:` trailer.

## 8. Linking Doctrine

Wikilinks within the vault. Cross-vault references use the house convention discovered in §1; absent one, use the forge web URL (`https://git.adna.network/vaults/<vault>/src/...`) so links survive outside Obsidian. Every propagated doctrine block links back here as `source`.

---
*Document 04 of 6 · Lighthouse.aDNA seed set · Mission LIGHTHOUSE-GENESIS*
