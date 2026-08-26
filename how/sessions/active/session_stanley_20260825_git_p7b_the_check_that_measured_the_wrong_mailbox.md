---
type: session
session_id: session_stanley_20260825_git_p7b_the_check_that_measured_the_wrong_mailbox
date: 2026-08-25        # twenty-third sitting (FIRST on this local date). Act timestamps UTC.
persona: hopper
executor_tier: opus
status: active
campaign: campaign_git_genesis
phase: "P7b — a peer files a defect against our send gate, and verifying it finds a second one in the same check"
door: "§1 open sweep · §2 intake both inbound · §3 repair check_own_inbound · §4 extend --meta · §5 doctrine · §6 findings · §7 memo + delivery · §8 verify · §9 close"
plan: please-read-the-claude-md-stateless-salamander
head_at_open: 5acf73a
head_at_close: see tracking commit (this sitting)
inbound_at_open: "2 — MEASURED with `git ls-files --others --exclude-standard`, not `git status` (F-DF-145: the default form collapses an all-untracked directory to one line, and one of the two sits in the drop-box `who/coordination/inbox/`). (1) Galileo/Jupyter — F-DF-215 against `probe_peer_state.sh`; (2) Ilmarinen/Forgejo — M10 upgrade-window close report (cc). Both `ack_required: false`."
inbound_at_close: "TBD — re-swept before the closing commit (both-ends doctrine). Both prior sittings took live delivery mid-sitting; the reading at open is provisional by construction."
leases_at_open: "ours 0 (`how/sessions/active/` held only .gitkeep before this file). Peer leases deliberately UNPROBED at open — probing them here would produce exactly the stale reading F-P7b-i is about. The one delivery this sitting is gated at the act, in the same command as the act."
outward: partial        # DECLARED: exactly ONE act — the Galileo memo drop into Jupyter.aDNA/who/coordination/, gated by probe --exec. NO push, NO forge call, NO repo created, NO visibility flip, NO .adna/ edit. Berthier's Codeberg memo stays STAGED by last sitting's ruling.
crash_recovery: "The twenty-second sitting crashed after its close commit. VERIFIED, not assumed — FIFTH consecutive sitting to open this way, and the check stays ritual because it is cheap: `5acf73a` is a session-close commit carrying STATE + CHANGELOG + the session file already in `history/2026-08/`; `how/sessions/active/` held only `.gitkeep`; the only untracked paths are the two inbound. The crash cost the conversation, not the vault."

operator_rulings:
  - "fix shape for F-DF-215 = Galileo's shapes 2+3 COMBINED — refuse without `--self`, AND name the vault in the output. Shape 1 (default to $PWD's vault) was offered and DECLINED: it replaces one silent default with another, and a silent default is the fail-open class this vault has filed repeatedly. Shape 3 alone was offered and declined as insufficient — it makes a wrong reading visible without correcting it. (AskUserQuestion, plan gate)"
  - "disposition of the SECOND defect (ours, F-P7b-w) = RESOLVE THE SURFACE, and return UNKNOWN — never PASS — when no coordination surface is found. Two alternatives offered and not taken: resolve-but-PASS-if-none (preserves a fail-open for the one vault measured to have no surface), and file-without-patching (leaves WGS's undispositioned inbound invisible to the gate meanwhile)."
  - "outward lane = GALILEO ONLY. The Berthier Codeberg 19/19 memo was offered as a second drop and DECLINED ⇒ it remains OWED and STAGED, unsent by ruling for a second consecutive sitting, and is recorded that way rather than quietly dropped."

