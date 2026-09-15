#!/usr/bin/env bash
# pre-push-sanitize.sh — vault publish sanitization hook
#
# Source (canonical post-M03 flatten): how/standard/hooks/pre-push-sanitize.sh
# Source (template-shipped reference): .adna/how/standard/hooks/pre-push-sanitize.sh
# Installed by: skill_deploy (copies to .git/hooks/pre-push)
# Used by: skill_vault_publish (runs automatically on git push)
# Spec: aDNA.aDNA/how/campaigns/campaign_adna_v2_infrastructure/missions/artifacts/pre_push_hook_spec.md
#   ⛔ THE VAULT PREFIX IS LOAD-BEARING AND WAS MISSING UNTIL 2026-09-15. The path was written
#   vault-relative, so it resolved only from `aDNA.aDNA/` and named NOTHING from this tree — the
#   tree of the file that cites it. Measured: `find . -name pre_push_hook_spec.md` → 0 here, 1 in
#   `aDNA.aDNA`; `git log --all --diff-filter=A` → it has never existed at that path in this repo.
#   ⛩ A citation that reads as authority and resolves to nothing is the same class as R3's ✅ row
#   below it — and it is the path defect Rosetta named against her own memo on 2026-09-08.
#
# LAYER_CONTRACT_VERSION=4.4.0
#
# ⚠ DECLARED DRIFT — this copy is AHEAD of .adna/ and that is deliberate, not an accident.
#   At 4.0.1 this file was byte-identical to .adna/how/standard/hooks/pre-push-sanitize.sh
#   (verified 2026-08-26). 4.1.0 added R8 (content deny list); 4.2.0 SCOPES R8 to the lines a
#   push would ADD (see R8's own header); 4.3.0 REMOVES R5/R6's `*.md` extension test and
#   REPLACES the single success count with PER-RULE coverage; 4.4.0 GENERATES the FAIL-rule
#   fixtures at test time (see below). All are authored HERE, because Git.aDNA owns the git-ops
#   standard and Standing Rule 1 forbids editing .adna/ directly. The drift is stated rather
#   than silent so a census can see it. It closes when Rosetta (aDNA.aDNA) ships these via
#   skill_template_release.
#
#   ⛩ THE 4.3.0 GAP IS CLOSED, AND THIS PARAGRAPH WAS THE STALE ROW IT WARNS ABOUT.
#   Until 2026-09-15 the text here read "THE GAP IS THREE VERSIONS, NOT ONE … Re-verified here
#   at the object: `.adna/` = 4.0.1", from Rosetta's 2026-09-07 correction. **She shipped 4.3.0
#   fleet-wide as governance v8.10 on 2026-09-11.** Re-measured at the object 2026-09-15:
#   `.adna/` = **4.3.0**, and it also now carries the R5 fixture pair this file's own repair
#   needed. ⇒ the standing gap is **one** version (4.4.0), not three.
#   ⭐⭐ The paragraph that says *"A drift statement that still described 4.1.0 would be the
#   exact class this vault keeps filing: a stale row that reads as current"* had become exactly
#   that, eight days after saying so. ⛩ *A sentence that warns against staleness is not thereby
#   exempt from it — only re-measuring is.* Not smoothed: recorded, because the stale version
#   was also asserted in STATE.md and in the Next Session Prompt, i.e. in every place a cold
#   start would read it.
#
#   ⭐ AND THE SEAM SHE SAID DID NOT EXIST IS THE ONE 4.3.0 ADDS. Her §3 measured `.adna/`'s
#   copy as defining ZERO functions, and drew the structural conclusion: the self-test and the
#   push-time rules *cannot* share an implementation, because there is nothing to share — so
#   R7's non-exercise "is not an oversight in the self-test; it is a consequence of the file
#   having no seam." Re-verified: `.adna/` 4.0.1 has 0 function definitions. `sanitize_is_text`
#   and `sanitize_frontmatter` below are the first shared predicates in this file's history,
#   and R5/R6's two sites are the first rules to use one. ⇒ Her diagnosis and this repair were
#   written hours apart, in different vaults, without either knowing.
#   ⛔ 4.2.0 AND 4.3.0 ARE SEMANTIC CHANGES, NOT ADDITIONS, so this paragraph changes with
#   them. A drift statement that still described 4.1.0 would be the exact class this vault
#   keeps filing: a stale row that reads as current.
#   Upstream basis (4.2.0): Git.aDNA ADR-016 D5 (RATIFIED 2026-08-27 at rev 3) + D4
#   (fix-forward), which 4.2.0 brings the instrument into line with — the whole-file scan
#   EXCEEDED D4.
#
# ---------------------------------------------------------------------------
# 4.4.0 — THE FIXTURE SET FROZE ON THE DAY THE GATE STARTED WORKING.
#
#   ⛔ INBOUND SYMPTOM, SELF-FOUND CAUSE. Rosetta (aDNA.aDNA) measured it in our tree
#   2026-09-08: nothing in the fixture set exercises the case 4.3.0 exists to fix, so
#   `--self-test` prints the same thing before and after that repair — it shipped fleet-wide at
#   v8.10 with NO regression guard. Beside it she found worse: `test_fixtures/README.md` marked
#   **R3 `✅`** against `dirty/config/.env`, a file that has never existed in ANY tree and is
#   matched by our own `.gitignore:41`. ⇒ no clone could ever exercise R3, and the row said it
#   could. *An honestly empty row invites the question; a wrongly full one closes it.*
#
#   ⭐⭐ THE CAUSE IS IN NEITHER MEMO, AND IT IS THIS GATE. Measured 2026-09-15:
#     · `pushed_files` = `git diff --name-only remote..local` — the files changed in the push.
#     · R3 iterates it by `basename`, UNFILTERED ⇒ a newly-added `dirty/config/.env` lands in
#       that list, matches `.env`, enters `fail_findings`, and BLOCKS the push.
#     · R5 is likewise FAIL ⇒ the `confidential: true` fixtures trip it identically.
#   Every tracked dirty fixture dates to **2026-06-19**, this vault's genesis day. The gate went
#   live **2026-09-02** (F-P7b-ag, "the gate that never ran"). Nothing has entered the set since.
#   ⇒ ⛩ ***THE FIXTURE SET'S COVERAGE IS SHAPED BY WHICH RULES ARE FAIL AND WHICH ARE WARN, NOT
#   BY WHAT ANYONE DECIDED TO COVER.*** R6 — the only WARN rule among the dirty fixtures — is
#   the only one a live gate would pass today. R5, R7 and R3 are all FAIL rules whose honest
#   fixture the gate refuses. **A fixture for a FAIL rule is indistinguishable, to the rule,
#   from the thing the rule exists to stop.**
#
#   ⛩ OPERATOR RULING 2026-09-15 — GENERATE, do not exempt. The FAIL-rule fixtures are
#   materialized into a temp tree at self-test time and torn down after. Nothing is tracked, so
#   nothing reaches `pushed_files`, so the gate never sees them — and **no exemption of any kind
#   is created.** A clone can genuinely GENERATE R3's fixture, which is what the `✅` row was
#   implicitly promising all along.
#
#   ⛔ RULED OUT, recorded so they are not re-proposed:
#     (a) rename the fixture — rejected at the 2026-09-09 template-release gate (R3 matches
#         FILENAMES, so a renamed fixture stops exercising the rule), and independently useless
#         for R5, which is content-keyed.
#     (b) a path allowlist for `test_fixtures/` — the exemption shape **ADR-016 A1 §2 forbids**
#         and this vault has refused three times: a file-scoped exemption lets a NEW occurrence
#         pass, which is the exact case the gate exists to catch.
#     (c) one-time `--no-verify` per fixture-add (F-P7b-bf's precedent) — works, but recurs
#         every time the set grows. **A bypass is not a mechanism.**
#   ⚠ The 2026-09-09 ruling that R3 be tracked via a path-scoped `.gitignore` negation was made
#   WITHOUT this fact. The negation is necessary and mechanically sound (`git check-ignore`:
#   only `.gitignore:41` matches, no parent dir excluded) but **not sufficient** — committing
#   the result is what blocks. Re-ruled above; `.gitignore` is therefore left UNCHANGED.
#
# ---------------------------------------------------------------------------
# 4.3.0 — R5/R6 WERE AN EXTENSION ALLOWLIST IN A DISCLOSURE GATE. IT FAILED OPEN.
#
#   ⛔ INBOUND, NOT SELF-FOUND. Reported by Hermes (Exchange.aDNA) 2026-09-06, who measured
#   the class against a template artifact he ships and does not run. Recorded as his because
#   a finding's provenance is part of the finding. Ours is F-P7b-ay.
#
#   Both R5/R6 loops opened with `[[ "$f" == *.md ]] || continue` — so a node flagged
#   `confidential: true` or `private: true` in ANY other file type was pushed UNSCANNED by the
#   rule whose entire job is to stop exactly that. Extension allowlists in publish gates fail
#   OPEN; the origin of the class is Venus's 2026-09-03 five-desk memo §5a, where a `.tsv` slid
#   past a list that had `.csv`.
#
#   ⭐ THE CORRECT PREDICATE WAS ALREADY IN THIS FILE, ~60 LINES BELOW, IN R2:
#       file --mime "$f" | grep -q 'charset=binary'   → scan unless PROVABLY BINARY.
#   The right predicate and the defective one sat adjacent in one artifact, unconnected. The
#   fix is not new engineering; it is making R5/R6 use what R2 already uses.
#
#   ⛔ TWO SITES, NOT ONE. The test also appeared in --self-test, which REIMPLEMENTS R1–R6
#   rather than driving them (F-P7b-z's class, named at how/tests/test_sanitize_content_gate.sh:15).
#   Fixing only the real one would leave a reimplementation that disagrees with the rule, and
#   the disagreement would print as a PASS. Under ADR-011 A8 §2 the self-test is SELF_TEST_ONLY
#   for these rules; the verdict of record comes from the driving harness.
#
#   ⚠ F-P7b-az — FOUND WHILE FIXING THE ABOVE, AND THE REASON THE FIX IS NOT ONE LINE. The
#   frontmatter awk was UNANCHORED (`/^---$/` anywhere in the file), which the `*.md` test had
#   been masking. Broadening the file predicate without anchoring trades a fail-OPEN for a
#   latent false-POSITIVE. Measured over all 176 previously-unread tracked files: 8 TRUE
#   frontmatter (the `.base/*.template` files every new vault forks from — exactly the objects
#   a vault would think to mark `private: true`) and 1 PHANTOM (a vendored minified .js with a
#   stray `---`, the same class that produced III's 10 false positives at Wave 2). Anchoring
#   to line 1 makes that 8 and 0. Both changes land together or neither is safe.
#
# ---------------------------------------------------------------------------
# 4.3.0 — THE SUCCESS LINE REPORTED A COVERAGE NUMBER THAT WAS WRONG FOR THE RULE.
#
#   It read: `clean (${#pushed_files[@]} files checked)` — the count of EVERY file in the push,
#   while R5/R6 read a subset of it. ⇒ the gate did not merely OMIT its coverage; it asserted a
#   specific, untrue one, and an operator reading `clean (86 files checked)` had been told
#   something false about R5.
#
#   ⛩ This is ADR-011 A8 §5 verbatim — *a coverage claim states its population, or it is not a
#   coverage claim* — RATIFIED 2026-09-07, one day after Hermes filed the defect that turned out
#   to be its first live instance, in this vault's own control. Neither desk knew.
#   A8 §7 makes the clause reflexive: the instrument reporting coverage is bound FIRST OF ALL.
#
# Exit codes:
#   0 = clean — push proceeds
#   1 = FAIL — sanitization violation; push aborted by git
#   2 = WARN — borderline finding; hook prompts operator confirmation
#
# Bypass (use sparingly):
#   git push --no-verify origin <branch>

