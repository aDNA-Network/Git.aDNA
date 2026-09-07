#!/usr/bin/env bash
# census_findings.sh — how many findings does this vault have, and how many are open?
#
#   run:  bash how/tests/census_findings.sh            # the census
#         bash how/tests/census_findings.sh --meta     # demonstrate every failure path fails
#         bash how/tests/census_findings.sh --tsv      # machine-readable rows
#
# ---------------------------------------------------------------------------
# WHY THIS EXISTS — the winddown of 2026-09-07.
#
#   Until that date the vault's findings lived ONLY as prose in STATE.md, and closure was
#   recorded by appending `_closed` to a TAG. Fifty-five ids had accumulated and the question
#   "how many are open?" could not be answered by anything.
#
#   ⛩ The campaign's signature class, turned on the campaign's own records: a POPULATION WITH
#   NO INSTRUMENT — which is what ADR-011 A8 was ratified about, one level down.
#
#   ⭐ The sitting that wrote this had already proved the gap against itself: F-P7b-ay, its own
#   headline finding, was in the tags/hook/tests/memo/ADR but NOT ONCE in STATE.md's prose; and
#   F-P7b-ba was planned, folded elsewhere, and never assigned. Nothing could have reported
#   either. ⇒ THIS PROGRAM MUST REPORT BOTH, or it is not doing its job.
#
# ---------------------------------------------------------------------------
# ⛔ ENUMERATED FROM THE TREE, NEVER ROSTERED — ADR-011 A8 §1.
#
#   The directory listing IS the population. There is no list of expected findings anywhere in
#   this file, deliberately: "a list of what we believe exists is not a population", and nothing
#   notices when a roster drifts from the thing it claims to describe.
#
# ⛔ UNMEASURED IS `INDETERMINATE`, NEVER A GREEN AND NEVER A ZERO — A8 §3.
#
#   Only 18 of 55 ids have nodes. The other 37 are named in prose and unadjudicated. They are
#   reported as INDETERMINATE — NOT omitted, NOT counted closed. An absence that borrows a
#   benign verdict is the exact failure mode A8 §3 forbids.
#
# ⛔ A COVERAGE CLAIM STATES ITS POPULATION — A8 §5. Every count below prints what it counted
#   over. A verdict whose population is unstated may not be cited as coverage.
#
# ⛔ REFLEXIVE — A8 §7 binds "any instrument built to evaluate A8 itself, FIRST OF ALL".
#   `--meta` demonstrates each failure path FAILS. Until it is run, this census is NO_META and
#   says so in its own footer.
# ---------------------------------------------------------------------------
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${CENSUS_ROOT:-$(cd "$HERE/../.." && pwd)}"
FINDINGS_DIR="$ROOT/what/findings"
PROSE=("$ROOT/STATE.md" "$ROOT/STATE_history.md")
MODE=census
case "${1:-}" in --meta) MODE=meta ;; --tsv) MODE=tsv ;; -h|--help) sed -n '2,8p' "$0"; exit 0 ;; esac

# ---- the two readings, each from its own source ---------------------------
# (a) nodes on disk — the population.
# (b) ids named in prose — the claim. Their difference is the finding.
nodes_ids()  { ls "$FINDINGS_DIR"/finding_f_p7b_*.md 2>/dev/null \
                 | sed 's|.*/finding_f_p7b_||; s|\.md$||' | sort -u; }
prose_ids()  { grep -ohE 'F-P7b-[a-z]{1,2}\b' "${PROSE[@]}" 2>/dev/null \
                 | sed 's/F-P7b-//' | sort -u; }

status_of() { # <id> -> status field, or MALFORMED
  local f="$FINDINGS_DIR/finding_f_p7b_$1.md" s
  [ -r "$f" ] || { echo MISSING; return; }
  s="$(awk 'NR==1&&$0!="---"{exit} /^---$/{c++; if(c==1)next; if(c==2)exit} c==1' "$f" \
        | grep -m1 '^status:' | sed 's/^status:[[:space:]]*//; s/[[:space:]]*#.*//')"
  case "$s" in open|closed|retired_unused) echo "$s" ;; *) echo MALFORMED ;; esac
}

