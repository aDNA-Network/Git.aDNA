#!/usr/bin/env bash
# census_wrapper_copy.sh — fleet WRAPPER-COPY census (Git.aDNA · ADR-011 A4/A6 · F-P7b-o)
#
# Measures, for every vault carrying a `how/federation/git/` wrapper, WHICH VERSION OF THE
# HOOK THAT VAULT WOULD RE-INSTALL FROM — and adjudicates it instead of asserting it.
#
# ⭐ WHY THIS IS A SEPARATE INSTRUMENT FROM census_secret_gate.sh, AND MUST STAY SEPARATE.
#
#   census_secret_gate.sh measures the hook that is INSTALLED — what git executes today.
#   This one measures the hook that is DISTRIBUTED — the file a consumer copies FROM.
#
#   They are different objects and they disagree. On 2026-08-24 the fleet read
#   0 dangling / 68 PASS_EQUIV INSTALLED, while 35 of 38 wrapper COPIES contained no
#   range-scan mechanism at all. Both readings are true. Folding them into one number
#   would hide exactly the gap that produced F-P7b-o.
#
#   ⛔ The generalisation, and the reason this file exists at all: WE HAD NO INSTRUMENT
#   FOR THIS SURFACE. On 2026-08-24 two vaults disputed the count — Git.aDNA said 43/44,
#   Home.aDNA said 45/69 — and NEITHER number was reproducible, because both came from
#   ad-hoc greps. A retirement condition in Home's §C registry was keyed to a number that
#   nothing measured. *A figure that governs a decision and has no instrument behind it is
#   a rumour with a decimal point.* The answer to a disputed count is a stated predicate,
#   not a third figure.
#
# READ-ONLY BY CONSTRUCTION: no writes, no network, no credentials, no `git config --set`,
# no `gitleaks` invocation, no foreign file touched. Safe against a live fleet mid-session.
# ⛔ It does NOT read any peer's registry and does NOT re-run any peer's probe. Their
#    instrument, their lane.
#
# ---------------------------------------------------------------------------
# DOCTRINE THIS INSTRUMENT IS BUILT UNDER — read before adding a class.
#
#   ADR-011 A6 (accepted 2026-08-24): CLASSIFY BY THE FIX'S MECHANISM, NEVER BY THE
#   DEFECT'S NAME. This is the whole design. The disputed "45 stale copies" was produced
#   by grepping the stale install line `ln -sf ../../git/hooks/...` — and that string is
#   present in the v1 no-op, in the P3 draft, AND in v2.0.0. It cannot separate them.
#   ⛔ NEVER add a class keyed on that string, or on any prose the artifact happens to carry.
#
#   The mechanism keys, in priority order:
#     1. HOOK_CONTRACT_VERSION — the version the artifact DECLARES.
#     2. the `remote_sha|local_sha` site count — the range-scan mechanism itself, i.e.
#        whether this file can scan a push range AT ALL. A hook with 0 sites is not a
#        secret gate in any version, whatever its header says.
#   ⭐ Both are read, and DISAGREEMENT IS ITS OWN CLASS (MECHANISM_MISSING). A version
#   token is a claim; the site count is the measurement. When a claim and a measurement
#   disagree the instrument must not silently prefer either.
#
#   ADR-011 A4 §2(a): an unknown reading is never a silent pass. UNCLASSIFIED counts as FAIL.
#   ADR-011 A4 §5: ABSENT and DECEPTIVE are different states with different repairs.
#     An absent copy is honest. A copy that looks like a gate and fails open is not.
#   ADR-011 A4 §6 / A5 §2: --meta builds one sabotage fixture per class, each REQUIRED to
#     FAIL, plus known-good controls REQUIRED to PASS. An instrument stuck at FAIL is as
#     useless as one stuck at PASS.
#   ADR-015 §D1.5b: every check states its failure condition at the point of definition.
#
#   ⚠ FILED AGAINST THIS FILE'S OWN AUTHOR, 2026-08-24. The first measurement of this
#   surface grepped `HOOK_CONTRACT_VERSION="` — with a quote. The artifact carries
#   `# HOOK_CONTRACT_VERSION=2.1.0`, unquoted. Every one of the 38 copies reported
#   NO_VERSION: a UNIFORM FALSE READING that erased the only real discriminator and would
#   have made 2.1.0 indistinguishable from the v1 no-op. It was caught by reading the
#   canonical file, not by the harness. Hence rule: A CLASS KEY IS NOT TRUSTED UNTIL A
#   CONTROL PROVES IT MATCHES SOMETHING. Every class below has such a control in --meta.
#
# Usage:
#   bash how/tests/census_wrapper_copy.sh [--root DIR] [--format tsv|summary] [--meta]
#
# Output (TSV): vault  copy_state  contract  range_sites  digest  class  verdict
# Exit: 0 always for a census run (an instrument reports, it does not block).
#       --meta exits non-zero if any fixture or control misbehaves.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd -P)"
# The CANONICAL distributed artifact — the file a consumer refreshes FROM. Derived from
# this script's own location, never hardcoded: an absolute path to one machine inside the
# portability vault's own instrument would be its own finding.
CANON="$HERE/../federation/git/hooks/pre-push.gitleaks.sh"
# The release ledger is the SINGLE place a contract version is recorded (ADR-004 A1 §1).
# Read, never hardcoded — a second copy of the version here would be a second source of truth.
LEDGER="$HERE/../../what/inventory/wrapper_contract_releases.md"

