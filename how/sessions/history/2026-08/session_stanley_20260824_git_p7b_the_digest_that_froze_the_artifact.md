---
type: session
session_id: session_stanley_20260824_git_p7b_the_digest_that_froze_the_artifact
date: 2026-08-24        # nineteenth sitting (FIFTH on this local date). Act timestamps UTC.
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — take F-P7b-p's exit: a digest recorded as ratified evidence froze a shipped artifact, and the binding table cannot classify the hook we ship"
door: "§1 open sweep + lease · §2 ADR-011 A7 (append-only, stamp) · §3 hook 2.1.1 + the stale-blocker fix · §4 ledger 0.2.1 + census closure · §5 memos authored · §6 probe-gated delivery · §7 verify · §8 close"
plan: please-read-the-claude-md-mutable-wind
head_at_open: 57c4e7e
head_at_close: see_tracking_commit
inbound_at_open: 0      # `git status --porcelain -uall` empty at open. Recorded as MEASURED, not assumed.
inbound_at_close: 0     # ✅ SWEPT AT CLOSE, MEASURED. All 3 files in who/coordination/ are ours (2 authored here, 1 modified here). ⛔ BUT SEE F-P7b-q: this reading cannot distinguish "nobody wrote" from "everyone was refused by our own live lease" — Forgejo.aDNA/STATE.md:2070 records exactly such a refusal against this session at 15:50. The number is honest; the reassuring reading of it is not.
leases_at_open: "ours 0 (`how/sessions/active/` held only .gitkeep before this file). Peer leases NOT probed at open — this sitting DOES send, and the probe is taken AT each act, in the same command as the copy (`--exec`). An open-sweep peer reading would be provisional by the time it was relied upon, and the previous sitting proved that live: aDNALabs held 0 leases at planning and 1 at the act."
outward: true           # 3 declared memo drops, each gated by `probe_peer_state.sh --exec`. NOTHING else.
crash_recovery: "The eighteenth sitting crashed after its work commit. Verified rather than assumed that the vault was intact: `57c4e7e` carries STATE + CHANGELOG + the session file already in history/2026-08/, active/ held only .gitkeep, `git status --porcelain -uall` empty. The crash cost the conversation, not the vault."
operator_rulings:
  - "F-P7b-p exit = A′ — the ADR stops carrying exact md5s as ratified evidence and keys its binding table on ROLE; `wrapper_contract_releases.md` becomes the dated digest of record; the INSTRUMENT deliberately keeps exact digests. Exits A (re-pin), B (role-key both censuses) and C (carry) were all offered and declined. (AskUserQuestion, plan gate)"
  - "outward window = OPEN, for memo drops only. Route the `0.2.0` remedy to Hestia + Berthier; retry Pythia's owed cc only on a probe GO."
  - "scope = KEEP IT TIGHT — the exit and the routing. No backfills, no consolidation reading, no census mechanism port."
  - "ADR-011 Amendment A7 = RATIFY at this gate. §7.7 exercised — the plan carried A7's five clauses and their reasoning in full, and offered an explicit `hold A7 as proposed` escape that was NOT taken."
signature_basis: "§7.7 on ADR-011 A7: plan-gate approval, primary account, in-session, against a plan document that carried A7's five clauses, the finding that occasioned them, and clause 5's statement that NO blocking gate is wired to A7 — all before approval. ⚠ This is a PLAN-GATE ACCEPTANCE OF A RECOMMENDATION, not a per-clause reply to a ratification packet; recorded so a later reader sees which of the two happened rather than inferring it. ⭐ The plan stated in terms that declining A7 still cut 2.1.1, still fixed the false universal, and still routed the remedy — i.e. the escape cost nothing — and it was not taken. An offered refusal declined is a stronger basis than silence. NOT transcribed status; NOT held on a peer's receipt."

