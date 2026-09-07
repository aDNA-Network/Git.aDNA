#!/usr/bin/env bash
# census_secret_gate.sh — fleet secret-gate census (Git.aDNA · ADR-011 A4)
#
# Measures, for every push-capable git repo in a workspace, whether a secret-scanning pre-push
# gate is actually in force — and adjudicates the answer instead of asserting it.
#
# READ-ONLY BY CONSTRUCTION: no writes, no network, no credentials, no `git config --set`,
# no `gitleaks` invocation. Every git call is a read (`config --get`, `rev-parse`, `remote`).
# Safe to run against a live fleet mid-session.
#
# Implements ADR-011 A4:
#   §1  population = every push-capable repo, minus a dated + enumerated exemption list
#   §2  adjudication is a closed table WITH an explicit unknown class (unknown => FAIL)
#   §3  resolution order is binding: core.hooksPath -> rev-parse --git-path -> realpath -> adjudicate
#   §4  the enumeration predicate is part of the instrument (worktrees are in-population)
#
# Why the resolution order matters (F-P7a-i): a vault that sets `core.hooksPath` has a
# `.git/hooks/pre-push` that git NEVER CONSULTS. Reading it reports the health of a file nothing
# runs. `ScienceStanley.aDNA` is the live instance: its `.git/hooks/pre-push` adjudicates PASS
# while the hook git actually executes is the retired v1 no-op.
#
# Why enumeration matters (F-P7a-h): `[ -d .git ]` silently drops linked worktrees and submodules,
# whose `.git` is a FILE. A repo the predicate excludes is UNMEASURED, not healthy.
#
# Usage:
#   bash how/tests/census_secret_gate.sh [--root DIR] [--format tsv|summary] [--include-exempt]
#
# Output (TSV): repo  hooks_source  hook_state  digest  verdict  exec  link  remote  exempt
# Exit: 0 always (this is an instrument, not a gate — it reports, it does not block).

set -uo pipefail

ROOT="${HOME}/aDNA"
FORMAT="tsv"
INCLUDE_EXEMPT=1

while [ $# -gt 0 ]; do
  case "$1" in
    --root)           ROOT="$2"; shift 2 ;;
    --format)         FORMAT="$2"; shift 2 ;;
    --include-exempt) INCLUDE_EXEMPT=1; shift ;;
    --no-exempt)      INCLUDE_EXEMPT=0; shift ;;
    -h|--help)        sed -n '2,30p' "$0"; exit 0 ;;
    *) printf 'unknown arg: %s\n' "$1" >&2; exit 2 ;;
  esac
done

[ -d "$ROOT" ] || { printf 'root not found: %s\n' "$ROOT" >&2; exit 2; }

