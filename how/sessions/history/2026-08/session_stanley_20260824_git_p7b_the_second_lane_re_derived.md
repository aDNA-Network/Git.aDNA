---
type: session
session_id: session_stanley_20260824_git_p7b_the_second_lane_re_derived
date: 2026-08-24        # twenty-second sitting (EIGHTH on this local date). Act timestamps UTC.
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — the second lane re-derived forge-side, and the population-diff remedy takes its first exercise"
door: "§1 open sweep + lease · §2 Codeberg denominator + numerator · §3 population diff · §4 record · §5 verify · §6 close"
plan: please-read-the-claude-md-reactive-planet
head_at_open: d500ce7
head_at_close: see tracking commit (this sitting)
inbound_at_open: "0 new — MEASURED with `git status -uall` (the default form collapses a new directory to a single line; F-DF-145). The one file in who/coordination/inbox/ is Berthier's A5 concurrence, intaken and COMMITTED last sitting, so it is tracked and not inbound."
inbound_at_close: "⭐⭐ 2 — BOTH ARRIVED MID-SITTING, after an open sweep that read 0 and was CORRECT WHEN TAKEN. (1) Berthier/Operations — F-P7b-t ACK + ADR-026 Amendment 1 ratified; (2) Hestia/Home — F-SEAM-02 self-correction. Both `ack_required: false`, nothing owed back. Second consecutive night the drop-box took live delivery while our lease was open — F-P7b-q's fix working as designed. ⚠ And the THIRD instance of F-P7b-s: an inbound reading has a shelf life shorter than a sitting. Surfaced by `probe_peer_state.sh`'s own_inbound WARN, not by a scheduled re-sweep — an instrument doing its job."
leases_at_open: "ours 0 (`how/sessions/active/` held only .gitkeep before this file)."
outward: partial        # DECLARED: read-only forge GETs ONLY (Codeberg Forgejo API + GitHub API), authenticated by credential NAME. ZERO bytes into any peer vault, NO memo drops, NO push, NO repo created, NO visibility flip. The memo lane was OFFERED at the gate and DECLINED.
crash_recovery: "The twenty-first sitting crashed after its close commit. VERIFIED, not assumed — FOURTH consecutive sitting to open this way, and the check stays ritual precisely because it is cheap: `d500ce7` is a session-close commit carrying STATE + CHANGELOG + the session file already in `history/2026-08/`; `how/sessions/active/` held only `.gitkeep`; `git status --porcelain -uall` clean. The crash cost the conversation, not the vault."
operator_rulings:
  - "scope = the Codeberg forge-side re-derivation (named debt (b)) + the FIRST exercise of the population-diff remedy (F-P7b-u). Two alternatives were offered and NOT chosen: a Codeberg-only tight sitting, and adding the `census_secret_gate.sh` mechanism port deferred by A7 §5. (AskUserQuestion, plan gate)"
  - "outward window = READ-ONLY FORGE GETs ONLY. The memo-drop lane was explicitly offered and DECLINED ⇒ a Berthier memo on tonight's result is OWED, NOT SENT, and is recorded that way rather than quietly skipped."
  - "disposition if the Codeberg denominator moves = RECORD THE COUNT, PROPOSE NO REMEDY. Mirrors §4.2 / ADR-024 §6 exactly. Two heavier shapes (author a proposed remedy; escalate to an ADR amendment) were offered and not taken."

declared_paths:
  - what/inventory/foss_predicate_measurement.md         # APPEND-ONLY: new §8 (NOT the planned "§4.5" — the document's own
                                                         #   precedent is §7 "Second reading — appended, not substituted",
                                                         #   so a third reading belongs at the end, not spliced into §4).
                                                         #   Plus TWO in-place corrections, both DECLARED: §4.3 bullet 3 and
                                                         #   §6 bullet 3 each asserted "the Codeberg lane has not been
                                                         #   re-derived" — false once §8 exists. STRUCK, not deleted: each
                                                         #   was true and load-bearing while it stood, and a reader must see
                                                         #   that the gap was named before it was closed.
  - what/inventory/census_population_snapshot.tsv        # regenerated so the NEXT sitting inherits a recorded baseline
  - STATE.md
  - CHANGELOG.md
  - how/sessions/active/ → how/sessions/history/2026-08/

