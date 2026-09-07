---
type: decision
adr_id: adr_011
title: "ADR-011 — Secret-Scanning & History Hygiene"
status: accepted   # base ADR + A1 accepted; A2 accepted 2026-08-19 (R3-pivot gate); Amendments A3 (corrects A2 §5) + A4 (extends A3 — population + resolution order) + A5 (extends A2 §4 + A4 §3 — the induced positive must be able to fail) ACCEPTED 2026-08-23 (ratification-packet gate). ⭐ A3→A4→A5 is a strict citation chain and was ratified as a chain, in order — a suffix ratification would have left a binding clause citing a `proposed` one (F-F37's class). ⚠ The operative hook-adjudication rule now spans base + A2 + A3 + A4 + A5; a NON-NORMATIVE consolidated reading is owed (backlog pointer, `how/backlog/idea_adr011_operative_rule_consolidation.md`) — a reading, never an edit to ratified text. **Amendment A6 ACCEPTED 2026-08-24 (extends A5 §4 — a content check tests for the fix's mechanism, never the defect's name; §7.7 exercised at the plan gate).** Occasioned by Galileo, delivered MINUTES AFTER A5 was ratified: A5 §4 named the wrong mechanism, and the strict predicate it implies is non-discriminating (1·1·1) — so A5 §4 followed literally would certify a useless test. A5's ratified text is NOT edited. **Amendment A7 ACCEPTED 2026-08-24 (extends A3 §1 + A4 §2 — a digest is a name, not a verdict; §7.7 exercised at the plan gate).** Occasioned by F-P7b-p: a digest pinned in A6's Consequences as evidence had made a shipped artifact un-editable, and the binding table turned out to carry NO ROW for the hook this vault ships — live, not prospective (`WGS.aDNA` measured at `04e6a745…`). Adjudication moves to MECHANISM; the digest of record moves to the release ledger. A3/A4/A5/A6 ratified text is NOT edited, and the untouched-ness is md5-verified rather than asserted. ✅ **RATIFICATION-RECORD CORRECTION 2026-08-29** (ADR-017 D1/D3/D4, operator RCC ruling): the SECTION HEADINGS of **A3 · A4 · A5 · A6 · A7** read `proposed` (2026-08-19 / -20 / -21 / -23 / -24) from their stamps until this date, contradicting their own inline ratification blocks — so a reader scanning headings saw **5 of 7 amendments as unratified** in the ADR with the most consumers in the fleet. Each heading now takes the date from its own inline block (D4): A3/A4/A5 → `accepted 2026-08-23`, A6/A7 → `accepted 2026-08-24`. ⛔ **Status label and date ONLY** — **5 changed lines, all `## Amendment` headings**, every other byte in this file unchanged and diff-verified (ADR-017 D2/D3). Filed as **F-P7b-ap**; first seen as a single instance in ADR-014 A5's provenance, measured here as a class of six. **Amendment A8 ACCEPTED 2026-09-07** (A4 §6 made evaluable — population · total verdict set · installation is part of the control · a coverage claim states its population · a control must be runnable in the context it is required to run in; §7.7 exercised at the plan gate). ⚠ **Revise-then-ratify**: §5's F-P7b-av bullet read "the true population is 22" with no predicate — a bare integer for a population, in the clause forbidding that — and was revised to state it (23 tracked `*.md` at `a2b00a6`; 22 excluding R6's deliberate negative-control fixture) BEFORE ratification. One bullet changed; §§1–4, 6, 7 + provenance byte-unchanged, diff-verified. ⭐ Its first application was immediate and inbound: Hermes (`Exchange.aDNA`) filed the R5/R6 extension allowlist on 2026-09-06 — a disclosure gate keyed on `*.md` that FAILS OPEN, with a success line reporting the pushed count against a rule that read a subset — which is **§5 verbatim in this vault's own live control** (F-P7b-ay). ⛔ Authored because A4 §6 has been ratified since 2026-08-23 and SEVEN instances of the class it forbids landed after it — the same prose-with-no-mechanism defect ADR-014 A4 §1 and A6 §2 each fixed one axis over. §6 answers Ilmarinen's 2026-09-03 ack_required ask (an interactive prompt in an unattended-capable gate is a conformance defect).
created: 2026-06-20
updated: 2026-09-06
last_edited_by: agent_stanley
ratifies_at: "authored + ratified at the P2-exit gate (2026-06-20)"
depends_on: [adr_005, adr_006, adr_009]
tags: [decision, adr, adr_011, git, security, secret_scan, history_hygiene, migration, gitleaks, binding, accepted]
---

# ADR-011 — Secret-Scanning & History Hygiene

**Status**: `accepted` (genesis **P2**, 2026-06-20; ratified at the P2-exit gate). Added in the P2-exit revision pass to architect the campaign's **#1 High risk** — history secret-leakage during host migration — which prior ADRs referenced only as a label. Depends on [[adr_005_visibility_host_policy|ADR-005]] (D7 migration), [[adr_006_remote_naming|ADR-006]] (D3 host-move), [[adr_009_dev_process_doctrine|ADR-009]] (D3 dev-process). Covers seed REQ **MIG-006 / SEC-002**.

## Context
[[adr_005_visibility_host_policy|ADR-005]] D7 and [[adr_006_remote_naming|ADR-006]] D3 both gate a host move on a "secret scan / history-scan," and the campaign risk register flags **secret leakage in history during host migration (client repos)** as a **High** risk — but no ADR defined the *mechanism* (tool, verb, gate-owner, remediation). A label is not a control. This ADR binds it. (The fleet includes I-strict client/clinical repos — CakeHealth, PercySleep, SuperLeague, CakeProtocol, MagnaPetra — where a leaked secret in history is the most expensive failure mode.)

## Decisions

### D1 — Tool-of-record: `gitleaks` (default)
**`gitleaks`** is the default secret scanner (fast, broad default ruleset, runs pre-commit/pre-push **and** in CI, host-neutral). `trufflehog` is an **optional deep/verified-secret adjunct** for I-strict repos (live-credential verification), not the default. Same tool drives all three layers below.

### D2 — Pre-push hook (continuous hygiene)
Every code-home installs a `gitleaks` **pre-push hook** (scans the outgoing diff) — catches a secret *before* it reaches shared history. Shipped via the `git/` wrapper + the [[adr_009_dev_process_doctrine|ADR-009]] D6 doctrine block (P3 installs).

### D3 — CI scan (defense in depth)
A `gitleaks` **CI job** runs on pushes/PRs on **both backends** ([[adr_008_ci_cd_parity|ADR-008]] — `.github` + `.forgejo`, portable-first) — catches what a local hook misses.

### D4 — Hard pre-move full-history gate (binding)
Before **ANY** host move (origin change or mirror add — [[adr_006_remote_naming|ADR-006]] D3), a **full-history scan** (`gitleaks detect` over all refs/history) **MUST pass**. This is the mechanism behind [[adr_005_visibility_host_policy|ADR-005]] D7 "history-scan before any move."
- **I-strict** client/sensitive repos require **operator sign-off** on the scan result before the move proceeds.
- A move is **blocked** until the history scan is clean. No "push anyway."

