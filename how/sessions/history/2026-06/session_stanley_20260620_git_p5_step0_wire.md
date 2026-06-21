---
session_id: session_stanley_20260620_git_p5_step0_wire
type: session
tier: 1
created: 2026-06-20
updated: 2026-06-20
status: completed
operator: stanley
last_edited_by: agent_stanley
campaign_id: campaign_git_genesis
mission_id: p5_codeberg_beachhead
started: 2026-06-20T19:40:44-0700
completed: 2026-06-20T19:52:03-0700
intent: "R1/P5 Step 0 (non-outward, operator-chosen): wire the live dispatch path in gitops_dispatch.sh (LIVE-STUB -> real gh/curl execution, auth out-of-band, fail-loud, idempotent); author (do-not-run) a gated live-smoke harness; settle SD-1 (Git.aDNA -> public/codeberg.org/class P) in its own git/ wrapper; record in STATE+CHANGELOG; local commit. No outward actions, no .adna/ edits, no cross-vault writes."
tags: [session, campaign, git, p5, step0, dispatch, live_wiring, sd1, operation_free_harbor]
files_modified:
  - how/skills/lib/gitops_dispatch.sh
  - how/tests/livesmoke_gitops.sh
  - git/CLAUDE.md
  - STATE.md
  - CHANGELOG.md
  - CLAUDE.md
---

# Session: Git.aDNA — P5 Step 0 (Wire Live Dispatch Path) + SD-1

**Campaign**: campaign_git_genesis — Operation Free Harbor · **R1/P5 Step 0** (non-outward)

## Intent
Operator resume ("read the claude.md and continue the campaign"). State on entry: genesis-planning **P0–P4 ✅**, `campaign_gitops_rollout` ratified, Resume-Here = **R1/P5 Codeberg-FOSS beachhead (first outward)** — hard-gated on Rosetta skill-release + Hestia `CODEBERG_TOKEN` + operator DP4 (both external gates verified **not landed** this session). Per AskUserQuestion the operator chose **"Wire live path (non-outward)"** + **SD-1 = public→Codeberg/class P**. This session did the only P5 work that crosses no gate. Approved plan: `~/.claude/plans/please-read-the-claude-md-kind-eclipse.md`.

## SITREP
**Completed** (all non-outward, local-only):
- **Primary — Step 0 live dispatch WIRED.** `how/skills/lib/gitops_dispatch.sh`: `_gitops_emit` → dual-channel `_gitops_run <label> <PLAN> -- <argv>`. Dry-run prints the PLAN verbatim (every harness substring preserved); `GITOPS_ALLOW_LIVE=1` dispatches **real** executors — Forgejo `_gitops_api` (curl `--config`-stdin auth, idempotent 409/422, fail-loud non-2xx, error redaction), GitHub `gh api`, git `set-remote`/`push` (auth via `http.extraHeader` env-config — never argv/`.git/config`), `port-ci` (local CI-template copy), + smoke-only `_gitops_delete_repo`. Token discipline per ADR-007 D3.
- **Live-smoke harness authored (NOT run).** `how/tests/livesmoke_gitops.sh` — outward create→push→release→clone→delete on `aDNA-Network/_smoke`, **triple-gated** (`GITOPS_ALLOW_LIVE=1` + `GITOPS_SMOKE=1` + token). All three refusal paths verified to exit 3 before any network.
- **SD-1 ratified** in `git/CLAUDE.md`: own `git_provider` → `codeberg.org` / `forgejo` / **public** / **class P** (was private/GitHub/I); `origin` stays BLANK (P5 dogfood). Added an SD-1 note.
- **Recorded**: STATE QUEUED block (Step 0 WIRED + SD-1) + intake log; CHANGELOG v0.10; CLAUDE.md frontmatter version 0.9→0.10 (governance-version sync).
- **Verification**: dry-run gate **19/19** (final); gitleaks working-tree scan (2.04 MB) **no leaks**; live token-guard re-verified to fire **before any network under bash AND zsh** (curl stubbed).

