---
type: decision
adr_id: adr_004
title: "ADR-004 — Git-Ops Provider-Contract Interface (binding)"
status: accepted   # base ADR (D1–D6) accepted 2026-06-20 and NOT edited. ✅ Amendment A1 ACCEPTED 2026-08-24 (operator §7.7 at the plan gate; discharges the OURS half of F-P7b-o — the wrapper contract's `version` field was specified at P3, never bound, and therefore never owned or bumped).
created: 2026-06-20
updated: 2026-08-24   # Amendment A1 appended + stamped. D1–D6 clause text untouched.
last_edited_by: agent_stanley
ratifies_at: "authored at genesis P2 (2026-06-20); ratified at the P2-exit gate (proposed → accepted)"
depends_on: [adr_000, adr_001]
supersedes: adr_002
amendments:
  - id: A1
    title: "The wrapper contract's `version` gets an owner and a bump trigger (extends D4 / spec §7)"
    status: accepted
    date: 2026-08-24
    discharges: F-P7b-o (ours half)
    wires_no_gate: true   # ⛔ §5 — deliberate. No placement verb is gated on contract version.
tags: [decision, adr, adr_004, git, provider_abstraction, forgejo, github, rest_api, binding, accepted, amendment_a1, wrapper_contract_version, f_p7b_o, distribution]
---

# ADR-004 — Git-Ops Provider-Contract Interface (binding)

**Status**: `accepted` (authored at genesis **P2**, 2026-06-20; ratified at the P2-exit gate). **Supersedes [[adr_002_provider_abstraction]]** (the P0 sketch) — promotes it to the binding interface using P1 evidence. Depends on [[adr_000_project_identity]] (D5), [[adr_001_seed_docs_reframe]].

## Context

[[adr_002_provider_abstraction]] sketched a git-ops **provider contract** (verbs over two backends) and left five questions for P1. P1 answered them — [[context_provider_tooling_sota]] fixed the **tool-of-record = raw Forgejo REST `/api/v1`** (not `tea`/`fj`), enumerated the mirror mechanics + their gotchas, and confirmed `gh` already wraps REST on the GitHub side. This ADR makes the contract **binding** so P3 can author skills against a stable interface.

## Decisions

### D1 — The verb set (binding; host-neutral)
A graph's git-ops are exactly these seven verbs. Skills and doctrine call the **verb**; the verb dispatches to a **backend**. A pattern that names a provider instead of a verb is a defect (Standing Order #4).

| Verb | Contract semantics (host-neutral) | GitHub backend | Forgejo backend *(Codeberg + self-hosted)* |
|---|---|---|---|
| `create-repo` | get-or-create a remote repo for `{org, name, visibility}` (idempotent) | `gh api /orgs/{org}/repos` | `POST /api/v1/orgs/{org}/repos` |
| `set-remote` | point a named local remote at a provider URL | `git remote …` | `git remote …` (same git) |
| `push` | publish history + tags | `git push` | `git push` |
| `open-pr` | propose `head → base` | `gh api …/pulls` | `POST /api/v1/repos/{o}/{r}/pulls` |
| `cut-release` | tag-anchored release (+ optional assets) | `gh api …/releases` | `POST /api/v1/repos/{o}/{r}/releases` + asset upload |
| `configure-mirror` | get-or-create a push-mirror `origin → target` (idempotent) | (GitHub is usually the mirror *target*, not origin) | `POST /api/v1/repos/{o}/{r}/push_mirrors` (Forgejo-native) |
| `port-ci` | place/sync the CI surface for the host | `.github/workflows/` | `.forgejo/workflows/` (GitHub-Actions-familiar syntax, `.github/` fallback — [[adr_008_ci_cd_parity\|ADR-008]]) |

### D2 — Two backends cover three profiles (no third backend)
Because **Codeberg runs Forgejo**, one Forgejo backend serves **hosted Codeberg and any future self-hosted lighthouse** — the abstraction is a **2-backend** problem (GitHub-API + Forgejo-API). `backend` is *derived* from `host`: `github.com → github`; everything else (`codeberg.org`, `git.<subnet>.adna.network`) `→ forgejo`.

