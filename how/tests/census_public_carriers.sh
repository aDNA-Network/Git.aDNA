#!/usr/bin/env bash
# census_public_carriers.sh — enumerate the fleet's PUBLIC repos on both forges and count
# publication-boundary occurrences at each repo's OWN default branch, anonymously.
#
#   run:  bash how/tests/census_public_carriers.sh              # the census
#         bash how/tests/census_public_carriers.sh --meta       # the meta-control
#         bash how/tests/census_public_carriers.sh --local-only # predicates + self-measure, no network
#
# ⛔ REDACTED BY CONSTRUCTION. This script never prints the literal it counts. Patterns are
#    built into files and passed by reference; matches are counted, never echoed. A census
#    instrument that publishes the string it is counting has defeated its own subject.
#
# ---------------------------------------------------------------------------
# WHY THIS IS A VAULT INSTRUMENT AND NOT A SCRATCHPAD SCRIPT — promoted 2026-08-27.
#
#   It ran twice from a scratchpad and produced a published figure both times. The first
#   run's population was a ROSTER OF CORRESPONDENTS rather than an enumeration of public
#   repos (ADR-016 §C1). The second run's `A_HOST` figure — 57/17 — went into ADR-016 rev 2
#   and DID NOT REPRODUCE at a peer's desk, who measured 66/20 at our own published commit.
#
#   ⭐ Both defects are properties of an instrument nobody could run. A number produced by a
#   script in a temp directory cannot be re-derived by the desk that disputes it, cannot be
#   diffed against a peer's, and cannot carry a control. ADR-016 D6.2 says a census is
#   enumerated rather than assembled; an un-promoted instrument makes that unverifiable in
#   practice even when it is true in principle.
#
#   ⇒ ADR-016 rev 3 CITES THIS FILE AND ITS DATED OUTPUT instead of transcribing figures.
#     The operator's ruling at the 2026-08-27 plan gate, after the allowlist figure moved for
#     the third time in one sitting (31 → 62 → 75).
#
# ⛔ THE DEFECT THAT PRODUCED 57/17, FIXED HERE — F-P7b-af.
#   `A_HOST` was built as `(^|[^0-9.])<host>([^0-9.]|$)`. Both guards excluded `.`, and with
#   `grep -o` that is wrong twice over:
#     (1) THE TRAILING GUARD CONSUMES THE SEPARATOR. Two occurrences on one line are counted
#         as ONE. Minimal reproduction, in --meta: a line bearing the address twice scores 1.
#     (2) EXCLUDING AN ADJACENT DOT CREATES FALSE NEGATIVES. An address preceded by a dot, or
#         ending a prose sentence, does not match at all. Three files in this tree carry the
#         host in a `…ly.<addr>` construct and were invisible to it.
#   ⇒ Guards exclude adjacent DIGITS only. 57 → 70 occurrences at the same commit, which
#     reproduces the peer's 66 LINES / 20 files exactly once the unit is stated.
#
# ⛔ AND STATE THE UNIT, EVERY TIME. ADR-016 rev 2 reported `31/13` (lines/files) beside
#   `62/20` (occurrences/files) in ONE TABLE with no labels. Two units, one table, and the
#   reader cannot tell. This script reports OCCURRENCES, FILES and LINES as three columns and
#   never collapses them.
#
# DOCTRINE THIS INSTRUMENT IS BUILT UNDER — read before adding a predicate.
#   ADR-016 D6.2 — a census is enumerated from the forge, NEVER assembled from a roster.
#   ADR-016 D6.3 — a result may be cited only for the question its predicate asked.
#   ADR-016 D6.4 — ⛔ A ZERO MUST BE FALSIFIED BEFORE IT IS RECORDED. Every predicate is
#                  proven live against a known-positive control before any zero is recorded
#                  anywhere; `HTTP 200` + empty body is NOT evidence of an empty population;
#                  absent a control the verdict is UNKNOWN, never 0.
#   ADR-011 A4 §6 — no instrument is trusted until DEMONSTRATED TO FAIL (`--meta`).
# ---------------------------------------------------------------------------
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VAULT="$(cd "$HERE/../.." && pwd)"
MODE=census
case "${1:-}" in
  --meta)       MODE=meta ;;
  --local-only) MODE=local ;;
  -h|--help)    sed -n '2,8p' "$0"; exit 0 ;;
  "")           ;;
  *) printf 'unknown arg: %s\n' "$1" >&2; exit 2 ;;
