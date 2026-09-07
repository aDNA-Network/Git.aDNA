---
type: session
session_id: session_stanley_20260906_git_p7b_the_ones_that_passed_were_not_scanned
date: 2026-09-06        # thirtieth sitting. Act timestamps UTC.
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — the ones that passed were not scanned"
door: "§1 open sweep + intake 4 inbound + 3 guest-pen commits · §2 ratify ADR-016 A1 · §3 ADR-011 A8 authored · §4 F-P7b-aw repaired in our copies · §5 three memos · §6 verify + close"
plan: please-give-your-advice-idempotent-wilkinson
head_at_open: 7a204dc
head_at_close: this close commit
outward_acts_planned: 3   # memos: Forgejo.aDNA (Ilmarinen) · Canvas.aDNA (Mondrian) · Network.aDNA (Venus)
token_budget_estimated: ~200k

plan_vs_measured: "⛔ THE PLAN WAS STALE ON EVERY LOAD-BEARING FACT, AND ONE OF THE ERRORS WAS OURS.
  HEAD `901aa56`→**`7a204dc`** (3 Venus guest-pen commits landed) · unpushed 28→**31** ·
  inbound 0→**4** · draft-status files **9→22**. The first three are the world moving under a
  two-day-old plan. ⛔ **The fourth is a measurement defect in the planning pass**: the count came
  from `grep -rl … | head`, and `head` truncated silently at 10, which was reported as a population
  of '9 + 1 fixture'. See F-P7b-av. The plan's own preamble said its facts were 'a starting
  hypothesis, not a finding', and re-measuring at the first act is what caught all four."

inbound_at_open: "4 untracked (`git ls-files --others --exclude-standard`, F-DF-145) **plus 3
  guest-pen commits already in the tree** — a channel the open sweep had no row for until now.
  (1) Ilmarinen → ADR-011 refused four Wave-2 landings; `PercySleep.aDNA`'s hook dies on `/dev/tty`.
  (2) Ilmarinen → **CORRECTION: the four were operator-triaged FALSE POSITIVES on 08-28; ask (1)
      withdrawn.** No exposure, no purge, no rotation, no routing decision owed.
  (3) Ilmarinen → **'the ones that passed were not scanned'** — the gate's coverage is a function of
      remote configuration, not content; four vaults scanned a 0-commit range and returned green.
  (4) Mondrian → ack, plus 'your floor was 4× low' — a second RFC1918 literal our published figure
      never named.
  (5–7) Venus/`Network.aDNA` guest-pen commits `88f41ce` · `da6fd2e` · `7a204dc` — a fleet notice, a
      delivery-stamp correction, and **an ask directed at us** (§5: GitHub mirrors as a real remote
      role for `WebForge.aDNA` + `TypeScript.aDNA` under ADR-006 D1)."

leases_at_open: "ours 0 (`how/sessions/active/` held only .gitkeep before this file). Peer leases
  NOT read at open — the probe measures at the act (F-P7b-i)."

outward: partial   # EXECUTED: 3 memo placements, each probe-gated GO.
                   # NO push, NO forge write-call, NO has_actions PATCH, NO graduation,
                   # NO visibility flip, NO .adna/ edit, NO peer-tree repair.

crash_recovery: "The 29th sitting closed cleanly (`901aa56`); three guest-pen commits landed after it;
  `how/sessions/active/` held only `.gitkeep` at open; tree clean but for the 4 untracked inbound.
  TWELFTH consecutive sitting to open on a clean-or-crash check; this one is clean."

operator_rulings:
  - "SCOPE RE-GATED MID-SITTING after the intake: HOOK DEFECTS + A8 + THE A1 STAMP. Three declined:
    hook defects only; stay on the approved plan; add the full 22-file draft audit.
    DEFERRED by this ruling: `census_instrument_meta.sh`, the draft audit, the CI-template repairs
    (F-P7b-at/-au), and Venus's mirror ask."
  - "Ilmarinen's ask #2 = YES, AN INTERACTIVE PROMPT IN AN UNATTENDED-CAPABLE GATE IS AN ADR-011
    CONFORMANCE DEFECT, ruled in A8. Two declined: a separate amendment; not-a-defect/hook-quality."
  - "F-P7b-aw = FIX OUR COPIES, MEMO VENUS WITH THE MEASUREMENT. Two declined: memo only; sweep and
    fix fleet-wide (which ADR-016 D6.1 rules is not ours to do)."
  - "ADR-016 A1 = RATIFY AS WRITTEN (carried from the 2026-09-04 gate). Two declined: ratify without
    §2's allowlist prohibition; hold."

