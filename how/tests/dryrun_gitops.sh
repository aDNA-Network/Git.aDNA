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

# ---------------------------------------------------------------------------
# Hook INSTALL SURFACE (ADR-011 A6 / contract 2.1.0). Both arms per A4 §6 + A5 §2:
# sabotage fixtures REQUIRED TO FAIL, and controls REQUIRED TO PASS. A suite of
# must-fail cases alone cannot distinguish "the check works" from "the check is
# dead" — F-P7b-d, where three sabotage fixtures reported `ok` because the check
# was CRASHING, and only the known-good controls exposed it.
#
# Everything below runs in a throwaway repo under a mktemp dir. NO live repo is
# touched, and no network is used.
# ---------------------------------------------------------------------------
HOOK_SRC="$HERE/../federation/git/hooks/pre-push.gitleaks.sh"

check_rc() { # <desc> <expected-rc> <actual-rc>
  local desc="$1" expect="$2" actual="$3"
  if [ "$expect" = "$actual" ]; then
    printf 'PASS  %s\n' "$desc"; pass=$((pass+1))
  else
    printf 'FAIL  %s\n        want exit: %s\n        got exit: %s\n' "$desc" "$expect" "$actual"; fail=$((fail+1))
  fi
}

if command -v gitleaks >/dev/null 2>&1; then
  _t="$(mktemp -d)"
  ( cd "$_t" && git init -q r ) 2>/dev/null
  _r="$_t/r"; _hookpath="$_r/.git/hooks/pre-push"

  # -- control: correctly installed -> resolves, exit 0
  ln -sfn "$(cd "$(dirname "$HOOK_SRC")" && pwd -P)/pre-push.gitleaks.sh" "$_hookpath"
  out="$(cd "$_r" && bash "$HOOK_SRC" --self-test 2>&1)"; rc=$?
  check_rc "[hook] control: good install -> exit 0"            0 "$rc"
  check    "[hook] control: good install -> OK row"            "installed hook resolves" "$out"

  # -- sabotage: the PRE-2.1.0 DOCUMENTED INSTALL LINE, in a repo with no root git/ shim.
  #    This is the exact defect A6 named. Under 2.0.0 this self-tested GREEN.
  ln -sfn ../../git/hooks/pre-push.gitleaks.sh "$_hookpath"
  # meta-control on the FIXTURE: it must really be dangling, or the must-fail case
  # below could pass for the wrong reason (a check is not validated by the direction
  # of its output).
  if [ -L "$_hookpath" ] && [ ! -e "$_hookpath" ]; then
    printf 'PASS  %s\n' "[hook] fixture is genuinely dangling (meta-control)"; pass=$((pass+1))
  else
    printf 'FAIL  %s\n' "[hook] fixture is NOT dangling — the sabotage case below proves nothing"; fail=$((fail+1))
  fi
  out="$(cd "$_r" && bash "$HOOK_SRC" --self-test 2>&1)"; rc=$?
  check_rc "[hook] SABOTAGE: dangling install -> exit 1"       1 "$rc"
  check    "[hook] SABOTAGE: dangling names the silent state"  "DANGLING INSTALL" "$out"

  # -- sabotage: present but not executable (git skips it silently, same end state)
  rm -f "$_hookpath"; cp "$HOOK_SRC" "$_hookpath"; chmod -x "$_hookpath"
  out="$(cd "$_r" && bash "$HOOK_SRC" --self-test 2>&1)"; rc=$?
  check_rc "[hook] SABOTAGE: non-executable -> exit 1"         1 "$rc"

  # -- control: absent. Ungated, but HONESTLY so (census: FAIL_NONE). Must NOT exit 1 —
  #    the asymmetry against dangling is deliberate (A4 §5: installed-and-broken is a
  #    different repair from missing) and keeps the pre-install engine check usable.
  rm -f "$_hookpath"
  out="$(cd "$_r" && bash "$HOOK_SRC" --self-test 2>&1)"; rc=$?
  check_rc "[hook] control: absent -> exit 0 (honest, not silent)" 0 "$rc"
  check    "[hook] control: absent reports NOT_INSTALLED"       "NOT_INSTALLED" "$out"

  # -- control: outside a repo -> install unverifiable, and SAID so rather than passed silently
  out="$(cd "$_t" && bash "$HOOK_SRC" --self-test 2>&1)"; rc=$?
  check_rc "[hook] control: outside a repo -> exit 0"          0 "$rc"
  check    "[hook] control: outside a repo SKIPs, not passes"  "install unverified" "$out"

  # -- the shipped digest the census now adjudicates. Keyed to the artifact, so a silent
  #    edit to the hook fails HERE rather than fleet-wide at the next census.
  _md5="$(md5 -q "$HOOK_SRC" 2>/dev/null || md5sum "$HOOK_SRC" | awk '{print $1}')"
  check "[hook] shipped digest is the one census_secret_gate PASSes" \
    "$_md5" "$(grep -o '[0-9a-f]\{32\}) echo "PASS" ;;.*v2\.1\.0' "$HERE/census_secret_gate.sh" | grep -o '^[0-9a-f]\{32\}')"

  rm -rf "$_t"
else
  printf 'SKIP  [hook] install-surface cases — gitleaks not on PATH (engine arm cannot run)\n'
fi

echo "---"
printf 'dry-run harness: %d passed, %d failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
