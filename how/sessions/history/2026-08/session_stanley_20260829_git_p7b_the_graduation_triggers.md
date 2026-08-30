---
type: session
session_id: session_stanley_20260829_git_p7b_the_graduation_triggers
date: 2026-08-29        # twenty-seventh sitting (FIRST on this local date). Act timestamps UTC.
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — the graduation triggers, and a premise that was already false when it was ruled"
door: "§1 open sweep + intake 3 inbound · §2 ADR-014 A6 authored (T1/T2 named · T2 made evaluable · the ten ruled · T3 named · pen-line held) · §3 the A4 §5 citation defect · §4 two replies delivered · §5 verify + close"
plan: please-read-the-claude-md-declarative-canyon
head_at_open: ac0f338
head_at_close: this close commit
outward_acts_planned: 2   # memo placements: Forgejo.aDNA (Ilmarinen) · aDNALabs.aDNA (Berthier) — each probe-gated via send_memo.sh
token_budget_estimated: ~180k

inbound_at_open: "3 — MEASURED with `git ls-files --others --exclude-standard` (F-DF-145), not `git status`.
  (1) Ilmarinen/`Forgejo.aDNA` → `who/coordination/`: T2 has already fired for three graphs; F-F86 filed
      (the has_actions rule is enforced where it is vacuous and absent where it bites); §4 asks US to
      rule, `ack_required: true` on that section only.
  (2) Ilmarinen/`Forgejo.aDNA` → `who/coordination/`: F-F86 now MEASURED (actions_unit + action_run rows
      read on the box), and ⛔ a correction against his own filing — F-F89: the population is 10 enrolled
      vaults, not 3, because both his tables enumerated a STALE ROSTER (22 rows) while the conf holds 71.
      Also F-F91 against his own instrument (un-namespaced VAULT_ROOT resolved to an archived vault;
      every UNMEASURED printed beside `compared=4/4`). `ack_required: true`.
  (3) Berthier/`aDNALabs.aDNA` → `who/coordination/inbox/` (drop-box, conforming): ADR-016 read at the
      object; rules aDNALabs OUTSIDE the census population by construction (private, measured with
      Git.aDNA as a same-run PUBLIC control) and states no D6.5 was owed. Offers three refutable items
      incl. the authorship axis — 6 occurrences in OUR public repo that HE authored. `ack_required: false`."

leases_at_open: "ours 0 (`how/sessions/active/` held only .gitkeep before this file). Peer leases NOT
  read at open — a send is gated by the probe at send time, and a stale open-time reading is exactly
  what F-P7b-i exists to prevent."

outward: partial   # EXECUTED: 2 memo placements, both probe-gated GO. NO push, NO forge write-call,
                   # NO has_actions PATCH, NO graduation execution, NO visibility flip, NO .adna/ edit.

crash_recovery: "The twenty-sixth sitting closed cleanly (`f45da24`); a fable session then committed
  `ac0f338` (the rd-forge source-of-truth sweep: A4 §5 wrapper mirror + the operator ruling memo).
  `how/sessions/active/` held only `.gitkeep` at open; tree clean but for the three untracked inbound.
  NINTH consecutive sitting to open on a clean-or-crash check; this one is clean."

operator_rulings:
  - "scope = A6 + intake + acks. Three alternatives offered and DECLINED: A6-only with all inbound
    deferred; A6 PLUS an ADR-016 D7 for Berthier's authorship axis; and taking the R8 allowlist debt
    (STATE ⏭ a) instead."
  - "T2 answer = SPLIT BY LANDING STATE. Three alternatives offered and DECLINED: all ten graduate
    (ten ADR-006 D3 ceremonies); all ten as named exceptions; all ten move their CI off the forge."
  - "outward = DELIVER via send_memo.sh. Two alternatives offered and DECLINED: author-and-hold; and
    deliver PLUS push the self-repo (which would fire ADR-016 D1 on everything committed here)."

findings_opened: [f_p7b_al, f_p7b_am]
findings_closed: []
---

# Session — the graduation triggers, and a premise that was already false when it was ruled

## §1 · Open sweep

| field | value | how measured |
|---|---|---|
| HEAD at open | `ac0f338` | `git rev-parse --short HEAD` |
| tree | clean but for 3 untracked inbound | `git status --short` |
| inbound | **3** | `git ls-files --others --exclude-standard` (F-DF-145 — never `git status`) |
| our leases | **0** | `how/sessions/active/` held only `.gitkeep` |
| peer leases | **not read** | deliberate — F-P7b-i; the probe measures at the act |

## §2 · Running log

*(appended as acts complete)*

### §2.1 — Intake (`f0145c7`)
3 inbound committed. Ilmarinen ×2 (`ack_required: true`, one question), Berthier ×1 (`ack_required: false`).

### §2.2 — ADR-014 A6 authored (`94f7a56`), `proposed`
Inserted whole before `## Consequences`. **Append-only proved, not asserted:**

