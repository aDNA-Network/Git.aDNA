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
#   ⛔ THE PREDICATE RULE, which has now failed in FIVE directions (could not fail ·
#   matched documentation · could not succeed · compared against the wrong object ·
#   could not DISCRIMINATE) — and four of the five PRINTED THE ANSWER WE WANTED:
#     · `lfs_rehydration` false-BLOCKED on the two files that merely QUOTE the LFS
#       pointer signature (F-P7b-e).
#     · A peer's census adjudicated a hook by grepping for `pre-commit`, and moved
#       68 repos (F-P7b-f).
#
#   ⚠ CORRECTED 2026-08-24 (ADR-011 A6, Consequences bullet 1 — this header's own
#   stated rationale was owed an update, and the update is not a nicety).
#
#   This header used to attribute F-P7b-f to "a string that appears in that hook's
#   OWN COMMENT BLOCK" — full stop. Galileo re-measured instead of taking our
#   retraction on our word, and that is HALF the mechanism. The loose predicate
#   scores 2 on the hardened hook, and the two hits are DIFFERENT FP CLASSES:
#     · line 13 — the defect's own documentation.        ← the half we had filed
#     · line 44 — `(same probe discipline as the sibling pre-commit hook)`
#                 ⇒ A REFERENCE TO A DIFFERENT HOOK ENTIRELY. Not documentation
#                 of the defect, not about the flag. Our wording did not reach it.
#
#   ⭐ And the correction carries the sharper finding: the loose predicate is
#   ANTI-CORRELATED. It scores the MOST HARDENED file HIGHEST, because remediation
#   documentation is written INTO the remediated artifact — a hook earns its false
#   red by explaining the defect it fixed. This header is itself such an artifact.
#
#   ⚠ The stricter form is worse in the way that matters: `grep -c -- '--pre-commit'`
#   returns 1 · 1 · 1 across hardened / no-op / v2 — arithmetically correct,
#   anchored, comment-excluded, AND UNABLE TO SEPARATE A GATED HOOK FROM A NO-OP.
#   ⭐ That is the FIFTH direction, and the dangerous one, because it looks like the
#   fixed instrument: it satisfies every stated repair of the first four and still
#   measures nothing. A6 §4 binds the answer — a content check tests for the presence
#   of the FIX'S MECHANISM (`remote_sha|local_sha` = 8/0/8, or HOOK_CONTRACT_VERSION),
#   never for the absence of the DEFECT'S NAME. The absence of a defect's name is
#   evidence about prose; the presence of a fix's mechanism is evidence about behaviour.
#
#   ⛩ THE INSTRUMENT ITSELF IS UNAFFECTED and was never at risk: `declared_collision`
#   reads declarations POSITIONALLY (below), and `census_secret_gate.sh` adjudicates by
#   digest, which is immune by construction. What was defective was the REASON WRITTEN
#   DOWN FOR WHY — and a guard whose stated rationale is wrong will be widened wrongly
#   by whoever extends it next.
#
#   So `declared_collision` below does NOT grep the lease for our directory name.
#   A lease is FULL OF paths in prose — Rosetta's live lease on 2026-08-22 contains
#   the literal string `who/coordination/` inside a documented sweep command while
#   declaring an entirely different file set. A naive grep REFUSES that send, and
#   it is wrong. Declared paths are read from the two places a declaration can
#   legitimately live, and from nowhere else. Fixture C proves it.
# ---------------------------------------------------------------------------
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ⛔ F-DF-215 (Galileo, Jupyter.aDNA, 2026-08-25) — SELF_VAULT NO LONGER DEFAULTS.
#   It used to be `$(cd "$HERE/../.." && pwd)` — the SCRIPT's own repo. Every peer calling this gate
#   therefore had check 7 run against `Git.aDNA`, and the row it printed said "our" about somebody
#   else's mail. Six of the seven checks take an explicit --target; this was the one taking an
#   implicit vault, which is exactly why nobody thought to pass the flag.
#
#   ⚠ It failed in BOTH directions and the quiet one was the dangerous one: a caller whose own box was
#   dirty read PASS whenever ours happened to be clean — a fail-open on the check whose entire job is
#   *do not commit over undispositioned inbound*.
#
#   Ruled at the 2026-08-25 plan gate: Galileo's shapes 2+3, REFUSE rather than guess. Shape 1
#   (default to $PWD's enclosing vault) was offered and DECLINED — it replaces one silent default with
#   another, and this desk's own argument one line up in FO-10 is that a silently-IGNORED flag is a
#   fail-open. A silently-DEFAULTED one is the same animal.
SELF_VAULT=""

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

