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

# ---------------------------------------------------------------------------
# LICENSED FIXTURE (ADR-013 A1) — the dispatch cases below test BACKEND DISPATCH,
# not licensing, and A1 §1 makes a license a precondition of the Codeberg and
# public lanes. Run them from inside a licensed repo so each case still tests the
# one thing it was written to test.
#
# ⛔ WHY THIS FIXTURE EXISTS AT ALL — F-P7b-m, filed 2026-08-24 against this harness.
#   Before A1, six of these cases asserted, AS PASSES, that we could plan an
#   unlicensed Codeberg placement and an unlicensed public flip. The harness did
#   not merely fail to catch the gap — IT ENCODED IT, and printed green for two
#   months. A conformance suite written before a precondition existed will assert
#   the precondition's absence, and go on asserting it after the rule arrives.
# ---------------------------------------------------------------------------
LICFIX="$(mktemp -d)"; ( cd "$LICFIX" && git init -q . && printf 'MIT License\n\nCopyright (c) 2026\n' > LICENSE )
_HOMEDIR="$PWD"; cd "$LICFIX" || exit 1

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
#
# ⛔ ASSERTIONS TIGHTENED 2026-08-24 (F-P7b-m, second limb). These three used to grep
#   for the bare word "REFUSED" — and once the A1 license gate landed IN FRONT of the
#   live guard, all three began matching `REFUSED[license-gate]` and NEVER REACHED the
#   live guard at all. They kept printing PASS while testing nothing they were written
#   to test. ⭐ That is A6's own fifth direction — a check that cannot DISCRIMINATE —
#   reproduced by A6's ratifier, in the same sitting, by adding a second refusal path
#   in front of the first. A check that greps for a WORD is hostage to every future
#   caller of that word; these now name the guard they mean.
unset GITOPS_DRY_RUN
refused="$(gitops_create_repo codeberg.org "$ORG" "$REPO" 2>&1 || true)"
check "[safety] create-repo refused without GITOPS_ALLOW_LIVE" "GITOPS_ALLOW_LIVE=1" "$refused"
check "[safety] create-repo refusal is the LIVE guard, not the license gate" "REFUSED[create-repo]" "$refused"
refused_co="$(gitops_create_org codeberg.org "$ORG" 2>&1 || true)"
check "[safety] create-org refused without GITOPS_ALLOW_LIVE" "GITOPS_ALLOW_LIVE=1" "$refused_co"
refused_sv="$(gitops_set_visibility github.com "$ORG" "$REPO" public 2>&1 || true)"
check "[safety] set-visibility refused without GITOPS_ALLOW_LIVE" "GITOPS_ALLOW_LIVE=1" "$refused_sv"
check "[safety] set-visibility refusal is the LIVE guard, not the license gate" "REFUSED[set-visibility]" "$refused_sv"
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

# ---------------------------------------------------------------------------
# LICENSE GATE (ADR-013 A1). Both arms per A4 §6 + A5 §2: sabotage fixtures
# REQUIRED TO BLOCK, and controls REQUIRED TO PASS. The controls are not padding —
# a gate stuck at BLOCK is as useless as one stuck at PASS, and F-P7b-d is the
# instance where three sabotage fixtures reported `ok` because the check was dead.
#
# The controls also pin the gate's SCOPE, which is the part most likely to drift:
# a licensing gate that creeps onto private non-Codeberg placements would block
# most of the fleet's ordinary work, and one that blocks → private would block
# its own remedy.
# ---------------------------------------------------------------------------
export GITOPS_DRY_RUN=1
LIC_NO="$(mktemp -d)";  ( cd "$LIC_NO"  && git init -q . )                                        # no LICENSE
LIC_YES="$(mktemp -d)"; ( cd "$LIC_YES" && git init -q . && printf 'Apache License\nVersion 2.0\n' > LICENSE )
LIC_BARE="$(mktemp -d)"                                                                            # not a repo at all

# -- meta-control: the unlicensed fixture is GENUINELY unlicensed, so the must-block
#    cases below cannot block for the wrong reason (cf. the dangling-fixture meta-control).
check_rc "[license] fixture is genuinely unlicensed (meta-control)" 0 \
  "$( [ ! -e "$LIC_NO/LICENSE" ] && echo 0 || echo 1 )"