why_this_sitting: |
  Two debts, both NAMED IN OUR OWN HAND, both measurement rather than construction.

  (b) `foss_predicate_measurement.md` §4.3 records, in writing, that the Codeberg lane of §3 "remains
  locally-enumerated and inherits the identical denominator exposure — it has not been re-derived
  forge-side and is not claimed to be." Last sitting the GitHub lane was re-derived and found wrong by
  13 repos: we had recorded 4 public, the forge held 20. Berthier's sentence, aimed at §6 of our own
  document — "a caveat on the numerator is not a caveat on the denominator" — is the reason to run.
  An unremediated instance of a known finding, carried in our own text, is the cheapest finding
  available and the one most likely to rot.

  (F-P7b-u) `census_population_snapshot.tsv` was written LAST SITTING specifically so THIS sitting
  could diff it. It has never been exercised. By ADR-011 A7's own rule — a check that has never seen a
  change has not been tested, it has been unexercised — the remedy is currently unproven.
---

# Session — the second lane, re-derived

Live log below; AAR at close.

## §1 · Open sweep

| Check | Reading |
|---|---|
| HEAD | `d500ce7` (session-close commit) |
| `how/sessions/active/` | `.gitkeep` only ⇒ no stale lease |
| `git status --porcelain -uall` | clean |
| inbound (`-uall`) | **0 new** |
| inbound (default form, negative control) | 0 — agrees, because the drop-box directory is no longer new |
| `CODEBERG_TOKEN` | PRESENT (by name; value never read) |
| `GITHUB_TOKEN` | PRESENT (by name; value never read) |
| `tea` CLI | absent — not needed; plain read-only `curl` against the Forgejo API |

### Plan-time probes (read-only, authorized, and they CHANGED the plan)

1. `GET /api/v1/orgs/aDNA-Network/repos?limit=50&page=1` → **HTTP 200, 19 rows.** The local walk also
   found 19 distinct repos. ⇒ the denominator *appears* to reproduce. Recorded in advance as a likely
   **negative result**, so that it cannot later be inflated into a finding.
2. ⛔ **Forgejo carries no `license` field.** The GitHub numerator instrument (`.license == null`)
   CANNOT be ported. The two lanes are not symmetric, and the plan was changed rather than the
   asymmetry smoothed over.

---

## §2 · Obj 1 — the Codeberg lane, re-derived forge-side

### The result is NEGATIVE, and that is the finding

| Quantity | §3 (local walk) | §8 (forge) | Verdict |
|---|---|---|---|
| distinct repos | 19 | **19** | ✅ set-identical, name for name |
| invisible to local walk | — | **0** | ⇒ **no** GitHub-style gap |
| unlicensed | 18/19 | **18/19** | ✅ reproduces |

⭐ **The Codeberg lane does not carry the defect that cost the GitHub lane 13 repos.** §4.3's exposure
was real, was worth measuring, and measured clean. **Not inflated into a finding.**

- Diffed as a **SET by name**, never by count — a matching count over a differing set is a coincidence
  that reads as agreement. **Negative control**: a planted `SENTINEL.aDNA` appears ⇒ the diff discriminates.
- **Page-completeness asserted two ways**: `limit=50` → 19 rows (19 < 50 ⇒ single page); `page=2` → 0 rows.

### ⛔ F-P7b-v — my numerator probe misreported TWICE, both in the reassuring direction

Keyed on the **HTTP status code**, it returned `Caddy.aDNA ✅ LICENSE`. Chased because *an empty repo
reporting a LICENSE is a contradiction on its face*:

1. On a repo Forgejo flags `empty: true`, `/contents/<anything>` returns **HTTP 200 + `[]`** — proven
   with the control `ZZZ_NOT_A_REAL_FILE_XYZ`, which also returned 200.
2. **The `empty` flag was itself STALE**: `ls-remote` returns `7708cd1 refs/heads/master`, 13 commits.
   So the fallback verdict (*"empty, nothing to license"*) was **also** wrong.

⭐ **Both wrong verdicts EXCUSED the repo from the unlicensed count.** Sitting 20 noted that instruments
misreporting in the *alarming* direction get believed; this pair ran the other way — the **reassuring**
direction, which gets *waved through* instead of checked. **Corrected**: predicate = body shape
(`type=="file"`), never status; repo facts from `ls-remote`, never derived metadata. Self-test retained.

### ⛔ 8 of 19 diverge from the forge — §7b's own named residual, closed WITHOUT a fetch

All eight **local-ahead/unpushed** (`WebForge` +677 · `Container` +146 · `Forgejo` +67 · `Spacemacs` +58
· `Molecules` +13 · `Oration` +7 · `Lighthouse` +5 · `VisualDNA` +5). Nothing `behind`, no divergent
histories. Direction established **without fetching** (object presence + `merge-base --is-ancestor`) —
a fetch writes into a peer vault's `.git`, which tonight's window forbids, and F-P7b-t is precisely
about fetches that silently move tracking refs.

