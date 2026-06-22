#!/usr/bin/env bash
# gitops_dispatch.sh — platform-agnostic git-ops dispatch lib (Git.aDNA · status: draft)
#
# Contract:  what/specs/spec_gitops_provider_abstraction.md  (binds ADR-004/005/006/007/008/011)
# Backends:  GitHub-API (gh api)  +  raw Forgejo REST /api/v1  (codeberg.org + self-hosted both run Forgejo)
# Tool-of-record: gh (GitHub) / curl against /api/v1 (Forgejo) — NOT tea/fj (ADR-004 D3).
#
# SAFETY (three execution states):
#   GITOPS_DRY_RUN=1   → print the PLAN only (no network, no secrets, no writes).  ← default everywhere up to P4
#   (neither flag)     → REFUSE (return 3); no outward writes without explicit authorization.
#   GITOPS_ALLOW_LIVE=1 (and DRY_RUN unset) → LIVE path — wired P5 Step 0 (2026-06-20). Refuses otherwise.
# Token discipline (ADR-007 D3): tokens are resolved by ENV-VAR NAME, read indirectly at exec, asserted
#   non-empty, passed to curl out-of-band (via --config stdin, never argv) / to git via http.extraHeader
#   env config (never persisted to .git/config); never echoed; redacted from any error surface.
# This file is SOURCED by skills + the dry-run harness; it deliberately does NOT set -e.

# ── host → backend / token-env / api-base ────────────────────────────────────
gitops_backend_for_host() {            # <host> → github|forgejo
  case "$1" in
    github.com) echo github ;;
    *)          echo forgejo ;;        # codeberg.org + git.<subnet>.adna.network
  esac
}

gitops_token_env_for_host() {          # <host> → env-var NAME (never the value) — ADR-007 D3
  case "$1" in
    github.com)   echo GITHUB_TOKEN ;;
    codeberg.org) echo CODEBERG_TOKEN ;;
    *)            echo FORGEJO_TOKEN ;;
  esac
}

gitops_api_base_for_host() {           # <host> → REST base
  case "$1" in
    github.com) echo "https://api.github.com" ;;
    *)          echo "https://$1/api/v1" ;;
  esac
}

gitops_remote_url() { echo "https://$1/$2/$3.git"; }   # <host> <org> <repo>

# ── plan / refuse / exec emitter ─────────────────────────────────────────────
_gitops_run() {                         # <verb-label> <PLAN-display> -- <real argv…>
  local label="$1" plan="$2"; shift 2
  [ "${1:-}" = "--" ] && shift
  if [ "${GITOPS_DRY_RUN:-0}" = "1" ]; then
    printf 'PLAN[%s] %s\n' "$label" "$plan"
    return 0
  fi
  if [ "${GITOPS_ALLOW_LIVE:-0}" != "1" ]; then
    printf 'REFUSED[%s] live execution requires GITOPS_ALLOW_LIVE=1 (P5+ only); would run: %s\n' "$label" "$plan" >&2
    return 3
  fi
  "$@"                                  # LIVE — dispatch the real executor (token never on this line)
}

# ── live executors (reached only when GITOPS_ALLOW_LIVE=1 and DRY_RUN unset) ──
_gitops_token_value() {                 # <env-var-name> → value on stdout (never logged); fail if empty
  # Portable indirect read (no bash-only ${!name}; works under bash AND zsh) over the fixed token set.
  local name="$1" val=""
  case "$name" in
    GITHUB_TOKEN)   val="${GITHUB_TOKEN:-}" ;;
    CODEBERG_TOKEN) val="${CODEBERG_TOKEN:-}" ;;
    FORGEJO_TOKEN)  val="${FORGEJO_TOKEN:-}" ;;
    *)              val="" ;;            # keep in lock-step with gitops_token_env_for_host()
  esac
  [ -n "$val" ] || { printf 'gitops: $%s is empty/unset (credential broker: Home.aDNA)\n' "$name" >&2; return 4; }
  printf '%s' "$val"
}

_gitops_redact() {                      # <text> <token-value> → text with token masked
  local text="$1" tok="$2"
  [ -n "$tok" ] && text="${text//$tok/***REDACTED***}"
  printf '%s' "$text"
}

