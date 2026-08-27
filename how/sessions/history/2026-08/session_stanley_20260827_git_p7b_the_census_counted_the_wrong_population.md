---
type: session
session_id: session_stanley_20260827_git_p7b_the_census_counted_the_wrong_population
date: 2026-08-27        # twenty-fifth sitting (FIRST on this local date). Act timestamps UTC.
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — a peer corrected our census before it ratified, and the population was wider than the correction"
door: "§1 open sweep · §2 intake 1 inbound · §3 census re-derived over the enumerated population · §4 ADR-016 rev 2 (correction, struck visible) · §5 consequence check on D4 · §6 reply memo + staged-delivery retry · §7 verify · §8 close"
plan: please-read-the-claude-md-polished-ritchie
head_at_open: 88e03a0
head_at_close: see tracking commit (this sitting)
outward_acts_measured: 2   # both memo placements into Forgejo.aDNA/who/coordination/, each probe-gated via --exec; fleet-wide find confirms nothing placed elsewhere
token_budget_estimated: ~160k
inbound_at_open: "1 — MEASURED with `git ls-files --others --exclude-standard`, not `git status` (F-DF-145). Ilmarinen/`Forgejo` — our ADR-016 census carries a false zero and an omission: `aDNA.aDNA` measures 1 (not 0; its default branch is `main`), `Canvas.aDNA` measures 2 and was absent from the table entirely. ack_required: false, but time-sensitive against a `proposed` ADR."
inbound_at_close: "0 NEW — re-swept at the close end with `git ls-files --others --exclude-standard`. The 5 untracked paths are this sitting's own products (4) plus the 1 inbound already dispositioned."
leases_at_open: "ours 0 (`how/sessions/active/` held only .gitkeep before this file). Peer leases NOT read at open — the send is gated by the probe at send time, and a stale open-time reading is exactly what PASS_INFERRED exists to make visible."
outward: partial        # DECLARED: ILMARINEN ONLY. NO push, NO forge write-call, NO repo created, NO visibility flip, NO .adna/ edit. Anonymous read-only clones/API GETs are measurements, not acts.
crash_recovery: "The twenty-fourth sitting crashed after its close commit. VERIFIED, not assumed — SEVENTH consecutive sitting to open this way: `88e03a0` is a session-close commit carrying STATE + CHANGELOG + the session file; `how/sessions/active/` held only `.gitkeep`; tree clean but for the one untracked inbound."

operator_rulings:
  - "scope = census re-derivation AND the ADR-016 correction, nothing further. Two wider scopes were offered and DECLINED: (+) the dispatch-side probe drop-box repair, and (+) the `.adna/` self-test sweep that F-P7b-z's wider question opens."
  - "remedy on the false census = CORRECT IN PLACE, ERROR STRUCK VISIBLE. Two alternatives offered and NOT taken: a clean rewrite to rev 2 with no strikethrough, and leaving rev 1 intact with a separate erratum memo. The operator ratifies at §7.7 seeing what was wrong, not a document that never was."
  - "outward lane = ILMARINEN ONLY. The Berthier Codeberg 19/19 delivery was offered and DECLINED for a FOURTH sitting; it remains the oldest open delivery on this desk."

declared_paths:
  - who/coordination/coord_2026_08_26_ilmarinen_to_hopper_your_census_has_two_false_zeros.md   # intake
  - what/decisions/adr_016_publication_boundary.md                                             # rev 2 — census corrected
  - who/coordination/coord_2026_08_27_hopper_to_ilmarinen_*.md                                 # NEW — reply
  - STATE.md · CHANGELOG.md · this session file

tags: [session, git, p7b, operation_free_harbor, adr_016, f_f78, census, false_zero,
  population_defect, wrong_population, enumerate_dont_roster, unfalsified_zero,
  redacted_reporting, struck_not_rewritten, seventh_crash_open]
---

# Session — the census counted the wrong population

> ⛔ **No literal address in this file.** It is committed to a repo that publishes. `<forge-overlay-addr>`
> throughout, per [[adr_016_publication_boundary|ADR-016]]'s own demonstration discipline.

## §1 — Open sweep (crash-open, VERIFIED)

| check | instrument | result |
|---|---|---|
| HEAD | `git log -1` | `88e03a0` — a **session-close** commit (STATE + CHANGELOG + session file) |
| our lease | `find how/sessions/active -type f` | **0** (only `.gitkeep`) |
| tree | `git status --porcelain` | clean but for 1 untracked inbound |
| intake | `git ls-files --others --exclude-standard` (F-DF-145) | **1** |

⇒ **seventh consecutive crash-open**, verified rather than assumed.

## §2 — Intake

**1 inbound**: `coord_2026_08_26_ilmarinen_to_hopper_your_census_has_two_false_zeros.md`.
`ack_required: false`, **nothing owed** — but time-sensitive: it corrects a census inside an ADR
that is `proposed` and awaiting operator §7.7.

Disposition: **accepted, verified at source, and extended** — see §3.

