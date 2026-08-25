---
type: session
session_id: session_stanley_20260824_git_p7b_the_vault_that_preached_portability
date: 2026-08-24        # twentieth sitting (SIXTH on this local date). Act timestamps UTC.
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — ADR-024 lands and the licensing debt becomes performable: this vault is one of the unlicensed public repos it measured, and the drop-box it never opened is why peers have been refused four sittings running"
door: "§1 open sweep + lease · §2 forge reading #1 (pre-act) · §3 Lane A LICENSE + push · §4 forge reading #2 (post-act) · §5 Lane B drop-box · §6 Lane C measurement correction · §7 verify · §8 close"
plan: please-read-the-claude-md-tingly-lerdorf
head_at_open: 7f1efcd
head_at_close: see_tracking_commit
inbound_at_open: 1      # ⭐ MEASURED, not assumed: `coord_2026_08_24_berthier_to_hopper_licensing_ruled_and_your_public_lane_is_five_times_larger.md`, untracked, mtime 16:11:48. ⛔ AND SEE F-P7b-q: this vault publishes NO drop-box, so a 0 here would never have been evidence of quiet. This 1 arrived only because our lease happened to be closed.
inbound_at_close: 0 new    # ✅ SWEPT AT CLOSE, MEASURED with -uall AND ls-files. The only untracked items in who/coordination/ are the Berthier memo (dispositioned this sitting) and our own new inbox/README.md. ⭐ AND FROM TONIGHT THAT READING MEANS SOMETHING: with the drop-box open, 0 inbound can no longer be the artefact of our own lease refusing everyone at the door (F-P7b-q).
leases_at_open: "ours 0 (`how/sessions/active/` held only .gitkeep before this file). Peers at open: Home 1 · aDNALabs 0 · Network 0 · aDNA 0; Forgejo/Inference/Lighthouse have no `how/sessions/active/` dir ⇒ UNKNOWN, not 0. Recorded as PROVISIONAL — this sitting sends nothing, so no act depends on it."
outward: true           # DECLARED: exactly one push (this vault's own LICENSE to origin) + read-only `gh api` GETs. No repo created, no visibility flip, no write into any peer vault.
crash_recovery: "The nineteenth sitting crashed after its work commit. Verified rather than assumed: `7f1efcd` carries STATE + CHANGELOG + the session file already in history/2026-08/; `how/sessions/active/` held only .gitkeep; `git status --porcelain` clean but for the one untracked inbound. The crash cost the conversation, not the vault. Second consecutive sitting to open this way, and the check is cheap enough that it should stay ritual rather than become an assumption."
operator_rulings:
  - "scope = all three lanes: LICENSE this vault · open the drop-box · correct the measurement doc. The MEMO lane was offered and DECLINED ⇒ the Berthier ack and the Rule-10 asks to III + Canvas stay OWED and are named as such, not quietly dropped. (AskUserQuestion, plan gate)"
  - "outward window = OPEN for push + forge read. The LICENSE is pushed (the act that actually licenses the distributed copy), and read-only `gh api` GETs are authorised."
  - "the corrected public-lane figure = RE-DERIVED AT THIS DESK, not adopted from Berthier. Options to withdraw-the-figure or adopt-marked-un-re-derived were offered and declined."
signature_basis: "No ADR is ratified this sitting. ADR-024 is aDNALabs' record, ratified at THEIR gate (S242) — we are a consumer of it, not a signatory, and this file must not read as though we signed it."

inbound_intake: |
  `coord_2026_08_24_berthier_to_hopper_licensing_ruled_and_your_public_lane_is_five_times_larger.md`
  — from Berthier (aDNALabs.aDNA), `ack_required: false`, `severity: medium-high`, delivered 16:11:48.

  Three things it does to us:
  1. ⭐ RULES both open asks. ADR-024 `accepted`: MIT house default, `Copyright (c) 2026 aDNA Labs`,
     public lane first, binding PROSPECTIVELY (§4 — our own A1 §3 clause, adopted by name and cited
     back to us). This was the SOLE blocker on the licensing debt: we could measure the gap but not
     pick a license. It is now performable.
  2. ⛔ FILES A FINDING AGAINST OUR MEASUREMENT. `foss_predicate_measurement.md` §4 counts the public
     lane 4 repos / 3 unlicensed, enumerated from LOCAL vault directories carrying a GitHub origin.
     Measured at the forge: 20 / 16. Thirteen public repos have no local directory at all.
  3. Holds the ADR-045 git limb, re-keyed to OUR instrument rather than any figure; and TAKES Pythia's
     owed cc as his row — closing a standing debt of ours by his hand, not ours.

  ⛩ The transferable half, and it is his sentence not mine: *a caveat on the numerator is not a caveat
  on the denominator.* Our §6 DOES carry a "not a remote reading" caveat. It guards what we counted.
  It cannot guard what we never walked past.
