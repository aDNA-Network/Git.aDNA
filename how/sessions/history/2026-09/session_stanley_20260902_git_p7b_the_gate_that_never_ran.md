---
type: session
session_id: session_stanley_20260902_git_p7b_the_gate_that_never_ran
date: 2026-09-02        # twenty-ninth sitting. Act timestamps UTC.
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — the two stamps owed, and the gate that has never run"
door: "§1 open sweep + intake 2 inbound · §2 ratification records (A6 rev 2 + ADR-017) · §3 R8 re-scoped to D4 + 4.2.0 · §4 deny-file header · §5 chained install · §6 verify at the real entry point · §7 3 memos · §8 verify + close"
plan: please-give-your-advice-idempotent-wilkinson
head_at_open: 74b4ab5
head_at_close: this close commit
outward_acts_planned: 3   # memos: Inference.aDNA (Pythia) · aDNA.aDNA (Rosetta) ×2
token_budget_estimated: ~200k

date_correction: "⚠ The plan was authored 2026-08-31 and dated every act to it. The local date at
  first act is 2026-09-02. Ratification dates are BINDING RECORD, so both §7.7 stamps, the session
  id, and the history directory take 2026-09-02. Corrected before the first edit, not after."

inbound_at_open: "2 — MEASURED with `git ls-files --others --exclude-standard` (F-DF-145), not
  `git status`. ⛩ BOTH ARRIVED BETWEEN THE PLAN GATE AND THE FIRST ACT — F-P7b-ae paying out for a
  THIRD consecutive sitting, and for the second time the memo lands on the exact clause the sitting
  was opened to stamp.
  (1) Rosetta/`aDNA.aDNA` → `who/coordination/inbox/`. ACK on the 08-27 boundary memo,
  `ack_required: false`, nothing owed. Their redaction reached `origin/main` at `0362a00` on
  2026-09-02 ⇒ the fleet's `aDNA.aDNA` public count is now **0**, not 1. ⭐ Their own supersession
  condition fired at delivery and was corrected before sending rather than arriving stale — our
  clause doing its job in a peer's hands.
  (2) Ilmarinen/`Forgejo.aDNA` → `who/coordination/`. `ack_required: false`, but NOT disposable:
  §1 states the mapping A6 §5.1 assigned him, and the stated predicate is **not a refinement of
  §2's row — it is an inversion on one axis**. See F-P7b-aq below. Also carries F-F97 (a withdrawal
  whose zero was taken over an empty population, and whose two corroborating vantages both read the
  wrong column — *two vantages corroborate only if they are capable of disagreeing*), F-F98, and
  §4: he routes the T3 contest to the operator **un-adjudicated**, holds no forge-side fact bearing
  on it, and confirms the Pythia routing is ours or the operator's, not his."

leases_at_open: "ours 0 (`how/sessions/active/` held only .gitkeep before this file). Peer leases
  NOT read at open — the probe measures at the act (F-P7b-i)."

outward: partial   # EXECUTED: 3 memo placements, each probe-gated GO.
                   # NO push, NO forge write-call, NO has_actions PATCH, NO graduation,
                   # NO visibility flip, NO .adna/ edit.

crash_recovery: "The twenty-eighth sitting closed cleanly (`74b4ab5`, a session-close commit);
  `how/sessions/active/` held only `.gitkeep` at open; tree clean but for the 2 untracked inbound.
  ELEVENTH consecutive sitting to open on a clean-or-crash check; this one is clean."

operator_rulings:
  - "A6 rev 2 = RATIFY AS WRITTEN, CONTEST ACCEPTED. T3 withdrawn; exactly two triggers;
    `Inference.aDNA` is not a graduation candidate and the cure is a declaration, Pythia's act.
    Three alternatives offered and DECLINED: ratify but overrule §4; ratify §1/§2/§3/§5 and hold
    §4; hold A6 entirely.
    ⛔ RULED AT 2026-09-02 GATE, BEFORE THE ILMARINEN MEMO WAS READ. Re-opened by F-P7b-aq."
  - "ADR-017 = RATIFY AS WRITTEN. Two alternatives offered and DECLINED: ratify and wire the
    heading-vs-block check now; hold. The named enforcement gap stays named, per its own
    Consequences. ⭐ Unaffected by F-P7b-aq — ADR-017 governs ratification RECORDS, not A6's
    substance."
  - "Sitting work = RE-DERIVE, THEN INSTALL R8 CHAINED. Three declined: re-derive only; the
    F-P7b-z sweep; records + backfills only."
  - "Outward = THREE MEMOS — Pythia (the declaration question) · Rosetta (hook 4.2.0 upstream) ·
    Rosetta (offer ADR-017). Author-and-hold declined."
  - "R8 shape = BASELINE-SCOPED, the gate checks ADDED LINES ONLY. Three declined: file-scoped
    dated allowlist; 70 per-line pragma markers; install blocking and hold the push."

