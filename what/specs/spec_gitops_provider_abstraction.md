---
type: spec
spec_id: spec_gitops_provider_abstraction
title: "Spec — Platform-Agnostic Git-Ops Provider Abstraction (consumer-facing)"
status: draft
version: "0.1.0"
created: 2026-06-20
updated: 2026-06-21
last_edited_by: agent_stanley
binds_adrs: [adr_004, adr_005, adr_006, adr_007, adr_008, adr_009, adr_010, adr_011, adr_012, adr_013]
tags: [spec, git, provider_abstraction, federation, git_wrapper, draft, phase_3]
---

# Spec — Platform-Agnostic Git-Ops Provider Abstraction

**Status**: `draft` (genesis **P3**, 2026-06-20). The single **consumer-facing reference** for the git-ops standard — it consolidates the binding ADRs (004–011) into one operational contract that the agnostic skills implement, the `git/` wrapper carries, and `aDNA.aDNA` upstreams at P4. **Authority is the ADRs**; this spec restates, never overrides them. Drafted Git.aDNA-local; **no `.adna/` edits, no outward actions** at P3.

> **⚠ Two reconciliations pending (post-P5, 2026-06-21).** (1) **Host policy:** [[adr_013_host_role_inversion|ADR-013]] **supersedes ADR-005's direction** — released-FOSS → **GitHub-public**, FOSS-in-dev → **Codeberg-private**, proprietary → GitHub-private→self-hosted (Codeberg FOSS-only). §3/§5/§host-policy prose below still narrates the superseded ADR-005 Codeberg-public-home text — read it through ADR-013; a full inline pass lands with the P6 doctrine reconciliation. (2) **Lib-fix addendum §1.1** records 3 contract-relevant fixes the P5 live beachhead surfaced.

