#!/usr/bin/env bash
# check_send_boundary.sh — the SEND-end publication boundary (Git.aDNA · ADR-016).
#
# Answers ONE question, before a memo is copied anywhere: does this file carry material
# ADR-016 D2 rules unpublishable?
#
#   run:  bash how/tests/check_send_boundary.sh <memo> [--dest <peer vault>]
#         bash how/tests/check_send_boundary.sh --meta
#
# READ-ONLY. It never edits the memo. ⛔ IT SUGGESTS; IT NEVER REDACTS — rewriting a memo
# mid-send would change the artifact a peer verifies, and content is the author's act. On a
# refusal it stops and says why; the author edits, or records that the send is right anyway.
#
# ---------------------------------------------------------------------------
# WHY THIS EXISTS — F-P7b-ad(i), 2026-08-27.
#
#   Two memos were delivered on 2026-08-26 and their redaction was verified AFTER the `cp`.
#   They were clean — BY AUTHORSHIP, NOT BY CONTROL. ⭐ A check that runs after the mutation
#   is a detector, not a guard. Ilmarinen's send program does this before its copy and has
#   since 2026-08-24; this desk had no send path at all, only a hand-assembled `cp`.
#
# ⭐ ONE PREDICATE FILE, TWO ENFORCEMENT SURFACES — and that is the whole design.
#   This reads `sanitize_deny_content.txt`, the SAME file R8 reads in
#   how/standard/hooks/pre-push-sanitize.sh, with the SAME resolution order. It does not
#   carry a second copy of the pattern.
#
#   ⛔ THE REASON IS A MEASURED DEFECT, not tidiness. ADR-016 §C3: the ADR quoted 31, the
#   gate shipped a predicate matching 62, and after F-P7b-af's repair the true figure was 75.
#   *A reader could not predict what the gate would do from the figures in the document that
#   ships it.* A hand-written second predicate here would have been a FOURTH number.
#
# ⚠ AND WHAT IS **NOT** SHARED, stated because the asymmetry is deliberate.
#   The MATCHER — ERE validation, binary skip, the pragma escape, redacted reporting — is
#   reimplemented below rather than sourced. Standing Order #3: `pre-push-sanitize.sh` is
#   authored here and shipped to `.adna/` AS A SINGLE FILE for vaults that have no
#   how/tests/. A `source how/tests/lib/…` would create a dependency `.adna/` cannot satisfy,
#   and it would fail in the worst direction — a missing source under a shell without `-e`
#   fails OPEN.
#   ⇒ Sameness is held by a DIFFERENTIAL CONTROL over a shared corpus, in
#     how/tests/test_sanitize_content_gate.sh, which runs the same fixtures through the hook
#     and through this file and asserts the verdicts agree. That control would go RED on
#     drift. A shared library would merely make drift unlikely; a control makes it visible.
#
# ⚖ THE BOUND ON THAT CLAIM: the differential arm proves agreement ON THE CORPUS, not
#   everywhere. The corpus is one fixture per matcher semantic, so a drift in any of the five
#   is detectable rather than merely improbable — but "detectable" is the honest word.
#
# DOCTRINE — read before adding a check.
#   ADR-011 A4 §2(a) — fail-closed: a malformed pattern or unreadable deny file BLOCKS.
#   ADR-011 A4 §6    — no instrument is trusted until DEMONSTRATED TO FAIL (`--meta`).
#   ADR-016 D2/D5    — the unpublishable classes, and why a path rule cannot express them.
#   ADR-016 D6.4     — a zero must be falsified before it is recorded.
# ---------------------------------------------------------------------------
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT="$(cd "$HERE/../.." && pwd)"
BOUNDARY_CONTRACT_VERSION="0.1.0"

MEMO=""; DEST=""; MODE=check; QUIET=0
while [ $# -gt 0 ]; do
  case "$1" in
    --meta)  MODE=meta; shift ;;
    --dest)  DEST="$2"; shift 2 ;;
    --quiet) QUIET=1; shift ;;
    -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
    -*) printf 'unknown arg: %s\n' "$1" >&2; exit 2 ;;
    *)  MEMO="$1"; shift ;;
  esac
done