findings_opened: [f_p7b_at, f_p7b_au, f_p7b_av, f_p7b_aw, f_p7b_ax]
findings_closed: []
---

# Session — the ones that passed were not scanned

## §1 · Open sweep

| field | value | how measured |
|---|---|---|
| HEAD at open | `7a204dc` | `git rev-parse --short HEAD` — ⚠ **not** the plan's `901aa56` |
| tree | clean but for 4 untracked inbound | `git status --porcelain` |
| inbound | **4** untracked **+ 3 guest-pen commits** | `git ls-files --others --exclude-standard` (F-DF-145) |
| our leases | **0** | `how/sessions/active/` held only `.gitkeep` |
| peer leases | **not read** | deliberate — F-P7b-i, measured at each act |
| unpushed | **31** | `git rev-list --count @{u}..HEAD` |

**Twelfth consecutive clean-or-crash open; this one clean.**

⛩ **The open sweep had no row for a channel that was already in use.** Three of the seven inbound
items arrived as **guest-pen commits** — already committed into this tree by another graph's session,
so `git ls-files --others` could never have seen them, and the "inbound" count would have read **4**
while the true intake was **7**. Recorded as **F-P7b-ax**; the sweep's own predicate is now the
thing that was incomplete.

---

## ⛔ F-P7b-av — our own coverage claim, from a truncated read, in the planning pass for the clause that forbids it

The 2026-09-03 planning pass reported **"9 files carry `status: draft`"** and built a work item
around it. Measured at the first act: **22** (23 including a test fixture).

**Cause**: the command was `grep -rl '^status: draft' --include="*.md" . | head`. **`head`
truncated at 10 and said nothing.** The number that came back was plausible, so nothing questioned
it, and it was reported to the operator as a population and used to size a decision.

⛩ **It was made while planning ADR-011 A8 §5 — *"a coverage claim states its population, or it is
not a coverage claim."*** The clause was authored against seven instances of other people's version
of this mistake, in a pass that committed it.

⭐ **It is the third instance of the identical class in this one sitting's material**, from three
desks:

| # | instance | the shape |
|---|---|---|
| 1 | **Ilmarinen** — four vaults "landed clean"; their pre-push scanned a **0-commit range** | green over an empty population |
| 2 | **F-F97** (his, on record) — a hazard withdrawn on `waiting=0`, taken before the schedule was registered | zero over an empty population |
| 3 | **ours, F-P7b-av** — `head` truncated 22 → 10, reported as 9 | a count over a truncated population |

⇒ **A8 §5 is no longer an argument from other people's findings.** It is the clause this desk needed
two days ago and did not have.

## §2 · Running log

### §2.1 — Intake (7 items, 2 of them dispositioned by a peer before we read them)

**Ilmarinen ×3.** ⭐ **His correction arrived with the original, so ask #1 cost nothing** — read the
withdrawal first. The four "likely secrets" are the operator's own 08-28 triage, **101/101 false
positive**; no exposure, no purge, no rotation, no confidential channel owed. His durable line, taken
into our record: *"that the findings turn out to be benign does not retroactively make the mapping
safe to publish — it makes it unnecessary to publish."*

⭐⭐ **His third memo is the sitting's spine.** A pre-push gate scans `HEAD --not --remotes`, so its
coverage is a function of **remote configuration, not content**. Four Wave-2 vaults scanned a
**0-commit range** and returned green. ⇒ ***"They did not pass, they were not looked at."***

**Mondrian.** Ack, plus *"your floor was 4× low"* — a second RFC1918 literal our published figure
never named. **Venus ×3 (guest-pen).** A fleet notice, a delivery-stamp correction, and **an ask**
(§5: GitHub mirrors as a real remote role for `WebForge` + `TypeScript` under ADR-006 D1).

### §2.2 — ADR-016 A1 ratified (`60c5027`)

Three record sites under ADR-017 D1/D3/D4. **D1–D6 reproduce `3a35df11`**; every hunk at frontmatter
`:5` or inside A1. ⚠ The 4-day install-to-stamp interval is recorded in the frontmatter rather than
smoothed — A1 was authored *after* the gate it describes, and said so on its face, because 4.2.0
brought the instrument **into line with** ratified D4.

### §2.3 — ADR-011 A8 authored (`proposed`, `60c5027`)

