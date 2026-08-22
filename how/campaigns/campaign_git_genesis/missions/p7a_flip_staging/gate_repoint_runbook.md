---
type: runbook
title: "Secret-Gate Repoint Runbook — the wrapper files behind the ungated repos"   # was "the 10 wrapper files behind 14 ungated repos"; 5 of the 14 closed by another route 2026-08-21 (§3)
created: 2026-08-20
updated: 2026-08-21
status: staged            # ⛔ FIRES NOTHING. Each section needs its own operator gate (Rule 10).
last_edited_by: agent_stanley
campaign_id: campaign_git_genesis
campaign_phase: 7a
executor_tier: sonnet     # mechanical per-row; the adjudication was opus and is already done
implements: adr_011 (A2 §4 as corrected by A5 §1–§2, A3 §1–§2, A4 §3–§5, A5 §3)
source_measurement: "fresh census run 2026-08-22T01:13Z (supersedes what/inventory/secret_gate_census.md @ 2026-08-21T02:26Z — see §3; the census .md itself is NOT rewritten here)"
tags: [runbook, staged, adr_011, secret_gate, repoint, cross_vault, rule_10, p7a]
---

# Secret-Gate Repoint Runbook

> **⛔ THIS RUNBOOK FIRES NOTHING.** It is staged against a `proposed` amendment **by design** — the
> same discipline as the flip runbook: ratification should know what A4 costs to execute. Every
> section is a **cross-vault write** and takes its own operator gate (Rule 10). Nothing here is
> pre-authorized by the census having been approved.

**Source of truth**: [[../../../../what/inventory/secret_gate_census|the census]] §3a. **Re-run
`how/tests/census_secret_gate.sh` before firing any row** — the census is a timestamped measurement,
not a standing fact, and rows 1–10 below may have changed under it (F-W3-e: verify at use).

---

## §0 — The repair, stated once

Each target is a wrapper file whose content is the **retired v1 no-op** `216aaca2…` — it scans the
*staged* diff (empty at push time) and exits clean having examined nothing. Thirteen of the fourteen
ungated repos reach it **by symlink**, so repointing the wrapper repairs every consumer behind it at
once.

**Replacement**: `Git.aDNA/how/federation/git/hooks/pre-push.gitleaks.sh` (skeleton v2,
`a1288f7371afa187cb1cfd8b9810a669`, 138 lines) — range-scanning, fail-closed, config search order
preserved (`$GITLEAKS_CONFIG` → `git/.gitleaks.toml` → root), per ADR-011 A2 §1–§3.

## §0a — Per-row procedure (identical for every section)

1. **Collision check #1** — target vault tree clean **and** `how/sessions/active/` empty. A non-empty
   peer session means *do not co-write its files* (single-writer lease).
2. **Read the current wrapper** and confirm it is still `216aaca2…`. If the digest has moved, **stop**
   and re-adjudicate — do not repoint a file whose content you have not just read.
3. **Copy v2 over the wrapper.** Do not touch the consumer's `.git/hooks/pre-push` symlink; the whole
   point is that the symlink already resolves correctly.

   ⛔ **Never derive the target from `--path-format=absolute --git-path`** (ADR-011 **A5 §3**): it
   **resolves symlinks and returns the target**, so a `cp` to its answer writes **the tracked wrapper
   this runbook reserves**. Measured live in `Jupyter.aDNA`, caught by md5 and reverted. Where a path
   must be derived, derive it as:

   ```sh
   "$(git rev-parse --path-format=absolute --git-common-dir)/hooks/pre-push"
   ```

   — returns the **link**, unresolved, and collapses correctly for linked worktrees
   (`--absolute-git-dir` returns `…/.git/worktrees/<name>`, which has **no `hooks/` at all**).

3a. ⛔ **Ask first: is this checkout pinned?** (ADR-011 A5 §3 · Galileo, `bright_sextant`.) A
   symlink-shaped install into a **deliberately frozen** working tree silently degrades to whatever
   that tree already holds: the repoint lands on `origin/main`, the checkout never sees it, and the
   hook keeps executing the old content — **while every md5-of-the-tracked-file census reports green.**
   `Jupyter.aDNA/what/lab` is pinned at `277c46f` and cannot be fast-forwarded (its live L1 services run
   off it through an editable-venv `.pth`, so a fast-forward *is* a deploy). **On a frozen checkout only
   a regular-file install survives.** This is the failure mode that is invisible from the tracked side.
4. **Verify the resolution** — `census_secret_gate.sh --root <workspace>` and confirm every consumer
   behind this wrapper flipped `FAIL_NOOP` → `PASS`. Confirm the `+x` bit survived the copy (A4 §5).