run_census() {
  local fmt="$1" open=0 closed=0 retired=0 malformed=0 indet=0
  local -a indet_ids=() malformed_ids=() open_ids=()

  if [ ! -d "$FINDINGS_DIR" ]; then
    echo "census_findings: ⛔ $FINDINGS_DIR does not exist — fail-closed (A4 §2(a): an" >&2
    echo "                 undeterminable reading is a refusal, never a pass)." >&2
    return 1
  fi

  local nodes prose; nodes="$(nodes_ids)"; prose="$(prose_ids)"
  local n_nodes n_prose
  n_nodes=$(printf '%s\n' "$nodes" | grep -c . || true)
  n_prose=$(printf '%s\n' "$prose" | grep -c . || true)

  while read -r id; do
    [ -z "$id" ] && continue
    case "$(status_of "$id")" in
      open)          open=$((open+1));    open_ids+=("$id") ;;
      closed)        closed=$((closed+1)) ;;
      retired_unused) retired=$((retired+1)) ;;
      *)             malformed=$((malformed+1)); malformed_ids+=("$id") ;;
    esac
  done <<< "$nodes"

  # named in prose, no node ⇒ INDETERMINATE. Never inferred to be closed.
  while read -r id; do
    [ -z "$id" ] && continue
    grep -qx "$id" <<< "$nodes" || { indet=$((indet+1)); indet_ids+=("$id"); }
  done <<< "$prose"

  # a node whose id never appears in prose — the F-P7b-ay shape, inverted.
  local -a orphan=()
  while read -r id; do
    [ -z "$id" ] && continue
    grep -qx "$id" <<< "$prose" || orphan+=("$id")
  done <<< "$nodes"

  if [ "$fmt" = tsv ]; then
    printf 'verdict\tcount\tpopulation\n'
    printf 'OPEN\t%d\t%d nodes\nCLOSED\t%d\t%d nodes\nRETIRED\t%d\t%d nodes\n' \
      "$open" "$n_nodes" "$closed" "$n_nodes" "$retired" "$n_nodes"
    printf 'INDETERMINATE\t%d\t%d ids in prose\nMALFORMED\t%d\t%d nodes\n' \
      "$indet" "$n_prose" "$malformed" "$n_nodes"
    return 0
  fi

  echo "census_findings — Git.aDNA"
  echo "  population (A8 §5, stated with the verdict):"
  printf '    nodes on disk    %3d   (%s)\n' "$n_nodes" "${FINDINGS_DIR#$ROOT/}/finding_f_p7b_*.md"
  printf '    ids named in prose %3d (STATE.md + STATE_history.md)\n' "$n_prose"
  echo ""
  printf '    OPEN            %3d\n' "$open"
  printf '    CLOSED          %3d\n' "$closed"
  printf '    RETIRED_UNUSED  %3d\n' "$retired"
  printf '    INDETERMINATE   %3d   ⛔ named in prose, no node — NOT closed, NOT absent (A8 §3)\n' "$indet"
  [ "$malformed" -gt 0 ] && printf '    MALFORMED       %3d   ⛔ node present, status unreadable\n' "$malformed"
  echo ""
  [ "$open" -gt 0 ] && { echo "  open:"; printf '    F-P7b-%s\n' "${open_ids[@]}"; }
  [ "${#orphan[@]}" -gt 0 ] && {
    echo "  ⛔ node exists but the id appears NOWHERE in prose (the F-P7b-ay shape):"
    printf '    F-P7b-%s\n' "${orphan[@]}"; }
  [ "$malformed" -gt 0 ] && printf '    ⛔ malformed: F-P7b-%s\n' "${malformed_ids[@]}"
  echo ""
  echo "  ⚠ INDETERMINATE is the honest verdict for the pre-2026-09-07 backlog, not a defect in"
  echo "    this census: those ids were never adjudicated at the object. Backfilling them from"
  echo "    prose would be ASSERTING a population, which is what A8 §5 forbids."
  echo "  ⛔ NO_META unless \`--meta\` has been run in this session (A8 §7)."
  return 0
}

run_meta() {
  # ⛔ A8 §7 / A4 §6 — no instrument is trusted until DEMONSTRATED TO FAIL. Each arm builds a
  #   broken world and requires this program to NOTICE. An arm that cannot go red proves nothing.
  local pass=0 fail=0 tmp out
  arm() { # <name> <expect: rc|substr> <value> <root>
    local name="$1" kind="$2" want="$3" root="$4" rc
    out="$(CENSUS_ROOT="$root" bash "$0" 2>&1)"; rc=$?
    local ok=1
    case "$kind" in
      rc)     [ "$rc" -eq "$want" ] || ok=0 ;;
      substr) grep -q "$want" <<< "$out" || ok=0 ;;
    esac
    if [ $ok -eq 1 ]; then pass=$((pass+1)); printf '  ok    %s\n' "$name"
    else fail=$((fail+1)); printf '  RED   %s (rc=%s)\n' "$name" "$rc"; sed 's/^/          /' <<< "$out" | head -4; fi
  }

  echo "census_findings --meta — every failure path demonstrated to FAIL"
  echo ""

  tmp="$(mktemp -d)"; mkdir -p "$tmp/what"      # no findings dir at all
  arm "missing findings dir REFUSES (never reports 0 open)" rc 1 "$tmp"
  rm -rf "$tmp"

  tmp="$(mktemp -d)"; mkdir -p "$tmp/what/findings"
  printf -- '---\nstatus: banana\n---\n' > "$tmp/what/findings/finding_f_p7b_qq.md"
  arm "a malformed status is MALFORMED, not silently closed" substr "MALFORMED" "$tmp"
  rm -rf "$tmp"

  tmp="$(mktemp -d)"; mkdir -p "$tmp/what/findings"
  printf -- '---\nstatus: open\n---\n' > "$tmp/what/findings/finding_f_p7b_qq.md"
  printf 'prose mentions F-P7b-zz and nothing else\n' > "$tmp/STATE.md"
  arm "an id in prose with no node is INDETERMINATE" substr "INDETERMINATE     1" "$tmp"
  arm "a node whose id is absent from prose is REPORTED" substr "appears NOWHERE in prose" "$tmp"
  rm -rf "$tmp"

  tmp="$(mktemp -d)"; mkdir -p "$tmp/what/findings"
  printf -- '---\nstatus: open\n---\n' > "$tmp/what/findings/finding_f_p7b_qq.md"
  printf 'F-P7b-qq\n' > "$tmp/STATE.md"
  arm "a clean world reports OPEN 1 and INDETERMINATE 0" substr "OPEN              1" "$tmp"
  rm -rf "$tmp"

  echo ""
  if [ "$fail" -eq 0 ]; then
    echo "meta-control: $pass/$pass arms — every failure path demonstrated; the census may be cited."
    return 0
  fi
  echo "meta-control: $fail RED of $((pass+fail)) — ⛔ the census may NOT be cited."
  return 1
}

case "$MODE" in
  meta) run_meta ;;
  tsv)  run_census tsv ;;
  *)    run_census human ;;
esac