_gitops_api() {                         # <METHOD> <url> <token-env-name> [json-body] [--idempotent]
  command -v curl >/dev/null 2>&1 || { echo 'gitops: curl not found' >&2; return 6; }
  local method="$1" url="$2" tokenv="$3" body="${4:-}" idem="${5:-}"
  local tok; tok="$(_gitops_token_value "$tokenv")" || return 4
  [ -n "$tok" ] || { printf 'gitops: refusing %s %s — no token (guard)\n' "$method" "$url" >&2; return 4; }   # belt-and-suspenders: never reach curl tokenless
  local args=(-sS --fail-with-body -X "$method" -H 'Content-Type: application/json' -w $'\n%{http_code}')
  [ -n "$body" ] && args+=(--data "$body")
  # Authorization passed via --config on stdin → token never appears in argv (ps-invisible).
  local out rc code
  out="$(printf 'header = "Authorization: token %s"\n' "$tok" | curl --config - "${args[@]}" "$url")"; rc=$?
  code="${out##*$'\n'}"; out="${out%$'\n'*}"
  if [ "$rc" -ne 0 ]; then
    if [ "$idem" = --idempotent ] && { [ "$code" = 409 ] || [ "$code" = 422 ]; }; then
      printf 'gitops: %s %s → %s (exists; idempotent OK)\n' "$method" "$url" "$code" >&2
      return 0
    fi
    printf 'gitops: %s %s → HTTP %s\n%s\n' "$method" "$url" "${code:-ERR}" "$(_gitops_redact "$out" "$tok")" >&2
    return 5
  fi
  printf '%s' "$out"
}

_gitops_gh() {                          # <gh args…> — gh reads GITHUB_TOKEN / gh auth (self-redacts)
  command -v gh >/dev/null 2>&1 || { echo 'gitops: gh CLI not found' >&2; return 6; }
  gh "$@"
}

_gitops_gh_create_repo() {              # <org> <repo> <private-bool> (idempotent get-or-create; rename-redirect-safe)
  local org="$1" repo="$2" priv="$3" got want
  # gh/GitHub follows a 301 redirect for a RENAMED repo, so a *vacated* name can falsely read as "exists"
  # (P5 finding: archiving Git.aDNA→Git.aDNA-legacy left the old name redirecting). Compare the resolved
  # full_name — only an EXACT (case-insensitive) match counts as existing; a redirect ⇒ create.
  want="$(printf '%s/%s' "$org" "$repo" | tr '[:upper:]' '[:lower:]')"
  if got="$(_gitops_gh api "/repos/$org/$repo" --jq .full_name 2>/dev/null)" && \
     [ "$(printf '%s' "$got" | tr '[:upper:]' '[:lower:]')" = "$want" ]; then
    printf 'gitops: %s/%s exists (idempotent OK)\n' "$org" "$repo" >&2; return 0
  fi
  _gitops_gh api -X POST "/orgs/$org/repos" -f "name=$repo" -F "private=$priv"
}

_gitops_git_set_remote() {              # <name> <url> (idempotent: add-or-set-url; tokenless URL)
  local name="$1" url="$2"
  if git remote get-url "$name" >/dev/null 2>&1; then git remote set-url "$name" "$url"
  else git remote add "$name" "$url"; fi
}