### D5 — Remediation (binding)
A finding blocks the move. Remediate by purging the secret from history with **`git-filter-repo`** (preferred) or **BFG**, then **rotate the exposed credential via the Home.aDNA broker** ([[adr_007_credential_model|ADR-007]] D4), re-scan to confirm clean, and only then proceed. A purge rewrites history — coordinate via the shim registry ([[adr_006_remote_naming|ADR-006]] D4) and (if the repo already has consumers) a coord memo (Rule 10).

### D6 — Ownership & boundary
The **migrating agent** runs the scan; the **operator** gates I-strict moves; **Home.aDNA** holds credential rotation ([[adr_007_credential_model|ADR-007]]) and the shim registry. Git.aDNA owns the **scan doctrine + the pre-move gate verb**; it never stores secrets. Tooling specifics (hook install, CI-job YAML, allowlist/baseline policy) → **P3**.

## Amendment A1 — First-share host-move-class gate (accepted 2026-08-08)

*Adopts Berthier's 2026-07-20 proposal ([[../../who/coordination/coord_2026_07_20_berthier_to_gracehopper_first_share_host_move_gate|memo]]) verbatim-in-substance; operator blanket ruling approval 2026-08-08. Track record pre-adoption: run twice under HQ local binding; caught a real finding (an operator residential IP in Fluxer's history).*

