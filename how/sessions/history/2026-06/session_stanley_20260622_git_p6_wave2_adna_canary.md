---
type: session
session_id: session_stanley_20260622_git_p6_wave2_adna_canary
campaign: campaign_git_genesis
phase: p6
mission: mission_p6_fleet_alignment
wave: 2
graph: aDNA.aDNA
persona: hopper
operator: Stanley
created: 2026-06-22
status: completed
tags: [session, git, genesis, operation_free_harbor, phase_6, wave_2, adna, public_flip, visibility, outward, dp5]
---

# Session — R2/P6 Wave 2 CANARY: Flip `aDNA.aDNA` → GitHub-public

## Shape

Cold start post-`/clear`. Operator: "please read the claude.md and continue the campaign." Oriented from STATE.md: **P0–P5 ✅**; R2/P6 **Wave 1a + 1b ✅ COMPLETE** (6 graphs → Codeberg-private: VisualDNA · Lighthouse · Videos · Oration · Spacemacs · Molecules). **Next gated step = Wave 2 public-flips** (`aDNA`·`III`·`Canvas`·`Astro` → GitHub-public).

**Read-only recon (this session):** only **`aDNA.aDNA` is canary-ready** — clean working tree, no active session, same-org (`aDNA-Network`), name matches, full-history `gitleaks` clean (439 commits, no leaks), and it is *intended-public* (the standard's docs face; the `.adna` template is already public). The other three are each blocked: `III` (10 gitleaks hits → triage FP-vs-real, + 1 dirty file), `Canvas` (active `palette_p4_close` session + 2 dirty = collision), `Astro` (cross-org + name-drift `LatticeProtocol/SiteForge.aDNA` → migrate+rename via Berthier *before* flip).

**Load-bearing tooling finding:** the agnostic lib (`gitops_dispatch.sh`) has **no visibility-flip verb** — Wave 1 *created* repos; Wave 2 must **PATCH an existing repo private→public**. Per Standing Order #4 (dogfood + host-neutral), authored `gitops_set_visibility` non-outward first (dry-run), *then* used it live — the same shape as the Wave-1 F1/F2 folds.

Operator (AskUserQuestion) → **"Canary: flip aDNA public."** Plan ratified via plan-mode ExitPlanMode (`~/.claude/plans/please-read-the-claude-md-gleaming-sprout.md`) = the rollout **DP5 gate** (scope-limited to the `aDNA` canary). Hold `III`/`Canvas`/`Astro` at their own later sub-gates.

## Pre-flight state

- Touch only `aDNA.aDNA/.git` (origin `github.com/aDNA-Network/aDNA.aDNA`, branch `main`). Visibility-flip = same origin, no host move ⇒ **no `rollback` remote, no Home §C shim** (the reverse is a trivial re-privatize).
- Git.aDNA HEAD at apply = `<set at commit>` (wrapper pin). Dry-run target after the new verb = 26/26.

## Execution log (actuals)

**Phase 1 — non-outward (lib + staging):**
- Authored `gitops_set_visibility <host> <org> <repo> public|private` in `how/skills/lib/gitops_dispatch.sh` (non-contract helper, grouped with `gitops_create_org`; ADR-013 D4; ADR-004 contract unchanged). GitHub `gh api -X PATCH /repos -F private=$priv`; Forgejo `_gitops_api PATCH /repos {private:$priv}` for portability. `public⇒false`, `private⇒true`, bad-arg⇒rc 2.
- Extended `how/tests/dryrun_gitops.sh` +7 assertions (loop dispatch both backends · public→`private=false` · private→`private=true` · Forgejo `{"private":false}` · bad-arg rejected · live-refusal). **Dry-run 24/24 → 31/31 PASS.** `bash -n` + `zsh -n` + `shellcheck -S warning` all clean.
- Authored [[wave2_runbook]] (public-flip semantics: visibility-only, no rollback/shim, anon-clone-SUCCEEDS verify, hard per-graph scan; aDNA recipe + III/Canvas/Astro held). **Phase-1 commit `40f3c58`** (Git.aDNA HEAD = aDNA's wrapper pin).

**Pre-flight (all ✅):**
- `GITHUB_TOKEN` ← `gh auth token` (gho_, len 40; `gh auth status` scopes `gist, read:org, repo, workflow` — `repo` suffices for the visibility PATCH).
- aDNA porcelain-clean, branch `main`, sessionless. **Collision re-check:** session-start recon saw HEAD `b5a68c0`; at the gate HEAD = `94e318d` → investigated: that commit is completed Operation-aDNA work from **12 h prior** (01:18; its session in `history/`, `active/` empty, last file mtime 11.5 h ago, no `.git` lock) — *not* concurrent. Safe.
- **Hard gate:** fresh full-history `gitleaks detect` → **440 commits, no leaks** (rc 0).

**Fired (outward, DP5):**
- Applied per-graph artifacts into `aDNA.aDNA`: `git/CLAUDE.md` wrapper (federates Git.aDNA `pinned_at_commit 40f3c58`; host `github.com`/public/class P; `local_extensions` notes `set-visibility`) + `git/.gitleaks.toml` + `git/hooks/pre-push.gitleaks.sh` (installed `.git/hooks/pre-push`) + `## Git-Ops` doctrine block in `CLAUDE.md` + MANIFEST host-fact. **STATE host-fact deferred** (active 33 K-token Operation-aDNA state) → Rosetta folds. Commit `a12d9c0` (6 ahead).
- **Dogfood push** `gitops_push main origin` → **`pre-push: gitleaks clean ✓`** + `c092b68..a12d9c0 main -> main` (rc 0). **First live exercise of the P5 GitHub Basic-auth push path** (`x-access-token:tok` Basic; Waves 1a/1b only ever pushed to Codeberg/Forgejo) — proven.
- **Flip:** `GITOPS_ALLOW_LIVE=1 gitops_set_visibility github.com aDNA-Network aDNA.aDNA public` (rc 0) → API `full_name: aDNA-Network/aDNA.aDNA`, `private:false`, `visibility:public`, `default_branch:main`. **The verb's first live exercise.**

**Verify (all ✅):** anon-clone (creds-helper disabled, `GIT_TERMINAL_PROMPT=0`) **SUCCEEDS** = public invariant (inverse of W1's refused); clone HEAD `a12d9c0`; `git/` wrapper + `## Git-Ops` doctrine present in the public clone; independent `gh api` re-confirm `private:false`/`visibility:public`. No `rollback` remote / no Home §C shim (visibility-only; reverse = one-command re-privatize).

**Bookkeeping:** disposition_ledger (aDNA → FIRED; Wave-2 canary; wave-sequence row) · [[wave2_runbook]] (as-fired) · p6_fleet_alignment (objective #3 progress + AAR) · CHANGELOG v0.19 · STATE (callout + summary + intake) · CLAUDE.md (status + Resume-Here banners). Git.aDNA commit + this session → history.

## AAR
- **Worked**: the canary rhythm carried from Wave 1b into the higher-stakes public wave — *author-the-missing-verb-then-fire* mirrors the F1/F2 *fold-then-fire*. `aDNA` was the ideal first public-flip (clean scan + intended-public — the standard's docs face, actively being prepped as a public docs site ⇒ low *actual* exposure despite Wave 2's irreversible class). **Two paths got their first live validation in one push:** `gitops_set_visibility` (new) **and** the P5 GitHub Basic-auth push fix (previously dry-run-only).
- **Didn't**: held `III`/`Canvas`/`Astro` (each a distinct real blocker, not deferred-in-error). Deferred the `aDNA` STATE.md host-fact to avoid churning its active 33 K-token campaign state → landed it in the lower-churn MANIFEST + wrapper instead.
- **Finding (collision)**: the "HEAD moved vs session-start recon" signal resolved to completed work 12 h prior via commit-age + file-mtime + session-location + lock checks — *read at use, not at recon* (the Molecules lesson) held again. **Finding (org policy)**: `aDNA-Network` permits the visibility PATCH (no 403) ⇒ `III`/`Canvas`/`Astro` clear the same auth path. **Finding (verb gap)**: Wave 2 needed an 8th operation the 7-verb contract lacked — added non-contract (like `create-org`); a follow-up ADR may formalize, and it joins the Rosetta `.adna/` release (now 8 fixes).
- **Change**: `aDNA.aDNA` → GitHub-public (Wave 2 canary). First fleet graph flipped *public* under the campaign (Git.aDNA itself was public from the P5 beachhead).
- **Follow-up**: **Wave 2 continuation** — `III` (triage 10 gitleaks hits → FP-allowlist or purge+rotate, then flip), `Canvas` (fires when `palette_p4_close` closes + tree clean), `Astro` (Berthier cross-org migrate + rename → scan → flip); each a separate per-graph DP5 gate. Then Wave 3 (internal touch-only). Standing fast-follows: Rosetta `.adna/` release (8 folded fixes); Hestia registers the 4 Wave-1b §C shims + `C58`; Rosetta folds the deferred `aDNA` STATE host-fact.

## Next Session Prompt
> Continue Operation Free Harbor R2/P6. **Wave 1a+1b ✅ COMPLETE** (6 graphs → Codeberg-private) + **Wave 2 CANARY ✅ FIRED** (`aDNA.aDNA` → GitHub-public; `gitops_set_visibility` authored + first-exercised). **Next = the held Wave 2 set** (each a separate per-graph DP5 gate, each with a **hard full-history secret-scan**): **`III`** — triage its 10 gitleaks history hits (FP-vs-real; FP ⇒ a per-graph `git/.gitleaks.toml` allowlist like Molecules, real ⇒ purge+rotate) + commit its 1 dirty file, then flip; **`Canvas`** — fires when its active `palette_p4_close` session closes + tree clean (the Molecules collision precedent); **`Astro`** — Berthier-coord cross-org migrate (`LatticeProtocol/SiteForge.aDNA` → `aDNA-Network`) + rename → `Astro.aDNA` → scan → public-flip. The lib's `gitops_set_visibility` + GitHub Basic-auth push are now both live-proven; the org allows visibility PATCHes. Read `STATE.md` first. Non-blocking fast-follows: Rosetta `.adna/` release (8 folded fixes), Hestia registers the 4 §C shims + `C58`, Rosetta folds the deferred `aDNA` STATE host-fact.

status → completed; moved to `how/sessions/history/2026-06/`.
