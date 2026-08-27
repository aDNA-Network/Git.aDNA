#!/usr/bin/env bash
# send_memo.sh — deliver ONE coordination memo into ONE peer vault (Git.aDNA · Hopper).
#
#   run:  bash how/tests/send_memo.sh --memo who/coordination/coord_x.md --peer ~/aDNA/Foo.aDNA
#         bash how/tests/send_memo.sh --memo ... --peer ... --dry-run
#         bash how/tests/send_memo.sh --meta
#
# ---------------------------------------------------------------------------
# WHY THIS EXISTS — F-P7b-ad, 2026-08-27. "Our send has no send tool, and it showed twice."
#
#   Until today a delivery was a hand-assembled `cp` handed to probe_peer_state.sh --exec.
#   On 2026-08-26 that cost two measurable things, both in a peer's tree and both permanent:
#     (i)  the redaction check ran AFTER the `cp`. The memos were clean BY AUTHORSHIP, NOT BY
#          CONTROL. ⭐ A check that runs after the mutation is a detector, not a guard.
#     (ii) the `status:` stamp landed AFTER the `cp`, so both delivered copies froze at the
#          instant before their own delivery existed and read `status: staged` in the
#          recipient's tree while our record read delivered. Re-delivering the stamped copy
#          was attempted and CORRECTLY REFUSED on dest_collision. ⛩ The drift was recorded,
#          not forced — and it cannot now be repaired in place.
#
#   ⭐ Ilmarinen filed the identical defect as F-F53 on 2026-08-24, with a denominator we did
#   not have: 112 peer-held memos authored by his lane, 12 lying, across 7 vaults, back to
#   2026-08-10. F-F35 is real — no copy in the field can state its own hash — but it applies
#   to THE HASH ALONE, and both desks generalised it to the whole stamp block. That was the bug.
#
# ⇒ EVERYTHING EXCEPT THE HASH IS STAMPED BEFORE THE cp. The hash is written into the
#   RETAINED copy only, after. The two copies then differ by EXACTLY ONE LINE, which is the
#   irreducible residue.
#
# ⛔ TWO PROBE INVOCATIONS, ONE ACT — and the reason is not stylistic.
#   `delivered_to:` must name the RESOLVED destination, which only the probe knows (it may
#   redirect to a drop-box). And the probe must run IN THE SAME COMMAND AS THE ACT, or it has
#   re-created the stale reading F-P7b-i exists to prevent. Both cannot hold with one call.
#     STEP 2 discovers the route and CAUSES NOTHING.
#     STEP 4 re-measures everything and gates the copy.
#   No reading is carried across. ⛔ Having this program call dropbox_open() itself was
#   rejected: that is reimplementation of the probe's predicate, which is the exact defect
#   being closed one file over.
#
# ⛔ WHAT THIS PROGRAM DOES NOT DO. It does not commit, does not touch any index, does not
#   decide WHETHER to send, and does not reimplement any probe or boundary predicate. It has
#   no mandate to delete anything in a peer's tree, on any path, including failure paths.
#
# DOCTRINE — read before adding a step.
#   ADR-011 A4 §2(a) — an undeterminable reading is a refusal, never a pass.
#   ADR-011 A4 §6    — no instrument is trusted until DEMONSTRATED TO FAIL (`--meta`).
#   ADR-016 D6.1     — each graph owns its own remedy; we do not repair a peer's tree.
#   Standing Rule 10 — cross-vault writes are gated, never silent.
# ---------------------------------------------------------------------------
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SELF_VAULT="$(cd "$HERE/../.." && pwd)"
PROBE="$HERE/probe_peer_state.sh"
BOUNDARY="$HERE/check_send_boundary.sh"
SEND_CONTRACT_VERSION="0.1.0"
WRITE_DIR="who/coordination"

MEMO=""; PEER=""; DRY=0; MODE=send
while [ $# -gt 0 ]; do
  case "$1" in
    --memo) MEMO="$2"; shift 2 ;;
    --peer) PEER="$2"; shift 2 ;;
    --write-dir) WRITE_DIR="$2"; shift 2 ;;
    --dry-run) DRY=1; shift ;;
    --meta) MODE=meta; shift ;;
    -h|--help) sed -n '2,7p' "$0"; exit 0 ;;
    *) printf 'unknown arg: %s\n' "$1" >&2; exit 2 ;;
  esac
