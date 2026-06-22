#!/usr/bin/env bash
# dryrun_gitops.sh — P3 exit-gate harness (Git.aDNA · Operation Free Harbor).
# Proves the verb→backend dispatch for BOTH GitHub and Forgejo in PLAN mode.
# NO network, NO secrets, NO writes. Exit 0 iff every assertion passes.
#   run:  bash how/tests/dryrun_gitops.sh
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB="$HERE/../skills/lib/gitops_dispatch.sh"
export GITOPS_DRY_RUN=1
# shellcheck source=/dev/null
source "$LIB"

pass=0; fail=0
check() { # <desc> <expected-substring> <actual>
  local desc="$1" expect="$2" actual="$3"
  if printf '%s' "$actual" | grep -qF -- "$expect"; then
    printf 'PASS  %s\n' "$desc"; pass=$((pass+1))
  else
    printf 'FAIL  %s\n        want substring: %s\n        got: %s\n' "$desc" "$expect" "$actual"; fail=$((fail+1))
  fi
}

ORG=aDNA-Network; REPO=Demo

for host in github.com codeberg.org; do
  be="$(gitops_backend_for_host "$host")"
  if [ "$be" = github ]; then api="gh api"; want_be=github; tokv=GITHUB_TOKEN; ci=.github/workflows
  else api="/api/v1/"; want_be=forgejo; tokv=CODEBERG_TOKEN; ci=.forgejo/workflows; fi

  check "[$host] backend=$want_be"            "$want_be" "$be"
  check "[$host] token-env=$tokv (name only)" "$tokv"    "$(gitops_token_env_for_host "$host")"
  check "[$host] create-repo → $api"          "$api"     "$(gitops_create_repo "$host" "$ORG" "$REPO" public)"
  check "[$host] set-remote → $host url"       "$host/$ORG/$REPO.git" "$(gitops_set_remote "$host" "$ORG" "$REPO")"
  check "[$host] push → git push"             "git push" "$(gitops_push main)"
  check "[$host] open-pr → $api"              "$api"     "$(gitops_open_pr "$host" "$ORG" "$REPO" feat main 'x')"
  check "[$host] cut-release → $api"          "$api"     "$(gitops_cut_release "$host" "$ORG" "$REPO" v0.1.0)"
  check "[$host] port-ci → $ci"               "$ci"      "$(gitops_port_ci "$host")"
  check "[$host] set-visibility → $api"       "$api"     "$(gitops_set_visibility "$host" "$ORG" "$REPO" public)"
done

# configure-mirror: Forgejo origin → push_mirrors; GitHub origin → mirror note (ADR-004 D5 / ADR-008)
check "[codeberg.org] configure-mirror → push_mirrors" \
  "/api/v1/repos/$ORG/$REPO/push_mirrors" \
  "$(gitops_configure_mirror codeberg.org "$ORG" "$REPO" "https://github.com/$ORG/$REPO.git")"
check "[github.com] configure-mirror → mirror note" \
  "mirror" \
  "$(gitops_configure_mirror github.com "$ORG" "$REPO" "https://codeberg.org/$ORG/$REPO.git")"

# cut-release: Forgejo body must carry target_commitish (P5 fix) so an un-tagged HEAD can be released
check "[codeberg.org] cut-release carries target_commitish" \
  "target_commitish" \
  "$(gitops_cut_release codeberg.org "$ORG" "$REPO" v0.1.0)"

# create-org: non-contract helper (ADR-004 unchanged) — Forgejo POST /orgs; GitHub = admin-scoped note
check "[codeberg.org] create-org → /api/v1/orgs" \
  "/api/v1/orgs" \
  "$(gitops_create_org codeberg.org "$ORG")"
check "[github.com] create-org → admin-scoped note" \
  "admin" \
  "$(gitops_create_org github.com "$ORG")"

# push: advertises the Forgejo post-push default_branch reconcile (Wave-1a F1 fix; GitHub no-op)
check "[push] advertises Forgejo default_branch reconcile (F1)" \
  "default_branch" \
  "$(gitops_push main)"

# set-visibility: non-contract helper (ADR-013 D4 release open-flow; Wave-2 finding 2026-06-22).
# GitHub PATCH -F private=<bool>; Forgejo PATCH {private:<bool>}. public⇒false, private⇒true (rollback dir).
check "[github.com] set-visibility public → private=false (the Wave-2 live path)" \
  "private=false" \
  "$(gitops_set_visibility github.com "$ORG" "$REPO" public)"
check "[github.com] set-visibility private → private=true (re-privatize/rollback)" \
  "private=true" \
  "$(gitops_set_visibility github.com "$ORG" "$REPO" private)"
check "[codeberg.org] set-visibility public → {\"private\":false} (portability)" \
  '"private":false' \
  "$(gitops_set_visibility codeberg.org "$ORG" "$REPO" public)"
check "[input] set-visibility rejects a bad arg" \
  "needs public|private" \
  "$(gitops_set_visibility github.com "$ORG" "$REPO" bogus 2>&1)"

# safety: with dry-run OFF and no GITOPS_ALLOW_LIVE, the lib must REFUSE (no outward writes)
unset GITOPS_DRY_RUN
refused="$(gitops_create_repo codeberg.org "$ORG" "$REPO" 2>&1 || true)"
check "[safety] create-repo refused without GITOPS_ALLOW_LIVE" "REFUSED" "$refused"
refused_co="$(gitops_create_org codeberg.org "$ORG" 2>&1 || true)"
check "[safety] create-org refused without GITOPS_ALLOW_LIVE" "REFUSED" "$refused_co"
refused_sv="$(gitops_set_visibility github.com "$ORG" "$REPO" public 2>&1 || true)"
check "[safety] set-visibility refused without GITOPS_ALLOW_LIVE" "REFUSED" "$refused_sv"
export GITOPS_DRY_RUN=1

echo "---"
printf 'dry-run harness: %d passed, %d failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