_gitops_git_push() {                    # <branch> <remote> — per-backend auth via http.extraHeader env-config (no argv/.git/config leak)
  local branch="$1" remote="$2" url host be tokenv tok authhdr rc
  url="$(git remote get-url "$remote" 2>/dev/null)" || { printf "gitops: remote '%s' not set\n" "$remote" >&2; return 7; }
  host="$(printf '%s' "$url" | sed -E 's#^[a-z]+://([^/]+)/.*#\1#')"
  be="$(gitops_backend_for_host "$host")"
  tokenv="$(gitops_token_env_for_host "$host")"
  tok="$(_gitops_token_value "$tokenv")" || return 4
  if [ "$be" = github ]; then
    # P5 finding: GitHub REJECTS a raw `Authorization: token <oauth>` extraHeader → use HTTP Basic with
    # the token as the password (user = x-access-token; the actions/checkout convention; works for
    # gho_/ghp_/github_pat_). base64 must be UNWRAPPED — GNU base64 wraps at 76 cols (PATs overflow).
    authhdr="Authorization: Basic $(printf 'x-access-token:%s' "$tok" | base64 | tr -d '\n')"
  else
    authhdr="Authorization: token $tok"   # Forgejo accepts the token header directly (proven live, P5)
  fi
  GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=http.extraHeader GIT_CONFIG_VALUE_0="$authhdr" \
    git push -u "$remote" "$branch" --tags; rc=$?
  [ "$rc" -eq 0 ] || return "$rc"
  # F1 (Wave-1a finding): a fresh Forgejo/Codeberg repo defaults to `main`; a graph on another branch
  # (e.g. master) would keep a wrong default_branch. The branch EXISTS on the remote only after the push,
  # so reconcile here (post-push), not at create-repo (empty repo ⇒ Forgejo 422). Idempotent; non-fatal on
  # failure (the push already succeeded). GitHub adopts the first pushed branch itself ⇒ no-op there.
  if [ "$be" = forgejo ]; then
    local apibase org repo
    apibase="$(gitops_api_base_for_host "$host")"
    org="$(printf '%s' "$url"  | sed -E 's#^[a-z]+://[^/]+/([^/]+)/.*#\1#')"
    repo="$(printf '%s' "$url" | sed -E 's#^[a-z]+://[^/]+/[^/]+/##; s#\.git$##')"
    if _gitops_api PATCH "$apibase/repos/$org/$repo" "$tokenv" "{\"default_branch\":\"$branch\"}" >/dev/null; then
      printf 'gitops: %s/%s default_branch → %s\n' "$org" "$repo" "$branch" >&2
    else
      printf 'gitops: WARNING — %s/%s default_branch not set to %s (push OK; PATCH it manually)\n' "$org" "$repo" "$branch" >&2
    fi
  fi
}

_gitops_place_ci() {                    # <github|forgejo> — copy Git.aDNA CI template into $PWD if absent (local, no network)
  local be="$1" root src dst
  root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." 2>/dev/null && pwd)"
  if [ "$be" = github ]; then src="$root/what/templates/ci/github/ci.yml"; dst=".github/workflows/ci.yml"
  else                        src="$root/what/templates/ci/forgejo/ci.yml"; dst=".forgejo/workflows/ci.yml"; fi
  [ -f "$src" ] || { printf 'gitops: CI template not found: %s\n' "$src" >&2; return 8; }
  [ -f "$dst" ] && { printf 'gitops: %s exists; leaving as-is (no overwrite)\n' "$dst" >&2; return 0; }
  mkdir -p "$(dirname "$dst")" && cp "$src" "$dst" && printf 'gitops: placed %s\n' "$dst" >&2
}

_gitops_mirror_note() {                 # GitHub-origin mirror is not a Forgejo op (ADR-008)
  echo 'gitops: GitHub-origin push-mirror is not a Forgejo op; use a sync workflow/Action instead (ADR-008)' >&2
  return 0
}

# Non-contract helper — smoke-teardown ONLY (not one of the 7 verbs); gated like the live path.
_gitops_delete_repo() {                 # <host> <org> <repo>
  [ "${GITOPS_ALLOW_LIVE:-0}" = "1" ] || { echo 'gitops: _gitops_delete_repo requires GITOPS_ALLOW_LIVE=1' >&2; return 3; }
  local host="$1" org="$2" repo="$3" be tokenv apibase
  be="$(gitops_backend_for_host "$host")"; tokenv="$(gitops_token_env_for_host "$host")"; apibase="$(gitops_api_base_for_host "$host")"
  if [ "$be" = github ]; then _gitops_gh api -X DELETE "/repos/$org/$repo"
  else _gitops_api DELETE "$apibase/repos/$org/$repo" "$tokenv"; fi
}

_gitops_org_note() {                    # GitHub org creation is admin/enterprise-scoped — surfaced, not silently skipped
  echo 'gitops: GitHub org creation is admin/enterprise-scoped (web UI / enterprise API); aDNA-Network already exists — no-op (non-contract)' >&2
  return 0
}