done

note() { printf '  %s\n' "$*"; }
die()  { printf '\n⛔ %s\n' "$1" >&2; [ -n "${2:-}" ] && printf '   %s\n' "$2" >&2; exit "${3:-2}"; }

# ===========================================================================
# Frontmatter mechanics. Generic; no contract machinery is imported.
#
# ⛔ FRONTMATTER-SCOPED, NEVER WHOLE-FILE. Our memos quote frontmatter field names in their
#   bodies constantly — this very file will be described in one. A `grep -c '^delivered_md5:'`
#   over the whole file counts prose. Ilmarinen shipped the whole-file form and measured the
#   cost at F-F76 (1 in 126); the lesson is taken here without repeating the interval.
# ===========================================================================
fm_bounds() {   # <file> -> "<start> <end>" 1-indexed line numbers of the --- fences, or empty
  awk 'BEGIN{n=0} /^---[[:space:]]*$/{n++; if(n==1)s=NR; else if(n==2){print s" "NR; exit}}' "$1" 2>/dev/null
}
fm_get() {      # <file> <key>
  local b; b="$(fm_bounds "$1")"; [ -n "$b" ] || return 0
  awk -v k="$2" -v s="${b% *}" -v e="${b#* }" '
    NR>s && NR<e && index($0, k ":")==1 { v=substr($0,length(k)+2); sub(/^[[:space:]]+/,"",v); print v; exit }' "$1"
}
fm_count() {    # <file> <key> -> number of top-level occurrences INSIDE the frontmatter
  local b; b="$(fm_bounds "$1")"; [ -n "$b" ] || { printf '0\n'; return; }
  awk -v k="$2" -v s="${b% *}" -v e="${b#* }" '
    NR>s && NR<e && index($0, k ":")==1 { c++ } END { print c+0 }' "$1"
}
fm_set() {      # <file> <key> <value>  — replace in place, or append just before the closing ---
  local f="$1" k="$2" v="$3" b t; b="$(fm_bounds "$f")" || return 1
  [ -n "$b" ] || return 1
  t="$(mktemp)"
  awk -v k="$k" -v v="$v" -v s="${b% *}" -v e="${b#* }" '
    NR>s && NR<e && index($0, k ":")==1 { if(!done){print k": "v; done=1} next }
    NR==e && !done { print k": "v; done=1 }
    { print }' "$f" > "$t" && mv "$t" "$f"
}
fm_del() {      # <file> <key>
  local f="$1" k="$2" b t; b="$(fm_bounds "$f")"; [ -n "$b" ] || return 1
  t="$(mktemp)"
  awk -v k="$k" -v s="${b% *}" -v e="${b#* }" '
    NR>s && NR<e && index($0, k ":")==1 { next } { print }' "$f" > "$t" && mv "$t" "$f"
}

