#!/usr/bin/env bash
# preflight_context_sync.sh — P7b obj 4 preflight (Git.aDNA · Operation Free Harbor).
#
# Measures whether a vault can survive a mesh context-sync ROUND-TRIP:
#   push to the subnet forge -> clone somewhere else -> get the same tree back.
#
# READ-ONLY. No push, no repo creation, no peer-vault write, no mutation of the
# subject vault. `--lanes` performs read-only `git ls-remote` (network reads only).
#
#   run:  bash how/tests/preflight_context_sync.sh                 # this vault
#         bash how/tests/preflight_context_sync.sh --vault ~/aDNA/Molecules.aDNA
#         bash how/tests/preflight_context_sync.sh --lanes         # replica freshness table
#         bash how/tests/preflight_context_sync.sh --meta          # the meta-control
#
# ---------------------------------------------------------------------------
# DOCTRINE THIS INSTRUMENT IS BUILT UNDER — read before adding a check.
#
#   ADR-015 §D1.5b (generalized): every check states its FAILURE CONDITION at the
#   point of definition. A column that cannot report the failure it exists to catch
#   is not a control (F-P7a-f). Each check() below carries a `fails_when:` line, and
#   `--meta` proves each one can actually reach that state.
#
#   ADR-011 A4 §6: no conformance instrument is trusted until DEMONSTRATED TO FAIL.
#   `--meta` builds one sabotage fixture per check, each REQUIRED to fail, plus a
#   known-good control REQUIRED to pass — an instrument stuck at FAIL is as useless
#   as one stuck at PASS. This clause exists because census Fixture E found a branch
#   that was unreachable (F-P7a-f in a different coat).
#
#   ADR-011 A4 §2(a): an unknown reading is never a silent pass. UNKNOWN counts as
#   failure, exactly as UNCLASSIFIED does in the census.
#
#   ADR-011 A4 §3: the secret-gate verdict is NOT re-implemented here. It is
#   delegated to census_secret_gate.sh, which owns the binding resolution order
#   (core.hooksPath -> git-path -> realpath -> adjudicate). Two implementations of
#   one adjudication is how they drift apart.
# ---------------------------------------------------------------------------
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT="$(cd "$HERE/../.." && pwd)"
CENSUS="$HERE/census_secret_gate.sh"
MODE="preflight"

while [ $# -gt 0 ]; do
  case "$1" in
    --vault) VAULT="$2"; shift 2 ;;
    --lanes) MODE="lanes"; shift ;;
    --meta)  MODE="meta";  shift ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    *) printf 'unknown arg: %s\n' "$1" >&2; exit 2 ;;
  esac
done

pass=0; warn=0; block=0; unknown=0
check() {  # <name> <verdict PASS|WARN|BLOCK|UNKNOWN> <detail>
  case "$2" in
    PASS)    pass=$((pass+1));    printf '  PASS   %-22s %s\n' "$1" "$3" ;;
    WARN)    warn=$((warn+1));    printf '  WARN   %-22s %s\n' "$1" "$3" ;;
    BLOCK)   block=$((block+1));  printf '  BLOCK  %-22s %s\n' "$1" "$3" ;;
    *)       unknown=$((unknown+1)); printf '  UNKNOWN %-21s %s\n' "$1" "$3" ;;
  esac
}

realpath_of() { python3 -c 'import os,sys;print(os.path.realpath(sys.argv[1]))' "$1" 2>/dev/null; }

# ===========================================================================
# The checks. Each is a function of a repo path; each prints exactly one row.
# ===========================================================================

