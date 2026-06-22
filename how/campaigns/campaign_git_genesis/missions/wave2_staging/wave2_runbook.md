---
type: runbook
runbook_id: wave2_runbook
title: "P6 Wave 2 — Public-Flip Runbook (released-FOSS → GitHub-public)"
created: 2026-06-22
updated: 2026-06-22
status: active
last_edited_by: agent_stanley
campaign: campaign_git_genesis
phase: P6
wave: 2
binds_adrs: [adr_013, adr_011, adr_006, adr_004]
tags: [runbook, git, p6, wave_2, public_flip, visibility, released_foss, operation_free_harbor, dp5]
---

# P6 Wave 2 — Execution Runbook (public-flips)

> **STATUS: Wave 2 CANARY ✅ EXECUTED 2026-06-22** (`aDNA.aDNA` → GitHub-public; DP5 scope-limited to the canary; authored `gitops_set_visibility` non-outward first). `III`/`Canvas`/`Astro` **HELD** at their own later per-graph sub-gates. Each public-flip is **outward + irreversible-exposure** → fires only at the operator gate (rollout DP5), per-graph, with a **mandatory full-history secret-scan**.

Wave 2 is the **released-FOSS → GitHub-public** wave — the campaign's highest-blast-radius, least-reversible step, deliberately **deferred after Wave 1 and gated per-graph**. The released set (conservative threshold, [[disposition_ledger]]): **`aDNA` · `III` · `Canvas` · `Astro`** (+ `Git.aDNA` already public from the P5 beachhead).

## How Wave 2 differs from Wave 1 (read first)

| | Wave 1 (private moves) | **Wave 2 (public flips)** |
|---|---|---|
| Action | create-repo / host-move → Codeberg-private | **visibility-flip** GitHub-private → **GitHub-public** (same origin) |
| Verb | `gitops_create_repo`/`set_remote`/`push` | **`gitops_set_visibility <host> <org> <repo> public`** (NEW — non-contract; ADR-013 D4) |
| Origin change | yes (new Codeberg origin) | **no** — origin unchanged; only visibility PATCHes |
| `rollback` remote / Home §C shim | yes (host-move) | **no** — no host move ⇒ no rollback remote, no shim |
| Reversibility | rollback remote (30d) | **`gitops_set_visibility … private`** (trivial re-privatize) — but *exposure* is irreversible |
| Verify invariant | anon-clone **REFUSED** (private) | anon-clone **SUCCEEDS** (public) — the inverse |
| Secret-scan | full-history (pre-cleared at W1 prep) | **full-history HARD GATE, run fresh per-graph at the gate** (public exposure ⇒ no pre-clear shortcut) |

**Tooling note (Wave-2 finding, 2026-06-22):** the lib had no visibility-flip verb (Wave 1 only *created* repos). Authored `gitops_set_visibility` in `how/skills/lib/gitops_dispatch.sh` (GitHub `PATCH /repos -F private=`; Forgejo `PATCH /repos {private}` for portability — only the GitHub path runs live at W2). Dry-run harness extended → **31/31**. Same fold-then-fire shape as the Wave-1 F1/F2 findings.

## Wave 2 set — readiness (recon 2026-06-22)

| Graph | Origin | Branch | Full-history scan | Readiness |
|---|---|---|---|---|
| **`aDNA.aDNA`** | `aDNA-Network/aDNA.aDNA` | main | ✅ **439 commits, no leaks** | **✅ CANARY — FIRED 2026-06-22** |
| `III.aDNA` | `aDNA-Network/III.aDNA` | main | ⛔ **10 gitleaks hits** | HELD — triage FP-vs-real (Molecules pattern → per-graph allowlist) + commit 1 dirty file |
| `Canvas.aDNA` | `aDNA-Network/Canvas.aDNA` | master | not run | HELD — active session (`palette_p4_close`) + 2 dirty = collision; fires when session closes + tree clean |
| `Astro.aDNA` | **`LatticeProtocol/SiteForge.aDNA`** | main | not run | DEFERRED — cross-org + name-drift; Berthier-coord → migrate `aDNA-Network` + rename `Astro.aDNA` → scan → flip |

## Prerequisites at the gate (per graph)

1. **Operator "released" confirm** ✅ (`aDNA`·`III`·`Canvas`·`Astro`, conservative threshold) + **per-graph DP5 authorization**.
2. **`GITHUB_TOKEN` / `gh auth`** present (Home broker; GitHub backend, ADR-007).
3. **Fresh full-history `gitleaks detect` → clean** (the HARD gate; a finding blocks until purged + rotated — Home).
4. **Porcelain-clean + sessionless** (collision-avoid — the Molecules/Canvas lesson).

