---
type: decision
adr_id: adr_011
title: "ADR-011 — Secret-Scanning & History Hygiene"
status: accepted   # base ADR + A1 accepted; Amendment A2 (2026-08-19) is `proposed` pending operator ratification
created: 2026-06-20
updated: 2026-08-19
last_edited_by: agent_stanley
ratifies_at: "authored + ratified at the P2-exit gate (2026-06-20)"
depends_on: [adr_005, adr_006, adr_009]
tags: [decision, adr, adr_011, git, security, secret_scan, history_hygiene, migration, gitleaks, binding, accepted]
---

# ADR-011 — Secret-Scanning & History Hygiene

**Status**: `accepted` (genesis **P2**, 2026-06-20; ratified at the P2-exit gate). Added in the P2-exit revision pass to architect the campaign's **#1 High risk** — history secret-leakage during host migration — which prior ADRs referenced only as a label. Depends on [[adr_005_visibility_host_policy|ADR-005]] (D7 migration), [[adr_006_remote_naming|ADR-006]] (D3 host-move), [[adr_009_dev_process_doctrine|ADR-009]] (D3 dev-process). Covers seed REQ **MIG-006 / SEC-002**.

## Context
[[adr_005_visibility_host_policy|ADR-005]] D7 and [[adr_006_remote_naming|ADR-006]] D3 both gate a host move on a "secret scan / history-scan," and the campaign risk register flags **secret leakage in history during host migration (client repos)** as a **High** risk — but no ADR defined the *mechanism* (tool, verb, gate-owner, remediation). A label is not a control. This ADR binds it. (The fleet includes I-strict client/clinical repos — CakeHealth, PercySleep, SuperLeague, CakeProtocol, MagnaPetra — where a leaked secret in history is the most expensive failure mode.)

## Decisions

### D1 — Tool-of-record: `gitleaks` (default)
**`gitleaks`** is the default secret scanner (fast, broad default ruleset, runs pre-commit/pre-push **and** in CI, host-neutral). `trufflehog` is an **optional deep/verified-secret adjunct** for I-strict repos (live-credential verification), not the default. Same tool drives all three layers below.

### D2 — Pre-push hook (continuous hygiene)
Every code-home installs a `gitleaks` **pre-push hook** (scans the outgoing diff) — catches a secret *before* it reaches shared history. Shipped via the `git/` wrapper + the [[adr_009_dev_process_doctrine|ADR-009]] D6 doctrine block (P3 installs).

### D3 — CI scan (defense in depth)
A `gitleaks` **CI job** runs on pushes/PRs on **both backends** ([[adr_008_ci_cd_parity|ADR-008]] — `.github` + `.forgejo`, portable-first) — catches what a local hook misses.

### D4 — Hard pre-move full-history gate (binding)
Before **ANY** host move (origin change or mirror add — [[adr_006_remote_naming|ADR-006]] D3), a **full-history scan** (`gitleaks detect` over all refs/history) **MUST pass**. This is the mechanism behind [[adr_005_visibility_host_policy|ADR-005]] D7 "history-scan before any move."
- **I-strict** client/sensitive repos require **operator sign-off** on the scan result before the move proceeds.
- A move is **blocked** until the history scan is clean. No "push anyway."

### D5 — Remediation (binding)
A finding blocks the move. Remediate by purging the secret from history with **`git-filter-repo`** (preferred) or **BFG**, then **rotate the exposed credential via the Home.aDNA broker** ([[adr_007_credential_model|ADR-007]] D4), re-scan to confirm clean, and only then proceed. A purge rewrites history — coordinate via the shim registry ([[adr_006_remote_naming|ADR-006]] D4) and (if the repo already has consumers) a coord memo (Rule 10).

### D6 — Ownership & boundary
The **migrating agent** runs the scan; the **operator** gates I-strict moves; **Home.aDNA** holds credential rotation ([[adr_007_credential_model|ADR-007]]) and the shim registry. Git.aDNA owns the **scan doctrine + the pre-move gate verb**; it never stores secrets. Tooling specifics (hook install, CI-job YAML, allowlist/baseline policy) → **P3**.

## Amendment A1 — First-share host-move-class gate (accepted 2026-08-08)

*Adopts Berthier's 2026-07-20 proposal ([[../../who/coordination/coord_2026_07_20_berthier_to_gracehopper_first_share_host_move_gate|memo]]) verbatim-in-substance; operator blanket ruling approval 2026-08-08. Track record pre-adoption: run twice under HQ local binding; caught a real finding (an operator residential IP in Fluxer's history).*