set -euo pipefail

# ============================================================================
# Configuration (shared by self-test mode and push-time scan)
# ============================================================================
SANITIZE_MAX_BYTES="${SANITIZE_MAX_BYTES:-10485760}"  # 10 MiB
DENY_FILE_TEMPLATE=".adna/sanitize_deny.txt"
DENY_FILE_VAULT="sanitize_deny.txt"
# R8 — content deny list (paths deliberately parallel to R7's, so operators learn one convention)
DENY_CONTENT_TEMPLATE=".adna/sanitize_deny_content.txt"
DENY_CONTENT_VAULT="sanitize_deny_content.txt"
NULL_SHA="0000000000000000000000000000000000000000"

# Secret-pattern regexes (referenced by R2 rule + self-test fixture scan).
# ANSI-C quoting ($'...') is used so \x27 / \x22 expand to ' and " — POSIX grep -E
# does NOT interpret \xNN as hex, so legacy '...' quoting would leave them as 8 literal
# chars and silently miss any quoted secret. Surfaced by M05 S2 self-test against fixtures.
declare -a secret_patterns=(
  $'([Aa][Pp][Ii]|[Ss][Ee][Cc][Rr][Ee][Tt]|[Aa][Cc][Cc][Ee][Ss][Ss])[_-]?([Kk][Ee][Yy]|[Tt][Oo][Kk][Ee][Nn])[[:space:]]*[:=][[:space:]]*[\x27\x22]?[A-Za-z0-9_\\-]{20,}'
  $'([Gg][Ii][Tt][Hh][Uu][Bb]|[Gg][Hh])[_-]?[Tt][Oo][Kk][Ee][Nn][[:space:]]*[:=][[:space:]]*[\x27\x22]?gh[psoru]_[A-Za-z0-9]{36,}'
  $'[Oo][Pp][Ee][Nn][Aa][Ii][_-]?[Aa][Pp][Ii][_-]?[Kk][Ee][Yy][[:space:]]*[:=][[:space:]]*[\x27\x22]?sk-[A-Za-z0-9]{40,}'
  $'[Aa][Nn][Tt][Hh][Rr][Oo][Pp][Ii][Cc][_-]?[Aa][Pp][Ii][_-]?[Kk][Ee][Yy][[:space:]]*[:=][[:space:]]*[\x27\x22]?sk-ant-[A-Za-z0-9_\\-]{40,}'
  $'-----BEGIN (RSA |EC |OPENSSH |DSA |)PRIVATE KEY-----'
  $'[Aa][Ww][Ss]_[Ss][Ee][Cc][Rr][Ee][Tt]_[Aa][Cc][Cc][Ee][Ss][Ss]_[Kk][Ee][Yy][[:space:]]*[:=][[:space:]]*[\x27\x22]?[A-Za-z0-9/+=]{40}'
  $'[Ll][Aa][Tt][Ll][Aa][Bb][_-]?[Tt][Oo][Kk][Ee][Nn][[:space:]]*[:=][[:space:]]*[\x27\x22]?[A-Za-z0-9_\\-]{20,}'
)

