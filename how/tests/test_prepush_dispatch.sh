#!/usr/bin/env bash
# test_prepush_dispatch.sh — arms for how/code/hooks/pre-push-dispatch.sh
#
# Owner: Git.aDNA (Hopper).  Installed 2026-09-02, 29th sitting.
#
# ⛔ THE ARM THAT MATTERS IS ARM 1, AND IT GUARDS A SILENT FAILURE.
#   git delivers the pre-push ref list on STDIN, and stdin is consumed by the FIRST reader.
#   A naive `gate1 && gate2` chain hands gate 2 an EMPTY ref list — which every correctly
#   written pre-push gate reads as "nothing is being pushed" and exits 0.
#
#   ⇒ The second gate reports CLEAN on every push, forever, while appearing installed. It is
#     invisible to any test that runs the gates DIRECTLY, because run directly they get their
#     stdin. It is only visible from the dispatcher's own entry point, which is why this file
#     exists rather than more arms in the gate's own suite.
#
#   ⭐ Same class as F-P7b-z (a self-test that reimplements rather than drives) and F-P7b-ag
#   (a gate believed installed that was not): the failure is never in the checked thing, it
#   is in the seam nobody points a control at.
#
# The gates are STUBS here, on purpose. This file tests the DISPATCHER's contract — every
# gate runs, each gets the refs, any non-zero blocks, a missing gate blocks — not what the
# real gates decide. Their verdicts have their own suites.
#
# Usage: bash how/tests/test_prepush_dispatch.sh
# Exit:  0 = all arms green · 1 = one or more RED

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DISPATCH="$HERE/../code/hooks/pre-push-dispatch.sh"
pass=0; fail=0; declare -a failures=()

REFS_LINE='refs/heads/master aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa refs/heads/master bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'

ok()  { pass=$((pass+1)); printf '  ✓ %s\n' "$1"; }
bad() { fail=$((fail+1)); failures+=("$1"); printf '  ✗ %s\n' "$1"; }

# Build a scratch repo carrying the two gate paths the dispatcher resolves.
# <stub_rc_secret> <stub_rc_sanitize>
scaffold() {
  local d; d="$(mktemp -d)"
  git -C "$d" init -q .
  mkdir -p "$d/how/code/hooks" "$d/how/standard/hooks"
  cat > "$d/how/code/hooks/pre-push-secret-scan.sh" <<STUB
#!/usr/bin/env bash
wc -l < /dev/stdin | tr -d ' ' > "\$(git rev-parse --show-toplevel)/.saw_secret"
exit ${1:-0}
STUB
  cat > "$d/how/standard/hooks/pre-push-sanitize.sh" <<STUB
#!/usr/bin/env bash
wc -l < /dev/stdin | tr -d ' ' > "\$(git rev-parse --show-toplevel)/.saw_sanitize"
exit ${2:-0}
STUB
  cp "$DISPATCH" "$d/how/code/hooks/pre-push-dispatch.sh"
  echo "$d"
}

drive() {  # <dir> -> prints rc
  local d="$1" rc
  ( cd "$d" && printf '%s\n' "$REFS_LINE" \
      | bash how/code/hooks/pre-push-dispatch.sh origin https://example.invalid/r.git ) \
      > "$d/.out" 2>&1
  rc=$?      # own line, never through a pipe (F-P7b-ab)
  echo "$rc"
}

echo "pre-push dispatcher"

# ── ARM 1 — the stdin seam ────────────────────────────────────────────────────
d="$(scaffold 0 0)"; rc="$(drive "$d")"
saw_a="$(cat "$d/.saw_secret"   2>/dev/null || echo MISSING)"
saw_b="$(cat "$d/.saw_sanitize" 2>/dev/null || echo MISSING)"
if [[ "$saw_a" == "1" && "$saw_b" == "1" ]]; then
  ok "BOTH gates receive the ref list (secret=$saw_a sanitize=$saw_b lines)"
else
  bad "stdin seam — secret saw '$saw_a', sanitize saw '$saw_b' lines; want 1 and 1"
fi
[[ "$rc" -eq 0 ]] && ok "clean+clean ⇒ rc=0" || bad "clean+clean ⇒ rc=$rc, want 0"
rm -rf "$d"

# ── ARM 2 — either gate can block, and an early block does not skip the rest ──
d="$(scaffold 1 0)"; rc="$(drive "$d")"
saw_b="$(cat "$d/.saw_sanitize" 2>/dev/null || echo MISSING)"
[[ "$rc" -eq 1 ]] && ok "secret blocks ⇒ rc=1" || bad "secret blocks ⇒ rc=$rc, want 1"
[[ "$saw_b" == "1" ]] && ok "a blocking first gate does NOT skip the second" \
                      || bad "second gate skipped after an early block (saw '$saw_b')"
rm -rf "$d"

d="$(scaffold 0 1)"; rc="$(drive "$d")"
[[ "$rc" -eq 1 ]] && ok "sanitize blocks ⇒ rc=1" || bad "sanitize blocks ⇒ rc=$rc, want 1"
rm -rf "$d"

# ── ARM 3 — fail-closed on a missing gate ────────────────────────────────────
d="$(scaffold 0 0)"; rm -f "$d/how/standard/hooks/pre-push-sanitize.sh"
rc="$(drive "$d")"
if [[ "$rc" -eq 1 ]] && grep -q "GATE MISSING" "$d/.out"; then
  ok "a MISSING gate blocks and says so (fail-closed)"
else
  bad "missing gate ⇒ rc=$rc, want 1 with 'GATE MISSING'"
fi
rm -rf "$d"

# ── ARM 4 — an unreadable gate is not silently skipped ───────────────────────
d="$(scaffold 0 0)"; chmod 000 "$d/how/standard/hooks/pre-push-sanitize.sh"
rc="$(drive "$d")"
[[ "$rc" -eq 1 ]] && ok "an UNREADABLE gate blocks (fail-closed)" \
                  || bad "unreadable gate ⇒ rc=$rc, want 1"
chmod 644 "$d/how/standard/hooks/pre-push-sanitize.sh" 2>/dev/null; rm -rf "$d"

echo
if [[ $fail -eq 0 ]]; then
  echo "✓ pre-push dispatcher: $pass/$((pass+fail)) arms GREEN"; exit 0
else
  echo "❌ pre-push dispatcher: $fail RED of $((pass+fail))"
  printf '   - %s\n' "${failures[@]}"; exit 1
fi