pass=0; warn=0; block=0; unknown=0; inferred=0
check() {  # <name> <verdict PASS|PASS_INFERRED|WARN|BLOCK|UNKNOWN> <detail>
  case "$2" in
    PASS)  pass=$((pass+1));      printf '  PASS    %-20s %s\n' "$1" "$3" ;;
    # ⚠ PASS_INFERRED is a PASS whose basis is an INFERENCE, not a direct reading, and it
    #   is a distinct verdict precisely so a reader can see that. It permits (counts toward
    #   GO) but never disguises itself as a measurement. Added 2026-08-26 — see the
    #   lease-surface block in check_active_leases for the one inference it is used for,
    #   and the stated limit on that inference.
    PASS_INFERRED)
           inferred=$((inferred+1));printf '  PASS~   %-20s %s\n' "$1" "$3" ;;
    WARN)  warn=$((warn+1));      printf '  WARN    %-20s %s\n' "$1" "$3" ;;
    BLOCK) block=$((block+1));    printf '  BLOCK   %-20s %s\n' "$1" "$3" ;;
    *)     unknown=$((unknown+1));printf '  UNKNOWN %-20s %s\n' "$1" "$3" ;;
  esac
}

# ===========================================================================
# Lease-surface resolution  (F-P7b-w's CLASS, swept 2026-08-26)
#
# ⛔ THE DEFECT THIS FIXES IS NOT A FAIL-OPEN, AND CALLING IT ONE WOULD BE WRONG.
#   check_active_leases and check_declared_collision both hardcoded "$t/how/sessions/active"
#   and returned UNKNOWN when it was absent. Under UNKNOWN-never-PASS that REFUSES, so the
#   checks were fail-CLOSED and safe. They failed *uninformative*: for 23 of 97 fleet vaults
#   they could never return anything but UNKNOWN, so the gate could never say GO to a quarter
#   of the fleet for a reason about OUR path assumption rather than the peer's state.
#
# ⭐ Measured 2026-08-26 across 97 git vaults — and the 23 are not one population:
#     74  have how/sessions/active/            → read it directly, unchanged
#     15  have how/sessions/history/ but no active/   → CONVENTIONAL vault, empty active/
#      8  have no how/sessions/history/ at all        → genuinely unreadable
#   git cannot track an empty directory. A conventional vault with no live lease therefore
#   has NO active/ at all unless someone left a .gitkeep in it — which is why our own vault
#   keeps one. For those 15, absence is POSITIVE EVIDENCE of zero live leases, and the old
#   code converted the strongest available evidence into a refusal.
#
#   Forgejo.aDNA is one of the 15. Every lease reading this desk has taken of the peer it
#   corresponds with most has been structurally uninformative.
#
# ⚠ THE LIMIT OF THE INFERENCE, STATED RATHER THAN BURIED. An absent active/ in a WORKING
#   TREE could also mean the directory was deleted, or that a vault stages leases somewhere
#   this predicate does not know about. The inference is "conventional layout + no active/
#   ⇒ no live lease", and it is a good inference, not a reading. That is exactly why it
#   returns PASS_INFERRED and not PASS: a reader can see an inference was made, and a later
#   finding can be filed against it by name.
#
#   The flat-layout vaults (session files directly under how/sessions/, no history/ split)
#   stay UNKNOWN, correctly — Operations.aDNA is one of them and had a session file dated
#   the day this was written, so it is a vault actively working whose leases we cannot read.
#
# Returns: "direct" (active/ present) · "inferred" (conventional, empty) · "unknown"
# ===========================================================================
lease_surface() {   # <target>
  local t="$1"
  if [ -d "$t/how/sessions/active" ]; then printf 'direct\n'; return; fi
  if [ -d "$t/how/sessions/history" ]; then printf 'inferred\n'; return; fi
  printf 'unknown\n'
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

# fails_when: the WRITE-DIR itself does not exist in the target, so the copy cannot
# land — regardless of what every other check says about it.
#
# ⛔ F-P7b-n, 2026-08-24, found IN LIVE USE and not by the meta-control. A send to
#   `WGS.aDNA/who/coordination` returned **verdict: GO** and the `cp` exited 1: that
#   vault's coordination surface is `who/comms/`, and `who/coordination/` has never
#   existed there. The probe checked the VAULT and never the DIRECTORY.
#
#   ⭐ And `dest_collision` reported **PASS — "absent in target"**, which was true and
#   entirely misleading: the destination file was absent because the whole DIRECTORY
#   was absent. **Absence read as health**, on the one check whose job is to look at
#   the destination — the same family as `ln -sf` onto a missing target (F-P7b-l) and
#   A4 §4's `[ -d .git ]`. The only thing that caught it was `--exec`'s exit code, i.e.
#   the act itself. ⛩ A probe whose verdict is corrected by the act it gates has the
#   dependency backwards.
check_writedir_exists() {   # <target> <write-dir>
  local t="$1" w="$2"
  if [ -z "$w" ]; then check writedir_exists UNKNOWN "no --write-dir given"; return; fi
  if [ ! -d "$t/$w" ]; then
    check writedir_exists BLOCK "$w does not exist in target — the copy cannot land (check the vault's actual coordination surface; e.g. some use who/comms/)"
    return
  fi
  check writedir_exists PASS "$w exists"
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
  case "$(lease_surface "$t")" in
    inferred) check active_leases PASS_INFERRED "no active/ but how/sessions/history/ present — conventional layout, empty active/ ⇒ 0 live leases (INFERRED, not read; git cannot track an empty dir)"; return ;;
    unknown)  check active_leases UNKNOWN "no how/sessions/ layout found (neither active/ nor history/) — cannot read leases, and an unknown reading is never a silent pass"; return ;;
  esac
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
  # Same three-way resolution as check_active_leases — and the inference carries further
  # here: no live lease exists ⇒ no live lease can DECLARE our write directory. Deliberately
  # NOT re-derived; the two checks must agree about what surface they are reading, and the
  # 2026-08-25 repair fixed the sibling defect in check_own_inbound at its instance only.
  case "$(lease_surface "$t")" in
    inferred) check declared_collision PASS_INFERRED "no active/ but how/sessions/history/ present — 0 live leases ⇒ none can declare $w (INFERRED)"; return ;;
    unknown)  check declared_collision UNKNOWN "no how/sessions/ layout found (neither active/ nor history/)"; return ;;
  esac
  if [ -z "$w" ]; then check declared_collision UNKNOWN "no --write-dir given"; return; fi
  # Unreachable given lease_surface() above returned "direct" — kept as a defensive arm,
  # not as live logic. If it ever fires, lease_surface and this check have disagreed about
  # the same directory, which is a defect in the resolution and must not read as a pass.
  if [ ! -d "$dir" ]; then check declared_collision UNKNOWN "lease_surface said direct but $dir is absent — resolution disagreement"; return; fi
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
  # ⛔ -uall is REQUIRED on both reads. F-DF-145 (Venus, Network.aDNA S374; reached us
  # via Galileo's drop-box README): git's default -unormal COLLAPSES a directory whose
  # contents are entirely untracked into ONE `?? dir/` line. A peer's brand-new drop-box
  # holding 3 queued memos then reads as `1 untracked file`.
  #
  # ⚠ Scope it honestly — this is a COUNT defect, not a DECISION defect. The branch below
  # keys on tracked>0 / untracked>0, and the tracked-vs-untracked CLASSIFICATION survives
  # the collapse intact, so every GO/NO-GO this probe has ever returned was correct. What
  # was wrong is the queue depth we reported to the operator in the WARN line.
  # Measured 2026-08-24 in an isolated repo: 3 memos → default 1, -uall 3.
  tracked="$(git -C "$t" status --porcelain -uall -- "$w" 2>/dev/null | grep -cv '^??' | tr -d ' ')"
  untracked="$(git -C "$t" status --porcelain -uall -- "$w" 2>/dev/null | grep -c '^??' | tr -d ' ')"
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
#
# ⛔ DO NOT "SIMPLIFY" THE ls-files CALL BELOW INTO `git status`. It is load-bearing.
#   `ls-files --others` enumerates FILES and is immune to the F-DF-145 -unormal collapse
#   documented at check_writedir_dirty; `git status` without -uall is not. Since
#   2026-08-24 this vault publishes a drop-box at who/coordination/inbox/, which is
#   exactly the all-untracked directory that triggers the collapse — so this leg reads
#   the drop-box correctly ONLY because of the command it happens to use.
#
# ⚠ And that immunity was ACCIDENTAL, which is the whole reason this comment exists.
#   `ls-files` was chosen here before F-DF-145 was known to this vault; nobody selected
#   it to dodge a defect they had never heard of. Verified by measurement on 2026-08-24,
#   not by reading: 3 memos in an all-untracked box → ls-files 3, git status 1.
#   ⭐ An undesigned immunity is not a guarantee. It holds until someone refactors this
#   line to the more obvious idiom, at which point our inbound sweep goes blind on the
#   first memo into an empty box — the condition where being blind costs the most.
#
# ---------------------------------------------------------------------------
# ⛔ F-P7b-w, 2026-08-25 — THE SECOND FAIL-OPEN IN THIS CHECK, and it is not the
#   one that was reported to us. Galileo's F-DF-215 is about measuring the wrong
#   VAULT. This one is about measuring the wrong DIRECTORY inside whatever vault
#   you got.
#
#   This function hardcoded `who/coordination/`. ⛔ **F-P7b-n, documented ~130
#   lines up in THIS FILE at check_writedir_exists, had already established that
#   fleet coordination surfaces differ** — that finding was raised by a send to
#   `WGS.aDNA/who/coordination` returning GO while the `cp` exited 1, because that
#   vault's surface is `who/comms/`. It was fixed at its instance and never swept
#   to its class, so the identical assumption sat untouched one check below the
#   comment describing it.
#
# ⚠ Measured live at the repair, not argued: `WGS.aDNA` was holding an
#   undispositioned inbound in `who/comms/` — ONE OF OUR OWN MEMOS — and this
#   check returned `PASS  no undispositioned inbound here` for it, **even with
#   --self passed correctly**. `operations_stanley.aDNA` has NEITHER surface and
#   would likewise have read 0 → PASS.
#
#   ⭐ Third instance of this desk's own sentence: *a finding closed at its
#   instance is not a finding closed* (cf. F-Astro; F-P7b-b, where a peer ran our
#   class-sweep for us). The sweep is one command.
#
#   Resolution order: `who/coordination/` then `who/comms/`; where BOTH exist both
#   are measured and both are named. Where NEITHER exists the verdict is UNKNOWN,
#   never PASS — UNKNOWN already forces REFUSE through run_probe's existing verdict
#   logic, so this reuses the fail-closed machinery rather than inventing one,
#   exactly as A4 §2 requires.
#
# ⭐ Every row now NAMES the vault and the surface it measured. That is the
#   ADR-011 A7 remedy class one instrument over — *a digest is a name, not a
#   verdict* — applied to a reading: state what was measured, so a reader can tell
#   a true reading from a true-looking one. Galileo makes this argument himself in
#   his §4 shape 3, and it COMPOSES with the refusal rather than substituting for it.
check_own_inbound() {   # <self vault>
  local s="$1" d raw rc n total=0 detail="" surfaces=""

  # ⛔ F-DF-215: no implicit vault. Refusing beats guessing, and BLOCK beats WARN
  #   because a missing flag is a definite defect in the invocation, not an
  #   ambiguous reading.
  if [ -z "$s" ]; then
    check own_inbound BLOCK "--self not given — refusing to guess whose mailbox to measure (F-DF-215; pass --self <your vault>)"
    return
  fi
  if [ ! -d "$s" ]; then
    check own_inbound BLOCK "--self $s: no such directory"
    return
  fi
  # ⛔ `-e`, never `-d`: on a linked worktree `.git` is a FILE. A4 §4 is precisely
  #   this mistake, and check_target_exists above already uses the correct form —
  #   matched here deliberately rather than re-derived.
  if [ ! -e "$s/.git" ]; then
    check own_inbound BLOCK "--self $s is not a git working tree — ls-files would return nothing, and nothing reads as clean"
    return
  fi

  for d in who/coordination who/comms; do
    [ -d "$s/$d" ] && surfaces="$surfaces $d"
  done
  if [ -z "$surfaces" ]; then
    check own_inbound UNKNOWN "$(basename "$s"): no coordination surface found (who/coordination/ · who/comms/) — an unknown reading is never a silent pass (A4 §2)"
    return
  fi

  for d in $surfaces; do
    # ⛔ Capture, THEN test $?. NEVER pipe here: on 2026-08-24 this desk read a
    #   pipeline's exit code, measured `head`'s status instead of the command's,
    #   and published a false finding against a shipped script. An assignment's $?
    #   IS the command substitution's status; a pipeline's is the last stage's.
    raw="$(git -C "$s" ls-files --others --exclude-standard "$d/" 2>/dev/null)"
    rc=$?
    if [ "$rc" -ne 0 ]; then
      check own_inbound UNKNOWN "$(basename "$s"): ls-files exited $rc on $d/ — empty output is not a measurement"
      return
    fi
    n="$(printf '%s\n' "$raw" | grep -c . | tr -d ' ')"
    total=$(( total + ${n:-0} ))
    detail="$detail $d/=${n:-0}"
  done

  # ⚠ F-P7b-y, found at this sitting's OWN close sweep by running the repaired
  #   instrument on ourselves: this counts untracked files in the coordination
  #   surface, which includes THIS DESK'S OWN QUEUED OUTBOUND — the row said
  #   "untracked inbound" and that is not what it measures. Small, and it gates
  #   nothing (WARN, never BLOCK). ⛩ But it is the exact defect class this sitting
  #   is about — a row asserting more than its measurement supports — found in the
  #   row rewritten to fix that class, minutes after a memo arguing it went out.
  #   ⇒ The count is honest about what it is; the disposition instruction is unchanged,
  #   because queued outbound also wants dispositioning by name before a commit.
  if [ "$total" -eq 0 ]; then
    check own_inbound PASS "$(basename "$s"): coordination surface clean —$detail"
  else
    check own_inbound WARN "$(basename "$s"): $total untracked (inbound and/or our own queued outbound) —$detail — disposition by name before commit"
  fi
}

