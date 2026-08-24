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
# Install — DERIVE BOTH ENDS, HARDCODE NEITHER. Run from anywhere inside the target repo:
#
#   HOOK="$(git rev-parse --path-format=absolute --git-common-dir)/hooks/pre-push"
#   ln -sfn "$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd -P)/pre-push.gitleaks.sh" "$HOOK"
#   "$HOOK" --self-test        # <- confirms the link RESOLVES; see the note below
#
# ⛔ The v2.0.0 header documented `ln -sf ../../git/hooks/… .git/hooks/pre-push`, which resolves to
#   <repo-root>/git/hooks/ and therefore only works where a root `git/` shim exists. `ln -sf`
#   succeeds against a NON-EXISTENT target, and git SILENTLY SKIPS a hook it cannot execute — so the
#   repo reads *installed* while behaving *ungated*, with no error at install time and none at push
#   time. Measured 2026-08-24: 44/44 wrapper-carrying vaults still hold that shim, so nothing was
#   dangling — but the shim is registered in Home.aDNA §C under the ADR-045 wrapper-relocation batch
#   (window ~2026-07-30, LAPSED, disposition "batch-retire as one pre-authorized wave"), so the old
#   line was one already-approved cleanup away from generating dangling installs fleet-wide.
#
# Why `--git-common-dir` (ADR-011 A5 §3): `--git-path` RESOLVES SYMLINKS and would return the link's
#   target; `--absolute-git-dir` on a LINKED WORKTREE returns a dir with no hooks/ at all (A4 §4).
#   `-n` on `ln` matters when the target is an existing symlink-to-directory.
# Why symlink-to-canonical over copy (WGS, `WGS.aDNA/how/federation/git/CLAUDE.md`, with credit):
#   the realpath is canonical by construction, a version bump propagates without re-install, and it
#   cannot rot into the v1 no-op. Per A3 §2, installing "via the wrapper" writes into a file the live
#   hook never reads and then certifies the vault by md5-ing the file it just wrote —
#   "F-S158-01's own disease class reproduced inside the fix for it."
#
# Validation standard (ADR-011 A2 §4, as amended by A5 §1-2): an install is DONE only after an
#   induced positive — a SYNTHETIC, NON-ALLOWLISTED secret planted in a PUSHED (not staged) commit
#   and demonstrated to BLOCK — and a known-good control demonstrated to PASS. Both arms, or it is
#   not a validation.
# Config search order (unchanged from v1 / F-W3-a-compatible):
#   $GITLEAKS_CONFIG → <repo>/git/.gitleaks.toml → <repo>/.gitleaks.toml → gitleaks defaults.
# Engine: gitleaks >= 8.19 (`gitleaks git --log-opts`; tested on 8.30.1). Tool-of-record: ADR-011 D1.
#
# HOOK_CONTRACT_VERSION=2.1.0
#
# 2.1.0 (2026-08-24) — no change to the scan path. Two repairs to the INSTALL surface, both from
#   ADR-011 A6's Consequences: (i) the documented install line no longer assumes a pre-ADR-045
#   layout; (ii) `--self-test` now ASSERTS THE INSTALLED HOOK RESOLVES TO AN EXISTING EXECUTABLE.
#   Until 2.1.0 the self-test probed only the engine and therefore PASSED ON A DANGLING INSTALL —
#   absence indistinguishable from health, the same family as A4 §4's `[ -d .git ]`.
#   ⚠ v2.0.0 installs (md5 a1288f7371afa187cb1cfd8b9810a669) remain BEHAVIOURALLY CORRECT and are
#   still adjudicated PASS by census_secret_gate.sh. The defect was a comment plus a blind spot in
#   the self-test, never the range scan.
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
# Self-test mode — TWO independent assertions, and neither substitutes for the
# other:
#   (1) ENGINE — present, flags a known-bad string, passes a known-good one.
#   (2) INSTALL — the repo's live pre-push hook RESOLVES to an existing
#       executable.  Added at 2.1.0 (ADR-011 A6). Until then this mode probed
#       only the engine, so a DANGLING install self-tested green.
# Range construction is proven by the induced-positive drill (A2 §4 / A5 §1-2),
# not here.
# --------------------------------------------------------------------------

