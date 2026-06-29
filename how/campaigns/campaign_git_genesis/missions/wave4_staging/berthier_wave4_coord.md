---
type: coordination
coord_id: berthier_wave4_coord
title: "Git.aDNA → Berthier (aDNALabs/WS-1): Wave-4 nested code-repo federation boundary"
created: 2026-06-27
updated: 2026-06-27
status: delivered        # DELIVERED 2026-06-29 → aDNALabs (coord_2026_06_29_inbound_from_hopper_git_wave4_federation_boundary.md; aDLabs commit 56ed23e); operator approval = cross-persona ack
last_edited_by: agent_stanley
from_persona: hopper      # Git.aDNA
to_persona: berthier      # aDNALabs.aDNA — the GitHub-org migration program (Operation Homecoming / WS-1)
also_for: hestia          # Home.aDNA — §Home (legacy-remote + origin records, Rule 9)
campaign: campaign_git_genesis
phase: P6
wave: 4
tags: [coordination, git, wave4, nested_code_as_what, ws1, ownership_boundary, staged, operation_free_harbor]
---

# Git.aDNA → Berthier — Wave-4 nested code-repo federation boundary

**TL;DR.** Git.aDNA's R2/P6 **Wave 4** is the nested **code-as-WHAT** repos. A live re-probe shows your **WS-1 pilot already host-moved** three of them and the **Harness team already fully federated** a fourth — so Wave 4's real residue is the **Git.aDNA federation *touch*** (the `git/` declaration + `## Git-Ops` doctrine + gitleaks hook + CI-parity), **not** a host move. This memo records that ground truth, fixes the ownership boundary, and asks for two things: a per-repo federation pass (in lockstep with your program) and **one host-decision** (`moleculeforge`).

## What WS-1 / Harness already did (Git.aDNA records this — does NOT redo it)
| Repo | Your action | Evidence |
|---|---|---|
| `lattice-protocol` · `latlab` · `moleculeforge` | host-moved `LatticeProtocol`→`aDNA-Network` (old origin kept as a **`legacy`** remote) | WS-1 pilots (`aDNALabs …/history/2026-06/session_*_ws1_{latlab,moleculeforge}_pilot.md`) |
| `harness` → `adna-harness` | first-remote `aDNA-Network/adna-harness` (private, class I) + portable CI + `git/` wrapper committed into the repo | `Harness.aDNA …/session_20260625_gitadna_wave4_harness_code_federation.md` (completed 06-26); "WS-1 pilot #4" |

`harness` is the **exemplar** — Git.aDNA's [[wave4_runbook]] generalizes exactly that pattern to the rest.

## Ownership boundary (per Git.aDNA charter: "we supply patterns; you run the org-level program")
- **Berthier / WS-1 owns:** per-repo **host execution** (org placement, transfers, `legacy`/rollback remotes, the Homecoming program cadence).
- **Git.aDNA / Hopper supplies:** the **federation pattern** (the in-repo `git/` wrapper + `## Git-Ops` + gitleaks hook + CI-parity), the secret-scan gate, and the dispatch lib. The federation touch is **`gitops_push` to the existing origin** — no host move, no new remote (except the one open `moleculeforge` decision).

## Ask #1 — federation touch on the 5 pending repos (coordinate, then fire per-repo at the DP5 gate)
`contextscope` · `lattice-protocol` · `latlab` · `latlab-lab` (4a) + `moleculeforge` (4b, conditional). Per repo: the harness-exemplar artifacts (committed INTO the repo) → dogfood push to the existing origin → verify private/anon-refused. Pre-clear scans done (2026-06-27): `contextscope`/`lattice-protocol`/`latlab-lab` clean; `latlab` (15) + `moleculeforge` (71) **all false-positive** → tight allowlists staged + validated. **Holds:** `latlab` (5-dirty) + `moleculeforge` (active-dev) until quiet.

## Ask #2 — `moleculeforge` host-decision (the one open call — F-W4-e)
WS-1 placed `moleculeforge` on **GitHub-`aDNA-Network`** (class **I**). But its parent `Molecules.aDNA` is **P-dev → Codeberg-private** (Wave 1b). Does the nested code repo **stay GitHub-I** (matching WS-1 + the `harness` Apache-2.0→classified-I precedent) or **follow the parent → Codeberg-P-dev**? Recommend **stay GitHub-`aDNA-Network` / class I** for now (lowest-churn, matches the live WS-1 state + the harness precedent; a release-time reclassification I→P stays available). Your call at the gate.

## §Home (Hestia, Rule 9 — origins + legacy-remote records)
Register in the shim/origins registry (records, not new shims by Git.aDNA):
- `adna-harness` → new origin `aDNA-Network/adna-harness` (private; first-remote 06-26).
- `legacy` remotes (WS-1 rollbacks): `lattice-protocol`·`latlab`·`moleculeforge` each carry `legacy → github.com/LatticeProtocol/<repo>` — record + set a retire-condition (WS-1 owns retirement).
- A new §C shim is needed **only if** `moleculeforge`→Codeberg (host-move) — otherwise none (origins unchanged).

## Status
**DELIVERED 2026-06-29** → aDNALabs `who/coordination/coord_2026_06_29_inbound_from_hopper_git_wave4_federation_boundary.md` (+ index row; stage-only-mine; aDLabs commit `56ed23e`, unpushed — Berthier's cadence). Operator approval at the Wave-4 full-fire DP5 gate = cross-persona ack. Fired that gate: 4a `contextscope`+`latlab-lab` + 4c `dataroom` (L); **`moleculeforge` HELD** (live collision F-W4-g; **Ask #2 RESOLVED = GitHub-I**); `latlab` held (5-dirty). **(Prior:)** **STAGED** in Git.aDNA (Rule 10 — not written into aDNALabs/Home). **Update 2026-06-27:** the **4a canary `lattice-protocol` ✅ FIRED** (`47935b6`, private, anon-refused, hook clean) at the DP5 gate under **operator approval = Berthier cross-persona ack** (the Wave-3b precedent — aDNALabs was busy: 1 session + 3 dirty, so this memo's *delivery into aDNALabs* stays HELD until it's quiet). Deliver + ack the remaining 4a (`latlab-lab`/`contextscope`/`latlab`) + 4b (`moleculeforge`, class I per Ask #2) touches at their gates.