# ===========================================================================
# THE SEND
# ===========================================================================
run_send() {
  local dest_rel route probe_out probe_rc guard dest_dir dest_file rc md5

  # ---------------------------------------------------------------- STEP 0
  [ -n "$MEMO" ] && [ -n "$PEER" ] || die "usage" "--memo <file> --peer <vault>" 2
  [ -f "$MEMO" ] || die "memo_missing" "$MEMO" 2
  # ⛔ NON-EMPTY. An empty file `cmp`s equal to an empty destination, so every verification
  #   below would pass for the emptiest possible reason.
  [ -s "$MEMO" ] || die "memo_empty" "$MEMO is zero bytes — an empty file verifies as delivered for the wrong reason" 2
  [ -n "$(fm_get "$MEMO" coord_id)" ] || die "no_coord_id" "$MEMO has no coord_id in its frontmatter" 2
  [ -d "$PEER" ] && [ -e "$PEER/.git" ] || die "peer_not_a_vault" "$PEER" 2
  # ⚠ The probe is mode 0644, not executable. An `[ -x ]` guard ported from a peer's sender
  #   would refuse every send on day one; `[ -r ]` is the correct question for a `bash X` call.
  [ -r "$PROBE" ] && [ -r "$BOUNDARY" ] || die "instrument_missing" "$PROBE / $BOUNDARY" 2

  printf '\nsend_memo %s\n' "$SEND_CONTRACT_VERSION"
  printf '  memo : %s\n  peer : %s\n\n' "$(basename "$MEMO")" "$(basename "$PEER")"

  # ---------------------------------------------------------------- STEP 1
  # ⛔ BEFORE the cp, and before the dry-run branch — both deliberately. Before the cp because
  #   redaction is the right remedy before publication and the wrong one after it. Before the
  #   dry run because a preview that cannot show a refusal is not a preview of what runs.
  note "STEP 1 — publication boundary"
  local bl bv
  bl="$(bash "$BOUNDARY" "$MEMO" --dest "$PEER" --quiet 2>&1)"
  bv="$(printf '%s\n' "$bl" | sed -n 's/.*verdict=\([A-Z_]*\).*/\1/p')"
  # ⛔ Dispatch on verdict=, never a substring: BOUNDARY_REFUSE and BOUNDARY_CLEAN share the
  #   prefix BOUNDARY_, and F-F49 is on the record twice for exactly this.
  case "$bv" in
    BOUNDARY_CLEAN)  note "  clean" ;;
    BOUNDARY_REFUSE)
      # ⚖ This mutates the retained memo on a refusal path. Named rather than hidden: this
      #   desk keeps no register, so the memo IS the record, and the alternative is that a
      #   refusal leaves no trace at all. It is the only write on this path.
      fm_set "$MEMO" status "staged_blocked_publication_boundary"
      printf '%s\n' "$bl" >&2
      note "  ⛔ the placeholder is <forge-overlay-addr> — SUGGESTED, not applied."
      note "  ⛔ this program does not edit your memo. if the send is right anyway, that is a"
      note "     decision to record, not a check to bypass."
      printf 'SEND_REFUSED reason=publication_boundary coord_id=%s peer=%s copied=no memo_status=staged_blocked_publication_boundary version=%s\n' \
        "$(fm_get "$MEMO" coord_id)" "$(basename "$PEER")" "$SEND_CONTRACT_VERSION"
      return 1 ;;
    *)
      # ⛔ ABSENT IS NOT CLEAN, and neither is unparseable.
      die "boundary_indeterminate" "verdict not understood: '${bv:-<none>}' :: $bl" 6 ;;
  esac

  # ---------------------------------------------------------------- STEP 2
  # Route discovery. Causes NOTHING — no --exec. Reads target_path:/route: off the trailer;
  # ⛔ never constructs them. If the peer's write-dir is dirty and they publish an open
  #   drop-box, the probe re-targets and says so, and `delivered_to:` must carry that.
  note "STEP 2 — route discovery (no --exec; this call causes nothing)"
  probe_out="$(bash "$PROBE" --target "$PEER" --write-dir "$WRITE_DIR" \
                 --dest-file "$(basename "$MEMO")" --self "$SELF_VAULT" 2>&1)"
  probe_rc=$?
  dest_rel="$(printf '%s\n' "$probe_out" | sed -n 's/^target_path: //p')"
  route="$(   printf '%s\n' "$probe_out" | sed -n 's/^route: //p')"
  [ -n "$dest_rel" ] || die "no_target_path" "the probe published no target_path: — refusing to guess a destination" 3
  note "  route=$route target_path=$dest_rel (rc=$probe_rc at discovery)"
  if [ "$probe_rc" -ne 0 ]; then
    printf '%s\n' "$probe_out" | grep -E '  (BLOCK|UNKNOWN|WARN) ' | sed 's/^/  /'
    fm_set "$MEMO" status "staged_blocked_peer_state"
    fm_set "$MEMO" delivered_state "refused"
    fm_set "$MEMO" delivered_guard "\"$(printf '%s' "$probe_out" | grep '^verdict:' | tr -d '"')\""
    # ⛔ NO delivered_to / delivered_on ON A REFUSAL. Claiming a destination for a thing that
    #   was not delivered is precisely the class of lie this program exists to close.
    fm_del "$MEMO" delivered_to; fm_del "$MEMO" delivered_on
    printf 'SEND_REFUSED reason=peer_state coord_id=%s peer=%s copied=no memo_status=staged_blocked_peer_state version=%s\n' \
      "$(fm_get "$MEMO" coord_id)" "$(basename "$PEER")" "$SEND_CONTRACT_VERSION"
    return 3
  fi
  dest_dir="$PEER/${dest_rel%/}"
  dest_file="$dest_dir/$(basename "$MEMO")"
  [ -d "$dest_dir" ] || die "dest_missing" "$dest_dir (the probe said target_path=$dest_rel)" 2

  # ---------------------------------------------------------------- STEP 3
  note "STEP 3 — strip residue, then stamp (BEFORE the cp)"
  # Strip any prior leg's hash first, so the post-cp residue is a CLOSED SET OF ONE.
  fm_del "$MEMO" delivered_md5
  [ "$(fm_count "$MEMO" delivered_md5)" -eq 0 ] || die "residue" "delivered_md5 survived the strip" 2
  fm_set "$MEMO" status          "delivered"
  fm_set "$MEMO" delivered_to    "$(basename "$PEER")/${dest_rel%/}/"
  fm_set "$MEMO" delivered_on    "$(date -u +%Y-%m-%d)"
  fm_set "$MEMO" delivered_state "untracked_peer_side"
  guard="$(printf '%s' "$probe_out" | grep '^probe:' | tr -d '"')"
  # ⚠ Double-quoted always: the guard line contains colons, and a bare colon-space in a plain
  #   YAML scalar is a mapping. Assert it holds no quote of its own before writing it.
  case "$guard" in *'"'*) die "guard_quote" "probe summary contains a double quote" 2 ;; esac
  fm_set "$MEMO" delivered_guard "\"$guard | route=$route\""
  # ⭐ THE PLACEHOLDER PRECONDITION. `delivered_on: TBD` is live in a peer's tree right now, in
  #   a memo this desk delivered — a placeholder that survived into the record. Frontmatter-
  #   scoped, so a body that discusses TBD is untouched.
  #
  # ⚠ STATE ITS ACTUAL REACH, because the first version of this comment overclaimed and the
  #   meta-control caught it. This check runs AFTER the stamp block, and the stamp block
  #   OVERWRITES `status`, `delivered_to`, `delivered_on`, `delivered_state`,
  #   `delivered_guard`. A `TBD` in any of those five is not *caught* here — it is
  #   STRUCTURALLY IMPOSSIBLE, because we set them ourselves. That is the stronger remedy for
  #   the live instance, and it is a different remedy from the one this check provides.
  #   ⇒ What this check actually reaches is every OTHER frontmatter field — author-written
  #   ones like `relates:`, `in_reply_to:`, `ack_required:` — where a placeholder would
  #   otherwise ride into a peer's tree unexamined. The arm tests one of those, deliberately,
  #   because an arm on a stamped field would pass for a reason unrelated to this check.
  local b; b="$(fm_bounds "$MEMO")"
  if awk -v s="${b% *}" -v e="${b#* }" 'NR>s && NR<e' "$MEMO" \
       | grep -qE ':[[:space:]]*(TBD|TODO|<[a-z_-]+>)[[:space:]]*(#.*)?$'; then
    die "placeholder_in_stamp" "the frontmatter still carries TBD/TODO/<placeholder> — it would be delivered as-is" 2
  fi
  note "  status=delivered delivered_to=$(basename "$PEER")/${dest_rel%/}/"

  if [ "$DRY" -eq 1 ]; then
    printf '\nSEND_DRYRUN verdict=would_send coord_id=%s peer=%s route=%s dest=%s copied=no version=%s\n' \
      "$(fm_get "$MEMO" coord_id)" "$(basename "$PEER")" "$route" "$dest_file" "$SEND_CONTRACT_VERSION"
    return 0
  fi

  # ---------------------------------------------------------------- STEP 4
  # The gated act. The probe re-measures EVERYTHING here — leases, dirt, collision — and the
  # cp runs only inside its GO. Nothing from STEP 2 is trusted.
  note "STEP 4 — the gated act (probe re-measures; cp runs only inside a GO)"
  probe_out="$(bash "$PROBE" --target "$PEER" --write-dir "${dest_rel%/}" \
                 --dest-file "$(basename "$MEMO")" --self "$SELF_VAULT" \
                 --exec "cp -- '$MEMO' '$dest_file'" 2>&1)"
  probe_rc=$?
  # ⛔ DO NOT DISPATCH ON THE EXIT CODE. --exec exits 3 on REFUSE and with the cp's status on
  #   GO; a cp exiting 3 is indistinguishable from a refusal. Read the verdict line, and read
  #   the --exec exit line separately.
  local verdict exec_exit
  verdict="$(  printf '%s\n' "$probe_out" | sed -n 's/^verdict: \([A-Z]*\).*/\1/p')"
  exec_exit="$(printf '%s\n' "$probe_out" | sed -n 's/^--exec exit : //p')"
  if [ "$verdict" != GO ]; then
    printf '%s\n' "$probe_out" | grep -E '  (BLOCK|UNKNOWN) ' | sed 's/^/  /'
    fm_set "$MEMO" status "staged_blocked_peer_state"
    fm_set "$MEMO" delivered_state "refused_at_act"
    fm_del "$MEMO" delivered_to; fm_del "$MEMO" delivered_on
    printf 'SEND_REFUSED reason=peer_state_at_act coord_id=%s peer=%s copied=no memo_status=staged_blocked_peer_state version=%s\n' \
      "$(fm_get "$MEMO" coord_id)" "$(basename "$PEER")" "$SEND_CONTRACT_VERSION"
    return 3
  fi

  # ---------------------------------------------------------------- STEP 5
  note "STEP 5 — verify"
  # ⛔ NO ROLLBACK ON FAILURE — CORRECT FORWARD. Three reasons, in this vault's own terms:
  #   (1) a rollback is a write on a failure path, the least-tested code in any program;
  #   (2) it destroys the evidence that a send was ATTEMPTED — the memo would read `staged`
  #       and nothing would distinguish "tried and failed" from "never tried", which is the
  #       fact a retry decision turns on;
  #   (3) it would make the stamp a hope rather than a fact.
  #   ⭐ And it is SAFE here in a way the delivered-copy drift was not: a failed cp leaves
  #     NOTHING in the peer's tree, so there is no field copy to disagree with. The retained
  #     memo is a local file we own.
  if [ "${exec_exit:-1}" -ne 0 ] || [ ! -s "$dest_file" ]; then
    fm_set "$MEMO" status "staged_send_failed"
    fm_set "$MEMO" delivered_state "cp_failed"
    fm_set "$MEMO" delivered_error "rc=${exec_exit:-unknown} dest=$dest_file"
    fm_del "$MEMO" delivered_to; fm_del "$MEMO" delivered_on
    printf 'SEND_DRIFT reason=cp_failed coord_id=%s peer=%s dest=%s memo_status=staged_send_failed version=%s\n' \
      "$(fm_get "$MEMO" coord_id)" "$(basename "$PEER")" "$dest_file" "$SEND_CONTRACT_VERSION"
    return 4
  fi
  # ⛔ The exclusion list is EMPTY at this instant, and that is the design. Asserting
  #   byte-identity BEFORE anything is added makes the post-cp residue a CLOSED, ENUMERABLE
  #   SET OF ONE. An exclusion list can only ever fail to notice a line it excludes.
  if ! cmp -s "$MEMO" "$dest_file"; then
    fm_set "$MEMO" status "staged_send_indeterminate"
    fm_set "$MEMO" delivered_state "partial_unverified"
    # ⛔ DO NOT DELETE IT. This program has no mandate to delete in a peer's tree, and a
    #   failure path is the worst possible place to invent one. Surface it.
    printf 'SEND_DRIFT reason=partial_unverified coord_id=%s peer=%s dest=%s memo_status=staged_send_indeterminate version=%s\n' \
      "$(fm_get "$MEMO" coord_id)" "$(basename "$PEER")" "$dest_file" "$SEND_CONTRACT_VERSION"
    return 5
  fi
  note "  cmp: byte-identical at copy time (empty exclusion list)"

  # The one-line delta. RETAINED ONLY — F-F35: no copy in the field can state its own hash.
  md5="$(md5 -q "$dest_file" 2>/dev/null || md5sum "$dest_file" | awk '{print $1}')"
  fm_set "$MEMO" delivered_md5 "$md5"
  [ "$(fm_count "$MEMO" delivered_md5)" -eq 1 ] || die "residue" "retained copy has $(fm_count "$MEMO" delivered_md5) delivered_md5 lines, want 1" 2
  [ "$(fm_count "$dest_file" delivered_md5)" -eq 0 ] || die "residue" "the DELIVERED copy carries delivered_md5 — it cannot state its own hash" 2
  local delta; delta=$(( $(wc -l < "$MEMO") - $(wc -l < "$dest_file") ))
  [ "$delta" -eq 1 ] || die "residue" "retained/delivered differ by $delta lines, want exactly 1" 2
  note "  delta: exactly 1 line (delivered_md5, retained only)"
  note "  delivered copy reads status=$(fm_get "$dest_file" status)"

  printf '\nSEND_OK coord_id=%s peer=%s route=%s target_path=%s dest=%s md5=%s retained_uncommitted=yes version=%s\n' \
    "$(fm_get "$MEMO" coord_id)" "$(basename "$PEER")" "$route" "$dest_rel" "$dest_file" "$md5" "$SEND_CONTRACT_VERSION"
  return 0
}

