---
type: decision
adr_id: adr_011
title: "ADR-011 — Secret-Scanning & History Hygiene"
status: accepted
created: 2026-06-20
updated: 2026-06-20
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

## Consequences
- The #1 High risk moves from a label to an enforced, layered control (local hook → CI → hard pre-move gate).
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