ROOT="${HOME}/aDNA"
FORMAT="tsv"
MODE="census"
VAULT=""

while [ $# -gt 0 ]; do
  case "$1" in
    --root)    ROOT="$2"; shift 2 ;;
    --format)  FORMAT="$2"; shift 2 ;;
    --meta)    MODE="meta"; shift ;;
    --vault)   MODE="vault"; VAULT="$2"; shift 2 ;;
    -h|--help) sed -n '2,80p' "$0"; exit 0 ;;
    *) printf 'unknown arg: %s\n' "$1" >&2; exit 2 ;;
  esac
done

md5_of() {                           # portable md5 (macOS `md5 -q` / GNU `md5sum`)
  if command -v md5 >/dev/null 2>&1; then md5 -q "$1" 2>/dev/null
  else md5sum "$1" 2>/dev/null | awk '{print $1}'; fi
}

# ---------------------------------------------------------------------------
# MECHANISM READERS. Each returns a measurement, never a verdict.
# ---------------------------------------------------------------------------

# fails_when: the file declares no contract version. Returns "" — which is a
# READING, not an error: v1 and the P3 draft predate the token entirely.
# ⛔ The pattern is UNQUOTED and anchored on `=`. See the author-error note above.
contract_of() {                      # <file> -> version string or ""
  grep -o 'HOOK_CONTRACT_VERSION=[0-9][0-9.]*' "$1" 2>/dev/null | head -1 | cut -d= -f2
}

# fails_when: the file cannot scan a push range. 0 sites means the file is not a
# secret gate in any version — this is the measurement that outranks the header.
#
# ⛔ DO NOT write this as `grep -c ... || echo 0`. That shipped in the first cut of this
# file and it emitted TWO lines on a zero match — grep -c PRINTS "0" and then EXITS 1, so
# the `||` arm fired and appended a second "0". Every `[ "$sites" -eq 0 ]` then died with
# "integer expected", and because a dead comparison falls through to the default arm,
# THREE SABOTAGE FIXTURES REPORTED THE WRONG CLASS AND ONE REPORTED `ok` WHILE CRASHING.
# ⭐ That is F-P7b-i's exact shape recurring inside a NEW instrument — a fixture that wants
# NOTPASS cannot tell a correct refusal from a crashed one — and it was caught here only
# because the controls (E/F) passed while the sabotage cases did not. Caught by --meta on
# its first run, which is the entire argument for A4 §6.
range_sites_of() {                   # <file> -> integer
  local n; n="$(grep -c 'remote_sha\|local_sha' "$1" 2>/dev/null)"
  case "$n" in ''|*[!0-9]*) echo 0 ;; *) echo "$n" ;; esac
}

# fails_when: the hook exits 0 on a missing scanner, i.e. an absent tool silently
# removes the layer (ADR-011 A2 §2 forbids exactly this). DECEPTIVE, not absent:
# the file is present, executable, and looks installed.
#
# ⛔ THE WINDOW MUST CLOSE. The first cut opened a window at the missing-tool marker and
# then matched ANY later `exit 0` — which in a real hook includes the scanner's own
# SUCCESS exit (`if gitleaks detect; then exit 0; ...`). Every hook that scans and passes
# cleanly was therefore reported fail-open, including fail-CLOSED ones. Caught by fixture
# B (the same skeleton, hardened), which exists precisely to prove this reader
# discriminates instead of riding along with range_sites.
# ⭐ Third predicate defect in this one file, all three found by --meta and none by
# reading the code. The window closes at `fi`/`}`, and an inline `exit 1` on the marker
# line is a fail-CLOSED guard and closes it immediately.
fails_open_p() {                     # <file> -> yes|no
  awk '
    /gitleaks not installed|command -v gitleaks/ {
      if ($0 ~ /exit 0/) { print "yes"; exit }     # inline fail-open guard
      if ($0 ~ /exit 1/) { w = 0; next }           # inline fail-CLOSED guard
      w = 1; next
    }
    w && /exit 0/            { print "yes"; exit }
    w && /^[[:space:]]*(fi|\})/ { w = 0 }
  ' "$1" 2>/dev/null | head -1 | grep -q yes && echo yes || echo no
}

