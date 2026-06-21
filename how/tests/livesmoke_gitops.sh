#!/usr/bin/env bash
# livesmoke_gitops.sh — OUTWARD live-smoke for the agnostic dispatch contract (Git.aDNA · P5 Step 0).
#
#   *** OUTWARD ***  This creates, pushes to, releases on, and then DELETES a REAL repo
#   (default codeberg.org/aDNA-Network/_smoke). It is NOT part of the non-outward dry-run gate
#   (how/tests/dryrun_gitops.sh) and is run by the OPERATOR at P5 ONLY, after a token is provisioned.
#
# Refuses unless ALL of: GITOPS_ALLOW_LIVE=1  AND  GITOPS_SMOKE=1  AND  the host's token is present.
#   operator run (P5):  GITOPS_ALLOW_LIVE=1 GITOPS_SMOKE=1 bash how/tests/livesmoke_gitops.sh [host] [org]
#   default host/org:   codeberg.org  aDNA-Network        (repo: _smoke)
set -uo pipefail

HOST="${1:-codeberg.org}"; ORG="${2:-aDNA-Network}"; REPO="${SMOKE_REPO:-_smoke}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$HERE/../skills/lib/gitops_dispatch.sh"

_refuse() { printf 'livesmoke REFUSED: %s\n' "$1" >&2; exit 3; }
[ "${GITOPS_ALLOW_LIVE:-0}" = "1" ] || _refuse "set GITOPS_ALLOW_LIVE=1 (outward authorization)"
[ "${GITOPS_SMOKE:-0}"      = "1" ] || _refuse "set GITOPS_SMOKE=1 (smoke opt-in)"
unset GITOPS_DRY_RUN
tokenv="$(gitops_token_env_for_host "$HOST")"
_gitops_token_value "$tokenv" >/dev/null 2>&1 || _refuse "\$$tokenv is empty/unset (broker: Home.aDNA)"

echo "=== OUTWARD live-smoke → $HOST/$ORG/$REPO  (create → push → release → DELETE) ==="
set -e
workdir="$(mktemp -d)"; trap 'rm -rf "$workdir"' EXIT

echo "[1/5] create-repo (idempotent)";        gitops_create_repo "$HOST" "$ORG" "$REPO" public
echo "[2/5] seed + set-remote + push"
(
  cd "$workdir"
  git init -q && git checkout -q -b main
  printf '# %s\nGit.aDNA agnostic-dispatch live-smoke (safe to delete).\n' "$REPO" > README.md
  git add README.md
  git -c user.email=smoke@adna.local -c user.name=adna-smoke commit -qm 'smoke: init'
  gitops_set_remote "$HOST" "$ORG" "$REPO"
  gitops_push main
)
echo "[3/5] cut-release";                       gitops_cut_release "$HOST" "$ORG" "$REPO" v0.0.0-smoke "live-smoke"
echo "[4/5] verify clone round-trip"
git clone -q "$(gitops_remote_url "$HOST" "$ORG" "$REPO")" "$workdir/clone"
test -f "$workdir/clone/README.md"
echo "[5/5] teardown — delete repo";            _gitops_delete_repo "$HOST" "$ORG" "$REPO"

echo "=== live-smoke PASS — create→push→release→clone→delete round-trip on $HOST ==="
