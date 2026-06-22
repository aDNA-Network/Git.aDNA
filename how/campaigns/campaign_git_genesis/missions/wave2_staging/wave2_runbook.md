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

> **STATUS: Wave 2 — ✅ COMPLETE 2026-06-22.** `aDNA.aDNA` (canary) + **`III.aDNA` ✅** + **`Canvas.aDNA` ✅** → GitHub-public (3/3 released; all `private:false`, anon-clone succeeds, visibility-only no-shim; `gitops_set_visibility` proven across 3 graphs). **`Astro.aDNA` ✅ RESOLVED** — operator **BSL-1.1 posture = keep private** ⇒ reclassified W2→W3 (class I); migrated home via a GitHub-native cross-org **transfer + rename** (`LatticeProtocol/SiteForge.aDNA` → `aDNA-Network/Astro.aDNA`, private throughout; `set_visibility public` NOT run; HEAD `0d0c315`; anon-clone refused). Each public-flip is **outward + irreversible-exposure** → fired only at its operator gate (rollout DP5), per-graph, with a **mandatory full-history secret-scan**.

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
| `Astro.aDNA` | `aDNA-Network/Astro.aDNA` (was `LatticeProtocol/SiteForge.aDNA`) | main | ✅ **35 commits, no leaks** | **✅ RESOLVED 2026-06-22 — kept PRIVATE (W2→W3)**; native transfer+rename done; no public flip |

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

### `III.aDNA` (class P-released · branch `main`) — ✅ FIRED 2026-06-22
- **Triage outcome:** full-history `gitleaks` (72 commits) → **10 hits, ALL false-positives** (7× the field NAME `idempotency_key` in coord/validation/session prose — value = audit ceremony-key; 3× minified var-assignments in vendored `.obsidian/plugins/{obsidian-tasks-plugin,termy}/main.js`). No real secret, nothing to rotate. Scoped `git/.gitleaks.toml` allowlist: `paths` for the two plugin bundles + `regexes=['idempotency_key']` with **`regexTarget="match"`** (the field name isn't the extracted secret, so default `secret` target wouldn't catch it — verified the re-scan returns clean). Folded the 1 untracked file (`coord_2026_06_13_hypnos_to_argus_iii_node_pilot_aar.md`) into the artifact commit. Also **corrected a stale MANIFEST host-fact** (`LatticeProtocol/III.aDNA` → `aDNA-Network/III.aDNA`). Commit `fb807f1`; dogfood push (hook clean); flip → `private:false`; anon-clone **succeeds**; HEAD match; `git/`+`## Git-Ops` in public clone. **no shim.**

### `Canvas.aDNA` (class P-released · branch `master`) — ✅ FIRED 2026-06-22
- **Collision cleared (read-at-use):** `palette_p4_close` was **completed** (in `history/`), `sessions/active/` empty, no `index.lock` — not an active collision. BUT the tree carried **uncommitted completed work** that appeared mid-session: **Operation Salon P0** (new `campaign_canvas_salon/` + `adr_006` + 8-decision record + STATE edits), HELD at its P0→P1 gate. **Surfaced to operator → authorized "commit salon, then flip."** Committed the salon work as its own provenance-clear commit `79f372a` (HELD-at-gate, NOT ratified), then the Wave-2 artifacts as `b345e7b`. Fresh full-history scan (62 commits) **CLEAN** → baseline `.gitleaks.toml`, no allowlist. Dogfood push on `master` (hook clean); flip → `private:false`/`default_branch:master`; anon-clone **succeeds**; HEAD match; salon work present in public. **no shim.**

### `Astro.aDNA` (was class P-released · branch `main` · **cross-org + name-drift**) — ✅ RESOLVED 2026-06-22 (reclassified W2→W3, kept PRIVATE)
- **Operator BSL-1.1 posture decision = keep private** (BSL-1.1 is source-available, not OSI-FOSS) ⇒ **reclassified W2 (public-flip) → W3 (internal-touch, class I)**; the public flip was **NOT** run. This is a *private cross-org migrate* (a W3-shaped touch done early), not a Wave-2 public exposure.
- **As-fired (private cross-org migrate):** pre-flight (`admin:true`, ahead 5, sessionless, target 404) → **fresh full-history `gitleaks` 35 commits clean** (HARD gate) → GitHub-native **transfer** `LatticeProtocol/SiteForge.aDNA` → `aDNA-Network` (poll-until-settled; the rename hit a transient **422 "conflicting operation in progress"** while the transfer finalized async → retried, succeeded on next attempt) → **rename** → `aDNA-Network/Astro.aDNA` → repoint origin + fetch → artifacts (git/ wrapper pin `b870c16` + `## Git-Ops` block + hook + STATE/MANIFEST host-fact) committed `0d0c315` → dogfood push (private). **Verify:** API `private:true`; **anon-clone REFUSED**; authed HEAD `0d0c315` match; `git/`+`## Git-Ops` in clone; both old paths (`LatticeProtocol/SiteForge.aDNA` + `aDNA-Network/SiteForge.aDNA`) redirect. `set_visibility public` NOT run.
- **§C shim** (host-move; rollback = **re-transfer**; **no `rollback` remote** — native transfer preserves the object + installs redirects, so an old-URL remote would just redirect forward).
- **Finding (F-Astro): stale `core.hooksPath`.** Astro's `.git/config` carried `core.hooksPath = /Users/stanley/lattice/SiteForge.aDNA/.git/hooks` — a defunct pre-Operation-Homecoming path (whole `~/lattice` is gone) — which silently **bypassed the pre-push gitleaks hook on the first push**. Fixed: `git config --unset core.hooksPath` → the standard `.git/hooks/pre-push` symlink is now active → re-dogfooded (`pre-push: gitleaks clean ✓`). No secret risk (full-history scan was the hard gate, clean ×3). Fleet sweep: only `ScienceStanley.aDNA` else carries a hooksPath (`how/governance/hooks`, intentional/relative — flag for its W3 touch so the hook lands in its custom dir). Coord: [[coord_2026_06_22_git_wave2_astro_cross_org]].

## Wave-exit
Each released graph: `git/` declaration + doctrine block + hook + updated STATE/MANIFEST + ledger row → ✅; **anon-clone succeeds** (public proven). **Nothing in Wave 2 runs without a per-graph DP5 gate + a fresh full-history scan** (Standing Order #1/#2; ADR-011 D4). After Wave 2: Wave 3 (internal touch-only) · Wave 4 (nested) · Wave 5 (client/I-strict).
