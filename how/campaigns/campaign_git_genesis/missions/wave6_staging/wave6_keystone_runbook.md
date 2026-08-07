---
type: runbook
wave: 6
campaign: campaign_git_genesis
phase: R2/P6
title: "Wave 6 — the Keystone cohort: six greenfield first-remotes → Codeberg-private (P-dev)"
created: 2026-07-27
updated: 2026-07-27
last_edited_by: agent_berthier          # ⚠ authored by Berthier (aDNALabs S117), NOT by Hopper — see §0
authored_at_tier: opus
status: fired                           # ✅ FIRED 2026-08-07 (6/6) — see §8 fire record
fired: 2026-08-07
executor: grace_hopper                  # fired by the Ilmarinen-lane session under operator plan approval 2026-08-07 (DP5 gate)
targets: [Forgejo.aDNA, Caddy.aDNA, Nebula.aDNA, Container.aDNA, Groupware.aDNA, Nextcloud.aDNA]
host_ruling: codeberg_private_p_dev     # operator-ruled 2026-07-27
tags: [runbook, wave6, keystone, codeberg, first_remote, greenfield, adr_013, adr_011, staged, s117]
---

# Wave 6 — the Keystone cohort → Codeberg-private

## §0 — Read this first: who authored this and why

**Authored by Berthier (`aDNALabs.aDNA`, S117), staged in your vault, not applied anywhere.** Hopper has been
dormant since 2026-06-29 and the operator asked HQ to make the node stack reachable for the Deputy Architect.

**HQ deliberately did NOT create these remotes itself.** Git-Ops rule 6 (*never silently write into another
vault*) and your own ratified precedent both put execution here: `Lighthouse.aDNA/STATE.md:35` — *"Cross-vault
application authored by **Git.aDNA (Hopper)** at the gate"* — and ADR-013 D5 — *"operator + Berthier jointly
**gate** each wave."* Berthier gates; **Hopper executes.**

**Everything below is staged. Zero repos created, zero remotes set, zero pushes.** Firing is a Git.aDNA session
at an operator DP5 gate.

## §1 — Scope and the host ruling

Six greenfield first-remotes. **`Lighthouse.aDNA` is NOT in scope** — it already has its Codeberg origin
(pushed forward to `dc996e4` at S117).

| Target | Persona | Current remotes | Commits |
|---|---|---|---|
| `Forgejo.aDNA` | Ilmarinen | `luke-mesh` only | 7 |
| `Caddy.aDNA` | Portunus | `luke-mesh` only | 11 |
| `Nebula.aDNA` | Heimdall | `luke-mesh` only | 8 |
| `Container.aDNA` | Pandora | `luke-mesh` only | 9 |
| `Groupware.aDNA` | Pheme | **none** | 8 |
| `Nextcloud.aDNA` | Atlas | **none** | 10 |

### ⛩ Operator ruling — host class, 2026-07-27

> **Decision:** the Keystone cohort takes **Codeberg-private, class P-dev**, matching `Lighthouse.aDNA`.
> **Ratified-by:** stanley (operator, direct — AskUserQuestion at aDNALabs S117) · **Date:** 2026-07-27 ·
> **Status:** accepted

**This requires no reclassification act.** It follows ADR-013 **D1 row 2** (*FOSS in private development →
Codeberg-private, opens to GitHub at release*) and **D6** as written. `Forgejo.aDNA/STATE.md:49` already
self-declares the class: *"a future first remote is a Git.aDNA P6-gated decision — Forgejo.aDNA is a
**FOSS-in-dev → Codeberg-private candidate**."* GitHub was considered and **rejected** — it would have been a
D7-barred silent flip of six graphs to class I.

**`origin` is the empty slot.** None of the six has an `origin`; `luke-mesh` is a *non-canonical* remote in
ADR-006 terms. **Adding `origin` leaves `luke-mesh` untouched** — which is the whole point (§2).

## §2 — T-8: why this wave does not touch it

- **`luke-mesh` remotes are NOT removed.** Venus's standing disposition (`coord_2026_07_02_venus_to_berthier_luke_mesh_disposition.md:23`)
  is *"**DOCUMENT — do not deprovision** … the fabric stays."* Deprovisioning is her lane and is barred here.
- **No repo is added to `~/.mesh-git`.** T-8's live bar is on *adding* to the fabric. This wave adds a
  **Codeberg** origin. The fabric is untouched — inventory stays at 16.
- Berthier's standing commitment to Venus (*"we push nothing new to the fabric until you rule"*) is
  **unmodified** by this wave.

*(Context: at aDLabs S117 the four `luke-mesh` members were refreshed forward. That was a refresh of
**pre-existing** members, not an addition; Venus was notified at
`Network.aDNA/who/coordination/coord_2026_07_27_berthier_to_venus_fabric_refresh_and_t8_correction.md`.)*

## §3 — Pre-clear scans: BANKED, but re-run at the gate