# ---------------------------------------------------------------------------
# Shared predicates (4.3.0) — ONE definition, used by BOTH the push-time rules and the
# --self-test reimplementation.
#
# ⛔ Defined here, not inlined twice, on purpose. The defect these replace existed in two
#   places (the real R5/R6 loop and the self-test's re-implementation of it), which is how a
#   self-test can agree with itself and disagree with the rule. Two copies of a predicate are
#   two predicates.

# TEXT? — R2's predicate, adopted verbatim by R5/R6 at 4.3.0: scan unless PROVABLY binary.
# ⚠ The direction matters and is the whole finding: an allowlist ("only these extensions")
#   fails OPEN on everything it forgot; a denylist against a MEASURED property (`file --mime`
#   says binary) fails CLOSED on anything it cannot classify.
sanitize_is_text() {
  ! file --mime "$1" 2>/dev/null | grep -q 'charset=binary'
}

# Emit the YAML frontmatter block, or nothing.
#
# ⚠ ANCHORED (F-P7b-az). "Frontmatter" means the fence that OPENS the document; the previous
#   scan treated a `---` ANYWHERE as an opening fence, which the `*.md` test had been masking.
#   Removing that test without anchoring this would have traded a fail-OPEN for a
#   false-POSITIVE — measured: 1 phantom (a vendored minified .js with a stray `---`) against
#   8 genuine (the .base/*.template files every new vault forks from).
#
# ⛔⛔ F-P7b-bd — THE FIRST ANCHOR WAS STRICT `NR==1` AND IT SILENTLY NARROWED COVERAGE.
#   Four governance documents carry a REFRAME BANNER as a leading blockquote before the fence
#   — Git.aDNA Standing Order #12, a DOCUMENTED convention, not an accident:
#     what/doctrine/{charter_lighthouse,migration_doctrine}_seed.md
#     what/{architecture/architecture_forge,requirements/requirements_forge}_seed.md
#   ⇒ Under `NR==1` their frontmatter is invisible and R5/R6 stop reading them. Caught by
#   measuring the tree AFTER the change and comparing populations, not by reading the code.
#   ⛩ THAT IS THE SAME CLASS AS THE DEFECT THIS FILE IS BEING REPAIRED FOR — a predicate that
#   quietly stops examining things — introduced WHILE repairing it, in the same act, and it
#   would have shipped as a fix. It is recorded rather than smoothed because the seven
#   instances behind ADR-011 A8 are all this shape.
#
#   ⇒ The preamble skipped is EXACTLY the convention: blank lines and blockquote (`>`) lines.
#   Anything else before the fence ends the scan. Measured over the whole tracked tree: this
#   recovers those 4 files and NOTHING ELSE, and the phantom .js stays excluded.
# ⛔ `|| true` IS LOAD-BEARING, AND F-P7b-bb IS WHY. awk exits 2 when it cannot open its
#   input, and under `set -euo pipefail` the assignment `fm=$(sanitize_frontmatter "$f")`
#   propagated that straight out of the hook: exit 2, NO OUTPUT, before any Decision block.
#   Fail-safe in direction — a non-zero status blocks the push — but it is a CRASH, not a
#   VERDICT, and the two are different facts (the same distinction R8's header draws about
#   `r8_patterns=()`). An operator would have seen a bare `2` and no finding.
#   ⭐ The `*.md` test had been MASKING this: unreadable non-.md files never reached the awk.
#   Removing an allowlist exposes everything the allowlist was accidentally protecting, which
#   is an argument for removing it, not against.
#   Unreadability is reported as a FINDING by the caller, never swallowed here.
sanitize_frontmatter() {
  [[ -f "$1" && -r "$1" ]] || return 0
  awk 'BEGIN{o=0}
       !o && (/^[[:space:]]*$/ || /^>/) {next}      # documented banner/blank preamble
       !o && $0=="---" {o=1; next}                  # the opening fence
       !o {exit}                                    # anything else ⇒ no frontmatter
       o && /^---$/ {exit}                          # the closing fence
       o {print}' "$1" 2>/dev/null || true
}

