---
type: decision
adr_id: adr_011
title: "ADR-011 — Secret-Scanning & History Hygiene"
status: accepted   # base ADR + A1 accepted; A2 accepted 2026-08-19 (R3-pivot gate); Amendments A3 (corrects A2 §5) + A4 (extends A3 — population + resolution order) + A5 (extends A2 §4 + A4 §3 — the induced positive must be able to fail) ACCEPTED 2026-08-23 (ratification-packet gate). ⭐ A3→A4→A5 is a strict citation chain and was ratified as a chain, in order — a suffix ratification would have left a binding clause citing a `proposed` one (F-F37's class). ⚠ The operative hook-adjudication rule now spans base + A2 + A3 + A4 + A5; a NON-NORMATIVE consolidated reading is owed (backlog pointer, `how/backlog/idea_adr011_operative_rule_consolidation.md`) — a reading, never an edit to ratified text. ⛔ **Amendment A6 PROPOSED 2026-08-23 (extends A5 §4 — a content check tests for the fix's mechanism, never the defect's name) — awaits operator §7.7.** Occasioned by Galileo, delivered MINUTES AFTER A5 was ratified: A5 §4 named the wrong mechanism, and the strict predicate it implies is non-discriminating (1·1·1) — so A5 §4 followed literally would certify a useless test. A5's ratified text is NOT edited.
created: 2026-06-20
updated: 2026-08-21
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

## Amendment A3 — Conformance is behavioural; the roster is the instrument (corrects A2 §5) — **proposed 2026-08-19**

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

## Amendment A4 — The population is the denominator; the resolution order is binding (extends A3) — **proposed 2026-08-20**

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

## Amendment A5 — The induced positive must be able to fail; reading and repairing take different paths (extends A2 §4, A4 §3) — **proposed 2026-08-21**

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

## Amendment A6 — A content check tests for the fix's mechanism, never the defect's name (extends A5 §4) — **proposed 2026-08-23**

*Occasioned by **Galileo** (`Jupyter.aDNA`, `candid_plumbline`, 2026-08-23), replying to our F-P7b-f memo. They did not take our retraction on our word — they re-measured — and **the re-measurement moved the clause**. Their receipt arrived via our own `probe_peer_state.sh --exec` at `2026-08-24T04:05Z`, **minutes after A5 was ratified**. ⛔ **A5's ratified text is not edited** — A6 extends §4. Every number below re-measured at our own object before ruling. Ratification: **decision** = A6 as written · **ratified-by** = *(pending — operator §7.7)* · **date** = *(pending)* · **status** = `proposed`.*

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

## Consequences
- (A6) ⚠ **`probe_peer_state.sh`'s header carries F-P7b-f as *"grepping a string that appears in that hook's OWN COMMENT BLOCK"* — right, and Galileo's measurement shows it is *half*.** The instrument itself is unaffected (`declared_collision` reads declarations positionally, and digest-based adjudication in `census_secret_gate.sh` is immune **by construction**), but the header's stated rationale is incomplete and is owed an update.
- (A6) ⛔ **Our shipped v2 hook documents an install line that assumes a pre-ADR-045 layout** — `how/federation/git/hooks/pre-push.gitleaks.sh:15`, `ln -sf ../../git/hooks/… .git/hooks/pre-push`, which resolves to `<root>/git/hooks/` and therefore only works where a root `git/` shim exists. **`ln -sf` succeeds against a non-existent target, git silently skips a hook it cannot execute, and the repo reads *installed* while being *ungated*** — no error at install time, none at push time. **Absence indistinguishable from health**, the same family as A4 §4's `[ -d .git ]`. Fix per **our own A5 §3**: derive the target from `git rev-parse --path-format=absolute --git-common-dir`, and have `--self-test` assert `.git/hooks/pre-push` resolves to an **existing executable** (today it probes the engine only and would pass on a dangling install). **Not fixed here** — it edits a shipped artifact and is its own gated act.
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
