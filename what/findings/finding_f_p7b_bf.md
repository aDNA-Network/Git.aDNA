---
type: finding
finding_id: F-P7b-bf
status: open
class: move_indistinguishable_from_addition
opened: 2026-09-07
closed: null
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, r8, over_refusal, graduation, so6, adr_016_d4, adr_016_a1, f_p7b_bf]
---

# F-P7b-bf — R8 cannot distinguish a within-repo move from new content

## Shape

The 2026-09-07 winddown graduated 29 sitting entries **verbatim** from `STATE.md` to
`STATE_history.md`. The push was **REFUSED by R8** on two lines in `STATE_history.md`.

**Measured before deciding anything:**

| | |
|---|---|
| both flagged lines already on `origin/master` (in `STATE.md`) | **yes**, verified with `git show origin/master:STATE.md` |
| occurrences across `STATE.md` + `STATE_history.md` on origin | **4** |
| occurrences across both files locally | **4** |
| **net new disclosure** | ⭐ **ZERO** |

R8 at 4.2.0 checks **the lines a push would ADD** (correctly scoped to ADR-016 D4 — the historical
body is out of scope by doctrine). A **move** presents as an addition in the destination file, because
the scope is computed per-file and nothing compares against the same content's prior location.

## Status

⛔ **OPEN, and it is an over-refusal rather than a false negative — the safe direction.** It is also
**predicted in the instrument's own header**: *"⚠ A RENAME presents as all-new and BLOCKS. Fail-safe,
stated here rather than discovered."* ⇒ A **documented limitation meeting its first real case**, not a
defect discovered in the field. ADR-016 A1 §2 already contemplates the over-refusal class.

⚠ **Why it matters beyond one push: graduation is the prescribed remedy and it will recur.** `STATE.md`
crossed the read cap once and will again; SO-6 (archive-never-delete) means the remedy is always a
**verbatim move**; and every such move will hit this. The three resolutions that do NOT work are worth
naming so they are not re-proposed:

- ⛔ **pragma-allowlist the lines** — edits the graduated record, destroying the byte-identical property
  that makes a graduation trustworthy at all.
- ⛔ **redact in the graduated copy** — same, and it is content already public.
- ⛔ **weaken the R8 pattern** — refused three times before, on the record. Still refused.

**The real fix is to teach the scope about moves**: when an added line's content already exists in the
push's *base* tree anywhere in the repo, it is a relocation, not a disclosure. ⚠ That is a genuine
change to a live publication gate and must not be improvised — it needs its own sitting, its own
negative control, and a demonstration that it cannot be used to launder genuinely new content
(the obvious attack: add the line to a scanned file, then "move" it).

**Interim disposition 2026-09-07 — ONE-TIME BYPASS, OPERATOR-AUTHORIZED, RECORDED HERE BEFORE IT WAS
USED.** The push went out with `--no-verify` after the following were established:

- ⭐ **Zero new disclosure, measured** — both lines already on `origin/master`; 4 occurrences before,
  4 after, across the same two files.
- ⛔ **`--no-verify` skips BOTH gates, not just the refusing one.** So `pre-push-secret-scan.sh`
  (gitleaks, the older and higher-severity control) was **run manually over the identical outgoing
  range first: CLEAN, rc=0.** ⛩ *A bypass that silently drops an unrelated control is a second defect
  wearing the first one's authorisation.*
- The sanitize gate's **only** findings were the two R8 move lines — nothing else was suppressed.

⚠ **This is a bypass of a correct control, not a refutation of it.** R8 was right about what it can
see. The authorisation covers **this push only**; the next graduation must not treat it as precedent —
it must either carry its own measurement and gate, or wait for the move-aware scope.