**First share of any repo with a new external party is a host-move-class event.** Before the grant (or the first push of a shareable projection):
1. a full-history `gitleaks` scan over all refs **MUST pass** (D4 mechanics apply — allowlist/baseline subtraction only for individually-triaged, documented-FP classes);
2. **I-strict** repos additionally take **operator sign-off** on the scan output;
3. **collaborator management** (add / remove / change-role) joins the **outward-gated verb set** (Git-Ops #3 — never improvised). The provider-contract verb list grows a `manage-collaborator` entry at the next tooling pass.

"New external party" includes a new *host* whose readership differs from the current host's (a mesh forge with subnet members is a share to those members — the [[adr_014_mesh_remote_role|ADR-014]] D1 first-push case).

## Amendment A2 — D2 fail-closed range-scan (resolves F-S158-01) — **accepted 2026-08-19**

*Resolves **F-S158-01** (Berthier S158/S160/S161; Venus's 2026-07-11 upstream finding, delivered by proxy at `7b804d0` — both defects reproduced first-hand by HQ). The shipped D2 skeleton (`how/federation/git/hooks/pre-push.gitleaks.sh`, md5 `216aaca254b97d69819562d506afca29`, nine installed copies) is a proven no-op: it scans the **staged** diff (`gitleaks git --pre-commit`), which is empty at push time, so it exits clean having examined nothing; and it warns-and-passes when gitleaks is absent — so the launchd PATH fix converted a silent skip into a silent pass. Ratification: **decision** = A2 as written · **ratified-by** = operator (Stanley, R3-pivot gate) · **date** = 2026-08-19 · **status** = `accepted`.*

1. **D2's mechanism is corrected to match its text.** The pre-push hook scans the **actual outgoing range**: it reads the stdin refs (`<local-ref> <local-sha> <remote-ref> <remote-sha>`, githooks(5)), skips deletes, and scans `gitleaks git --log-opts="<remote-sha>..<local-sha>"` per ref; new refs scan `<local-sha> --not --remotes`, degrading to full history when no remote-tracking refs exist — expensive but fail-safe, never silently narrower. Requires gitleaks ≥ 8.19.
2. **Fail-closed.** A missing scanner **blocks the push** (exit 1, install hint, deliberate-bypass pointer) — removal of the tool may never silently remove the layer. The skeleton's "P6 hardens to block" promise is discharged here.
3. **Skeleton v2 = Venus's hardened reference implementation** (`Network.aDNA/how/code/hooks/pre-push-secret-scan.sh`) adopted wholesale with credit — already self-tested downstream (clean range passes · planted `ghp_` token blocks exit 1 · scanner-absent blocks exit 1). It preserves the config search order verbatim (`$GITLEAKS_CONFIG` → `git/.gitleaks.toml` → root `.gitleaks.toml`), so F-W3-a arrangements resolve identically.
4. **Validation standard: the induced positive.** No install of v2 is recorded as done until a planted secret in a **pushed** (not staged) commit has been demonstrated to block. A scan that has never been shown to fail is the same class of artifact as a monitor that has never fired.
5. **Rollout + caveat retirement.** After Git.aDNA validates v2 (induced positive), consumers install on Hopper's notice via their `git/` wrappers (HQ/Operations coordinate the nine enrolled vaults); the fleet-wide "`scan-ok` means the hook ran, not that the range was scanned" caveat retires **per-vault** on verified install, not globally on announcement.

## Amendment A3 — Conformance is behavioural; the roster is the instrument (corrects A2 §5) — **accepted 2026-08-23**

*Answers Berthier's `ack_required` ask (`aDNALabs.aDNA/who/coordination/coord_2026_08_19_berthier_to_gracehopper_install_surface_measured.md` — cited by peer-side path deliberately: it is `authored_send_held`, so it was read **staged on his desk, not delivered**, and his send-go remains his to fire. Method + per-vault table: `aDNALabs.aDNA/how/campaigns/campaign_rd_node/artifacts/install_surface_measurement_s214.md`). He measured the install surface instead of scheduling against it, and the measurement says the rollout instruction I sent in A2 §5 is wrong in **both** directions. Two of his three findings I re-verified at source this session before ruling. Ratification: **decision** = A3 as written · **ratified-by** = operator (Stanley, ratification-packet gate — RCC accepted in-session; basis recorded at `session_stanley_20260823_git_ratification_packet` `signature_basis`) · **date** = 2026-08-23 · **status** = `accepted`.*

1. **Behavioural conformance is the bar, not byte conformance.** Resolve `.git/hooks/pre-push` to its **realpath**, then **adjudicate** — never equality-test against a single digest:

   | md5 of the realpath | Verdict |
   |---|---|
   | `a1288f7371afa187cb1cfd8b9810a669` | **PASS** — shipped skeleton v2 |
   | `f255e2a0221794a29b5e24a65fc52622` | **PASS-equivalent** — Venus's script: range-scanning + fail-closed. **Not a finding.** |
   | `216aaca254b97d69819562d506afca29` | **FAIL** — the v1 no-op |
   | *(no file)* | **FAIL, worse** — no gate at all |

   Stripped of comments the two passing scripts differ by one line (a launchd-PATH advisory echo). They already scan the outgoing range and already fail closed; for those vaults v2 is a version bump, not a repair. A byte-equality sweep would file **seven false reds** — including one against **this vault**, whose own live hook resolves to `f255e2a0…` (verified 2026-08-19). Reds that are known-false stop being read, which is how a control becomes decorative.

2. **Install targets the live hook. A2 §5's "via their `git/` wrappers" is corrected.** Exactly one enrolled vault's hook resolves *through* its wrapper; four carry a stale v1 wrapper copy that nothing reads. Installing "via the wrapper" there writes v2 into a dead file, leaves the live hook untouched, and then records the vault installed by md5-ing the file just written. That is **F-S158-01's own disease class — a cheap legible token standing in for the thing it names — reproduced inside the fix for it.** Resolve first, install at the realpath, and record the realpath's verdict.

3. **An instrument must be able to represent the worst state it looks for.** Three separate exercises (the S154 triage, the M-A3 94-vault census, and F-S158-01's own blast-radius count) each enumerated **copies of the skeleton**. A vault with no copy has no row — so the worst possible state, *no gate at all*, rendered as absence-of-a-problem. **Conformance sweeps enumerate the roster, never the artifact**, and every roster entry resolves to a verdict including `FAIL, worse`. Generalised: an instrument that cannot represent the worst state it looks for will report that state as health.

4. **Coverage was 8/10, never 10/10 — and enrollment is the gap.** `WGS.aDNA` and `WilhelmAI.aDNA` are on the nightly roster, push nightly, are counted in `OK 10/10`, and have **no `pre-push` hook and no `how/federation/git/` wrapper** (re-verified at source, 2026-08-19). **This outranks the finding the rollout was about.** The enrollment gate (per-repo scan + operator first-push GO) is hereby explicit that a vault may not enter the roster without a resolvable gate at its realpath; the two already enrolled are a **finding with an owner**, not a backlog row. Their remediation is a scoped, gated cross-vault act (Rule 10) — named here, not performed here.

5. **F-S158-01 does not close on skeleton v2.** Its remaining limb — the nightly log distinguishing *scanned-clean* from *scan-skipped* — is now **unsatisfiable by its original mechanism**: `mesh_rd_push_runner.py` detects a skipped scan by grepping stderr for v1's own wording (`"secret scan SKIPPED"`), which neither v2 nor Venus's script ever prints, because both **block** instead. `OK_SCAN_SKIPPED` is therefore structurally unreachable — a token minted to make the log confess, never once seen in a live fire, made unobservable by the very fix meant to prove it out. An absent scanner now surfaces as `PUSH_ERRORS`. Three of four limbs are discharged; the fourth is Operations' pen and is recorded **open**.

6. **Per-vault install roster.** A2 §5's per-vault caveat retirement had nowhere to be recorded. The roster lives at [[../inventory/disposition_ledger|disposition ledger]] §Secret-gate install roster: one row per enrolled vault carrying realpath verdict · induced-positive date · caveat-retired date. **The `scan-ok` caveat retires per-vault on the induced positive, not on the md5** — A2 §4 stands: a scan that has never been shown to fail is a monitor that has never fired, and md5 is evidence of a file, not of a control.

## Amendment A4 — The population is the denominator; the resolution order is binding (extends A3) — **accepted 2026-08-23**

*Discharges **F-P7a-e** (filed 2026-08-19 against A3 §6's roster). A3 corrected how a single reading is **adjudicated**; it left unstated **which repos get read** and **where the reading is taken from**, and both turned out to be load-bearing. Measured, not argued: [[../inventory/secret_gate_census|fleet secret-gate census]], `measured_at` 2026-08-21T02:26Z, instrument `how/tests/census_secret_gate.sh` (read-only, re-runnable, validated against six sabotage fixtures). **A3's ratified text is not edited** — A4 extends it. Ratification: **decision** = A4 as written · **ratified-by** = operator (Stanley, ratification-packet gate — RCC accepted in-session; basis at `session_stanley_20260823_git_ratification_packet`) · **date** = 2026-08-23 · **status** = `accepted`. ⭐ *Note for a later reader: A4's **headline** decision — the claimed population — was already an operator ruling at the **2026-08-20 plan gate**, as this preamble records. This stamp therefore **records a decision already taken**; it did not make one.*

**Headline: coverage is 70/117 (60%), not 8/10 (80%).** Both numbers are arithmetically correct; they describe different populations. Operator ruling at the 2026-08-20 plan gate selected the population below.

1. **The claimed population is every push-capable repo, minus a dated and enumerated exemption list.** `Operations.aDNA/.../enrolled_vaults.conf` is a **scheduling artifact** — it enumerates what the nightly runner pushes, which is a different question from what the gate covers. It happened to be enumerable, and being enumerable is how it became a denominator. **Coverage is always reported as a fraction of *claimed*, and the exempt set is printed *with* the number, never behind it** — a repo that disappears from a denominator is indistinguishable from a repo that passed. Enumeration spans nested repos (`what/<code>/`), not just vault roots: 6 of the 14 no-op gates are nested, and none of them were in any prior count.

2. **The adjudication table gains four classes. An unknown reading is never a silent pass.**

   | Reading | Verdict | Rule |
   |---|---|---|
   | *(digest with no row)* | **`UNCLASSIFIED` — counts as FAIL until adjudicated** | An instrument closed over known digests treats every hook it has never seen as acceptable. Unknown is a question, and an open question is not a pass. |
   | `a9399d70…` — git-lfs's own pre-push | **FAIL-for-purpose, and *compose*, never overwrite** | A foreign hook occupying the slot is not a secret gate; installing over it silently breaks LFS. Repair composes the two. |
   | `3f4bb7f6…` — legacy publish-sanitize (`LAYER_CONTRACT_VERSION=4.0.1`) | **FAIL for ADR-011, adjudicated on its own terms** | It is a real control with a real guarantee (it does read the outgoing ref list); it is **not** this gate. Neither silently credited nor dismissed. Live on **`PercySleep.aDNA`** — class I-strict. |
   | `280056d3…` — class-L refuse-all | **`PASS_STRONGER`** | Blocks *every* push unconditionally — strictly stronger than a scan. **A3 §3 inverted**: an instrument that cannot represent a state *better* than the one it expects reports that state as a defect, and known-false reds stop being read. |

3. **Resolution order is binding: `core.hooksPath` → `rev-parse --git-path` → `realpath` → adjudicate.** A reading taken from a path git does not consult is not a measurement of anything. Where `core.hooksPath` is set, `.git/hooks/` is **irrelevant** — `ScienceStanley.aDNA`'s `.git/hooks/pre-push` adjudicates PASS while the hook git actually executes is the retired no-op. And a `core.hooksPath` pointing at a **defunct absolute path** disables hooks silently: `Archive.aDNA/lattice-labs` points outside the workspace at a directory that no longer exists. **That is F-Astro's exact mechanism** (2026-06-22, Wave 2) — *fixed in the vault where it was found and never swept for*, still live two months later. **A finding closed at its instance is not a finding closed**; every hook-mechanism finding now carries a fleet sweep or an explicit, dated decision not to sweep.

4. **The enumeration predicate is part of the instrument, and a repo it excludes is *unmeasured*, not healthy.** `[ -d .git ]` is false for linked worktrees and submodules, whose `.git` is a **file** — four `latlab` worktrees, all pushing to a live GitHub origin through one shared no-op hook, were excluded outright and thereby rendered as absence-of-a-problem. This is A3 §3 one level up: A3 fixed the roster so *no gate at all* gets a row; A4 fixes the predicate so *not looked at* gets one too. Worktrees and submodules are in-population. Root-level **shims are not separate repos** — a symlink and its target share one control, and adjudicating both double-counts it, flattering coverage whenever the shared gate passes.

5. **Content is not execution, and presence is not content.** A hook with byte-perfect v2 content and no `+x` bit is not run by git; a digest-only column reports it PASS. A dangling symlink is a hook that is *installed and broken* — a different repair from a hook that is *missing*, and `[ -e ]` alone cannot tell them apart. Both are verdict rows, not footnotes.

6. **Any conformance instrument must be demonstrated to fail before its output is trusted** (ADR-015 §D1.5b, applied reflexively). The census ships with sabotage fixtures covering every clause above and is required to fail each one, *and* to still pass a known-good control — an instrument stuck at FAIL is as useless as one stuck at PASS. This is not ceremony: the fixtures found an unreachable branch in the census's own dangling-symlink handling, which had been reporting a broken hook as a missing one. **An unreachable branch in a checker is F-P7a-f wearing a different coat.**

## Amendment A5 — The induced positive must be able to fail; reading and repairing take different paths (extends A2 §4, A4 §3) — **accepted 2026-08-23**

*Occasioned by **Galileo** (`Jupyter.aDNA`, `bright_sextant`, 2026-08-21), who re-ran A2 §4's validation first-hand rather than inheriting a prior lane's, and whose **first attempt returned a false green**. Their receipt is quoted below and credited by name; the wording is ours because the ADR is. Adjudication of the full inbound, with every claim re-measured at source: [[../inventory/galileo_inbound_adjudication|galileo_inbound_adjudication]]. **A2's and A3's ratified text are not edited** — A5 extends them. Ratification: **decision** = A5 as written · **ratified-by** = operator (Stanley, ratification-packet gate — RCC accepted in-session; basis at `session_stanley_20260823_git_ratification_packet`) · **date** = 2026-08-23 · **status** = `accepted`. ⚠ *Recorded at the stamp: A5 had already been **delivered to Rosetta as an instruction to change their validation** (`coord_2026_08_22_hopper_to_rosetta_a5_the_plant_matters`, delivered 2026-08-24T01:42Z) while still `proposed`. A peer acting on an unratified clause is a state that should not recur; it is named here rather than quietly resolved by the ratification that ends it.*

**Headline: A2 §4, followed literally, can certify an inert hook.** It requires *"a planted secret in a **pushed** commit demonstrated to block"* and says nothing about **what** is planted. That is **F-P7a-f arriving at the clause written to enforce F-P7a-f** — a validation standard that cannot reliably fail is not a validation standard.

1. **The planted secret must be synthetic and non-allowlisted.** Scanners allowlist vendor **documentation example** credentials by design. Galileo planted `AKIAIOSFODNN7EXAMPLE` / `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` — the canonical AWS example pair, *and the first thing most people reach for*. The hook scanned the correct outgoing range, reported **`gitleaks clean ✓`**, and **pushed the commit**. In their words:

   > *"An induced positive built from a documentation example key validates nothing, and it fails in the reassuring direction — it prints the same green a working control prints."*

   The plant is therefore **random-bodied with a real rule shape** (e.g. a `ghp_` prefix over a random body), and — per the reference implementation — **assembled at runtime so the literal never appears contiguously in the hook file**, which would otherwise make the gate's own source a finding.

2. **Both arms are required; a single arm adjudicates nothing.** Validation completes only when the **clean** arm passes *and* the **planted** arm blocks. A hook that blocks *everything* prints exactly the red a working hook prints — this is **A4 §2's `PASS_STRONGER` row seen from the other side**, and an instrument stuck at FAIL is as useless as one stuck at PASS (**A4 §6**). Where the scanner can be removed, the **scanner-absent** arm is a third required row (A2 §2).

   ⚠ **Recorded against ourselves: A2 already knew this and A2 §4 did not say it.** A2 §3 *describes* the reference implementation as "already self-tested downstream (clean range passes · planted `ghp_` token blocks exit 1 · scanner-absent blocks exit 1)" — three arms, the synthetic plant among them — and §4 then codified a weaker standard **eleven lines later, in the same accepted text**. The doctrine was not missing; our writing-down of it was. This is the second time an amendment of ours has had to repair a clause that its own neighbouring paragraph contradicted (cf. ADR-014 A4 on A3 §1).

3. **Reading a hook and repairing a hook take different paths.** A4 §3's resolution order (`core.hooksPath` → `rev-parse --git-path` → `realpath` → adjudicate) is correct for **reading** and is a hazard as a **repair target**, because `--path-format=absolute` **resolves symlinks and returns the target**. Measured on three cases this sitting:

   | Case | Query | Answer |
   |---|---|---|
   | symlinked install | `--path-format=absolute --git-path hooks/pre-push` | ⛔ the **tracked wrapper** — a `cp` here overwrites the file P7a rows 8–9 reserve |
   | linked worktree | `--absolute-git-dir` | ⛔ `…/.git/worktrees/<name>` — which contains **no `hooks/` at all** |
   | either, plus plain repos | `--path-format=absolute --git-common-dir` + `/hooks/pre-push` | ✅ the link itself, unresolved; worktrees collapse correctly |

   ⇒ **repairs target `"$(git rev-parse --path-format=absolute --git-common-dir)/hooks/pre-push"`**, never the `--git-path` answer. Galileo's tree recorded a live instance: a `cp` to the resolved answer wrote the tracked wrapper, caught by md5 and reverted. The worktree half is **A4 §4's exclusion by a second, independent predicate** — the same four `latlab` worktrees rendered unmeasurable twice over.

4. **A predicate that matches a hook's own documentation is not a measurement.** Adjudicating a hook by grepping for a signature string counts occurrences in **comments** — including the comment in which a hardened hook describes the defect it replaced. Measured: `f255e2a0…` (**`PASS_EQUIV`**, A3 §1; **68 of the census's 70 passing repos**) was nominated as an ungated v1 hook on a count of *"two `--pre-commit` sites"*; it has **one**, at line 13, inside the rationale block, and **8 `remote_sha`/`local_sha` sites** with a live range scan and a fail-closed arm. Taken at face value the reading moves fleet coverage from **60%** toward **2%**.

   ⇒ **a content check states what it measures — line-anchored, position-bound, comments excluded — or it is a check that cannot correctly fail.** Filed as **F-P7b-f**; it is **F-P7b-e's second instance** (this vault's own `lfs_rehydration` check false-BLOCKED on the two files that merely *quote* the LFS pointer signature — its own source and its own runbook), and the first in a peer's tree. **A false red and a false green are the same defect**: neither predicate stated its subject. Digest-based adjudication (`census_secret_gate.sh`) is immune to this **by construction**, which was a property of its design and not a foresight anyone can claim.

## Amendment A6 — A content check tests for the fix's mechanism, never the defect's name (extends A5 §4) — **accepted 2026-08-24**

*Occasioned by **Galileo** (`Jupyter.aDNA`, `candid_plumbline`, 2026-08-23), replying to our F-P7b-f memo. They did not take our retraction on our word — they re-measured — and **the re-measurement moved the clause**. Their receipt arrived via our own `probe_peer_state.sh --exec` at `2026-08-24T04:05Z`, **minutes after A5 was ratified**. ⛔ **A5's ratified text is not edited** — A6 extends §4. Every number below re-measured at our own object before ruling. Ratification: **decision** = A6 as written · **ratified-by** = operator (Stanley, plan gate — the A6 recommendation and its reasoning were carried in the plan in full before approval; basis recorded at `session_stanley_20260824_git_p7b_the_seven_land` `signature_basis`) · **date** = 2026-08-24 · **status** = `accepted`. ⭐ *Note for a later reader: A6's correction was **already implemented in the shipped artifact** before this stamp — contract 2.1.0's classification and the `census_secret_gate` adjudication both follow §4's positive predicate. So this stamp, like A4's, **records a decision already acted upon**; what it closes is the gap between practice and record, which is the drift A4's own stamp was found to be documenting.*

**Headline: A5 §4 named the wrong mechanism, and the predicate it implies is non-discriminating — so A5 §4, followed literally, would certify a useless test.** That is **F-P7a-f arriving at the clause written to enforce F-P7a-f**, for the *second* time in the same amendment chain (cf. A5 §1 on A2 §4).

1. **The mechanism was not "the grep matched the documentation" alone.** A5 §4 attributed the false reading to a predicate matching a hook's own comment block. Measured, **the strict form cannot produce the reported count at all**: `grep -c -- '--pre-commit'` returns **1** on the hardened file and **1** on the v1 no-op. The producing command was the **loose** form, `grep -c 'pre-commit'`, which returns **2** — and the two hits are **two different false-positive classes**:

   - **line 13** — the defect's own documentation. *Our half, as filed.*
   - **line 44** — `# known-good one (same probe discipline as the sibling pre-commit hook)` ⇒ **a reference to a different hook entirely.** Not documentation of the defect, not about the flag. **A5 §4's wording does not reach it.**

2. **The loose predicate is not merely wrong — it is *anti-correlated*.** Run as a classifier across all three hook classes (Galileo's table; our v2 row re-measured here at `a1288f73…`):

   | file | truth | loose `pre-commit` | strict `--pre-commit` | `remote_sha\|local_sha` |
   |---|---|---|---|---|
   | `f255e2a0…` Venus hardened | **GATED** | **2** ← highest | 1 | **8** |
   | `216aaca2…` P3 skeleton | **NO-OP** | 1 | 1 | **0** |
   | `a1288f73…` our v2 | **GATED** | 1 | 1 | **8** |

   ⭐ **It scores the most hardened file highest, because remediation documentation is written *into* the remediated artifact — a hook earns its false red by explaining the defect it fixed.** Our own v2 header would score worse the more carefully it documented what it superseded.

3. ⚠ **The "corrected" strict form is non-discriminating — 1 · 1 · 1 — and A5 §4 as written would certify it.** This is the more dangerous half **because it looks like the fixed instrument**: arithmetically correct, anchored, position-bound, comment-excluded — and unable to separate a gated hook from a no-op. ⭐ **The predicate rule's fifth direction: a check that cannot correctly *discriminate*.** The four already filed were *cannot fail · matched documentation · cannot succeed · compared against the wrong object*; this one **satisfies every stated repair of the first four and still measures nothing.**

4. **Therefore, binding: a content check tests for the presence of the fix's mechanism, never for the absence of the defect's name.** A **positive** predicate, not a negative one. Concretely, a pre-push hook is classified by `remote_sha|local_sha` (**8 / 0 / 8** — the only column in the table that separates truth) or by `HOOK_CONTRACT_VERSION`, which our v2 carries and which is the cleanest handle in the file; **never by `--pre-commit`**. Generalised: *the absence of a defect's name is evidence about prose. The presence of a fix's mechanism is evidence about behaviour.*

⛩ **Recorded with credit, including the half they kept**: Galileo's own first hypothesis was a two-file census that **also sums to exactly 2** — *"two different wrong mechanisms, one number"* — and they found the real one only by **running candidate commands against the artifact instead of reasoning about it.** Their words, worth preserving: *"Had we stopped at the arithmetic, we would have sent you a plausible, self-consistent, wrong root cause — and you would have had no way to tell."* ⚠ And their disclosure on the original §4(b): the md5, the class, and the site-count were **three separate unmeasured claims that agreed with each other**.

## Amendment A7 — A digest is a name, not a verdict (extends A3 §1, A4 §2) — **accepted 2026-08-24**

*Occasioned by **F-P7b-p**, filed against our own shipped artifact: `pre-push.gitleaks.sh:24` asserts *"Measured 2026-08-24: **44/44** wrapper-carrying vaults still hold that shim"*. Re-measured at the cut: **59–61 wrapper-carrying vaults, 54 with the shim, 5 without** (`Emacs`·`Fluxer`·`GOTFN`·`RealityScan`·**`WGS`**). The claim is false, and false in the **reassuring** direction, inside the file 35 vaults are being asked to re-install from. ⛔ **And the one-character fix was blocked**: the hook's md5 is recorded as evidence in **A6's ratified Consequences**, so editing a comment falsifies a ratified record. Ratification: **decision** = A7 as written · **ratified-by** = operator (Stanley, plan gate — the plan carried A7's five clauses, the finding that occasioned them, and clause 5's no-gate statement in full before approval, **and offered an explicit `hold A7 as proposed` escape which was not taken**; basis recorded at `session_stanley_20260824_git_p7b_the_digest_that_froze_the_artifact` `signature_basis`) · **date** = 2026-08-24 · **status** = `accepted`. **A3's, A4's, A5's and A6's ratified text are not edited** — A7 extends them, and the untouched-ness is **verified by per-section md5 before and after**, not asserted.*

**Headline: the binding adjudication table has no row for the hook this vault currently ships, and that is not a prospective gap — it is live.** A3 §1's table lists `a1288f73…` / `f255e2a0…` / `216aaca2…` / *(no file)*; A4 §2 adds four classes and the rule *"digest with no row → **`UNCLASSIFIED`**, counts as FAIL until adjudicated."* `04e6a745…` — contract 2.1.0, shipped 2026-08-24 — **appears in neither.** Its only PASS lives in A6's *Consequences* narrative and in `census_secret_gate.sh:71`.

⛔ **Measured at this sitting's opening baseline, before any edit:** `WGS.aDNA  git-path  present  04e6a745  PASS  x  symlink`. **One vault in the fleet is adjudicated two ways right now** — PASS by the instrument, UNCLASSIFIED-therefore-FAIL by the binding rule. ⭐ **And it is `WGS`, the vault that wrote the install-surface repair before we did.** Adopting our own shipped fix is precisely what made them the single vault the ratified table cannot classify. *A conformance table that penalises the fastest adopter of the thing it certifies is keyed on the wrong quantity.*

1. **A digest is a name, not a verdict.** Binding adjudication is by **mechanism**: the hook's `HOOK_CONTRACT_VERSION` marker, the range-scan mechanism (`remote_sha`/`local_sha` over the *outgoing* range), and the **fail-closed** arm. A digest may be reported — in its own column, as a label naming a known artifact — and **never contributes to the verdict**. This is not a new invention: `how/tests/census_wrapper_copy.sh` already implements exactly this split (*"MECHANISM DECIDES THE CLASS. The digest only NAMES a known artifact, in a separate column, and never contributes to the verdict"*), and it was **proven by regression** — 6 red on the four removed mechanisms, `--meta` 9/9. A7 makes the reference shape binding rather than incidental.

2. **The digest of record moves to the release ledger.** [[../inventory/wrapper_contract_releases|`wrapper_contract_releases.md`]] — which ADR-004 A1 §1 already designates *"the ONE place a bump is recorded"* — is the **dated digest of record**. ADR-011 stops carrying exact md5s as **ratified evidence**. Digests already written into A2–A6 stay exactly where they are: they are **dated historical readings**, true at their timestamps, and a historical measurement is falsified rather than improved by editing it.

3. **The owed row is discharged, by role rather than by enumeration.** `04e6a745…` adjudicates **PASS** — not because a row was added for it, but because it *carries the mechanism*: `HOOK_CONTRACT_VERSION=2.1.x`, a live outgoing-range scan, and a fail-closed arm. Every future shipped version adjudicates the same way **without an amendment**, which is the whole point. `WGS.aDNA`'s live install is correctly classified from this stamp forward.

4. **A4 §2's `UNCLASSIFIED` rule survives untouched.** An unknown reading is still never a silent pass. A7 changes **what makes a reading known** — mechanism, not identity — and changes nothing about what happens to a reading that remains unknown. A hook carrying none of the three mechanisms is `UNCLASSIFIED` and counts as FAIL, exactly as before.

5. **No blocking gate is wired to A7, and the instrument is deliberately left digest-keyed.** No check enforces this clause set: an enforcing check is a stronger claim on the world than a written clause, and shipping the check first inverts the order §7.7 exists to impose — the defect ADR-013 A1's Consequences recorded against this desk, and the reason ADR-004 A1 §5 declined the same wiring. ⭐ **`census_secret_gate.sh` therefore stays on its digest table on purpose**: a closed digest table is a **strictly conservative** implementation of a role rule — it PASSes only what it has positively recognised, and A4 §2 catches everything else as FAIL — so the instrument sits *behind* A7 without diverging from it. It costs one hand-added row per shipped version, **visibly**. Porting the mechanism split into it is a behaviour change to the fleet's measuring instrument and is **its own pass**, filed to the register.

⛩ **The coupling nobody designed.** A6 pinned a digest to make a fix *verifiable*, and in doing so converted the artifact into something **un-editable without an amendment** — every future correction to a shipped file, however cosmetic, falsified a ratified record. Same family as **F-C36**: a mechanism correct in itself, correctly evaluated, and load-bearing for a third party who was never consulted. ⭐ **And the sharpest form of it is a self-indictment**: **A5 §4 praised digest adjudication as *"immune to this by construction"*** — immune to the content-predicate false-positive class, and true. *It is exactly that immunity — identity-matching, which cannot be fooled because it cannot generalise — that produced the freeze.* **A property can be the virtue on one axis and the defect on another, and naming it as a virtue is what stopped anyone looking at the other axis.**

## Amendment A8 — A4 §6 is made evaluable: an instrument's own conformance is a predicate, not a habit (extends A4 §6) — **accepted 2026-09-07**

*Authored 2026-09-06 (30th sitting) after the class A4 §6 forbids was measured **seven more times, all
after A4 §6 was ratified**. Ratification: **decision** = A8 with §5's F-P7b-av population predicate
stated (22-of-23, the fixture named) · **ratified-by** = operator (plan gate,
`please-give-your-rec-giggly-kahan`) · **date** = 2026-09-07 · **status** = `accepted`.*

> ⚠ **Revise-then-ratify, and what was revised.** At the ratification gate §5's F-P7b-av bullet still read
> *"the true population is **22**"* — a bare integer for a population, inside the clause that forbids
> exactly that. **One bullet was revised** to state its predicate; **§§1–4, 6, 7 and the provenance block
> are byte-unchanged**, and the untouched-ness is diff-verified rather than asserted (A7's discipline).
> ⛩ *An amendment that shipped an instance of its own clause would have been the fourth time this campaign
> found the rule and the violation in one artifact.* Precedent for the move: the 29th sitting's "revise A6
> to rev 3 then ratify". Three alternatives declined, as there: ratify-and-fix-in-A9 · carve out §5 · hold.

**The finding, in one line: A4 §6 is the rule, it has been ratified since 2026-08-23, and every
instance of the class has landed since.**

| # | instance | shape |
|---|---|---|
| **F-P7b-z** | R7 has shipped in `.adna/` and has never run — `--self-test` reimplements R1–R6 | the only exercise is a path no caller takes |
| **F-P7b-ag** | the deny file was held back "by choice"; the hook that reads it was not installed either | a gate believed installed that was not |
| **F-P7b-as** | a no-tty guard that reads correctly and **cannot fire**; it reached the right verdict by accident | a guard whose predicate is never true |
| **F-P7b-ar** | the live control was untracked and named a source of record that did not exist | an install with no asserted provenance |
| **F-P7b-aa** | a probe that returned `UNKNOWN` for a whole population — fail-safe, but uninformative | an absence borrowing a verdict |
| **F-P7b-am** / **F-F91** | `carrying=0` from a broken loop; `UNMEASURED` printed beside `compared=4/4` | a benign value never measured |
| **F-F97** (peer) | a hazard withdrawn on `waiting=0`, taken before the schedule was registered | a zero over an empty population |

⛩ **A4 §6 is prose with no population, no verdict set, and no enforcement — the identical defect
[[adr_014_mesh_remote_role|ADR-014]] A4 §1 fixed for the declared freshness mode (made it a *field*)
and A6 §2 fixed for T2 (made it a *predicate*).** Third time, same move. *A rule stated as prose, with
no mechanism that could ever notice it was untrue, is how this campaign keeps finding the same thing.*

### §1 — The population (binding)

A **conformance instrument** is any executable in this vault whose output is cited as evidence for a
decision, a gate, or a coverage claim. **Enumerated from the tree, never rostered**
([[adr_016_publication_boundary|ADR-016]] D6.2) — a list of what we believe exists is not a
population, and A4 §4 already ruled that a thing a predicate excludes is *unmeasured*, not healthy.

### §2 — A total verdict set (binding)

Every instrument lands on **exactly one** verdict, and totality is binding — A6 §2's property, reused
because rev 1 of that clause was not total and the missing case was the urgent one (F-P7b-ao).

| verdict | predicate |
|---|---|
| **`DRIVEN`** | exercised at its **real entry point**, **and** it has a negative control that has been **demonstrated to fail** |
| **`SELF_TEST_ONLY`** | its only exercise **reimplements** the rule rather than driving it — F-P7b-z's class |
| **`NO_META`** | no negative control. Its output is **unverified**, which is not the same as wrong |
| **`NOT_INSTALLED`** | a gate whose installation is **not asserted** — see §4 |
| **`INDETERMINATE`** | unread, unreadable, or two vantages disagree |

### §3 — Unmeasured is `INDETERMINATE`, never a green and never a zero (binding)

**Reused verbatim from A6 §2.2**, and cited as reuse rather than re-derived — restating a rule in new
words is how two versions of it start drifting. An absence that borrows a benign verdict is the
failure mode this clause exists to forbid.

### §4 — Installation is part of the control (binding)

A gate's installation is **asserted, never assumed**. The installed artifact must have a **tracked
source of record** and must **match it**. Both halves are F-P7b-ar, stated as a rule instead of a war
story: the live control was untracked *and* its header named a tracked source that did not exist, so
it was unreconstructible — and nothing noticed, **because it worked**.

⇒ A gate that is not installed is `NOT_INSTALLED`, which is a **verdict**, not a silence.

### §5 — A coverage claim states its population, or it is not a coverage claim (binding)

A green from an instrument is a statement **about the population it examined**, and that population
is reported **with the verdict, always**. A verdict whose population is unstated may not be cited as
coverage.

⛔ **This clause is the one bought most expensively, and by three desks in one sitting:**

- **Ilmarinen** — four Wave-2 vaults "landed clean"; their pre-push scanned a range of **0 commits**.
  gitleaks examined nothing and returned success. ⭐ His line, and it is the clause in a sentence:
  ***"they did not pass, they were not looked at."***
- **F-F97** (his, against himself) — a hazard withdrawn on `waiting=0`, where the zero was taken
  **before the schedule was registered**: *"has not"* read as *"cannot"*.
- ⛔ **F-P7b-av — ours.** The planning pass for **this amendment** reported *"9 files carry
  `status: draft`"*. The command was `grep -rl … | head`; `head` truncated at 10 in silence. **The true
  population is 23** — tracked `*.md` whose first-block frontmatter matches `^status:[[:space:]]*draft`,
  measured at `a2b00a6`; **22** excluding `how/standard/hooks/test_fixtures/dirty/draft_post.md`, which
  is R6's **deliberate negative control** and must stay draft. The number was plausible, so nothing
  questioned it, and it was given to the operator as a population and used to size a decision.
  ⚠ **This bullet said "22" with no predicate until 2026-09-07** — a bare integer for a population, in
  the clause that forbids exactly that. Corrected before ratification rather than after, because a
  ratified §5 carrying an unstated population would be the clause disproving itself in its own text.

⛩ *The clause was authored against seven instances of other people's version of this mistake, in a
pass that committed it.*

### §6 — A control must be runnable in the context it is required to run in (binding)

⛔ **An unattended-capable gate that can only reach its verdict through an interactive prompt is a
conformance defect**, and is `NOT_INSTALLED` for its actual population.

*Answers Ilmarinen's 2026-09-03 `ack_required` ask, which he routed to this pen rather than inventing
a predicate to sweep against.* His instance: `PercySleep.aDNA`'s pre-push hook dies with
`/dev/tty: Device not configured`. ⚠ **It does not fail open** — the direction is right — but it
fails **for a reason unrelated to what it checks**, and names a **device** rather than a **finding**.

⛔ **Why this outranks its one instance**: `Operations.aDNA`'s nightly `mesh_rd_push` runs
**unattended**. Any vault whose hook prompts fails there identically, **forever**, with an error that
reads as an infrastructure fault rather than a policy gate.

**The conforming shape** — the reference cure, already shipped here at `pre-push-sanitize.sh` 4.2.0
(F-P7b-as): **test the act, not a property inferred about it** (`if ! ( : < /dev/tty ) 2>/dev/null`,
in a subshell), and on no controlling terminal **resolve to the stricter verdict with an explanatory
message naming the finding**. ⚠ Not by prompting-and-hoping, and not by proceeding.

⚖ **Sweeping for other instances is Ilmarinen's**, against this predicate; the predicate is ours.

### §7 — Reflexive, and says so (binding)

A8 binds **every instrument this vault cites**, including any instrument built to evaluate A8 itself,
**first of all**. A conformance census that has not been demonstrated to fail is `NO_META` in its own
report — and if it cannot represent that about itself, it is not implementing this amendment.

### A8 provenance

- ⭐ **The rule was not missing. The mechanism was.** A4 §6 is quoted at the top of `send_memo.sh` and
  cited in three instruments; it was read, agreed with, and cited by the same desk that then produced
  five instances of the class. **Citation is not enforcement** — which is
  [[adr_017_ratification_record|ADR-017]]'s lesson (*a discipline held in prose propagates as an
  absolute and is not held at all*), arriving one level down, in the instruments rather than the
  records.
- ⚠ **No instrument is shipped with this amendment, deliberately.** `census_instrument_meta.sh` is
  **deferred to a later sitting by operator ruling**, and A8 is authored first so the clause is not
  written to describe whatever the instrument happened to measure. ⛔ That ordering is the one §7.7
  exists to impose, and it is the inverse of what this vault did with R8 four days ago — recorded
  because doing it correctly once does not retire the finding about doing it the other way.
- ⚠ **A8 does not amend A4 §6, and A4's ratified text is untouched.** A4 §6 remains the rule; A8 gives
  it a population, a verdict set, and two clauses (§4, §6) it never had.

## Consequences
- (A7) ⛔ **`census_secret_gate.sh:64–69` carried a blocker that had outlived its blocker.** It read *"⛩ A6 (`proposed`, NOT ratified) prescribes the real fix for this whole function… NOT DONE HERE — acting on unratified text is the exact error this desk apologised to Rosetta for on 2026-08-23."* **A6 ratified 2026-08-24.** The note went on asserting a falsehood inside a shipped instrument — *the same class as the `44/44` line, found in the file written to measure that class.* ✅ Corrected at this act. ⭐ **Rule taken: a note that names its own blocker must name the observable that clears it, or it becomes false the moment the blocker lifts and no one is watching that sentence.**
- (A7) **Hook `2.1.1` cut at this act** — `HOOK_CONTRACT_VERSION` bumped and line 24's false universal replaced with the measured reading plus the honest attribution: nothing was dangling, and the evidence for that is `census_secret_gate.sh`'s independent **0 dangling** reading, **not this count**. ⭐ *A number that does not establish the claim standing next to it is not support; it is decoration that reads as support.* Digest recorded in the release ledger (§2), **not here**.
- (A7) ⚠ **The induced positive is INHERITED from 2.1.0, and that is a dated decision rather than an omission.** A5 §1 requires a synthetic non-allowlisted plant demonstrated to block. 2.1.1 changes **comments only**, and the licence for inheriting is the **stripped-comment diff being empty** — which is *run*, not asserted, and recorded in the ledger row. Had that diff been non-empty the inheritance would have been void and the full both-arms validation required before the row was cut. Per A4 §3, an explicit decision not to re-run is carried rather than left as a gap.
- (A6) ⚠ **`probe_peer_state.sh`'s header carries F-P7b-f as *"grepping a string that appears in that hook's OWN COMMENT BLOCK"* — right, and Galileo's measurement shows it is *half*.** The instrument itself is unaffected (`declared_collision` reads declarations positionally, and digest-based adjudication in `census_secret_gate.sh` is immune **by construction**), but the header's stated rationale is incomplete and is owed an update. ✅ **UPDATED 2026-08-24** (`session_…_the_seven_land`) — the header now names **both** false-positive classes (line 13 = the defect's own documentation, *our half as filed*; line 44 = a reference to **a different hook entirely**, which our wording did not reach), records that the loose predicate is **anti-correlated**, and carries the **fifth direction** (1·1·1 — cannot discriminate) with A6 §4's positive-predicate answer. ⭐ **Why a header edit was worth its own act:** the guard was never at risk, but *a guard whose stated rationale is wrong will be widened wrongly by whoever extends it next* — the rationale is the part a future author reads before touching the check.
- (A6) ⛔ **Our shipped v2 hook documents an install line that assumes a pre-ADR-045 layout** — `how/federation/git/hooks/pre-push.gitleaks.sh:15`, `ln -sf ../../git/hooks/… .git/hooks/pre-push`, which resolves to `<root>/git/hooks/` and therefore only works where a root `git/` shim exists. **`ln -sf` succeeds against a non-existent target, git silently skips a hook it cannot execute, and the repo reads *installed* while being *ungated*** — no error at install time, none at push time. **Absence indistinguishable from health**, the same family as A4 §4's `[ -d .git ]`. Fix per **our own A5 §3**: derive the target from `git rev-parse --path-format=absolute --git-common-dir`, and have `--self-test` assert `.git/hooks/pre-push` resolves to an **existing executable** (today it probes the engine only and would pass on a dangling install). ~~**Not fixed here** — it edits a shipped artifact and is its own gated act.~~ ✅ **FIXED 2026-08-24** at that gated act (`session_…_the_shim_that_holds_it_up`) — contract **2.1.0**, md5 `a1288f73…` → `04e6a745…`; both digests adjudicate `PASS` (2.0.0's scan path is byte-identical and correct). Validated by induced positive: synthetic non-allowlisted plant **BLOCKED** and **absent from the remote afterwards**; known-good control **PUSHED**. Harness **31 → 42**, the 11 new cases carrying both arms.
  - ⛔ **AND THIS BULLET'S OWN FRAMING WAS WRONG IN BOTH DIRECTIONS — struck, not erased, because the correction is the finding.** ~~It implies live exposure.~~ **Measured 2026-08-24: 44 of 44 wrapper-carrying vaults hold the root `git/` shim, and the fleet census reports ZERO dangling installs** (a second, independent instrument agreeing). **Nothing was ungated. The defect was LATENT.** ⭐ **And "latent" understates it in the other direction**: that shim is registered in `Home.aDNA` §C under the **ADR-045 wrapper-relocation batch** — 175 unique root `<wrapper>` shims, `git` among them — window **`~2026-07-30`, LAPSED**, disposition **"batch-retire as one pre-authorized wave."** ⇒ **the hazard was never "some vaults are broken"; it was that one already-approved cleanup on another vault's lane would have converted 44 working installs into 44 silently-ungated repos.** ⛩ **F-C36's rule inverted**: Pandora paid for *"key a retirement condition to the observable it waits for, never to a phase expected to deliver it"* — here a retirement keyed to the **right** observable fires **correctly** and breaks a third party's artifact, because the artifact depended on the thing being retired and never said so. **A dependency on a shim is a dependency, and the shim registry cannot see it.**
  - ⚠ **Two consumers found this before we did, independently, and neither reached the artifact's owner.** **Galileo** (`Jupyter.aDNA/how/federation/git/CLAUDE.md`) recorded the hazard *exactly*, including the shim-retirement trigger, and routed it as *"an observation; the shim's retire-condition is Hestia's, not this vault's"* — correct about the shim, but **we ship the hook and were never told**; it reached us days later inside a memo about something else. **WGS** (`WGS.aDNA/how/federation/git/CLAUDE.md`) went further and **had already implemented this exact repair** — `--git-common-dir`, `ln -sfn` to canonical, with the A3 §2 wrapper-copy trap written out. **The fix existed in the field and the shipping vault was the last to know.** ⭐ **The rule, and it is against us as much as anyone: a defect in a shipped artifact routes to the artifact's OWNER, not only to the party who can work around it. A finding routed to whoever can route around it is not a finding reported.** (2.1.0 adopts WGS's substance **with credit**, changing one thing: they hardcode `~/aDNA/Git.aDNA`, and an absolute path to one machine inside the portability vault's own shipped artifact would be its own finding — so the source is derived from the script's location instead.)
- (A6) **`gate_repoint_runbook` row 9 closes for coverage** — Galileo measured all five checkouts of `what/lab` (main + 4 linked worktrees) resolving to one `a1288f73…`. **Row 8 stands**: `what/lab-workspace` is still `216aaca2…`, **0** range sites. Both rows remain **ours and unfired**.
- The #1 High risk moves from a label to an enforced, layered control (local hook → CI → hard pre-move gate).
- (A5) ⚠ **Every induced positive on the roster records that a plant blocked and none records *what was planted*.** Checked at source: `Git.aDNA`'s own row reads *"drill 3/3 (planted-secret-in-pushed-commit BLOCKED · clean PASSED · scanner-absent BLOCKED)"* — three arms, correctly, but an **unnamed subject**; `Network.aDNA`'s reads *"upstream (Venus's own self-test)"*, traceable to a `ghp_`-class plant only through A2 §3, one indirection away. **No recorded validation is retroactively voided** — nothing suggests a documentation example was used, and the reference implementation's plant is synthetic. But **none of them can be re-adjudicated by the next reader**, which is the defect A5 §1 describes, standing in our own ledger. From A5 the roster row records **what was planted** and **that both arms ran**.
- (A5) Repairs and readings take different paths: repointing a hook via the `--git-path` absolute answer can overwrite a **tracked wrapper**, and the fleet's four linked worktrees are unmeasurable through `--absolute-git-dir`. The repoint runbook targets `--git-common-dir`.
- (A4) The fleet's real coverage is known and is **60%**, against a claimed population that is written down. 14 repos with live remotes push through a hook that appears installed and does not gate; the repair is **10 wrapper files**, staged in the P7a repoint runbook and gated per Rule 10.
- (A4) The shipped skeleton v2 has **one** live installation fleet-wide (`aDNALabs.aDNA`). "We shipped v2" and "v2 is deployed" differ by 116 repos; the census makes the gap visible rather than inferable.
- (A3) Conformance sweeps stop producing false reds against behaviourally-correct vaults, and start producing rows for vaults that have no gate at all — the two failure modes the byte-equality instrument had exactly backwards.
- (A2) F-S158-01 closes on the induced-positive demonstration; ten vaults stop pushing nightly on a scan that does not run.
- P6 waves cannot start a host move on a repo until its history scan is clean — the gate is mechanical, not advisory.
- `repo-migrate` (P3 skill) embeds D4 as a precondition; the doctrine block (ADR-009 D6) gains a scan line.

## Open questions carried forward (→ P3)
- Allowlist/baseline management (false positives; committed-test-fixtures policy).
- Scan performance on large/LFS repos (note: `DataRoom.aDNA` is Class **L** / never-push, so out of the migration path entirely).
- When to escalate an I-strict repo from `gitleaks` to `trufflehog` verified-secret mode.

## Alternatives considered
- **No scan / manual eyeballing** — rejected: the High risk demands a mechanical gate.
- **CI-scan only (no pre-move history gate)** — rejected: by CI time the secret is already on the host; the hard gate is the point.
- **`trufflehog` as default** — rejected: heavier; `gitleaks` is the standard fast default. `trufflehog` stays the deep-verify adjunct.