pass=0; block=0; unknown=0; advisory=0
check() {  # <name> <PASS|BLOCK|UNKNOWN|ADVISORY> <detail>
  case "$2" in
    PASS)     pass=$((pass+1));         printf '  PASS    %-18s %s\n' "$1" "$3" ;;
    ADVISORY) advisory=$((advisory+1)); printf '  ADVISE  %-18s %s\n' "$1" "$3" ;;
    BLOCK)    block=$((block+1));       printf '  BLOCK   %-18s %s\n' "$1" "$3" ;;
    *)        unknown=$((unknown+1));   printf '  UNKNOWN %-18s %s\n' "$1" "$3" ;;
  esac
}

# ⛔ Same resolution order as R8, stated as SHARED rather than re-derived. `.adna/` first,
#   then the vault, ADDITIVELY — both are read when both exist. `.adna/` does not exist in
#   this vault today, so the two coincide; that coincidence is an accident of the present
#   layout and must not be relied on, which is why the loop is written out.
deny_files() {
  local f
  for f in "$VAULT/.adna/sanitize_deny_content.txt" "$VAULT/sanitize_deny_content.txt"; do
    [ -e "$f" ] && printf '%s\n' "$f"
  done
}

# fails_when: no deny file resolves at all.
# why it matters: ⛔ ABSENT IS NOT CLEAN. A missing predicate file means the boundary was NOT
# evaluated, and a "no matches" line for a check that never ran is the exact lie F-F51 names.
check_deny_present() {
  local n; n="$(deny_files | grep -c .)"
  if [ "${n:-0}" -eq 0 ]; then
    check deny_present UNKNOWN "no sanitize_deny_content.txt resolved — the boundary was NOT checked, and that is not a pass"
    return 1
  fi
  check deny_present PASS "$n deny file(s) resolved (same order as R8)"
  return 0
}

# fails_when: a deny file exists but is unreadable, or carries a pattern grep rejects.
# ⛔ FAIL-CLOSED. A deny-list that silently skips the pattern it cannot compile is worse than
#   no deny-list, because it reports green. `grep -E` exits 0=matched, 1=no-match (pattern
#   fine), 2=bad pattern; only 2 is a defect and it is indistinguishable from 1 unless you look.
check_patterns_valid() {
  local df line rc bad=0 n=0
  while IFS= read -r df; do
    if [ ! -r "$df" ]; then
      check patterns_valid BLOCK "$(basename "$df") exists but is not readable (fail-closed)"; return 1
    fi
    while IFS= read -r line || [ -n "$line" ]; do
      case "$line" in ''|\#*|' '*\#*) continue ;; esac
      [ -z "${line//[[:space:]]/}" ] && continue
      n=$((n+1)); rc=0
      printf '' | grep -E "$line" >/dev/null 2>&1 || rc=$?
      [ "$rc" -gt 1 ] && { bad=$((bad+1)); }
    done < "$df"
  done < <(deny_files)
  if [ "$bad" -gt 0 ]; then
    check patterns_valid BLOCK "$bad malformed pattern(s) — fail-closed, and the pattern text is NOT echoed"; return 1
  fi
  check patterns_valid PASS "$n pattern(s) compile"
  return 0
}

# fails_when: the memo carries a line matching any deny pattern, without a pragma.
# ⛔ REPORTED REDACTED. This instrument must never print the string it exists to withhold —
#   a refusal that quotes the match is the next scan finding, one layer up.
check_content() {   # <file>
  local f="$1" df line lineno content hits=0 detail=""
  if [ ! -f "$f" ]; then check content UNKNOWN "no such file: $f"; return 1; fi
  if file --mime "$f" 2>/dev/null | grep -q 'charset=binary'; then
    check content PASS "binary file — skipped, as R8 skips it"; return 0
  fi
  while IFS= read -r df; do
    while IFS= read -r line || [ -n "$line" ]; do
      case "$line" in ''|\#*) continue ;; esac
      [ -z "${line//[[:space:]]/}" ] && continue
      while IFS=: read -r lineno content; do
        [ -z "$lineno" ] && continue
        printf '%s\n' "$content" | grep -qE 'pragma:[[:space:]]*allowlist' && continue
        hits=$((hits+1)); detail="$detail $(basename "$f"):$lineno"
      done < <(grep -nE "$line" "$f" 2>/dev/null || true)
    done < "$df"
  done < <(deny_files)
  if [ "$hits" -gt 0 ]; then
    check content BLOCK "$hits line(s) carry unpublishable material (redacted):$detail"
    return 1
  fi
  check content PASS "no deny match"
  return 0
}