# ⛔ CORRECTION TO THE APPROVED PLAN'S OWN PREMISE, made at §1 before any edit.
plan_premise_corrected_at_open: |
  The plan asserted the UNCLASSIFIED gap was "latent today (no vault has installed 2.1.0)".
  ⛔ FALSE, and measured false at the opening baseline: `census_secret_gate.sh` reports
  `WGS.aDNA  git-path  present  04e6a745  PASS  x  symlink` — 2.1.0 IS INSTALLED AND LIVE.
  ⇒ the divergence is LIVE, not prospective: WGS's hook adjudicates PASS by the instrument
  (`census_secret_gate.sh:71` carries the row) and UNCLASSIFIED→FAIL by the BINDING table
  (A3 §1 + A4 §2 have no row for it). One vault in the fleet is classified two ways right now.
  ⭐ And it is WGS — the vault that wrote the install-surface repair before we did. Adopting our
  own shipped fix is what made them the single vault the ratified table cannot classify.
  ⇒ A7 clause 3 discharges a CURRENT misclassification, not a future one. The case is stronger
  than the one the operator approved, never weaker, so the ruling stands unchanged — but the
  premise is corrected in the record rather than quietly improved.

baseline_at_open:
  dryrun_gitops: "93 passed, 0 failed"
  census_wrapper_copy_meta: "PASS — every class fails when it should, every control passes"
  probe_peer_state_meta: "every check reached its failure state; controls passed; --exec gates both ways"
  census_secret_gate: "68 PASS_EQUIV · 38 FAIL_NONE · 9 FAIL_NOOP · 8 PASS · 2 FAIL_LEGACY_SANITIZE · 1 PASS_STRONGER · 0 UNCLASSIFIED · 0 dangling"
  census_secret_gate_note: "⚠ `secret_gate_census.md`'s table records PASS=1 (dated 2026-08-21). It is now 8 — seven further skeleton-v2 installs landed in the interval, one of them at 2.1.0. The doc is a DATED reading and is not edited here; the delta is recorded because a stale count read as current is this vault's most-repeated defect class."

declared_files:
  - what/decisions/adr_011_secret_scanning.md          # §2 — A7 APPENDED. No ratified clause edited; A3/A4/A5/A6 md5-identical before and after.
  - how/federation/git/hooks/pre-push.gitleaks.sh      # §3 — 2.1.0 -> 2.1.1: version marker, history stanza, and the false 44/44 replaced. COMMENTS ONLY.
  - how/tests/census_secret_gate.sh                    # §3/§4 — the stale "A6 proposed, NOT ratified" note + the 2.1.1 digest row
  - what/inventory/wrapper_contract_releases.md        # §4 — the 0.2.1 row; this file becomes the digest of record under A7 §2
  - what/inventory/secret_gate_census.md               # §4 — F-P7b-p recorded CLOSED via A7, three-exit table retained as the reasoning taken
  - who/coordination/                                  # §5 — 3 memos authored
  - STATE.md                                           # §8
  - CHANGELOG.md                                       # §8
declared_peer_writes:
  - "Home.aDNA/who/coordination/        — the hold-has-an-exit memo (Hestia)"
  - "aDNALabs.aDNA/who/coordination/    — the same memo (Berthier)"
  - "Jupyter.aDNA/who/coordination/     — A7 ratified (Galileo, who occasioned A6)"
  - "Inference.aDNA/who/coordination/   — the owed ADR-014 cc (Pythia). REFUSED TWICE ALREADY; a third refusal is recorded, not routed around."