# fails_when: the file never invokes the scanner at all, or never blocks on a finding.
#
# ⛔⛔ THIS READER EXISTS BECAUSE THE FIRST LIVE RUN OF THIS CENSUS OVERSTATED THE DEFECT,
# AND THE OVERSTATEMENT RAN IN THE ALARMING DIRECTION. With only a range-site reader, 35
# copies classified as `NO_MECHANISM` — a label that reads "these files do nothing". Read
# at the object, `216aaca2…` (33 of the 35) DOES invoke gitleaks and DOES exit 1 on a
# finding. It is a working scanner. What it is not is a PUSH-RANGE scanner, and it exits 0
# when gitleaks is missing.
# ⭐ Those are two specific, repairable defects — not "no gate". A memo telling two peers
# that 35 vaults are ungated would have been false, and false in the direction that
# produces alarm rather than accuracy. Caught before publication, which is the only reason
# it counts for anything: this is A4 §4's self-correction, on a second instrument.
# ⇒ Rule: A CLASS NAME IS A CLAIM. `NO_MECHANISM` claimed more than `range_sites == 0`
#   measures, and a name that outruns its measurement is the predicate defect wearing a
#   label instead of a grep.
scans_p() {                          # <file> -> yes|no
  grep -q 'gitleaks git\|gitleaks detect\|gitleaks dir' "$1" 2>/dev/null && echo yes || echo no
}

# ---------------------------------------------------------------------------
# Adjudication. MECHANISM DECIDES THE CLASS. The digest only NAMES a known
# artifact, in a separate column, and never contributes to the verdict.
#
# ⛔⛔ THIS SEPARATION IS THE SECOND DEFECT --meta CAUGHT IN THIS FILE, and it is a
# better finding than the first. The initial classify() keyed its failing classes on
# DIGESTS (`216aaca2… -> V1_NOOP`, `c9e3be43… -> P3_DRAFT_FAIL_OPEN`) — i.e. it
# classified by the artifact's IDENTITY rather than by its MECHANISM, which is
# precisely what ADR-011 A6 forbids and what this instrument was written to enforce.
# ⭐ It was exposed because the sabotage fixtures reproduce the SHAPE of those artifacts
# and not their bytes: a shape-faithful fixture could not match an identity-keyed table,
# so A and B failed. A digest table would also have had to be hand-extended at every
# version bump — A6's own stated complaint against census_secret_gate.sh's table.
#
# ⇒ Rule, taken here and paid for here: IF A FIXTURE THAT REPRODUCES THE DEFECT CANNOT
#   BE CLASSIFIED BY THE INSTRUMENT, THE INSTRUMENT IS KEYED ON THE WRONG THING.
# ---------------------------------------------------------------------------
classify() {                         # <contract> <range_sites> <failsopen> <scans> -> class
  local ver="$1" sites="$2" fo="$3" sc="$4"

  # A declared version with no range scan is a claim contradicted by measurement.
  # Neither a pass nor a known-bad artifact: it is a file lying about itself.
  if [ -n "$ver" ] && [ "$sites" -eq 0 ]; then echo "MECHANISM_MISSING"; return; fi

  if [ -n "$ver" ]; then
    case "$ver" in
      2.1.0) echo "V2_1_0" ;;
      2.0.0) echo "V2_0_0" ;;
      *)     echo "UNCLASSIFIED_VERSION" ;;           # a real range scan, an unknown contract
    esac
    return
  fi

  # No contract token. The measurements, not the identity, decide — and the class name
  # says exactly what was measured and nothing more.
  if [ "$sites" -eq 0 ]; then
    if [ "$sc" = "no" ]; then echo "NO_SCAN"; return; fi   # never invokes the scanner
    # Scans, and blocks on a finding — but not over the PUSH RANGE, and (usually) exits 0
    # when the scanner is missing. A real but under-scoped control, not an absent one.
    [ "$fo" = "yes" ] && echo "P3_SKELETON_FAIL_OPEN" || echo "P3_SKELETON_NO_RANGE"
    return
  fi

  echo "UNVERSIONED_RANGE_SCAN"      # scans a range, declares no contract version
}

