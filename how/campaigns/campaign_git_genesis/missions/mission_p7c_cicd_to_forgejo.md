---
plan_id: mission_p7c_cicd_to_forgejo
type: plan
title: "P7c — CI/CD of record moves to our Forgejo (the card)"
owner: stanley
status: proposed        # a CARD. Acceptance, chartering and every gate below are the operator's (SO#1, §7.7). Nothing deployed.
campaign_id: campaign_git_genesis
campaign_phase: 7
campaign_mission_number: "7c"
mission_class: reconnaissance
executor_tier: opus
token_budget_estimated: ~120k per leg sitting (L0 rides Forgejo.aDNA's lane, not this one)
created: 2026-10-26
updated: 2026-10-26
last_edited_by: agent_stanley
source_words: "MD-3, Automator row 11079, verbatim: \"I think we want to transition to ci-cd through our forgejo system\""
source_ruling: "MD-3 label (b) \"Leave CI dark this week\" (Automator row 11079) - no billing fix; this card is the follow-through his words name"
dispatched_by: "Automator.aDNA D1-12 (orders_day1_20261026; SPAWN row 11221)"
depends_on: [adr_008, adr_013, adr_014, adr_011, adr_006, adr_007, adr_015]
session: session_stanley_20261026_083844_git_cicd_forgejo_card
tags: [plan, campaign, git, p7c, cicd, forgejo_actions, card, proposed, md_3, t2_build_home, graduation, mirror_rule]
---

# Mission card: P7c — CI/CD of record moves to our Forgejo

**Campaign**: [[how/campaigns/campaign_git_genesis/campaign_git_genesis|campaign_git_genesis]] — Operation Free Harbor
**Phase**: 7 — Integrated Lighthouse Forge (after [[p7a_integration_architecture|P7a]] ✅ and alongside [[p7_mesh_git_spike|P7b]])
**Status**: `proposed`. ⛔ **Nothing in this card has been done.** No runner touched, no workflow file edited anywhere, no remote changed, no memo sent, nothing pushed.

> **Claim tags**: **VERIFIED** (path / command output at this sitting, 2026-10-26 08:4x PDT) · **REPORTED** (another graph's record, dated) · **INFERRED** · **UNKNOWN** (with how to resolve). **Surety lines** read `surety: p · class` where class **S** = this desk may act · **R** = this desk recommends, acts only at ≥ 0.90 with a reversal line · **H** = his, never acted here.

## Goal

Make **Forgejo Actions the CI/CD of record** for the fleet's private code-homes, starting with one low-risk graph, so that CI stops depending on a GitHub billing line — while keeping the provider-neutral thesis (ADR-000 D5: user host-choice forever), the ADR-013 host table, and the gitleaks gates exactly as they stand.

## Exit gate (for the card itself)

He rules **CI-1** (accept / revise / hold). Each leg below then carries its own gate, and each gate is his.

---

## 1 · The situation, from disk

### 1.1 · The trigger — the GitHub billing line (names only)

- **REPORTED** (Automator SEAL row 11056, question MD-3; 2026-10-26): both main CI jobs on the `Jupyter` lab repo's merge #75 were refused by GitHub with *"recent account payments have failed or your spending limit needs to be increased"*. The station read it as: likely every private `aDNA-Network` repo's Actions are dark.
- **REPORTED** (Automator row 11079): he ruled **(b) leave CI dark this week** — no billing fix — and gave the words this card answers.
- **UNKNOWN**: whether public repos are refused too. **INFERRED**: no. GitHub's standard runners are free for public repos, so the refusal should hit private repos only. *Resolve*: one names-only `gh run list` per public repo at his GO, or read the next public push's run.
- Nothing about the amount, the card or the payment method is on disk here, and this card records none.

### 1.2 · Who runs GitHub Actions today (listing only, no run, no file opened)

*Population predicate (A8 §5)*: every directory matching `*/.github/workflows`, `*/.forgejo/workflows` or `*/.gitea/workflows`, at `maxdepth 5` below `~/aDNA`, with `.claude`, `_archive`, `Archive.aDNA` and `node_modules` pruned. Remote hosts are read from each enclosing repo's `.git/config`, host only. **VERIFIED**, 2026-10-26 08:4x. Census scripts: the session's scratch (not kept in the vault).

| class | repos (workflow files) |
|---|---|
| **GitHub origin + `.github/workflows`** (19 repos) | `.adna` (3, public MIT image, Rosetta's) · `aDNA` (4) · `aDNALabs` (2) · `Context/what/contextscope` (1) · `HarnessOld/what/harness` (1) · `Jupyter/what/lab` (3) · `LatticeProtocol/what/latticeprotocol` (2) · `LinkML` (1) · `llama.cpp` (34, upstream, never moved) · `Molecules/what/moleculeforge` (5) · `Network` (4, two of them Windows builds) · `Operations/what/operations-bridge` (1) · `Operations/what/operations-web` (2) · `RareArchive/what/rare-archive` (2, partner canonical) · `ScienceStanley` (2) · `TappProtocol` (1) · `Terminal` (2) · `wga` (1) · `WGS` (2) |
| GitHub origin, outside the router | `latlab-m-l13_5` (2), `latlab-ws1-ledger` (2). **INFERRED**: clones of `Jupyter/what/lab`, since they carry the same remote set. |
| **Codeberg origin** (hosted Forgejo) | `Emacs` (`.github` 2 + `.forgejo` 4, incl. two `-macos` jobs) · `Spacemacs` (`.github` 3) · `Exchange` (`.forgejo` 1) + `Exchange/what/exchange` (`.forgejo` 1) |
| Other | `AILedger/what/latticeprotocol` (2; remote = the graph forge `.5`, Jake's) · `operations_stanley` (1; `mesh-rd` only) · `Harness/what/harness` (1; no remote) · `share_omics/.../pipeline` (`.forgejo`, `ci.yml.disabled`; no remote) |

### 1.3 · Who already has a Forgejo remote

**VERIFIED** (the same read, top-level `*.aDNA` only):

- **`mesh-rd` → the R&D forge (`rd-forge`, `adna_rd_l1`, `.28`)**: **71 graphs** carry it (ADR-014's replica role), and **`LAVentureGraph`** has *graduated*: origin = `rd-forge`, GitHub kept as `rollback`. ⇒ **Almost the whole fleet's bytes are already on our forge.** What moves in this card is the *build*, and with it (per ADR-014 A6) the canonical.
- **Codeberg origin**: 18 graphs (the Free Harbor P-dev set).
- **The graph forge (`.5`, Jake's)**: `operations_jake` (origin), `AILedger` (`forge`), `Socials` (`mesh`), `Exchange` (`graph-forge`); `Atlantis` (`forge` → `git.ailedger.dev`). **UNKNOWN** whether that hostname is `.5`; Atlantis's own record would say.
- **REPORTED** (ADR-014 A6 §3.3, a non-normative snapshot from **2026-08-29**, 58 days old): three replicas were **already building on the R&D forge** (`REPLICA_BUILD_HOME`: `aDNALabs` 8 runs · `Network` 21 · `WGS` 2), un-graduated and un-excepted. **UNKNOWN today**. *Resolve*: `Forgejo.aDNA/what/deploy/check_replica_actions_posture.sh`, run in Forgejo's lane once the box answers. → [[../../../../what/findings/finding_f_p7c_b|F-P7c-b]]

### 1.4 · Where the runners stand

| runner | where | registered to | labels | state |
|---|---|---|---|---|
| `rd-node` (id 1) | in a container on `adna_rd_l1` (`.28`) | the R&D forge itself | `rd-node` · `adna-linux-gpu-host` · `ubuntu-latest` | **REPORTED** (Forgejo.aDNA STATE, 2026-09-17): the box has been **DARK since 2026-09-10T21:36Z** and is pinned at 15.0.7, **behind 15.0.8 with severity critical** (an upstream RCE). Today: **UNKNOWN**. *Resolve*: Forgejo's `check_forge_liveness.sh`, in that lane. |
| `adna-l1-Dyrnwyn` (id 752660) | Docker on this Mac (`adna-forgejo-runner`, `runner:12.12.0`) | **codeberg.org** | `adna-linux` (act image) | **REPORTED** (Forgejo.aDNA memo 2026-08-19; Home offload disposition 2026-08-31) |
| macOS native | LaunchAgent `com.adna.forgejo-runner-macos`, config under `~/.adna/forgejo-runner-macos/` | **UNKNOWN** (this desk did not open the config dir, which also holds the runner's token file) | **INFERRED**: a macOS class label, which Emacs's `-macos` jobs need | **REPORTED** (Home, F-PORT-24, re-read 2026-10-25): live, on **two wildcard binds** (49397, 49398). Home rows it `owner_vault: Git.aDNA`. → [[../../../../what/findings/finding_f_p7c_a|F-P7c-a]] |
| Jake's runner on `.5` | the graph forge | `.5` | — | **REPORTED** (Forgejo ADR-002 §2.5): exists. Its isolation posture is **his and Jake's to declare** and is not inherited from ours. Agents never log in to `.5` (ADR-018 §A). |

Standing constraints on the `rd-node` runner (**REPORTED**, Forgejo campaign DP#4 / M09, 2026-08-18): it is **one shared** ephemeral runner at **capacity 2**; additional lanes get a **label on it, not a runner of their own**. It mounts the **host Docker socket under F-C10** (an accepted *interim* risk). Its config is code (`what/deploy/runner-config.yml`). Re-registering it is **credential-bearing**: the registration token `FORGEJO_RUNNER_REG_TOKEN` (C70) is held in external custody on that box.

### 1.5 · What already binds this card

- **ADR-008** (accepted): one canonical workflow in GitHub-Actions syntax. Forgejo **falls back to `.github/workflows/`**, so most repos need **no file move**. The D2 delta checklist (`uses:` pins · `runs-on:` labels · secrets · `github.*` context · GitHub-only features) is binding on `port-ci`. A1: `runs-on` names a host *class*, never a hostname. Templates: `what/templates/ci/{github,forgejo}/ci.yml`.
- **ADR-014 A6** (accepted rev 3): **T2, the build-home need, is a graduation trigger.** A graph whose CI must run on the forge either (i) **graduates** by the ADR-006 D3 host-move (forge = `origin`, old host kept as `rollback`, later a standing `mirror`), or (ii) takes a **named exception** that the graph authors and **he ratifies** (§3.2). A2 §1 adds that **a graduated repo is never single-homed on the forge**; it owes an off-forge replica.
- **ADR-013** (accepted): public/released FOSS stays **GitHub-public**. Private work goes **GitHub-private (interim) → self-hosted Forgejo**, and never to Codeberg. ⇒ **For the private class this card is the "→ self-hosted Forgejo" step ADR-013 already names.** For the public class it is not.
- **ADR-011** (accepted, A1–A9): the chained pre-push gate and gitleaks. Nothing here weakens either.
- **ADR-007**: credentials are names-only, brokered by Home.

---

## 2 · The target

| axis | target | surety |
|---|---|---|
| CI/CD of record | **Forgejo Actions** for the **private class-I** code-homes, on our forge. Public classes keep CI where their origin is (§3.3). | 0.85 · R |
| "Our Forgejo system" | **The R&D forge `rd-forge` on `adna_rd_l1` (`.28`)**: the only Forgejo we operate, already the replica home of 71 graphs, already running CI. **Not** `.5` (Jake's; agents never log in). **Not** Codeberg for private work (FOSS-only ToS). The production home is the **Lighthouse go/no-go** (L5), not this card. | 0.80 · H (CI-2) |
| GitHub | **A mirror, not a home**, for each graduated private repo: the old origin becomes `rollback` for 30 days, then a standing `mirror` (A2 §1's off-forge replica). Public repos: GitHub stays the home (ADR-013). | 0.85 · H (CI-4) |
| Runner | **`rd-node`, co-located with the forge** (no cross-node hop), new lanes as **labels**. The L1 runners are **not** of record: this node is on battery, its Docker daemon is intermittent, and its macOS runner is wide-bound. Keep the macOS runner only for a macOS-class label. | 0.80 · H (CI-5) |
| Secrets | Forgejo repo/org secrets **re-provisioned through the broker** (Home.aDNA, Bitwarden-primary, by name → env var; never carried from GitHub, never inlined). **The first graph is chosen to need none.** | 0.90 · R (no secret moves in L0–L1) |
| Mirror credential | The GitHub write credential for a mirror should **not** be stored on the forge: a push-mirror stores it at rest inside the F-F15 radius on someone else's box, the same shape as P9 / F-P7b-k. Prefer an **L1-side mirror push** (fetch from the forge, push to GitHub) on the existing Operations push path, with the credential kept at the broker. | 0.80 · H (CI-4) |
| Gitleaks gates | **Kept, all of them.** The client-side chained pre-push hook (gitleaks + sanitize + R8) is host-neutral and runs on every push to whatever `origin` is. **Add** the server-side scan step from `what/templates/ci/forgejo/ci.yml` to every ported workflow. No allowlist widened, no gate skipped to make a migration fit. | 0.95 · S |

---

## 3 · The migration — legs, each with his gate

**Rule for every leg**: probe first (the box answers, the repo has no live sitting, the tree is clean); act; prove it **by log lines, not by a badge** (Forgejo's M09 precedent); record. GitHub workflows are **disabled, never deleted** (SO#6), so every leg can roll back.

### L0 · Preconditions (no CI moves) — gate **G-CI0**, his

1. `.28` answers again. Forgejo.aDNA's **restore → assess → upgrade** rule, then the upgrade to **≥ 15.0.8**, run in **Forgejo's lane**, not here. A forge carrying a critical RCE must not take new build load from pushes.
2. `rd-node` re-verified after the restart: labels, capacity 2, job-container reaping, the F-C10 interim risk **re-affirmed by him** for the added load.
3. **The off-box backup leg is real.** It was an *unheld hand* as of 2026-08-11 (Forgejo memo). A graduated canonical with no off-forge copy breaks A2 §1.
4. A fresh **A6 posture reading** (`check_replica_actions_posture.sh`), so the three standing build homes are classed by today's predicate, not by the 08-29 snapshot.
- **Rollback**: none needed, since L0 changes no graph.

### L1 · The first graph: **`TappProtocol.aDNA`** — gates **G-CI1** (build on the forge) and **G-CI2** (graduate), both his

**Why this one** (surety 0.80 · R, ruled at CI-6):
- **Private, class I** (disposition ledger: Wave 3b, 2026-06-24). That puts it squarely in ADR-013's "→ self-hosted Forgejo" class and among the repos the billing refusal hits.
- **One workflow** (`ci.yml`). The smallest possible port.
- **Quiet**: last commit 2026-08-28 and no live sitting (VERIFIED: `how/sessions/active/` empty). Nobody's merge flow is interrupted.
- **Already a `mesh-rd` replica** of the forge. Nothing new lands.
- **Not** partner-owned, **not** upstream, **not** public, **not** multi-writer (T1 does not fire).
- **Not the alternatives**: `WGS` already builds there but is two-operator and carries a visual-regression job; `aDNALabs` is HQ (load-bearing); `Network` has Windows builds (non-portable); `Terminal`, `Jupyter` and `Operations` are live and load-bearing. Git.aDNA has no workflow to move, so dogfooding here means adding CI, not migrating it (a later, separate act).
- **UNKNOWN**: whether its `ci.yml` is ADR-008-portable. This desk listed the file name only. *Resolve*: read the file at L1's first step, in a TappProtocol-admitted sitting.

Steps:
1. **Read-and-classify** `ci.yml` against ADR-008 D2. Fallback-only (no `.forgejo/` file) is the expected outcome. Any GitHub-only construct is declined and documented, never faked (ADR-014 A3 §3).
2. **G-CI1** → enable Actions on its forge repo (it is `LATENT` or `REPLICA_ACTIONS_ON` today, so this is the A6 "declare T2 intent" path). Push, then run green **three times**, asserted on log lines. GitHub stays as it is (dark).
3. **G-CI2** → graduate per ADR-006 D3 + ADR-014 D4/A2: forge URL = `origin`; the `mesh-rd` remote removed as redundant; GitHub kept as `rollback` (30 days); enrollment conf `state: graduated` (Operations' row, by memo); disable GitHub Actions on the repo, workflow file kept; Home registers the §C shim. Then **CI-4's mirror rule** turns `rollback` into the standing `mirror`.
- **Rollback**: re-enable GitHub Actions (the file was never removed); repoint `origin` back to the `rollback` remote within its window (the LAVG / Wave-1b precedent); on the forge, `has_actions=false`, **read back from the forge's own rows**.

### L2 · The private class-I GitHub repos with portable CI — one gate per graph or per small batch, his

Lowest-risk first, each repeating L1's three steps. **INFERRED** order: `LinkML` · `Context/contextscope` · `HarnessOld/harness` · `LatticeProtocol/latticeprotocol` · `Molecules/moleculeforge` (nested repos are their own host-moves, Wave-4 shape) · `ScienceStanley` · `Operations/operations-web` · `Operations/operations-bridge` · `Jupyter/lab` · `Terminal`. Each owning graph authors its own move. **UNKNOWN**: each repo's visibility today. *Resolve*: the ledger row plus a names-only API read per graph at its gate.

### L3 · Regularize the three standing build homes — owners author, he ratifies (A6 §3)

`aDNALabs`, `Network`, `WGS` (if today's reading agrees). Each either graduates or takes a **ratified named exception**. Network's Windows jobs cannot run on a Linux runner: they stay on GitHub as a documented provider-specific remainder (ADR-008 D3), or are dropped by Venus's choice. **Never patched off from this desk** (A6: stopping a live build is SO#1 broken by an instrument).

### L4 · Public and outside-the-fleet repos — mostly *no move*

- `aDNA`, `III`, `Canvas`, `Git` and the public `.adna` image keep their **GitHub-public home** (ADR-013). Their CI either stays on GitHub (where public Actions are INFERRED unaffected by the billing line) or builds on the replica under a ratified named exception. That is his call per graph, never a default.
- `llama.cpp` (upstream) and `rare-archive` (partner canonical) are **never moved**.
- `Emacs`, `Spacemacs` and `Exchange` are already on Forgejo (Codeberg) and outside this card, except that Emacs's macOS jobs depend on the L1 macOS runner (F-P7c-a).

### L5 · The production forge — strategic, not this card

Moving CI of record **off a box in Jake's custody, with a socket-mounted runner**, onto a Lighthouse-composed data-plane forge (ADR-012 / ADR-015, network §8 placement) is the **Lighthouse go/no-go**. L2 `exxact3` (always-on, rootless podman) is a candidate host to put to Venus and Jupyter. ⛔ Not chartered here, and no composer claim (Dynamo R3).

---

## 4 · Risks, and what is his

| # | risk | weight | mitigation in this card |
|---|---|---|---|
| K1 | **The forge is dark** (last reading on disk), so CI of record on it would be dark CI again, one host over | high | L0.1 before anything; A2 §1's off-forge replica; GitHub kept as `rollback` |
| K2 | **Critical upstream RCE** (15.0.7 < 15.0.8) on a forge whose runner executes pushed code | high | L0.1: upgrade before new load |
| K3 | **F-C10**: the runner mounts the host Docker socket on a co-tenanted box in someone else's custody | high | his re-affirmation at L0.2; L5 is the cure, not this card |
| K4 | **Secrets at rest on the forge** inside the F-F15 radius (any NOPASSWD-sudo account on the box) | med | L1 graph needs no secrets; the mirror credential stays at the broker |
| K5 | **Non-portable workflows** (Windows, macOS, GitHub-only features, marketplace actions, `uses:` resolution needing egress from the box) | med | ADR-008 D2 classification per repo; decline and document |
| K6 | **Double-CI drift** while both hosts are live | low | GitHub disabled at graduation; one source file (ADR-008 D1) |
| K7 | **The L1 macOS runner's wildcard binds** (F-PORT-24) on a travelling laptop | med | F-P7c-a; CI-10 |
| K8 | **A public repo silently graduated** off its ADR-013 home | med | L4: never a default |
| K9 | **Single shared runner at capacity 2** queues under fleet load | low→med | labels, not runners (DP#4); revisit at L5 |

**His, without exception**: accepting this card · every gate (G-CI0, G-CI1, G-CI2, each L2/L3 graph) · the restore of `.28` and its upgrade window (hands on a box in his lab; Jake's consent under ADR-018) · any runner registration or re-registration (credential-bearing, C70 custody) · every secret provisioned to a forge (a broker ceremony) · the mirror credential · **any spend** (the GitHub billing fix, hardware, a paid runner) · the L1 runner's binds · every host move and §C shim · every named exception (§7.7).

---

## 5 · The docket — rulings, one-minute form

| id | situation | options | recommendation · surety | if vetoed |
|---|---|---|---|---|
| **CI-1** | This card is `proposed`. | (a) accept and charter as P7c · (b) revise by name · (c) hold | **(a)** · 0.85 · H | CI stays dark on GitHub's billing line; nothing else moves |
| **CI-2** | "Our Forgejo system" has three readings. | (a) the R&D forge `.28` now, the Lighthouse forge at L5 · (b) wait for a new forge (L2 or Lighthouse) · (c) Codeberg (FOSS only, so not the private class) | **(a)** · 0.80 · H | (b) means no CI of record until a forge is built |
| **CI-3** | `.28` was dark and critically behind at the last reading. | (a) restore → assess → upgrade to ≥ 15.0.8 in Forgejo's lane, then G-CI0 · (b) skip the upgrade · (c) leave it dark | **(a)** · 0.90 · H | under (b), new build load runs on an RCE-exposed forge; under (c), the card stops at L0 |
| **CI-4** | The mirror rule. | (a) private class I graduates, GitHub becomes `rollback` then `mirror`, pushed from L1 with the credential at the broker · (b) the same, but a forge-side push-mirror storing a GitHub credential on the box · (c) no GitHub copy | **(a)** · 0.80 · H | (b) adds K4 on Jake's box; (c) breaks ADR-014 A2 §1 (single-homed) |
| **CI-5** | The runner of record. | (a) `rd-node` on `.28`, labels-not-runners, F-C10 re-affirmed · (b) the L1 runners · (c) a new runner on L2 | **(a)** · 0.80 · H | (b) means CI on a battery node; (c) is new infrastructure (L5) |
| **CI-6** | The first graph. | (a) `TappProtocol` · (b) `WGS` (already builds there) · (c) by name | **(a)** · 0.80 · R | (b) needs both operators and a heavier job |
| **CI-7** | Secrets on the forge. | (a) none in L0–L1, then per graph through the broker ceremony · (b) bulk re-provision now | **(a)** · 0.90 · H | (b) is a fleet-wide custody act on a dark, behind box |
| **CI-8** | The GitHub billing line. | (a) MD-3 (b) stands: no spend; GitHub Actions disabled per graph only at its graduation, files kept · (b) fix the billing for the transition window | **(a)** · 0.75 · H | (b) is a spend, his alone |
| **CI-9** | Three replicas already build on the forge without graduation or exception (as of 08-29). | (a) L3: each owner authors graduation or an exception; he ratifies · (b) leave as is | **(a)** · 0.85 · H | A6 stays a rule with standing unratified exceptions |
| **CI-10** | The L1 macOS runner listens on two wildcard binds; Home rows it as Git.aDNA's, and this desk has no record of it. | (a) Git.aDNA records the runner (names only) at a GO'd sitting, then proposes a narrower bind · (b) leave it wide | **(a)** · 0.85 · H | F-PORT-24 stays open at Home |

---

## Campaign context

- **Builds on**: ADR-008's parity contract and templates (P3) · ADR-014 A6's T2 trigger · the R&D forge, live since 2026-08-08 (P7b obj 3) · LAVG's graduation precedent · Forgejo.aDNA's M09 runner surface.
- **Feeds**: L5 / the Lighthouse go/no-go; P8's standing missions → Operations.aDNA.
- **Seams** (all `counterparty_confirmed: false` until each answers): Forgejo.aDNA (Ilmarinen: L0, the runner, posture readings) · Operations.aDNA (enrollment conf `state: graduated`, the L1 mirror push) · Home.aDNA (the §C shims, secrets, F-PORT-24) · each owning graph (its own move) · Jake (custody of `.28`).

## Notes

- **Findings filed this sitting**: [[../../../../what/findings/finding_f_p7c_a|F-P7c-a]] (two L1 runners rowed to this vault, no record here) · [[../../../../what/findings/finding_f_p7c_b|F-P7c-b]] (the only build-home reading is 58 days old, on a box that has since gone dark).
- **Inbound at open**: 16 untracked memos in `who/coordination/inbox/`. **Unread this sitting** (scope fence). Not committed.
- The F-PORT-24 memo was read **at Home's staging** (status `staged`, not delivered). This desk sent nothing and acked nothing.

## Completion summary

*Not applicable: this is a card. Filled when L1 closes.*

## AAR

*Owed at L1's close, before any `status: completed`.*