## 0. Mental model
A graph's git-ops are **seven host-neutral verbs**. Skills + doctrine call a **verb**; the verb dispatches to a **backend** (GitHub-API or Forgejo-API) chosen from the graph's declared `host`. A pattern that names a provider instead of a verb is a defect (SO#4).

## 1. The provider contract — verbs (ADR-004 D1)

| Verb | Contract semantics (host-neutral) | GitHub backend | Forgejo backend *(Codeberg + self-hosted)* |
|---|---|---|---|
| `create-repo` | get-or-create remote repo for `{org,name,visibility}` (idempotent) | `gh api /orgs/{org}/repos` | `POST /api/v1/orgs/{org}/repos` |
| `set-remote` | point a named local remote at a provider URL | `git remote …` | `git remote …` |
| `push` | publish history + tags | `git push` | `git push` |
| `open-pr` | propose `head → base` | `gh api …/pulls` | `POST /api/v1/repos/{o}/{r}/pulls` |
| `cut-release` | tag-anchored release (+ assets) | `gh api …/releases` | `POST /api/v1/repos/{o}/{r}/releases` (+ asset upload) |
| `configure-mirror` | get-or-create push-mirror `origin → target` (idempotent) | (GitHub = mirror *target*) | `POST /api/v1/repos/{o}/{r}/push_mirrors` |
| `port-ci` | place/sync the CI surface | `.github/workflows/` | `.forgejo/workflows/` (`.github/` fallback) |

### 1.1 Beachhead lib-fix addendum (P5 dogfood, 2026-06-21)
Three corrections the live beachhead surfaced (dry-run never exercises real auth), folded into `gitops_dispatch.sh`:
1. **`push` auth is per-backend.** GitHub **rejects** a raw `Authorization: token <oauth>` `http.extraHeader`; the lib sends **HTTP Basic** with the token as password (`x-access-token:<tok>`, the `actions/checkout` convention; base64 unwrapped). Forgejo accepts the `token` header directly. Token still injected via `GIT_CONFIG_*` env — never argv / `.git/config`.
2. **`cut-release` on Forgejo carries `target_commitish`.** Forgejo requires it when the tag doesn't pre-exist (GitHub auto-derives); the lib defaults it to the current branch. Verb signature gains an optional trailing `target_commitish`.
3. **`create-org` exists as a *non-contract* helper** — **NOT one of the 7 verbs** (ADR-004 contract unchanged). Forgejo `POST /api/v1/orgs`; GitHub org-create is admin/enterprise-scoped (surfaced as a no-op note). Gated like the verbs. *(Also: `create-repo`'s GitHub get-or-create now compares the resolved `full_name` so a 301 rename-redirect can't false-positive — an internal correctness fix, no contract change.)*

## 2. Two backends, host-derived (ADR-004 D2)
`backend` is **derived from `host`**: `github.com → github`; everything else (`codeberg.org`, `git.<subnet>.adna.network`) `→ forgejo`. Codeberg *runs Forgejo*, so one Forgejo backend serves hosted Codeberg **and** the future self-hosted lighthouse — a **2-backend** problem. Tool-of-record for Forgejo = **raw REST `/api/v1`** (`gh api`-style), not `tea`/`fj` (ADR-004 D3).

## 3. Per-graph declaration — `git_provider` (ADR-004 D4)
Carried by the graph's `git/` wrapper (§7). Host-neutral; ADR-005 sets the default host per visibility, ADR-006 governs remote names.

```yaml
git_provider:
  host: github.com            # github.com | codeberg.org | git.<subnet>.adna.network
  backend: github             # github | forgejo  (derived from host; explicit for clarity)
  org: aDNA-Network
  visibility: private         # private | public
  class: I                    # I internal · P public-primary · R release-mirrored · L local-only (ADR-005 D2)
  lfs: false                  # LFS present? (drives the HTTPS+PAT mirror caveat, §5)
  remotes:
    origin:                   # canonical home (ADR-006); blank until set
    mirror:                   # optional outbound release/discovery target (Class R/P)
    upstream:                 # optional external-tracked-not-owned
```

**Host policy (ADR-005, Path B):** public/FOSS → **Codeberg** origin (+ GitHub discovery mirror); private/proprietary → **GitHub interim** (eventual self-hosted Forgejo, post-P7); **Codeberg is FOSS-only** (ToS — never private proprietary). New-graph default: FOSS→Codeberg-public, private→GitHub-interim. **Lighthouse-operator default ([[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]]):** a node running its own L1 lighthouse subnet defaults to **its own Forgejo** (`host: git.<subnet>.adna.network`) as the subnet's core git + context-sync (see [[context_gitops_options]]).

## 4. Remote-naming (ADR-006)
`origin` = canonical home (single source of truth) · `mirror` = write-only outbound (private→public) · `upstream` = external, read-only (never pushed) · `rollback` = previous origin, **temporary** across a host move. Host-move sequence (`skill_repo_migrate`): **pre-move secret-scan gate (§10)** → `rename origin→rollback` → `set-remote origin <new>` → `push --all --tags` → emit Home shim-registry entry → remove `rollback` at window close.

## 5. Mirror mechanics + gotchas (ADR-004 D5)
`configure-mirror` MUST encode the P1 findings: **(a)** no in-place update — change = delete + re-add (idempotency = get-or-create / delete-then-recreate); **(b)** no tags-only toggle — blank filter = `--mirror` (all branches+tags); "release-only" = branch-filter + tag discipline; **(c)** **LFS does not mirror over SSH** — `lfs: true` ⇒ HTTPS+PAT.

## 6. Credentials — host→env map (ADR-007)
The dispatch lib resolves the token from `host`, never prompts: `github.com → $GITHUB_TOKEN` · `codeberg.org → $CODEBERG_TOKEN` · `git.<subnet>… → $FORGEJO_TOKEN`. Brokered by **Home.aDNA** (Keychain + 1P; Rule 6); never inlined; never echoed. Provisioned at P5.

## 7. The `git/` consumer wrapper + `federation_ref` (mirrors III's `iii/`)
Every code-home adopts the standard via a `git/` wrapper — directory `<vault>.aDNA/git/` with a `CLAUDE.md` carrying a `federation_ref` block + the §3 `git_provider` declaration. Schema (mirrors `III.aDNA/what/decisions/adr_002_consumer_federation_contract.md`, with git-specific fields):

```yaml
federation_ref:
  source_vault: Git.aDNA
  source_skill: how/skills/skill_git_provider_config.md   # entry skill
  version: "0.1.0"                # Git.aDNA release pinned at wrapper creation
  version_policy: minor           # minor (review on bump) | locked (manual)
  pinned_at_commit: "<sha>"
  binds_adrs: [adr_004, adr_005, adr_006, adr_007, adr_008, adr_009, adr_011]
  verbs_exposed: [create-repo, set-remote, push, open-pr, cut-release, configure-mirror, port-ci]
  local_extensions:               # optional, per-consumer (kind: doctrine_override | local_skill | hooks)
    - kind: doctrine_override
      path: git/what/context_gitops_local.md
      rationale: <one line>
git_provider: { … see §3 … }
```

Loading: read `git/CLAUDE.md` → resolve `git_provider` + `federation_ref` → the dispatch lib (§8) executes verbs against the declared host. A host swap = a one-field `host` edit + `skill_repo_migrate` (the north-star on-ramp, ADR-010 D1).

## 8. The dispatch lib contract (ADR-004 D6)
Realized as **provider-parametrized skills + a thin shared shell lib** (`how/skills/lib/gitops_dispatch.sh`) — a "`gh api` for Forgejo". Public interface:
- `gitops_backend_for_host <host>` → `github|forgejo`
- `gitops_token_env_for_host <host>` → env-var name (§6)
- `gitops_<verb> <args…>` for each of the 7 verbs — honor `GITOPS_DRY_RUN=1` (print the plan, no network/secrets/writes) vs live (guarded; requires token + explicit opt-in; **P5+ only**).
- **Non-contract helpers** (gated identically; NOT part of the 7-verb contract): `gitops_create_org` (§1.1) and `_gitops_delete_repo` (smoke-teardown only).
A dedicated `adna-git` CLI is deferred (ADR-004 D6) — skills are the unit of distribution (they ship to `.adna/` at P4).

## 9. CI parity (ADR-008)
`port-ci`: one portable workflow in `.github/workflows/` syntax (Forgejo Actions is *familiar, not byte-compatible* and **falls back to `.github/`**); emit a `.forgejo/workflows/` delta-variant **only where a delta requires it** (action-pin · runner-label · secrets · `github.*` context · GitHub-only features). Templates: `what/templates/ci/`.

## 10. Secret hygiene (ADR-011)
`gitleaks` pre-push hook on every code-home (`git/hooks/`); CI scan on both backends; **hard full-history scan gate before ANY host move** (`gitleaks detect`; I-strict client repos need operator sign-off; move blocked until clean); remediation = `git-filter-repo`/BFG + credential rotation via Home.

## 11. Dev-process doctrine block (ADR-009 D6)
The 7-item host-neutral block (`what/doctrine/doctrine_gitops_block.md`) every code-home's CLAUDE.md inherits: remotes (ADR-006) · local-first/HEAD-is-truth · gated outward actions · broker creds · CI portable-first · cross-graph coord memos · secret hygiene.

## Skill ↔ verb map (drafts in `how/skills/`, P3)
| Skill | Verbs | Note |
|---|---|---|
| `skill_git_remote_setup` | create-repo · set-remote · push | supersedes the `.adna/` GitHub-hardcoded original |
| `skill_vault_publish` | push · cut-release | provider-aware |
| `skill_git_provider_config` | (declaration) | manage the `git/` wrapper + fork-hook default |
| `skill_repo_migrate` | set-remote · push · configure-mirror | scan-gated host move (§4, §10) |
| `skill_release_mirror` | configure-mirror | Class R (§5) |

## Dry-run (P3 exit gate)
`how/tests/dryrun_gitops.sh` runs the lib with `GITOPS_DRY_RUN=1` for `host=github.com` **and** `host=codeberg.org` across the verbs and asserts the printed plan carries the right backend marker (`gh api` vs `/api/v1/`) — **no network, no secrets, no writes**. **23/23 PASS** as of 2026-06-21 (was 19/19; +4 asserting the §1.1 fixes — Forgejo `cut-release` `target_commitish`, `create-org` dispatch both backends, and its live-refusal). Live verification of the per-backend `push` auth + Forgejo `cut-release` is deferred to the next gated outward push (operator-run `livesmoke_gitops.sh`, now private-default, or a P6 wave).
