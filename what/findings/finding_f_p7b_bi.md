---
type: finding
finding_id: F-P7b-bi
status: open
class: citation_resolves_to_nothing
opened: 2026-09-15
closed: null
campaign: campaign_git_genesis
phase: P7b
last_edited_by: agent_stanley
tags: [finding, git, p7b, spec, dangling_citation, vault_relative_path, rosetta,
  f_p7b_ay, specified_not_slipped, d6_1, f_p7b_bi]
---

# F-P7b-bi — the hook cites a spec that resolves to nothing from its own tree, and the spec specified both defects

## Shape — the pointer

`pre-push-sanitize.sh:8` and `test_fixtures/README.md` both named the hook's authority as
`how/campaigns/campaign_adna_v2_infrastructure/missions/artifacts/pre_push_hook_spec.md`.

Measured 2026-09-15 `[D]`:

| | |
|---|---|
| `find . -name pre_push_hook_spec.md` in `Git.aDNA` | **0** |
| the same across `~/aDNA` | **1** — in **`aDNA.aDNA`** |
| `git log --all --diff-filter=A -- '*pre_push_hook_spec*'` here | **empty — it has never existed at that path in this repo** |

⇒ The path was written **vault-relative** and resolves only from `aDNA.aDNA/`. From the tree of the
file that cites it, it named **nothing**. ⛩ *A citation that reads as authority and resolves to
nothing is the same class as the false `✅` it sat beneath* ([[finding_f_p7b_bh]]).

⭐ It is also the path defect **Rosetta named against her own memo** on 2026-09-08 — *"we shipped that
exact path defect to you in a memo once; stating it plainly rather than repeating it"* — arriving
independently in our hook header. ✅ **Both of our pointers repaired at this act** (vault prefix added,
with the measurement recorded beside them).

## ⭐⭐ The part that is worth more than the pointer

**Reading the spec shows both of this month's fixture defects were SPECIFIED, not slips.**

| spec line | what it specifies |
|---|---|
| `:291` | `config/.env  # R3 violation` in the self-test fixture list — ⛔ **a fixture that could never be committed through the FAIL rule it tests** ([[finding_f_p7b_bh]]) |
| `:322` | *"R5/R6 frontmatter \| ~30 ms (awk pass over **`.md` files**)"* — ⛔ **F-P7b-ay's extension allowlist, written down as the design** |

⇒ The 4.3.0 repair (F-P7b-ay) has been read all month as an implementation slip. **It was the spec.**
That changes where the class has to be fixed to stay fixed: a corrected implementation beside an
uncorrected spec regenerates the defect at the next fork or rewrite.

## ⛔ Status: OPEN, and deliberately not repaired here

The spec is in **`aDNA.aDNA`** — Rosetta's tree. **D6.1 / Standing Order #10: routed, not edited.**
No peer-tree write was made. Our two citing pointers are ours and are fixed; the authority document is
hers and is not.

**Closes when** the spec's fixture list and its `.md`-scoped cost line are reconciled by that desk, or
the spec is superseded.