# -- SABOTAGE: unlicensed onto the Codeberg lane (any visibility — ToS binds on the host)
out="$(cd "$LIC_NO" && gitops_create_repo codeberg.org "$ORG" "$REPO" private 2>&1)"; rc=$?
check_rc "[license] SABOTAGE: unlicensed → Codeberg-private BLOCKS"  51 "$rc"
check    "[license] SABOTAGE: Codeberg block names the ToS, not style" "FOSS-only by ToS" "$out"

# -- SABOTAGE: unlicensed onto a public lane, at creation
out="$(cd "$LIC_NO" && gitops_create_repo github.com "$ORG" "$REPO" public 2>&1)"; rc=$?
check_rc "[license] SABOTAGE: unlicensed → GitHub-public BLOCKS"     51 "$rc"
check    "[license] SABOTAGE: public block names all-rights-reserved" "all-rights-reserved" "$out"

# -- SABOTAGE: unlicensed onto a public lane, at the FLIP (the Wave-2 verb — this is the
#    exact act that put 3 of 4 public graphs into all-rights-reserved distribution)
out="$(cd "$LIC_NO" && gitops_set_visibility github.com "$ORG" "$REPO" public 2>&1)"; rc=$?
check_rc "[license] SABOTAGE: unlicensed → public FLIP BLOCKS"       51 "$rc"

# -- SABOTAGE: undeterminable reading. NOT a pass, and a DIFFERENT code from a clean
#    block — an unknown reading is never a silent pass (ADR-011 A4 §2(a)), and it is
#    also not the same repair as a missing LICENSE.
out="$(cd "$LIC_BARE" && gitops_create_repo codeberg.org "$ORG" "$REPO" private 2>&1)"; rc=$?
check_rc "[license] SABOTAGE: no repo root → BLOCKS (52, not 51, not 0)" 52 "$rc"
check    "[license] SABOTAGE: undeterminable says so"  "cannot determine a repo root" "$out"

# -- control: licensed onto the Codeberg lane → the verb PLANS normally
out="$(cd "$LIC_YES" && gitops_create_repo codeberg.org "$ORG" "$REPO" private 2>&1)"; rc=$?
check_rc "[license] control: licensed → Codeberg PLANS"             0 "$rc"
check    "[license] control: licensed reports OK with the id"       "license-gate OK" "$out"
check    "[license] control: the PLAN still emits (gate is not a detour)" "/api/v1/" "$out"

# -- control: unlicensed, PRIVATE, non-Codeberg → OUT OF SCOPE. Must not block.
#    D1 scopes the predicate to rows 1 and 2; a gate that overreaches here would
#    stop most of the fleet's ordinary work on a rule that does not apply to it.
out="$(cd "$LIC_NO" && gitops_create_repo github.com "$ORG" "$REPO" private 2>&1)"; rc=$?
check_rc "[license] control: unlicensed GitHub-PRIVATE is out of scope" 0 "$rc"
check    "[license] control: out-of-scope lane is SILENT, not warned"   "gh api" "$out"

# -- control: → PRIVATE is the REMEDIATION direction and is never gated.
#    ⭐ A gate that blocks the fix for the state it detects converts a finding into a trap.
out="$(cd "$LIC_NO" && gitops_set_visibility github.com "$ORG" "$REPO" private 2>&1)"; rc=$?
check_rc "[license] control: unlicensed → PRIVATE flip is never blocked" 0 "$rc"

# -- control: the ack is a DECLARATION and gets its own verdict word.
#    ⛔ It must NOT print "OK" — a bypass that greps the same as a pass is how a
#    log stops being able to tell a decision from a check (A4 §5's asymmetry).
out="$(cd "$LIC_NO" && GITOPS_LICENSE_ACK='operator: BSL-1.1 pending legal' gitops_create_repo codeberg.org "$ORG" "$REPO" private 2>&1)"; rc=$?
check_rc "[license] control: explicit ack proceeds"                 0 "$rc"
check    "[license] control: ack prints BYPASSED"                   "license-gate BYPASSED" "$out"
check    "[license] control: ack is NOT reported as a pass"         "NOT a passing check" "$out"
check_rc "[license] control: ack output contains no 'license-gate OK'" 0 \
  "$(printf '%s' "$out" | grep -cF 'license-gate OK')"

rm -rf "$LIC_NO" "$LIC_YES" "$LIC_BARE" "$LICFIX"
cd "$_HOMEDIR" || true

echo "---"
printf 'dry-run harness: %d passed, %d failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