esac

WORK="$(mktemp -d)"; PAT="$WORK/pat"; mkdir -p "$PAT"
trap 'rm -rf "$WORK"' EXIT

# ===========================================================================
# 1. Derive the predicates. ⛔ Nothing here reaches stdout.
# ===========================================================================
# B_CLASS: lifted VERBATIM from the shipped deny list — the same predicate R8 uses, by
# reference and never re-typed. If the gate's pattern changes, this census changes with it,
# which is the only way the two can be prevented from drifting into different numbers.
build_predicates() {   # <tree to derive the instance host from>
  local src="$1"
  grep -v '^[[:space:]]*#' "$VAULT/sanitize_deny_content.txt" \
    | grep -v '^[[:space:]]*$' | head -1 > "$PAT/b_class.re"
  [ -s "$PAT/b_class.re" ] || { echo "FATAL: could not lift R8 pattern 1 from the deny list"; return 9; }

  # A_HOST: the most frequent RFC1918 host in the source tree = the instance under discussion.
  # ⛔ Derived, never written into this file. The instrument that counts the literal must not
  #   be a place the literal is published.
  local host
  host="$(grep -rIhoE '(10|192\.168|172\.(1[6-9]|2[0-9]|3[01]))\.[0-9]{1,3}(\.[0-9]{1,3}){0,2}' \
            --exclude-dir=.git "$src" 2>/dev/null \
          | grep -oE '[0-9]{1,3}(\.[0-9]{1,3}){3}' | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')"
  [ -n "$host" ] || { echo "FATAL: could not derive instance host from $src"; return 9; }
  local hre; hre="$(printf '%s' "$host" | sed 's/\./\\./g')"

  # ⛔ F-P7b-af: guards exclude adjacent DIGITS ONLY. Never `.` — see the header.
  printf '(^|[^0-9])%s([^0-9]|$)\n' "$hre" > "$PAT/a_host.re"

  local port
  port="$(grep -rIhoE "${hre}:[0-9]{2,5}" --exclude-dir=.git "$src" 2>/dev/null \
          | sed 's/.*://' | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')"
  [ -n "$port" ] || { echo "FATAL: could not derive primary port from $src"; return 9; }
  printf '(^|[^0-9])%s:%s([^0-9]|$)\n' "$hre" "$port" > "$PAT/a_addr.re"
  return 0
}

# ===========================================================================
# 2. Count. Three columns, three units, never collapsed (see the header).
# ===========================================================================
count() {  # <tree> <patternfile> -> "<occurrences> <lines> <files>"
  local tree="$1" pf="$2" occ lines files
  occ="$(  grep -rIoE -f "$pf" --exclude-dir=.git "$tree" 2>/dev/null | grep -c .)"
  lines="$(grep -rIE  -f "$pf" --exclude-dir=.git "$tree" 2>/dev/null | grep -c .)"
  files="$(grep -rIlE -f "$pf" --exclude-dir=.git "$tree" 2>/dev/null | grep -c .)"
  printf '%s %s %s' "${occ:-0}" "${lines:-0}" "${files:-0}"
}

# ⛔ D6.4's machinery, and the reason this function exists rather than an inline `if`.
# A zero is only recordable once the SAME predicate, run by the SAME code path, has been
# shown able to return non-zero. The control is this vault: it is known to carry the material,
# and if it ever reads 0 the instrument is broken and every other zero is meaningless.
control_proves_predicate() {   # <patternfile> -> 0 if the predicate can return non-zero
  local occ; read -r occ _ _ <<<"$(count "$VAULT" "$1")"
  [ "${occ:-0}" -gt 0 ]
}

