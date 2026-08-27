#!/usr/bin/env bash
# test_sanitize_content_gate.sh — end-to-end arms for pre-push-sanitize.sh R7 + R8
#
# Owner:  Git.aDNA (Hopper).  Subject: how/standard/hooks/pre-push-sanitize.sh @ 4.1.0
# Basis:  what/decisions/adr_016_publication_boundary.md D5 (proposed)
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
HOOK="$HERE/../standard/hooks/pre-push-sanitize.sh"
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

deny_addr() { printf '%s\n' \
  '(^|[^0-9.])(10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|192\.168\.[0-9]{1,3}\.[0-9]{1,3})([^0-9.]|$)' \
  > sanitize_deny_content.txt; }

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
s_multiline()  { { echo "one $TEST_ADDR"; echo "two 192.168.1.5"; echo "three clean"; } > doc.md; deny_addr; commit_all; }

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
echo
if [[ $fail -eq 0 ]]; then
  echo "✓ sanitize content gate: $pass/$((pass+fail)) arms GREEN"
  exit 0
else
  echo "❌ sanitize content gate: $fail RED of $((pass+fail))"
  printf '   - %s\n' "${failures[@]}"
  exit 1
fi