findings_opened: [f_p7b_aq, f_p7b_ar, f_p7b_as]
findings_closed: [f_p7b_ag]   # discharged: the hook is installed, chained, and driven
---

# Session — the gate that never ran, and a shared string that named two different states

## §1 · Open sweep

| field | value | how measured |
|---|---|---|
| HEAD at open | `74b4ab5` (a session-close commit) | `git rev-parse --short HEAD` |
| tree | clean but for 2 untracked inbound | `git status --porcelain` |
| inbound | **2** | `git ls-files --others --exclude-standard` (F-DF-145) |
| our leases | **0** | `how/sessions/active/` held only `.gitkeep` |
| peer leases | **not read** | deliberate — F-P7b-i, measured at each act |
| unpushed | **24** ahead of `origin/master` | `git rev-list --count @{u}..HEAD` |

**Eleventh consecutive clean-or-crash open; this one clean.**

⛩ **F-P7b-ae paid out for a third consecutive sitting, and again in the open window.** The plan's
own sweep, taken 2026-08-31, measured **0** inbound. Two arrived before the first act, and one of
them bears directly on the clause this sitting was convened to stamp. Both were read in full and
dispositioned by name **before** any edit.

## §2 · Running log

*(appended as acts complete)*

### §2.0 — Intake (2 inbound, both read at the object)

**Rosetta — ACK, nothing owed.** Re-derived their own count rather than accepting ours; remedy
taken under D6.1 (theirs to rule); fix-forward per our D4 with the history explicitly *not*
rewritten and said plainly. ⭐ Their memo sat staged five days and its **supersession condition
fired at delivery** — the pin we asked every peer to put on the face of a memo caught its own
staleness and was corrected before sending. Fleet effect: `aDNA.aDNA`'s public surface no longer
serves the literal, so the fleet count moves 1 → 0. **Our own 75 · 70 · 23 is unaffected** — that
is a different tree and the two must not be conflated.

**Ilmarinen — the mapping, and it inverts.** Detail in F-P7b-aq below.

---

## ⛔⛔ F-P7b-aq — A6 adopted a peer's verdict string to END a divergence, and thereby created a sharper one: the strings now agree while the predicates disagree

**Measured at both objects, 2026-09-02** — not from either memo's prose. His instrument:
`Forgejo.aDNA/what/deploy/check_replica_actions_posture.sh` `:41–43`. Ours: A6 §2 `:241–245`.

With capability held (`actions_unit=1` / (b)), `w` = workflow objects, `r` = `action_run` rows:

| `w` | `r` | his instrument | A6 §2 | |
|---|---|---|---|---|
| >0 | >0 | `REPLICA_BUILD_HOME` | `REPLICA_BUILD_HOME` | ✅ |
| **>0** | **=0** | **`REPLICA_BUILD_HOME`** | **`REPLICA_ACTIONS_ON`** | ❌ |
| **=0** | **>0** | **`REPLICA_BUILD_HOME`** | **`CLEAR`** | ❌ |
| **=0** | **=0** | **`REPLICA_ACTIONS_ON`** | **`CLEAR`** | ❌ |
| unread | any | `INDETERMINATE` | `INDETERMINATE` | ✅ |

**Three of five states disagree, and the two that agree are the trivial ones** — the all-positive
case and the unread case.

⛔ **It is not a naming collision; it is a disposition hazard**, because A6 **§3 attaches binding
acts to these strings**:

- §3 `REPLICA_ACTIONS_ON` → *"one push from firing… `has_actions=false` is PATCHed and read back
  before any further push. **This is the class where acting is cheapest.**"*
  His `REPLICA_ACTIONS_ON` is `w=0` — **Actions on with nothing to run.** Benign. The urgent
  disposition would be applied to the harmless population.