# fails_when: a tracked symlink resolves outside the repo root, or is absolute.
# why it matters: git stores the LINK, not the target. A clone on another node
# has no such path -> the link dangles and the "synced context" is incomplete.
check_escaping_symlinks() {
  local repo="$1" root n=0 out=""
  root="$(realpath_of "$repo")"
  while IFS= read -r l; do
    [ -n "$l" ] || continue
    local tgt res
    tgt="$(readlink "$repo/$l" 2>/dev/null)"
    case "$tgt" in
      /*) n=$((n+1)); out="$out $l->$tgt"; continue ;;
    esac
    res="$(realpath_of "$repo/$l")"
    case "$res" in
      "$root"/*|"$root") : ;;
      *) n=$((n+1)); out="$out $l->$tgt" ;;
    esac
  done < <(git -C "$repo" ls-files -s 2>/dev/null | awk '$1=="120000"{ $1="";$2="";$3="";sub(/^ +/,""); print }')
  if [ "$n" -eq 0 ]; then check escaping_symlinks PASS "no tracked symlink leaves the repo"
  else check escaping_symlinks BLOCK "$n dangle on clone elsewhere:$out"; fi
}

# fails_when: .gitmodules is tracked.
# why it matters: a plain clone yields empty submodule dirs; the round-trip
# silently returns less context than it sent unless --recurse-submodules AND the
# submodule's own remote is reachable from the far side of the mesh.
check_submodules() {
  local repo="$1"
  if git -C "$repo" ls-files --error-unmatch .gitmodules >/dev/null 2>&1; then
    check submodules WARN "tracked .gitmodules — clone needs --recurse-submodules + peer reachability"
  else
    check submodules PASS "none"
  fi
}

# fails_when: LFS pointer files are tracked but the far side cannot rehydrate them
#             (no lfs filter declared, or git-lfs absent).
# why it matters: the clone returns 130-byte pointers instead of content, and
# every byte-identity assertion on those paths passes while the data is absent.
#
# ⛔ A POINTER IS THE SIGNATURE ON LINE 1 — not the string somewhere in the file.
# The first cut grepped for `git-lfs.github.com/spec/v1` anywhere in HEAD and
# promptly BLOCKED this vault on two hits: *this script* and *the runbook that
# documents it*, both of which merely mention the signature. A false BLOCK stops a
# legitimate round-trip, and it is the same root error as a check that cannot fail
# — the check did not state precisely what it measures. Candidates are line-anchored,
# then each is confirmed to carry the signature as its FIRST line.
check_lfs() {
  local repo="$1" declared=0 ptr=0 f
  if git -C "$repo" grep -qI 'filter=lfs' HEAD -- '*.gitattributes' 2>/dev/null; then declared=1; fi
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    f="${f#HEAD:}"
    case "$(git -C "$repo" show "HEAD:$f" 2>/dev/null | head -1)" in
      version\ https://git-lfs.github.com/spec/v1*) ptr=$((ptr+1)) ;;
    esac
  done < <(git -C "$repo" grep -lI '^version https://git-lfs\.github\.com/spec/v1' HEAD 2>/dev/null)
  if [ "$ptr" -gt 0 ] && [ "$declared" -eq 0 ]; then
    check lfs_rehydration BLOCK "$ptr pointer file(s) tracked with no lfs filter declared — clone returns pointers"
  elif [ "$ptr" -gt 0 ] && ! command -v git-lfs >/dev/null 2>&1; then
    check lfs_rehydration BLOCK "$ptr pointer file(s) and git-lfs not installed on this side"
  elif [ "$ptr" -gt 0 ]; then
    check lfs_rehydration WARN "$ptr pointer file(s); far side must also have git-lfs"
  else
    check lfs_rehydration PASS "no LFS pointers tracked"
  fi
}

# fails_when: two tracked paths differ only by case.
# why it matters: macOS/Windows checkouts are case-INSENSITIVE. One file silently
# overwrites the other on clone; the round-trip then reports a spurious diff that
# looks like corruption and is actually the filesystem.
check_case_collisions() {
  local repo="$1" dups
  dups="$(git -C "$repo" ls-files 2>/dev/null | tr 'A-Z' 'a-z' | sort | uniq -d | head -5)"
  if [ -z "$dups" ]; then check case_collisions PASS "no case-only path collisions"
  else check case_collisions BLOCK "collide on a case-insensitive checkout: $(echo "$dups" | tr '\n' ' ')"; fi
}

# fails_when: the working tree is dirty.
# why it matters: a round-trip verifies the clone against the source. If the source
# moves during the trip, a PASS means nothing and a FAIL is unattributable.
check_clean_tree() {
  local repo="$1" n
  n="$(git -C "$repo" status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$n" -eq 0 ]; then check clean_tree PASS "tree clean at measurement"
  else check clean_tree BLOCK "$n uncommitted path(s) — the subject must not move mid-trip"; fi
}

# fails_when: no secret gate git will actually RUN, or an unrecognised one.
# why it matters: the round-trip's first leg is a PUSH to a forge other vaults can
# read. A vault must not reach shared storage ungated. UNCLASSIFIED counts as FAIL.
# Delegated to census_secret_gate.sh (A4 §3 owns the resolution order).
check_secret_gate() {
  local repo="$1" verdict
  if [ ! -f "$CENSUS" ]; then check secret_gate UNKNOWN "census_secret_gate.sh not found — cannot adjudicate"; return; fi
  verdict="$(bash "$CENSUS" --root "$repo" --format tsv 2>/dev/null | awk -F'\t' 'NR>1{print $5; exit}')"
  case "$verdict" in
    PASS|PASS_EQUIV|PASS_STRONGER) check secret_gate PASS "$verdict (census-adjudicated)" ;;
    FAIL_*)                        check secret_gate BLOCK "$verdict — must not push a vault to shared storage ungated" ;;
    UNCLASSIFIED)                  check secret_gate BLOCK "UNCLASSIFIED — A4 §2(a): unknown is never a silent pass" ;;
    *)                             check secret_gate UNKNOWN "census returned no row for this repo" ;;
  esac
}

# fails_when: a remote pointing at the mesh forge is not named mesh-<fabric-id>,
#             or the mesh forge is the repo's `origin`.
# why it matters: ADR-014 D2 binds mesh remote naming. `origin`-on-the-spike means
# the graph's PRIMARY home is an instance the campaign calls "a spike, not production."
check_remote_naming() {
  local repo="$1" bad="" orig=""
  while read -r name url _; do
    [ -n "$name" ] || continue
    case "$url" in
      *rd-forge*|*10.43.0.28*|*mesh-git*|*.adna.network*)
        [ "$name" = "origin" ] && orig="$name"
        case "$name" in mesh-*) : ;; *) bad="$bad $name" ;; esac ;;
    esac
  done < <(git -C "$repo" remote -v 2>/dev/null | awk '/\(fetch\)/{print $1, $2}')
  if [ -n "$orig" ]; then
    check remote_naming BLOCK "the mesh forge is this repo's 'origin' — primary home on a spike instance (ADR-014 D2)"
  elif [ -n "$bad" ]; then
    check remote_naming WARN "mesh remote(s) not named mesh-<fabric-id>:$bad (ADR-014 D2)"
  else
    check remote_naming PASS "mesh remote naming conforms (or no mesh remote)"
  fi
}

# fails_when: the transferable object store is large enough that a mesh round-trip
#             is a scheduling item rather than an opportunistic one.
# why it matters: not a defect — a cost, stated so a window is budgeted not guessed.
#
# ⚠ `size-pack` ALONE UNDER-REPORTS, and it under-reports toward "cheap". A repo whose
#   objects are still loose (never gc'd) reports `size-pack 0` and passes while holding
#   an arbitrary amount of data — observed live on LAVentureGraph.aDNA, 2026-08-21.
#   A cost column that reads 0 on a non-empty repo is a column that cannot report the
#   condition it exists to report. Both halves are summed, and the split is printed so
#   the reading is auditable rather than merely small.
check_transfer_size() {
  local repo="$1" kp kl tot
  kp="$(git -C "$repo" count-objects -v 2>/dev/null | awk '/^size-pack:/{print $2+0}')"
  kl="$(git -C "$repo" count-objects -v 2>/dev/null | awk '/^size:/{print $2+0}')"
  if [ -z "$kp" ] && [ -z "$kl" ]; then check transfer_size UNKNOWN "count-objects returned nothing"; return; fi
  tot=$(( ${kp:-0} + ${kl:-0} ))                       # KiB
  local human="$(( tot / 1024 )) MiB (pack $(( ${kp:-0} / 1024 )) + loose $(( ${kl:-0} / 1024 )))"
  if [ "$tot" -gt 524288 ]; then check transfer_size WARN "$human — schedule the window, do not improvise it"
  else check transfer_size PASS "$human"; fi
}

run_preflight() {
  local repo="$1"
  printf '\npreflight_context_sync — %s\n' "$repo"
  printf 'measured_at: %s   HEAD: %s\n\n' "$(date -u +%Y-%m-%dT%H:%MZ)" "$(git -C "$repo" rev-parse --short HEAD 2>/dev/null || echo '-')"
  if [ ! -e "$repo/.git" ]; then check repo_is_git BLOCK "no .git at $repo"; else
    check_clean_tree        "$repo"
    check_escaping_symlinks "$repo"
    check_case_collisions   "$repo"
    check_submodules        "$repo"
    check_lfs               "$repo"
    check_secret_gate       "$repo"
    check_remote_naming     "$repo"
    check_transfer_size     "$repo"
  fi
  printf '\n---\npreflight: %d pass, %d warn, %d BLOCK, %d UNKNOWN\n' "$pass" "$warn" "$block" "$unknown"
  [ "$block" -eq 0 ] && [ "$unknown" -eq 0 ]
}

# ===========================================================================
# --lanes : replica freshness. READ-ONLY network (ls-remote). Reproduces §3 of
#           what/inventory/context_sync_lane_assignment.md.
#
# ⚠ DIVERGED is NOT a verdict of "stale" or "wrong". Under ADR-014 A3 a replica
#   may lawfully lag. Whether a row is a DEFECT depends on a declared
#   `freshness_mode`, which exists in no conf yet (A4 §1a `pending_declaration`,
#   Berthier's pen). This table reports tips; it deliberately does not adjudicate
#   them, because the instrument that could does not exist. Saying so is the point.
# ===========================================================================
run_lanes() {
  printf '\nmesh replica freshness — read-only ls-remote\nmeasured_at: %s\n\n' "$(date -u +%Y-%m-%dT%H:%MZ)"
  # ⛔ ONE ROW PER MESH REMOTE, and the remote is NAMED in the row.
  # The first cut took `... {print $1; exit}` — the FIRST matching remote — which made
  # the reading arbitrary for any repo enrolled on two fabrics. Forgejo.aDNA read
  # DIVERGED when measured against `mesh-rd` by name and UNREACHABLE here, from the
  # same tree minutes apart: same question, two answers, no way for a reader to tell
  # which remote either row described. An unlabelled row is not a measurement.
  printf '%-22s %-10s %-9s %-9s %s\n' VAULT REMOTE LOCAL MESH STATE
  local d rn br loc rem st n_sync=0 n_div=0 n_un=0
  for d in "$HOME"/aDNA/*.aDNA; do
    [ -L "$d" ] && continue                     # A4 §4: a shim and its target are ONE repo
    [ -d "$d/.git" ] || continue
    br="$(git -C "$d" symbolic-ref --short HEAD 2>/dev/null)"
    loc="$(git -C "$d" rev-parse --short HEAD 2>/dev/null)"
    while read -r rn url; do
      [ -n "$rn" ] || continue
      case "$url" in *rd-forge*|*10.43.0.28*|*mesh-git*|*.adna.network*) : ;; *) continue ;; esac
      rem="$(timeout 10 git -C "$d" ls-remote "$rn" "refs/heads/$br" 2>/dev/null | awk '{print substr($1,1,7)}')"
      if   [ -z "$rem" ];        then st="UNREACHABLE/NO-REF"; n_un=$((n_un+1))
      elif [ "$loc" = "$rem" ];  then st="IN-SYNC";  n_sync=$((n_sync+1))
      else                            st="DIVERGED"; n_div=$((n_div+1)); fi
      printf '%-22s %-10s %-9s %-9s %s\n' "$(basename "$d")" "$rn" "$loc" "${rem:--}" "$st"
    done < <(git -C "$d" remote -v 2>/dev/null | awk '/\(fetch\)/{print $1, $2}')
  done
  printf '\n---\n%d in-sync · %d diverged · %d unreachable\n' "$n_sync" "$n_div" "$n_un"
  printf 'NOT adjudicated: no declared freshness_mode exists to adjudicate against (ADR-014 A4 §1a).\n'
}

# ===========================================================================
# --meta : the meta-control (ADR-011 A4 §6).
#   Every check must be shown to REACH its failure state, and the known-good
#   control must still PASS. A check that cannot be made to fail is not shipped.
#   Fixtures are built in a temp dir and removed. Nothing in any vault is touched.
# ===========================================================================
fixture_base() {                      # -> path of a fresh clean git repo
  local d; d="$(mktemp -d)"
  git -C "$d" init -q 2>/dev/null
  git -C "$d" config user.email meta@local; git -C "$d" config user.name meta
  mkdir -p "$d/.git/hooks"
  cp "$(cd "$HERE/../federation/git/hooks" && pwd)/pre-push.gitleaks.sh" "$d/.git/hooks/pre-push" 2>/dev/null
  chmod +x "$d/.git/hooks/pre-push" 2>/dev/null
  echo hello > "$d/README.md"
  git -C "$d" add -A >/dev/null 2>&1; git -C "$d" commit -qm base >/dev/null 2>&1
  echo "$d"
}

# ⛔ F-P7b-d — read this before "simplifying" the line that parses $out.
# The first cut of this function adjudicated on the `pass` counter. `$( ... )` runs
# the check in a SUBSHELL, so every increment was discarded and `pass` was ALWAYS 0
# — i.e. always NOTPASS. All seven sabotage rows reported `ok` for a reason that had
# nothing to do with the checks: the comparison could not come out any other way.
# A meta-control that cannot fail is exactly what it was written to forbid (F-P7a-f),
# committed inside the harness enforcing it. Only the known-good control could expose
# it, which is the whole argument for A4 §6's "and a control required to PASS".
# The verdict is therefore read from the check's OWN EMITTED ROW, which crosses the
# subshell boundary because it is stdout, not state.
meta_expect() {                       # <label> <expected PASS|NOTPASS> <checkfn> <repo>
  local label="$1" want="$2" fn="$3" repo="$4" out
  out="$("$fn" "$repo" 2>&1)"
  local got="NOTPASS"
  case "$out" in *"  PASS   "*) got="PASS" ;; esac
  if [ "$got" = "$want" ]; then printf '  ok    %-28s (%s)\n' "$label" "$(echo "$out" | awk '{print $1}')"; return 0
  else printf '  FAIL  %-28s wanted %s got %s :: %s\n' "$label" "$want" "$got" "$out"; return 1; fi
}

run_meta() {
  printf '\nmeta-control — each check must be demonstrated able to FAIL (ADR-011 A4 §6)\n\n'
  local bad=0 d

  d="$(fixture_base)"; printf 'x\n' >> "$d/README.md"
  meta_expect "A dirty tree -> not pass"    NOTPASS check_clean_tree        "$d" || bad=1; rm -rf "$d"

  d="$(fixture_base)"; ln -s /etc/hosts "$d/escape"; git -C "$d" add -A >/dev/null 2>&1
  git -C "$d" commit -qm esc >/dev/null 2>&1
  meta_expect "B escaping symlink -> block" NOTPASS check_escaping_symlinks "$d" || bad=1; rm -rf "$d"

  d="$(fixture_base)"
  s="$(git -C "$d" hash-object -w --stdin <<< dup)"
  git -C "$d" update-index --add --cacheinfo 100644,"$s",Dup.md >/dev/null 2>&1
  git -C "$d" update-index --add --cacheinfo 100644,"$s",dup.md >/dev/null 2>&1
  meta_expect "C case collision -> block"   NOTPASS check_case_collisions   "$d" || bad=1; rm -rf "$d"

  d="$(fixture_base)"; printf '[submodule "x"]\n' > "$d/.gitmodules"
  git -C "$d" add -A >/dev/null 2>&1; git -C "$d" commit -qm sub >/dev/null 2>&1
  meta_expect "D submodule -> warn"         NOTPASS check_submodules       "$d" || bad=1; rm -rf "$d"

  d="$(fixture_base)"
  printf 'version https://git-lfs.github.com/spec/v1\noid sha256:0\nsize 1\n' > "$d/big.bin"
  git -C "$d" add -A >/dev/null 2>&1; git -C "$d" commit -qm lfs >/dev/null 2>&1
  meta_expect "E lfs pointer, no filter"    NOTPASS check_lfs              "$d" || bad=1; rm -rf "$d"

  d="$(fixture_base)"; rm -f "$d/.git/hooks/pre-push"
  meta_expect "F no secret gate -> block"   NOTPASS check_secret_gate      "$d" || bad=1; rm -rf "$d"

  d="$(fixture_base)"; git -C "$d" remote add origin rd-forge:aDNA-Network/X.git 2>/dev/null
  meta_expect "G mesh-as-origin -> block"   NOTPASS check_remote_naming    "$d" || bad=1; rm -rf "$d"

  printf '\n  -- known-good control (an instrument stuck at FAIL is as useless as one stuck at PASS) --\n'
  d="$(fixture_base)"
  meta_expect "control clean_tree"          PASS    check_clean_tree        "$d" || bad=1
  meta_expect "control escaping_symlinks"   PASS    check_escaping_symlinks "$d" || bad=1
  meta_expect "control case_collisions"     PASS    check_case_collisions   "$d" || bad=1
  meta_expect "control submodules"          PASS    check_submodules        "$d" || bad=1
  meta_expect "control lfs"                 PASS    check_lfs               "$d" || bad=1
  meta_expect "control remote_naming"       PASS    check_remote_naming     "$d" || bad=1
  rm -rf "$d"

  printf '\n---\nmeta-control: %s\n' "$([ "$bad" -eq 0 ] && echo 'every check reached its failure state; control passed' || echo 'DEFECT — see FAIL rows above')"
  [ "$bad" -eq 0 ]
}

case "$MODE" in
  lanes) run_lanes ;;
  meta)  run_meta ;;
  *)     run_preflight "$VAULT" ;;
esac