# ---------------------------------------------------------------------------
# GENERATED FIXTURES (4.4.0) — the fixtures for FAIL rules, materialized at test time.
#
# ⛩ WHY THESE ARE GENERATED AND THE OTHERS ARE TRACKED. R1/R2/R4/R6's fixtures are tracked
#   because they were committed 2026-06-19, before this gate went live. R3 and R5 cannot be:
#   both are FAIL rules, so an honest fixture for either lands in `pushed_files` and blocks the
#   very push that would add it. Generating them creates NO exemption — the alternative shapes
#   (a path allowlist; a per-add `--no-verify`) are ruled out in this file's 4.4.0 header.
#
# ⛔ THE LABEL PLACEMENT IN THE NON-`.md` FIXTURE IS LOAD-BEARING, AND IT WAS MEASURED.
#   `sanitize_frontmatter` skips only blank lines and `>` blockquote preamble before the opening
#   fence; ANY other leading line ends the scan. A `#` comment on line 1 — exactly where a YAML
#   author would naturally put a label — therefore means "no frontmatter", R5 never fires, and
#   **the fixture reads as coverage and is not**: the precise defect this pair exists to close,
#   reproduced inside it. Reported by Rosetta 2026-09-08 §4; REPRODUCED here before being
#   believed (identical bytes ± one leading `#` ⇒ parser returns the frontmatter, then empty).
#   ⇒ in non-markdown fixtures the label sits BELOW the closing fence.
#
# ⚠ `.env`'s content is DELIBERATELY BENIGN. R3 is a FILENAME rule; if the body also tripped R2
#   the catch would not be attributable to R3, and a fixture that cannot say which rule caught
#   it is not evidence about that rule.
#
# Provenance: the R5 pair is adopted from Rosetta's public MIT fixtures shipped at tag `v8.10`
#   (`aDNA-Network/aDNA`), with their controls intact — a fixture adopted without its controls
#   is the thing both desks would rather avoid.
sanitize_gen_fixtures() {
  local d="$1"
  mkdir -p "$d/config"

  # R3 — filename pattern. Benign body on purpose (see above).
  cat > "$d/config/.env" <<'GENEOF'
# Fixture: exercises R3 (filename pattern: credential file).
# The NAME is the trigger. Every value below is benign and deliberately too short and too
# ordinary to match any R2 secret pattern — if R2 also fired, the catch would not be
# attributable to R3.
APP_ENV=test
DATABASE_HOST=localhost
DATABASE_PORT=5432
FEATURE_FLAG_NEW_UI=true
GENEOF

  # R5 control — `.md`. Must be caught by EVERY version; a miss here is a HARNESS BUG.
  cat > "$d/control_confidential.md" <<'GENEOF'
---
type: note
confidential: true
tags: [fixture, generated, r5, control]
---

# Confidential Control (Fixture)

> Triggers R5 (frontmatter `confidential: true`) in a **`.md`** file.
> Pairs with `test_confidential.yaml`, which carries the identical flag in a **non-`.md`** file.
> The two differ **only in extension**, so a run that flags this one and misses its sibling has
> located the extension predicate and nothing else.
> ⛔ Both hook versions must flag *this* file — a miss here is a HARNESS BUG, not a rule finding.
GENEOF

  # R5 subject — non-`.md`. MISSED by 4.0.1, CAUGHT by 4.3.0+. This is the discriminating file.
  cat > "$d/test_confidential.yaml" <<'GENEOF'
---
type: inventory
confidential: true
tags: [fixture, generated, r5, subject]
---
node_inventory: redacted

# Fixture purpose: triggers R5 (frontmatter `confidential: true`) in a NON-`.md` file.
#
# Pairs with control_confidential.md, which carries the identical flag in a .md file.
# 4.0.1 does NOT flag this file — R5/R6 short-circuited on the extension
# (`[[ "$f" == *.md ]] || continue`), so any confidential non-.md file was pushed UNSCANNED.
# 4.3.0 does flag it. The PAIR is what makes that difference attributable to the extension
# and to nothing else.
#
# ⛔ This label sits BELOW the closing fence deliberately. A `#` comment ABOVE the opening fence
# means "no frontmatter" to the reader, R5 never fires, and the fixture reads as coverage and
# is not — the exact defect this pair exists to close, reproduced inside it.
GENEOF
}