# Naming only. A known artifact gets a human-readable label so a reader can tell 33
# copies of one thing from 33 different things — but an unrecognised digest changes
# NOTHING about the verdict, so this table can never become load-bearing by accident.
artifact_of() {                      # <digest> -> label or "-"
  case "$1" in
    216aaca254b97d69819562d506afca29) echo "v1_noop" ;;      # retired v1 no-op
    c9e3be43f42cb9bb6e193192b82d20bf) echo "p3_draft" ;;     # P3 skeleton, status: draft
    a1288f7371afa187cb1cfd8b9810a669) echo "shipped_2.0.0" ;;
    04e6a745d1871da0bf1df97cb079b308) echo "shipped_2.1.0" ;;
    "")                               echo "-" ;;
    *)                                echo "unrecognised" ;;
  esac
}

# ⛔ verdict is SEPARATE from class, deliberately. The class says what the artifact IS;
# the verdict says whether re-installing from it would give the consumer a working gate.
# Collapsing the two is how "stale documentation" and "not a gate at all" got conflated.
verdict_of() {                       # <class> -> PASS|FAIL_*
  case "$1" in
    V2_1_0)                  echo "PASS" ;;
    V2_0_0)                  echo "PASS" ;;   # behaviourally correct; 2.1.0 changed the INSTALL SURFACE only
    # ⚠ TWO distinct defects, and the verdict names BOTH rather than collapsing them:
    #   under-scoped (no push-range scan) AND fail-open (missing tool => exit 0).
    #   It DOES scan and DOES block on a finding. Not "ungated" — do not report it as such.
    P3_SKELETON_FAIL_OPEN)   echo "FAIL_NO_RANGE_AND_OPEN" ;;
    P3_SKELETON_NO_RANGE)    echo "FAIL_NO_RANGE" ;;
    NO_SCAN)                 echo "FAIL_NOT_A_GATE" ;;   # genuinely does nothing
    MECHANISM_MISSING)       echo "FAIL_MECHANISM_MISSING" ;;
    UNVERSIONED_RANGE_SCAN)  echo "FAIL_UNCLASSIFIED" ;;
    COPY_ABSENT)             echo "FAIL_NONE" ;;   # A4 §5: ABSENT, and honest about it
    *)                       echo "FAIL_UNCLASSIFIED" ;;  # A4 §2(a)
  esac
}

# ---------------------------------------------------------------------------
# Enumerate. Population = wrapper DIRS, not copies. The two numbers are reported
# separately and NEVER as a ratio: a wrapper with no hook copy is the denominator
# defect that produced this whole disagreement, and a ratio would hide it.
# ---------------------------------------------------------------------------
enumerate_wrappers() {
  find "$ROOT" -type d -path '*/how/federation/git' -not -path '*/node_modules/*' 2>/dev/null | sort -u
}

run_census() {
  [ -d "$ROOT" ] || { printf 'root not found: %s\n' "$ROOT" >&2; exit 2; }
  [ "$FORMAT" = "tsv" ] && printf 'vault\tcopy_state\tcontract\trange_sites\tscans\tdigest\tartifact\tclass\tverdict\n'

  local wrappers=0 copies=0 absent=0
  declare -a CLASSES=()

  while IFS= read -r wdir; do
    [ -n "$wdir" ] || continue
    wrappers=$((wrappers + 1))
    local vault rel hook
    rel="${wdir#"$ROOT"/}"; vault="${rel%%/how/federation/git}"
    hook="$wdir/hooks/pre-push.gitleaks.sh"

    local copy_state ver sites dg fo sc class art
    if [ -f "$hook" ]; then
      copies=$((copies + 1)); copy_state="present"
      ver="$(contract_of "$hook")"
      sites="$(range_sites_of "$hook")"
      dg="$(md5_of "$hook")"
      fo="$(fails_open_p "$hook")"
      sc="$(scans_p "$hook")"
      class="$(classify "$ver" "$sites" "$fo" "$sc")"
    else
      absent=$((absent + 1)); copy_state="absent"
      ver=""; sites=0; dg=""; fo="no"; sc="no"; class="COPY_ABSENT"
    fi
    art="$(artifact_of "$dg")"

    local verdict; verdict="$(verdict_of "$class")"
    CLASSES+=("$class")

    [ "$FORMAT" = "tsv" ] && printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
      "$vault" "$copy_state" "${ver:--}" "$sites" "$sc" "${dg:0:8}" "$art" "$class" "$verdict"
  done < <(enumerate_wrappers)

  if [ "$FORMAT" = "summary" ]; then
    printf 'measured_at:   %s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
    printf 'root:          %s\n' "$ROOT"
    printf 'wrapper_dirs:  %s\n' "$wrappers"
    printf 'hook_copies:   %s\n' "$copies"
    printf 'copies_absent: %s   <- reported as its own number, never folded into a ratio\n\n' "$absent"
    printf '%s\n' "${CLASSES[@]}" | sort | uniq -c | sort -rn
  fi
}

