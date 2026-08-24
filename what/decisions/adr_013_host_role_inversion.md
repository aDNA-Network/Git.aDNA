---
type: decision
adr_id: adr_013
title: "ADR-013 — Host-Role Inversion (GitHub-public-home / Codeberg-private-FOSS-dev; supersedes ADR-005 Path B; reverses SD-1)"
status: accepted   # base ADR (D1–D7) accepted 2026-06-20 and NOT edited. ✅ Amendment A1 ACCEPTED 2026-08-24 (operator §7.7 at the plan gate; discharges F-P7b-j — the 🚩 FOSS predicate D1 is keyed on had no owner and no check point).
created: 2026-06-20
updated: 2026-08-24
last_edited_by: agent_stanley
ratifies_at: "authored + operator-ratified at R1/P5 (2026-06-20), mid-beachhead; per-graph assignments re-confirmed wave-by-wave at P6"
depends_on: [adr_000, adr_004, adr_005]
supersedes: adr_005
tags: [decision, adr, adr_013, git, visibility, codeberg, github, host_policy, inversion, foss_in_dev, binding, accepted, operation_free_harbor]
---

# ADR-013 — Host-Role Inversion (GitHub-public-home / Codeberg-private-FOSS-dev)

**Status**: `accepted` (authored + **operator-ratified at R1/P5**, 2026-06-20, mid-beachhead). **Supersedes [[adr_005_visibility_host_policy|ADR-005]]** (Path B) — reverses its public-home *direction* and **reverses SD-1**; **carries forward** ADR-005's proprietary/self-hosted posture, Operation-Homecoming coexistence, and the mesh-git north star. Depends on [[adr_004_provider_contract_interface|ADR-004]].

## Context

[[adr_005_visibility_host_policy|ADR-005]] (Path B, genesis P2) set **Codeberg as the public-FOSS *home*** (origin) with GitHub as a discovery mirror, and **GitHub-interim-private** for the ~95%-private fleet — itself a correction of [[adr_003_visibility_split_policy|ADR-003]] after the P1 finding that Codeberg's ToS forbids private *proprietary* repos.

At **R1/P5** (the first outward step) the operator stated the actual intent: **use Codeberg for private development; keep public repos on GitHub** — i.e. ADR-003's original *direction*. Surfaced against Codeberg's FOSS-only ToS, the operator chose the **ToS-compliant** form: Codeberg-private is scoped to **FOSS projects kept private *during development*** (opened/released to GitHub-public when ready), **never** to proprietary code.

This **re-inverts** the public-home direction (Codeberg → GitHub) and adds an explicit **FOSS-in-private-development** lane on Codeberg. The permanent architecture ([[adr_000_project_identity|ADR-000]] D5) is unchanged: provider-agnostic contract; self-hosted Forgejo = north-star private home; user host-choice preserved forever. Path B was *near-term sequencing*; this ADR corrects its direction to the operator's actual model.

## Decisions

### D1 — The host split, re-inverted (binding)

| Visibility / kind | Default **origin** | Eventual home | Public face | Why |
|---|---|---|---|---|
| **public / released FOSS** | **GitHub** (`aDNA-Network`, public) | GitHub | — (GitHub *is* the public home) | GitHub's network effect = discovery/stars/PRs for released work |
| **FOSS, in private development** | **Codeberg** (`aDNA-Network`, **private**) | opens → GitHub-public at release | GitHub on release | develop privately; Codeberg-private is ToS-OK **only** for FOSS-bound work |
| **private / proprietary / client** | **GitHub** (private, interim) | **self-hosted Forgejo** (post-P7) | — | Codeberg ToS forbids proprietary; **unchanged** from ADR-005 |
| **release of internal work** (Class R) | private origin | self-hosted | GitHub mirror on tags | **unchanged** from ADR-005 D3 |
| **local-only** (Class L) | none | none | — | Rule 4 / legal IP |

> 🚩 **Codeberg = FOSS-only.** Codeberg-private is permitted *only* for FOSS work that will be opened (pre-release development) — **never** for proprietary/closed code. This ToS line is exactly what separates row 2 from row 3.

