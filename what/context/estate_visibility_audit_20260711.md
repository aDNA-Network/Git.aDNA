---
type: context
context_class: forge_estate_audit
created: 2026-07-11
last_edited_by: agent_stanley
status: active
provenance: "read-only audit via gh CLI (account ScienceStanley, admin@aDNA-Network) + per-vault `git remote` sweep, 2026-07-11; requested by the operator as pre-launch review"
audience: [operator, grace_hopper]
tags: [context, git, forge, estate, visibility, audit, path_b, codeberg, github, launch_prep]
---

# aDNA repo-estate visibility audit — 2026-07-11

**Why:** operator-requested review, ahead of next week's network launch — confirm the right graphs are on the right forge with the right public/private posture. This is a **report with flagged decisions**; no visibility changes were made. Decisions belong to the operator + Git.aDNA (Grace Hopper) per the Path B doctrine.

**One change made same session (operator-authorized, separate ask):** `Fluxer.aDNA` was pushed to a **new private** `aDNA-Network/Fluxer.aDNA` (was local-only). Not public — a public Fluxer vault would have exposed 99 internal files (partner-ToS framing, mesh/overlay IPs, operator egress IP, SSH key name, host roster, spend). README rides in the private repo; shareable with fluxer.host by copy-paste.

## Headline

| Forge | Count | Notes |
|---|---|---|
| **GitHub `aDNA-Network` — private** | 50 | Interim-private per Path B; the conservative pre-launch default |
| **GitHub `aDNA-Network` — public** | 7 | The FOSS/standard set only (below) |
| **Codeberg-primary** (`origin` → codeberg.org) | 9 | Path B FOSS home; visibility not gh-checkable |
| **Local-only** (no remote) | ~30 | incl. genesis stubs, local-by-design vaults, `Home` (Rule 4) |
| **External partner** (`Wilhelm-Foundation`, private) | 2 | RareArchive, WilhelmAI |

## GitHub public today (7) — all appropriate as FOSS/standard

`aDNA` (the clone-and-run image — the public face) · `aDNA.aDNA` (self-referential docs, Operation Rosetta) · `Git.aDNA` · `III.aDNA` · `Canvas.aDNA` · `spacemacs` · `adna-legacy` (archived, the frozen predecessor template).

Everything else on GitHub is **private** — a coherent posture for a pre-launch network. There is **no glaring "should-be-public-but-isn't"** among the platform/org/strategy vaults; that set going public is a deliberate launch call (flag 3), not an obvious fix.

## Codeberg-primary (origin → codeberg.org)

`Exchange` · `Lighthouse` · `Molecules` · `Oration` · `Spacemacs` · `TypeScript` · `Videos` · `VisualDNA` · `WebForge`. These are the FOSS-destined graphs whose canonical home moved to Codeberg. **Their public/private state on Codeberg was not checked** (gh can't; verify on Codeberg directly, or via `Lighthouse.aDNA`/Forgejo tooling).

## Local-only (no remote) — ~30

Remoting is a per-vault operator-gated step (`skill_git_remote_setup`). Present set includes: **Fluxer** *(now remoted private — see above)*; **`Home`** (local-by-default, Standing Rule 4 — keep local); **Keystone cohort stubs** (Forgejo, Caddy, Nebula, Nextcloud, Bitwarden, Container, Inference, FastAPI, Store, Groupware); **web-stack stubs** (React*, Tailwind, ThreeJS, D3, Vercel); **dataroom family** (Datarooms, DataRoom, aiLP-Dataroom — local-only by design, D-DR-7); **domain stubs** (MagnaPetra, Datasets, WGS, CakeProtocol, RealityScan, LlamaCppForge, APScheduler, Prefect, ComfyUI); **Archive** + archived shims. *(React actually HAS a private GitHub repo — see the name-mismatch note.)*

## External-partner org (private) — leave as-is

`RareArchive` → `Wilhelm-Foundation/rare-archive-vault` (private) · `WilhelmAI` → `Wilhelm-Foundation/WilhelmAI` (private). Owned/governed externally; not ours to reconfigure.

## Flagged for decision (operator + Grace Hopper) — not defaults

1. **GitHub old-name stragglers vs Codeberg new-name canonical (the biggest cleanup).** Several graphs renamed *and* moved to Codeberg, leaving **private old-name GitHub repos** behind:
   - GitHub `SpeechForge.aDNA` (private) ↔ Codeberg `Oration`
   - GitHub `MoleculeForge.aDNA` + `moleculeforge` (private) ↔ Codeberg `Molecules`
   - GitHub `Videos.aDNA` (private) ↔ Codeberg `Videos`
   - GitHub `TypeScript.aDNA` (private) ↔ Codeberg `TypeScript`
   - GitHub `spacemacs` (**public**) ↔ Codeberg `Spacemacs`
   Decide per graph: **retire the GitHub straggler**, or keep it as an intentional private mirror. Pick one canonical source of truth.
2. **`spacemacs` is PUBLIC on GitHub AND Codeberg-primary** — confirm the public GitHub presence is intended (it's the lone public repo outside the standard image + framework set).
3. **Launch visibility call.** Which currently-private vaults flip **public** for/at launch? Today's 7 public = FOSS/standard; platform/org/strategy vaults being private is defensible. Decide the go-public set deliberately (candidate FOSS platforms: the Keystone software graphs? the deploy-face SDGs? — Grace Hopper's Path B call). **Before any flips: run the secret/infra grep sweep on each candidate** (the Fluxer sweep found IPs, SSH key names, partner-ToS framing — the same hazards live in other data-bearing/infra vaults).
4. **Superseded / merged vault repos still on GitHub (private).** `CanvasForge.aDNA` (→Canvas), `ComfyForge.aDNA` (archived), `ContextCompass.aDNA` (→Context), `LatticeLabs.aDNA` (→aDNALabs), `LiteratureForge.aDNA` (wound down), `videoforge`/`Git.aDNA-legacy`/`adna-legacy` (archived), code repos `lattice-protocol`/`adna-lab`/`latlab-lab`/`adna-harness`/`contextscope`. Confirm archive/rename disposition so the GitHub org reflects the live graph set at launch. *(Also seen: `TheKINN.aDNA`, `WGS.aDNA`, `WorldGenomeProtocol.aDNA` private — confirm these map to intended live/stub graphs.)*
5. **Name-mismatch: local dir vs GitHub repo name.** Some vault dirs push to a repo of a *different* name (e.g., `React.aDNA` dir → GitHub `React.aDNA` private exists; several `*Forge`→new-name). Harmless but worth a canonical-name reconciliation at launch so contributors aren't confused.
6. **Optional hardening (offered):** spot-check the 7 public repos for accidental secrets/infra leakage with the same sweep run on Fluxer. Low effort, high value before a launch spotlight.

## Related in-flight

An untracked `who/coordination/coord_2026_07_11_exchange_to_git_remote_host_doctrine.md` exists in this vault (Exchange → Git, remote-host doctrine) — directly relevant to flags 1–3; fold it into whatever remote-host ruling Grace Hopper makes. *(Left untouched by this audit.)*

## Method

`gh repo list aDNA-Network --json name,visibility,isArchived` (57 repos) + `gh repo view` for Wilhelm-Foundation + a `git remote get-url origin` sweep across all `~/aDNA/*.aDNA`. Read-only. Codeberg visibility and any self-hosted Forgejo mirrors are out of gh's reach and unverified here.