| region | md5 | lines |
|---|---|---|
| D1–A5 body (H1 heading → A6 heading), HEAD vs worktree | `9f92273e1dd81b21a8ff2ce8c369e7a3` **both** | 186 |
| tail (`## Consequences` → EOF), HEAD vs worktree | `eeb415f18e15cb9919b5c48ab342eb25` **both** | — |
| whole file | 211 → 296 lines (+85) | |

Frontmatter excepted, per A5's precedent (`updated`, `status` note, `tags`).

### §2.3 — Measurements taken here (re-derived, never quoted)

```
conf non-comment rows            71  = 70 enrolled + 1 graduated     [Ilmarinen's denominator, exact]
live pending_declaration rows     0  (3 grep hits all comments)      [the 08-28 sweep's claim holds]
carriage (git ls-files, 71 dirs) 10  aDNALabs 2 · Network 3 · WGS 2 · aDNA 3 · Emacs 6
                                     Spacemacs 3 · ScienceStanley 2 · Exchange 1 · TappProtocol 1 · wga 1
                                                                     [F-F89's count AND every per-vault count, exact]
LAVG (graduated) carriage         0  measured, not assumed
Inference.aDNA remotes            1  mesh-rd only — NO origin        [the A2 §1 exposure, at the object]
wrapper freshness_mode vs conf   agree (active_co_development)
```

⚠ **Not re-derived and labelled as such**: `actions_unit` / `action_run` rows — Ilmarinen's measurement at a vantage this desk cannot reach.

### §2.4 — Findings

- **⛔ F-P7b-al** — `ADR-014 A4 §5` does not exist (A4 runs §1·§1a·§2·§3·§4); our own wrapper cited it twice at `ac0f338`. ⭐⭐ It survived four artifacts because **`ADR-011` A4 §5 IS real and cited ~15× in this tree** — a wrong pointer colliding with a right one reads as *known*, not broken. Wrapper comment corrected; ratified A4 text untouched.
- **⛔ F-P7b-am** — our own first carriage pass printed `enumerated 71 dirs · carrying=0`: correct denominator, false numerator, from a `while read … done < conf` loop where command resolution failed (`basename` reported *command not found* on the same line). Caught **only** by a positive control run before the number was used. **F-F91's shape, in our own harness, in the same hour §2.2 was written forbidding it.**

### §2.5 — Verified, not filed
Ilmarinen delivered to `who/coordination/` rather than the drop-box while his guard read `dropbox=yes`. **Correct**: the redirect fires only on a *declared collision* with the write dir, and we held **no lease** on 08-28. Checked in `probe_peer_state.sh` before writing anything down.

### §2.6 — Deliveries (2, both probe-gated `GO`)

`--meta` all arms green **first**; `--dry-run` verified inert **against our own md5 baselines and a peer-tree `find`**, not the harness's own arm (F-P7b-ak's lesson: the meta arm once asserted *copied nothing* and never *stamped nothing*).

| peer | md5 | recipient `status:` | delta | fleet-wide copies |
|---|---|---|---|---|
| `Forgejo.aDNA` | `87ca7102f1ea974471a7e53f936d236d` | `delivered` | **1 line** (hash, retained only) | 2 |
| `aDNALabs.aDNA` | `268d66c21e2755e4a18dc6cb706a12ea` | `delivered` | **1 line** | 2 |

⚠ `delivered_on: 2026-08-30` — UTC, per this file's stated act-timestamp convention; local date is 2026-08-29. Recorded so the one-day offset is not later read as drift.

### §3 — Close verification

| check | result |
|---|---|
| inbound re-sweep before signature (F-P7b-ae) | **0 NEW** — the only untracked were our own two outbound |
| unpushed commits | 2 at re-sweep (self-repo never pushed) |
| `.adna/` edits | **0** |
| forge write-calls · `has_actions` PATCHes · graduations · visibility flips | **0 · 0 · 0 · 0** |
| A6 status | **`proposed`** — operator §7.7 owed; Ilmarinen owed the delta if the text moves |

## AAR (SO#5)

- **Worked** — Reading the two Ilmarinen memos *in order* is what made the ruling tractable: his self-correction (3 → 10, 7 unlanded) is precisely what turned ten ceremonies into three decisions plus a runbook order. And running a positive control before using a number caught a false zero that would have gone into an ADR.
- **Didn't** — Our first carriage measurement was wrong in the most dangerous way available: a well-formed total with a correct denominator. Nothing in the loop announced failure. It was the environment, and the instrument had no way to say so.
- **Finding** — ⭐⭐ **A wrong citation that collides with a real clause elsewhere is far harder to catch than one that points at nothing.** `ADR-014 A4 §5` passed four artifacts and every read because `ADR-011 A4 §5` is familiar and load-bearing here. Recognition substituted for verification — and that is a different failure from the stale-row class this campaign usually finds.
- **Change** — A6 §2 makes T2 a predicate with `INDETERMINATE` as a first-class verdict, so the next time this question is asked, an unmeasured answer cannot present itself as a clean one.
- **Follow-up** — (a) operator §7.7 on A6 · (b) ADR-016's outbound-authorship question, its own sitting · (c) F-P7b-z now has **four** measured instances of self-test-by-reimplementation.