**Findings**:
1. **Portability defect, self-corrected (the session's key finding).** The first guard test ran under **zsh** (this node's default shell), where the bash-only `${!name}` indirect token read is a "bad substitution" — it bypassed the empty-token guard and let **one unauthenticated POST reach `codeberg.org/api/v1/.../repos` → HTTP 401** (no token present, **nothing created**, no auth leaked). Replaced `${!name}` with a portable `case` + a belt-and-suspenders non-empty assert in `_gitops_api`; re-verified guarded-before-network under both shells. *A vault whose thesis is portability shipped a shell-specific footgun in its safety guard — caught only because the test shell ≠ the harness shell.*
2. **Live success/idempotency paths are unexercised by design** — they need a token + network (outward). The operator-run `livesmoke_gitops.sh` is the first real exercise, at P5.

**In progress**: None.
**Next up**: **R1/P5 — Codeberg-FOSS Beachhead** (first outward) — Steps 1–7 of `p5_codeberg_beachhead.md`; tooling is now live-ready.
**Blockers**: the **three unchanged R1 gates** — Rosetta releases the agnostic skills into `.adna/` · Hestia provisions `CODEBERG_TOKEN` · operator **DP4** (+ settle **SD-2** pilot pick). All cross-vault/operator — not Git.aDNA-side.
**Files**: 5 modified + 1 new (`livesmoke_gitops.sh`) + this session file. **No remote; no `.adna/`; no cross-vault writes** (`coord_delivery_queue` rows still QUEUED).

## AAR (Standing Order #5)
- **Worked**: Testing the live guard under the *actual* default shell (zsh), not just the harness's bash, exposed a real safety bug before it could matter. Stubbing `curl` made the re-test network-proof. The dual-channel emitter let me add live execution with **zero** change to the 19/19 dry-run gate.
- **Didn't**: Did not run the live-smoke (outward; no token; correctly deferred) and did not deliver the Rosetta/Hestia memos (cross-vault; operator-directed) — both out of the chosen non-outward scope.
- **Finding**: A safety guard is only as portable as the shell it's tested in. `${!name}` passed `bash -n`, passed the bash harness, and *looked* fine — but the node's interactive shell is zsh, where it silently defeated the no-token guard and touched the network. Portability claims must be tested in the environment's real shell, not just the author's.
- **Change**: For any guard/credential path in a "portable" lib, test under **both** bash and zsh (the node default) with the network stubbed, as a standing check — fold a two-shell guard assertion into the test plan whenever the lib gains a live path.
- **Follow-up**: (1) The three R1 gates + SD-2 remain for the outward session — deliver the staged Rosetta + Hestia memos (`coord_delivery_queue.md`) to open #1/#2. (2) Consider a two-shell variant of `dryrun_gitops.sh`'s safety assertion (run the refusal under zsh too). (3) Carryover: CLAUDE.md "Default host policy" / identity table still cites superseded ADR-002/003 vs Path B (ADR-004/005) — a doctrine-reference pass (now also: body still narrates "Codeberg-private/GitHub-public", pre-SD-1).

## Next Session Prompt
Git.aDNA / Operation Free Harbor: **genesis-planning (P0–P4) complete + ratified; R1/P5 Step 0 is DONE (non-outward).** The agnostic dispatch lib (`how/skills/lib/gitops_dispatch.sh`) now executes **live** behind `GITOPS_ALLOW_LIVE=1` (real `gh`/`curl`; out-of-band auth; idempotent; redacted; bash+zsh-portable guard verified pre-network). Dry-run **19/19**; gitleaks clean. `how/tests/livesmoke_gitops.sh` is authored but **NOT run** (outward; triple-gated). **SD-1 ratified**: Git.aDNA is public FOSS on `codeberg.org` (class P) — `git/CLAUDE.md` updated; `origin` still BLANK.

**The next live step is R1/P5 proper — the FIRST OUTWARD phase** (`p5_codeberg_beachhead.md` Steps 1–7). It does not start until **all three** gates land: (1) `aDNA.aDNA` (Rosetta) releases the agnostic skills into `.adna/`; (2) `Home.aDNA` (Hestia) provisions `CODEBERG_TOKEN`; (3) operator **DP4** authorizes the Codeberg org/teams + first pushes — **and at DP4, settle SD-2** (pilot pick; rec: greenfield `TypeScript.aDNA`). Delivering the staged Rosetta + Hestia memos (`coord_delivery_queue.md`) is the gated action that opens #1/#2. First outward smoke: `GITOPS_ALLOW_LIVE=1 GITOPS_SMOKE=1 bash how/tests/livesmoke_gitops.sh`. Read STATE.md + `p5_codeberg_beachhead.md` + `coord_delivery_queue.md` first.