declared_paths:
  - how/tests/probe_peer_state.sh                        # check_own_inbound repaired (both fail-opens) + --meta extended with
                                                         #   FULL-PROCESS arms. The `ls-files --others --exclude-standard`
                                                         #   call is NOT touched — its header records that its F-DF-145
                                                         #   immunity is ACCIDENTAL and survives only until someone
                                                         #   refactors it to the obvious `git status` idiom.
  - how/sessions/AGENTS.md                               # the both-ends doctrine table hardcodes who/coordination/ — the SAME
                                                         #   defect one level up, in the doctrine binding every session.
  - who/coordination/inbox/                              # Galileo's memo intaken (tracked, not moved — the drop-box is where
                                                         #   he addressed it and provenance is the point)
  - who/coordination/coord_2026_08_24_ilmarinen_to_consumers_upgrade_window_close_report.md
  - who/coordination/coord_2026_08_25_hopper_to_galileo_the_second_defect_in_the_check_you_filed.md   # NEW — the one outward act
  - STATE.md
  - CHANGELOG.md
  - how/sessions/active/ → how/sessions/history/2026-08/

why_this_sitting: |
  A peer filed a defect against an instrument this vault ships and other vaults call as a send gate.
  That is the first time that has happened to `probe_peer_state.sh`, and the memo is careful in a way
  that makes it cheap to act on: Galileo routed rather than patched (Rule 10), wrote nothing into our
  tree, delivered on a corrected reading rather than the defective one, and stated in §4 that the fix
  shape is ours to choose.

  Verifying his claim at source — this vault does not adopt a peer's summary — confirmed it exactly,
  and turned up a SECOND fail-open in the same check that his memo does not name and his proposed
  fixes do not close. The check hardcodes `who/coordination/`, and F-P7b-n — documented in this very
  file, one check above — already established that fleet coordination surfaces differ. `WGS.aDNA`
  holds one of OUR memos undispositioned in `who/comms/` right now, and the check reports PASS for it.

  ⭐ The reason to run tonight is not that one peer's send gate misreported. It is that the defect
  Galileo found and the defect he did not are the same defect wearing two hats — an implicit argument
  nobody passes and an implicit path nobody checks — and both survived a meta-control that injects the
  very flag a real caller omits.

# ---------------------------------------------------------------------------
# §1 — Open sweep (recorded at open; provisional by construction)
# ---------------------------------------------------------------------------
open_sweep:
  head: 5acf73a
  tree: "clean apart from the 2 untracked inbound"
  active_leases_ours: 0
  probed_at: 2026-08-26T05:51:48Z

# ---------------------------------------------------------------------------
# §2 — Verified at source BEFORE planning (Galileo's claim)
# ---------------------------------------------------------------------------
verification_at_source:
  - "line 100  SELF_VAULT=\"$(cd \"$HERE/../..\" && pwd)\"  — defaults to the SCRIPT's repo — ✅ exact"
  - "line 343  check_own_inbound \"$SELF_VAULT\"  — the only check not taking --target — ✅ exact"
  - "line 110  --self exists but is silently defaulted — ✅ exact"
  - "fail-open mechanism: a caller with a dirty box reads PASS whenever OURS is clean — ✅ confirmed"
  - "lines 459/464: the two full-process --meta arms pass --self \"$d\" EXPLICITLY; every other arm calls the check function directly, bypassing argument parsing entirely ⇒ the default arm is NEVER exercised — ✅ confirmed"

# ---------------------------------------------------------------------------
# §3 — The second defect, measured live (ours, not Galileo's)
# ---------------------------------------------------------------------------
second_defect_measurement:
  method: "replicated check_own_inbound's exact command per candidate caller; read-only"
  probed_at: 2026-08-26T05:51:48Z
  rows:
    - "WGS.aDNA            who/coordination/ -> 0   |  who/comms/ -> 1 undispositioned inbound (OURS: coord_2026_08_24_hopper_to_wgs_you_wrote_my_repair_before_i_did.md)"
    - "operations_stanley.aDNA   no coordination surface at all -> would read 0 -> PASS"
    - "Jupyter.aDNA        who/coordination/ -> 0"
    - "Git.aDNA            who/coordination/ -> 2   (this sitting's own inbound — the check measures US correctly)"
  consequence: "the check reports PASS for WGS *even with --self passed correctly*. Galileo's shapes 1 and 2 do not close this; shape 3 makes it visible but not correct."
---

# Session — the check that measured the wrong mailbox, and then the wrong drawer

Working log below; SITREP + AAR at close.