- §3 `REPLICA_BUILD_HOME` → *"T2 has fired. Its own ADR-006 D3 ceremony **or** a named exception,
  operator-ratified."*
  His `REPLICA_BUILD_HOME` includes `w>0 ∧ r=0` — **armed but never built.** A full graduation
  ceremony, or an operator-ratified exception, would be sought for a repo that has never run a
  build.

⇒ **Both errors, in opposite directions, on the clause that says where acting is cheapest.**

⭐ **The durable line: neither desk broke a rule, and the joint rule did not exist.** §5.1 explicitly
licenses his predicate to differ and rules the mapping his to state — *and he stated it, promptly and
against his own prior claim.* The clause worked exactly as written. What §5.1 did not foresee is that
**§3 turns the vocabulary into an instruction set**, and a disposition attached to a *string* is only
safe when the *predicate* is shared. This is [[what/decisions/adr_016_publication_boundary|ADR-016]]
D2.4's shape one axis over — *a boundary declared by the graph that owns the fact binds every graph
that quotes it* — with "fact" replaced by "predicate".

⛩ **And the sting is that adopting his string is what sharpened it.** Before rev 2 the two desks used
different words for overlapping states, and any reader could see there was a mapping question. After
rev 2 they use **the same words for different states**, which reads as agreement. *A vocabulary
merged without merging its predicates is worse than two vocabularies, because it stops looking like a
question.*

⚠ **Secondary limb, stated with less confidence and not leaned on.** A6 §2's `CLEAR` row is defined
on `¬(a)` alone and therefore absorbs `w=0 ∧ r>0` — a repo that **has** built and has since had its
workflows removed — and §3 gives `CLEAR` the disposition *"nothing owed."* Defensible if T2 is read
strictly forward-looking, but it means a repo with capability on and builds in its record is ruled
*nothing owed* on a row whose gloss reads *"no carriage; T2 cannot fire."* Recorded as an
observation for the operator, **not** as an established defect.

**Status: routed to the operator.** ⛔ Not self-adjudicated, and A6 **not stamped** pending the
ruling. The 2026-09-02 gate ruled *ratify as written* — but that ruling was given **before this memo
was read**, and this is the same shape the 27th→28th sitting resolved by revising before the stamp
rather than ratifying over a known defect. §7.7: authored for ratification, the operator decides.

⚖ **What is NOT in question:** T1/T2 as triggers · §4's withdrawal of T3 and its contest (Ilmarinen
confirms he holds no forge-side fact bearing on it) · §1 · §3's *shape* (act where cheap;
ceremony-or-ratified-exception where fired) · ADR-017, which is independent of all of this.

**⛩ OPERATOR RULING, 2026-09-02: REVISE TO REV 3, THEN RATIFY.** Three alternatives offered and
DECLINED: ratify as written and fix in A7; ratify §1/§2/§4 and hold §3/§5; hold A6 pending a joint
predicate reconciliation. *(Same disposition the operator reached at the 27th→28th sitting on the
same shape — revise before the stamp rather than ratify over a known defect.)*

### §2.1 — A6 rev 3, and both stamps

**Rev 3 — one substantive change plus its limb.** **§5.2 (binding)**: a disposition attaches to a
**predicate**, never to a verdict string; an instrument's output is mapped onto §2's rows before any
§3 row is applied, and where a shared string's predicate differs, **the mapping governs and the
string is discarded**. §3's opening now points at it, so a reader of the disposition table meets the
constraint there rather than five clauses away. **§2.4** narrows `CLEAR`'s gloss (limb B) — predicate
unchanged at `¬(a)`, because narrowing it would break §2's totality property.

⚖ **Nothing is asked of Ilmarinen and his instrument is not in error.** §5.1 stands **unchanged**:
the pen is his, the mapping is his, both remain correct. §5.2 binds **this ADR's own readers** — us
and the forge lane's runbook. Asking him to change a published verdict string to fit our clause is
what §5.1 declined to do, and rev 3 does not reopen it.

**Both records completed** — ADR-017 D1 (heading label · frontmatter · inline block), D3 (dated,
provenanced, digests), D4 (the inline block governs):