# ============================================================================
# Self-test mode (called by skill_deploy post-install)
# ============================================================================
if [[ "${1:-}" == "--self-test" ]]; then
  # Resolve fixtures location: post-M03-flatten canonical first, fallback to legacy .adna/ layout
  fixtures_dir="how/standard/hooks/test_fixtures"
  [[ -d "$fixtures_dir" ]] || fixtures_dir=".adna/how/standard/hooks/test_fixtures"

  if [[ ! -d "$fixtures_dir" ]]; then
    echo "WARN: self-test skipped — fixtures not found at how/standard/hooks/test_fixtures"
    echo "WARN: (fallback .adna/how/standard/hooks/test_fixtures also missing)"
    echo "WARN: install fixtures or run a real publish to verify."
    exit 0
  fi

  echo "INFO: self-test fixtures dir: $fixtures_dir"

  # Per-file rule scan — emits one line per finding (R<N>: <rel> (<detail>)) to stdout
  check_fixture_file() {
    local f="$1"      # absolute or repo-relative path to fixture file
    local rel="$2"    # vault-relative path the fixture simulates (e.g., what/local/notes.md)

    # R1: private path leakage
    case "$rel" in
      what/local/*|how/local/*|who/operators/*|deploy/*|.publish-clone/*|.publish-clone.bak/*|private/*)
        echo "R1: $rel (private path leakage)"
        ;;
    esac

    # R3: filename patterns
    case "$(basename "$rel")" in
      .env|.env.*|id_rsa|id_ed25519|id_ecdsa|id_dsa)
        echo "R3: $rel (filename pattern: credential file)"
        ;;
      secrets|secrets.yaml|secrets.yml|secrets.json|secrets.toml|secrets.ini)
        echo "R3: $rel (filename pattern: secrets file)"
        ;;
    esac

    [[ -f "$f" ]] || return 0

    # R2: secret-pattern match (skip binary)
    if sanitize_is_text "$f"; then
      for pattern in "${secret_patterns[@]}"; do
        if grep -qE "$pattern" "$f" 2>/dev/null; then
          # Honor pragma: allowlist secret
          if ! grep -E "$pattern" "$f" 2>/dev/null | grep -qE 'pragma:[[:space:]]*allowlist[[:space:]]+secret'; then
            echo "R2: $rel (secret pattern match)"
            break
          fi
        fi
      done
    fi

    # R4: large file
    local size
    size=$(stat -f%z "$f" 2>/dev/null || stat -c%s "$f" 2>/dev/null || echo 0)
    if [[ "$size" -gt "$SANITIZE_MAX_BYTES" ]]; then
      echo "R4: $rel ($size bytes > $SANITIZE_MAX_BYTES)"
    fi

    # R5/R6: frontmatter checks — ANY text file, not just *.md (4.3.0; F-P7b-ay).
    # ⚠ This branch is a REIMPLEMENTATION of the push-time rule below, not the rule itself
    #   (F-P7b-z's class). It is kept in step by sharing the predicates, and its green is
    #   SELF_TEST_ONLY under ADR-011 A8 §2 — never cited as coverage for R5/R6.
    if sanitize_is_text "$f"; then
      local fm
      fm=$(sanitize_frontmatter "$f")
      if [[ -n "$fm" ]]; then
        if echo "$fm" | grep -qE '^(confidential|private)[[:space:]]*:[[:space:]]*true'; then
          echo "R5: $rel (frontmatter confidential|private: true)"
        fi
        if echo "$fm" | grep -qE '^status[[:space:]]*:[[:space:]]*draft'; then
          echo "R6: $rel (frontmatter status: draft)"
        fi
      fi
    fi
  }

  exit_code=0
  echo ""
  echo "=== Clean fixtures (expect zero findings each) ==="
  if [[ -d "$fixtures_dir/clean" ]]; then
    while IFS= read -r f; do
      rel="${f#$fixtures_dir/clean/}"
      findings=$(check_fixture_file "$f" "$rel" || true)
      if [[ -z "$findings" ]]; then
        echo "  ✓ $rel"
      else
        echo "  ❌ $rel — UNEXPECTED findings:"
        echo "$findings" | sed 's/^/      /'
        exit_code=1
      fi
    done < <(find "$fixtures_dir/clean" -type f 2>/dev/null | sort)
  else
    echo "  (no clean/ subdir)"
  fi

  # Rules this arm actually implements. ⛔ NOT "all the rules" — R7 (operator deny list) and R8
  # (content deny list) are push-time only and have no branch in check_fixture_file, so folding
  # them into a denominator here would assert coverage the arm cannot produce.
  self_test_rules="R1 R2 R3 R4 R5 R6"
  rules_seen=""
  fixtures_scanned=0
  fixtures_missed=0

  # Walk one dirty root; every file in it must produce ≥1 finding.
  scan_dirty_root() {
    local root="$1"
    local f rel findings
    while IFS= read -r f; do
      rel="${f#$root/}"
      fixtures_scanned=$((fixtures_scanned + 1))
      findings=$(check_fixture_file "$f" "$rel" || true)
      if [[ -n "$findings" ]]; then
        echo "  ✓ $rel — caught:"
        echo "$findings" | sed 's/^/      /'
        # ⛩ Coverage is ACCUMULATED FROM FINDINGS, never asserted. See the note at the
        #   coverage print below — a hardcoded list is a claim about a population no one counted.
        rules_seen="$rules_seen $(echo "$findings" | sed -n 's/^\(R[0-9]\)[:/].*/\1/p' | tr '\n' ' ')"
      else
        echo "  ❌ $rel — NO findings (rule miss; expected at least one R1-R7 finding)"
        fixtures_missed=$((fixtures_missed + 1))
        exit_code=1
      fi
    done < <(find "$root" -type f 2>/dev/null | sort)
  }

  echo ""
  echo "=== Dirty fixtures — tracked (expect ≥1 finding each, matching the named rule) ==="
  if [[ -d "$fixtures_dir/dirty" ]]; then
    scan_dirty_root "$fixtures_dir/dirty"
  else
    echo "  (no dirty/ subdir)"
  fi

  # 4.4.0 — the FAIL-rule fixtures, generated rather than tracked. See sanitize_gen_fixtures.
  gen_dir=$(mktemp -d 2>/dev/null) || gen_dir=""
  if [[ -z "$gen_dir" || ! -d "$gen_dir" ]]; then
    # ⛔ A generator that cannot generate is UNMEASURED, never a pass (ADR-011 A8 §3).
    echo ""
    echo "❌ generated fixtures — could not create a temp dir; R3/R5 coverage is UNMEASURED"
    exit_code=1
  else
    trap 'rm -rf "$gen_dir"' EXIT
    sanitize_gen_fixtures "$gen_dir"
    echo ""
    echo "=== Dirty fixtures — generated (R3/R5: FAIL rules, see 4.4.0 header) ==="
    scan_dirty_root "$gen_dir"
  fi

  echo ""
  # ⛩ COVERAGE IS MEASURED HERE, NOT ASSERTED — and this block was defective on first write.
  #   4.4.0's first draft printed a HARDCODED "R1 R2 R3 R4 R5 R6 exercised" line. Driven against
  #   the 4.0.1 counterfactual it printed "R5 exercised" IN THE VERY ARM WHERE R5 MISSED — a
  #   claim about a population nobody counted, which is F-P7b-ay's exact shape (*"the gate did
  #   not merely OMIT its coverage; it asserted a wrong one"*) reproduced inside the line written
  #   to report coverage. Caught by RUNNING the counterfactual, never by re-reading the code.
  #   ⇒ the list below is accumulated from findings actually produced (ADR-011 A8 §5).
  covered=$(echo "$rules_seen" | tr ' ' '\n' | grep -E '^R[0-9]$' | sort -u | tr '\n' ' ')
  missing=""
  for r in $self_test_rules; do
    [[ " $covered " == *" $r "* ]] || missing="$missing $r"
  done
  n_rules=$(echo $self_test_rules | wc -w | tr -d ' ')
  echo "coverage (measured; population = the $n_rules rules this arm implements: $self_test_rules):"
  echo "          exercised:${covered:+ }${covered:-(none)}"
  if [[ -n "$missing" ]]; then
    echo "          ⛔ NOT exercised:$missing — uncovered, NOT passing"
  fi
  # ⛔ A RULE CAN BE "EXERCISED" WHILE A FIXTURE FOR IT IS MISSED, and the line above cannot say
  #   so: `control_confidential.md` reaches R5 even in an arm where `test_confidential.yaml` is
  #   missed, so rule-level coverage printed IDENTICALLY in the passing and failing runs when
  #   this was first written. ⛩ *A number that reads the same whether the run passed or failed
  #   is decoration that reads as support.* ⇒ the fixture tally is printed beside it, always.
  echo "          fixtures: $fixtures_scanned scanned, $fixtures_missed missed" \
       "$([[ $fixtures_missed -gt 0 ]] && echo '⛔ — a missed fixture is a RULE MISS, and rule-level coverage above cannot express it')"
  echo "          R7 (operator deny list) + R8 (content deny list) have NO branch in this arm —"
  echo "          push-time only, so they are outside the population above, not inside it at 0."
  echo "          R5/R6's arm here REIMPLEMENTS the push-time rule ⇒ SELF_TEST_ONLY (A8 §2),"
  echo "          never citable as coverage for R5/R6 themselves."
  if [[ $exit_code -eq 0 ]]; then
    echo "✓ self-test PASSED (clean fixtures all CLEAN; dirty fixtures all flagged)"
  else
    echo "❌ self-test FAILED — see findings above"
  fi
  exit $exit_code
fi