# Install assertion. Prints one row; returns 0 = ok, 1 = DANGLING, 2 = absent,
# 3 = not in a repo. ⛔ Only DANGLING is a failure, and the asymmetry is
# deliberate — see the disposition table below.
check_install() {
  local common_dir hook target self
  if ! common_dir="$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)" \
     || [ -z "$common_dir" ]; then
    echo "SKIP(self-test): not inside a git repository — ENGINE CHECKED ONLY, install unverified."
    return 3
  fi
  hook="$common_dir/hooks/pre-push"
  # This script's own absolute path — so the hint below is copy-pasteable from any cwd,
  # rather than echoing an unexpanded ${BASH_SOURCE} the reader has to resolve themselves.
  self="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd -P)/$(basename "${BASH_SOURCE[0]:-$0}")"

  # -e follows symlinks, so a dangling link is NOT -e while it IS -L. That pair
  # is the whole test: `installed` and `resolves` are different questions, and
  # conflating them is what let a dangling install read as health.
  if [ ! -e "$hook" ] && [ ! -L "$hook" ]; then
    echo "NOT_INSTALLED(self-test): no pre-push hook at $hook"
    echo "   install:  ln -sfn \"$self\" \"$hook\""
    return 2
  fi
  if [ ! -e "$hook" ]; then
    echo "FAIL(self-test): $hook is a DANGLING SYMLINK -> $(readlink "$hook" 2>/dev/null)" >&2
    echo "   ⛔ DANGLING INSTALL: the repo reads *installed* and behaves *ungated* — git silently" >&2
    echo "      skips a hook it cannot execute, and nothing errors at install or at push time." >&2
    return 1
  fi
  if [ ! -x "$hook" ]; then
    echo "FAIL(self-test): $hook exists but is NOT EXECUTABLE — git will skip it silently." >&2
    echo "   repair:  chmod +x \"$hook\"" >&2
    return 1
  fi
  target="$(cd "$(dirname "$hook")" && pwd -P)/$(basename "$hook")"
  command -v realpath >/dev/null 2>&1 && target="$(realpath "$hook" 2>/dev/null || echo "$target")"
  echo "OK(self-test): installed hook resolves to an existing executable -> $target"
  return 0
}

if [[ "${1:-}" == "--self-test" ]]; then
  # (1) ENGINE
  if ! command -v gitleaks >/dev/null 2>&1; then
    echo "FAIL(self-test): gitleaks not on PATH — install it ($GITLEAKS_MIN_HINT)."
    exit 1
  fi
  echo "INFO(self-test): gitleaks $(gitleaks version 2>/dev/null)"
  # Probe token assembled at runtime so the literal never appears contiguously here.
  # A5 §1: the plant must be SYNTHETIC and NON-ALLOWLISTED — a canonical vendor
  # documentation example is allowlisted by default rulesets and CERTIFIES AN INERT HOOK.
  _bad_token="ghp_""0a1B2c3D4e5F6g7H8i9J0k1L2m3N4o5P6q7R"
  if printf 'github_pat = "%s"\n' "$_bad_token" \
      | gitleaks stdin --no-banner --redact >/dev/null 2>&1; then
    echo "FAIL(self-test): engine did NOT flag a known-bad secret."
    exit 1
  fi
  if ! printf 'This memo references the credential by NAME only, per Rule 6.\n' \
      | gitleaks stdin --no-banner >/dev/null 2>&1; then
    echo "FAIL(self-test): engine flagged a known-good string (over-broad ruleset)."
    exit 1
  fi
  echo "OK(self-test): known-good string passed; known-bad string flagged. Engine is live."

  # (2) INSTALL — runs even when the engine passed, and can still fail the run.
  check_install || _install_rc=$?
  _install_rc="${_install_rc:-0}"

  # Disposition. ⛩ DANGLING exits 1; ABSENT does not, and the asymmetry is the point:
  #   - DANGLING is the DECEPTIVE state (reads installed, behaves ungated). It is what A6 targets.
  #   - ABSENT is HONEST, and the fleet census already resolves it to FAIL_NONE (A4 §5 draws exactly
  #     this distinction: "installed-and-broken" is a different repair from "missing").
  #   - Exiting 1 on ABSENT would also break the legitimate pre-install use: check the engine, then
  #     install.
  case "$_install_rc" in
    0) echo "OK(self-test): engine live AND install resolves. Gate is live."; exit 0 ;;
    1) echo "FAIL(self-test): engine is live but THE INSTALL IS BROKEN — this repo is ungated." >&2
       exit 1 ;;
    2) echo "OK(self-test): engine live. ⚠ Hook NOT INSTALLED here — this repo is ungated by absence,"
       echo "   which is honest and visible (census: FAIL_NONE), not the silent state above."
       exit 0 ;;
    3) exit 0 ;;
  esac
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