# ===========================================================================
# --meta : the meta-control (ADR-011 A4 §6). Fixture peers only; no real vault is touched.
# ===========================================================================
run_meta() {
  printf '\nmeta-control — each failure path must be demonstrated (ADR-011 A4 §6)\n\n'
  local bad=0 root d peer memo out rc
  root="$(mktemp -d)"
  local A="10.$((40+3)).0.$((14*2))"

  mk_peer() {   # <name> [dropbox] -> path
    local p="$root/$1"; mkdir -p "$p/who/coordination"
    git -C "$p" init -q; git -C "$p" config user.email m@l; git -C "$p" config user.name m
    mkdir -p "$p/how/sessions/active"; : > "$p/how/sessions/active/.gitkeep"
    echo seed > "$p/who/coordination/.gitkeep"
    if [ "${2:-}" = dropbox ]; then
      mkdir -p "$p/who/coordination/inbox"
      printf -- '---\ntype: convention\nstatus: open\n---\n# box\n' > "$p/who/coordination/inbox/README.md"
    fi
    git -C "$p" add -A >/dev/null 2>&1; git -C "$p" commit -qm base >/dev/null 2>&1
    printf '%s\n' "$p"
  }
  mk_memo() {   # <name> <body> -> path
    local m="$root/$1.md"
    printf -- '---\ntype: coordination\ncoord_id: %s\nstatus: staged\n---\n\n%b\n' "$1" "$2" > "$m"
    printf '%s\n' "$m"
  }
  run() { out="$(bash "$0" --memo "$1" --peer "$2" "${@:3}" 2>&1)"; rc=$?; }
  want() {  # <label> <want rc> <want trailer substring>
    if [ "$rc" -eq "$2" ] && printf '%s\n' "$out" | grep -q "$3"; then
      printf '  ok    %-40s (rc=%s)\n' "$1" "$rc"
    else printf '  FAIL  %-40s wanted rc=%s + "%s", got rc=%s :: %s\n' "$1" "$2" "$3" "$rc" "$(printf '%s' "$out"|tr '\n' '|')"; bad=1; fi
  }

  printf '  -- the happy path, and the residue that proves it --\n'
  peer="$(mk_peer happy)"; memo="$(mk_memo clean_one 'a memo about nothing')"
  run "$memo" "$peer"; want "clean memo -> SEND_OK" 0 "SEND_OK"
  local dest="$peer/who/coordination/clean_one.md"
  [ -f "$dest" ] && printf '  ok    %-40s\n' "delivered copy exists" || { printf '  FAIL  delivered copy missing\n'; bad=1; }
  # ⭐ THE ARM F-P7b-ad(ii) IS ABOUT. The delivered copy must read `delivered`, not `staged`.
  if [ "$(fm_get "$dest" status)" = delivered ]; then printf '  ok    %-40s (F-P7b-ad(ii) inverse)\n' "delivered copy reads status=delivered"
  else printf '  FAIL  %-40s got status=%s\n' "delivered copy reads status=delivered" "$(fm_get "$dest" status)"; bad=1; fi
  [ "$(fm_count "$dest" delivered_md5)" -eq 0 ] && printf '  ok    %-40s (F-F35)\n' "delivered copy has NO delivered_md5" \
    || { printf '  FAIL  delivered copy states its own hash\n'; bad=1; }
  [ "$(fm_count "$memo" delivered_md5)" -eq 1 ] && printf '  ok    %-40s\n' "retained copy has exactly one" \
    || { printf '  FAIL  retained delivered_md5 count wrong\n'; bad=1; }
  [ $(( $(wc -l < "$memo") - $(wc -l < "$dest") )) -eq 1 ] && printf '  ok    %-40s\n' "delta is exactly one line" \
    || { printf '  FAIL  delta is not one line\n'; bad=1; }

  printf '\n  -- refusal paths: nothing is copied, and nothing claims a destination --\n'
  peer="$(mk_peer boundary)"; memo="$(mk_memo dirty_one "the forge runs at $A today")"
  run "$memo" "$peer"; want "boundary refuse -> copied=no" 1 "SEND_REFUSED reason=publication_boundary"
  [ ! -e "$peer/who/coordination/dirty_one.md" ] && printf '  ok    %-40s\n' "nothing copied on boundary refuse" \
    || { printf '  FAIL  a refused memo was copied\n'; bad=1; }
  # ⛔ and the refusal must not have printed the string it refused
  printf '%s\n' "$out" | grep -qF "$A" && { printf '  FAIL  the refusal printed the denied string\n'; bad=1; } \
    || printf '  ok    %-40s\n' "refusal output stays redacted"

  peer="$(mk_peer leased)"; memo="$(mk_memo leased_one 'clean body')"
  printf -- '---\nstatus: active\ndeclared_files:\n  - who/coordination/\n---\n' > "$peer/how/sessions/active/session_x.md"
  run "$memo" "$peer"; want "peer lease refuse -> copied=no" 3 "SEND_REFUSED reason=peer_state"
  # ⭐ THE ARM THAT MATTERS ON A REFUSAL: no delivered_to may survive.
  [ -z "$(fm_get "$memo" delivered_to)" ] && printf '  ok    %-40s (no false destination claim)\n' "refused memo has NO delivered_to" \
    || { printf '  FAIL  a refused memo claims delivered_to=%s\n' "$(fm_get "$memo" delivered_to)"; bad=1; }

  printf '\n  -- the placeholder precondition (live in a peer tree right now) --\n'
  # ⚠ The arm uses a NON-STAMPED field. Using `delivered_on: TBD` — the live instance — was
  #   the first cut, and it went green-by-accident: STEP 3 overwrites that field before the
  #   check runs, so the send succeeded and the arm was testing nothing. ⭐ The meta-control
  #   caught it, which is the entire argument for having one.
  peer="$(mk_peer ph)"; memo="$(mk_memo ph_one 'clean body')"
  fm_set "$memo" in_reply_to "TBD"
  run "$memo" "$peer"; want "TBD in an author field -> refuse" 2 "placeholder_in_stamp"
  # ...and the paired arm: the five STAMPED fields cannot carry a placeholder at all, because
  # this program writes them. Different remedy, asserted separately so neither is assumed.
  peer="$(mk_peer ph2)"; memo="$(mk_memo ph2_one 'clean body')"
  fm_set "$memo" delivered_on "TBD"
  run "$memo" "$peer"
  if [ "$rc" -eq 0 ] && [ "$(fm_get "$memo" delivered_on)" != TBD ]; then
    printf '  ok    %-40s (overwritten, not caught — a stronger remedy)\n' "TBD in a STAMPED field -> impossible"
  else printf '  FAIL  %-40s rc=%s delivered_on=%s\n' "TBD in a STAMPED field -> impossible" "$rc" "$(fm_get "$memo" delivered_on)"; bad=1; fi

  printf '\n  -- preconditions --\n'
  peer="$(mk_peer pre)"; memo="$root/empty.md"; printf -- '---\ncoord_id: e\n---\n' > "$memo"
  : > "$memo"; run "$memo" "$peer"; want "empty memo -> refuse" 2 "memo_empty"
  memo="$(mk_memo noid 'body')"; fm_del "$memo" coord_id
  run "$memo" "$peer"; want "no coord_id -> refuse" 2 "no_coord_id"

  printf '\n  -- the drift arm: cp fails AFTER a successful stamp --\n'
  peer="$(mk_peer driftp)"; memo="$(mk_memo drift_one 'clean body')"
  chmod 500 "$peer/who/coordination"
  run "$memo" "$peer"; want "unwritable dest -> SEND_DRIFT" 4 "SEND_DRIFT reason=cp_failed"
  # ⛔ the memo must NOT read `staged` — that would be indistinguishable from "never tried"
  [ "$(fm_get "$memo" status)" = staged_send_failed ] && printf '  ok    %-40s (tried-and-failed is recorded)\n' "drift memo reads staged_send_failed" \
    || { printf '  FAIL  drift memo reads status=%s\n' "$(fm_get "$memo" status)"; bad=1; }
  [ -z "$(fm_get "$memo" delivered_to)" ] && printf '  ok    %-40s\n' "drift memo has NO delivered_to" \
    || { printf '  FAIL  drift memo claims a destination\n'; bad=1; }
  chmod 700 "$peer/who/coordination"

  printf '\n  -- the drop-box route: delivered_to must name the RESOLVED path --\n'
  peer="$(mk_peer boxed dropbox)"; memo="$(mk_memo boxed_one 'clean body')"
  echo edited >> "$peer/who/coordination/.gitkeep"      # dirty the parent -> redirect
  run "$memo" "$peer"; want "dirty parent + box -> SEND_OK" 0 "route=dropbox"
  case "$(fm_get "$memo" delivered_to)" in
    */who/coordination/inbox/) printf '  ok    %-40s (read off target_path, not constructed)\n' "delivered_to names the drop-box" ;;
    *) printf '  FAIL  %-40s got %s\n' "delivered_to names the drop-box" "$(fm_get "$memo" delivered_to)"; bad=1 ;;
  esac
  [ -f "$peer/who/coordination/inbox/boxed_one.md" ] && printf '  ok    %-40s\n' "the copy landed in the box" \
    || { printf '  FAIL  copy did not land in the box\n'; bad=1; }

  printf '\n  -- dry-run previews the real thing and copies nothing --\n'
  peer="$(mk_peer dry)"; memo="$(mk_memo dry_one 'clean body')"
  run "$memo" "$peer" --dry-run; want "dry-run -> would_send" 0 "SEND_DRYRUN verdict=would_send"
  [ ! -e "$peer/who/coordination/dry_one.md" ] && printf '  ok    %-40s\n' "dry-run copied nothing" \
    || { printf '  FAIL  dry-run copied a file\n'; bad=1; }

  printf '\n  -- fm_count is frontmatter-scoped, not whole-file (F-F76 without the interval) --\n'
  memo="$(mk_memo scoped 'this body mentions delivered_md5: deadbeef in prose')"
  [ "$(fm_count "$memo" delivered_md5)" -eq 0 ] && printf '  ok    %-40s\n' "body mention is not counted" \
    || { printf '  FAIL  fm_count counted a body line\n'; bad=1; }

  rm -rf "$root"
  printf '\n---\nmeta-control: %s\n' \
    "$([ "$bad" -eq 0 ] && echo 'every failure path demonstrated; the happy path verified by residue' \
                        || echo 'DEFECT — see FAIL rows above')"
  [ "$bad" -eq 0 ]
}

case "$MODE" in meta) run_meta; exit $? ;; esac
run_send