tags: [session, p7b, adr_024, licensing, mit, dropbox, f_p7b_q, denominator_defect, forge_enumeration, hopper]
---

# Session — The Vault That Preached Portability And Shipped No License

## §1 · Open sweep

| Check | Reading |
|---|---|
| HEAD at open | `7f1efcd` (nineteenth sitting's close) |
| Tree | clean but for 1 untracked inbound |
| Our leases | 0 (`.gitkeep` only) |
| Inbound | **1 — Berthier, 16:11:48** |
| `core.hooksPath` | **unset** ⇒ `.git/hooks/pre-push` is live (F-Astro verified absent, not assumed) |
| `gh auth` | ScienceStanley, scopes `admin:org`, `repo`, `workflow` |

## §2 · The three lanes

**A · LICENSE this vault.** `Git.aDNA` is one of the three unlicensed GitHub-public repos our own §4
table names — public since the P5 beachhead (2026-06-20), distributed right now under what default
copyright makes *all rights reserved*. Our own document already indicts us by name:

> *A reader who forks `Git.aDNA` today has no license to do so, and this vault's entire thesis is
> portability and open standards.*

**B · Open the drop-box.** `Forgejo.aDNA/STATE.md` records this vault as `GUARD_REFUSE reason=lease`,
**no drop-box**, and logs a Git-directed leg blocked **four consecutive sittings**. Eleven peers publish
one. We publish none.

**C · Correct the measurement**, re-derived here rather than adopted.

## §3 · Lane A — executed

| Step | Result |
|---|---|
| `cp ../Exchange.aDNA/LICENSE LICENSE` | `cmp` **identical**, md5 `b189a96420df57c630764b57ba7ff2f4` both sides |
| Commit | `b6c070c` |
| Push | `847bccb..b6c070c master -> master` |
| Pre-push hook | **RAN** — `gitleaks scanning outgoing range … clean across 1 outgoing range(s) ✓` |
| `core.hooksPath` | unset ⇒ F-Astro (stale hooksPath silently bypassing the gate) **verified absent** |
| Forge view | `private=false  license=MIT  name=MIT License` |
| Anon `ls-remote` | `b6c070c…` — a stranger reaches it, now under MIT |

## §4 · Lane C — the two readings that straddle the act

| Reading | Taken | public | `license==null` |
|---|---|---|---|
| #1 pre-act | `01:15:19Z` | 20 | **16** |
| #2 post-act | `01:16:13Z` | 20 | **15** |

**Berthier's 20/16 reproduces exactly at this desk** — re-derived per the operator's ruling, not adopted.
Page-completeness asserted on both (20 < 100 on `per_page=100`).

⭐ **The delta is the verification.** `Git.aDNA` left the null set; the denominator moved by exactly the
repo we touched, measured by an instrument that knows nothing about the push's exit code.

⚠ **And re-derivation found something his table did not carry.** The 20 and our 4 answer **different
questions** — the licensed complement includes `adna-legacy` (archived template), `spacemacs` (a fork
carrying **upstream's** GPL-3.0), `community-policies` (not a graph). Recorded as **two populations**
(§4.2) rather than one number replacing another. ⛔ **This sharpens rather than softens the finding**:
the gap is **13 public repos governance could not discover**. We record the count and propose no remedy
— ADR-024 §6 holds them as an open disposition.

## §5 · Lane B — the drop-box, and the trap proven in our own tree

`who/coordination/inbox/README.md`, `open_unilaterally`, adapted from Galileo with Venus's F-DF-145
credit carried across.

**Negative control, identical working state:**

```
default (-unormal):  ?? who/coordination/inbox/          ⛔ directory, not the file
with -uall:          ?? who/coordination/inbox/README.md ✅ named
```

⭐ **Trap reproduced here, not inherited on their word.** Tell worth keeping: the Berthier memo **is**
named by the default form (it sits directly in a tracked dir) — only the *new* directory collapses,
which is exactly a brand-new drop-box's condition.

### §5.1 · The audit found less than the plan feared, and it is reported that way

The plan warned we might ship a convention whose stated trap we then fall into. **Measured: we do not.**

- `check_own_inbound` uses `git ls-files --others --exclude-standard` ⇒ enumerates **files**, **immune**.
  Live probe reports **2**, having seen *into* the brand-new box.
- `check_writedir_dirty` used `git status --porcelain` without `-uall` ⇒ **undercounts**. Proved in an
  isolated repo: 3 memos → default **1**, `-uall` **3**.
  ⚠ **Scoped honestly: a COUNT defect, not a DECISION defect.** The branch keys on `tracked>0` /
  `untracked>0`, and that classification survives the collapse ⇒ **every GO/NO-GO this probe ever
  returned was correct.** What was wrong is the queue depth reported to the operator. Fixed.

⭐ **The more valuable artifact is the comment, not the fix.** `check_own_inbound`'s immunity is
**accidental** — `ls-files` was chosen before F-DF-145 was known here; nobody dodged a defect they had
never heard of. *An undesigned immunity is not a guarantee*: a future refactor to the more obvious
`git status` idiom would silently blind our inbound sweep on the first memo into an empty box. A
`DO NOT SIMPLIFY` comment now pins why the command is load-bearing.

## §6 · ⛔⛔ THREE INSTRUMENTS, ONE DEFECT — each valid under a precondition nobody wrote down

**F-P7b-r.** Tonight produced three independent instances of a single shape, and only the first was
reported to us:

1. **§6's own caveat** (Berthier's finding). *"Not a remote reading"* guards the **numerator**; the
   **denominator** was equally a remote fact and nothing guarded it. Precondition: *the local walk sees
   every repo.* Never stated, and false by 13.
2. **The census tally.** `secret_gate` read **39 `FAIL_NONE`** against a recorded baseline of **38** —
   which reads as a regression. It is not: **`operations_stanley.aDNA` was created today at 18:09**,
   between the two readings. Precondition: *the population is fixed.* ⭐ *A tally compared across
   sittings is evidence only if the population is compared too.*
3. **The outward-acts mtime sweep.** Returned **519** files newer than our lease outside `Git.aDNA`.
   Nothing of ours: **0** are hopper-authored; the writers are `agent_rosetta`, `berthier`,
   `agent_ilmarinen_lane` on their own desks. Precondition: *the workspace is quiet.*
   ⛔ **The eighteenth sitting recorded "outward acts ZERO — PROVEN, not asserted (mtime sweep)". That
   proof was sound only because nothing else happened to be running.** Tonight the identical command
   returns 519 and looks like a catastrophe.

> ⭐ **The generalisation, paid for three times in one sitting:** *an instrument valid under an unstated
> precondition does not fall silent when the precondition fails — it reports, confidently, and wrong.*
> Two of the three would have reported in the **alarming** direction, which is the direction that gets
> believed.

⇒ **Outward acts are attributed BY NAME from here, never by clock.** This sitting's, exhaustively:
**one push** (our own `LICENSE` to `origin`) · **read-only `gh api` GETs** · **one read-only peer probe**
(Jupyter, no `--exec`) · **one read** of `Exchange.aDNA/LICENSE`. **No repo created, no visibility flip,
no destructive call, no byte written into any peer vault** — 0 hopper-authored files outside this tree.

## §7 · Verification

| Instrument | Result |
|---|---|
| `dryrun_gitops.sh` | **94 passed, 0 failed** — unchanged |
| `census_wrapper_copy --meta` | **PASS** — every class fails when it should |
| `census_wrapper_copy` live | **61 · 38 present · 23 absent · 35 skeleton · 2 v2.0.0 · 1 v2.1.0 · 0 UNCLASSIFIED** — matches baseline exactly |
| `census_secret_gate` | **0 dangling · 0 UNCLASSIFIED** unchanged; `FAIL_NONE` 38→39 **explained, not a regression** (§6.2) |
| `probe_peer_state --meta` | every check reached failure; controls pass; `--exec` gates both ways |
| `probe_peer_state` live | Jupyter **GO**, 6 pass / 1 warn — `own_inbound` correctly reports 2 |
| `preflight_context_sync` | **7 PASS / 1 BLOCK** ⚠ and the BLOCK is `clean_tree` on this sitting's own paths — correct trip-gate behaviour |
| `-uall` negative control | trap reproduced in this tree, both forms recorded |

## §8 · Owed, and named so it is not read as done

- ⛔ **`III.aDNA` and `Canvas.aDNA` remain public and unlicensed.** Rule-10 theirs; the asks are
  **unsent** — the memo lane was declined at the gate. 15 is not progress on their behalf.
- The **Berthier ack** (his §3 finding adopted; the two-populations refinement is his to see).
- The **Home** half of the *hold-now-has-an-exit* memo — Home held 1 lease at open.
- **F-P7b-q's drop-box convention** as a *fleet* ruling — ours is open, which is only our half.
- ⚠ **`operations_stanley.aDNA` reads `FAIL_NONE`** (new vault, no hook). Observation only — theirs.
- ⚠ Fleet stale-lease accumulation observed in passing: `CanvasForge` 120, `WilhelmAI` 49 files in
  `how/sessions/active/`. Not ours; noted because our own sender treats a lease as authoritative.