out_of_scope:
  - "⛔ any push, forge call, repo creation, visibility flip, or mirror configuration. The ONLY outward acts are the 4 declared memo drops, each through `probe_peer_state.sh --exec`."
  - "⛔ editing any RATIFIED clause of ADR-011. A7 is APPENDED. A3/A4/A5/A6 and the base D1–D6 are untouched, and this is verified by md5 before and after — the chain's own discipline, stated by every prior amendment."
  - "⛔ porting the mechanism split into `census_secret_gate.sh`. A6's ratification unblocked it and the instrument's own comment says so; it is a behaviour change to the fleet's measuring instrument and is ITS OWN PASS. Filed to the register, not done here."
  - "⛔ re-running the both-arms induced positive against a remote. 2.1.1 is comment-only; the stripped-comment diff is RUN and required to be empty, and the inheritance is recorded as a dated decision. If that diff is non-empty the inheritance is VOID and the full induced positive is required before the row is cut."
  - "⛔ correcting `secret_gate_census.md`'s PASS=1 to PASS=8. It is a dated reading; a historical measurement is falsified, not improved, by editing it. The delta is recorded in this lease and in the closure note."
  - "⛔ the 35 consumer wrapper-refresh acts (Rule 10) — theirs. This sitting routes the remedy; it does not perform them."
  - "⛔ intake-log + CHANGELOG backfills, the seven-layer consolidation reading, shape B, obj 5, the fleet host-move wave. Operator ruled KEEP IT TIGHT."
  - "⛔ any `.adna/` edit (Standing Rule 1)."
  - "⛔ wiring any blocking gate to A7 — clause 5 forbids it, for the reason ADR-004 A1 §5 records and ADR-013 A1's Consequences paid for."
---

# Session — The Digest That Froze The Artifact

## §1 — Open sweep (complete)

| Reading | Value |
|---|---|
| HEAD | `57c4e7e`, clean |
| Inbound | **0**, measured (`git status --porcelain -uall` empty) |
| Our leases | 0 before this file |
| Peer leases | deliberately unprobed at open — taken at each act via `--exec` |
| Crash residue | **none** — session file already in history, STATE + CHANGELOG committed |

Baselines and the corrected plan premise are in the frontmatter above.

## Running log

- **§1** open sweep + lease. ⛔ The approved plan's "latent" premise measured **false** at baseline —
  `WGS.aDNA` is live on `04e6a745`. Corrected in frontmatter before any edit.
- **§2** ADR-011 **A7** appended + stamped. All 7 ratified sections md5-identical; only 2 deletions, both frontmatter.
- **§3** hook **2.1.1** cut. Comment-stripped diff **empty** (`ac446005…` both sides) ⇒ inherited induced positive licensed.
- **§4** ledger **`0.2.1`** + F-P7b-p closed. Two further regressions caught mid-cut (see findings).
- **§5–6** 3 memos; **2 delivered** (aDNALabs, Jupyter), **2 refused** (Home, Inference) — both refusals recorded with probe output.
- **§7** verification: dryrun **94/0**, both meta-controls PASS, census tally **unchanged**, preflight **7/1-BLOCK** (own tree).

---

# SITREP — close

## What this sitting did

| | |
|---|---|
| **ADR-011 A7** | `accepted` — *a digest is a name, not a verdict*. Appended; **all 7 ratified sections md5-identical**, only 2 deletions and both frontmatter. |
| **Hook `2.1.1`** | false universal removed; stale A6 blocker note in `census_secret_gate.sh` corrected. md5 `04e6a745…` → `169eec6a…`. |
| **Ledger `0.2.1`** | cut, pinned at `57c4e7e` (read from `git rev-parse`, not transcribed). This file is now the **digest of record** under A7 §2. |
| **F-P7b-p** | **CLOSED** via exit `A′`. |
| **Deliveries** | 2 of 4 landed, byte-identical, untracked peer-side. 2 refused **correctly** and recorded with evidence. |

## Findings

### ⛔⛔ F-P7b-q — our own lease refuses our own inbound, and "0 inbound" cannot tell silence from refusal

Found **incidentally**, during the outward-acts audit, in *Ilmarinen's* records rather than ours.
`Forgejo.aDNA/STATE.md:2070` records that their send to this vault was refused at **15:50** because
**this session's lease — opened 15:48 — was live.** They log it as the **FOURTH consecutive sitting**
a Git leg has been blocked, and have routed it as a convention question (a drop-box).

⛩ **The symmetry is the finding.** We refuse to write into a peer holding a lease; a peer refuses to
write into us holding a lease. Both correct. But **we hold a lease for the entire duration of every
sitting**, so *any* peer attempting to reach us while we work is refused by construction.

