---
type: session
session_id: session_stanley_20260819_git_fix_the_scan
created: 2026-08-19
updated: 2026-08-19
status: completed
last_edited_by: agent_stanley
campaign: campaign_git_genesis
phase: R3/P7 (standing-quality: F-S158-01 remediation + A1 allowlists)
start_head: 6531fb3
plan: ~/.claude/plans/please-read-the-claude-md-fancy-goblet.md (Session B)
tags: [session, f_s158_01, skeleton_v2, induced_positive, allowlists, adr_011_a2, operation_free_harbor]
---

# Session — "Fix the Scan": skeleton v2 + induced-positive validation + A1 allowlists

> Continuation of the R3-pivot sitting (operator: ratify all four · push now · continue). Ground truth at open: Git.aDNA's own `.git/hooks/pre-push` was ALREADY Venus's hardened hook (md5 `f255e2a0…`, mtime 08-18 — evidenced on the `3e68b41..6531fb3` push); the **shipped skeleton** was still defective v1 (`216aaca2…`) — the gap was in what the nine consumers copied, not in this repo's own gate.

## Work log
- [x] **Skeleton v2 shipped** — `how/federation/git/hooks/pre-push.gitleaks.sh` (root `git/hooks/` copy same-inode, both updated), md5 **`a1288f7371afa187cb1cfd8b9810a669`**; Venus's implementation wholesale, Git.aDNA-canonical header (ADR-011 A2 provenance + install + validation standard); `--self-test` PASS (gitleaks 8.30.1).
- [x] **Induced-positive drill 3/3** (scratchpad `induced_positive_drill/`, throwaway bare remote + work repo, v2 installed as `.git/hooks/pre-push`):
  - T1 planted secret (runtime-assembled `ghp_…`) in a **pushed** (committed, not staged) commit → **BLOCKED exit 1** ✓
  - T2 clean push → **PASSED** (`gitleaks clean across 1 outgoing range(s) ✓`) ✓
  - T3 scanner absent (`PATH=/usr/bin:/bin`, the launchd class) → **BLOCKED exit 1** ✓
- [x] **A1 allowlists validated to 0** — pre-clear reproduced Ilmarinen's result exactly (configless full-history scan: 71 commits, **11 findings** = 9× `.obsidian/plugins/terminal/main.js` F-W3-b + 2× `wave4_runbook.md:84` F-W4-b); staged F-W4-b `Ed25519PrivateKey` (`regexTarget="match"`) into `git/.gitleaks.toml` (F-W3-b fold already present since 06-24); **re-scan with config: 71 commits, 0 findings**.
- [x] Notices delivered peer-side (cmp-verified): **Berthier/Operations install notice** (9-vault rollout; per-vault caveat retirement; F-S158-01 → RESOLVED-at-source) · **Rosetta release-batch fold** (9th lib fix).
- [x] STATE R3 callout finalized · CHANGELOG v0.33 · close · push.

## SITREP
**F-S158-01 is resolved at source, with the evidence class Berthier demanded.** Skeleton v2 (Venus's fail-closed outgoing-range implementation, adopted wholesale under ratified ADR-011 A2) replaces the no-op v1 in the shipped wrapper; the induced positive has fired (planted secret in a pushed commit BLOCKED), clean pushes pass, and a missing scanner now blocks instead of silently passing. Git.aDNA's own A1 first-share gate is green: 11 documented-FP findings → 0 on the staged config. Residual = the nine-vault install (Operations noticed; caveat retires per-vault on verified md5 `a1288f73…`). Rosetta's release batch grows to 9 fixes so every future fork gets v2. Findings: **F-R3-b** — Git.aDNA's own `.git/hooks/pre-push` had been quietly upgraded to Venus's hook (08-18) while the shipped skeleton stayed defective: an install≠skeleton divergence the md5-in-nightly-log recommendation makes visible. **F-R3-c** — the 08-11 A1 gate scan ran configless, re-raising 9 findings the shipped baseline had already folded on 06-24; gate scans must resolve config the same way the hook does.

### AAR
- **Worked**: adopting Venus's implementation wholesale (per ruling) collapsed fix+validation into one sitting; the 3-test drill matrix (positive/clean/absent) is a reusable validation harness — T1 is the "monitor that fired".
- **Didn't**: nothing failed in-session; the residual risk is rollout lag across the nine vaults (out of this vault's hands, Operations-scheduled).
- **Finding**: F-R3-b (installed-hook vs shipped-skeleton divergence is invisible without md5 provenance) · F-R3-c (configless gate scans re-raise folded FPs).
- **Change**: skeleton v2 shipped + validated · `git/.gitleaks.toml` A1-complete · 2 notices delivered · CHANGELOG v0.33.
- **Follow-up**: verify per-vault v2 installs as Operations reports (md5 check); P7a design block next; tooling-cascade debt unchanged.

### Next Session Prompt
"Continue the campaign." Resume-Here = **R3/P7 — "Lighthouse Addressing" (P7a design block)** per the mission card `p7a_integration_architecture.md`: TLS `git.<subnet>.adna.network` on 443 (retires the Exchange's ADR-038 §2.7 four-part egress downgrade — weeks-out commitment given to Ilmarinen 2026-08-19), identity-bridge interim posture (Forgejo OAuth2 no-scope-enforcement ⇒ first-party-apps-only), context-sync reconciliation with Network's tarball ceremony, → the joint integration ADR with Venus (exit gate). Also author the cross-node mesh-mirror pattern doc (Archimedes' dogfood offer accepted) and scope P7b objectives 4–5 with Ilmarinen. Check first: amendment-ratification fan-out landed (Berthier runner patch after A2? per-vault v2 installs?); standing waves fire only at explicit DP5 gates.
