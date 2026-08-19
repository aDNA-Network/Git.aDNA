---
type: coordination
title: "Coord — ADR-016 Remote & Host Doctrine (Exchange application): confirm-or-amend the classification + mirror/App posture (Exchange triad → Git.aDNA)"
created: 2026-07-11
updated: 2026-07-11
last_edited_by: agent_berthier
acting_persona: [themis, mnemosyne]
status: routed             # operator-released ⛩ G2 2026-07-11; delivery state per Routing log
direction: outbound
from_vault: Exchange.aDNA
to_vaults: [Git.aDNA]
to_personas: [grace_hopper]
cc_vaults: [aDNA.aDNA]
blocks: none
ack_required: true         # confirm-or-amend at your cadence; decline-eligible
origin_mission: campaign_operation_caduceus C2.9
references: [what/decisions/adr_016_remote_host_doctrine.md, recon/caduceus_recon_dossier.md]
tags: [coordination, rule_10, staged_held, host_doctrine, adr_013, mirror, github_app, canonicity, caduceus]
---

# Coord — ADR-016: the Exchange's application of your host doctrine

> **Rule 10**: authored + staged Exchange-side; a copy lands in `Git.aDNA/who/coordination/` only on operator-authorized routing (Caduceus G2) at your quiescence. **Federate, never duplicate** — ADR-016 *applies* your ADR-013/ADR-006; it re-authors nothing.

## Ask (one line)

**Confirm-or-amend Exchange ADR-016** (`Exchange.aDNA/what/decisions/adr_016_remote_host_doctrine.md`, `proposed`) — our vault-side application of Git.aDNA ADR-013 (host-role inversion) + ADR-006 (remote naming) to the Exchange's repos, mirror posture, GitHub-App boundary, and the registry's host-agnostic entry shape.

## The five points you'd check (all cited to your law)

1. **Classification**: `Exchange.aDNA` = FOSS-in-dev → Codeberg-private origin (as-is, correct); R-shaped at release (private-canonical + `mirror` on tags, your ADR-006 D2); `aDNA-Network/aDNA` = Class-P GitHub-public confirmed. Seed **P/R/I + `harbor` translated, never written as live doctrine** (ADR-016 b — permanent translation table).
2. **Canonicity finding closed**: seed "git.aDNA canonical" = bannered-superseded (your `adr_001_seed_docs_reframe`); "Codeberg canonical" = class-scoped current truth; `pharos`/P7 = north star. Recorded Exchange-side at ADR-016 (f); our CLAUDE Standing Order 5 gains the class-scoped phrasing on ratification.
3. **Mirror posture**: Forgejo-native push-mirror per your `skill_release_mirror` (draft), exercised at first release per your ADR-013 D4 — `designed-not-built` until then. New use we're adding: the **signed-tree-head checkpoint file** rides the canonical repo + the GitHub `mirror` as a **replication witness** (never a trust claim — our §10c).
4. **GitHub App boundary** (`adna-exchange-ingest`, designed-not-built): `contents:read` + webhooks, install-per-repo, no org grants, ingestion-only — it never touches origin/mirror mechanics you own.
5. **Host-agnostic registry entries** (`remote URL + ref + CID` + host_class): user graphs publish from **any** host, first-class; integrity from content addressing + our transparency log, never the host. No Exchange canonical origin migrates anywhere.

## Non-asks

No change requested to any Git.aDNA artifact; no mirror configured now; the template-corpus rename drift we found (dead `LatticeProtocol/latlab` URLs etc.) routes to **Rosetta's** template-release lane, not to you.

## Reply

Confirm-or-amend → `Exchange.aDNA/who/coordination/` at your cadence; a decline with a named reason is a complete answer.

## Routing log

- Released ⛩ G2 (operator, 2026-07-11) per `gates/gate_g2_halt_package.md` §D.
- **Delivered** → `Git.aDNA/who/coordination/` 2026-07-11 (quiescence probe clear; copy left untracked peer-side — their commit is theirs).