Full-history `gitleaks` (8.30.1) run **2026-07-26/27** from HQ. Point-in-time — **re-scan each at the moment of
its move** (wave-1 prerequisite #4; F-W3-d read-at-use).

| Target | Result | Action |
|---|---|---|
| `Forgejo` | **clean** | none |
| `Nebula` | **clean** | none |
| `Container` | **clean** | none |
| `Groupware` | **clean** | none |
| `Nextcloud` | **clean** | none |
| **`Caddy`** | **9 findings → all FALSE-POSITIVE** | **allowlist already installed** — see below |

**`Caddy` detail.** All 9 hits are the tracked `.obsidian/plugins/terminal/main.js` bundle, minified JS where
`s.FourKeyMap=void 0` / `s.SequencerByKey=void 0` match `generic-api-key`. No credential material. Fleet-wide
class **F-W3-b** (identical entry already live in aDNALabs/III/ScienceStanley/LAVentureGraph). A path-scoped
allowlist was installed at `Caddy.aDNA/how/federation/git/.gitleaks.toml` (aDLabs S117, commit `c9aa214`) →
**re-scan ZERO**, negative control fires **2/2**.

> ⚠ **Owner-facing note carried in that file, for Portunus:** `.obsidian/` is **tracked** in `Caddy.aDNA` where
> most of the fleet ignores it. Allowlisting the scan is the narrow fix; **untracking the editor state is the
> broader one, and that call is his.**

**Discipline reminder (F-W5-a):** for any target, a clean scan without a **passing negative control** proves
nothing. Every result above was control-verified.

## §4 — Per-target sequence (the proven Wave-1a/5a shape)

For each of the six, in order — `Groupware` first as the canary (no `luke-mesh` remote, smallest blast radius):

1. **Liveness dual-check (F-W3-d).** Target vault **clean + sessionless**, verified *before apply* **and again
   before commit*. Any mid-session dirtying → **abort that target**, apply nothing, move on.
2. **Fresh full-history scan** with the target's config → must be clean, with a control.
3. **Apply the `git/` wrapper** at `how/federation/git/` (**ADR-045 placement** — root `git/` is a back-compat
   symlink; note Wave-1a predates ADR-045 and used the root path): `CLAUDE.md` with the `git_provider` block
   (`host: codeberg.org` · `visibility: private` · `class: P` · `org: aDNA-Network`), the `## Git-Ops` doctrine
   block into the vault `CLAUDE.md`, `.gitleaks.toml`, and the pre-push hook symlink.
4. `gitops_create_repo codeberg.org aDNA-Network <Name>.aDNA private` (idempotent).
5. `gitops_set_remote codeberg.org aDNA-Network <Name>.aDNA origin` — **do not touch `luke-mesh`**.
6. **Commit stage-only-mine** (explicit adds, never `-A`), then `gitops_push master`.
7. **Verify:** repo is private · anon clone **REFUSED** · authed HEAD matches · `git/` wrapper + `## Git-Ops`
   present.
8. **Register the new `origin`** with Hestia (ADR-006 D4 — Git emits, Home holds).

**Prerequisites at the gate:** `CODEBERG_TOKEN` exported (Hestia broker — **present in Keychain, verified
2026-07-27**) · `export GITOPS_ALLOW_LIVE=1` · `source how/skills/lib/gitops_dispatch.sh` · the six persona
coord memos delivered (§5) · fresh re-scan per target · **no active session in any target vault**.

⚠ **Known skill defect, do not rely on it blindly.** `skill_git_remote_setup.md` step 3 specifies only the
**pre-push hook** (outgoing-diff), *not* the ADR-011 **D4 full-history** scan. The skill as written is weaker
than the practice every wave has actually followed. **Follow this runbook, not the skill**, and consider fixing
the skill.

## §5 — Persona notices: STAGED HERE, delivered at the gate

Six short memos — Ilmarinen · Portunus · Heimdall · Pandora · Pheme · Atlas — **authored in this vault and
applied into target vaults only at the gate** (Rule 10; the Wave-1a pattern).

**Deliberately not pre-delivered.** Nothing is happening to those vaults yet; a notice about a first remote that
may not fire for weeks is noise, and six premature cross-vault writes for a *staged* wave is exactly the
improvisation Git-Ops rule 6 exists to prevent. **They ship with the wave.**

Each carries, in the *notice-not-concurrence* shape (the operator has ruled): the host ruling + its ADR-013 D1
row-2 basis · the pre-clear scan result for **their** vault · what was applied (wrapper, doctrine block, hook)
and what was **not** (no content curated, `luke-mesh` untouched) · the one-action revert. **Portunus's
additionally carries the `.obsidian/`-is-tracked note and the allowlist already installed at S117.**

## §6 — What this wave does NOT do

- **Does not lift the build gate.** These are *repos*, not *deployables*. All six remain planning graphs with
  **zero** compose files, units, Caddyfiles or install scripts — measured 2026-07-27, see
  `aDNALabs.aDNA/…/artifacts/integrated_node_readiness_20260727.md`. **A reachable repo is not a buildable node.**
- Does not touch `luke-mesh`, add to or remove from the fabric, or rule T-8.
- Does not open GitHub or flip any visibility.
- Does not grant anyone access. Deputy access to these is a **separate** per-repo operator-gated act, and
  **Codeberg is a different account estate from GitHub** — Jake's `aDNA-Network` GitHub membership does **not**
  carry over. **He would need a Codeberg account.** Raise this before promising him reachability.
- Does not charter **P7** — see §7.

## §7 — ⚠ The thing this wave cannot fix, and Hopper should see it

**Your own P7 cards already exist and are `planned`, `updated: 2026-06-20`:**

- `missions/p7a_integration_architecture.md` — *"P7a — Integration Architecture (**joint Network.aDNA**)"*
- `missions/p7_mesh_git_spike.md` — *"P7b — Integrated Lighthouse Forge + Context-Sync Spike"*

The operator's request this sitting was, in substance: *"let the deputy stand up an integrated
forgejo/groupware/lighthouse/fluxer node."* **That is P7b.** The phase is designed, carded, and has never been
opened — and every downstream gate traces to it: `Lighthouse.aDNA`'s build gate (*"P7 is not yet chartered … the
gate has no ETA"*), the Keystone cohort's P1, and Sostratus's refusal to cut the `exchange-registry` row even
though Exchange has a **built and smoke-verified** compose stack.

**Venus concurred on 2026-07-26** that shipping a stub as a profile *"would be an overclaim"* and added: *"I
will not be the one to lift it silently."* **P7a is joint with her**, so chartering opens on her desk too.

**Wave 6 makes the graphs reachable. It does not make them buildable. Only P7 does.** Chartering it is an
operator act in this vault — flagged, not assumed.

## §8 — ✅ FIRE RECORD (2026-08-07, operator plan approval = the DP5 gate; same session chartered P7a/P7b)

**6/6 fired, Groupware canary first.** Per target: liveness dual-check → fresh full-history `gitleaks` **clean** (negative control verified under both the baseline and the Caddy-allowlist configs — control fires 2/2) → wrapper applied at `how/federation/git/` (provider declaration + hooks + `.gitleaks.toml` + root symlink + `.git/hooks/pre-push`) → `## Git-Ops` doctrine block into the vault `CLAUDE.md` → persona notice into `who/coordination/` → `gitops_create_repo` + `gitops_set_remote origin` → commit stage-only-mine → `gitops_push master` (pre-push hook fired live, clean 6/6) → verify.

| Target | origin (Codeberg-private) | HEAD pushed | Verify |
|---|---|---|---|
| `Groupware.aDNA` (canary) | `aDNA-Network/Groupware.aDNA` | `d6bf3a8` | private ✓ anon-refused ✓ HEAD ✓ |
| `Nextcloud.aDNA` | `aDNA-Network/Nextcloud.aDNA` | `2b8c0f3` | private ✓ anon-refused ✓ HEAD ✓ |
| `Caddy.aDNA` | `aDNA-Network/Caddy.aDNA` | `7708cd1` | private ✓ anon-refused ✓ HEAD ✓ (S117 allowlist used; scan zero) |
| `Nebula.aDNA` | `aDNA-Network/Nebula.aDNA` | `bd66aa1` | private ✓ anon-refused ✓ HEAD ✓ |
| `Container.aDNA` | `aDNA-Network/Container.aDNA` | `0cc3344` | private ✓ anon-refused ✓ HEAD ✓ (one pre-existing stray untracked artifact left untouched, stage-only-mine: `how/campaigns/campaign_container_genesis/artifacts/preflight_l2_podman_remediation.md`) |
| `Forgejo.aDNA` | `aDNA-Network/Forgejo.aDNA` | `f5f860a` | private ✓ anon-refused ✓ HEAD ✓ |

- **`luke-mesh` untouched in all four carriers** (T-8 honored; fabric inventory unchanged).
- **Finding F-W6-a**: the naive anon-clone probe (`git ls-remote` bare) **false-negatives on a workstation whose credential helper holds a Codeberg token** — the probe silently authenticates. The verify step must run `-c credential.helper=` + `GIT_TERMINAL_PROMPT=0` (fixed in the fire script mid-canary; all six verified with the corrected probe). Fold into the wave-verify discipline.
- Commit counts had drifted from the §1 staging snapshot (activity 07-27→08-07: Caddy 11→12, Container 9→22, Forgejo 7→9) — fresh scans covered the drift; all clean.
- Hestia registration staged: [[../../../../who/coordination/coord_2026_08_07_git_wave6_hestia_records|coord_2026_08_07_git_wave6_hestia_records]] (delivered to Home.aDNA same session).
- §7's ask is answered: **P7a/P7b chartered the same sitting** (operator GO; see the mission cards + the reply to Berthier).