### D2 — Repo classes (P/I/R/L retained; P gains a pre-release host state)
- **P — Public-primary** (FOSS): **released → GitHub-public** origin; **in private development → Codeberg-private** origin (pre-release; opens to GitHub at release). This pre-release Codeberg-private state **is** the "private dev on Codeberg" lane. *(Reverses ADR-005's Codeberg-origin-for-P.)*
- **I / I-strict — proprietary / client**: GitHub-private (interim) → self-hosted Forgejo. **Never Codeberg.** *(unchanged)*
- **R — Release**: private origin + public mirror on tags. *(unchanged)*
- **L — Local-only**: never push (Rule 4 / legal IP). *(unchanged)*

**Decision tree:** released & FOSS? → **P-released** (GitHub-public). FOSS but developed privately first? → **P-dev** (Codeberg-private, opens at release). Proprietary/client? → **I / I-strict** (GitHub-private → self-hosted; never Codeberg). Authored internally, published outward? → **R**. Never-push? → **L**.

### D3 — Git.aDNA itself → GitHub-public (reverses SD-1)
Git.aDNA is the open git-ops standard — public by nature, with no private-dev phase. Its public home is **GitHub** (`github.com/aDNA-Network/Git.aDNA`, public, class **P-released**). This **reverses SD-1** (ratified 2026-06-20, which had pinned Git.aDNA to Codeberg-public). `git/CLAUDE.md`'s `git_provider` is updated accordingly; `origin` is set at the P5 dogfood.

### D4 — Open/release flow (P-dev → public)
When a P-dev (Codeberg-private) graph is ready to open: either **(a)** migrate origin Codeberg→GitHub-public (repoint + Home shim, [[adr_006_remote_naming|ADR-006]]), or **(b)** configure a Codeberg→GitHub push-mirror and flip the GitHub repo public at release ([[adr_004_provider_contract_interface|ADR-004]] D5 mechanics). Direction is chosen per-graph at the open gate. *(This re-scopes ADR-005's "release-mirror" — P5 step F — to the open-flow; it is exercised when a P-dev graph first releases, not at the beachhead.)*

### D5 — Carried forward from ADR-005 (unchanged, still binding)
- **Proprietary/client posture**: GitHub-private (interim) → self-hosted Forgejo (post-P7); I-strict history-scan-gated ([[adr_011_secret_scanning|ADR-011]]); external upstreams never re-homed (ADR-005 D7).
- **Homecoming coexistence** (ADR-005 D6): GitHub `aDNA-Network` stays the public + private-interim home; `aDNALabs.aDNA` (Berthier) owns the org-level program; **operator + Berthier jointly gate each wave**.
- **Self-hosted mesh-git north star** ([[adr_010_mesh_git_north_star|ADR-010]] / [[adr_012_lighthouse_operator_default_and_context_sync|ADR-012]]) + provider-agnostic contract (ADR-004).
- **Credential model** ([[adr_007_credential_model|ADR-007]]): `GITHUB_TOKEN` + `CODEBERG_TOKEN` now, `FORGEJO_TOKEN` later.

### D6 — New-graph defaults (`git/` fork-hook)
public/released → **GitHub-public** · FOSS-in-dev → **Codeberg-private** · proprietary → **GitHub-private/self-hosted**. Retires ADR-005 D5's "new FOSS → Codeberg-public" default.

### D7 — Classification re-confirmed at P6 (no silent flips)
[[fleet_git_state]] is re-mapped to the D1 table; the intended-public OSS set (`aDNA · III · Canvas · Astro · Videos · Molecules · Oration · TypeScript · …`) splits per-graph into **released → GitHub-public** vs **still-in-dev → Codeberg-private**, authorized wave-by-wave at gated P6.

## Amendment A1 — The FOSS predicate gets an owner and a check point (extends D1) — **accepted 2026-08-24**

*Discharges **F-P7b-j** (filed 2026-08-23 while staging P7b obj 5). **D1–D7 are ratified and are NOT edited** — A1 extends D1. Ratification: **decision** = A1 as written · **ratified-by** = **operator (Stanley), §7.7 at the plan gate, primary account, in-session** · **date** = **2026-08-24** · **status** = `accepted`. ⚠ *Signature basis is a plan-gate acceptance of a recommendation, not a per-clause reply to a ratification packet — stated so a later reader sees which of the two happened. The Consequences annotations above (the corrected wrapper-copy figure, the enforce-before-ratify interval, and §3's outstanding ledger debt) were written **before** this stamp, so the signature lands on final text.*

**Headline: D1's 🚩 line states the load-bearing predicate — *"Codeberg-private is permitted only for FOSS work that will be opened"*, and *"this ToS line is exactly what separates row 2 from row 3"* — and then assigns nobody to establish it, nowhere to check it, and no moment at which it is checked. Measured `2026-08-24T03:52Z`: 18 of 19 Codeberg repos and 3 of 4 GitHub-public ones carry no license at `HEAD`. The rule was never violated; it was never asked.**

1. **The predicate is a *placement* precondition, and it is checked at the placement verb.** A repo is placed on the **Codeberg lane** (any visibility — the ToS binds on the host, not on the flag) or **flipped GitHub-public** only if it declares a license: a `LICENSE` file at the repo root plus the SPDX id in the `git/` declaration. **No license ⇒ the verb blocks.** Fail-closed, per ADR-011 A2 §2's discipline: an absent input may never silently remove the layer. **An undeterminable reading is a BLOCK, never a pass** (ADR-011 A4 §2(a)). Private, non-Codeberg placements are untouched — the predicate is D1's, and D1 scopes it to rows 1 and 2.

2. **Three owners, named separately, because they are three different decisions.**

   | Question | Owner |
   |---|---|
   | *Is the predicate enforced, and where?* | **Git.aDNA** (Hopper) — the check, the verb, the harness. **Taken here.** |
   | *Which license does an aDNA graph carry?* | **`aDNALabs.aDNA`** (Berthier) — an org/legal call, not a tooling one. **Asked, not taken.** |
   | *What asks a new graph to pick one?* | **`aDNA.aDNA`** (Rosetta) — `.adna/how/skills/skill_project_fork.md:100` deletes the template `LICENSE` under R4 so the project picks its own, and nothing downstream ever asks. **Asked, not taken** (Standing Rule 1). |

   ⭐ **The mechanism is not broken — it is never invoked.** The only two licensed graphs (`Exchange.aDNA` MIT, `Astro.aDNA` BSL-1.1) are **exactly the two where a human decided.** R4 is a correct rule missing its second half.

3. ⛔ **A1 binds PROSPECTIVELY. It does not convert 21 already-placed repos into errors at the ratification instant.** This is deliberate and it is the hazard **ADR-014 A4 §1a** was engineered against: a clause that makes pre-existing state an error the moment it is signed puts every holder in a state nobody caused. The already-placed unlicensed set is instead **a finding with an owner — named here, not performed here** (ADR-011 A3 §4): enumerated, dated, and carried on the [[../inventory/disposition_ledger|disposition ledger]] with an explicit `license_state`, a **third value and never an absence** — because *an absent field cannot be distinguished from a dropped one*.

4. ⚠ **`Git.aDNA` is in that set, and says so here rather than being found in it.** This vault is GitHub-public and unlicensed, and has been distributing under all-rights-reserved since **2026-06-20** — from the graph whose thesis is portability and open standards. ⭐ **The exposure asymmetry is the part that was not obvious going in:** the Codeberg set is *private and undistributed*, so its ToS exposure is latent; **the public lane is actually distributing, and that is the one with a clock running.** An amendment authored to fix the private lane would have fixed the wrong lane first.

5. **The check ships with the amendment, not after it.** `_gitops_license_gate` in `how/skills/lib/gitops_dispatch.sh`, called from `gitops_create_repo` and `gitops_set_visibility`, with harness cases on **both arms** (ADR-011 A4 §6 / A5 §2) — sabotage cases *required to fail* and controls *required to pass*. ⛩ **This clause exists because ADR-011's own Context opens with *"A label is not a control"***, and an amendment that named a check point while shipping no check would be that sentence's next instance. **The gate does not depend on doctrine propagation** — the fleet's wrapper copies are overwhelmingly stale (F-P7b-l), and a rule that only works where the documentation is current is not a control either. ⚠ *Corrected before the stamp, visibly rather than silently: this clause as drafted read "43 vaults hold stale wrapper prose", a figure produced by an ad-hoc grep. Instrumented at `2026-08-24T18:27Z` ([[../inventory/secret_gate_census|census]] §wrapper-copy) the population is **61 wrapper dirs, 38 hook copies — 33 of them the retired v1 no-op, 2 UNCLASSIFIED, 2 at v2.0.0, 1 at v2.1.0**. The substance of this clause is unaffected and is in fact strengthened; the number is not, and **a falsified figure must not be signed into ratified text** (F-P7b-o).*

## Consequences
- (A1) The 🚩 predicate D1 calls *"exactly what separates row 2 from row 3"* becomes checkable at the moment it matters. **21 of 23 published repos are non-conforming today** — a number that was unobtainable while nothing measured it.
- (A1) ⚠ **The two silences were both ours.** `doctrine_gitops_block.md` carried **zero** licensing tokens until 2026-08-24, and this ADR named a predicate and assigned no one. Neither was a peer's gap, and neither is asked of a peer.
- (A1) ⛔ **This stamp ends a state in which shipped code enforced unratified text.** `_gitops_license_gate` was authored, wired to both placement verbs and covered on both harness arms on 2026-08-24 — **while A1 was `proposed`.** §5 argued that a check must ship with its amendment, and that remains right; what it did not say is that the interval between the two is itself a defect. ⭐ *An enforcing check is a stronger claim on the world than a written clause, so shipping the check first inverts the order §7.7 exists to impose* — the same error this desk apologised to Rosetta for on 2026-08-23, when A5 was delivered as an instruction to act while still `proposed`. Named here at the stamp rather than left for a later reader to reconstruct from commit order.
- (A1) ⚠ **§3's promise is outstanding at the moment of ratification, and is recorded as owed rather than as done.** A1 §3 commits the already-placed unlicensed set to the [[../inventory/disposition_ledger|disposition ledger]] with an explicit `license_state`. As of this stamp the ledger carries **zero** `license_state` values. The clause binds prospectively, so nothing is in an error state — but **a promise inside ratified text is a debt from the instant it is signed**, and it is carried on the debt register as ours.
- The **R1/P5 beachhead** now dogfoods **both backends in their real roles**: Git.aDNA → GitHub-public (D3); a FOSS-in-dev pilot (`TypeScript.aDNA`) → Codeberg-private (P-dev). Strongest possible proof of provider-agnosticism.
- The **provider-agnostic contract is unaffected** — only the default host *bindings* change; the 7 verbs run identically on GitHub-API and Forgejo-API.
- ADR-005's careful posture for proprietary/client repos is **preserved** — no proprietary repo ever lands on Codeberg.
- Release-mirror is deferred to the D4 open-flow (re-scopes P5 step F).

## Provenance
[[adr_003_visibility_split_policy|ADR-003]] (private→Codeberg, P0) → superseded by [[adr_005_visibility_host_policy|ADR-005]] (Path B: Codeberg-public-FOSS, P2, over the ToS finding) → superseded by **ADR-013** (re-inverts the public-home to GitHub; scopes Codeberg to FOSS-in-dev). The *direction* has returned to ADR-003's intent, now ToS-correct. **SD-1** (Git.aDNA→Codeberg-public) is **reversed** (D3).

## Alternatives considered (at the R1/P5 checkpoint)
- **Keep ADR-005 Path B** (Codeberg-public home) — rejected by the operator; it inverts their actual workflow (private dev on Codeberg, public on GitHub).
- **Codeberg for *all* private dev incl. proprietary** — rejected: violates Codeberg ToS (the P1 finding). Proprietary stays GitHub-private → self-hosted (D5).
- **Drop Codeberg entirely (GitHub-public + self-hosted-private)** — rejected for now: Codeberg-private is a valid, free ToS-compliant home for FOSS-in-dev and exercises the Forgejo backend ahead of the self-hosted lighthouse.
