---
type: doctrine
doctrine_id: doctrine_gitops_block
title: "Git-Ops Doctrine Block (host-neutral; propagatable)"
status: active
version: "0.3.0"        # 0.2.0 → 0.3.0 at 2026-08-24: item 9 (wrapper contract version, ADR-004 A1) added + the propagation note's two FALSIFIED figures corrected (69/43 → 61/38, F-P7b-o). MINOR, not patch — the block gains a clause consumers must re-take. (0.1.0 → 0.2.0 earlier the same day: item 8, licensing.)
created: 2026-06-20
updated: 2026-09-07
last_edited_by: agent_stanley
binds_adrs: [adr_004, adr_013, adr_006, adr_007, adr_008, adr_009, adr_011]   # adr_004 A1 = item 9's binding
supersedes_host_policy: adr_005
tags: [doctrine, git, doctrine_block, federation, phase_3, adr_013, licensing, f_p7b_j, adr_013_a1, adr_004_a1, wrapper_contract_version, f_p7b_o]
---

# Git-Ops Doctrine Block (host-neutral)

The **canonical, provider-neutral git-ops doctrine block** every aDNA code-home carries in its `CLAUDE.md` (ADR-009 D6). It replaces the seed §7 block (which baked in `harbor`/GitHub specifics + a self-hosted-canonical stance). Consumers inherit it via their `git/` wrapper (P3 authors; propagated fleet-wide in gated waves at P6; the canonical copy ships to `.adna/` via `aDNA.aDNA` at P4).

> **Usage:** paste the fenced block below into a code-home's `CLAUDE.md` under a `## Git-Ops` heading, then fill the graph's `git/` declaration ([[spec_gitops_provider_abstraction]] §3). The block is **host-neutral** — it reads the same whether the graph lives on GitHub, Codeberg, or a self-hosted Forgejo lighthouse.

```markdown
## Git-Ops (federates Git.aDNA via `git/`)

1. **Remotes** follow Git.aDNA ADR-006 (+ ADR-014) — `origin` (canonical home) · `mirror` (outbound release/discovery) · `upstream` (external, never pushed) · `rollback` (temporary, during a host move) · `mesh`/`mesh-<fabric>` (subnet-internal mesh replica — non-canonical, may run ahead of origin, push-based keep-fresh; ADR-014). Host & visibility per the `git/` declaration (ADR-013 host-role inversion: **released-FOSS → GitHub-public** · **FOSS-in-dev → Codeberg-private** (opens to GitHub at release) · **private/proprietary → GitHub-private-interim → self-hosted**; **Codeberg is FOSS-only**).
2. **Local-first; HEAD is truth; commit after significant edits.** Read before write; never batch a phase into one mega-commit.
3. **Outward actions are gated** — creating remotes, pushing, cutting releases, configuring mirrors, and migrating hosts require operator confirmation. Never improvised.
4. **Credentials via the Home.aDNA broker; never inlined** — host→env-var (`GITHUB_TOKEN`/`CODEBERG_TOKEN`/`FORGEJO_TOKEN`); tokens never transit the conversation (ADR-007).
5. **CI is portable-first** — author workflows in `.github/workflows/` syntax (Forgejo falls back to it); add a `.forgejo/workflows/` variant only where a delta requires it (ADR-008).
6. **Cross-graph writes are staged as coord memos** — never silently write into another vault (workspace Rule 10).
7. **Secret hygiene** — `gitleaks` pre-push hook on every push; a **full-history scan is a hard gate before any host move** (ADR-011); a finding blocks the move until purged + the credential is rotated.
8. **Licensing is part of host placement** (ADR-013 A1) — a graph placed on the **Codeberg lane** (FOSS-only by ToS) or **flipped GitHub-public** declares its license **at the placement**: a `LICENSE` file at the repo root, and the SPDX id in the `git/` declaration. **No license ⇒ the placement verb blocks** — it is not a warning and there is no "publish anyway". A vault is born without a `LICENSE` on purpose (the project picks its own); **choosing one is a step in publishing, not a step someone else will remember.** Private, non-Codeberg placements are unaffected.
9. **Your `git/` wrapper copy has a version, and keeping it current is yours** (ADR-004 A1) — the wrapper's `federation_ref.version` records **the contract revision this copy was last refreshed to**. `Git.aDNA` owns the contract, cuts bumps into its release ledger, and announces them in its `CHANGELOG.md`; **you refresh, in your own vault, via `skill_git_wrapper_refresh`** (Rule 10 — nobody writes into your wrapper). Verify with `census_wrapper_copy.sh --vault <your-vault>`. ⚠ **Being out of date is not a violation** and **no verb is gated on it** — but a stale copy is the file you would re-install your secret gate *from*, and 35 fleet copies are currently a **fail-open** skeleton: it scans, blocks on a finding, and **exits 0 when `gitleaks` is absent**, with no push-range scan. ⛔ **A missing copy is a *different* repair from a stale one** (absence is honest; a stale copy reads installed) — do not fold the two.
```