**The finding is that the rule was never missing.** A4 §6 — *"any conformance instrument must be
demonstrated to fail before its output is trusted"* — has been ratified since **2026-08-23**, and
**all seven instances of the class landed after it**. It is quoted at the top of `send_memo.sh` and
cited in three instruments; the same desk that cited it produced five of the seven.

⇒ **Citation is not enforcement.** A8 gives A4 §6 a **population** (§1), a **total verdict set**
(§2), and two clauses it never had: **§4** installation is part of the control, **§6** a control must
be runnable in the context it is required to run in.

⚖ **§6 answers Ilmarinen's `ack_required` ask**, ruled `yes`: an interactive prompt in an
unattended-capable gate is a conformance defect. ⭐ **The cure was already in our tree when he wrote**
— F-P7b-as, found 2026-09-02, one day earlier, neither desk knowing.

⚠ **No instrument ships with A8, deliberately.** The census is deferred, so the clause is authored
**first** rather than written to describe whatever the instrument happened to measure — the inverse
of what this vault did with R8 four days ago, recorded because doing it right once does not retire
the finding about doing it the other way.

Append-only: **A1..A7 `fb7ba622`**, tail **`f5256665`**, both unchanged; one pure-insertion hunk.

### §2.4 — ⛔ F-P7b-aw: the scan excluded every remote, not the destination (`4f323a0`)

Chasing Ilmarinen's finding into the hook found a **second, distinct defect in the same nine lines**,
and this one is not about empty ranges. On a new ref the range was `$local_sha --not --remotes` —
**`--remotes` with no pattern subtracts everything reachable from ANY remote-tracking ref.**

⛩ **Under ADR-013 the fleet deliberately runs mixed trust classes on one repo.** A commit vetted for
a **private** mesh replica is not thereby vetted for a **public** origin. Trust class is a property of
the **remote**; the unpatterned form flattens them.

| range, measured here | commits in scope |
|---|---|
| `HEAD --not --remotes` — as shipped | **3** |
| `HEAD --not --remotes=origin` — the destination only | **31** |

⚠ **And the comment above the line asserts the property it violates** — *"never silently narrower"*.
It was narrower by 28 commits. **Third sitting running that a comment in this tree said something
untrue about its own code** (F-P7b-ar's source-of-record, F-P7b-as's tty comment, now this).

Repaired in **the two files we own** (three paths — ⚠ `git/` is a **symlink** to
`how/federation/git`, so the "three copies" in the plan were two). The fallback **never** returns to
the unpatterned form: no tracking refs for the destination ⇒ exclude **nothing**. *Fail-safe means
erring toward more scanning.* ⚖ Venus's own copy **untouched** (D6.1) and sent the reproduction.

### §2.5 — ⭐⭐ The gate's FIRST LIVE CATCH, and D4.1's empty category is no longer empty

Driving the installed hook with real refs: **R8 refused the push** on **1 occurrence / 1 file** —
an RFC1918 literal in `…venus_fleet_notice_adna_rd_l1_rename.md:25`, added by **guest-pen commit
`7a204dc`**, in a file **nobody read**.

**Measured**: present at **neither `origin/master` nor `mesh-rd/master`**. ⇒ nothing published, and
**the first live instance of ADR-016 D4.1's committed-but-unpushed state** — a category that clause
has recorded as *"real and empty here"* since it was written.

**Operator ruling: redact our copy with a dated note; notify Venus.** D6.1 resolves the clash with
*"received correspondence untouched"*: the carrier of **this** copy is `Git.aDNA`, so this copy's
remedy is ours and hers is hers. Literal → `<forge-overlay-addr>`; **nothing else altered**.

⚠ **Fix-forward worked because R8 diffs endpoint-to-endpoint**: committing the redaction removed the
occurrence from what would be published. The first re-drive still blocked — correctly — because the
edit was uncommitted while the diff is computed between commits.

⇒ ⛔ **F-P7b-ax — the guest-pen channel bypasses every control except the push gate.** Three of the
seven inbound items were already committed when we saw them, so `git ls-files --others` could never
report them: the open sweep counted **4** against a true intake of **7**, and the authoring-time
boundary check we run on our own outbound never sees an inbound commit.

### §2.6 — Verification

| suite | result |
|---|---|
| `test_sanitize_content_gate.sh` | **28/28** |
| `test_prepush_dispatch.sh` | **7/7** |
| `test_prepush_scan_range.sh` (new) | **5/5** |

