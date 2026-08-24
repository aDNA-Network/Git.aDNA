#!/usr/bin/env bash
# probe_peer_state.sh — the second end of the both-ends sweep (Git.aDNA · Operation Free Harbor).
#
# Answers ONE question, at the moment it is relied upon: may this vault write a
# file into <target vault>/<write-dir> right now?
#
# READ-ONLY on every vault it inspects. It writes nothing anywhere. The ONLY thing
# it can cause to happen is the command handed to --exec, and only on a GO.
#
#   run:  bash how/tests/probe_peer_state.sh --target ~/aDNA/Jupyter.aDNA \
#                --write-dir who/coordination --dest-file coord_x.md
#         bash how/tests/probe_peer_state.sh --target ... --write-dir ... \
#                --dest-file ... --exec 'cp src dst'      # runs ONLY on GO
#         bash how/tests/probe_peer_state.sh --meta        # the meta-control
#
# ---------------------------------------------------------------------------
# WHY THIS EXISTS — F-P7b-i, 2026-08-22, filed against our own instrument.
#
#   After F-INTAKE-04 this vault adopted a both-ends sweep for INBOUND mail: a
#   clean sweep at open is not a clean sweep at close. We never extended the same
#   discipline to LEASES. On 2026-08-22 a sitting recorded `leases_at_open: 0`,
#   took an operator authorization against that number, and found at the act that
#   BOTH target peers had taken leases in the interval. Both sends were refused,
#   correctly — but by an inline probe, not by anything durable.
#
#   ⭐ The generalisation: we guarded the input we RECEIVE and not the input we
#   DEPEND ON. Inbound mail and peer leases are the same kind of fact — another
#   vault's state, read once, acted on later — and only one of them was guarded.
#
#   ⛔ Hence --exec. "Probe in the same command as the act" was a discipline an
#   operator had to remember; --exec makes it a property of the tool. The gate
#   authorises the send; the probe governs the moment. A probe that reports and
#   then lets an unrelated command run later has re-created the stale reading it
#   was written to prevent.
#
# DOCTRINE THIS INSTRUMENT IS BUILT UNDER — read before adding a check.
#
#   ADR-015 §D1.5b (generalized): every check states its FAILURE CONDITION at the
#   point of definition. A column that cannot report the failure it exists to
#   catch is not a control (F-P7a-f). Each check() below carries a `fails_when:`.
#
#   ADR-011 A4 §6: no conformance instrument is trusted until DEMONSTRATED TO FAIL.
#   `--meta` builds one sabotage fixture per check, each REQUIRED to fail, plus
#   known-good controls REQUIRED to pass — an instrument stuck at FAIL is as
#   useless as one stuck at PASS.
#
#   ADR-011 A4 §2(a): an unknown reading is never a silent pass.
#
#   ⛔ THE PREDICATE RULE, which has now failed in FOUR directions inside 72 hours
#   (could not fail · matched documentation · could not succeed · compared against
#   the wrong object) — and three of the four PRINTED THE ANSWER WE WANTED:
#     · `lfs_rehydration` false-BLOCKED on the two files that merely QUOTE the LFS
#       pointer signature (F-P7b-e).
#     · A peer's census adjudicated a hook by grepping a string that appears in
#       that hook's OWN COMMENT BLOCK, and moved 68 repos (F-P7b-f).
#   So `declared_collision` below does NOT grep the lease for our directory name.
#   A lease is FULL OF paths in prose — Rosetta's live lease on 2026-08-22 contains
#   the literal string `who/coordination/` inside a documented sweep command while
#   declaring an entirely different file set. A naive grep REFUSES that send, and
#   it is wrong. Declared paths are read from the two places a declaration can
#   legitimately live, and from nowhere else. Fixture C proves it.
# ---------------------------------------------------------------------------
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SELF_VAULT="$(cd "$HERE/../.." && pwd)"

TARGET=""; WRITE_DIR=""; DEST_FILE=""; EXEC_CMD=""; MODE="probe"