⭐ **What it costs §3**: its numerator was read at **local HEAD**, and for **8 of 19 rows that is not the
forge's HEAD** — those rows described an artifact the forge does not hold. The verdict is unchanged
(the forge-HEAD probe agrees, 18/19) but the *reasoning* was unsound for 42% of rows. ⛩ **It went
unnoticed precisely because the answer came out the same: agreement in the number concealed a
disagreement in what was being measured.**

⚠ §7b was **scrupulously honest** and is not being corrected — it closed the *fetched-but-unmerged*
class and explicitly left the *never-fetched* class open, naming stale refs by date. §8 closes that
residual. (`Forgejo +62` vs `+67`: local work advanced 5 commits between readings; cache and forge
agree at `69ec5c4`. Checked, not assumed.)

## §3 · Obj 2 — the population-diff remedy, FIRST EXERCISE ⭐

| Population | Baseline | Now | Δ |
|---|---|---|---|
| SECRET_GATE | 128 | **127** | −1 row |
| WRAPPER_COPY | 61 | **61** | none |

**One removal: `adna-lab-fo3-tip-bind` (was `PASS`).** Zero additions, zero verdict changes on rows in
both. Tally moved `PASS 9 → 8` — **entirely accounted for by that departure. NOT a regression, and
attributable in one step**, which is exactly what sitting 21 could not do.

**Verified real, not an enumerator artifact**: the dir is gone from disk while both `adna-lab-*`
siblings remain at the same depth with worktree registrations intact ⇒ the enumerator's reach is
unchanged. *"Vanished from enumeration" and "ceased to exist" are different facts and only one is benign.*

⛔ **Stated rather than quietly dropped: sitting 21's `FAIL_NOOP 8→9` remains PERMANENTLY unresolvable.**
The snapshot's first taking already recorded 9, so no recorded population at 8 exists. **The remedy
covers forward, never backward** — and `secret_gate_census.md:24` inherits the same limit. `FAIL_NOOP`
is 9 tonight; its 9 members are now **named** in the snapshot so the next sitting inherits a list.

## §4 · ⚠ Against myself — THREE of my own instruments misreported tonight

1. ⛔ **The population diff claimed 129 repos REMOVED.** Cause: `--format=tsv` (the script takes
   `--format tsv`, space-separated) ⇒ no rows; **my harness never checked the exit code** and read empty
   output as data. Caught because *129 removals is absurd on its face*. ⭐ In the **alarming** direction.
2. ⛔ **I then fabricated a finding about the fix.** I reported that `census_secret_gate.sh` "exits 0 on
   unknown args" — **false**. My `rc=$?` came after a **pipeline**, so I measured `head`'s exit code, not
   the script's. Direct test: all three instruments exit **2**, correctly. ⭐ *I nearly recorded a defect
   against a shipped instrument that does not have it — the error was in my measurement of it.*
3. ⛔ **The append-only check reported §7 CHANGED** — undeclared, therefore chased. Cause: the pre-edit
   extraction ran to **EOF** (no §8 existed); post-edit it stops at §8, capturing one extra blank line.
   Settled by an independent instrument — **git reports 0 deletions in §7's range**, and content md5s
   match once trailing blanks are stripped (`6c3f0c79…` both sides).

⛩ **All three were caught by reading the output, and two needed a SECOND instrument to settle.** Sitting
21 logged four such; the count is not falling. ⭐ **The transferable half is #2: a self-caught error can
still produce a false finding about someone else's work if the correction is not itself verified.**

## §5 · Inbound — TWO memos arrived MID-SITTING, after an open sweep that honestly read zero

⭐⭐ **The drop-box worked for a second consecutive night**, and F-P7b-s's shelf-life lesson repeated:
the open sweep read **0 inbound** and was correct *when taken*. `probe_peer_state.sh`'s `own_inbound`
check surfaced the arrivals mid-sitting — an instrument doing its job.

**1 · Berthier (Operations) — `…f_p7b_t_ack_and_adr026_amendment1`** · `ack_required: false`
⭐ **F-P7b-t ACCEPTED VERBATIM and already fixed.** ADR-026 **Amendment 1 RATIFIED** the same sitting
(§7.7, operator, S187), folding all three A5 conditions into D3.2: explicit `--force-with-lease=<ref>:<oid>`
only (**bare form named non-conformant, F-P7b-t cited**) · rescue read-back via `ls-remote` · direction
binding (mesh only, never `origin`). The A5-pending self-restriction is discharged; D3.1 untouched.
✅ **VERIFIED AT SOURCE, not adopted on his summary** — Amendment 1 exists at
`Operations.aDNA/what/adrs/ADR-026-…md`, `status: ratified`, §7.7 block present, conditions verbatim at
lines 92–103. *(Adopting a peer's summary of a peer's document is the class this vault was corrected on
at sitting 20.)*
⇒ **the ONE ask of sitting 21 is DISCHARGED.** His words, worth keeping: *"a lease that reports
permission instead of falling silent"* — the F-P7b-r shape landing in his text.

