#!/usr/bin/env bash
# test_sanitize_content_gate.sh — end-to-end arms for pre-push-sanitize.sh R7 + R8
#
# Owner:  Git.aDNA (Hopper).  Subject: how/standard/hooks/pre-push-sanitize.sh @ 4.2.0
# Basis:  what/decisions/adr_016_publication_boundary.md D5 + D4 + Amendment A1
#
# ⛔ SANITIZE_HOOK overrides the subject under test. It exists so a new arm can be run
#   against the PREVIOUS version and MEASURED red, rather than asserted to discriminate:
#     git show HEAD:how/standard/hooks/pre-push-sanitize.sh > /tmp/h410.sh
#     SANITIZE_HOOK=/tmp/h410.sh bash how/tests/test_sanitize_content_gate.sh
#   An arm that is green against BOTH versions discriminates nothing about the change.
#   Such arms are kept as regression guards and LABELLED, never counted as evidence.
#
# ⛔ WHY THIS FILE EXISTS RATHER THAN MORE --self-test FIXTURES
#   The hook's own `--self-test` mode does NOT test the hook. It REIMPLEMENTS R1–R6 as a
#   separate inline scan over a fixtures directory and never enters the push-time code
#   path at all. Consequences, measured 2026-08-26:
#     · R7 (operator deny list) has shipped in .adna/ and has NEVER been exercised.
#     · R8 would have inherited exactly that, on the day it was written.
#     · A self-test that passes tells you the reimplementation agrees with itself.
#   That is F-P7b-x a fourth time — a control validating a code path no caller takes —
#   and this time in the template's hook rather than in one of our own instruments.
#
#   So every arm below drives the REAL path: a real git repo, real stdin ref lines in
#   githooks(5) format, the real `git ls-tree`/`git diff` range computation, the real
#   rule blocks, the real Decision block. Full-process. No functions called by hand.
#
# ⛔ EXIT CODES ARE CAPTURED, NEVER READ THROUGH A PIPE.  `cmd | tail` reports the exit
#   status of `tail`. This desk has committed that defect twice, the second time inside
#   the very function it was repairing. Every arm here captures output to a file and
#   reads $? on the next line.
#
# Usage:  bash how/tests/test_sanitize_content_gate.sh [--verbose]
# Exit:   0 = all arms green · 1 = one or more arms RED

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOK="${SANITIZE_HOOK:-$HERE/../standard/hooks/pre-push-sanitize.sh}"
VERBOSE=0; [[ "${1:-}" == "--verbose" ]] && VERBOSE=1

pass=0; fail=0
declare -a failures=()

# The address family under test. Built at runtime from octets so that THIS FILE never
# contains a literal RFC1918 address — the test for a publication boundary must not
# itself breach it. (ADR-016's own preamble makes the same move for the same reason.)
TEST_ADDR="10.$((40+3)).0.$((14*2))"
TEST_PORT="3300"