# ===========================================================================
# --meta : the meta-control (ADR-011 A4 §6 / A5 §2).
# Fixtures live in temp dirs and are removed. No vault is read or touched.
# ===========================================================================
STALE_INSTALL_LINE='#   ln -sf ../../git/hooks/pre-push.gitleaks.sh .git/hooks/pre-push'

mk() {                               # <body-kind> -> path to a fixture hook file
  local kind="$1" f; f="$(mktemp)"
  case "$kind" in
    # ⭐ SHAPE-FAITHFUL to the real `216aaca2…` (33 of 38 live copies): it DOES scan and
    # DOES block on a finding; what it lacks is a push-range scan, and it exits 0 when
    # gitleaks is missing. A fixture that merely `exit 0`-ed would be a fixture of a file
    # that does not exist, and would have let the over-broad `NO_MECHANISM` class pass.
    p3skel)      { echo '#!/usr/bin/env bash'; echo "$STALE_INSTALL_LINE"
                   echo 'if ! command -v gitleaks >/dev/null 2>&1; then'
                   echo '  echo "pre-push: WARNING — gitleaks not installed; secret scan SKIPPED." >&2'
                   echo '  exit 0'; echo 'fi'
                   echo 'if gitleaks git --pre-commit --redact; then exit 0; else exit 1; fi'; } > "$f" ;;
    # the same skeleton HARDENED against a missing tool, but still not range-scanning —
    # proves fails_open_p discriminates rather than riding along with range_sites.
    p3closed)    { echo '#!/usr/bin/env bash'; echo "$STALE_INSTALL_LINE"
                   echo 'command -v gitleaks >/dev/null 2>&1 || { echo missing >&2; exit 1; }'
                   echo 'if gitleaks detect --redact; then exit 0; else exit 1; fi'; } > "$f" ;;
    v210)        { echo '#!/usr/bin/env bash'; echo '# HOOK_CONTRACT_VERSION=2.1.0'
                   echo "$STALE_INSTALL_LINE"
                   echo 'while read -r local_ref local_sha remote_ref remote_sha; do :; done'; } > "$f" ;;
    v200)        { echo '#!/usr/bin/env bash'; echo '# HOOK_CONTRACT_VERSION=2.0.0'
                   echo 'while read -r local_ref local_sha remote_ref remote_sha; do :; done'; } > "$f" ;;
    liar)        { echo '#!/usr/bin/env bash'; echo '# HOOK_CONTRACT_VERSION=2.1.0'
                   echo '# no range scan anywhere in this file'; } > "$f" ;;
    alien)       { echo '#!/usr/bin/env bash'; echo '# something nobody has ever shipped'; } > "$f" ;;
  esac
  echo "$f"
}

# adjudicates on the classifier's OWN RETURNED CLASS, never on a counter.
# ⛔ F-P7b-d: $( ) runs in a subshell and discards counter increments, so a
# counter-based verdict is always the same value and every fixture reports ok
# for a reason unrelated to the check. That defect has shipped in this vault twice.
meta_expect() {                      # <label> <want-class> <file>
  local label="$1" want="$2" f="$3"
  local ver sites fo sc got
  ver="$(contract_of "$f")"; sites="$(range_sites_of "$f")"
  fo="$(fails_open_p "$f")"; sc="$(scans_p "$f")"
  got="$(classify "$ver" "$sites" "$fo" "$sc")"
  if [ "$got" = "$want" ]; then printf '  ok    %-40s (%s)\n' "$label" "$got"; return 0; fi
  printf '  FAIL  %-40s wanted %s got %s\n' "$label" "$want" "$got"; return 1
}