### D3 — Tool-of-record (binding; P1-resolved)
The Forgejo backend is the **raw REST API `/api/v1`**, driven `gh api`-style (`Authorization: token <PAT>`) — *not* `tea`/`fj`. Rationale ([[context_provider_tooling_sota]]): only REST covers the critical path (`push_mirror`/`pull_mirror`/webhook/deploy-key are REST-only; `tea` exposes workflow surface only); the API is pinned Gitea-1.22-compatible (survived the hard fork — durability); REST exposes the status/payloads idempotency needs; and it is **symmetric** with the GitHub side (`gh` is already a REST wrapper) — one pattern, two endpoints (swap base URL + token). `tea`/`fj` are **optional human-convenience adjuncts only, never the automation path**.

### D4 — Per-graph declaration (binding schema)
Each graph declares its git-ops posture in machine-readable form (the `git/` consumer wrapper carries it — P3). The schema is **host-neutral**; [[adr_005_visibility_host_policy|ADR-005]] sets the *default* host per visibility, [[adr_006_remote_naming|ADR-006]] governs the remote names.

```yaml
git_provider:
  host: github.com            # github.com | codeberg.org | git.<subnet>.adna.network
  backend: github             # github | forgejo  (derived from host; explicit for clarity)
  org: aDNA-Network
  visibility: private         # private | public
  class: I                    # I internal · P public-primary · R release-mirrored · L local-only (ADR-005)
  lfs: false                  # LFS present? (drives the HTTPS+PAT mirror caveat, D5)
  remotes:
    origin: github.com/aDNA-Network/Git.aDNA       # canonical home (ADR-006)
    mirror:                                          # optional outbound mirror target (Class R/discovery)
    upstream:                                        # optional external-tracked-not-owned
```

A host swap (e.g. GitHub-interim → self-hosted lighthouse) is a **one-field edit + re-point**, not a tooling rewrite — that is the **north-star on-ramp** ([[adr_010_mesh_git_north_star|ADR-010]]).

### D5 — `configure-mirror` contract (P1 gotchas are binding)
The mirror verb MUST encode the P1 findings, or it will silently misbehave:
- **No in-place update.** A push-mirror config cannot be edited — change = **delete + re-add** (`repoDeletePushMirror` → `repoAddPushMirror`). Idempotency pattern is **get-or-create / delete-then-recreate**, never update.
- **No tags-only toggle.** Filter is branch-glob only; blank filter = `git push --mirror` (all branches **+ tags**, force). A "release-only" mirror is achieved by branch-filter + tag discipline, not a tags-only switch.
- **LFS does not mirror over SSH.** LFS repos (`lfs: true`) MUST mirror via **HTTPS + PAT**, never SSH+deploy-key.

### D6 — Implementation form (direction; P3 builds)
The contract is realized as **provider-parametrized skills + a thin shared shell lib** — a "`gh api` for Forgejo" HTTP client wrapping `/api/v1` with the brokered token ([[adr_007_credential_model|ADR-007]]). A dedicated `adna-git` CLI is **deferred** (revisit if the shell lib grows unwieldy) — skills are the unit of distribution because they ship to `.adna/` via `aDNA.aDNA` (ADR-000 D4). Optional backend libraries (Gitea Go SDK / `pyforgejo`) are allowed inside a skill but are not the contract.

## Consequences

- The two GitHub-hardcoded `.adna/` skills (`skill_git_remote_setup`, `skill_vault_publish`) become **verb-dispatching + provider-parametrized** (P3 drafts; P4 upstreams). `skill_update_all_vaults` is already host-neutral.
- A new per-graph **`git/` consumer wrapper** carries the D4 declaration (P3) — the III `iii/` wrapper is the template.
- ForgeFed federation (same Forgejo backend, federated) is the technical substrate of the mesh-git north star ([[adr_010_mesh_git_north_star|ADR-010]]) — experimental today ([[context_provider_tooling_sota]]).
- CI parity (`port-ci`) is a first-class verb with its own ADR ([[adr_008_ci_cd_parity|ADR-008]]).