# fails_when: nothing — this leg NEVER gates at v0.1.0. It reports and no more.
#
# ⛔ WHY THE DESTINATION DOES NOT DECIDE, and why this is a simplification rather than a
#   deferral. The decision is asymmetric:
#     · content CLEAN  ⇒ the destination cannot change the answer. A memo carrying nothing
#       publishes nothing, anywhere.
#     · content DIRTY  ⇒ the binding destination is OUR OWN TREE. `how/federation/git/CLAUDE.md`
#       declares this vault public with a live `origin`, and the retained copy is committed
#       into who/coordination/ as ordinary ritual. A dirty memo therefore publishes REGARDLESS
#       of the peer — through the one path where no gate is currently installed (F-P7b-ag).
#   ⇒ the peer's class is context for the reader, never a permission.
#
# ⚠ AND `dest=not_public` IS NOT "SAFE". `Forgejo.aDNA` is P-dev and opens to a public host at
#   release. Delivery there is a DEFERRED publication, which is why this says so out loud
#   rather than printing a reassuring line.
#
# ⛔ NO NETWORK CALL. If one is ever added, ADR-016 D6.4 binds it: a known-positive control
#   from the same vantage in the same run, or the verdict is UNKNOWN. A `403` is a rate limit,
#   not evidence of privacy — Ilmarinen's F-F82, where exactly that mapping fell open with a
#   green test standing over it.
check_dest_class() {   # <peer vault or empty>
  local p="$1" wr cls origin remote
  if [ -z "$p" ]; then check dest_class PASS "no --dest given — destination is context, never a permission"; return 0; fi
  wr="$p/how/federation/git/CLAUDE.md"
  if [ ! -f "$wr" ]; then check dest_class ADVISORY "$(basename "$p"): no git wrapper — class UNDECLARED, reported not gated"; return 0; fi
  # ⛔ POSITIONAL, never `grep -m1`. This vault's own wrapper carries TWO `visibility:` keys —
  #   the real one, and one inside a paste-this-into-your-vault TEMPLATE block. A first-match
  #   read gets the right one BY ORDERING LUCK. The mechanism test: a block describes THIS
  #   repo only if its declared origin equals the repo's actual origin. That tests for the
  #   presence of a mechanism, never for the absence of the word "template" (F-P7b-af's rule
  #   one instrument over).
  origin="$(git -C "$p" remote get-url origin 2>/dev/null)"
  remote="$(awk '/^[[:space:]]*origin:/{print $2; exit}' "$wr" 2>/dev/null)"
  cls="$(awk '/^[[:space:]]*visibility:/{print $2; exit}' "$wr" 2>/dev/null | tr -d ' ')"
  if [ -n "$origin" ] && [ -n "$remote" ] && [ "$origin" != "$remote" ]; then
    check dest_class ADVISORY "$(basename "$p"): wrapper origin does not match the live remote — declaration not trusted, class reported as UNDECLARED"
    return 0
  fi
  case "$cls" in
    public)  check dest_class ADVISORY "$(basename "$p"): declares PUBLIC — a clean memo is still clean, but note where it lands" ;;
    private) check dest_class ADVISORY "$(basename "$p"): declares private — ⚠ NOT 'safe': a P-dev repo opens to a public host at release, so this is a DEFERRED publication" ;;
    *)       check dest_class ADVISORY "$(basename "$p"): visibility undeclared or unreadable — reported, not gated" ;;
  esac
  return 0
}

