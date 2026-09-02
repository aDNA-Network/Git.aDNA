#!/usr/bin/env bash
# pre-push-dispatch.sh — run EVERY push-time gate, block if ANY of them blocks.
#
# Source of record (tracked):   how/code/hooks/pre-push-dispatch.sh   ← this file
# Installed to (untracked):     .git/hooks/pre-push
# Installed:                    2026-09-02 (Git.aDNA, 29th sitting)
#
# ---------------------------------------------------------------------------
# WHY A DISPATCHER AND NOT A REPLACEMENT — F-P7b-ag, discharged here.
#
#   Until today `.git/hooks/pre-push` was the gitleaks secret scanner ALONE, and
#   `core.hooksPath` was unset. The sanitize gate's canonical install instruction is
#   "copies to .git/hooks/pre-push" — i.e. the two controls are specified to occupy the
#   SAME SLOT. Installing sanitize as documented would have silently traded one live
#   control for another and reported success.
#
#   ⛔ Both run. Either can block. Neither is subordinate to the other.
#
# ---------------------------------------------------------------------------
# ⛔ STDIN IS THE TRAP, AND IT IS A GREEN-REPORTING ONE.
#
#   git delivers the ref list on STDIN, and stdin is consumed by the FIRST reader. A naive
#   `gate1 && gate2` chain hands gate 2 an EMPTY ref list — which every correctly-written
#   pre-push gate reads as "nothing is being pushed" and exits 0.
#
#   ⇒ The second gate would report CLEAN on every push, forever, while appearing installed.
#     That is a green-reporting gate created in the very act of installing a gate against
#     green reporting, and it would be invisible to any test that ran the gates directly.
#
#   The refs are therefore captured ONCE to a temp file and REDIRECTED into each gate.
#   ⚠ A file redirect, not a pipe: F-P7b-ab recorded three instances on this desk of an exit
#   code clobbered by a pipeline or a command substitution. `$?` here is the gate's own.
#
# ⛔ FAIL-CLOSED. A gate that is missing or unreadable BLOCKS the push. An absent control
#   must never be indistinguishable from a passing one — ADR-011 A4 §2(a).
#
# Exit: 0 = every gate clean · 1 = at least one gate blocked, or a gate was unreachable.
# Bypass (use sparingly): git push --no-verify

set -uo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "pre-push: ⛔ not inside a git work tree — fail-closed" >&2; exit 1; }

# Order is deliberate: secrets first (the cheaper, older, higher-severity check), then the
# publication boundary. Both always run — an early block does NOT skip the rest, because a
# push held for two reasons should report two reasons.
GATES=(
  "$ROOT/how/code/hooks/pre-push-secret-scan.sh"      # gitleaks, outgoing range (Venus)
  "$ROOT/how/standard/hooks/pre-push-sanitize.sh"     # R1–R8, incl. the content boundary
)

REFS_FILE="$(mktemp)" || { echo "pre-push: ⛔ mktemp failed — fail-closed" >&2; exit 1; }
trap 'rm -f "$REFS_FILE"' EXIT
cat > "$REFS_FILE"

failed=0
for gate in "${GATES[@]}"; do
  name="$(basename "$gate")"
  if [ ! -f "$gate" ] || [ ! -r "$gate" ]; then
    printf 'pre-push: ⛔ GATE MISSING OR UNREADABLE — %s (fail-closed)\n' "$gate" >&2
    failed=1
    continue
  fi
  bash "$gate" "$@" < "$REFS_FILE"
  rc=$?
  if [ "$rc" -ne 0 ]; then
    printf 'pre-push: ⛔ %s BLOCKED (exit %s)\n' "$name" "$rc" >&2
    failed=1
  fi
done

if [ "$failed" -ne 0 ]; then
  echo "" >&2
  echo "pre-push: push aborted — see the gate output above." >&2
  exit 1
fi

exit 0