Three of the new arms **measured RED** against the pre-fix hook via a `SUBJECT_HOOK` override —
[A] 3 vs 1 commits, [B] 5 vs 1. ⭐ **Two fixtures, because the repair has two correct outcomes and one
arm could not see both** — and **the first fixture I wrote could not tell the two range forms apart.
Its own discrimination arm said so**, which is the only reason I know; without that arm it would have
been three green arms proving nothing.

### §2.7 — Delivery (3, all probe-gated `GO`)

Dry-run verified inert on two independent measures, then live.

| peer | probe | `status:` | delta | copies |
|---|---|---|---|---|
| `Forgejo.aDNA` | 5 pass · 2 pass~ · 0 BLOCK · 0 UNKNOWN | `delivered` | **1 line** | 2 |
| `Network.aDNA` | 7 pass · 0 BLOCK · 0 UNKNOWN | `delivered` | **1 line** | 2 |
| `Canvas.aDNA` | 8 pass · 0 BLOCK · 0 UNKNOWN | `delivered` | **1 line** | 2 |

`delivered_md5` **0** field / **1** retained (F-F35); fleet-wide `find` = **2** per memo. ⚠ The
delivery stamps read **2026-09-07** against memos dated 09-06: act timestamps are UTC, session dates
local. Consistent with this file's own frontmatter convention; noted rather than reconciled silently.

## §3 — Close verification

| check | result |
|---|---|
| inbound re-sweep before signature | ⚠ **2 NEW** — Mercury + Vulcan, **both `ack_required: false`**, read and carried, scope not re-opened |
| R8 findings on the outgoing range | **0** (was 1) |
| gitleaks on the outgoing range | **clean** |
| ratified substance edited | **0** — ADR-016 D1–D6 `3a35df11`, ADR-011 A1..A7 `fb7ba622`, tail `f5256665` |
| deny-list patterns changed | **0** |
| installed dispatcher == tracked source | **YES** (A8 §4 applied to our own act) |
| suites | **28/28 · 7/7 · 5/5** |
| pushes · forge write-calls · `has_actions` PATCHes · graduations · visibility flips · `.adna/` edits | **0 · 0 · 0 · 0 · 0 · 0** |
| peer trees repaired | **0** — Venus's hook copy untouched (D6.1) |
| outward acts | **3**, each probe-gated `GO` |
| decisions left `proposed` | **1** — ADR-011 A8 |

⚠ **The `status: draft` WARN still blocks a non-interactive push** — deferred by the scope ruling, not
resolved. The population is **22**, not the 9 the plan carried.

## AAR (SO#5)

- **Worked** — Re-measuring the open sweep instead of inheriting the plan's. Every load-bearing fact
  had moved, and **one of them was wrong when written**. And reading peers **at the object**: it
  stopped a finding being filed against our own hook on the strength of a peer's description of *his*
  (ours uses the destination range on an existing ref; only the new-ref branch was defective), and it
  corrected Mondrian's diagnosis in his favour and against us.
- **Didn't** — Reported *"9 files carry `status: draft`"* from a `grep | head` that truncated at 10,
  in the planning pass for the amendment whose §5 forbids exactly that. The number was plausible, so
  nothing questioned it. **F-P7b-av.**
- **Finding** — ⭐⭐ **Citation is not enforcement.** A4 §6 has said the right thing since 2026-08-23,
  is quoted at the top of one instrument and cited in three, and every one of the seven instances
  landed after it — five of them from the desk doing the citing. *A rule you agree with, quote, and
  do not mechanise is indistinguishable from one you never wrote.*
- **Change** — A8 gives A4 §6 a population and a verdict set; §6 rules the unattended-prompt class and
  hands Ilmarinen a predicate to sweep against; F-P7b-aw repaired in our two copies with arms measured
  red against the pre-fix version; the gate took its first live catch and D4.1's empty category is
  no longer empty.
- **Follow-up** — (a) **A8 needs its §7.7 stamp** — the only `proposed` decision; (b) the 22-file
  draft class, still blocking non-interactive pushes; (c) `census_instrument_meta.sh`, deferred —
  and A8 §7 binds it before it exists; (d) the CI-template repairs **F-P7b-at** (the canonical
  template uses a marketplace action its own header forbids) and **F-P7b-au** (the shellcheck path
  list misses both hook dirs); (e) Venus's mirror ask, with the freshness-assertion problem flagged;
  (f) the census's **`--depth 1`** limitation — every figure it has produced is about **tips**, and it
  has never said so; (g) Mercury + Vulcan's memos, carried unread-in-depth.