## §3 — Census, re-derived over an ENUMERATED population

Instrument: `census_public_carriers.sh` (scratchpad — not a vault artifact this sitting; **owed** as
one). Anonymous throughout, because anonymity is not a convenience here — **it is the publicness
test**. Three predicates reported separately because they are not the same question:

| repo | branch | address (host) | host**:port** | RFC1918 class (= R8's own) |
|---|---|---|---|---|
| `Git.aDNA` | `master` | **57 / 17** | **31 / 13** ✅ known-good | **62 / 20** |
| `aDNA.aDNA` | `main` | **1 / 1** | 0 | 15 / 9 |
| `Canvas.aDNA` | `master` | **2 / 2** | 0 | 11 / 8 |
| `III.aDNA` · `aDNA` · `adna-legacy` | `main` | 0 | 0 | 2 · 1 · 1 |
| `community-policies` · `spacemacs` · `world-genome` | — | 0 | 0 | 0 |

⭐ **Ilmarinen's three rows reproduce EXACTLY, down to the file paths.** Zero divergence.

⭐ **And the population is 9, not his 3 and not our 7.** Six repos were measured by neither desk.

### Root causes — two, and the obvious one is FALSIFIED

1. ⚠ **Branch mismatch — FALSIFIED, recorded because it was wrong.** The plan's leading hypothesis.
   `aDNA.aDNA` has only `main`, `Canvas.aDNA` only `master` ⇒ a mis-branched query **errors**, it does
   not return a quiet zero. Not the `\b`-grep class recurring.
2. ⛔ **Predicate narrowing.** We measured `host:port` — literally the row header in ADR-016 §Context —
   and wrote the conclusion as *"carries the address."* Both other repos carry the **bare host, no
   port** ⇒ **their 0 was arithmetically correct.** The number was right; the sentence was not.
   Nastier than a bad query: a bad query leaves residue, this left none.
3. ⛔ **Wrong population.** The set was the destination roster of 7 inbound memos. `Canvas` was not
   mismeasured — **never in the set.** Better measuring cannot fix this.

### ⛔ F-P7b-ad(iii) — the ADR's number is not its gate's number

§Context reports 31 (instance:port); R8 ships a **class** predicate ⇒ **62/20 here, 6 repos
fleet-wide**. A reader cannot predict what the gate does from the figures in the ADR that ships it —
and the allowlist we intended to scope to 31 would not have covered it. → ADR-016 §C3.

### ⚠ Codeberg = UNKNOWN, not 0 — and the endpoint hides the difference

`orgs/aDNA-Network` → **404 `HasOrgOrUserVisible`**; `orgs/aDNA-Network/repos` → **HTTP 200, empty
array**. Control org returns 5, so the instrument works — the *org invisibility* is what makes
empty-because-none and empty-because-invisible identical. Recorded **UNKNOWN**. → **D6.4**.

⭐ **Fourth instance in two sittings, across both desks, of a reassuring answer from an instrument
without the authority to answer**: his suite's clean `114 passed` on a mutation that never applied ·
our `\b` grep · our roster · this. Neither desk has an instrument that reports *"I was not in a
position to know."*

### ⚠ Three malformed queries inside THIS sitting, all caught by mismatch not by design

`ls -t <dir>` (shell aliases `ls`→`eza`; `-t` ate the directory) read as *"no August sessions
exist"* — `find` shows 10+, all committed · `grep -f ../pat/…` wrong relative path → empty file list
against non-zero counts · `for f in $FILES` (zsh does not word-split) → both paths as one filename.
⛩ **All three failed loudly enough to catch. None was caught by a control.**

## §4 — ADR-016 rev 2

`revision: 1→2`, `updated: 2026-08-27`, **status stays `proposed`** — this sitting ratifies nothing.

- §Context finding #1 **STRUCK IN PLACE**, not rewritten (operator ruling; precedent `793a7aa`).
- **§Correction (rev 2)** added: C1 corrected census · C2 both root causes incl. the falsified one ·
  C3 the ADR-vs-gate predicate mismatch · C4 what survives (his narrower claim; the `adna-legacy`
  fork negative result; the Codeberg vantage) · C5 the consequence.
- **§Ratification** now states **what changed between rev 1 and rev 2**, so the operator signs
  knowing it, and names the two items *downstream* of the signature (R8 allowlist sizing, D6.5
  notifications).

## §5 — Consequence check on D4 — ruled, not left implicit

**D1–D5 stand.** The doctrine gap never depended on the count. But *"the remedy is this vault's
alone"* is **false**, and it was load-bearing:

- **D4** now binds **three graphs**, not one.
- **D2.4** is **strengthened**: authored against one quoting graph, the census shows three.

⇒ **D6 ADDED** (D6.1 each carrier owns its remedy · D6.2 enumerate, never roster · D6.3 a result is
cited only for the question its predicate asked · **D6.4 a zero must be falsified before recording;
`200`+empty ≠ empty population; absent a control the verdict is `UNKNOWN`** · D6.5 notify with the
measurement attached). Added rather than inferred, because an inference left implicit is what goes
unread at a ratification gate.

## §6 — Reply + delivery — 2 DELIVERED, 2 STAGED

**Delivered to Ilmarinen** (probe-gated `--exec`, GO both; fleet-wide `find` = `Forgejo.aDNA` only):
the reply, and **the memo held one sitting** by last sitting's correct BLOCK. ⭐ His §6 said his
surface was quiet; we **re-measured rather than adopted** — `writedir_dirty` **PASS**, and
`active_leases` returned the new **`PASS~`** on precisely the vault that repair was built for.

⚠ **First BLOCK was our own invocation error** — `--self` omitted (F-DF-215 refusing to guess whose
mailbox to measure). The instrument was right; the operator was wrong.

**Staged, NOT sent** (lane = Ilmarinen only): Rosetta (`aDNA.aDNA` 1×) and Mondrian (`Canvas.aDNA`
2×, one of them **inbound mail from Vulcan** — the live D2.4 case). Owed under D6.5.

### ⛔ F-P7b-ad — our send has no send tool, and it showed twice

(i) **Redaction verified AFTER the `cp`, not before.** Clean (0/0) **by authorship, not by control**.
Ilmarinen's `send_memo.sh` **STEP 3b** does exactly this *before* the `cp`; we have no send path at
all, only a hand-assembled `cp` behind a probe.
(ii) **The stamp lands after the send**, so both copies in his vault carry `status: staged`.
Re-delivering the stamped version was attempted and **CORRECTLY REFUSED** on `dest_collision`
(no-overwrite). ⛩ **Drift recorded, not forced** — the probe was right and we did not work around it.

### ⛔ F-P7b-ac — filed, NOT fixed

His §6: his drop-box at `who/coordination/inbox/` was open the whole time our probe refused last
sitting. **Our probe has no notion of a peer drop-box** — it reads the write-dir, finds it dirty, and
refuses beside an open lane built for that exact condition. His **F-F38 from the other side**. The
repair was offered at this sitting's scope gate and **declined**; open, owed, dated.

## §7 — Verification

| # | check | result |
|---|---|---|
| 1 | census reproduces known-good | `Git.aDNA` host:port = **31 / 13** ✅ |
| 2 | zero-falsification | every `0` recorded only against a live control; Codeberg → **UNKNOWN**, not 0 |
| 3 | branch assertion | **9/9 `REF_OK`** — cloned ref == API `default_branch`, asserted per repo |
| 4 | redaction | ADR + session + all 3 new memos: **A_HOST 0, B_CLASS 0**, against a control proving the predicate live (`STATE.md` = 3) |
| 5 | divergence vs Ilmarinen | **zero**, including file paths |
| 6 | delivery | 2× GO, `--exec exit 0`, md5 parity at send; fleet-wide `find` = `Forgejo.aDNA` only; the 2 staged memos confirmed **still in `Git.aDNA` only** |
| 7 | exit codes read directly | captured to a variable, never through a pipe or `$(…)` argument (F-P7b-ab) |
| 8 | probe meta-control | **exit 0**, every check reached its failure state, `--exec` gates both ways |
| 9 | close-end intake | **0 NEW** — the 5 untracked are this sitting's 4 products + the dispositioned inbound |

**ZERO pushes · ZERO forge write-calls · ZERO visibility flips · ZERO `.adna/` edits · R8 still
UNINSTALLED.** Outward acts: **2**, both memo placements into `Forgejo.aDNA`, both probe-gated.

## §8 — SITREP

⭐⭐ **A peer corrected our census before it ratified, and the population was wider than the
correction.** Three public carriers, not one — his figures reproduce exactly — but the census was
built on a **roster of correspondents rather than an enumeration of public repos**, and the
conclusion cited a `host:port` measurement for an *address* claim. ⛩ **The number was right and the
sentence it supported was not**, which is the failure mode that leaves nothing for a reviewer to
catch. Our own exposure is **57/17**, not the 31/13 both desks had been quoting.

⛔ **And the ADR's number is not its own gate's number** — R8 ships a class predicate that matches
**62/20 here and six public repos**, so an allowlist scoped to 31 would not have covered what the
gate stops.

**Next**: **(a)** ADR-016 §7.7 ratification at **rev 2** — then the R8 allowlist, now correctly sized
to 62 rather than 31; **(b)** the two D6.5 notifications (Rosetta · Mondrian), staged; **(c)**
⛔ Berthier's Codeberg 19/19, unsent a **fourth** sitting and the oldest open delivery; **(d)**
F-P7b-ac probe drop-box repair; **(e)** F-P7b-ad — a real send path, with the redaction check and the
stamp both *before* the `cp`; **(f)** promote the census script to a vault instrument; **(g)** upstream
hook 4.1.0 to Rosetta; **(h)** F-P7b-z's wider question — what else in `.adna/` self-tests by
reimplementation; **(i)** obj 5; **(j)** the fleet host-move wave; **(k)** intake-log + CHANGELOG backfills.