⭐ **And it retro-reads our own records.** STATE has logged **"0 inbound — MEASURED, not assumed"** for
several consecutive sittings, treated as a clean signal. The measurement is honest and the inference is
not: *`git status` on our own `who/coordination/` cannot distinguish **nobody wrote** from **everybody
was turned away at the door**.* Same shape as the `44/44` defect closed this sitting — a true reading
used to license a conclusion it does not establish — **found in our own bookkeeping, on the same day,
by a third party's log.**

⚠ Not routed around: their memo is **staged on their desk**, not delivered, and I did not read it.
Filed for the convention question they have already opened.

### ⛔⛔ Three instances of one defect, and the bump is what revealed all three

| # | Where | Keyed on | Consequence |
|---|---|---|---|
| 1 | ADR-011's **binding table** (A3 §1 + A4 §2) | exact digests | no row for `04e6a745…` ⇒ `UNCLASSIFIED`→FAIL. **Live**: `WGS.aDNA` runs it, adjudicated PASS by instrument and FAIL by rule. |
| 2 | `census_wrapper_copy.sh` | enumerated `2.1.0)` | a `2.1.1` copy → `FAIL_UNCLASSIFIED` ⇒ **every correct refresh would have verified as a failure.** ⭐ Inside A7's own cited exemplar, one line after the mechanism had already been measured. |
| 3 | `dryrun_gitops.sh` | the digest whose **comment** said `v2.1.0` | went red at the cut. ⛔ **A5 §4 verbatim** — a predicate matching a hook's own documentation. Now *runs* the adjudicator, with a meta-control. |

⭐ **The rule**: an identity-keyed check is green for exactly as long as nothing changes, and *the bump
is the only event that exposes it.* **A check that has never seen a version change has not been tested;
it has been unexercised.**

### ⚠ Against myself — I fabricated a SHA and caught it in the same minute

Writing the ledger frontmatter I typed a plausible 40-hex `pinned_at_commit` **from nothing**, then
replaced it with `git rev-parse`'s answer. ⭐ *A fabricated identifier is the exact failure this vault
spends its sittings hunting, and it is trivially avoidable by reading instead of composing.* Recorded
because a self-caught error that goes unrecorded teaches nobody.

## Verification

dry-run **94/0** (93→94; the replaced check became two, and **discrimination proven**: sabotage the hook
by one comment character ⇒ that row alone goes red, meta-control holds, restore ⇒ 94/0) ·
`census_wrapper_copy --meta` **10 checks PASS** (fixture **E2** added; **regression proof: restore the
enumerated table ⇒ E2 red and nothing else**) · `probe --meta` green, `--exec` gates both ways ·
`census_secret_gate` **68/38/9/8/2/1 — UNCHANGED, 0 UNCLASSIFIED**, and the new row proven load-bearing
(`169eec6a…` reads UNCLASSIFIED *before* it, PASS after; an invented digest still UNCLASSIFIED) ·
comment-stripped diff **empty** · `--self-test` green · `preflight` **7 PASS / 1 BLOCK**, the BLOCK being
`clean_tree` on this sitting's own 13 declared paths — correct trip-gate behaviour · **close-end inbound
0, MEASURED** (all 3 files in `who/coordination/` are ours-authored) · **outward acts: exactly 2 files,
attributed by name — no push, no forge call, no repo created, no visibility flip.**

## Next session

1. ⛔ **F-P7b-q** — the drop-box convention. Ilmarinen has opened it; our lease is half the mechanism.
2. **Home delivery outstanding** — the hold-has-an-exit memo reached Berthier, not Hestia. Retry when her lease clears.
3. ⛔ **Pythia's cc — third refusal, same cause.** `Inference.aDNA` has no `how/sessions/active/`; the delivery cannot succeed until it exists, and that is hers. Needs a different channel, not a fourth identical retry.
4. **`census_secret_gate.sh` mechanism port** — unblocked by A6/A7, deliberately deferred by A7 §5. Its own gated pass.
5. Berthier's re-keying + Hestia's registry amendment · the P7a flip (every precondition another lane's) · the seven-layer consolidation reading (now **eight** with A7) · shape B / obj 5 · intake-log + CHANGELOG backfills.