run_check() {
  [ -n "$MEMO" ] || { printf 'usage: %s <memo> [--dest <peer vault>]\n' "$0" >&2; exit 2; }
  [ "$QUIET" -eq 1 ] || {
    printf '\ncheck_send_boundary — memo %s\n' "$MEMO"
    printf 'checked_at: %s   (this reading is valid for THIS file as it stands NOW)\n\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  }
  check_deny_present   || true
  check_patterns_valid || true
  check_content "$MEMO" || true
  check_dest_class "$DEST" || true
  [ "$QUIET" -eq 1 ] || printf '\n---\nboundary: %d pass, %d advisory, %d BLOCK, %d UNKNOWN\n' "$pass" "$advisory" "$block" "$unknown"
  if [ "$block" -eq 0 ] && [ "$unknown" -eq 0 ]; then
    printf 'BOUNDARY verdict=BOUNDARY_CLEAN memo=%s dest=%s version=%s\n' \
      "$(basename "$MEMO")" "${DEST:-none}" "$BOUNDARY_CONTRACT_VERSION"
    return 0
  fi
  printf 'BOUNDARY verdict=BOUNDARY_REFUSE memo=%s dest=%s version=%s\n' \
    "$(basename "$MEMO")" "${DEST:-none}" "$BOUNDARY_CONTRACT_VERSION"
  [ "$QUIET" -eq 1 ] || {
    printf '\n⛔ the established placeholder is <forge-overlay-addr> — SUGGESTED, not applied.\n'
    printf '   this program does not edit your memo. if the send is right anyway, that is a\n'
    printf '   decision to record, not a check to bypass.\n'
  }
  return 1
}

# ===========================================================================
# --meta : the meta-control (ADR-011 A4 §6). Fixtures only; no vault is modified.
# ===========================================================================
run_meta() {
  printf '\nmeta-control — each check must be demonstrated able to FAIL (ADR-011 A4 §6)\n\n'
  local bad=0 d out rc
  # ⛔ Assembled from octets so THIS FILE never contains a matchable literal — the same move
  #   test_sanitize_content_gate.sh makes, for the same reason: the instrument that enforces
  #   a publication boundary must not breach it.
  local A="10.$((40+3)).0.$((14*2))"
  d="$(mktemp -d)"

  expect() {  # <label> <want rc> <file> [extra args...]
    local lbl="$1" want="$2" f="$3"; shift 3
    local o r; o="$(bash "$0" "$f" --quiet "$@" 2>&1)"; r=$?
    if [ "$r" -eq "$want" ]; then printf '  ok    %-38s (rc=%s)\n' "$lbl" "$r"
    else printf '  FAIL  %-38s wanted rc=%s got %s :: %s\n' "$lbl" "$want" "$r" "$o"; bad=1; fi
  }

  printf '  -- content: the predicate must be able to refuse, and to permit --\n'
  printf 'a clean memo about nothing in particular\n' > "$d/clean.md"
  expect "clean memo -> CLEAN" 0 "$d/clean.md"
  printf 'the forge runs at %s today\n' "$A" > "$d/dirty.md"
  expect "denied string -> REFUSE" 1 "$d/dirty.md"
  # ⭐ F-P7b-af's two recovered shapes, asserted HERE too — the send gate reads the repaired
  #   pattern, and if the pattern ever regresses this arm goes red alongside the hook's.
  printf 'see `internally.%s` in the notice\n' "$A" > "$d/dot_prefixed.md"
  expect "preceded by a dot -> REFUSE" 1 "$d/dot_prefixed.md"
  printf 'the forge runs at %s.\n' "$A" > "$d/prose_end.md"
  expect "prose sentence end -> REFUSE" 1 "$d/prose_end.md"

  printf '\n  -- the pragma escape, honoured exactly as R8 honours it --\n'
  printf 'the forge runs at %s  # pragma: allowlist\n' "$A" > "$d/pragma.md"
  expect "pragma: allowlist -> CLEAN" 0 "$d/pragma.md"

  printf '\n  -- must NOT refuse (an instrument that refuses everything gates nothing) --\n'
  printf 'bound to 127.0.0.1 and 0.0.0.0, example 192.0.2.10\n' > "$d/generic.md"
  expect "loopback/unspecified/RFC5737" 0 "$d/generic.md"

  printf '\n  -- fail-closed: malformed and unreadable deny files --\n'
  # A fixture vault whose deny file is broken. VAULT is derived from this script's location,
  # so the fixture runs a COPY of this script from inside the fixture tree — the only way to
  # exercise the resolution path a real caller takes.
  local fv="$d/fixture_vault"; mkdir -p "$fv/how/tests"
  cp "$0" "$fv/how/tests/$(basename "$0")"
  printf '[unclosed\n' > "$fv/sanitize_deny_content.txt"
  printf 'anything\n' > "$fv/memo.md"
  out="$(bash "$fv/how/tests/$(basename "$0")" "$fv/memo.md" --quiet 2>&1)"; rc=$?
  if [ "$rc" -ne 0 ] && printf '%s\n' "$out" | grep -q 'BOUNDARY_REFUSE'; then
    printf '  ok    %-38s (rc=%s)\n' "malformed pattern -> REFUSE" "$rc"
  else printf '  FAIL  %-38s :: %s\n' "malformed pattern -> REFUSE" "$out"; bad=1; fi
  printf '(^|[^0-9])10\\.1\\.1\\.1([^0-9]|$)\n' > "$fv/sanitize_deny_content.txt"
  chmod 000 "$fv/sanitize_deny_content.txt"
  out="$(bash "$fv/how/tests/$(basename "$0")" "$fv/memo.md" --quiet 2>&1)"; rc=$?
  if [ "$rc" -ne 0 ]; then printf '  ok    %-38s (rc=%s)\n' "unreadable deny file -> REFUSE" "$rc"
  else printf '  FAIL  %-38s permitted an unreadable deny file :: %s\n' "unreadable deny file -> REFUSE" "$out"; bad=1; fi
  chmod 644 "$fv/sanitize_deny_content.txt"
  # ⛔ ABSENT IS NOT CLEAN — the F-F51 arm.
  rm -f "$fv/sanitize_deny_content.txt"
  out="$(bash "$fv/how/tests/$(basename "$0")" "$fv/memo.md" --quiet 2>&1)"; rc=$?
  if [ "$rc" -ne 0 ] && printf '%s\n' "$out" | grep -q 'UNKNOWN'; then
    printf '  ok    %-38s (rc=%s, absent != clean)\n' "no deny file -> REFUSE" "$rc"
  else printf '  FAIL  %-38s :: %s\n' "no deny file -> REFUSE" "$out"; bad=1; fi

  printf '\n  -- binary files are skipped, as R8 skips them --\n'
  printf 'GIF89a\x00\x01\x02%s\x00\xff' "$A" > "$d/bin.gif"
  expect "binary -> skipped" 0 "$d/bin.gif"

  printf '\n  -- missing memo is UNKNOWN, never a pass --\n'
  expect "absent memo -> REFUSE" 1 "$d/no_such_file_$$.md"

  # ⭐⭐ THE REDACTION ARM. The whole point of this instrument is a refusal that does not
  #   reproduce the string it refuses. If this ever regresses, every BLOCK line becomes a new
  #   occurrence — the gate would manufacture the exposure it exists to prevent.
  printf '\n  -- redaction: a refusal must not reproduce what it refuses --\n'
  out="$(bash "$0" "$d/dirty.md" 2>&1)"
  if printf '%s\n' "$out" | grep -qF "$A"; then
    printf '  FAIL  %-38s the refusal PRINTED the denied string\n' "refusal output is redacted"; bad=1
  else printf '  ok    %-38s (denied string absent from output)\n' "refusal output is redacted"; fi
  # ...and the paired arm: the control must be able to SEE the string when it is there, or
  # the arm above passes for the wrong reason.
  if printf '%s\n' "$(cat "$d/dirty.md")" | grep -qF "$A"; then
    printf '  ok    %-38s (control: grep -F can see it in the fixture)\n' "redaction control"
  else printf '  FAIL  %-38s control cannot see the string at all\n' "redaction control"; bad=1; fi
  # ...and this script's own source must not carry one either.
  if grep -qE '(^|[^0-9])(10|192\.168)\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}([^0-9]|$)' "$0"; then
    printf '  FAIL  %-38s this script carries a matchable literal\n' "self is clean"; bad=1
  else printf '  ok    %-38s (no literal in this file)\n' "self is clean"; fi

  rm -rf "$d"
  printf '\n---\nmeta-control: %s\n' \
    "$([ "$bad" -eq 0 ] && echo 'every check reached its failure state; controls passed; redaction holds' \
                        || echo 'DEFECT — see FAIL rows above')"
  [ "$bad" -eq 0 ]
}

case "$MODE" in meta) run_meta; exit $? ;; esac
run_check