run_probe() {
  printf '\nprobe_peer_state — target %s · write-dir %s\n' "${TARGET:-<none>}" "${WRITE_DIR:-<none>}"
  printf 'probed_at: %s   (this reading is valid for THIS command and no other)\n\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  check_target_exists       "$TARGET"
  check_writedir_exists     "$TARGET" "$WRITE_DIR"
  check_active_leases       "$TARGET"
  check_declared_collision  "$TARGET" "$WRITE_DIR"
  check_writedir_dirty      "$TARGET" "$WRITE_DIR"
  check_dest_collision      "$TARGET" "$WRITE_DIR" "$DEST_FILE"
  check_own_inbound         "$SELF_VAULT"
  printf '\n---\nprobe: %d pass, %d pass~inferred, %d warn, %d BLOCK, %d UNKNOWN\n' "$pass" "$inferred" "$warn" "$block" "$unknown"
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

# ⛔ F-P7b-w fixtures. `fixture_vault` above builds a vault whose surface is
#   `who/coordination/` — the ONLY shape the harness knew how to build, which is
#   part of why the hardcoded-path fail-open survived every run of this control.
fixture_vault_history_only() {  # -> the 15-vault shape: how/sessions/history/ present, NO active/
  # ⭐ This is the Forgejo.aDNA shape, and 14 others. It is NOT a different convention —
  #   it is the SAME convention with an empty active/, which git cannot track and so does
  #   not materialise. Building it here rather than describing it is the point: the old
  #   code could never be pointed at this shape by any arm, which is why it survived.
  local d; d="$(mktemp -d)"
  git -C "$d" init -q 2>/dev/null
  git -C "$d" config user.email meta@local; git -C "$d" config user.name meta
  mkdir -p "$d/how/sessions/history" "$d/who/coordination"
  echo seed > "$d/how/sessions/history/.gitkeep"
  echo seed > "$d/who/coordination/.gitkeep"
  git -C "$d" add -A >/dev/null 2>&1; git -C "$d" commit -qm base >/dev/null 2>&1
  echo "$d"
}

fixture_vault_no_sessions() {   # -> the 8-vault shape: no how/sessions/ layout at all
  local d; d="$(mktemp -d)"
  git -C "$d" init -q 2>/dev/null
  git -C "$d" config user.email meta@local; git -C "$d" config user.name meta
  mkdir -p "$d/who/coordination"
  echo seed > "$d/who/coordination/.gitkeep"
  git -C "$d" add -A >/dev/null 2>&1; git -C "$d" commit -qm base >/dev/null 2>&1
  echo "$d"
}

fixture_vault_comms() {    # -> a vault whose coordination surface is who/comms/ (the WGS.aDNA shape)
  local d; d="$(mktemp -d)"
  git -C "$d" init -q 2>/dev/null
  git -C "$d" config user.email meta@local; git -C "$d" config user.name meta
  mkdir -p "$d/how/sessions/active" "$d/who/comms"
  : > "$d/how/sessions/active/.gitkeep"
  echo seed > "$d/who/comms/.gitkeep"
  git -C "$d" add -A >/dev/null 2>&1; git -C "$d" commit -qm base >/dev/null 2>&1
  echo "$d"
}

fixture_vault_nosurface() { # -> a git vault with NO coordination surface at all (the operations_stanley.aDNA shape)
  local d; d="$(mktemp -d)"
  git -C "$d" init -q 2>/dev/null
  git -C "$d" config user.email meta@local; git -C "$d" config user.name meta
  mkdir -p "$d/how/sessions/active"
  : > "$d/how/sessions/active/.gitkeep"
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

# ⛔ meta_expect adjudicates PASS vs NOTPASS and NOTHING FINER. For F-P7b-w that is
#   not enough: BLOCK, WARN and UNKNOWN are all "NOTPASS", and they are three
#   different rulings with three different consequences. A control that cannot tell
#   a refusal from a warning cannot certify a fail-CLOSED posture — it only certifies
#   "not PASS", which is exactly the resolution at which the original defect hid.
meta_expect_verdict() {    # <label> <PASS|WARN|BLOCK|UNKNOWN> <checkfn> <args...>
  local label="$1" want="$2" fn="$3"; shift 3
  local out; out="$("$fn" "$@" 2>&1)"
  local got; got="$(printf '%s\n' "$out" | awk 'NF{print $1; exit}')"
  if [ "$got" = "$want" ]; then printf '  ok    %-34s (%s)\n' "$label" "$got"; return 0; fi
  printf '  FAIL  %-34s wanted %s got %s :: %s\n' "$label" "$want" "${got:-<none>}" "$out"; return 1
}

# ⛔⛔ F-P7b-x — THE ARM THIS HARNESS NEVER HAD, and the reason two fail-opens
#   survived every green run of this control.
#
#   Every arm above invokes a check FUNCTION DIRECTLY, passing "$d" by hand. The two
#   full-process arms further down pass `--self "$d"` EXPLICITLY. So the harness
#   supplied, in every single arm, the very argument a real caller omits — and
#   `SELF_VAULT`'s default was therefore never once exercised by the instrument
#   built to exercise this script.
#
#   ⭐ The control validated a code path no caller takes. That is Galileo's own §5
#   argument (F-DF-178: *a validation is incomplete without the paired arm*) landing
#   on our instrument rather than on the hook it was written about.
#
#   ⇒ These arms run the script as a PROCESS, through argument parsing, the way a
#   caller does. A defect in the arg block is invisible to any other kind of arm.
meta_expect_proc() {       # <label> <PASS|WARN|BLOCK|UNKNOWN> <target> [extra argv...]
  local label="$1" want="$2" tgt="$3"; shift 3
  local out; out="$(bash "$0" --target "$tgt" --write-dir who/coordination \
                         --dest-file meta_probe_absent.md "$@" 2>&1)"
  local row; row="$(printf '%s\n' "$out" | grep own_inbound | head -1)"
  local got; got="$(printf '%s\n' "$row" | awk '{print $1}')"
  if [ "$got" = "$want" ]; then printf '  ok    %-34s (%s, full process)\n' "$label" "$got"; return 0; fi
  printf '  FAIL  %-34s wanted %s got %s :: %s\n' "$label" "$want" "${got:-<none>}" "$row"; return 1
}

run_meta() {
  printf '\nmeta-control — each check must be demonstrated able to FAIL (ADR-011 A4 §6)\n\n'
  local bad=0 d W2 W="who/coordination"

  meta_expect "A missing target -> block"      NOTPASS check_target_exists "/nonexistent/$$" || bad=1

  # F-P7b-n: the write-dir is a SEPARATE existence question from the vault, and the live
  # miss (WGS.aDNA/who/coordination, which has never existed) proved they are not the same.
  # ⭐ The fixture is a REAL vault with a MISSING write-dir — precisely the state that
  # returned GO. A fixture with a missing vault would pass this check for the wrong reason.
  d="$(fixture_vault)"
  meta_expect "A' missing write-dir -> block"  NOTPASS check_writedir_exists "$d" "who/nonexistent_$$" || bad=1
  rm -rf "$d"

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

  # -------------------------------------------------------------------------
  # F-DF-215 (Galileo) + F-P7b-w (ours) — the two fail-opens in check_own_inbound.
  # Every arm below asserts the EXACT verdict, not merely "not PASS": the whole
  # point of both fixes is WHICH refusal is returned, and a NOTPASS assertion
  # cannot see the difference.
  # -------------------------------------------------------------------------
  printf '\n  -- own_inbound: whose mailbox, and which drawer (F-DF-215 · F-P7b-w) --\n'

  meta_expect_verdict "G' no --self -> BLOCK"      BLOCK   check_own_inbound ""   || bad=1
  meta_expect_verdict "G'' --self absent -> BLOCK" BLOCK   check_own_inbound "/nonexistent/$$" || bad=1

  d="$(mktemp -d)"; mkdir -p "$d/who/coordination"      # a real dir, but NOT a git tree
  meta_expect_verdict "G''' not a git tree -> BLOCK" BLOCK check_own_inbound "$d" || bad=1
  rm -rf "$d"

  # ⛔ THE ONE THAT WAS LIVE. Pre-repair this returned PASS while the vault held an
  #   undispositioned memo — measured on WGS.aDNA, holding one of OUR OWN memos.
  d="$(fixture_vault_comms)"; : > "$d/who/comms/inbound.md"
  meta_expect_verdict "H who/comms inbound -> WARN" WARN   check_own_inbound "$d" || bad=1
  rm -rf "$d"

  d="$(fixture_vault_nosurface)"
  meta_expect_verdict "H' no surface -> UNKNOWN"   UNKNOWN check_own_inbound "$d" || bad=1
  rm -rf "$d"

  # Both surfaces present: both must be measured, and the count must be their SUM.
  # ⚠ A check that resolved to the FIRST surface and stopped would pass every arm
  #   above and still under-report here — the failure mode a resolution order invites.
  d="$(fixture_vault)"; mkdir -p "$d/who/comms"
  : > "$d/who/coordination/one.md"; : > "$d/who/comms/two.md"
  if check_own_inbound "$d" 2>&1 | grep -q 'who/coordination/=1 who/comms/=1'; then
    printf '  ok    %-34s (both surfaces summed)\n' "H'' both surfaces -> 2"
  else
    printf '  FAIL  %-34s :: %s\n' "H'' both surfaces -> 2" "$(check_own_inbound "$d" 2>&1)"; bad=1
  fi
  rm -rf "$d"

  # ⭐ F-P7b-x: the arms above still call the FUNCTION. These run the PROCESS, so the
  #   argument block itself is under test — the one region no other arm can reach.
  printf '\n  -- full-process arms: the arg block is the defect surface (F-P7b-x) --\n'
  d="$(fixture_vault)"; lease_yaml "$d" completed "STATE.md"
  meta_expect_proc "P no --self -> BLOCK"          BLOCK   "$d" || bad=1
  meta_expect_proc "P' --self given -> PASS"       PASS    "$d" --self "$d" || bad=1
  rm -rf "$d"

  d="$(fixture_vault_comms)"; : > "$d/who/comms/inbound.md"
  # target must be a vault the write-dir exists in, so probe the coordination fixture
  # while pointing --self at the comms-shaped one: whose mailbox is the question here.
  W2="$(fixture_vault)"; lease_yaml "$W2" completed "STATE.md"
  meta_expect_proc "P'' --self comms -> WARN"      WARN    "$W2" --self "$d" || bad=1
  rm -rf "$d" "$W2"

  # ⭐ F-P7b-w's CLASS (2026-08-26): the lease surface, swept rather than fixed at its
  #   instance. Three populations measured across 97 fleet vaults — 74 direct, 15
  #   conventional-but-empty, 8 genuinely absent — and each must produce a DIFFERENT
  #   verdict. An arm per population, because the defect these replace was precisely
  #   "answers identically regardless of what it is pointed at".
  printf '\n  -- lease-surface resolution: three populations, three verdicts (F-P7b-w class) --\n'

  d="$(fixture_vault)"; lease_yaml "$d" completed "STATE.md"          # active/ present
  meta_expect_verdict "S direct -> PASS"           PASS          check_active_leases      "$d" || bad=1
  meta_expect_verdict "S direct declared -> PASS"  PASS          check_declared_collision "$d" "$W" || bad=1
  rm -rf "$d"

  d="$(fixture_vault_history_only)"                                   # history/ only
  # ⚠ meta_expect_verdict adjudicates on the PRINTED token (first field), not the internal
  #   verdict name passed to check(). Those differ deliberately: check() takes PASS_INFERRED,
  #   the row prints PASS~. Asserting the internal name here failed on the first run — the
  #   behaviour was correct and the assertion was not, which is worth one line of comment
  #   so the next reader does not "fix" the code to match a wrong test.
  meta_expect_verdict "T conventional -> PASS~"    "PASS~"       check_active_leases      "$d" || bad=1
  meta_expect_verdict "T' conventional declared"   "PASS~"       check_declared_collision "$d" "$W" || bad=1
  rm -rf "$d"

  d="$(fixture_vault_no_sessions)"                                    # no how/sessions/ at all
  meta_expect_verdict "U no layout -> UNKNOWN"     UNKNOWN       check_active_leases      "$d" || bad=1
  meta_expect_verdict "U' no layout declared"      UNKNOWN       check_declared_collision "$d" "$W" || bad=1
  rm -rf "$d"

  # ⚠ PASS_INFERRED must PERMIT (count toward GO) — otherwise the repair changed the
  #   label and not the outcome, which is the failure mode this sweep exists to avoid.
  d="$(fixture_vault_history_only)"
  if bash "$0" --target "$d" --write-dir "$W" --dest-file new.md --self "$d" 2>&1 | grep -q 'verdict: GO'; then
    printf '  ok    %-34s (inferred permits)\n' "V PASS~ counts toward GO"
  else
    printf '  FAIL  %-34s inferred did NOT reach GO\n' "V PASS~ counts toward GO"; bad=1
  fi
  rm -rf "$d"

  # ⭐ Galileo's §2(ii) (F-DF-221, 2026-08-27): "nothing in --meta stages an outbound
  #   memo", so F-P7b-y's label repair was correct only because it was written correctly,
  #   not because anything checked it. He is right, and it is his own F-DF-178 clause —
  #   a validation is incomplete without the paired arm — landing here for the third time.
  #   This arm stages a file carrying `direction: outbound` and asserts the row does NOT
  #   claim it is inbound.
  printf '\n  -- outbound staging: the row must not call our own queued mail "inbound" (F-DF-221) --\n'
  d="$(fixture_vault)"
  printf -- '---\ndirection: outbound\n---\nqueued reply\n' > "$d/who/coordination/outbound_draft.md"
  out="$(check_own_inbound "$d" 2>&1)"
  if printf '%s\n' "$out" | grep -q 'untracked (inbound and/or our own queued outbound)'; then
    printf '  ok    %-34s (label covers both directions)\n' "W outbound -> honest label"
  else
    printf '  FAIL  %-34s :: %s\n' "W outbound -> honest label" "$out"; bad=1
  fi
  if printf '%s\n' "$out" | grep -qE 'untracked inbound[^ ]|[0-9]+ inbound '; then
    printf '  FAIL  %-34s row asserts "inbound" over queued outbound\n' "W' no false inbound claim"; bad=1
  else
    printf '  ok    %-34s (no unqualified inbound claim)\n' "W' no false inbound claim"
  fi
  rm -rf "$d"

  printf '\n  -- known-good controls (an instrument stuck at FAIL is as useless as one stuck at PASS) --\n'
  d="$(fixture_vault)"; lease_yaml "$d" completed "STATE.md"
  meta_expect "control target_exists"          PASS check_target_exists      "$d"        || bad=1
  meta_expect "control writedir_exists"        PASS check_writedir_exists    "$d" "who/coordination" || bad=1
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
    # ⛔ `printf '--exec exit ...'` -- a format string starting with `--` is parsed as
    # OPTIONS by bash's printf builtin and dies "invalid option". Found live on the
    # first real delivery this instrument gated: the cp had already succeeded, so the
    # error was cosmetic -- but it printed AFTER the act and would read to anyone
    # scanning output as "the delivery errored". A guard whose report is unreadable at
    # the moment it matters is a guard with a broken last mile. `%s` it, always.
    printf '%s%d\n' '--exec exit : ' "$ec"
    exit "$ec"
  fi
  printf '\n%s%s\n' '--exec (REFUSE) : NOT RUN — ' "$EXEC_CMD"
fi
exit "$rc"