# ---------------------------------------------------------------------------
# Adjudication table (ADR-011 A3 §1 as amended by A4 §2).
# NEVER equality-test a single digest. Every reading resolves to a verdict,
# and a reading with no row resolves to UNCLASSIFIED — which counts as FAIL.
# ---------------------------------------------------------------------------
#
# ⚠ TWO shipped-skeleton digests are PASS, and that is deliberate, not drift.
#   2.1.0 changed the INSTALL SURFACE ONLY (header install line + a --self-test that now asserts the
#   installed hook resolves to an existing executable — ADR-011 A6). The range scan, the fail-closed
#   path and the config search order are BYTE-IDENTICAL to 2.0.0, so a 2.0.0 install is
#   behaviourally correct and must not be demoted for being older. Verified by induced positive on
#   2.1.0 2026-08-24: synthetic non-allowlisted plant BLOCKED (exit 1, and absent from the remote
#   afterwards); known-good control PUSHED.
#
# ⛩ ADR-011 A7 (ACCEPTED 2026-08-24) prescribes the real fix for this whole function: classify by the
#   fix's MECHANISM (HOOK_CONTRACT_VERSION, or the `remote_sha|local_sha` range sites plus the
#   fail-closed arm) rather than by a digest table that must be hand-extended at every version bump.
#   The reference shape is already built and regression-proven next door, in census_wrapper_copy.sh:
#   "MECHANISM DECIDES THE CLASS. The digest only NAMES a known artifact."
#
#   ⛔ STILL NOT DONE HERE, and now for a DIFFERENT reason than before. A7 §5 leaves this instrument
#   digest-keyed ON PURPOSE: a closed digest table is a STRICTLY CONSERVATIVE implementation of a
#   role rule — it PASSes only what it has positively recognised, and A4 §2 catches everything else
#   as UNCLASSIFIED-therefore-FAIL. So this function sits BEHIND A7 without diverging from it. The
#   cost is one hand-added row per shipped version, VISIBLY. Porting the mechanism split here is a
#   behaviour change to the fleet's measuring instrument and is its own gated pass.
#
#   ⚠ THIS NOTE PREVIOUSLY READ "A6 (`proposed`, NOT ratified) ... acting on unratified text is the
#   exact error this desk apologised to Rosetta for on 2026-08-23." A6 ratified 2026-08-24, and the
#   note went on asserting a falsehood inside a shipped instrument — the same defect class this file
#   exists to measure, sitting in this file. Corrected at the A7 act. Rule taken: a note that names
#   its own blocker must also name the observable that clears it, or it becomes false the moment the
#   blocker lifts and nobody is watching that sentence.
adjudicate() {                       # <md5> -> verdict on stdout
  case "$1" in
    169eec6a86ce437374bc81cffad55b19) echo "PASS" ;;            # shipped skeleton v2.1.1 — COMMENTS ONLY vs 2.1.0; comment-stripped diff is EMPTY (run, not asserted), which is what licensed inheriting 2.1.0's induced positive. Digest of record: what/inventory/wrapper_contract_releases.md 0.2.1
    04e6a745d1871da0bf1df97cb079b308) echo "PASS" ;;            # shipped skeleton v2.1.0 (install surface repaired) — LIVE on WGS.aDNA, measured 2026-08-24
    a1288f7371afa187cb1cfd8b9810a669) echo "PASS" ;;            # shipped skeleton v2.0.0 — still correct, see note above
    89d4e2116ecb10ef0dd24fc5312294ed) echo "PASS_EQUIV" ;;      # Venus's script + the F-P7b-aw range repair (`--not --remotes=<name>`, never the unpatterned form). Row added 2026-09-07 as F-P7b-bc: the repair landed at 4f323a0 on 2026-09-06 and this table was NOT extended, so from that commit the census reported the REPAIRED hook as UNCLASSIFIED — including live on WGS.aDNA — and UNCLASSIFIED counts as FAIL (A4 §2(a)). ⛩ Fail-safe in direction, but the instrument was calling a fix a regression, and the dryrun arm that says so had been RED for a day with nobody reading it.
    f255e2a0221794a29b5e24a65fc52622) echo "PASS_EQUIV" ;;      # Venus's script: range-scan + fail-closed (PRE-F-P7b-aw; still correct for what it checks, superseded by the row above)
    280056d3d8b71d6e776e68555ffe46b4) echo "PASS_STRONGER" ;;   # class-L refuse-all (dataroom)
    216aaca254b97d69819562d506afca29) echo "FAIL_NOOP" ;;       # retired v1 no-op
    3f4bb7f6f25e00a0a3ce3ff42d02c9b5) echo "FAIL_LEGACY_SANITIZE" ;;  # different control, different guarantee
    a9399d70a31d576f0435e776cae4934e) echo "FAIL_FOREIGN_LFS" ;;      # git-lfs's own hook occupying the slot
    "")                               echo "FAIL_NONE" ;;       # no hook at all — the worst state
    *)                                echo "UNCLASSIFIED" ;;    # A4 §2(a): unknown is never a silent pass
  esac
}

