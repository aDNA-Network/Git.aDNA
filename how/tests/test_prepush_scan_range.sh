#!/usr/bin/env bash
# test_prepush_scan_range.sh — arms for the secret-scan hook's RANGE selection (F-P7b-aw)
#
# Owner: Git.aDNA (Hopper).  Subject: how/code/hooks/pre-push-secret-scan.sh
# Basis: ADR-011 A8 §5 (a coverage claim states its population) + A4 §6 (demonstrated to fail).
#
# ⛔ WHAT THIS GUARDS, AND WHY IT IS NOT AN ARM ABOUT SECRETS.
#   The hook's verdict is only as good as the COMMIT RANGE it hands gitleaks. On a new remote
#   ref the range was `$local_sha --not --remotes` — which subtracts everything reachable from
#   ANY remote-tracking ref. Under ADR-013 the fleet deliberately runs mixed trust classes on
#   one repo (a PRIVATE mesh replica beside a PUBLIC canonical), so the scan protecting the
#   first push to the public origin was narrowed by whatever the private replica had seen.
#
#   ⛩ A commit vetted for a private replica is NOT thereby vetted for a public origin.
#
#   These arms assert the RANGE, not the finding. A gate that scans the wrong population
#   returns a green that means nothing, and no arm about secrets can detect that.
#
# ⛔ SUBJECT_HOOK overrides the hook under test, so an arm can be MEASURED red against the
#   pre-fix version rather than asserted to discriminate (A4 §6):
#     git show <pre-fix>:how/code/hooks/pre-push-secret-scan.sh > /tmp/h_prefix.sh
#     SUBJECT_HOOK=/tmp/h_prefix.sh bash how/tests/test_prepush_scan_range.sh
#
# ⚠ These arms do NOT invoke gitleaks. They assert the range the hook COMPUTES, by reading the
#   `scanning outgoing range —` line the hook prints before it scans. That line is a published
#   part of the hook's behaviour; if it is ever removed these arms must become a real drive,
#   not be deleted.
#
# Usage: bash how/tests/test_prepush_scan_range.sh
# Exit:  0 = all arms green · 1 = one or more RED

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOK="${SUBJECT_HOOK:-$HERE/../code/hooks/pre-push-secret-scan.sh}"
ZERO=0000000000000000000000000000000000000000
pass=0; fail=0; declare -a failures=()

ok()  { pass=$((pass+1)); printf '  ✓ %s\n' "$1"; }
bad() { fail=$((fail+1)); failures+=("$1"); printf '  ✗ %s\n' "$1"; }

# Two fixtures, because the repair has two correct outcomes and one arm cannot see both.
#
#   A: destination HAS tracking refs  -> exclude only ITS refs   (`--not --remotes=<dest>`)
#   B: destination has NONE           -> exclude NOTHING, scan the ref in full
#
# Both differ from the defect, which excluded every remote's refs in both cases.
# `replica` stands for the PRIVATE mesh replica; `origin` for the PUBLIC canonical.

# <origin_at|none> -> dir
scaffold() {
  local origin_at="$1" d; d="$(mktemp -d)"
  (
    cd "$d" || exit 9
    git init -q . && git config user.email t@t && git config user.name t
    for i in 1 2 3 4 5; do echo "line $i" > "f$i.md"; git add -A; git commit -qm "c$i"; done
    # Fabricate tracking refs without a network. The private replica has seen c1..c4.
    git update-ref refs/remotes/replica/master "$(git rev-parse HEAD~1)"
    [ "$origin_at" != none ] && git update-ref refs/remotes/origin/master "$(git rev-parse "$origin_at")"
  ) >/dev/null 2>&1
  echo "$d"
}

range_for() {   # <dir> <remote-arg> -> the range_desc line the hook printed
  local d="$1" remote="$2" head out
  head="$(git -C "$d" rev-parse HEAD)"
  out="$d/.out"
  ( cd "$d" && printf 'refs/heads/master %s refs/heads/master %s\n' "$head" "$ZERO" \
      | bash "$HOOK" "$remote" https://example.invalid/r.git ) > "$out" 2>&1
  grep -m1 'scanning outgoing range' "$out" 2>/dev/null || echo "(no range line)"
}

echo "secret-scan hook — range selection (F-P7b-aw)"

# ══ FIXTURE A — destination has tracking refs ═══════════════════════════════
dA="$(scaffold HEAD~3)"
scope_fix=$(git -C "$dA" rev-list --count HEAD --not --remotes=origin)
scope_old=$(git -C "$dA" rev-list --count HEAD --not --remotes)
printf '  [A] origin@c2, replica@c4 — in scope: repaired=%s  pre-fix=%s\n' "$scope_fix" "$scope_old"

if [[ "$scope_fix" -gt "$scope_old" ]]; then
  ok "[A] fixture discriminates ($scope_fix vs $scope_old commits)"
else
  bad "[A] fixture does NOT discriminate — both forms give the same count; the arm proves nothing"
fi

r="$(range_for "$dA" origin)"
case "$r" in
  *"--not --remotes=origin"*) ok "[A] excludes ONLY the destination's refs" ;;
  *"--not --remotes"*)        bad "[A] F-P7b-aw LIVE — excluded every remote: ${r#*— }" ;;
  *)                          bad "[A] unexpected range: ${r#*— }" ;;
esac

# ══ FIXTURE B — destination has NO tracking refs ════════════════════════════
dB="$(scaffold none)"
b_total=$(git -C "$dB" rev-list --count HEAD)
b_old=$(git -C "$dB" rev-list --count HEAD --not --remotes)
printf '  [B] origin unknown, replica@c4 — in scope: repaired=%s (full)  pre-fix=%s\n' "$b_total" "$b_old"

if [[ "$b_total" -gt "$b_old" ]]; then
  ok "[B] fixture discriminates ($b_total vs $b_old commits)"
else
  bad "[B] fixture does NOT discriminate"
fi

r="$(range_for "$dB" origin)"
case "$r" in
  *"FULL history"*)    ok "[B] unknown destination scans the ref in FULL, never narrowed" ;;
  *"--not --remotes"*) bad "[B] F-P7b-aw LIVE via the fallback — ${r#*— }" ;;
  *)                   bad "[B] unexpected range: ${r#*— }" ;;
esac

# ══ ARM — an empty remote name must not degrade to the unpatterned form ═════
r="$(range_for "$dB" "")"
if [[ "$r" == *"--not --remotes"* ]] && [[ "$r" != *"--remotes="* ]]; then
  bad "empty remote name fell back to the unpatterned form — the defect, via the fallback"
else
  ok "empty remote name does not fall back to --remotes"
fi

rm -rf "$dA" "$dB"

echo
if [[ $fail -eq 0 ]]; then
  echo "✓ scan-range: $pass/$((pass+fail)) arms GREEN"; exit 0
else
  echo "❌ scan-range: $fail RED of $((pass+fail))"
  printf '   - %s\n' "${failures[@]}"; exit 1
fi