## Provenance & deltas from the seed §7 block
- `harbor` remote → generalized to **`rollback`** (ADR-006) — host-neutral.
- "no new internal repos on GitHub" / "git.aDNA canonical" → replaced by the **visibility-driven host policy** ([[adr_013_host_role_inversion|ADR-013]], host-role inversion — **supersedes** ADR-005's Codeberg-public-home direction; revives ADR-003's direction, ToS-scoped).
- Added **secret-hygiene** (item 7, ADR-011) and **CI portable-first** (item 5, ADR-008) — absent from the seed block.
- Added **licensing** (item 8, ADR-013 A1) 2026-08-24, occasioned by **F-P7b-j**. Measured `2026-08-24T03:52Z`: **18 of 19** Codeberg repos and **3 of 4** GitHub-public ones — `Git.aDNA` itself among them — carry no license at `HEAD`. ⭐ **The root cause is a deliberate rule with a missing half**: `.adna/how/skills/skill_project_fork.md:100` removes the template `LICENSE` so the project picks its own, and **nothing downstream ever asks it to** — not the fork skill, not this block (which carried **zero** licensing tokens until now), not any wave runbook, not ADR-013. Every vault was born unlicensed *by design* and then placed on a host whose ToS assumes otherwise. ⛩ **Both silent halves were ours**; the fork-skill half is Rosetta's and is asked, not taken.

## Propagation note (2026-08-24) — this block is copied, so a change here is fleet drift

**61 vaults carry a `how/federation/git/` wrapper**; **38** hold a hook copy and **23 hold none at all**.
Item 8 does **not** reach them by being written here. Consumers re-take at their own gate (**Rule 10** —
cross-vault writes are staged as coord memos, never applied silently), which is why the `version` moved to
**0.2.0**: ⭐ *a propagatable artifact whose version does not move cannot tell a stale copy from a current
one*, and that is precisely how 35 vaults came to hold documentation nobody knew was old. The
**enforcement** does not depend on propagation — the gate lives in `gitops_dispatch.sh`, which every
placement runs through regardless of whether a consumer's prose is current.

> ### ⛔ Correction — this note carried BOTH falsified figures until 2026-08-24T21:35Z
>
> As first written it read *"**69** vaults carry a wrapper, and F-P7b-l already has **43** of them holding
> a stale wrapper copy."* **Neither number reproduces.** Both were produced by grepping the stale install
> string `ln -sf ../../git/hooks/…` — **a string carried by the P3 skeleton, by v2.0.0 and by v2.1.0
> alike**, so it could not separate the populations it was being asked about (**F-P7b-o**). Instrumented
> by mechanism ([[../inventory/secret_gate_census|census]] §7): **61 wrapper dirs · 38 copies · 23 absent ·
> 35 P3 skeleton · 2 v2.0.0 · 1 v2.1.0**.
>
> ⭐ **The lesson is where the stale figures survived, not that they existed.** ADR-013 A1's clause text
> was corrected *before* its stamp — *"a falsified figure must not be signed into ratified text"* — and
> the sweep stopped at the ratified document. **This file is the one the fleet actually copies**, so a
> falsified figure here propagates further than one in an ADR. ⛩ *Correcting the record where the
> signature lands is not the same as correcting it where the readers are.*
>
> The **substance** of the note is unchanged and is strengthened: the stale population is smaller than
> claimed, and worse than claimed — 35 of the 38 copies are not merely out-of-date prose but a
> **fail-open** gate, and the 23 with no copy are a **different repair** that the old single number hid
> entirely.

## ADR-013 reconciliation (2026-06-21)
Item 1's host-policy clause was reconciled from the superseded **ADR-005** direction (*public/FOSS → Codeberg*) to **ADR-013** (*released-FOSS → GitHub-public; FOSS-in-dev → Codeberg-private; proprietary → GitHub-private→self-hosted*). Done at P6 before the block was staged into Wave-1 graphs (`session_stanley_20260621_git_p6_wave1_prep`) — so the fleet never inherits the pre-inversion text. Version held at `0.1.0` (genesis draft; matches the spec's same-day handling); `binds_adrs` now leads with `adr_013`.