## Common sequence (per graph `G`, run from `~/aDNA/<G>`)

```bash
# 0. pre-flight + fresh full-history scan (HARD GATE — public exposure)
gitleaks detect --source=. --no-banner --redact        # exit 0 + "no leaks found" required
# 1. apply per-graph artifacts (git/ wrapper · doctrine block · pre-push hook · STATE/MANIFEST host-fact)
#    install hook:  ln -sf ../../git/hooks/pre-push.gitleaks.sh .git/hooks/pre-push && chmod +x .git/hooks/pre-push
git add -A && git commit -m "feat(git): Wave-2 git/ wrapper + Git-Ops doctrine (GitHub-public, P-released)"
# 2. push local→origin so the soon-public repo reflects current state (pre-push hook DOGFOODS clean)
GITOPS_ALLOW_LIVE=1 ; source <Git.aDNA>/how/skills/lib/gitops_dispatch.sh
gitops_push <branch> origin
# 3. FLIP public (the new verb's live exercise)
GITOPS_ALLOW_LIVE=1 gitops_set_visibility github.com aDNA-Network <G> public
# 4. verify: API private:false  +  ANON clone SUCCEEDS (public invariant)  +  HEAD==pushed
GIT_TERMINAL_PROMPT=0 git clone https://github.com/aDNA-Network/<G>.git /tmp/_anon_<G>   # → OK (public)
rm -rf /tmp/_anon_<G>
# rollback (if needed): GITOPS_ALLOW_LIVE=1 gitops_set_visibility github.com aDNA-Network <G> private
```

> **No `rollback` remote, no Home §C shim** — the origin never changes (visibility-only). The reverse is a one-command re-privatize. (Contrast Wave 1b host-moves, which keep a 30-day `rollback` remote + a §C shim.)

## Per-graph

### `aDNA.aDNA` (class P-released · branch `main` · same-org · no drift) — ✅ EXECUTED 2026-06-22 (Wave 2 CANARY)
- **As-fired:** `gitops_set_visibility github.com aDNA-Network aDNA.aDNA public` → GitHub `private:false`; anon-clone **succeeds**; HEAD == pushed `main`. `git/CLAUDE.md` (host `github.com`, backend `github`, visibility **public**, class **P**, pin `<HEAD>`) + Git-Ops doctrine block + pre-push hook + STATE/MANIFEST host-fact applied + dogfood push clean. The standard's docs face — *intended public* (the `.adna` template is already public); lowest actual exposure risk → chosen as the canary to live-exercise the new verb.
- **No shim** (visibility-only). Reversible via re-privatize.

### `III.aDNA` (class P-released · branch `main`) — HELD
- **Blocker:** full-history `gitleaks` → **10 hits**. Triage each (FP-vs-real); FPs → a per-graph `git/.gitleaks.toml` allowlist with field-name justification (the Molecules precedent — 16 verdict-enum FPs); a real secret ⇒ purge (git-filter-repo) + rotate (Home) **before** any flip. Also commit the 1 dirty file. Then the common sequence. Production framework w/ live consumers — the scan gate matters most here.

### `Canvas.aDNA` (class P-released · branch `master`) — HELD (collision)
- **Blocker:** active `session_stanley_20260622_..._palette_p4_close` + 2 dirty files. Fires turnkey when the session closes + tree clean (the Molecules/Oration collision precedent). Run a fresh full-history scan at the gate (not yet run). Branch `master` ⇒ same flip (GitHub adopts the pushed default; visibility-flip is branch-agnostic).

### `Astro.aDNA` (class P-released · branch `main` · **cross-org + name-drift**) — DEFERRED (most complex)
- **Sequence:** Berthier coord → migrate `LatticeProtocol/SiteForge.aDNA` → `aDNA-Network` + rename → `Astro.aDNA` (GitHub transfer/rename; redirect-aware get-or-create) → fresh full-history scan → public-flip. The cross-org/rename happens **on GitHub** (not Codeberg — Astro is released-FOSS, GitHub-public is its home).

## Wave-exit
Each released graph: `git/` declaration + doctrine block + hook + updated STATE/MANIFEST + ledger row → ✅; **anon-clone succeeds** (public proven). **Nothing in Wave 2 runs without a per-graph DP5 gate + a fresh full-history scan** (Standing Order #1/#2; ADR-011 D4). After Wave 2: Wave 3 (internal touch-only) · Wave 4 (nested) · Wave 5 (client/I-strict).