run_meta() {
  printf '\nmeta-control — every class must be demonstrated able to FAIL (ADR-011 A4 §6)\n\n'
  local bad=0 f

  printf '  -- sabotage: each REQUIRED to classify as a failing class --\n'

  # ⭐⭐ FIXTURE A — THE ONE THIS INSTRUMENT EXISTS FOR.
  # A v1 no-op body carrying the STALE INSTALL LINE. This is not hypothetical: it is
  # 33 of the fleet's 38 wrapper copies, verbatim in shape. A string-predicate greps
  # that line, calls this "a stale 2.x copy", and folds it in with the 2 genuinely
  # stale ones — which is precisely how "45" was produced. The mechanism classifier
  # must call it V1_NOOP: 0 range sites, so it is not a gate in any version.
  f="$(mk p3skel)";  meta_expect "A conflation: P3 skeleton + stale line" P3_SKELETON_FAIL_OPEN "$f" || bad=1
  rm -f "$f"

  # FIXTURE B — the SAME skeleton, hardened against a missing tool but still not
  # range-scanning. ⭐ Required to separate from A: if fails_open_p were broken or were
  # merely riding along with range_sites, A and B would collapse into one class and the
  # census could not tell "under-scoped" from "under-scoped AND fail-open" — two defects
  # with different urgencies and different repairs.
  f="$(mk p3closed)"; meta_expect "B same skeleton, fail-CLOSED" P3_SKELETON_NO_RANGE "$f" || bad=1
  rm -f "$f"

  # FIXTURE C — a version CLAIM with no MECHANISM. The header says 2.1.0; the file
  # cannot scan a range. Neither a pass nor a known-bad artifact: it contradicts itself,
  # and an instrument that silently believed the header would certify it.
  f="$(mk liar)";    meta_expect "C version claim, no mechanism" MECHANISM_MISSING "$f" || bad=1
  rm -f "$f"

  # FIXTURE D — a file that never invokes the scanner at all. THE ONLY class entitled to
  # be called "not a gate". A4 §2(a): an unrecognised digest must not change the verdict
  # (artifact_of labels it `unrecognised`; the class still comes from the measurement).
  f="$(mk alien)";   meta_expect "D never invokes the scanner" NO_SCAN "$f" || bad=1
  rm -f "$f"

  printf '\n  -- controls: each REQUIRED to classify as a passing class --\n'
  # ⛔ Without these an instrument stuck at "everything fails" would report all-green above.
  # These are also what prove each class KEY MATCHES SOMETHING — the rule taken from the
  # unquoted-grep error that made all 38 copies read NO_VERSION.
  f="$(mk v210)";    meta_expect "E v2.1.0 (with stale line present)" V2_1_0 "$f" || bad=1
  rm -f "$f"
  f="$(mk v200)";    meta_expect "F v2.0.0" V2_0_0 "$f" || bad=1
  rm -f "$f"

  printf '\n  -- discrimination: the string predicate vs the mechanism predicate --\n'
  # ⭐ The green above proves nothing until the OLD predicate is shown to be red.
  # Both a v1 no-op and a real v2.1.0 carry the stale install line. A string predicate
  # cannot separate them; the mechanism predicate must.
  local a b sa sb
  a="$(mk p3skel)"; b="$(mk v210)"
  sa=$(grep -c 'ln -sf' "$a"); sb=$(grep -c 'ln -sf' "$b")
  if [ "$sa" -eq 1 ] && [ "$sb" -eq 1 ]; then
    printf '  ok    %-40s (string predicate: %s vs %s — CANNOT discriminate)\n' \
      "G stale-line grep is non-discriminating" "$sa" "$sb"
  else
    printf '  FAIL  %-40s expected both to carry the line (%s, %s)\n' \
      "G stale-line grep is non-discriminating" "$sa" "$sb"; bad=1
  fi
  sa="$(range_sites_of "$a")"; sb="$(range_sites_of "$b")"
  if [ "$sa" -eq 0 ] && [ "$sb" -gt 0 ]; then
    printf '  ok    %-40s (mechanism: %s vs %s — DISCRIMINATES)\n' \
      "H mechanism predicate discriminates" "$sa" "$sb"
  else
    printf '  FAIL  %-40s expected 0 vs >0 (%s, %s)\n' \
      "H mechanism predicate discriminates" "$sa" "$sb"; bad=1
  fi
  rm -f "$a" "$b"

  # META-CONTROL ON THE FIXTURES THEMSELVES: fixture A must GENUINELY carry the stale
  # line, or it passes check G for the wrong reason. A fixture that cannot reproduce the
  # defect proves nothing about the instrument that catches it.
  f="$(mk p3skel)"
  if grep -q 'ln -sf' "$f" && [ "$(range_sites_of "$f")" -eq 0 ]; then
    printf '  ok    %-40s (fixture is genuinely the conflating shape)\n' "I meta-control on fixture A"
  else
    printf '  FAIL  %-40s fixture A is not the shape it claims\n' "I meta-control on fixture A"; bad=1
  fi
  rm -f "$f"

  printf '\n'
  if [ "$bad" -eq 0 ]; then printf 'meta-control: PASS — every class fails when it should, every control passes.\n'
  else printf 'meta-control: FAIL\n'; fi
  return "$bad"
}

