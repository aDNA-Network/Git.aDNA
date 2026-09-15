# Pre-Push Sanitization Hook — Test Fixtures

> **Purpose**: smoke-test the `pre-push-sanitize.sh` rule logic without requiring a real `git push`. Used by `pre-push-sanitize.sh --self-test` (invoked by `skill_deploy` post-install).

## Layout

```
test_fixtures/
├── clean/              # files that MUST produce zero findings
│   ├── README.md
│   └── what/concepts/example_concept.md
└── dirty/              # TRACKED — files that MUST produce at least one named finding
    ├── what/local/notes.md          # R1: private path leakage      (FAIL)
    ├── fake_with_secret.md          # R2: secret pattern match      (FAIL)
    ├── large_binary.bin             # R4: >10 MiB binary            (WARN)
    └── draft_post.md                # R6: frontmatter status: draft (WARN)

                        # GENERATED at self-test time into a temp dir — never tracked.
                        # Authored by `sanitize_gen_fixtures()` in pre-push-sanitize.sh (4.4.0).
    ·   config/.env                  # R3: credential filename       (FAIL)
    ·   control_confidential.md      # R5 control, `.md`             (FAIL)
    ·   test_confidential.yaml       # R5 subject, non-`.md`         (FAIL)
```

## Rule coverage

⚠ **Read the `How` column before the `Covered?` column.** The two rows that read `✅ generated`
are **not** tracked files; a `find` over this directory will not show them.

| Rule | Covered? | How | Fixture |
|---|---|---|---|
| R1 (private path leakage) | ✅ | tracked | `dirty/what/local/notes.md` |
| R2 (secret-pattern match) | ✅ | tracked | `dirty/fake_with_secret.md` |
| R3 (filename patterns) | ✅ | **generated** | `config/.env` — benign body on purpose, so the catch is attributable to R3 and not to R2 |
| R4 (large binary > threshold) | ✅ | tracked | `dirty/large_binary.bin` (12 MiB) |
| R5 (frontmatter confidential/private: true) | ✅ | **generated** | `control_confidential.md` (`.md`) **+** `test_confidential.yaml` (non-`.md`) — a **pair** differing only in extension |
| R6 (frontmatter status: draft) | ✅ | tracked | `dirty/draft_post.md` |
| R7 (operator deny list) | ⏳ **deferred** | — | **none.** Honestly uncovered; see the asymmetry note below |
| R8 (content deny list) | n/a | — | push-time only; no branch in `--self-test`. Covered by `how/tests/test_sanitize_content_gate.sh` |

**Spec authority:** `aDNA.aDNA/how/campaigns/campaign_adna_v2_infrastructure/missions/artifacts/pre_push_hook_spec.md` §5.
**R5 and R3 are covered as of 4.4.0** (2026-09-15); **R7 remains deferred** to first operator use.

> ⛔ **The spec lives in `aDNA.aDNA`, not here, and the bare filename above used to imply otherwise.**
> Measured 2026-09-15: `find . -name pre_push_hook_spec.md` → **0** in this vault, **1** in
> `aDNA.aDNA`; it has **never** existed at that path in this repo's history. *A citation that reads
> as authority and resolves to nothing is the same class as the false `✅` it sat beneath.*
>
> ⭐⭐ **And reading it shows both defects were SPECIFIED, not slips.** Its fixture list names
> `config/.env  # R3 violation` — a fixture that could never be committed through the FAIL rule it
> tests — and its cost table reads *"R5/R6 frontmatter | ~30 ms (awk pass over **.md files**)"*, which
> is **F-P7b-ay's extension allowlist, written down as the design.** ⛔ **Not repaired here** — that
> tree is Rosetta's (D6.1, Standing Order #10); routed, not edited.

## ⛩ Why two of these are generated and not tracked

**R3 and R5 are FAIL rules, and this hook is installed as a live pre-push gate.** An honest fixture
for either lands in `pushed_files` and blocks the very push that would add it:

- `pushed_files` is `git diff --name-only remote..local`, and **R3 iterates it by `basename`,
  unfiltered** ⇒ a tracked `config/.env` matches `.env` and enters `fail_findings`.
- **R5 is likewise FAIL** ⇒ the `confidential: true` fixtures trip it identically.

⇒ **A fixture for a FAIL rule is indistinguishable, to the rule, from the thing the rule exists to
stop.** Every *tracked* dirty fixture here dates to **2026-06-19**, this vault's genesis day; the gate
went live **2026-09-02**. Nothing entered the set in between — so until 4.4.0, ***the coverage of this
fixture set was shaped by which rules are FAIL and which are WARN, not by what anyone decided to
cover.*** R6, the only WARN rule among the tracked dirty fixtures, is the only one a live gate would
pass today.

**Operator ruling 2026-09-15: generate, do not exempt.** Ruled out, recorded so they are not
re-proposed: renaming the fixture (R3 matches *filenames*, so a rename stops exercising the rule) ·
a path allowlist for `test_fixtures/` (the exemption shape **ADR-016 A1 §2 forbids**) · a per-add
`--no-verify` (works, but recurs every time the set grows — *a bypass is not a mechanism*).

## ⚠ The asymmetry that made this findable — keep it

Until 2026-09-15 this table read **R5 `⏳ deferred`** and **R3 `✅`**. R5 was *honestly uncovered*.
R3 was **`✅` and false**: its fixture path matches this repo's own `.gitignore` rule for `.env`, so
the file had never been committed and **no clone could exercise R3** — while the `Layout` block above
listed it as though it were there.

⭐ *A row that is honestly empty invites the question; a row that is wrongly full closes it.* R3's
false `✅` survived from 2026-06-19 to 2026-09-08 and was found by Rosetta (`aDNA.aDNA`) reading this
file while writing hers — not by any instrument here. **R7's `⏳ deferred` stays deferred rather than
being quietly upgraded**, for exactly that reason.

## Authoring conventions

- **Clean fixtures** must trigger zero R1-R7 findings — kept minimal, no frontmatter flags, no private paths, no secret patterns, no large binaries.
- **Dirty fixtures** must each trigger exactly one *named* finding — labeled in the fixture file (in a comment or frontmatter) so the self-test can verify the right rule fired.
- **⛔ In a non-`.md` fixture the label goes BELOW the closing frontmatter fence.** `sanitize_frontmatter`
  skips only blank lines and `>` blockquote preamble before the opening fence; **any** other leading
  line ends the scan. A `#` comment on line 1 — exactly where a YAML author would naturally put a label
  — therefore means *"no frontmatter"*, R5 never fires, and **the fixture reads as coverage and is not.**
  Reported by Rosetta 2026-09-08 §4 and **reproduced before being believed** (identical bytes ± one
  leading `#` ⇒ the parser returns the frontmatter, then empty). Guarded by the `[trap]` arm in
  `how/tests/test_sanitize_content_gate.sh`.
- **A fixture for a FAIL rule must be generated, not committed** — see the section above. The
  `generated fixtures are NOT tracked` arm in the same suite is what keeps that true.
- **Synthetic secrets**: any "secret" value in a dirty fixture must be obviously synthetic. The `pragma: allowlist secret` marker is reserved for production false-positive overrides, not fixtures.
- **Binary fixtures**: generated reproducibly via `dd if=/dev/zero ...` so the fixture set rebuilds bit-identical across machines.

## Regenerate

`dirty/large_binary.bin` is gitignored from publishing (the hook treats it as R4 violation, but the fixture file itself is intentionally large for the test). If lost, regenerate:

```bash
dd if=/dev/zero of=dirty/large_binary.bin bs=1M count=12
```

Other fixtures are plain text and version-controlled normally.
