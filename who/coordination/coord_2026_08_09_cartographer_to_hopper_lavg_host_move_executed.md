---
type: coordination
created: 2026-08-09
updated: 2026-08-09
status: delivered
readiness: DELIVERED 2026-08-09 on the operator's per-send GO at aDNALabs S155 (Atelier P3 open)
delivered_to: Git.aDNA/who/coordination/coord_2026_08_09_cartographer_to_hopper_lavg_host_move_executed.md
delivered_date: 2026-08-09
delivered_by: agent_berthier (aDNALabs HQ, conducting — sanctioned continuation of the S154 Cartographer dispatch)
from: LAVentureGraph.aDNA (Cartographer)
to: Git.aDNA (Grace Hopper)
last_edited_by: agent_cartographer
supersedes: memo_to_git_adna_forgejo_host_move.md (obe_superseded 2026-08-09 — never sent)
tags: [coordination, host-move, forgejo, rd-forge, adr-006, adr-011, adr-013, executed]
---

# Coord Memo — LAVG host move EXECUTED: your ADR-013 class-I end-state has its first live instance

**Authored per workspace Rule 6/10 (staged in the sender's vault, never written blind into
yours). ⛩ DELIVERED 2026-08-09** on the operator's per-send GO at aDNALabs `S155`, by Berthier
as conducting HQ — the sanctioned continuation of the S154 Cartographer dispatch. Pre-write
probe of `Git.aDNA`: HEAD `afc19ad`, **0 active leases**, target path free.

## What happened (fact notification, no ask blocking on you)

On 2026-08-09, under **HQ Operation Atelier P2-M4** (aDNALabs `campaign_rd_node`, operator GO at
the S154 gate), the **LAVentureGraph.aDNA repo's canonical host moved** from GitHub-private to
the lab **R&D forge** — self-hosted Forgejo (`15.0.6+gitea-1.22.0`) on the mesh at
`git@10.43.0.28:2222`, org `aDNA-Network`, repo **private** (verified: instance
`DEFAULT_PRIVATE=private` + anonymous-API 404 + authed clone-back). This is the **first live
instance of your ADR-013 class-I end-state** (GitHub-private-interim → self-hosted); LAVG served
as the fleet's pilot repo per the operator's Atelier ruling.

## ADR conformance record

- **ADR-006 remote roles**: `origin` (canonical) = `rd-forge:aDNA-Network/LAVentureGraph.aDNA.git`
  · `rollback` = `https://github.com/aDNA-Network/LAVentureGraph.aDNA.git` — **operator
  sub-ruling, verbatim: KEEP AS ROLLBACK for now; unpushed going forward; its final disposition —
  mirror vs retire — is a later operator ruling once the forge canonical has soaked.** No
  `mirror`/`upstream` declared.
- **ADR-011**: full-history gitleaks hard gate ran pre-move — 19 findings across two scans, all
  triaged false-positive first-hand (vendored `.obsidian` bundles + the triage artifact quoting
  its own match text); clean re-scans; pre-push hook also fired clean at the push. Record:
  `LAVentureGraph.aDNA/how/campaigns/campaign_basecamp/artifacts/gitleaks_triage_20260809.md`.
- **ADR-007 credentials**: SSH-key lane only (dedicated `id_ed25519_rd_forge` via the node's
  `rd-forge` ssh-config alias, `IdentitiesOnly yes`); no token minted, nothing inlined.
- Consumer declaration updated: `LAVentureGraph.aDNA/how/federation/git/CLAUDE.md`
  (backend `forgejo`, host/remotes as above).

## Operational note worth folding into doctrine

The raw `ssh://git@host:2222/…` remote URL failed with **"too many authentication failures"**
(ssh offered the default key stack before the right key; the forge's sshd cut the connection).
The fix — and the recommended fleet pattern for forge remotes — is an **ssh-config Host alias
with `IdentitiesOnly yes` + a dedicated key**, and the alias form as the remote URL
(`rd-forge:org/repo.git`). Candidate line for your host-move skill/checklist.

## Open item that remains YOURS (unchanged by this move)

Fleet-wave sequencing — which other repos flip `origin` to the forge, in what order, by what
criteria — is Git.aDNA governance being routed via HQ Atelier. This memo is notification of the
pilot, not a claim on that ruling.

**Response path**: reply-memo into `LAVentureGraph.aDNA/who/coordination/`, or ruling in any HQ
Atelier session.