| artifact | site | before | after |
|---|---|---|---|
| `adr_014` | frontmatter `:5` | A6 `PROPOSED 2026-08-29, at rev 2` | `ACCEPTED 2026-09-02, at rev 3` + contest disposition |
| `adr_014` | heading `:204` | `**proposed 2026-08-29 · rev 2**` | `**accepted 2026-09-02 · rev 3**` |
| `adr_014` | inline block `:206` | `ratified-by = _pending operator_` · `_pending_` · `proposed` | operator · 2026-09-02 · `accepted`, contest **accepted** |
| `adr_017` | frontmatter `:5` | `status: proposed` | `status: accepted` + declined alternatives |
| `adr_017` | `:18` | `**Status**: `proposed`` | `**Status**: `accepted` 2026-09-02` + **a new inline block** |

⭐ **ADR-017 had no inline ratification block** — the one artifact shape its own **D4** rules
`INDETERMINATE`. Not corrected under D1 (D1 governs a *stamped* record whose label lags); the block
was written **in the stamping act**, with the operator present, which is exactly what its
§Consequences asks of every future ratification. ⛩ *The decision about completing records shipped
with an incomplete one, and the rule it was written to install is what caught it.*

**D3 evidence — append-only proved, not asserted:**

| range | digest | want | |
|---|---|---|---|
| `adr_014` A5 provenance `164..203` | `25de3e09` | `25de3e09` | ✅ **D2 — A5's note stands unedited** |
| `adr_014` D1..A5 `22..203` | `7fe74d02` | `7fe74d02` | ✅ |
| `adr_014` tail `## Consequences..end` | `eeb415f1` | `eeb415f1` | ✅ *(reproduces rev 2's recorded value)* |

Every diff hunk in `adr_014` is at **frontmatter `:5`** or **`≥204`** (inside A6, which has never been
stamped). ⚠ `D1..A5` moved from rev 2's recorded `9f92273e` **before this sitting** — the ADR-017
heading correction at `5ef17fd` touched A4's heading, which sits inside that range. Stated because a
digest that changed for a legitimate recorded reason and a digest that changed silently look
identical if nobody says which.

### §2.2 — R8 scoped to D4; hook 4.2.0 (`9aaa384`)

⛩ **The gate was not too weak to install. It was STRICTER THAN THE DOCTRINE IT ENFORCED**, and that
is why it could not be installed at all. Ratified **D4** says *"the boundary binds the next write.
The count stops growing; it does not shrink."* A whole-file scan refused pushes over lines D4 rules
must not be touched — leaving only remedies D4 forbids (rewrite) or distrusts (an exemption list).

The deny file listed three resolutions — (a) allowlist, (b) ship uninstalled, (c) weaken the
pattern. It shipped **(b)** for four sittings. ⭐ **The list was incomplete, and the missing item
needed nothing from anybody**: **(d) scope the gate to D4's own rule.** ⛔ **(a) is now forbidden**,
not merely unused (A1 §2) — a file-scoped exemption lets a *new* occurrence in an exempted file
pass, and `STATE.md` would have been on that list. **(c) stays refused; the patterns are byte-
identical** (`8694ce70`, 2 → 2).

**ADR-016 Amendment A1 authored `proposed`** — inserted whole; D1–D6 byte-identical (`3a35df11`);
one pure-insertion hunk. ⛔ **Not self-stamped.**

### §2.3 — ⛔ F-P7b-ar: the live control had no tracked source, found *because* we went to replace it

`.git/hooks/pre-push` was an **untracked** 6697-byte script whose own header named
`how/code/hooks/pre-push-secret-scan.sh` as its *"Source of record (tracked)"* — **and that
directory did not exist.** Distinct from both gitleaks copies (`f255e2a0` vs `169eec6a`), so it was
not reconstructible from them either.

⇒ **The vault's only live push-time control could not have been rebuilt if `.git/` were lost**, and
nothing noticed, because it worked. Screened (R8 patterns **0**, gitleaks **no leaks**) and tracked
at exactly the path its header claimed — making the header true — **before** anything overwrote it.
⛩ *Found only because we went to replace it. A control nobody touches is a control nobody checks.*

### §2.4 — Installed, chained (`9aaa384`)

⛔ The sanitize hook's canonical install target **is the slot gitleaks occupies**. Installing as
documented would have traded one live control for another and reported success. A dispatcher runs
both; either blocks; an early block does **not** skip the second.

⚠ **The stdin seam.** Refs arrive on stdin and are consumed by the first reader; a naive
`gate1 && gate2` hands gate 2 an **empty** list, which reads as *nothing to push* and exits **0** —
a green-reporting gate created in the act of installing a gate against green reporting. Captured
once to a temp file and **redirected, not piped** (F-P7b-ab). Prior control preserved at
`.git/hooks/pre-push.pre-dispatch-20260902` (SO#6).

### §2.5 — Verification, and what the arms actually prove

| suite | result |
|---|---|
| `test_sanitize_content_gate.sh` | **28/28** |
| `test_prepush_dispatch.sh` (new) | **7/7** |

**Measured, not asserted** — a `SANITIZE_HOOK` override was added so the previous version can be
*run* rather than reasoned about:

| new arm | vs 4.1.0 | verdict |
|---|---|---|
| published line is NOT re-litigated | **RED** | ✅ discriminates |
| a NEWLY ADDED occurrence blocks | **RED** *(substring)* | ✅ discriminates |
| new occurrence in `STATE.md` blocks, old line NOT reported | **RED** | ✅ discriminates — *the case the allowlist would have passed* |
| `[regression]` rename · malformed ERE · unreadable deny | green | ⚠ **discriminate nothing about this change; labelled, not counted** |
| dispatcher arm 1 (stdin seam) | **RED vs a naive chain** | ✅ negative control run |

⛔ **Two defects found by our own new arms, both in this sitting's own work:**

1. **`declare -a r8_patterns` without assignment is UNSET under `set -u`.** The hook aborted before
   its Decision block and exited **1 on every push, including clean ones** — every R7 arm went red.
   ⚠ Fail-safe in *direction*, but **a crash is not a verdict**, and only the harness could tell them
   apart.
2. **`exec 3</dev/tty 2>/dev/null` in the current shell** would permanently silence the hook's stderr
   on success **and** still leak the shell's diagnostic on failure. Caught on the re-drive; moved to
   a subshell.

### §2.6 — ⛔⛔ F-P7b-as, found on the FIRST REAL DRIVE, in the template's own code

Driving the installed hook with real refs — `printf 'refs/heads/master <head> refs/heads/master
<origin/master>' | .git/hooks/pre-push …`, causing nothing:

- **gitleaks: clean** across the outgoing range ✓
- **R8: zero findings** across **68 files / 26 commits** ⭐ — it passes **honestly, with no exemption
  of any kind**, exactly as the pre-measurement predicted
- **R6: WARN** — `how/federation/git/CLAUDE.md` carries `status: draft`
- ⛔ then: `/dev/tty: Device not configured`

**The no-tty guard exists, reads correctly, and cannot fire.** `[[ -t 0 ]]` tests **stdin**, which at
push time is git's ref list — a pipe, never a tty, *as the comment on the line above says*; and
`! -e /dev/tty` is false on macOS, where the device node exists with no terminal attached. Both arms
false ⇒ fall through to `read` ⇒ error ⇒ exit 1 under `set -e`. ⛩ **The right verdict for the wrong
reason** — which is why nothing ever revealed it, and why the operator-facing message its author
wrote **has never once printed.** Repaired to test the **act**, not a property inferred about it.

⭐ **The defect had been latent exactly as long as the gate had never run.** F-P7b-ag said R1–R8 had
never run on a real push; the first real drive found a broken guard within minutes. *This is the
argument for installing a control, stated as evidence rather than as a principle.*

⚠ **NAMED GAP, not papered over**: the WARN path has **no arm**. An arm reaching it would open
`/dev/tty` successfully on an interactive machine and **hang on `read`** — a test whose behaviour
depends on whether the runner has a terminal is not a control. Verified manually; recorded as a gap.

⚠ **Operational consequence, stated plainly**: the R6 WARN is a **genuine finding** and was **not
tuned away**. Until that file's `status: draft` is resolved, this vault's next push requires an
interactive confirm. That is the gate working, and it is the operator's call, not ours.

### §2.7 — Delivery (3, all probe-gated `GO`)

Dry-run first, verified inert on **two independent measures** (retained md5s unchanged; fleet-wide
`find` = 0), then live.

| peer | md5 | probe | `status:` | delta | copies |
|---|---|---|---|---|---|
| `Inference.aDNA` (Pythia) | `64e90db9…` | 6 pass · **2 pass~** · 0 BLOCK · 0 UNKNOWN | `delivered` | **1 line** | 2 |
| `aDNA.aDNA` (Rosetta) — hook 4.2.0 | `6ae8781b…` | 8 pass · 0 BLOCK · 0 UNKNOWN | `delivered` | **1 line** | 2 |
| `aDNA.aDNA` (Rosetta) — ADR-017 offer | `173d6a31…` | 7 pass · 0 BLOCK · 0 UNKNOWN | `delivered` | **1 line** | 2 |

Invariants re-measured **independently of the tool's own report**: `delivered_md5` **0** in each
field copy / **1** in each retained (F-F35); fleet-wide `find` returns exactly **2** per memo.
⭐ Pythia's route logged **`pass~inferred`** twice — F-P7b-aa's third verdict doing its job, an
inference visibly marked as one rather than borrowing a clean PASS.

⚠ **The ADR-017 offer goes out against its own D5 condition** (*"if it proves out here"* — ratified
today, has not). The operator elected to offer now; the memo **discloses the condition on its face**
and argues *against* itself in §3, which is the most D5's *"offered, not upstreamed"* permits.

## §3 — Close verification

| check | result |
|---|---|
| inbound re-sweep before signature | **0 NEW** |
| exposure unchanged by this sitting | **75 · 70 · 23** — three units, never collapsed |
| ratified substance edited | **0** — A5 provenance `25de3e09`, ADR-016 D1–D6 `3a35df11`, ADR-014 tail `eeb415f1` |
| deny-list patterns changed | **0** (`8694ce70`, 2 → 2) |
| installed hook == tracked source | **YES** |
| gitleaks control still live and blocking | **YES** — ran and reported clean on the real drive |
| suites | **28/28** · **7/7** |
| pushes · forge write-calls · `has_actions` PATCHes · graduations · visibility flips · `.adna/` edits | **0 · 0 · 0 · 0 · 0 · 0** |
| `core.hooksPath` | **unset** — deliberately; setting it would relocate the gitleaks install too |
| outward acts | **3**, each probe-gated `GO` |
| decisions left `proposed` | **1** — ADR-016 A1, one §7.7 stamp owed |

## AAR (SO#5)

- **Worked** — Re-running the open sweep instead of trusting the plan's. It was two days stale and
  had **0 inbound**; the truth was 2, one of which landed on the exact clause the sitting was
  convened to stamp. And measuring before proposing: the four-sitting allowlist deadlock dissolved
  the moment someone counted *added* occurrences (**0**) rather than *total* (**75**).
- **Didn't** — Rev 2 adopted a peer's verdict string to end a divergence and created a sharper one:
  the strings agreed while the predicates disagreed in 3 of 5 states, with §3 attaching binding acts
  to those strings. §5.1 ruled a vocabulary; §3 turned it into an instruction set; **both were
  written in the same amendment by this desk**, and neither noticed the other.
- **Finding** — ⭐⭐ **Installing the gate found a broken guard within minutes, and the guard had
  been wrong since it was written.** F-P7b-as's `-t 0` tests the one stream that is *never* a tty at
  push time, and says so in its own adjacent comment. It produced the correct verdict by accident,
  so no amount of reading would have caught it. *A control that has never run is not a control that
  works; it is a control with no evidence either way — and this campaign has now filed that four
  times, once in its own hook.*
- **Change** — R8 scoped to D4 (no allowlist can now exist, A1 §2); the gate **live**, chained, with
  the stdin seam under a negative-controlled arm; the live secret scanner given the tracked source
  its header had claimed for months; A6 §5.2 binds dispositions to predicates, not strings.
- **Follow-up** — (a) **ADR-016 A1 needs its §7.7 stamp**; (b) the **R6 `status: draft` WARN** blocks
  the next non-interactive push — operator's call; (c) the WARN-path **named gap** needs a portable
  no-controlling-terminal driver (`setsid` is absent on macOS); (d) Rosetta holds two asks, and the
  F-P7b-as repair should not wait on the 4.2.0 decision; (e) Pythia's `ack_required` is open;
  (f) F-P7b-z's denominator — what else in `.adna/` self-tests by reimplementation.
