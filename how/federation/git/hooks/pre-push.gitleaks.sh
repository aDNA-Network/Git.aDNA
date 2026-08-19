#!/usr/bin/env bash
# pre-push.gitleaks.sh — outgoing-range secret-scan pre-push hook
# Git.aDNA SKELETON v2 (status: canonical — ADR-011 D2 as corrected by Amendment A2, 2026-08-19)
#
# v2 SUPERSEDES the P3 draft skeleton (md5 216aaca254b97d69819562d506afca29), which was a
# proven no-op at push time (F-S158-01): it ran `gitleaks git --pre-commit` (scans the STAGED
# diff — empty on push) and warned-not-blocked when the scanner was absent. v2 scans the
# ACTUAL OUTGOING RANGE from the pre-push stdin refs and FAILS CLOSED.
#
# Provenance: adopted wholesale from Network.aDNA's hardened reference implementation
# (how/code/hooks/pre-push-secret-scan.sh — Venus, FX-1/GT-93, filed 2026-07-11), with credit.
# Reproduction + adoption record: ADR-011 Amendment A2; Berthier S158 (both defects reproduced).
#
# Install (per code-home, via the git/ wrapper): symlink or copy to .git/hooks/pre-push, chmod +x.
#   ln -sf ../../git/hooks/pre-push.gitleaks.sh .git/hooks/pre-push
# Validation standard (ADR-011 A2 §4): an install is DONE only after an induced positive —
#   a planted secret in a PUSHED (not staged) commit demonstrated to BLOCK.
# Config search order (unchanged from v1 / F-W3-a-compatible):
#   $GITLEAKS_CONFIG → <repo>/git/.gitleaks.toml → <repo>/.gitleaks.toml → gitleaks defaults.
# Engine: gitleaks >= 8.19 (`gitleaks git --log-opts`; tested on 8.30.1). Tool-of-record: ADR-011 D1.
#
# HOOK_CONTRACT_VERSION=2.0.0
#
# Pre-push contract (githooks(5)): argv = <remote-name> <remote-url>; stdin = one line per
# ref being pushed: `<local-ref> <local-sha> <remote-ref> <remote-sha>`.
#
# Exit codes:
#   0 = clean — push proceeds (also: nothing to scan, e.g. deletes only)
#   1 = BLOCK — likely secret in an outgoing range, OR the scanner is unavailable
#       (FAIL CLOSED — a missing scanner must not silently pass).
#
# Bypass (use sparingly, deliberately): git push --no-verify
# Prefer instead: route the secret to the Home.aDNA broker (NAMES only, Rule 6),
# or add a scoped .gitleaks.toml allowlist entry / `gitleaks:allow` annotation.
#
# Self-test:  pre-push.gitleaks.sh --self-test   (no repo mutation)

set -euo pipefail

GITLEAKS_MIN_HINT="brew install gitleaks"
ZERO_SHA="0000000000000000000000000000000000000000"

# --------------------------------------------------------------------------
# Self-test mode — engine present + flags a known-bad string + passes a
# known-good one. Range construction is proven by the induced-positive drill
# (ADR-011 A2 §4); this probes only the engine.
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
  echo "   (Scheduled/launchd contexts: ensure the runner's PATH includes the gitleaks dir.)" >&2
  exit 1   # fail closed (ADR-011 A2 §2) — v1's warn-and-pass is retired
fi

# Config search order — v1-identical (F-W3-a-compatible).
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