# Non-contract helper — org standup (NOT one of the 7 verbs; ADR-004 contract unchanged). Gated like the verbs.
# P5 finding: the beachhead needed an org-create path but the contract has none; added out-of-contract.
gitops_create_org() {                   # <host> <org>
  local host="$1" org="$2" be tk apibase tokenv
  be="$(gitops_backend_for_host "$host")"; tk="\$$(gitops_token_env_for_host "$host")"
  apibase="$(gitops_api_base_for_host "$host")"; tokenv="$(gitops_token_env_for_host "$host")"
  if [ "$be" = github ]; then
    _gitops_run create-org \
      "GitHub org-create is admin/enterprise-scoped (gh api POST /admin/organizations or web UI); aDNA-Network already exists — no-op for the fleet" \
      -- _gitops_org_note
  else
    _gitops_run create-org \
      "curl -X POST $apibase/orgs -H 'Authorization: token $tk' -d '{\"username\":\"$org\"}'  (Forgejo; idempotent get-or-create)" \
      -- _gitops_api POST "$apibase/orgs" "$tokenv" "{\"username\":\"$org\"}" --idempotent
  fi
}

# ── the seven verbs (ADR-004 D1) ─────────────────────────────────────────────
gitops_create_repo() {                  # <host> <org> <repo> [visibility=private]
  local host="$1" org="$2" repo="$3" vis="${4:-private}"
  local be priv tk apibase tokenv
  be="$(gitops_backend_for_host "$host")"; tk="\$$(gitops_token_env_for_host "$host")"
  apibase="$(gitops_api_base_for_host "$host")"; tokenv="$(gitops_token_env_for_host "$host")"
  [ "$vis" = private ] && priv=true || priv=false
  if [ "$be" = github ]; then
    _gitops_run create-repo \
      "gh api -X POST /orgs/$org/repos -f name=$repo -F private=$priv  (auth: $tk; idempotent get-or-create)" \
      -- _gitops_gh_create_repo "$org" "$repo" "$priv"
  else
    _gitops_run create-repo \
      "curl -X POST $apibase/orgs/$org/repos -H 'Authorization: token $tk' -d '{\"name\":\"$repo\",\"private\":$priv}'  (idempotent get-or-create)" \
      -- _gitops_api POST "$apibase/orgs/$org/repos" "$tokenv" "{\"name\":\"$repo\",\"private\":$priv}" --idempotent
  fi
}

gitops_set_remote() {                   # <host> <org> <repo> [remote=origin]
  local host="$1" org="$2" repo="$3" name="${4:-origin}" url
  url="$(gitops_remote_url "$host" "$org" "$repo")"
  _gitops_run set-remote "git remote add $name $url" -- _gitops_git_set_remote "$name" "$url"
}

gitops_push() {                         # <branch> [remote=origin]
  local branch="$1" remote="${2:-origin}"
  _gitops_run push "git push -u $remote $branch --tags  (Forgejo backend also PATCHes default_branch=$branch post-push — Wave-1a F1 fix; GitHub no-op)" -- _gitops_git_push "$branch" "$remote"
}

gitops_open_pr() {                      # <host> <org> <repo> <head> <base> [title]
  local host="$1" org="$2" repo="$3" head="$4" base="$5" title="${6:-PR}"
  local be tk apibase tokenv
  be="$(gitops_backend_for_host "$host")"; tk="\$$(gitops_token_env_for_host "$host")"
  apibase="$(gitops_api_base_for_host "$host")"; tokenv="$(gitops_token_env_for_host "$host")"
  if [ "$be" = github ]; then
    _gitops_run open-pr \
      "gh api -X POST /repos/$org/$repo/pulls -f head=$head -f base=$base -f title='$title'  (auth: $tk)" \
      -- _gitops_gh api -X POST "/repos/$org/$repo/pulls" -f "head=$head" -f "base=$base" -f "title=$title"
  else
    _gitops_run open-pr \
      "curl -X POST $apibase/repos/$org/$repo/pulls -H 'Authorization: token $tk' -d '{\"head\":\"$head\",\"base\":\"$base\",\"title\":\"$title\"}'" \
      -- _gitops_api POST "$apibase/repos/$org/$repo/pulls" "$tokenv" "{\"head\":\"$head\",\"base\":\"$base\",\"title\":\"$title\"}"
  fi
}