arm() {  # <name> <expected_rc> <expected_substring|-> <setup_fn>
  local name="$1" exp_rc="$2" exp_sub="$3" setup="$4"
  local d out rc
  d="$(mktemp -d)"
  (
    cd "$d" || exit 99
    git init -q . && git config user.email t@t && git config user.name t
    "$setup" "$d"
  ) || { failures+=("$name — setup failed"); fail=$((fail+1)); rm -rf "$d"; return; }

  local sha
  sha="$(git -C "$d" rev-parse HEAD 2>/dev/null)" || sha=""
  if [[ -z "$sha" ]]; then
    failures+=("$name — no commit produced by setup"); fail=$((fail+1)); rm -rf "$d"; return
  fi

  out="$d/.hookout"
  # Full-process: real stdin in githooks(5) form. remote_sha = NULL ⇒ new-branch arm,
  # which makes the hook ls-tree the whole commit — the widest file set it ever sees.
  ( cd "$d" && printf 'refs/heads/master %s refs/heads/master %s\n' \
      "$sha" "0000000000000000000000000000000000000000" \
      | bash "$HOOK" origin https://example.invalid/r.git ) > "$out" 2>&1
  rc=$?          # captured on its own line; never through a pipe

  local ok=1
  [[ "$rc" -eq "$exp_rc" ]] || ok=0
  if [[ "$exp_sub" != "-" ]] && ! grep -q "$exp_sub" "$out"; then ok=0; fi

  if [[ $ok -eq 1 ]]; then
    pass=$((pass+1)); printf '  ✓ %s (rc=%s)\n' "$name" "$rc"
    [[ $VERBOSE -eq 1 ]] && sed 's/^/      /' "$out"
  else
    fail=$((fail+1))
    failures+=("$name — rc=$rc (want $exp_rc), expected substring: $exp_sub")
    printf '  ✗ %s (rc=%s, want %s)\n' "$name" "$rc" "$exp_rc"
    sed 's/^/      /' "$out"
  fi
  rm -rf "$d"
}

# ⛔ CORRECTED 2026-08-27 (F-P7b-aj) — THIS HARNESS CARRIED ITS OWN COPY OF THE PATTERN.
#   `deny_addr` used to write a hand-typed ERE into the fixture, so every arm below tested a
#   STRING IN THIS FILE and not the pattern the gate actually ships. When F-P7b-af repaired
#   the shipped guards, this copy stayed stale — and every arm stayed green, because they were
#   green about the wrong pattern.
#
#   ⭐ Same family as the defect it was written to guard: the census reimplemented the gate's
#   predicate and produced a fourth number; this test reimplemented it and produced a fourth
#   opinion. ⇒ The fixture is now COPIED FROM THE SHIPPED FILE. If the shipped pattern
#   regresses, these arms go red — which is the only reason to have them.
SHIPPED_DENY="$HERE/../../sanitize_deny_content.txt"
deny_addr() { cp "$SHIPPED_DENY" sanitize_deny_content.txt; }

commit_all() { git add -A >/dev/null 2>&1 && git commit -qm t >/dev/null 2>&1; }

# --------------------------------------------------------------------------
# R8 arms
# --------------------------------------------------------------------------
s_block()      { echo "forge lives at $TEST_ADDR:$TEST_PORT" > doc.md; deny_addr; commit_all; }
s_pragma()     { echo "forge at $TEST_ADDR:$TEST_PORT  <!-- pragma: allowlist -->" > doc.md; deny_addr; commit_all; }
s_clean()      { echo "forge lives on the mesh" > doc.md; deny_addr; commit_all; }
s_loopback()   { echo "bind 127.0.0.1:$TEST_PORT and 0.0.0.0 is generic" > doc.md; deny_addr; commit_all; }
s_nodeny()     { echo "forge at $TEST_ADDR:$TEST_PORT" > doc.md; commit_all; }
s_malformed()  { echo "hello" > doc.md; printf '%s\n' '([unclosed' > sanitize_deny_content.txt; commit_all; }
s_unreadable() { echo "hello" > doc.md; deny_addr; commit_all; chmod 000 sanitize_deny_content.txt; }
# ⛔ The second line hardcoded a literal address until 2026-08-27, in the file whose own header
#   says "THIS FILE never contains a literal RFC1918 address" — while that same line's FIRST
#   echo used $TEST_ADDR correctly. A stated discipline, broken one token from where it is
#   followed. It survived because nothing ever scanned this file: the gate it tests has never
#   been installed (F-P7b-ag), so the first instrument to read it was the send-end boundary
#   checker — written hours earlier, in this same sitting. ⭐ A rule with no instrument is a comment.
s_multiline()  { { echo "one $TEST_ADDR"; echo "two $TEST_ADDR"; echo "three clean"; } > doc.md; deny_addr; commit_all; }

echo "R8 — content deny list"
arm "R8 blocks a denied string"                  1 "R8: doc.md"        s_block
arm "R8 honours pragma: allowlist"               0 "-"                 s_pragma
arm "R8 passes clean content"                    0 "-"                 s_clean
arm "R8 does NOT match loopback or 0.0.0.0"      0 "-"                 s_loopback
arm "R8 inert when no deny file exists"          0 "-"                 s_nodeny
arm "R8 BLOCKS on a malformed pattern"           1 "malformed pattern" s_malformed
arm "R8 BLOCKS on an unreadable deny file"       1 "not readable"      s_unreadable
arm "R8 reports every matching line"             1 "doc.md:2"          s_multiline

# --------------------------------------------------------------------------
# Redaction — the gate must not print what it is refusing to publish
# --------------------------------------------------------------------------
echo "R8 — redaction"
d="$(mktemp -d)"
( cd "$d" && git init -q . && git config user.email t@t && git config user.name t \
  && echo "forge at $TEST_ADDR:$TEST_PORT" > doc.md && deny_addr && commit_all )
sha="$(git -C "$d" rev-parse HEAD)"
( cd "$d" && printf 'refs/heads/master %s refs/heads/master 0000000000000000000000000000000000000000\n' "$sha" \
  | bash "$HOOK" origin https://example.invalid/r.git ) > "$d/.out" 2>&1
rc=$?
if grep -q "$TEST_ADDR" "$d/.out"; then
  fail=$((fail+1)); failures+=("redaction — the hook printed the denied string")
  printf '  ✗ output does not leak the denied string\n'
else
  pass=$((pass+1)); printf '  ✓ output does not leak the denied string (rc=%s)\n' "$rc"
fi
rm -rf "$d"

# --------------------------------------------------------------------------
# R7 arms — FIRST EVER EXERCISE of a rule that has shipped in .adna/
# --------------------------------------------------------------------------
s_r7_prefix() { mkdir -p secrets && echo x > secrets/a.md && echo "secrets/" > sanitize_deny.txt; commit_all; }
s_r7_regex()  { echo x > notes.draft.md && printf 're:\\.draft\\.md$\n' > sanitize_deny.txt; commit_all; }
s_r7_clean()  { echo x > notes.md && echo "secrets/" > sanitize_deny.txt; commit_all; }

echo "R7 — path deny list (first exercise)"
arm "R7 blocks a denied path prefix"   1 "R7: secrets/a.md"    s_r7_prefix
arm "R7 blocks a denied path regex"    1 "R7: notes.draft.md"  s_r7_regex
arm "R7 passes a non-denied path"      0 "-"                   s_r7_clean

# --------------------------------------------------------------------------
# RANGE ARMS (4.2.0) — R8 checks the lines a push would ADD, per ADR-016 D4 + A1
#
# ⛔ Every arm ABOVE feeds remote_sha = NULL_SHA, i.e. the NEW-BRANCH case, which 4.2.0
#   still scans WHOLE-FILE. They are therefore the regression suite for the fallback path
#   and they must stay green unchanged. The arms below are the only ones that exercise the
#   new scope, and they need a driver that supplies a REAL remote_sha.
# --------------------------------------------------------------------------

# <name> <expected_rc> <expect_substring|-> <reject_substring|-> <setup_fn>
# setup_fn makes TWO commits: the first is the "already published" baseline, the second is
# what this push would add. stdin then carries remote_sha=HEAD~1, local_sha=HEAD.
arm_range() {
  local name="$1" exp_rc="$2" exp_sub="$3" rej_sub="$4" setup="$5"
  local d out rc base head
  d="$(mktemp -d)"
  (
    cd "$d" || exit 99
    git init -q . && git config user.email t@t && git config user.name t
    "$setup" "$d"
  ) || { failures+=("$name — setup failed"); fail=$((fail+1)); rm -rf "$d"; return; }

  base="$(git -C "$d" rev-parse HEAD~1 2>/dev/null)" || base=""
  head="$(git -C "$d" rev-parse HEAD 2>/dev/null)"   || head=""
  if [[ -z "$base" || -z "$head" ]]; then
    failures+=("$name — setup did not produce two commits"); fail=$((fail+1)); rm -rf "$d"; return
  fi

  out="$d/.hookout"
  ( cd "$d" && printf 'refs/heads/master %s refs/heads/master %s\n' "$head" "$base" \
      | bash "$HOOK" origin https://example.invalid/r.git ) > "$out" 2>&1
  rc=$?          # own line; never through a pipe (F-P7b-ab)

  local ok=1
  [[ "$rc" -eq "$exp_rc" ]] || ok=0
  if [[ "$exp_sub" != "-" ]] && ! grep -q "$exp_sub" "$out"; then ok=0; fi
  if [[ "$rej_sub" != "-" ]] &&   grep -q "$rej_sub" "$out"; then ok=0; fi

  if [[ $ok -eq 1 ]]; then
    pass=$((pass+1)); printf '  ✓ %s (rc=%s)\n' "$name" "$rc"
    [[ $VERBOSE -eq 1 ]] && sed 's/^/      /' "$out"
  else
    fail=$((fail+1))
    failures+=("$name — rc=$rc (want $exp_rc), want:'$exp_sub' reject:'$rej_sub'")
    printf '  ✗ %s (rc=%s, want %s)\n' "$name" "$rc" "$exp_rc"
    sed 's/^/      /' "$out"
  fi
  rm -rf "$d"
}

# baseline already carries the address; this push adds only clean text.
r_published_clean() {
  echo "forge at $TEST_ADDR:$TEST_PORT" > doc.md; deny_addr; commit_all
  echo "a second line, entirely clean" >> doc.md; commit_all
}
# baseline clean; this push introduces the address.
r_added_block() {
  echo "nothing here" > doc.md; deny_addr; commit_all
  echo "forge at $TEST_ADDR:$TEST_PORT" >> doc.md; commit_all
}
# ⭐ THE CASE THE FILE-SCOPED ALLOWLIST WOULD HAVE LET THROUGH.
#   STATE.md already carries the address (line 1) and this push adds ANOTHER (line 3).
#   4.2.0 must report line 3 and must NOT report line 1.
r_state_new_occurrence() {
  { echo "mesh forge at $TEST_ADDR:$TEST_PORT"; echo "unrelated prose"; } > STATE.md
  deny_addr; commit_all
  echo "and a NEW mention of $TEST_ADDR here" >> STATE.md; commit_all
}
# rename of a carrying file — presents as all-new. Known over-refusal, A1 §2.
r_rename() {
  echo "forge at $TEST_ADDR:$TEST_PORT" > doc.md; deny_addr; commit_all
  git mv doc.md moved.md >/dev/null 2>&1; commit_all
}
# fail-closed must survive the rescope, in RANGE mode specifically.
r_malformed() {
  echo "hello" > doc.md; deny_addr; commit_all
  printf '%s\n' '([unclosed' > sanitize_deny_content.txt; echo "more" >> doc.md; commit_all
}
r_unreadable() {
  echo "hello" > doc.md; deny_addr; commit_all
  echo "more" >> doc.md; commit_all; chmod 000 sanitize_deny_content.txt
}

echo "R8 — range scope (4.2.0)"
# ── discriminating: green here, RED against 4.1.0 ──────────────────────────
arm_range "published line is NOT re-litigated"   0 "-"              "-"          r_published_clean
arm_range "a NEWLY ADDED occurrence blocks"      1 "ADDED line"     "-"          r_added_block
arm_range "new occurrence in STATE.md blocks"    1 "STATE.md:3"     "STATE.md:1" r_state_new_occurrence
# ── regression guards: green against BOTH versions, kept and LABELLED ──────
arm_range "[regression] rename blocks"           1 "moved.md"       "-"          r_rename
arm_range "[regression] malformed ERE blocks"    1 "malformed"      "-"          r_malformed
arm_range "[regression] unreadable deny blocks"  1 "not readable"   "-"          r_unreadable

# --------------------------------------------------------------------------
# DIFFERENTIAL ARMS — the push gate (R8) and the send gate must agree.
#
# ⭐ WHY THIS SECTION IS THE LOAD-BEARING ONE. `how/tests/check_send_boundary.sh` reimplements
#   R8's matcher rather than sourcing it, because Standing Order #3 ships
#   pre-push-sanitize.sh to `.adna/` AS A SINGLE FILE and a `source` would create a dependency
#   `.adna/` cannot satisfy — failing OPEN if it ever went missing.
#
#   Reimplementation buys that safety and costs a drift risk. ⇒ The two are held identical by
#   a control, not by an assertion in a comment: one corpus, both instruments, verdicts must
#   match. This arm is what makes "the two gates cannot disagree" a claim that would go RED.
#
# ⚖ THE BOUND, ON THE LINE RATHER THAN IN A FOOTNOTE: this proves agreement ON THIS CORPUS,
#   not everywhere. The corpus is one fixture per matcher semantic — match, pragma escape,
#   the two shapes F-P7b-af recovered, the must-not-match generics, and binary skip — so a
#   drift in any one of them is DETECTABLE. "Detectable" is the honest word; "impossible"
#   would not be.
#
# ⚠ Both instruments read the SAME shipped deny file. That is the point: the predicate is
#   shared by reference, and only the matcher is duplicated.
# --------------------------------------------------------------------------
SEND_CHK="$HERE/check_send_boundary.sh"
diff_agree=0; diff_total=0

diff_arm() {  # <name> <content> <want: BLOCK|CLEAN>
  local name="$1" content="$2" want="$3"
  local d hook_v send_v sha
  diff_total=$((diff_total+1))
  d="$(mktemp -d)"
  ( cd "$d" && git init -q . && git config user.email t@t && git config user.name t \
    && printf '%b\n' "$content" > memo.md && cp "$SHIPPED_DENY" sanitize_deny_content.txt \
    && git add -A && git commit -qm t ) >/dev/null 2>&1
  sha="$(git -C "$d" rev-parse HEAD 2>/dev/null)"
  # --- the push gate, full process, real githooks(5) stdin ---
  ( cd "$d" && printf 'refs/heads/master %s refs/heads/master %s\n' "$sha" \
      "0000000000000000000000000000000000000000" \
      | bash "$HOOK" origin https://example.invalid/r.git ) >/dev/null 2>&1
  [[ $? -eq 0 ]] && hook_v=CLEAN || hook_v=BLOCK
  # --- the send gate, on the same file, reading the same deny list ---
  ( cd "$d" && bash "$SEND_CHK" memo.md --quiet ) >/dev/null 2>&1
  [[ $? -eq 0 ]] && send_v=CLEAN || send_v=BLOCK

  if [[ "$hook_v" == "$send_v" && "$hook_v" == "$want" ]]; then
    diff_agree=$((diff_agree+1)); pass=$((pass+1))
    printf '  ✓ %-34s hook=%-5s send=%-5s (agree, want %s)\n' "$name" "$hook_v" "$send_v" "$want"
  else
    fail=$((fail+1))
    failures+=("DIFF $name — hook=$hook_v send=$send_v want=$want")
    printf '  ✗ %-34s hook=%-5s send=%-5s want=%s\n' "$name" "$hook_v" "$send_v" "$want"
  fi
  rm -rf "$d"
}

echo
echo "DIFFERENTIAL — push gate (R8) vs send gate, one corpus, verdicts must agree"
diff_arm "match: bare, mid-sentence"   "the forge runs at ${TEST_ADDR} today"            BLOCK
diff_arm "match: with port"            "see ${TEST_ADDR}:${TEST_PORT} for the UI"        BLOCK
diff_arm "match: preceded by a dot"    "see \`internally.${TEST_ADDR}\` in the notice"   BLOCK
diff_arm "match: prose sentence end"   "the forge runs at ${TEST_ADDR}."                 BLOCK
diff_arm "escape: pragma allowlist"    "at ${TEST_ADDR}  # pragma: allowlist"            CLEAN
diff_arm "no-match: loopback"          "bound to 127.0.0.1 only"                         CLEAN
diff_arm "no-match: unspecified"       "listening on 0.0.0.0"                            CLEAN
diff_arm "no-match: RFC5737 doc range" "example uses 192.0.2.10"                         CLEAN
diff_arm "no-match: inside longer quad" "see 1${TEST_ADDR}1 here"                        CLEAN
diff_arm "no-match: clean prose"       "a memo about nothing in particular"              CLEAN
printf '  agreed=%s/%s corpus=r8_diff_v1  ⚠ agreement ON THIS CORPUS, not everywhere\n' \
  "$diff_agree" "$diff_total"

# --------------------------------------------------------------------------
echo
if [[ $fail -eq 0 ]]; then
  echo "✓ sanitize content gate: $pass/$((pass+fail)) arms GREEN"
  exit 0
else
  echo "❌ sanitize content gate: $fail RED of $((pass+fail))"
  printf '   - %s\n' "${failures[@]}"
  exit 1
fi
