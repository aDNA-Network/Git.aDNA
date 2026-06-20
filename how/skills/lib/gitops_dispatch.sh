#!/usr/bin/env bash
# gitops_dispatch.sh — platform-agnostic git-ops dispatch lib (Git.aDNA · P3 skeleton, status: draft)
#
# Contract:  what/specs/spec_gitops_provider_abstraction.md  (binds ADR-004/005/006/007/008/011)
# Backends:  GitHub-API (gh api)  +  raw Forgejo REST /api/v1  (codeberg.org + self-hosted both run Forgejo)
# Tool-of-record: gh (GitHub) / curl against /api/v1 (Forgejo) — NOT tea/fj (ADR-004 D3).
#
# SAFETY (genesis posture):
#   GITOPS_DRY_RUN=1   → print the PLAN only (no network, no secrets, no writes).  ← P3 default
#   GITOPS_ALLOW_LIVE=1 (and DRY_RUN unset) → live path (a STUB at P3; wired at P5). Refuses otherwise.
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

# ── plan/exec emitter ────────────────────────────────────────────────────────
_gitops_emit() {                        # <verb-label> <command tokens…>
  local label="$1"; shift
  if [ "${GITOPS_DRY_RUN:-0}" = "1" ]; then
    printf 'PLAN[%s] %s\n' "$label" "$*"
    return 0
  fi
  if [ "${GITOPS_ALLOW_LIVE:-0}" != "1" ]; then
    printf 'REFUSED[%s] live execution requires GITOPS_ALLOW_LIVE=1 (P5+ only); would run: %s\n' "$label" "$*" >&2
    return 3
  fi
  printf 'LIVE-STUB[%s] %s\n' "$label" "$*" >&2   # P3 keeps live unimplemented (no outward actions)
  return 0
}

# ── the seven verbs (ADR-004 D1) ─────────────────────────────────────────────
gitops_create_repo() {                  # <host> <org> <repo> [visibility=private]
  local host="$1" org="$2" repo="$3" vis="${4:-private}"
  local be priv tk; be="$(gitops_backend_for_host "$host")"; tk="\$$(gitops_token_env_for_host "$host")"
  [ "$vis" = private ] && priv=true || priv=false
  if [ "$be" = github ]; then
    _gitops_emit create-repo "gh api -X POST /orgs/$org/repos -f name=$repo -F private=$priv  (auth: $tk; idempotent get-or-create)"
  else
    _gitops_emit create-repo "curl -X POST $(gitops_api_base_for_host "$host")/orgs/$org/repos -H 'Authorization: token $tk' -d '{\"name\":\"$repo\",\"private\":$priv}'  (idempotent get-or-create)"
  fi
}

gitops_set_remote() {                   # <host> <org> <repo> [remote=origin]
  local host="$1" org="$2" repo="$3" name="${4:-origin}"
  _gitops_emit set-remote "git remote add $name $(gitops_remote_url "$host" "$org" "$repo")"
}

gitops_push() {                         # <branch> [remote=origin]
  local branch="$1" remote="${2:-origin}"
  _gitops_emit push "git push -u $remote $branch --tags"
}

gitops_open_pr() {                      # <host> <org> <repo> <head> <base> [title]
  local host="$1" org="$2" repo="$3" head="$4" base="$5" title="${6:-PR}"
  local be tk; be="$(gitops_backend_for_host "$host")"; tk="\$$(gitops_token_env_for_host "$host")"
  if [ "$be" = github ]; then
    _gitops_emit open-pr "gh api -X POST /repos/$org/$repo/pulls -f head=$head -f base=$base -f title='$title'  (auth: $tk)"
  else
    _gitops_emit open-pr "curl -X POST $(gitops_api_base_for_host "$host")/repos/$org/$repo/pulls -H 'Authorization: token $tk' -d '{\"head\":\"$head\",\"base\":\"$base\",\"title\":\"$title\"}'"
  fi
}

gitops_cut_release() {                  # <host> <org> <repo> <tag> [title]
  local host="$1" org="$2" repo="$3" tag="$4" title="${5:-$4}"
  local be tk; be="$(gitops_backend_for_host "$host")"; tk="\$$(gitops_token_env_for_host "$host")"
  if [ "$be" = github ]; then
    _gitops_emit cut-release "gh api -X POST /repos/$org/$repo/releases -f tag_name=$tag -f name='$title'  (auth: $tk; then upload assets)"
  else
    _gitops_emit cut-release "curl -X POST $(gitops_api_base_for_host "$host")/repos/$org/$repo/releases -H 'Authorization: token $tk' -d '{\"tag_name\":\"$tag\",\"name\":\"$title\"}'  (then POST .../releases/{id}/assets)"
  fi
}

gitops_configure_mirror() {             # <origin_host> <org> <repo> <target_url>
  local host="$1" org="$2" repo="$3" target="$4"
  local be tk; be="$(gitops_backend_for_host "$host")"; tk="\$$(gitops_token_env_for_host "$host")"
  if [ "$be" = github ]; then
    _gitops_emit configure-mirror "GitHub origin: push-mirror is a Forgejo-origin op; for a GitHub-origin mirror use a sync workflow/Action to $target (ADR-008)"
  else
    # idempotency: get-or-create / delete-then-recreate; no in-place update (ADR-004 D5)
    _gitops_emit configure-mirror "curl -X POST $(gitops_api_base_for_host "$host")/repos/$org/$repo/push_mirrors -H 'Authorization: token $tk' -d '{\"remote_address\":\"$target\",\"sync_on_commit\":true}'  (delete+re-add to change; LFS⇒HTTPS+PAT)"
  fi
}

gitops_port_ci() {                      # <host>
  local host="$1"; local be; be="$(gitops_backend_for_host "$host")"
  if [ "$be" = github ]; then
    _gitops_emit port-ci "place .github/workflows/ci.yml (GitHub Actions; portable source)"
  else
    _gitops_emit port-ci "ensure .forgejo/workflows/ci.yml ONLY if a delta is needed; else rely on .github/workflows/ fallback (ADR-008)"
  fi
}

# Sourced as a lib. If executed directly, print a one-line usage hint.
if [ "${BASH_SOURCE[0]:-$0}" = "${0}" ]; then
  echo "gitops_dispatch.sh is a sourced lib. Try: GITOPS_DRY_RUN=1 source $0 && gitops_create_repo codeberg.org aDNA-Network Demo public" >&2
fi