5. ⛔ **Induced positive (A2 §4 as corrected by **A5 §1–§2** — the gate that actually retires the
   caveat).** Plant a secret in a **pushed-range commit** on a scratch branch and confirm the hook
   **blocks** (exit 1). Delete the scratch branch. **No row is recorded done on an md5** — md5 is
   evidence of a file, not of a control. A gate that has never been shown to fail is a monitor that has
   never fired. Three requirements, all load-bearing:

   - ⛔ **The plant must be synthetic and non-allowlisted** — random body, real rule shape (e.g. a
     `ghp_` prefix over a random body). **Never a vendor documentation example.** Galileo's first
     attempt planted the canonical AWS example pair (`AKIAIOSFODNN7EXAMPLE` / `wJalrXUtnFEMI/…`), the
     hook scanned the correct range, printed **`gitleaks clean ✓`**, and **pushed**. Scanners allowlist
     example credentials by design, so *the reassuring green is the failure mode*.
   - ⛔ **Both arms, or the row is not recorded.** The **clean** arm must pass in the same exercise — a
     hook that blocks *everything* prints exactly the red a working hook prints.
   - ⛔ **Record what was planted**, not merely that something did. A validation whose subject is not
     written down cannot be re-adjudicated by the next reader (A5 Consequences — our own roster rows
     currently have this defect).
6. **Collision check #2** — re-check clean + sessionless **before committing** (F-W3-d: the tree that
   was clean at apply has twice gone dirty by commit time in this campaign).
7. **Commit stage-only-mine** — explicit paths, never `git add -A`.
8. **Record** the induced-positive date in [[../../../../what/inventory/disposition_ledger|ledger]]
   §Secret-gate install roster, and re-run the census to update coverage.

**Rollback (every row)**: restore the prior wrapper content from git. The consumer symlink is never
touched, so rollback is a single-file revert with no remote or config side effects.

---

## §1 — Rows, ordered lowest-exposure first

Ordering is deliberate: the first rows are ours or quiet, so the procedure is proven on cheap targets
before it reaches a partner-adjacent or multi-consumer one.

| # | Wrapper file | Consumers | Owner | Exposure | Notes |
|---|---|---|---|---|---|
| 1 | `Archive.aDNA/VideosOld.aDNA/how/federation/git/hooks/pre-push.gitleaks.sh` | 1 (+2 root shims) | Iris | **low** — archived vault | **Canary.** Archived + quiet. ⚠ Its origin is the *successor's* live Codeberg repo (`Videos.aDNA`) — flag to Iris; an archived predecessor holding a live push path to its successor is its own question. |
| 2 | `Context.aDNA/what/contextscope/git/hooks/pre-push.gitleaks.sh` | 1 | Prometheus | low | Code-as-WHAT; standard shape. |
| 3 | `LatticeProtocol.aDNA/what/latticeprotocol/git/hooks/pre-push.gitleaks.sh` | 1 | Noether | low | Code-as-WHAT; root `lattice-protocol` shim resolves here. |
| 4 | `Harness.aDNA/what/harness/git/hooks/pre-push.gitleaks.sh` | 1 | Stanley (Harness) | low-med | Live GitHub origin `aDNA-Network/adna-harness`. |
| 5 | `aDNA.aDNA/how/federation/git/hooks/pre-push.gitleaks.sh` | 1 | Rosetta | **med** | **The standard-bearer.** Pairs with the `.adna/` template question (§2) — the local fix does not fix the template. |
| 6 | `ScienceStanley.aDNA/how/federation/git/hooks/pre-push.gitleaks.sh` | 1 | ScienceStanley | **med** | ⛔ **Reached via `core.hooksPath=how/governance/hooks`**, whose `pre-push` symlinks to this file. **Verify by executing a push in a scratch clone, not by reading `.git/hooks/`** — this vault is the reason A4 §3 exists. Historically collision-prone (live site-dev sessions); needs a genuinely quiet window. |
| 7 | `ComfyUI.aDNA/how/federation/git/hooks/pre-push.gitleaks.sh` | 1 | Vulcan | **med-high** | Pushes to **a peer node's** bare repo (`luke-l1-sovereign:.mesh-git/`). An ungated push here lands on someone else's machine. |
| 8 | `Jupyter.aDNA/what/lab-workspace/git/hooks/pre-push.gitleaks.sh` | 1 | Galileo | med | ssh origin — the F-W4-d ssh-remote handling applies. ✅ **Re-verified 2026-08-21: still genuinely ungated** — `.git/hooks/pre-push` is a **symlink** → this wrapper, md5 `216aaca2…` (v1 no-op), zero `remote_sha`/`local_sha` sites. **Window nominated by the owner: now.** |
| 9 | `Jupyter.aDNA/what/lab/git/hooks/pre-push.gitleaks.sh` | **5** | Galileo | ~~**high**~~ → **low (hygiene)** | ⛔ **The premise inverted — corrected 2026-08-21, claim struck not rewritten.** ~~Largest single win in the runbook.~~ **Measured**: all five checkouts (`what/lab` + worktrees `adna-lab-h2d-l9` · `latlab-fencing-token` · `latlab-m-l13_5` · `latlab-ws1-ledger`) resolve `hooks/pre-push` to **one file** — `what/lab/.git/hooks/pre-push` — which is a **regular file already at v2** (`a1288f73…`), installed locally by Galileo. **Nothing resolves to this wrapper**, so repointing it yields **zero coverage change**. It remains worth doing as **tracked-wrapper hygiene** (the next fresh install reads it), and ⛔ the checkout is **pinned at `277c46f`** — see §0a.3a: a symlink-shaped install here would silently degrade. **Do not fire this row expecting a coverage win; the win already happened by another route.** |
| 10 | `Operations.aDNA/what/operations-bridge/.git/hooks/pre-push` | 1 | Berthier / Operations | med | ⛔ **A copy, not a symlink — there is no wrapper to repoint.** Repair in place at the realpath, and consider installing a wrapper so the next repair is one file. Berthier's lane; coordinate, do not unilaterally restructure. |

