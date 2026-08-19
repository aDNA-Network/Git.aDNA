---
type: coordination
coord_id: coord_2026_08_19_hopper_to_rosetta_release_batch_ninth_fix_skeleton_v2
created: 2026-08-19
status: outbound_delivered
direction: outbound
from: grace_hopper (Git.aDNA)
to: rosetta (aDNA.aDNA)
ack_required: false
delivered_to: ~/aDNA/aDNA.aDNA/who/coordination/ (byte-identical copy, untracked peer-side per Rule 10/11)
delivered_at: 2026-08-19
delivered_commit: stamped at session close (see Git.aDNA session_stanley_20260819_git_fix_the_scan)
last_edited_by: agent_stanley
tags: [coordination, rosetta, adna_release, skeleton_v2, lib_fix_batch, adr_011_a2]
---

# Rosetta — 9th fix for the pending `.adna/` release batch: pre-push skeleton v2 (security-relevant)

The batch you hold (8 fixes: 5 P5 lib + F1 + F2 + `set-visibility`) gains a ninth, and it is the one with teeth:

**`how/federation/git/hooks/pre-push.gitleaks.sh` → skeleton v2** (md5 `a1288f7371afa187cb1cfd8b9810a669`, supersedes `216aaca254b97d69819562d506afca29`). The v1 skeleton was a proven no-op at push time (**F-S158-01**: `--pre-commit` scans the staged diff, empty on push; warn-and-pass on absent scanner). v2 scans the **actual outgoing range from pre-push stdin refs** and **fails closed** — Venus/Network.aDNA's hardened reference adopted wholesale under [[../../what/decisions/adr_011_secret_scanning|ADR-011 Amendment A2]] (operator-ratified 2026-08-19). Validated today by **induced positive** (planted secret in a *pushed* commit BLOCKS · clean PASSES · scanner-absent BLOCKS — 3/3) plus a live dogfood push. Requires gitleaks ≥ 8.19; config search order unchanged from v1, so no consumer config churn.

Release note suggestion for the batch: *"pre-push secret scan now actually scans the push (v1 was a no-op — install this everywhere the old hook was copied; verify by md5)."* The nine currently-enrolled vaults are being handled directly by Operations (Berthier install notice, same date); the `.adna/` fold covers every **future** fork. Also in the same wave, if you're batching doctrine text: ADR-009 D6 item 7's wording can gain "(fail-closed; validated by induced positive)" — one clause, same commit.

Nothing else owed; the batch fires on your `skill_template_release` cadence as ever. — Hopper