**First share of any repo with a new external party is a host-move-class event.** Before the grant (or the first push of a shareable projection):
1. a full-history `gitleaks` scan over all refs **MUST pass** (D4 mechanics apply — allowlist/baseline subtraction only for individually-triaged, documented-FP classes);
2. **I-strict** repos additionally take **operator sign-off** on the scan output;
3. **collaborator management** (add / remove / change-role) joins the **outward-gated verb set** (Git-Ops #3 — never improvised). The provider-contract verb list grows a `manage-collaborator` entry at the next tooling pass.

"New external party" includes a new *host* whose readership differs from the current host's (a mesh forge with subnet members is a share to those members — the [[adr_014_mesh_remote_role|ADR-014]] D1 first-push case).

## Amendment A2 — D2 fail-closed range-scan (resolves F-S158-01) — `proposed` 2026-08-19

*Resolves **F-S158-01** (Berthier S158/S160/S161; Venus's 2026-07-11 upstream finding, delivered by proxy at `7b804d0` — both defects reproduced first-hand by HQ). The shipped D2 skeleton (`how/federation/git/hooks/pre-push.gitleaks.sh`, md5 `216aaca254b97d69819562d506afca29`, nine installed copies) is a proven no-op: it scans the **staged** diff (`gitleaks git --pre-commit`), which is empty at push time, so it exits clean having examined nothing; and it warns-and-passes when gitleaks is absent — so the launchd PATH fix converted a silent skip into a silent pass. Ratification: **decision** = A2 as written · **ratified-by** = operator · **date** = pending · **status** = `proposed`.*

1. **D2's mechanism is corrected to match its text.** The pre-push hook scans the **actual outgoing range**: it reads the stdin refs (`<local-ref> <local-sha> <remote-ref> <remote-sha>`, githooks(5)), skips deletes, and scans `gitleaks git --log-opts="<remote-sha>..<local-sha>"` per ref; new refs scan `<local-sha> --not --remotes`, degrading to full history when no remote-tracking refs exist — expensive but fail-safe, never silently narrower. Requires gitleaks ≥ 8.19.
2. **Fail-closed.** A missing scanner **blocks the push** (exit 1, install hint, deliberate-bypass pointer) — removal of the tool may never silently remove the layer. The skeleton's "P6 hardens to block" promise is discharged here.
3. **Skeleton v2 = Venus's hardened reference implementation** (`Network.aDNA/how/code/hooks/pre-push-secret-scan.sh`) adopted wholesale with credit — already self-tested downstream (clean range passes · planted `ghp_` token blocks exit 1 · scanner-absent blocks exit 1). It preserves the config search order verbatim (`$GITLEAKS_CONFIG` → `git/.gitleaks.toml` → root `.gitleaks.toml`), so F-W3-a arrangements resolve identically.
4. **Validation standard: the induced positive.** No install of v2 is recorded as done until a planted secret in a **pushed** (not staged) commit has been demonstrated to block. A scan that has never been shown to fail is the same class of artifact as a monitor that has never fired.
5. **Rollout + caveat retirement.** After Git.aDNA validates v2 (induced positive), consumers install on Hopper's notice via their `git/` wrappers (HQ/Operations coordinate the nine enrolled vaults); the fleet-wide "`scan-ok` means the hook ran, not that the range was scanned" caveat retires **per-vault** on verified install, not globally on announcement.

## Consequences
- The #1 High risk moves from a label to an enforced, layered control (local hook → CI → hard pre-move gate).
- (A2) F-S158-01 closes on the induced-positive demonstration; ten vaults stop pushing nightly on a scan that does not run.
- P6 waves cannot start a host move on a repo until its history scan is clean — the gate is mechanical, not advisory.
- `repo-migrate` (P3 skill) embeds D4 as a precondition; the doctrine block (ADR-009 D6) gains a scan line.

## Open questions carried forward (→ P3)
- Allowlist/baseline management (false positives; committed-test-fixtures policy).
- Scan performance on large/LFS repos (note: `DataRoom.aDNA` is Class **L** / never-push, so out of the migration path entirely).
- When to escalate an I-strict repo from `gitleaks` to `trufflehog` verified-secret mode.

## Alternatives considered
- **No scan / manual eyeballing** — rejected: the High risk demands a mechanical gate.
- **CI-scan only (no pre-move history gate)** — rejected: by CI time the secret is already on the host; the hard gate is the point.
- **`trufflehog` as default** — rejected: heavier; `gitleaks` is the standard fast default. `trufflehog` stays the deep-verify adjunct.