while [ $# -gt 0 ]; do
  case "$1" in
    --target)    TARGET="$2";    shift 2 ;;
    --write-dir) WRITE_DIR="$2"; shift 2 ;;
    --dest-file) DEST_FILE="$2"; shift 2 ;;
    --exec)      EXEC_CMD="$2";  shift 2 ;;
    --self)      SELF_VAULT="$2"; shift 2 ;;
    --meta)      MODE="meta";    shift ;;
    -h|--help)   sed -n '2,14p' "$0"; exit 0 ;;
    *) printf 'unknown arg: %s\n' "$1" >&2; exit 2 ;;
  esac
done

pass=0; warn=0; block=0; unknown=0
check() {  # <name> <verdict PASS|WARN|BLOCK|UNKNOWN> <detail>
  case "$2" in
    PASS)  pass=$((pass+1));      printf '  PASS    %-20s %s\n' "$1" "$3" ;;
    WARN)  warn=$((warn+1));      printf '  WARN    %-20s %s\n' "$1" "$3" ;;
    BLOCK) block=$((block+1));    printf '  BLOCK   %-20s %s\n' "$1" "$3" ;;
    *)     unknown=$((unknown+1));printf '  UNKNOWN %-20s %s\n' "$1" "$3" ;;
  esac
}

