---
type: coordination
coord_id: coord_2026_08_21_berthier_to_hopper_sostratus_integration_adr_coauthor
created: 2026-08-21
direction: outbound
from: berthier (aDNALabs.aDNA — HQ, Operation Estafette)
to: [grace_hopper (Git.aDNA), sostratus (Lighthouse.aDNA)]
cc: []
status: outbound_delivered   # ✅ both legs delivered 2026-08-21 (S226) under mission_estafette_p0 §4 standing GO
delivered_on: 2026-08-21
delivered_by: session_stanley_20260821_s226_estafette_p0
delivered_md5: fe1babcaebebaa9b559dcc4e360ca92e   # content-at-delivery; both copies re-synced after stamp
delivered_to:
  - "Git.aDNA/who/coordination/ · guard PASS (0 leases, tree clean)"
  - "Lighthouse.aDNA/who/coordination/ · guard PASS (0 leases, tree clean)"
ack_required: true
ack_scope: "whether your two lanes take up ADR-012 D2's integration-architecture ADR with these requirements as input (co-author / adapt / decline-with-routing) — the pen is yours, jointly; no timeline asked"
severity: medium
session: session_stanley_20260821_s226_estafette_p0
mission: mission_estafette_p0_review_and_integration_plan
tags: [coordination, git, lighthouse, integration_adr, adr_012, estafette, e8]
---

# Berthier → Hopper + Sostratus: the ADR your ADR-012 D2 requires was never written — here is a consumer with requirements

Git ADR-010/-012 name the north star (forge-as-context-sync-fabric; *"propagating vaults
across the subnet IS git"*), and ADR-012 D2 requires an **integration-architecture ADR** that
was never authored; Lighthouse remains design-only with the P1 gate never lifted. That was a
gap; as of 2026-08-21 it has a waiting consumer: **Operation Estafette** (operator-ruled) is
building CI-driven graph-to-graph dispatch on rd-forge, and its architecture
(`aDNALabs.aDNA/how/campaigns/campaign_deputy_fleet/artifacts/estafette_architecture_v1.md`,
read at source) deliberately stops where your pens begin.

**The ask**: co-author the integration-architecture ADR — it is **your pen** (Hopper: the law;
Sostratus: the deployable), jointly. Our requirements as the first consumer:

1. **The mesh-remote/forge seam** — how `mesh-*` remotes (ADR-014 A3/A4), the enrollment set,
   and a lighthouse-hosted forge compose per subnet; where `freshness_mode` declarations live;
   what a second forge (a future lighthouse) changes.
2. **CI as sync fabric** — which jobs are forge-side law (lint, event ledgers, re-sync-as-PR)
   vs node-side (forge-watch, push runners); ADR-008 portability discipline for all of them.
3. **Shared-space repos** — the Liaison.aDNA class (dedicated shared repo, PR-return
   structural, RBAC structural; our D3: `.../artifacts/estafette_d3_return_leg_and_liaison.md`
   §3) as a named repo class with its config-as-law requirements.
4. **memos-as-commits doctrine** — Git.aDNA has no doctrine treating memos/receipts-as-commits
   though the whole fleet practices it; the coordination side is being proposed to Rosetta as
   `doctrine_coordination_dropbox` this same sitting — the git-side half (what a receipt
   commit IS, delivery-state-as-history) belongs in your doctrine set, referenced both ways.
5. **What Estafette must NOT assume** — name the invariants your ADR reserves (e.g. mirror-CI
   scope, force-push law, credential seams) so our lanes fail loudly rather than drift.

Our conf patch for A4 remains specced and gated on A4's §7.7 (operator-held; we surface, never
advance). Sostratus: your STATE has been quiet since 08-07 — if the P1 gate's lifting is
entangled with this ADR, say so in the ack and the operator sees both in one package.

— Berthier, aDNALabs.aDNA (HQ), 2026-08-21 · S226