gitops_cut_release() {                  # <host> <org> <repo> <tag> [title] [target_commitish]
  local host="$1" org="$2" repo="$3" tag="$4" title="${5:-$4}" target="${6:-}"
  local be tk apibase tokenv
  be="$(gitops_backend_for_host "$host")"; tk="\$$(gitops_token_env_for_host "$host")"
  apibase="$(gitops_api_base_for_host "$host")"; tokenv="$(gitops_token_env_for_host "$host")"
  if [ "$be" = github ]; then
    _gitops_run cut-release \
      "gh api -X POST /repos/$org/$repo/releases -f tag_name=$tag -f name='$title'  (auth: $tk; then upload assets)" \
      -- _gitops_gh api -X POST "/repos/$org/$repo/releases" -f "tag_name=$tag" -f "name=$title"
  else
    # P5 finding: Forgejo requires target_commitish when the tag does NOT pre-exist (GitHub auto-derives).
    # Default to the current branch so a release can be cut against an un-tagged HEAD.
    [ -n "$target" ] || target="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)"
    _gitops_run cut-release \
      "curl -X POST $apibase/repos/$org/$repo/releases -H 'Authorization: token $tk' -d '{\"tag_name\":\"$tag\",\"target_commitish\":\"$target\",\"name\":\"$title\"}'  (then POST .../releases/{id}/assets)" \
      -- _gitops_api POST "$apibase/repos/$org/$repo/releases" "$tokenv" "{\"tag_name\":\"$tag\",\"target_commitish\":\"$target\",\"name\":\"$title\"}"
  fi
}

gitops_configure_mirror() {             # <origin_host> <org> <repo> <target_url>
  local host="$1" org="$2" repo="$3" target="$4"
  local be tk apibase tokenv
  be="$(gitops_backend_for_host "$host")"; tk="\$$(gitops_token_env_for_host "$host")"
  apibase="$(gitops_api_base_for_host "$host")"; tokenv="$(gitops_token_env_for_host "$host")"
  if [ "$be" = github ]; then
    _gitops_run configure-mirror \
      "GitHub origin: push-mirror is a Forgejo-origin op; for a GitHub-origin mirror use a sync workflow/Action to $target (ADR-008)" \
      -- _gitops_mirror_note
  else
    # idempotency: get-or-create / delete-then-recreate; no in-place update (ADR-004 D5)
    _gitops_run configure-mirror \
      "curl -X POST $apibase/repos/$org/$repo/push_mirrors -H 'Authorization: token $tk' -d '{\"remote_address\":\"$target\",\"sync_on_commit\":true}'  (delete+re-add to change; LFS⇒HTTPS+PAT)" \
      -- _gitops_api POST "$apibase/repos/$org/$repo/push_mirrors" "$tokenv" "{\"remote_address\":\"$target\",\"sync_on_commit\":true}" --idempotent
  fi
}

gitops_port_ci() {                      # <host>
  local host="$1"; local be; be="$(gitops_backend_for_host "$host")"
  if [ "$be" = github ]; then
    _gitops_run port-ci "place .github/workflows/ci.yml (GitHub Actions; portable source)" -- _gitops_place_ci github
  else
    _gitops_run port-ci "ensure .forgejo/workflows/ci.yml ONLY if a delta is needed; else rely on .github/workflows/ fallback (ADR-008)" -- _gitops_place_ci forgejo
  fi
}

# Sourced as a lib. If executed directly, print a one-line usage hint.
if [ "${BASH_SOURCE[0]:-$0}" = "${0}" ]; then
  echo "gitops_dispatch.sh is a sourced lib. Try: GITOPS_DRY_RUN=1 source $0 && gitops_create_repo codeberg.org aDNA-Network Demo public" >&2
  echo "Live path (P5+, outward) is gated: requires GITOPS_ALLOW_LIVE=1 + a provisioned token. See how/tests/livesmoke_gitops.sh." >&2
fi