# ===========================================================================
# Declared-path extraction.
#
# ⛔ A declaration lives in exactly TWO places and NOWHERE else:
#   (1) a YAML `declared_files:` block — this vault's own session form;
#   (2) a markdown table row whose first cell is "Files declared" — the form
#       aDNA.aDNA / Network.aDNA / Forgejo.aDNA sessions use, with the paths in
#       backtick spans inside the second cell.
# Prose, commented-out lines, sweep commands, quoted examples and narrative are
# NOT declarations, are never read here, and must never be. See the header.
# ===========================================================================
declared_paths() {   # <lease file> -> one normalized path token per line
  awk '
    BEGIN { inblk = 0 }
    # ---- form (1): YAML declared_files: block --------------------------------
    /^declared_files:[[:space:]]*$/ { inblk = 1; next }
    inblk == 1 {
      if ($0 ~ /^[[:space:]]*-[[:space:]]+/) {
        line = $0
        sub(/^[[:space:]]*-[[:space:]]+/, "", line)
        sub(/[[:space:]]+#.*$/, "", line)              # trailing comment is not a path
        gsub(/^["'"'"'[:space:]]+|["'"'"'[:space:]]+$/, "", line)
        gsub(/^`|`$/, "", line)
        if (line != "") print line
        next
      }
      if ($0 ~ /^[^[:space:]-]/) { inblk = 0 }         # next top-level key ends the block
    }
    # ---- form (2): | **Files declared** | `a` · `b` | ------------------------
    {
      probe = $0; gsub(/\*/, "", probe)
      if (probe ~ /^[[:space:]]*\|[[:space:]]*[Ff]iles declared[[:space:]]*\|/) {
        n = index(probe, "|"); rest = substr(probe, n + 1)
        m = index(rest, "|");  cell = substr(rest, m + 1)
        while (match(cell, /`[^`]+`/)) {
          print substr(cell, RSTART + 1, RLENGTH - 2)
          cell = substr(cell, RSTART + RLENGTH)
        }
      }
    }
  ' "$1" 2>/dev/null
}

# fails_when: a declared token and the write-dir stand in an ancestor/descendant
#             relation (segment-aligned), in either direction.
# Segment-aligned, never substring: `who/coordination` must not be matched by
# `elsewhere/who/coordinationX`, and `STATE.md` must not match anything.
collides() {   # <declared token> <write dir> -> 0 if they collide
  local d="$1" w="$2"
  d="${d#./}"; d="${d%/}"; w="${w#./}"; w="${w%/}"
  [ -n "$d" ] && [ -n "$w" ] || return 1
  case "/$d/" in */"$w"/*) return 0 ;; esac        # declared IS w, or sits under it
  case "/$w/" in */"$d"/*) return 0 ;; esac        # declared is an ancestor dir of w
  case "$d" in *[*?]*)                             # declared token is a glob
    case "/$w/" in */$d/*) return 0 ;; esac ;;
  esac
  return 1
}

# ===========================================================================
# The checks. Each prints exactly one row.
# ===========================================================================

# fails_when: the target path is absent, or is not a git working tree.
# why it matters: a "clear" reading taken against a path that does not exist is
# the emptiest kind of false pass — it reports no leases because it found no vault.
check_target_exists() {   # <target>
  local t="$1"
  if [ ! -d "$t" ];        then check target_exists BLOCK "no such directory: $t"; return; fi
  if [ ! -e "$t/.git" ];   then check target_exists BLOCK "$t is not a git working tree"; return; fi
  check target_exists PASS "$(basename "$t")"
}

# fails_when: the target holds one or more session leases whose status is
#             active/open (i.e. a live writer), excluding .gitkeep.
# why it matters: this is the number F-P7b-i is about. It is NOT on its own a
# refusal — a lease elsewhere in the vault does not collide with our directory —
# so it reports WARN and lets declared_collision do the adjudicating.
check_active_leases() {   # <target>
  # ⛔ `local a="$1" b="$a/x"` DOES NOT WORK: local declares every name first, so $a
  # is unset when b is expanded and `set -u` kills the shell mid-check. That defect
  # shipped in the first cut of this file and THREE sabotage fixtures reported `ok`
  # on it — they wanted NOTPASS and a dead shell reads as NOTPASS. Only the
  # known-good controls exposed it (F-P7b-d again, A4 §6 earning its keep twice).
  local t="$1"; local dir="$t/how/sessions/active"; local f n=0 live=0 names=""
  if [ ! -d "$dir" ]; then check active_leases UNKNOWN "no how/sessions/active/ — cannot read leases"; return; fi
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    case "$(basename "$f")" in .gitkeep|.*) continue ;; esac
    n=$((n+1))
    local st; st="$(awk -F': *' '/^status:/{print $2; exit}' "$f" 2>/dev/null | tr -d ' ')"
    case "$st" in active|open|in_progress) live=$((live+1)); names="$names $(basename "$f" .md)[$st]" ;;
                  "") names="$names $(basename "$f" .md)[NO-STATUS]"; live=$((live+1)) ;;
                  *)  names="$names $(basename "$f" .md)[$st]" ;; esac
  done < <(find "$dir" -maxdepth 1 -type f 2>/dev/null | sort)
  if [ "$live" -eq 0 ]; then check active_leases PASS "$n file(s), 0 live"
  else check active_leases WARN "$live live of $n:$names"; fi
}

# fails_when: any live lease DECLARES the directory we intend to write (or an
#             ancestor/descendant of it).
# why it matters: this is the single-writer rule's actual predicate. A lease that
# names our target directory is the refusal; a lease that merely exists is not.
#
# ⛔ Reads declarations only (see declared_paths). Never greps the lease body.
check_declared_collision() {   # <target> <write-dir>
  local t="$1" w="$2"; local dir="$t/how/sessions/active"; local f tok hits=0 detail=""   # see check_active_leases
  if [ -z "$w" ]; then check declared_collision UNKNOWN "no --write-dir given"; return; fi
  if [ ! -d "$dir" ]; then check declared_collision UNKNOWN "no how/sessions/active/"; return; fi
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    case "$(basename "$f")" in .gitkeep|.*) continue ;; esac
    while IFS= read -r tok; do
      [ -n "$tok" ] || continue
      if collides "$tok" "$w"; then hits=$((hits+1)); detail="$detail $(basename "$f" .md):$tok"; fi
    done < <(declared_paths "$f")
  done < <(find "$dir" -maxdepth 1 -type f 2>/dev/null | sort)
  if [ "$hits" -eq 0 ]; then check declared_collision PASS "no live lease declares $w"
  else check declared_collision BLOCK "$hits declaration(s) name $w:$detail"; fi
}

# fails_when: the target has TRACKED modifications inside the write-dir.
# why it matters: untracked files there are mail queued for intake — our file
# joins the queue and overwrites nothing. Tracked edits mean a writer is mid-change
# on that directory's content, which is the collision the lease rule exists for.
check_writedir_dirty() {   # <target> <write-dir>
  local t="$1" w="$2" tracked untracked
  if [ -z "$w" ]; then check writedir_dirty UNKNOWN "no --write-dir given"; return; fi
  if [ ! -d "$t/$w" ]; then check writedir_dirty WARN "$w does not exist in target — cp would create it"; return; fi
  tracked="$(git -C "$t" status --porcelain -- "$w" 2>/dev/null | grep -cv '^??' | tr -d ' ')"
  untracked="$(git -C "$t" status --porcelain -- "$w" 2>/dev/null | grep -c '^??' | tr -d ' ')"
  if [ "${tracked:-0}" -gt 0 ]; then check writedir_dirty BLOCK "$tracked tracked edit(s) in $w — a writer is mid-change there"
  elif [ "${untracked:-0}" -gt 0 ]; then check writedir_dirty WARN "$untracked untracked file(s) in $w (queued mail; no overwrite)"
  else check writedir_dirty PASS "$w clean"; fi
}

# fails_when: the destination file already exists in the target.
# why it matters: a delivery must never silently overwrite a peer's copy — theirs
# may carry edits, or be a different memo that happens to share a name.
check_dest_collision() {   # <target> <write-dir> <dest-file>
  local t="$1" w="$2" f="$3"
  if [ -z "$f" ]; then check dest_collision UNKNOWN "no --dest-file given — overwrite cannot be ruled out"; return; fi
  if [ -e "$t/$w/$f" ]; then check dest_collision BLOCK "$w/$f already exists in target — cp would overwrite"
  else check dest_collision PASS "$w/$f absent in target"; fi
}

# fails_when: our OWN who/coordination/ holds untracked inbound.
# why it matters: the first end of the both-ends sweep (F-INTAKE-04, five
# consecutive instances, load-bearing twice). Reported at every probe because the
# probe is the moment we are already looking at another vault's state.
check_own_inbound() {   # <self vault>
  local s="$1" n
  n="$(git -C "$s" ls-files --others --exclude-standard who/coordination/ 2>/dev/null | grep -c . | tr -d ' ')"
  if [ "${n:-0}" -eq 0 ]; then check own_inbound PASS "no undispositioned inbound here"
  else check own_inbound WARN "$n untracked inbound in our who/coordination/ — disposition by name before commit"; fi
}

run_probe() {
  printf '\nprobe_peer_state — target %s · write-dir %s\n' "${TARGET:-<none>}" "${WRITE_DIR:-<none>}"
  printf 'probed_at: %s   (this reading is valid for THIS command and no other)\n\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  check_target_exists       "$TARGET"
  check_active_leases       "$TARGET"
  check_declared_collision  "$TARGET" "$WRITE_DIR"
  check_writedir_dirty      "$TARGET" "$WRITE_DIR"
  check_dest_collision      "$TARGET" "$WRITE_DIR" "$DEST_FILE"
  check_own_inbound         "$SELF_VAULT"
  printf '\n---\nprobe: %d pass, %d warn, %d BLOCK, %d UNKNOWN\n' "$pass" "$warn" "$block" "$unknown"
  if [ "$block" -eq 0 ] && [ "$unknown" -eq 0 ]; then
    printf 'verdict: GO\n'; return 0
  fi
  printf 'verdict: REFUSE  (BLOCK or UNKNOWN present; an unknown reading is not a silent pass)\n'; return 3
}

# ===========================================================================
# --meta : the meta-control (ADR-011 A4 §6).
# Fixtures are built in temp dirs and removed. No vault is touched.
# ===========================================================================
fixture_vault() {          # -> path of a fresh peer-vault fixture, no live lease
  local d; d="$(mktemp -d)"
  git -C "$d" init -q 2>/dev/null
  git -C "$d" config user.email meta@local; git -C "$d" config user.name meta
  mkdir -p "$d/how/sessions/active" "$d/who/coordination"
  : > "$d/how/sessions/active/.gitkeep"
  echo seed > "$d/who/coordination/.gitkeep"
  git -C "$d" add -A >/dev/null 2>&1; git -C "$d" commit -qm base >/dev/null 2>&1
  echo "$d"
}

lease_yaml() {             # <vault> <status> <declared path...>
  local v="$1" st="$2"; shift 2
  { printf -- '---\nstatus: %s\ndeclared_files:\n' "$st"
    local p; for p in "$@"; do printf -- '  - %s\n' "$p"; done
    printf -- 'tags: [session]\n---\n'
  } > "$v/how/sessions/active/session_meta_fixture.md"
}

# ⛔ F-P7b-d — read this before "simplifying" the line that parses $out.
# meta_expect adjudicates on the check's OWN EMITTED ROW, not on a counter.
# $( ... ) runs the check in a SUBSHELL: every counter increment is discarded, so
# a counter-based verdict is ALWAYS the same value and every fixture reports ok
# for a reason unrelated to the check. That defect shipped once, inside the
# harness that forbids it (F-P7a-f), and only the known-good control exposed it.
meta_expect() {            # <label> <expected PASS|NOTPASS> <checkfn> <args...>
  local label="$1" want="$2" fn="$3"; shift 3
  local out; out="$("$fn" "$@" 2>&1)"
  local got="NOTPASS"; case "$out" in *"  PASS    "*) got="PASS" ;; esac
  if [ "$got" = "$want" ]; then printf '  ok    %-34s (%s)\n' "$label" "$(echo "$out" | awk '{print $1}')"; return 0; fi
  printf '  FAIL  %-34s wanted %s got %s :: %s\n' "$label" "$want" "$got" "$out"; return 1
}

run_meta() {
  printf '\nmeta-control — each check must be demonstrated able to FAIL (ADR-011 A4 §6)\n\n'
  local bad=0 d W="who/coordination"

  meta_expect "A missing target -> block"      NOTPASS check_target_exists "/nonexistent/$$" || bad=1

  d="$(fixture_vault)"; lease_yaml "$d" active "STATE.md"
  meta_expect "B live lease -> not pass"       NOTPASS check_active_leases "$d" || bad=1
  rm -rf "$d"

  # ⭐ FIXTURE C — THE ONE THIS INSTRUMENT EXISTS FOR.
  # A live lease that declares an UNRELATED file set, while its BODY quotes our
  # target directory inside a documented sweep command. This is not hypothetical:
  # it is aDNA.aDNA's live lease on 2026-08-22, verbatim in shape. A grep-based
  # check REFUSES this send and is wrong; the correct reading is GO on this axis.
  d="$(fixture_vault)"; lease_yaml "$d" active "STATE.md" "site/src/pages/index.astro"
  cat >> "$d/how/sessions/active/session_meta_fixture.md" <<'PROSE'

## Untracked coordination sweep — at OPEN

`git ls-files --others --exclude-standard who/coordination/` -> 1 memo.
Out of scope: `who/coordination/` intake is not a leg of this sitting.
PROSE
  meta_expect "C prose mentions dir -> PASS"   PASS    check_declared_collision "$d" "$W" || bad=1
  #    ...and the same fixture with the directory actually DECLARED must BLOCK.
  lease_yaml "$d" active "who/coordination/" "STATE.md"
  meta_expect "C' declared dir -> block"       NOTPASS check_declared_collision "$d" "$W" || bad=1
  #    ...and the table form must be read too, not only the YAML form.
  lease_yaml "$d" active "STATE.md"
  printf '| **Files declared** | `%s` · `STATE.md` |\n' "$W" >> "$d/how/sessions/active/session_meta_fixture.md"
  meta_expect "C'' table-form decl -> block"   NOTPASS check_declared_collision "$d" "$W" || bad=1
  rm -rf "$d"

  d="$(fixture_vault)"; echo edited >> "$d/who/coordination/.gitkeep"
  meta_expect "D tracked edit in dir -> block" NOTPASS check_writedir_dirty "$d" "$W" || bad=1
  rm -rf "$d"

  d="$(fixture_vault)"; : > "$d/who/coordination/already.md"
  meta_expect "E dest exists -> block"         NOTPASS check_dest_collision "$d" "$W" already.md || bad=1
  meta_expect "F no --dest-file -> unknown"    NOTPASS check_dest_collision "$d" "$W" "" || bad=1
  rm -rf "$d"

  d="$(fixture_vault)"; : > "$d/who/coordination/inbound.md"
  meta_expect "G untracked inbound -> warn"    NOTPASS check_own_inbound "$d" || bad=1
  rm -rf "$d"

  printf '\n  -- known-good controls (an instrument stuck at FAIL is as useless as one stuck at PASS) --\n'
  d="$(fixture_vault)"; lease_yaml "$d" completed "STATE.md"
  meta_expect "control target_exists"          PASS check_target_exists      "$d"        || bad=1
  meta_expect "control active_leases"          PASS check_active_leases      "$d"        || bad=1
  meta_expect "control declared_collision"     PASS check_declared_collision "$d" "$W"   || bad=1
  meta_expect "control writedir_dirty"         PASS check_writedir_dirty     "$d" "$W"   || bad=1
  meta_expect "control dest_collision"         PASS check_dest_collision     "$d" "$W" new.md || bad=1
  meta_expect "control own_inbound"            PASS check_own_inbound        "$d"        || bad=1
  rm -rf "$d"

  # ⛔ THE CONTROL THAT MATTERS MOST: --exec must NOT run its command on a REFUSE.
  # An --exec that fires anyway is F-P7a-f in a new coat — a guard that cannot
  # guard, printing a refusal while the act it refused has already happened.
  printf '\n  -- --exec gating (a probe that reports and then lets the act run is not a probe) --\n'
  local sent; sent="$(mktemp)"; rm -f "$sent"
  d="$(fixture_vault)"; lease_yaml "$d" active "who/coordination/"
  bash "$0" --target "$d" --write-dir "$W" --dest-file new.md --self "$d" \
       --exec "touch '$sent'" >/dev/null 2>&1
  if [ -e "$sent" ]; then printf '  FAIL  %-34s --exec RAN on a REFUSE\n' "H refuse -> exec suppressed"; bad=1
  else printf '  ok    %-34s (command not run)\n' "H refuse -> exec suppressed"; fi
  lease_yaml "$d" completed "STATE.md"
  bash "$0" --target "$d" --write-dir "$W" --dest-file new.md --self "$d" \
       --exec "touch '$sent'" >/dev/null 2>&1
  if [ -e "$sent" ]; then printf '  ok    %-34s (command ran)\n' "I go -> exec runs"
  else printf '  FAIL  %-34s --exec did NOT run on a GO\n' "I go -> exec runs"; bad=1; fi
  rm -f "$sent"; rm -rf "$d"

  printf '\n---\nmeta-control: %s\n' \
    "$([ "$bad" -eq 0 ] && echo 'every check reached its failure state; controls passed; --exec gates both ways' || echo 'DEFECT — see FAIL rows above')"
  [ "$bad" -eq 0 ]
}

case "$MODE" in
  meta) run_meta; exit $? ;;
esac

run_probe; rc=$?
if [ -n "$EXEC_CMD" ]; then
  if [ "$rc" -eq 0 ]; then
    printf '\n--exec (GO) : %s\n' "$EXEC_CMD"
    eval "$EXEC_CMD"; ec=$?
    printf '--exec exit : %d\n' "$ec"
    exit "$ec"
  fi
  printf '\n--exec (REFUSE) : NOT RUN — %s\n' "$EXEC_CMD"
fi
exit "$rc"