# ---------------------------------------------------------------------------
# Exemptions (A4 §5) — dated, enumerated, and PRINTED WITH the coverage number.
# An exempt repo is still measured and still emitted; it is subtracted by name,
# never silently dropped. Bare `case` globs, matched against the workspace-relative path.
# ---------------------------------------------------------------------------
exemption_of() {                     # <rel-path> -> exemption class or "-"
  case "$1" in
    llama.cpp|*/llama.cpp)                    echo "upstream_external" ;;   # ggml-org; never our push
    PercySleep.aDNA/what/percysleep_code/*)   echo "third_party_client" ;;  # ADR-005 D7 / ADR-001
    RareArchive.aDNA/what/rare-archive)       echo "third_party_partner" ;;
    Archive.aDNA/_archive/wilhelm-foundation/*) echo "third_party_partner" ;;
    *)                                        echo "-" ;;
  esac
}

md5_of() {                           # portable md5 (macOS `md5 -q` / GNU `md5sum`)
  if command -v md5 >/dev/null 2>&1; then md5 -q "$1" 2>/dev/null
  else md5sum "$1" 2>/dev/null | awk '{print $1}'; fi
}

realpath_of() { python3 -c 'import os,sys;print(os.path.realpath(sys.argv[1]))' "$1" 2>/dev/null; }

# ---------------------------------------------------------------------------
# Enumerate (A4 §4). `-name .git` with NO type predicate: directories AND files,
# so linked worktrees and submodules are in-population. Root level and nested.
# ---------------------------------------------------------------------------
enumerate() {
  find "$ROOT" -maxdepth 6 -name .git -not -path '*/node_modules/*' 2>/dev/null \
    | sed 's|/\.git$||' | sort -u
}

[ "$FORMAT" = "tsv" ] && printf 'repo\thooks_source\thook_state\tdigest\tverdict\texec\tlink\tremote\texempt\n'

total=0; exempt_n=0
declare -a VERDICTS=()

while IFS= read -r repo; do
  [ -n "$repo" ] || continue
  rel="${repo#"$ROOT"/}"
  [ "$rel" = "$repo" ] && rel="$(basename "$repo")"

  exempt="$(exemption_of "$rel")"
  [ "$exempt" != "-" ] && exempt_n=$((exempt_n + 1))
  [ "$exempt" != "-" ] && [ "$INCLUDE_EXEMPT" -eq 0 ] && continue

  # --- A4 §3, step 1: core.hooksPath WINS. `.git/hooks` is irrelevant when it is set.
  hp="$(git -C "$repo" config --get core.hooksPath 2>/dev/null)"
  if [ -n "$hp" ]; then
    hooks_source="core.hooksPath"
    case "$hp" in
      /*) hook="$hp/pre-push" ;;
       *) hook="$repo/$hp/pre-push" ;;
    esac
  else
    # --- step 2: ask git, do not hand-build the path (handles .git-as-a-file worktrees).
    gp="$(git -C "$repo" rev-parse --git-path hooks/pre-push 2>/dev/null)"
    if [ -z "$gp" ]; then
      hooks_source="NOT_A_REPO"; hook=""
    else
      hooks_source="git-path"
      case "$gp" in /*) hook="$gp" ;; *) hook="$repo/$gp" ;; esac
    fi
  fi

  # --- step 3: realpath, then digest.
  # `-e` is FALSE for a dangling symlink, so `-L` must be tested too — otherwise a broken
  # link falls into the `absent` arm and is diagnosed "no hook installed" when in fact a hook
  # IS installed and is broken. Both are failures, but they have different repairs, and the
  # dangling-symlink branch below is unreachable without this. (Caught by fixture E.)
  if [ -n "$hook" ] && { [ -e "$hook" ] || [ -L "$hook" ]; }; then
    hook_state="present"
    link="copy"; [ -L "$hook" ] && link="symlink"
    exec_bit="x"; [ -x "$hook" ] || exec_bit="NOEXEC"
    rp="$(realpath_of "$hook")"
    digest="$(md5_of "$rp")"
    [ -n "$digest" ] || { digest=""; hook_state="dangling"; }
  else
    hook_state="absent"; link="-"; exec_bit="-"; digest=""
  fi

  # --- step 4: adjudicate.
  verdict="$(adjudicate "$digest")"

  # A hook git will not execute is not a control, whatever it contains (F-P7a-k).
  if [ "$hook_state" = "present" ] && [ "$exec_bit" = "NOEXEC" ]; then
    case "$verdict" in PASS*) verdict="FAIL_NOT_EXECUTABLE" ;; esac
  fi
  [ "$hook_state" = "dangling" ] && verdict="FAIL_DANGLING_SYMLINK"

  remote="$(git -C "$repo" remote -v 2>/dev/null | awk 'NR==1{print $2}')"
  [ -n "$remote" ] || remote="NONE"

  total=$((total + 1))
  VERDICTS+=("$verdict")

  [ "$FORMAT" = "tsv" ] && printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$rel" "$hooks_source" "$hook_state" "${digest:0:8}" "$verdict" "$exec_bit" "$link" "$remote" "$exempt"
done < <(enumerate)

if [ "$FORMAT" = "summary" ]; then
  printf 'measured_at: %s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  printf 'root:        %s\n' "$ROOT"
  printf 'repos:       %s (of which exempt: %s)\n\n' "$total" "$exempt_n"
  printf '%s\n' "${VERDICTS[@]}" | sort | uniq -c | sort -rn
fi

exit 0