## Open questions — resolved / carried
- ✅ Tool-of-record (`tea` vs REST) → **REST** (D3).
- ✅ Contract as skills+lib vs CLI → **skills + thin lib**, CLI deferred (D6).
- → Auth UX for the Forgejo token in non-TTY contexts → [[adr_007_credential_model|ADR-007]].
- → `open-pr`/`cut-release` semantic deltas (GitHub vs Forgejo review/release models) → captured per-verb in P3 skill specs.
- → Submodule / package-registry parity across backends → [[adr_008_ci_cd_parity|ADR-008]] + P3 parity notes.

## Alternatives considered
- **`tea`/`fj` as the backend** — rejected (D3): no mirror/webhook/deploy-key coverage; Gitea-org drift risk.
- **Three backends** (Codeberg distinct from self-hosted) — rejected: Codeberg *is* Forgejo; one backend, half the surface.
- **A git-remote-helper / multi-forge wrapper wholesale** — rejected as the contract; may appear as a backend impl detail, but the aDNA verb set + per-graph declaration + broker integration are ours regardless.

---

## Amendment A1 — The wrapper contract's `version` gets an owner and a bump trigger (extends D4 / spec §7) — **accepted 2026-08-24**

*Discharges the **ours** half of **F-P7b-o** (filed 2026-08-24: 35 of 38 fleet wrapper copies are the fail-open P3 skeleton, so Hestia's §C retirement condition cannot be cleared by the remedy named beside it). **D1–D6 are ratified and are NOT edited** — A1 extends D4 and binds a field spec §7 already carries. Ratification: **decision** = A1 as written · **ratified-by** = **operator (Stanley), §7.7 at the plan gate, primary account, in-session** · **date** = **2026-08-24** · **status** = `accepted`.*

> ⚠ **Signature basis, stated rather than inflated.** A plan-gate acceptance of a recommendation, not a per-clause reply to a ratification packet. The plan named A1, all five clauses, and an explicit *"say so at approval and it stays `proposed`"* escape that was **not taken** — ⭐ *an offered refusal declined is a stronger basis than silence*, which is why this stamp is not read as assumed consent.
>
> ⛔ **Disclosed, because it bears on what was signed.** The Consequences bullets below record **two findings made after plan approval and before this stamp** — the D4-schema gap (§C1) and the III comparison (§C2). Neither changes a clause; both strengthen the rationale for §1–§2, and the operator did not see them at approval. They are annotated **before** the stamp so the signature lands on final text, and **named here** so a later reader is not left to infer which parts were pre-approval and which were not.

**Headline: spec §7 has specified `federation_ref.version`, `version_policy: minor  # review on bump`, and `pinned_at_commit` since P3 — and the field has never once been bumped. The shipped hook went `216aaca2` → `2.0.0` → `2.1.0` with the contract pinned at `0.1.0` throughout. The fleet is not stale because distribution was never designed; it is stale because a designed mechanism was never operated. Measured `2026-08-24T19:16Z`: 61 wrapper dirs · 38 copies · 35 P3 skeleton · 2 at v2.0.0 · 1 at v2.1.0 · 23 with no copy at all.**

1. **`Git.aDNA` owns the contract version, and a bump is recorded in exactly one place.** The `git/` wrapper contract carries a version distinct from the hook's `HOOK_CONTRACT_VERSION` and from any graph's own version. Bumps are cut here and recorded in [[../inventory/wrapper_contract_releases|`wrapper_contract_releases.md`]]. `federation_ref.version` in a consumer wrapper means **the contract revision that copy was last refreshed to** — a fact about the copy, not decoration. ⛔ *An ownerless version field is the same defect as ADR-013 D1's ownerless FOSS predicate, and A1 there is the precedent this clause follows.*

2. **The bump trigger is named, and so is the signal.** Any change to a **distributed artifact** under `how/federation/git/` — the hook, `.gitleaks.toml`, or the wrapper schema — cuts a contract bump. The signal a consumer reads is the release ledger row plus this vault's `CHANGELOG.md`. ⭐ **Adopted from `III.aDNA`'s ADR-002 §3 with credit**, which binds exactly this in a decision and names its CHANGELOG as the bump signal. Its Context lists the problem it was solving — *"consumers can't tell when III changes"* — **which is verbatim the condition of our 35.**

3. ⛔ **A1 binds PROSPECTIVELY. It does not convert 35 stale copies into errors at the ratification instant.** This is deliberate and it is **ADR-014 A4 §1a**'s hazard, avoided by construction — the same engineering ADR-013 A1 §3 applied to the 21 unlicensed repos. A copy at `0.1.0` is **out of date, not in violation**; its holder caused nothing and is owed a performable remedy rather than a finding against them.

4. **The refresh act is the consumer's under Standing Rule 10; making it performable and verifiable is OURS.** Replacing a wrapper copy is a different act from re-installing a hook, and it belongs to each vault. What was missing was not the consumer's willingness — it was a procedure to follow ([[../../how/skills/skill_git_wrapper_refresh|`skill_git_wrapper_refresh`]]), a version to refresh *to*, and an instrument to prove it landed (`census_wrapper_copy.sh --vault`). ⛩ **That half was ours and had no owner, which is why F-P7b-o's hold had no exit.**

5. **Ships with an instrument, and wires NO blocking gate.** The refresh skill and the `--vault` verifier are tooling a consumer opts into; **no placement verb is gated on a contract version.** ⭐ *This clause exists because ADR-013 A1's own Consequences recorded that `_gitops_license_gate` was enforcing A1 while A1 was `proposed` — "an enforcing check is a stronger claim on the world than a written clause, so shipping the check first inverts the order §7.7 exists to impose."* The correction is **applied** here rather than restated. A future decision to gate on contract version is a **new** amendment, taken deliberately.

### Consequences (A1)

- **(C1) ⛔ The root cause is one layer deeper than F-P7b-o recorded, and it is a governance gap rather than a tooling one.** **D4's binding schema contains no `version` field at all.** `federation_ref` — with `version`, `version_policy`, and `pinned_at_commit` — was introduced at **P3, in the spec**, mirroring III's consumer contract, and was **never carried into a binding decision**. ⭐ *A spec field with no ADR behind it has nobody obliged to operate it*, so "never bumped" was not an oversight that happened to a rule; it is what an unbound field does by default. A1 is that binding.
- **(C2) ⭐ The template we cited already contained the half we dropped.** ADR-004's own Consequences say *"the III `iii/` wrapper is the template."* `III.aDNA`'s ADR-002 **binds** the version policy in a decision, defines `minor` as *"consumer reviews when III.aDNA bumps minor version… reads the CHANGELOG diff and decides"*, requires a `rationale:` per extension, and keeps its amendment history **as the audit log**. We copied the two schema lines and left behind the decision, the signal, and the review obligation. ⛩ *Copying a pattern's shape without its enforcement is the same act as writing a label instead of a control* — ADR-011's opening sentence, reproduced at the level of an entire federation contract.
- **(C3) ⚠ The 23 `COPY_ABSENT` wrapper dirs are a DIFFERENT repair and must not be folded into the 35.** Per **ADR-011 A4 §5**, absence is *honest* and a missing copy is already legible as missing; the P3 skeleton is *deceptive* — it reads installed and, lacking a push-range scan, exits 0 when `gitleaks` is absent. A refresh wave that treats the two as one population would report a single number over two defects, which is the conflation F-P7b-o was filed for.
- **(C4) ⚠ Nothing measured here changes the INSTALLED surface, and that separation is load-bearing.** `census_secret_gate.sh` continues to report **0 dangling installs** fleet-wide. A1 governs the **distributed** artifact — the file a consumer re-installs *from*. Two instruments, two objects; ADR-011 **A6** is why they are deliberately not merged.
- **(C5) The contract's first bump is `0.1.0 → 0.2.0`**, carrying hook `2.1.0`. The interval in which the hook reached `2.0.0` with no bump cut is recorded in the release ledger **as the gap it was**, not backdated into a tidy history.
