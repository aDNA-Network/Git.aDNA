#!/usr/bin/env bash
# pre-push.gitleaks.sh — secret-scan pre-push hook (Git.aDNA · P3 skeleton, status: draft)
# Implements ADR-011 D2 (continuous pre-push layer). The D4 hard gate (full-history scan
# before any host move) lives in skill_repo_migrate, not here.
#
# Install (per code-home, P3+/P6): symlink or copy to .git/hooks/pre-push and `chmod +x`.
#   ln -sf ../../git/hooks/pre-push.gitleaks.sh .git/hooks/pre-push
# Config: <repo>/.gitleaks.toml (see git/.gitleaks.toml). Tool-of-record: gitleaks (ADR-011 D1).

set -euo pipefail

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
config="${GITLEAKS_CONFIG:-$repo_root/.gitleaks.toml}"

if ! command -v gitleaks >/dev/null 2>&1; then
  echo "pre-push: WARNING — gitleaks not installed; secret scan SKIPPED." >&2
  echo "          install it (brew install gitleaks) — ADR-011 makes this a required layer." >&2
  exit 0    # skeleton: warn-not-block when the tool is absent; P6 hardens to block.
fi

cfg_args=()
[ -f "$config" ] && cfg_args=(--config "$config")

echo "pre-push: gitleaks scanning outgoing changes…" >&2
if gitleaks git --pre-commit --redact --no-banner "${cfg_args[@]}" 2>/dev/null \
   || gitleaks detect --redact --no-banner "${cfg_args[@]}"; then
  echo "pre-push: gitleaks clean ✓" >&2
  exit 0
else
  cat >&2 <<'EOF'
pre-push: BLOCKED — gitleaks found a potential secret.
  Remediate before pushing (ADR-011 D5):
    1. Purge from history: git-filter-repo (preferred) or BFG.
    2. Rotate the exposed credential via the Home.aDNA broker.
    3. Re-scan; push only when clean.
  False positive? Add a scoped allowlist entry to .gitleaks.toml (justify it).
EOF
  exit 1
fi