# ============================================================================
# Read git push refs from stdin
# ============================================================================
declare -a ranges
while read -r local_ref local_sha remote_ref remote_sha; do
  # Skip delete operations
  [[ "$local_sha" == "$NULL_SHA" ]] && continue
  # New branch (no remote history) — compare against empty tree
  if [[ "$remote_sha" == "$NULL_SHA" ]]; then
    ranges+=("$local_sha")
  else
    ranges+=("$remote_sha..$local_sha")
  fi
done

# Empty push (nothing to check)
[[ ${#ranges[@]} -eq 0 ]] && exit 0

# ============================================================================
# Compute set of files about to be pushed
# ============================================================================
declare -a pushed_files
mapfile -t pushed_files < <(
  for range in "${ranges[@]}"; do
    if [[ "$range" == *..* ]]; then
      git diff --name-only "$range" 2>/dev/null
    else
      # New branch — list all files in the pushed commit
      git ls-tree -r --name-only "$range" 2>/dev/null
    fi
  done | sort -u
)

[[ ${#pushed_files[@]} -eq 0 ]] && exit 0

# ============================================================================
# Findings accumulators
# ============================================================================
fail_findings=()
warn_findings=()

# ============================================================================
# R1: Local/private directory leakage (FAIL)
# ============================================================================
for f in "${pushed_files[@]}"; do
  case "$f" in
    what/local/*|how/local/*|who/operators/*|deploy/*|\
    .publish-clone/*|.publish-clone.bak/*|private/*)
      fail_findings+=("R1: $f (private path leakage)")
      ;;
  esac
done

# ============================================================================
# R2: Secret-pattern matches (FAIL; redact when reporting)
# ============================================================================
# secret_patterns array is defined in the shared Configuration block above
# (referenced by both self-test mode and push-time scan).

r2_examined=0
for f in "${pushed_files[@]}"; do
  # Skip non-existing files (deleted in the push)
  [[ -f "$f" ]] || continue
  # Skip binary files
  sanitize_is_text "$f" || continue
  r2_examined=$((r2_examined + 1))
  # Skip if line contains pragma: allowlist secret
  for pattern in "${secret_patterns[@]}"; do
    while IFS=: read -r lineno content; do
      [[ -z "$lineno" ]] && continue
      # Honor pragma: allowlist secret comment
      if echo "$content" | grep -qE 'pragma:[[:space:]]*allowlist[[:space:]]+secret'; then
        continue
      fi
      # Redact: show first 4 chars of any captured group + "***"
      redacted=$(echo "$content" | grep -oE '[A-Za-z0-9_\-]{20,}' | head -1 | cut -c1-4)
      fail_findings+=("R2: ${f}:${lineno} (secret pattern match; redacted='${redacted}***')")
    done < <(grep -nE "$pattern" "$f" 2>/dev/null || true)
  done
done

# ============================================================================
# R3: Filename patterns (FAIL)
# ============================================================================
for f in "${pushed_files[@]}"; do
  case "$(basename "$f")" in
    .env|.env.*|id_rsa|id_ed25519|id_ecdsa|id_dsa)
      fail_findings+=("R3: $f (filename pattern: credential file)")
      ;;
    secrets|secrets.yaml|secrets.yml|secrets.json|secrets.toml|secrets.ini)
      fail_findings+=("R3: $f (filename pattern: secrets file)")
      ;;
  esac
  # .pem files: check content for private-key headers (handled by R2 too; cheap front-line check)
  if [[ "$f" == *.pem ]] && [[ -f "$f" ]]; then
    if grep -q "BEGIN .*PRIVATE KEY" "$f" 2>/dev/null; then
      fail_findings+=("R3: $f (filename .pem with private-key content)")
    fi
  fi
  # .netrc / .npmrc with auth tokens
  if [[ "$(basename "$f")" == ".netrc" || "$(basename "$f")" == ".npmrc" ]] && [[ -f "$f" ]]; then
    if grep -qE "(_authToken|password)[[:space:]]*=" "$f" 2>/dev/null; then
      fail_findings+=("R3: $f (filename .netrc/.npmrc with auth tokens)")
    fi
  fi
done

# ============================================================================
# R4: Large binary files (WARN)
# ============================================================================
r4_examined=0
for f in "${pushed_files[@]}"; do
  [[ -f "$f" ]] || continue
  r4_examined=$((r4_examined + 1))
  size=$(stat -f%z "$f" 2>/dev/null || stat -c%s "$f" 2>/dev/null || echo 0)
  if [[ "$size" -gt "$SANITIZE_MAX_BYTES" ]]; then
    warn_findings+=("R4: $f (size $size bytes > threshold $SANITIZE_MAX_BYTES)")
  fi
done

# ============================================================================
# R5/R6: Frontmatter confidential|private (FAIL) / status: draft (WARN)
# ============================================================================
# ⛔ 4.3.0 — THE `*.md` TEST IS GONE. It read `[[ "$f" == *.md ]] || continue`, which made a
#   DISCLOSURE rule an EXTENSION ALLOWLIST: a node marked `confidential: true` in a .yaml, a
#   .json, or an extensionless file was pushed unscanned by the one rule meant to stop it.
#   That fails OPEN. See the 4.3.0 block in this file's header for the measurement and for
#   F-P7b-az, the anchoring defect the extension test had been masking. Reported inbound by
#   Hermes (Exchange.aDNA), 2026-09-06.
r5r6_examined=0
for f in "${pushed_files[@]}"; do
  [[ -f "$f" ]] || continue
  # ⛔ FAIL-CLOSED on unreadable (F-P7b-bb). A file the disclosure rule CANNOT READ is not a
  #   file that passed it — ADR-011 A8 §3: unmeasured is INDETERMINATE, never a green. It is
  #   reported as a finding here rather than crashing the hook two lines later.
  if [[ ! -r "$f" ]]; then
    fail_findings+=("R5/R6: $f (unreadable — cannot be checked for confidential|private; fail-closed)")
    continue
  fi
  sanitize_is_text "$f" || continue
  r5r6_examined=$((r5r6_examined + 1))
  # Extract the frontmatter block (fence must OPEN the file — F-P7b-az)
  fm=$(sanitize_frontmatter "$f")
  [[ -z "$fm" ]] && continue
  # R5: confidential|private = true
  if echo "$fm" | grep -qE '^(confidential|private)[[:space:]]*:[[:space:]]*true'; then
    fail_findings+=("R5: $f (frontmatter flagged confidential|private: true)")
  fi
  # R6: status: draft
  if echo "$fm" | grep -qE '^status[[:space:]]*:[[:space:]]*draft'; then
    warn_findings+=("R6: $f (frontmatter status: draft)")
  fi
done

# ============================================================================
# R7: Operator-defined deny list (FAIL)
# ============================================================================
r7_rules=0
for deny_file in "$DENY_FILE_TEMPLATE" "$DENY_FILE_VAULT"; do
  [[ -f "$deny_file" ]] || continue
  while IFS= read -r line; do
    # Skip blank lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    r7_rules=$((r7_rules + 1))
    if [[ "$line" =~ ^re: ]]; then
      pattern="${line#re:}"
      for f in "${pushed_files[@]}"; do
        if [[ "$f" =~ $pattern ]]; then
          fail_findings+=("R7: $f (deny regex: $pattern)")
        fi
      done
    else
      for f in "${pushed_files[@]}"; do
        if [[ "$f" == "$line"* ]]; then
          fail_findings+=("R7: $f (deny prefix: $line)")
        fi
      done
    fi
  done < "$deny_file"
done

# ============================================================================
# R8: Operator-defined CONTENT deny list (FAIL)
# ============================================================================
# Why this exists (Git.aDNA ADR-016 D5, filed against F-F78):
#   R1 and R7 are PATH rules — R7 tests "$f" in both its `re:` and prefix branches,
#   and R1 matches a fixed set of directory prefixes. R2 is a content rule but its
#   patterns are hardcoded to secrets. So the gate could express "do not publish these
#   FILES" and "do not publish these SECRETS", and could not express "do not publish
#   this STRING".
#
#   That gap was not hypothetical. Git.aDNA published a mesh overlay address 31 times
#   across 13 files spanning who/, what/, how/ and two repo-root files. No path rule
#   can cover that set; the rule is about a string, not a location. gitleaks passed the
#   repo correctly — an IP and a port are not secrets. The material was reconnaissance
#   in a class the owning graph's MANIFEST rules unpublishable, and no instrument in
#   either vault evaluated a publication boundary because no doctrine stated one.
#
# Format (sanitize_deny_content.txt): one ERE per line; blanks and #-comments skipped.
# Escape hatch: the same `pragma: allowlist` marker R2 honours, on the matching line.
# Reporting: matches are REDACTED — the whole point is a hook that does not itself
# reproduce the string it is refusing to publish.
#
# FAIL-CLOSED (ADR-011 A4 §2(a) — an undeterminable reading is a BLOCK, never a pass):
#   an unreadable file, or a pattern grep rejects, BLOCKS. A deny-list that silently
#   skips the pattern it cannot compile is worse than no deny-list, because it reports
#   green.
# ⛔ SCOPE — R8 CHECKS THE LINES THIS PUSH WOULD ADD, NOT THE WHOLE FILE (4.2.0).
#   Git.aDNA ADR-016 D4 rules already-published content FIX-FORWARD and explicitly does NOT
#   rewrite it. A whole-file scan therefore EXCEEDED the doctrine it enforces: it refused a
#   push over lines the ADR had already ruled are not to be touched. Measured at the change:
#   the vault carried 70 matching lines across 23 files, every one of them already on
#   origin/master, and 24 unpushed commits that added ZERO new ones.
#
#   ⭐ This is the whole reason no allowlist file exists. The three alternatives considered
#   and DECLINED at the 2026-09-02 gate:
#     (a) a file-scoped allowlist naming those 23 files — a NEW occurrence added to any of
#         them (STATE.md above all) would then pass. A gate that reports green on the case
#         it exists to catch is the defect this vault has filed under three names.
#     (b) 70 per-line `pragma: allowlist` markers — edits published prose to satisfy a gate,
#         and the markers themselves become published content.
#     (c) ⛔ weaken the pattern until it passes. NEVER. Still refused, still named.
#   Scoping to D4's own rule needs none of them: the historical body is out of scope BY
#   DOCTRINE rather than by exemption, and there is no allowlist to go stale.
#
#   ⚠ NO REMOTE HISTORY (first push of a branch, remote_sha = NULL_SHA) ⇒ WHOLE FILE. Every
#   line is genuinely new there. That is the correct reading, not a weakened fallback.
#   ⚠ A RENAME presents as all-new and BLOCKS. Fail-safe, stated here rather than discovered.

# Emit "lineno:content" (grep -n's format) for the text this push would ADD in <file>.
r8_subject() {
  local f="$1" range
  for range in "${ranges[@]}"; do
    if [[ "$range" == *..* ]]; then
      # New-file line numbers come from the hunk header's +start; --unified=0 emits no context.
      git diff --unified=0 "$range" -- "$f" 2>/dev/null | awk '
        /^\+\+\+/ { next }
        /^@@/     { match($0, /\+[0-9]+/); n = substr($0, RSTART+1, RLENGTH-1) + 0; next }
        /^\+/     { print n ":" substr($0, 2); n++ }
      ' || true
    else
      grep -n '' "$f" 2>/dev/null || true
    fi
  done | sort -u
}

# Patterns are read and VALIDATED first, so a malformed one fails closed exactly once
# rather than once per file, and the per-file subject is computed only once.
# ⛔ `r8_patterns=()` NOT `declare -a r8_patterns`. Under `set -u` a declared-but-unassigned
#   array is UNSET, and `${#r8_patterns[@]}` then aborts the hook. Caught by the range arms:
#   the hook crashed before reaching its Decision block and exited 1 on EVERY push, including
#   clean ones and every R7 arm. ⚠ Fail-safe in direction, but it is a CRASH, not a verdict —
#   an exit code that means "the gate died" is not the same fact as "the gate refused", and
#   only the harness could tell them apart.
r8_patterns=()
for deny_file in "$DENY_CONTENT_TEMPLATE" "$DENY_CONTENT_VAULT"; do
  [[ -e "$deny_file" ]] || continue
  if [[ ! -r "$deny_file" ]]; then
    fail_findings+=("R8: $deny_file exists but is not readable (fail-closed)")
    continue
  fi
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    # Validate the pattern BEFORE trusting a zero-match result from it. grep exits
    # 0 = matched, 1 = no match (pattern is fine), 2 = bad pattern. Only 2 is a defect,
    # and it is indistinguishable from 1 unless the code looks. `|| rc=$?` is required:
    # under `set -e` a bare grep returning 1 would kill the hook.
    rc=0
    printf '' | grep -E "$line" >/dev/null 2>&1 || rc=$?
    if [[ $rc -gt 1 ]]; then
      fail_findings+=("R8: malformed pattern in $deny_file (fail-closed): ${line:0:24}…")
      continue
    fi
    r8_patterns+=("$line")
  done < "$deny_file"
done

r8_examined=0
if [[ ${#r8_patterns[@]} -gt 0 ]]; then
  for f in "${pushed_files[@]}"; do
    [[ -f "$f" ]] || continue
    sanitize_is_text "$f" || continue
    subject="$(r8_subject "$f")"
    [[ -z "$subject" ]] && continue
    r8_examined=$((r8_examined + 1))

    # ⛔ Split "lineno:content" into a CONTENT-ONLY stream plus a parallel line-number map.
    #   The deny patterns begin with `(^|[^0-9])`. Splicing that after a "lineno:" prefix
    #   would silently change what the `^` branch can match — the pattern must see exactly
    #   the bytes of the source line and nothing else, as the whole-file scan gave it.
    declare -a subj_no=() subj_txt=()
    while IFS= read -r sl; do
      [[ -z "$sl" ]] && continue
      subj_no+=("${sl%%:*}")
      subj_txt+=("${sl#*:}")
    done <<< "$subject"
    [[ ${#subj_txt[@]} -eq 0 ]] && continue

    for pattern in "${r8_patterns[@]}"; do
      while IFS= read -r idx; do
        [[ -z "$idx" ]] && continue
        content="${subj_txt[$((idx-1))]}"
        if echo "$content" | grep -qE 'pragma:[[:space:]]*allowlist'; then
          continue
        fi
        fail_findings+=("R8: ${f}:${subj_no[$((idx-1))]} (content deny match in ADDED line; redacted)")
      done < <(printf '%s\n' "${subj_txt[@]}" | grep -nE "$pattern" 2>/dev/null | cut -d: -f1 || true)
    done
  done
fi

# ============================================================================
# Decision
# ============================================================================
if [[ ${#fail_findings[@]} -gt 0 ]]; then
  echo ""
  echo "❌ pre-push-sanitize: FAIL — push aborted"
  printf '  %s\n' "${fail_findings[@]}"
  echo ""
  echo "Remediate the findings above (or add 'pragma: allowlist secret' on false-positive secret lines), recommit, then retry."
  echo "Emergency bypass (use sparingly): git push --no-verify origin <branch>"
  exit 1
fi

if [[ ${#warn_findings[@]} -gt 0 ]]; then
  echo ""
  echo "⚠ pre-push-sanitize: WARN — borderline findings"
  printf '  %s\n' "${warn_findings[@]}"
  echo ""
  # Read prompt from tty (stdin is git's ref list).
  #
  # ⛔ F-P7b-as (2026-09-02) — THE PREVIOUS GUARD COULD NOT FIRE, AND WAS RIGHT BY ACCIDENT.
  #   It read:  if [[ -t 0 ]] || [[ ! -e /dev/tty ]]; then <treat WARN as FAIL>
  #     · `-t 0` tests STDIN, which at push time is git's ref list — a pipe, never a tty.
  #       The comment one line above says so. The arm is false in normal operation, always.
  #     · `! -e /dev/tty` — on macOS /dev/tty is a device node that EXISTS whether or not a
  #       controlling terminal is attached. The arm is false there too.
  #   ⇒ Both false ⇒ fall through to `read < /dev/tty` ⇒ "Device not configured" ⇒ non-zero
  #     under `set -e` ⇒ exit 1. The RIGHT VERDICT FOR THE WRONG REASON, so nothing ever
  #     revealed it, and the operator-facing message below HAD NEVER ONCE PRINTED.
  #
  #   ⛩ Found on the FIRST REAL DRIVE of this hook, minutes after it was installed for the
  #   first time (F-P7b-ag: R1–R8 had never run on a real push). A guard that exists, reads
  #   correctly, and cannot fire is this campaign's signature class — F-P7b-z (R7 shipped and
  #   never ran), F-F95 (a control enforced where it is vacuous), F-P7b-aa (fail-uninformative).
  #
  #   The test is now the ACT, not a property inferred about it: try to open the terminal.
  #   ⚠ Tested in a SUBSHELL. `exec 3</dev/tty 2>/dev/null` in this shell is wrong twice:
  #   on SUCCESS the `2>/dev/null` is an exec redirection and would silence the hook's own
  #   stderr for the rest of the run; on FAILURE the shell emits its diagnostic before the
  #   redirection applies, so the raw "Device not configured" still leaks past the message
  #   written to replace it. A subshell scopes both.
  if ! ( : < /dev/tty ) 2>/dev/null; then
    echo "INFO: no controlling terminal; treating WARN as FAIL (no operator to confirm)."
    echo "      Resolve the warning, or push from an interactive shell to confirm."
    exit 1
  fi
  read -p "Continue with push? [y/N] " yn < /dev/tty
  if [[ "$yn" =~ ^[Yy]$ ]]; then
    echo "INFO: operator confirmed; proceeding with push."
    exit 0
  else
    echo "INFO: push aborted by operator."
    exit 1
  fi
fi

# ============================================================================
# Coverage report (4.3.0) — ADR-011 A8 §5, RATIFIED 2026-09-07
# ============================================================================
# ⛔ THIS LINE USED TO LIE, AND SPECIFICALLY. It read:
#       clean (${#pushed_files[@]} files checked)
#   — the count of EVERY file in the push, printed as though it were every rule's coverage,
#   while R2/R5/R6/R8 each read a strict subset. An operator reading `clean (86 files checked)`
#   was told something precise and untrue about R5.
#
#   ⛩ A8 §5: *a green from an instrument is a statement ABOUT THE POPULATION IT EXAMINED, and
#   that population is reported WITH THE VERDICT, always.* A verdict whose population is
#   unstated may not be cited as coverage — so this hook could not previously be cited as R5
#   coverage at all, in any of the three vaults running it.
#
#   ⚠ Per-rule, not one number, because the populations genuinely differ and averaging them
#   would be a new way of saying the same false thing. Rules that examine every pushed path
#   (R1, R3) say so explicitly rather than being omitted — an unstated population is the
#   defect, and that does not stop being true when the number happens to be the total.
echo "✓ pre-push-sanitize: clean — ${#pushed_files[@]} files in push. Coverage by rule:"
echo "    R1 paths        ${#pushed_files[@]}/${#pushed_files[@]} (every pushed path)"
echo "    R2 secrets      ${r2_examined}/${#pushed_files[@]} (present, non-binary)"
echo "    R3 filenames    ${#pushed_files[@]}/${#pushed_files[@]} (every pushed path)"
echo "    R4 large files  ${r4_examined}/${#pushed_files[@]} (present)"
echo "    R5/R6 frontmtr  ${r5r6_examined}/${#pushed_files[@]} (present, non-binary)"
echo "    R7 deny paths   ${#pushed_files[@]}/${#pushed_files[@]} against ${r7_rules} rule(s)"
echo "    R8 deny content ${r8_examined}/${#pushed_files[@]} (present, non-binary, with added lines) against ${#r8_patterns[@]} pattern(s)"
exit 0