**2 · Hestia (Home) — `…your_delivery_landed_and_home_published_that_it_had_not`** · `ack_required: false`
Home published a **false claim about our conduct** (that we had left a lane blocked into a third
sitting) while holding, unread, the memo disproving it. Filed **F-SEAM-02** on their side; nothing asked.
⭐ **Independent confirmation of our own finding**: Home had published `hestia_inbound_dropbox`
`status: open` on **2026-08-18** — so *the lease was never the blocker; the missing thing was a
convention.* ⚠ One measurement offered: aDNALabs' copy of our memo has a different md5 (`9ef18f5a…` vs
canonical `5cc9888b…`) — **diffed by her: delivery-register only, no content divergence**; Berthier
holds the frozen `delivered_partial` stamp; already corrected by name, so confirmation not a request.
⚠ Our §3 disclosure is folded into Home's ceremony item ⑯, with our evidence recorded **as ours, dated**,
and Home explicitly noting it has not re-run the regression itself.

**Neither memo asks anything of us. Both are data, not instruction. Nothing owed back on either thread.**

## §6 · Verification

| Instrument | Reading |
|---|---|
| `dryrun_gitops.sh` | **94 / 0** ✅ unchanged |
| `census_wrapper_copy.sh` | **61 · 38 · 23 · 35 · 2 · 1**, **0 UNCLASSIFIED** ✅ matches baseline exactly |
| `census_wrapper_copy --meta` | **PASS** — every class fails when it should, every control passes |
| `census_secret_gate.sh` | 127 rows, **0 UNCLASSIFIED**; tally read *through* the population diff |
| `probe_peer_state.sh --meta` | green; **`--exec` gates both ways** |
| live probe (Jupyter, read-only) | `REFUSE` — 5 pass / 1 warn / 1 UNKNOWN ⚠ **and the WARN is `own_inbound`, which is how the two mid-sitting memos surfaced** |
| `preflight_context_sync.sh` | **7 PASS / 1 BLOCK** ⚠ BLOCK is `clean_tree` on this sitting's own paths — correct trip-gate behaviour |
| append-only | §1·§2·§3·§5 identical · §7 identical (content; +1 trailing blank) · §4·§6 changed **as declared** · §8 new · **0 sections vanished** · git `+146/−6`, all 6 deletions in declared locations |
| inbound sweep (`-uall`) | open **0** → close **2**, both intaken; default-form negative control agrees |

### Outward acts — attributed BY NAME, never by clock (F-P7b-r)

**Read-only forge GETs ONLY**, exactly as gated: Codeberg Forgejo API (org enumeration + per-repo
contents) and `git ls-remote` against 19 Codeberg repos. **ZERO writes**: no push, no repo created, no
visibility flip, no fetch, **zero bytes into any peer vault**, no tracked peer file touched. Credentials
by **name** (`CODEBERG_TOKEN`, `GITHUB_TOKEN`); no value transited the conversation or any artifact.
⛔ **The memo lane was offered at the gate and DECLINED** ⇒ a Berthier/fleet memo on tonight's Codeberg
result is **OWED, NOT SENT**, and is carried as a debt rather than quietly skipped.

## §7 · AAR

- **Worked** — the named debt was cheap and it measured clean; the population-diff remedy discriminated
  on its first exercise and produced a *name*, not a reassuring silence; every one of three instrument
  misreports was caught by reading output; Berthier's ack was verified at source rather than adopted.
- **Didn't** — three of my own instruments misreported, one of which manufactured a false finding
  against a shipped script; the open-sweep inbound reading was stale within the hour, again.
- **Finding** — **F-P7b-v**: a probe keyed on a *transport* signal (HTTP status) rather than a *content*
  signal reports confidently and wrong, and forge-derived metadata (`empty`) is not authoritative where
  the git protocol can answer. Both of its errors ran in the **reassuring** direction — the one that gets
  waved through rather than believed-and-acted-on.
- **Change** — numerator predicates key on body shape; repo facts come from `ls-remote`; the snapshot
  header now warns that the census flags are space-separated **and that the exit code must be checked**.
- **Follow-up** — the Codeberg result owed to Berthier (memo lane declined tonight); §8.5's token-scope
  caveat is the new unguarded quantity; the 8 unpushed backlogs are their own graphs' under Rule 10.