# ===========================================================================
# --vault : SINGLE-VAULT mode (ADR-004 A1 §4 — the verifier a consumer runs)
#
# ⭐ THIS ANSWERS A DIFFERENT QUESTION FROM THE CENSUS VERDICT, AND THE TWO ARE
#   REPORTED AS SEPARATE COLUMNS RATHER THAN COLLAPSED INTO ONE.
#
#     verdict        : is this gate BEHAVIOURALLY SOUND?   (ADR-011 A4 adjudication)
#     refresh_needed : is this copy at the CURRENT CONTRACT? (ADR-004 A1)
#
#   A v2.0.0 copy is `PASS` on the first and `yes` on the second — behaviourally
#   correct, and still not the artifact a consumer should be re-installing from.
#   ⛔ Collapsing them into one boolean is EXACTLY the conflation F-P7b-o was filed
#   for: two published counts, produced by one predicate that could not separate
#   the two populations it was being asked about.
#
# ⭐ The expected contract is MEASURED FROM THE CANONICAL ARTIFACT ($CANON), never
#   hardcoded. A literal "2.1.0" in this file would be a second source of truth that
#   rots the moment the hook is bumped — a version string is an identity, and A6 is
#   the rule against keying on identities.
#
# Exit codes (the OUTPUT is the measurement; the code is a proxy for scripts):
#   0 at current contract · 1 refresh needed · 2 UNCLASSIFIED (BLOCK, A4 §2(a))
#   3 no wrapper dir at all — structurally DIFFERENT from COPY_ABSENT, see below
# ===========================================================================
run_vault() {
  local v="$VAULT"
  [ -n "$v" ] || { printf 'usage: %s --vault <path-to-vault>\n' "$0" >&2; exit 2; }
  [ -d "$v" ] || { printf 'vault not found: %s\n' "$v" >&2; exit 2; }
  v="$(cd "$v" && pwd -P)"

  local wdir="$v/how/federation/git"
  local hook="$wdir/hooks/pre-push.gitleaks.sh"

  # ⛔ NO WRAPPER DIR is NOT `COPY_ABSENT`. COPY_ABSENT means "this vault federates
  #   the git contract and holds no hook copy". No dir at all means it does not
  #   federate the contract — a non-consumer, not a defect. Reporting the second as
  #   the first would inflate the refresh population with vaults that owe nothing.
  if [ ! -d "$wdir" ]; then
    printf 'vault:            %s\n' "$v"
    printf 'wrapper_dir:      ABSENT\n'
    printf 'class:            NOT_A_CONSUMER\n'
    printf 'refresh_needed:   n/a  <- no git/ wrapper; this vault does not federate the contract\n'
    return 3
  fi

  # Expected values, MEASURED from the canonical artifact.
  local want_ver want_dg
  if [ -f "$CANON" ]; then
    want_ver="$(contract_of "$CANON")"; want_dg="$(md5_of "$CANON")"
  else
    printf 'canonical artifact not readable: %s\n' "$CANON" >&2; return 2
  fi

  local copy_state ver sites dg fo sc class art verdict
  if [ -f "$hook" ]; then
    copy_state="present"
    ver="$(contract_of "$hook")"
    sites="$(range_sites_of "$hook")"
    dg="$(md5_of "$hook")"
    fo="$(fails_open_p "$hook")"
    sc="$(scans_p "$hook")"
    class="$(classify "$ver" "$sites" "$fo" "$sc")"
  else
    copy_state="absent"; ver=""; sites=0; dg=""; fo="no"; sc="no"; class="COPY_ABSENT"
  fi
  art="$(artifact_of "$dg")"
  verdict="$(verdict_of "$class")"

  local refresh rc
  case "$class" in
    UNCLASSIFIED*|*UNCLASSIFIED) refresh="BLOCK"; rc=2 ;;   # A4 §2(a): never a silent pass
    COPY_ABSENT)                 refresh="yes (Path C — a DIFFERENT repair from a stale copy)"; rc=1 ;;
    *)
      if [ -n "$ver" ] && [ "$ver" = "$want_ver" ] && [ "$dg" = "$want_dg" ]; then
        refresh="no"; rc=0
      else
        refresh="yes"; rc=1
      fi ;;
  esac

  printf 'vault:            %s\n' "$v"
  printf 'wrapper_dir:      present\n'
  printf 'copy_state:       %s\n' "$copy_state"
  printf 'contract:         %s   (canonical: %s)\n' "${ver:--}" "${want_ver:--}"
  printf 'range_sites:      %s\n' "$sites"
  printf 'scans:            %s\n' "$sc"
  printf 'digest:           %s   (canonical: %s)\n' "${dg:0:8}" "${want_dg:0:8}"
  printf 'artifact:         %s\n' "$art"
  # -------------------------------------------------------------------------
  # PIN vs OBJECT — the bookkeeping half (ADR-004 A1 §4, Step 4 of the refresh skill).
  #
  # ⭐ THE TWO DIRECTIONS ARE NOT THE SAME DEFECT, and reporting one boolean would
  #   hide the dangerous one:
  #     PIN_LAGS       the file was refreshed, the record was not. Under-claims. Safe.
  #     PIN_OVERSTATES ⛔ the RECORD says current and the FILE is not. A vault that
  #                    reads compliant on paper while holding a fail-open gate — the
  #                    exact shape of "reads installed, behaves ungated", moved up one
  #                    layer from the hook to the ledger entry that describes it.
  #
  # ⛔ An ABSENT pin is a THIRD state and is reported as `none`, never as a mismatch:
  #   Git.aDNA's own wrapper carries no `federation_ref` by design (it IS the source),
  #   and an absent field must not be silently read as a wrong value.
  # -------------------------------------------------------------------------
  local cur pin drift canon_wdir
  cur="$(grep -m1 '^current_contract_version:' "$LEDGER" 2>/dev/null | tr -d '"' | awk '{print $2}')"

  # ⛔ THE SOURCE VAULT HAS NO PIN, AND ITS WRAPPER CONTAINS THE CONSUMER TEMPLATE.
  #   A naive `grep federation_ref:` matches that TEMPLATE and reports the contract's own
  #   owner as out of date — a FALSE RED on the one vault that is current by definition.
  #   ⭐ "Inside a fenced block" does NOT discriminate: consumers fence their LIVE
  #   declarations too (verified across aDNA/Jupyter/aDNALabs — all `^```yaml` at line 15).
  #   The reliable discriminator is MECHANISM, not text: the source vault is the one whose
  #   wrapper dir IS the canonical artifact this script ships from.
  canon_wdir="$(cd "$(dirname "$CANON")/.." 2>/dev/null && pwd -P)"
  if [ -n "$canon_wdir" ] && [ "$wdir" = "$canon_wdir" ]; then
    pin="none"
  elif grep -q 'federation_ref:' "$wdir/CLAUDE.md" 2>/dev/null; then
    pin="$(sed -n '/federation_ref:/,/^[a-z_]*:/p' "$wdir/CLAUDE.md" 2>/dev/null \
           | grep -m1 '^ *version:' | tr -d '"' | awk '{print $2}')"
    [ -n "$pin" ] || pin="unset"
  else
    pin="none"
  fi

  case "$pin" in
    none|unset) drift="n/a  (no federation_ref pin — source vault, or an unpinned wrapper)" ;;
    *)
      if [ "$pin" = "$cur" ] && [ "$refresh" != "no" ]; then
        drift="⛔ PIN_OVERSTATES — record says ${pin}, object is NOT current"; rc=1
      elif [ "$pin" != "$cur" ] && [ "$refresh" = "no" ]; then
        drift="PIN_LAGS — object is current, record still says ${pin}"; rc=1
      elif [ "$pin" = "$cur" ]; then
        drift="agree (${pin})"
      else
        drift="both stale (pin ${pin}, current ${cur})"
      fi ;;
  esac

  printf 'class:            %s\n' "$class"
  printf 'verdict:          %s        <- behavioural soundness (ADR-011 A4)\n' "$verdict"
  printf 'refresh_needed:   %s        <- contract currency (ADR-004 A1). A SEPARATE question.\n' "$refresh"
  printf 'pin_version:      %s   (current contract: %s)\n' "$pin" "${cur:--}"
  printf 'pin_vs_object:    %s\n' "$drift"
  return "$rc"
}

case "$MODE" in
  meta)  run_meta;   exit $? ;;
  vault) run_vault;  exit $? ;;
  *)     run_census; exit 0 ;;
esac
