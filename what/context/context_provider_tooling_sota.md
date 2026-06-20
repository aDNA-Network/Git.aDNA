---
type: context
created: 2026-06-19
updated: 2026-06-19
status: active
last_edited_by: agent_stanley
campaign: campaign_git_genesis
phase: P1
tags: [context, git, forgejo, codeberg, forgefed, provider_tooling, sota, p1]
---

# Provider-Tooling SOTA — Forgejo Backend (2025–2026)

> P1 deliverable (Operation Free Harbor). Read-only web survey to inform the P2 provider-abstraction ADRs and pick a Forgejo-backend tool-of-record. Verb existence verified against the **live OpenAPI spec** (`code.forgejo.org/swagger.v1.json`). Cited throughout; paraphrased.

## 🚨 Headline finding — CODEBERG ToS BLOCKS PRIVATE PROPRIETARY REPOS

**Codeberg is a non-profit FOR FOSS ONLY. Hosting proprietary/closed software is explicitly prohibited; private repos are allowed only as a FOSS-contributor convenience, capped at ~100 MB of private content; they do not accept payment to waive this — their FAQ points such users to self-host Forgejo.** ([Codeberg FAQ](https://docs.codeberg.org/getting-started/faq/), [storage limits](https://blog.codeberg.org/new-storage-limits-on-codeberg-what-you-need-to-know.html))

**This directly contradicts [[adr_003_visibility_split_policy]]'s "private/internal → Codeberg" default.** The fleet ([[fleet_git_state]]) is ~40 *private, proprietary* repos — that use **violates Codeberg's mission**. Codeberg is viable **only for the public/FOSS subset**.

**The clean reconciliation** (because Codeberg and self-hosted Forgejo speak the *identical* `/api/v1` surface — the abstraction is the same code, only base-URL/token/routing differ):

| Role | Original ADR-003 | **Corrected (P1 finding)** |
|---|---|---|
| Public / FOSS home | GitHub | **Codeberg** (its actual purpose) — + GitHub for network-effect/discovery |
| Private / internal home | **Codeberg** ❌ ToS-blocked | **Self-hosted Forgejo** (the north star, *pulled forward*) — GitHub remains the interim private home until it stands up |
| North star | self-hosted mesh-git | unchanged — now the *private-home* answer, not just a future aspiration |

→ **Operator decision at the P2-entry gate** (amends ADR-003): pick the private-home path — (A) self-host Forgejo now as the private home; (B) keep private on GitHub, use Codeberg for the FOSS subset only, self-host later; (C) hybrid. See P1-close presentation.

## 1. Forgejo REST API — verb coverage (verified)

Self-identifies as **OpenAPI 2.0**, `title: "Forgejo API"`, `version: 16.0.0-dev…+gitea-1.22.0` — i.e. **Gitea-1.22-API-compatible** (not GitHub-shaped). Auto-generated, browsable at `<instance>/api/swagger`, base `/api/v1/`. Auth: `Authorization: token <PAT>` / Bearer / basic; 2FA via `X-Forgejo-OTP`. ([api-usage](https://forgejo.org/docs/latest/user/api-usage/))

All our contract verbs exist as first-class operations (confirmed in the live spec): `createCurrentUserRepo`/`createOrgRepo` · `repoEdit` (default branch) · `repoCreateRelease` + `repoCreateReleaseAttachment` · `repoCreatePullRequest` + `repoMergePullRequest` · **`repoAddPushMirror` / `repoListPushMirrors` / `repoPushMirrorSync`** · `repoMirrorSync` (pull) · `repoCreateHook` · `repoCreateKey` · `userCreateToken`.

- **Forgejo is now a hard fork of Gitea** (since ~v7/v8; own numbering — v11 Apr 2025, v12 Jul 2025) but **deliberately keeps the Gitea-1.22 API numbering** so Gitea SDKs/tools work unmodified. ([versions](https://forgejo.org/docs/latest/user/versions/)) → a raw-REST client against `/api/v1` is the most durable target.
- **Gotcha:** **no in-place update for a push-mirror config** — change = delete + re-add (`repoAddPushMirror`). Design idempotency as get-or-create / delete-then-recreate. ([repo-mirror](https://forgejo.org/docs/latest/user/repo-mirror/))

## 2. CLIs — `tea` and `fj`

- **`tea`** (official *Gitea* CLI, Go, Gitea SDK): covers issues, PRs (incl. merge), **releases + `--asset`**, repos, orgs, labels, notifications; multi-instance logins. Works against Forgejo (API stays Gitea-compatible; a Forgejo `tea` fork was dismissed as unnecessary). **BUT coverage is workflow-surface, not full-API: it does NOT expose push-mirror / pull-mirror / webhook / deploy-key management** — those are REST-only. Lives in the *Gitea* org (drift risk). **Not installed on this node.** ([tea](https://about.gitea.com/products/tea), [CLI.md](https://gitea.com/gitea/tea/src/branch/main/docs/CLI.md))
- **`forgejo-cli` / `fj`** ([codeberg.org/forgejo-contrib/forgejo-cli](https://codeberg.org/forgejo-contrib/forgejo-cli)): Forgejo-native Rust CLI, active (June 2026), **not yet official** ([make-official discussion #400](https://codeberg.org/forgejo/discussions/issues/400)); still workflow-scoped. Track, don't bet.

## 3. Mirroring (our release-mirror mechanism)

- **Push-mirror** (Forgejo → GitHub): via Settings or API (`repoAddPushMirror`). Triggers: periodic interval · **"sync when new commits are pushed"** (on-push, ≥1.18) · manual / `repoPushMirrorSync`. **Branch-filter only** (comma/glob); blank = `git push --mirror` (all branches **+ tags**, force). **No tags-only toggle.** Auth to GitHub: HTTPS + **GitHub PAT** (`public_repo`+`workflow`) or SSH + Forgejo Ed25519 deploy key. **⚠ LFS does NOT mirror over SSH — use HTTPS+PAT for LFS repos.** ([repo-mirror](https://forgejo.org/docs/latest/user/repo-mirror/))
- **Pull-mirror** (GitHub → Forgejo): periodic + manual; **can only be set at repo creation** (existing repo can't convert).

## 4. Forgejo Actions vs GitHub Actions

Intent: **"familiar, not compatible."** ([github-actions](https://forgejo.org/docs/latest/user/actions/github-actions/))
- Dir `.forgejo/workflows/` with **fallback to `.github/workflows/`** → CI-portable with zero file moves.
- `uses:` relative refs resolve to **`data.forgejo.org`** (admin-configurable), **not github.com; no GH fallback** → pin **full URLs** for portability; common actions mirrored on `code.forgejo.org`.
- `FORGEJO_TOKEN` **aliased as `GITHUB_TOKEN`**; fork-PR secrets empty.
- **BYO runner** (`forgejo-runner`/`act_runner`); no GH-hosted-runner equivalent.
- **Ignored keys:** `permissions:`, `continue-on-error:`; some `github`-context keys missing; default image Debian bookworm.
- **Verdict:** portable with edits (full-URL action pins, drop `permissions:`, ensure runner tooling). Our 3 reusable workflows at `.adna/` (mypy/ruff/manifest, caller URLs still `LatticeProtocol/aDNA`) would need a `.forgejo/` parity pair + URL pins.

## 5. ForgeFed (mesh-git north-star substrate) — EXPERIMENTAL

**Not production-usable for cross-instance issues/PRs in 2025–2026.** Built on ForgeFed (ActivityPub ext). **Works today: federated repository *stars* only.** Not yet: federated following/issues/PRs/identities (roadmap; funded by Sovereign Tech / NLnet; blocked on moderation + access control). Forgejo reserves the right to make **breaking federation changes without warning**. ([FAQ](https://forgejo.org/faq/), [issue #59](https://codeberg.org/forgejo/forgejo/issues/59), [forgefed.org](https://forgefed.org/)) → **P7 reality check:** the near-term "mesh" is **mirroring (§3) + REST**, not ForgeFed. The north star's *federation* layer is a directional bet, not a 2026 substrate.

## 6. LFS + packages parity

Git-LFS supported (incl. migrate + mirror, HTTPS-only). Package registry: **~23 ecosystems + OCI container registry** — broadly GitHub-comparable. Gaps: no pull-through cache; some Actions↔registry token rough edges. LFS host-to-host recipe: `git clone --mirror` → `git lfs fetch --all` → `git lfs push --all <dest>` → `git push --mirror <dest>`. ([packages](https://forgejo.org/docs/latest/user/packages/container/)) Relevant fleet repos: `lattice-labs` (LFS), any media graphs.

## 7. Provider-agnostic tooling (reference only — none mature)

`forge` (Nesbitt, [blog](https://nesbitt.io/2026/03/13/forge.html)) — closest in spirit (auto-detects forge, common interface) · `git-forge` (issues/PRs across GH/GL/Gitea/Forgejo) · MultiGit (one-command multi-host push). For plumbing, **`git remote` with multiple `pushurl`s** is the lowest-common-denominator multi-push. No special remote-helper needed for HTTPS/SSH forges.

## 8. Codeberg specifics

Runs Forgejo. Rate limit **2000 req / 300 s** (~6.7/s; batch+backoff). Default **100 repos/org** (raise by request). Storage thresholds ~750 MiB git / ~1.5 GiB combined. Gitea/Forgejo org+team RBAC adequate. **+ the ToS blocker (headline).**

## ✅ RECOMMENDATION — tool of record

**Standardize the Forgejo backend on the raw REST API (`/api/v1`), driven `gh api`-style. Do NOT make `tea`/`fj` the backend.**
1. **Only REST covers the critical path** — push-mirror/pull-mirror/webhook/deploy-key are REST-only; `tea`/`fj` can't drive the release-mirror mechanism.
2. **Durability** — API pinned Gitea-1.22-compatible, survived the hard fork; `tea` is Gitea-org (drift), `fj` not yet official.
3. **Idempotency** — REST exposes status/payloads needed for get-or-create / delete-then-recreate (mirrors have no update).
4. **Symmetry** — our GitHub side already wraps REST; one pattern, two endpoints (swap base URL + token).
- **Shape:** thin HTTP client over `/api/v1` with `Authorization: token <PAT>` (a "`gh api` for Forgejo"). Optional libraries: **Gitea Go SDK** (`code.gitea.io/sdk/gitea`, what `tea` uses) or **`pyforgejo`** (Python). `tea`/`fj` = optional human-convenience adjuncts only, never the automation path.

## Flags for hands-on verification (P3/P5 — no instance or `tea`/`fj` yet)
1. **Mirror trigger on tag-only pushes** (the release flow) + branch-filter interaction — docs silent; **verify first** (core mechanism).
2. `repoAddPushMirror` exact payload + delete-then-recreate idempotency.
3. LFS over HTTPS+PAT push-mirror actually transits.
4. Port one real GitHub workflow to Forgejo Actions (runner + action-URL pins).
5. Re-check `fj` official-status trajectory (discussion #400).
6. Confirm the API version of the target Forgejo release tolerates the `+gitea-1.22.0` pin.
