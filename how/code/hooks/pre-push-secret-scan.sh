#!/usr/bin/env bash
# pre-push-secret-scan.sh — outgoing-range secret-scanner gate (Network.aDNA / Venus)
#
# Source of record (tracked):   how/code/hooks/pre-push-secret-scan.sh
# Installed to (untracked):     .git/hooks/pre-push  (symlink → this file)
# Engine:                       gitleaks (>= 8.19 for `gitleaks git --log-opts`; tested on 8.30.1)
# Config / allowlist:           $GITLEAKS_CONFIG → <repo>/git/.gitleaks.toml → <repo>/.gitleaks.toml
#                               (F-W3-a: this vault's ROOT .gitleaks.toml is authoritative;
#                               git/.gitleaks.toml is intentionally not staged — the search
#                               order is kept identical to the federated Git.aDNA skeleton.)
# Rationale:                    fl_code_fixes_ci FX-1 (GT-93). The federated Git.aDNA P3
#                               skeleton (how/federation/git/hooks/pre-push.gitleaks.sh) ran
#                               `gitleaks git --pre-commit`, which scans the STAGED diff —
#                               empty at push time — so the layer was a de-facto no-op, and it
#                               warned-not-blocked when the scanner was absent. This hardened
#                               local copy (wrapper `local_extensions`) scans the actual
#                               OUTGOING commit range from the pre-push stdin refs and FAILS
#                               CLOSED when gitleaks is unavailable. Upstream finding memo:
#                               who/coordination/coord_2026_07_11_venus_to_gracehopper_prepush_hook_finding.md
#
# HOOK_CONTRACT_VERSION=0.1.0
#
# Pre-push contract (githooks(5)): argv = <remote-name> <remote-url>; stdin = one line per
# ref being pushed: `<local-ref> <local-sha> <remote-ref> <remote-sha>`.
#
# Exit codes:
#   0 = clean — push proceeds (also: nothing to scan, e.g. deletes only)
#   1 = BLOCK — gitleaks found a likely secret in an outgoing range, OR the scanner is
#       unavailable (FAIL CLOSED — a missing scanner must not silently pass).
#
# Bypass (use sparingly): git push --no-verify
# Prefer instead: route the secret to the Home.aDNA broker (NAMES only, Rule 6),
# or add a scoped .gitleaks.toml allowlist entry / `gitleaks:allow` annotation.
#
# Self-test:  pre-push-secret-scan.sh --self-test   (no repo mutation)

set -euo pipefail

GITLEAKS_MIN_HINT="brew install gitleaks"
ZERO_SHA="0000000000000000000000000000000000000000"

# --------------------------------------------------------------------------
# Self-test mode — engine present + flags a known-bad string + passes a
# known-good one (same probe discipline as the sibling pre-commit hook).
# Range construction is proven by the stdin-fed live tests in the S267 record.
# --------------------------------------------------------------------------
if [[ "${1:-}" == "--self-test" ]]; then
  if ! command -v gitleaks >/dev/null 2>&1; then
    echo "FAIL(self-test): gitleaks not on PATH — install it ($GITLEAKS_MIN_HINT)."
    exit 1
  fi
  echo "INFO(self-test): gitleaks $(gitleaks version 2>/dev/null)"
  # Probe token assembled at runtime so the literal never appears contiguously here.
  _bad_token="ghp_""0a1B2c3D4e5F6g7H8i9J0k1L2m3N4o5P6q7R"
  if printf 'github_pat = "%s"\n' "$_bad_token" \
      | gitleaks stdin --no-banner --redact >/dev/null 2>&1; then
    echo "FAIL(self-test): engine did NOT flag a known-bad secret."
    exit 1
  fi
  if printf 'This memo references the credential by NAME only, per Rule 6.\n' \
      | gitleaks stdin --no-banner >/dev/null 2>&1; then
    echo "OK(self-test): known-good string passed; known-bad string flagged. Gate is live."
    exit 0
  else
    echo "FAIL(self-test): engine flagged a known-good string (over-broad ruleset)."
    exit 1
  fi
fi

# --------------------------------------------------------------------------
# Pre-push scan of the outgoing ranges
# --------------------------------------------------------------------------
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

if ! command -v gitleaks >/dev/null 2>&1; then
  echo "✋ pre-push BLOCKED: gitleaks is not installed, so the outgoing commits cannot be" >&2
  echo "   scanned for secrets (ADR-011 makes this a required layer). Install it" >&2
  echo "   ($GITLEAKS_MIN_HINT) or bypass deliberately with: git push --no-verify" >&2
  exit 1   # fail closed — hardened vs the federated skeleton's warn-and-pass
fi

# Config search order — identical to the federated skeleton (F-W3-a).
if   [[ -n "${GITLEAKS_CONFIG:-}" ]];          then config="$GITLEAKS_CONFIG"
elif [[ -f "$REPO_ROOT/git/.gitleaks.toml" ]]; then config="$REPO_ROOT/git/.gitleaks.toml"
elif [[ -f "$REPO_ROOT/.gitleaks.toml" ]];     then config="$REPO_ROOT/.gitleaks.toml"
else config=""
fi
CFG_ARGS=()
[[ -n "$config" && -f "$config" ]] && CFG_ARGS=(--config "$config")

blocked=0
scanned=0
while read -r local_ref local_sha remote_ref remote_sha; do
  [[ -z "${local_ref:-}" ]] && continue
  if [[ "$local_sha" == "$ZERO_SHA" ]]; then
    continue                     # ref delete — nothing outgoing to scan
  fi
  if [[ "$remote_sha" == "$ZERO_SHA" ]]; then
    # New remote ref: scan everything reachable from local_sha that no known remote
    # already has. With zero remote-tracking refs this degrades to a full-history
    # scan of the ref — expensive but fail-safe (never silently narrower).
    log_opts="$local_sha --not --remotes"
    range_desc="$local_ref (new ref: $local_sha --not --remotes)"
  else
    log_opts="$remote_sha..$local_sha"
    range_desc="$local_ref ($remote_sha..$local_sha)"
  fi
  scanned=$((scanned + 1))
  echo "pre-push: gitleaks scanning outgoing range — $range_desc" >&2
  if ! gitleaks git --redact --no-banner "${CFG_ARGS[@]}" --log-opts="$log_opts" . \
       >/dev/null 2>"/tmp/gitleaks_prepush.$$"; then
    blocked=1
    echo "✋ pre-push BLOCKED: gitleaks detected a likely secret in $range_desc" >&2
    echo "   (output redacted — secret values are not printed)" >&2
    sed 's/^/   /' "/tmp/gitleaks_prepush.$$" 2>/dev/null | tail -n 30 >&2 || true
  fi
  rm -f "/tmp/gitleaks_prepush.$$"
done

if [[ "$blocked" -eq 1 ]]; then
  cat >&2 <<'EOF'
   Remediate before pushing (ADR-011 D5):
     1. Purge from history: git-filter-repo (preferred) or BFG.
     2. Rotate the exposed credential via the Home.aDNA broker.
     3. Re-scan; push only when clean.
   False positive? Add a scoped allowlist entry to .gitleaks.toml (justify it),
   or annotate the line with a 'gitleaks:allow' comment.
EOF
  exit 1
fi

if [[ "$scanned" -gt 0 ]]; then
  echo "pre-push: gitleaks clean across $scanned outgoing range(s) ✓" >&2
fi
exit 0