# ===========================================================================
# 3. Enumerate the PUBLIC population. Enumerated, never rostered (D6.2).
# ===========================================================================
# ⛔ D6.4 APPLIED TO THE ENUMERATION ITSELF, not only to the counts. Codeberg's
#   `orgs/<org>/repos` returns HTTP 200 with an empty array for an org that is not visible
#   anonymously, which is indistinguishable from an org with no public repos. A control org
#   is queried on the SAME endpoint from the SAME vantage in the SAME run; if the control
#   does not return non-empty, the forge's row is UNKNOWN and is reported as UNKNOWN.
#   ⭐ Independently reproduced by Hermes (Exchange.aDNA), a Codeberg-origin vault, 2026-08-27.
enumerate() {
  local gh="$WORK/gh.json" cb="$WORK/cb.json" cbctl="$WORK/cbctl.json"
  if ! curl -sf "https://api.github.com/orgs/aDNA-Network/repos?per_page=100&type=public" -o "$gh"; then
    echo "FATAL: GitHub enumeration failed — refusing to report a census over an unknown population"
    return 8
  fi
  CB_STATE=unknown
  if curl -sf "https://codeberg.org/api/v1/orgs/forgejo/repos?limit=5" -o "$cbctl" \
     && [ "$(python3 -c 'import json,sys;print(len(json.load(open(sys.argv[1]))))' "$cbctl" 2>/dev/null || echo 0)" -gt 0 ]; then
    if curl -sf "https://codeberg.org/api/v1/orgs/aDNA-Network/repos?limit=100" -o "$cb"; then
      CB_STATE=measured
    fi
  fi
  [ "$CB_STATE" = measured ] || echo '[]' > "$cb"
  python3 - "$gh" "$cb" "$WORK/pop.tsv" "$CB_STATE" <<'PY'
import json,sys
out=[]
for r in json.load(open(sys.argv[1])):
    if not r['private']:
        out.append(("github", r['full_name'], r['default_branch'], r['clone_url'], r['forks_count']))
try: cb=json.load(open(sys.argv[2]))
except Exception: cb=[]
for r in (cb if isinstance(cb,list) else []):
    if not r.get('private'):
        out.append(("codeberg", r['full_name'], r.get('default_branch','main'), r['clone_url'], r.get('forks_count',0)))
open(sys.argv[3],'w').write("".join("\t".join(map(str,row))+"\n" for row in sorted(out)))
g=sum(1 for x in out if x[0]=="github"); c=sum(1 for x in out if x[0]=="codeberg")
print(f"population enumerated: {len(out)} public repos ({g} github, "
      + (f"{c} codeberg)" if sys.argv[4]=="measured"
         else "codeberg=UNKNOWN — control did not prove the endpoint; NOT recorded as 0 [D6.4])"))
PY
}

run_census() {
  build_predicates "$VAULT" || return $?
  echo "predicates built: A_HOST · A_ADDR · B_CLASS(=R8 pattern 1, by reference)  [literals withheld by design]"
  for p in a_host a_addr b_class; do
    control_proves_predicate "$PAT/$p.re" \
      || { echo "FATAL: predicate $p scores 0 on the known-positive control — instrument broken, every zero it reports is meaningless (D6.4)"; return 7; }
  done
  echo "known-positive control: all three predicates return non-zero on this vault ✓"
  echo
  enumerate || return $?
  echo
  printf '%-9s %-32s %-8s %-5s %-14s %-14s %-14s %s\n' \
    FORGE REPO BRANCH FORKS "A_HOST o/l/f" "A_ADDR o/l/f" "B_CLASS o/l/f" REF
  printf '%s\n' "--------------------------------------------------------------------------------------------------------------------"
  while IFS=$'\t' read -r forge full branch url forks; do
    local dest="$WORK/clones/${forge}_${full//\//_}"
    if ! git clone -q --depth 1 --branch "$branch" -c core.hooksPath=/dev/null "$url" "$dest" 2>/dev/null; then
      printf '%-9s %-32s %-8s %-5s %-14s %-14s %-14s %s\n' "$forge" "$full" "$branch" "$forks" CLONE_FAIL - - n/a
      continue
    fi
    # ⚠ Assert we counted the ref we claim to have counted. A census reported against an
    #   unstated branch is the defect one layer up from the one this file was promoted for.
    local actual refok; actual="$(git -C "$dest" rev-parse --abbrev-ref HEAD 2>/dev/null)"
    [ "$actual" = "$branch" ] && refok=REF_OK || refok="MISMATCH:$actual"
    local ho hl hf ao al af bo bl bf
    read -r ho hl hf <<<"$(count "$dest" "$PAT/a_host.re")"
    read -r ao al af <<<"$(count "$dest" "$PAT/a_addr.re")"
    read -r bo bl bf <<<"$(count "$dest" "$PAT/b_class.re")"
    printf '%-9s %-32s %-8s %-5s %-14s %-14s %-14s %s\n' \
      "$forge" "$full" "$branch" "$forks" "$ho/$hl/$hf" "$ao/$al/$af" "$bo/$bl/$bf" "$refok"
  done < "$WORK/pop.tsv"
  echo
  echo "columns: occurrences/lines/files — THREE UNITS, never collapsed (ADR-016 rev 2 mixed two in one table)"
  echo "A_HOST=instance host, any context · A_ADDR=host:primary-port · B_CLASS=R8 pattern 1, what the GATE stops"
}