---

## §2 — Explicit non-goals (things this runbook must NOT do)

- ⛔ **`.adna/` is not touched.** Standing Rule 1. Its `FAIL_NONE` is a **standard-side** question for
  Rosetta, fixed in the template and shipped via `skill_template_release` — patching it locally would
  put the workspace out of sync with the standard and violate the rule in the same stroke.
- ⛔ **git-lfs slots are composed, never overwritten.** Where a foreign hook occupies `pre-push`
  (A4 §2), installing over it silently breaks LFS. No such live row exists today —
  `Archive.aDNA/lattice-labs`'s lfs hook is dead behind a defunct `core.hooksPath` — but the rule
  binds if one appears.
- ⛔ **`dataroom` is not touched.** Its refuse-all hook is `PASS_STRONGER`; "upgrading" it to a
  gitleaks gate would *weaken* a never-push repo from refusing everything to permitting clean pushes.
- ⛔ **Exempt repos are not touched** (census §4) — third-party and upstream, not our authority.
- ⛔ **`WGS.aDNA` / `WilhelmAI.aDNA` are out of scope here.** They are `FAIL_NONE`, not `FAIL_NOOP` —
  a fresh install, not a repoint, with asymmetric exposure (WilhelmAI: partner org, push into another
  operator's home dir, nightly replication). Separate gated act, per the 08-19 liveness table.
- ⛔ **The archived-vault set is out of scope** — census §6 proposes the refuse-all disposition and it
  needs the archive owner's concurrence first.

## §3 — Exit condition

All rows fired, each with a **dated induced positive** in the ledger roster (per A5 §1–§2: synthetic
plant, both arms, plant recorded), and a re-run census showing `FAIL_NOOP = 0`. The remaining gap is
the `FAIL_NONE` set (§3c of the census), which is a different campaign with different owners —
**naming that here so the coverage number is never read as "done" when the no-op class closes.**

### ⚠ Arithmetic re-derived 2026-08-21T01:13Z — the starting point moved, and not because of us

~~Coverage rises 70/117 → 84/117 (**72%**).~~ Struck, not rewritten: the census this runbook was
costed against (`02:26Z`) is stale. Fresh run of the same instrument, `--no-exempt`:

| | `2026-08-21T02:26Z` | **`2026-08-22T01:13Z`** | Δ |
|---|---|---|---|
| claimed population | 117 | **118** | +1 repo appeared — attribution owed at the next census refresh |
| `PASS` (skeleton v2) | 1 | **6** | **+5** |
| `FAIL_NOOP` | 14 | **9** | **−5** |
| `PASS_EQUIV` | 68 | **68** | unchanged |
| `FAIL_NONE` · `FAIL_LEGACY_SANITIZE` | 31 · 2 | 32 · 2 | +1 · — |
| **coverage** | 70/117 = **60%** | **75/118 = 63.6%** | +5 gated |

⇒ **Row 9's five consumers closed themselves.** The +5/−5 are the same set — `what/lab` and its four
worktrees — moved by Galileo's local **regular-file** v2 install at 16:13, **not by this runbook**.
The exit endpoint is unchanged at **84**; only the distance to it shrank. **9 rows remain**, and row 9
is now hygiene rather than one of them (see its Notes).

⭐ **This run also independently corroborates the F-P7b-f rejection.** `PASS_EQUIV` held at **exactly
68** across both censuses, adjudicated by **digest**. Had §4(b)'s reading been right — `f255e2a0…` a
v1 no-op — those 68 rows would be ungated and fleet coverage would be **7/118 (6%)**. The arithmetic
closes on the digest reading and does not close on the grep reading.