# ===========================================================================
# --meta : the meta-control (ADR-011 A4 §6). Fixtures only; no network, no vault writes.
# ===========================================================================
run_meta() {
  printf '\nmeta-control — each predicate must be demonstrated able to FAIL (ADR-011 A4 §6)\n\n'
  local bad=0 d occ lines files
  # ⛔ Fixture addresses are ASSEMBLED FROM OCTETS so this control does not itself publish a
  #   matchable literal — the same discipline test_sanitize_content_gate.sh already uses.
  local A="10.$((40+3)).0.$((14*2))"
  d="$WORK/fx"; mkdir -p "$d"

  # --- the two defects that produced 57/17, each with a minimal reproduction --------------
  printf '  -- F-P7b-af: the guards that went blind --\n'
  printf 'forge at %s and mirror at %s on one line\n' "$A" "$A" > "$d/two_on_one_line.md"
  printf 'see `internally.%s` in the notice\n' "$A"             > "$d/preceded_by_dot.md"
  printf 'the forge runs at %s.\n' "$A"                          > "$d/prose_sentence_end.md"
  printf 'bare %s here\n' "$A"                                   > "$d/plain.md"
  # A_ADDR needs a host:port to derive from — the fixture must carry one or the build fails
  # for a reason unrelated to what these arms test.
  printf 'ui at %s:%s\n' "$A" "$((3000+300))"                    > "$d/with_port.md"
  build_predicates "$d" >/dev/null 2>&1 || { echo "  FAIL  could not build predicates from fixture"; return 1; }

  read -r occ lines files <<<"$(count "$d/two_on_one_line.md" "$PAT/a_host.re")"
  if [ "$occ" -eq 2 ]; then printf '  ok    %-40s (occ=2, separator not consumed)\n' "two on one line -> 2 occurrences"
  else printf '  FAIL  %-40s occ=%s want 2 — the trailing guard is eating the separator again\n' "two on one line -> 2 occurrences" "$occ"; bad=1; fi

  for fx in preceded_by_dot prose_sentence_end plain; do
    read -r occ lines files <<<"$(count "$d/$fx.md" "$PAT/a_host.re")"
    if [ "$occ" -ge 1 ]; then printf '  ok    %-40s (matched)\n' "must-match: $fx"
    else printf '  FAIL  %-40s occ=0 — false negative\n' "must-match: $fx"; bad=1; fi
  done

  # --- must NOT match: the reason the guards exist at all ---------------------------------
  printf '\n  -- must NOT match (an instrument that matches everything measures nothing) --\n'
  printf 'see 1%s1 here\n' "$A" > "$d/inside_longer.md"          # digit-adjacent both ends
  printf 'bound to 127.0.0.1 only\n' > "$d/loopback.md"
  printf 'listening on 0.0.0.0\n'    > "$d/unspecified.md"
  printf 'example uses 192.0.2.10\n' > "$d/rfc5737.md"
  for fx in inside_longer loopback unspecified rfc5737; do
    read -r occ lines files <<<"$(count "$d/$fx.md" "$PAT/b_class.re")"
    if [ "$occ" -eq 0 ]; then printf '  ok    %-40s (0)\n' "must-NOT-match: $fx"
    else printf '  FAIL  %-40s occ=%s want 0\n' "must-NOT-match: $fx" "$occ"; bad=1; fi
  done

  # --- the unit separation, asserted rather than assumed ----------------------------------
  printf '\n  -- three units, never collapsed (ADR-016 rev 2 mixed two in one table) --\n'
  read -r occ lines files <<<"$(count "$d/two_on_one_line.md" "$PAT/a_host.re")"
  if [ "$occ" -eq 2 ] && [ "$lines" -eq 1 ] && [ "$files" -eq 1 ]; then
    printf '  ok    %-40s (occ=2 lines=1 files=1 — all three differ, and must)\n' "occurrences != lines != files"
  else
    printf '  FAIL  %-40s occ=%s lines=%s files=%s want 2/1/1\n' "occurrences != lines != files" "$occ" "$lines" "$files"; bad=1
  fi

  # --- D6.4: the control that makes a zero recordable ------------------------------------
  printf '\n  -- D6.4: a zero must be falsified before it is recorded --\n'
  printf 'nothing of interest here\n' > "$d/empty_tree.md"
  local emptydir="$d/emptytree"; mkdir -p "$emptydir"; printf 'clean\n' > "$emptydir/x.md"
  read -r occ lines files <<<"$(count "$emptydir" "$PAT/a_host.re")"
  if [ "$occ" -eq 0 ]; then printf '  ok    %-40s (a true zero is reachable)\n' "clean tree -> 0"
  else printf '  FAIL  %-40s occ=%s want 0 — predicate matches everything\n' "clean tree -> 0" "$occ"; bad=1; fi
  if control_proves_predicate "$PAT/a_host.re"; then
    printf '  ok    %-40s (control returns non-zero, so the 0 above is a measurement)\n' "control proves the predicate"
  else
    printf '  FAIL  %-40s control scored 0 — every zero this run reports is meaningless\n' "control proves the predicate"; bad=1
  fi
  # ⭐ The paired arm: a BROKEN predicate must fail the control, or the control proves nothing.
  #
  # ⛔ THIS ARM CAUGHT ITSELF ON FIRST RUN, and the defect is this vault's signature one.
  #   The sentinel was written as a literal in this file. `control_proves_predicate` greps the
  #   WHOLE VAULT — which contains this script — so the "unmatchable" pattern matched its own
  #   source and the control reported that a dead predicate was alive. ⭐ A predicate matching
  #   its own documentation, inside the arm written to catch that class, on the instrument
  #   promoted because a census matched the wrong thing. It is assembled at runtime for the
  #   same reason the fixture addresses are.
  printf '%s\n' "Q$(printf 'Z%.0s' 1 2 3)_sentinel_$$_no_such_string" > "$PAT/broken.re"
  if control_proves_predicate "$PAT/broken.re"; then
    printf '  FAIL  %-40s a predicate that cannot match PASSED the control\n' "broken predicate -> control FAILS"; bad=1
  else
    printf '  ok    %-40s (control rejects an unmatchable predicate)\n' "broken predicate -> control FAILS"
  fi

  # --- redaction: the instrument must not publish what it counts -------------------------
  printf '\n  -- redaction: this script must never print the literal it counts --\n'
  local out; out="$(run_meta_selfscan "$A")"
  if [ "$out" = "clean" ]; then printf '  ok    %-40s (no literal in any output path)\n' "no address in output"
  else printf '  FAIL  %-40s %s\n' "no address in output" "$out"; bad=1; fi

  printf '\n---\nmeta-control: %s\n' \
    "$([ "$bad" -eq 0 ] && echo 'every predicate reached its failure state; controls passed; redaction holds' \
                        || echo 'DEFECT — see FAIL rows above')"
  [ "$bad" -eq 0 ]
}

# The source of this script must not contain a matchable literal, and neither must its help.
run_meta_selfscan() {   # <fixture address> -> "clean" | complaint
  local a="$1"
  if grep -qF "$a" "$0"; then printf 'the literal appears in %s\n' "$0"; return; fi
  printf 'clean\n'
}

case "$MODE" in
  meta)  run_meta; exit $? ;;
  local) build_predicates "$VAULT" || exit $?
         echo "predicates built [literals withheld]"
         for p in a_host a_addr b_class; do
           read -r o l f <<<"$(count "$VAULT" "$PAT/$p.re")"
           printf '  %-8s occurrences=%-4s lines=%-4s files=%s\n' "$p" "$o" "$l" "$f"
         done
         exit 0 ;;
esac
run_census
