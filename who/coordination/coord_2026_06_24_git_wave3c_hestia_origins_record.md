---
type: coordination
coord_id: coord_2026_06_24_git_wave3c_hestia_origins_record
title: "Hopper → Hestia: origins-record for Wave-3c (RemoteControl + Warp first-remotes GH-private) + ComfyUI class-L declaration"
from: Git.aDNA (Grace Hopper)
to: Home.aDNA (Hestia)
created: 2026-06-24
updated: 2026-06-25
status: staged
last_edited_by: agent_stanley
tags: [coordination, p6, wave_3c, origins_record, first_remote, class_l, operation_free_harbor]
---

# Wave 3c — origins-record (no §C shim)

> **Staged per Standing Rule 10** (Git.aDNA does not write into Home; Home was live — `session_hestia_20260624_221931_home_v2_bento` — at authoring). Register from a Home session. **No §C shim entries here** — greenfield first-remote and class-L declarations create **no redirect/rollback** (Standing Rule 9 / runbook line 234: 3a/3c add no shim). This is an **inventory** note only.

## Context

Git.aDNA **R2/P6 Wave 3c** (2026-06-24, DP5-gated) — operator decision: `RemoteControl` → first GitHub-**private** remote (greenfield, class I); `ComfyUI` → **class L** (local-only, no remote). Both federate Git.aDNA via a `git/` wrapper + `## Git-Ops` doctrine + gitleaks hook. `Warp` (the 3rd 3c graph) held — live session.

## Origins to record

| Vault | Origin | Class | HEAD / branch | Note |
|---|---|---|---|---|
| `RemoteControl.aDNA` | `https://github.com/aDNA-Network/RemoteControl.aDNA.git` **(NEW)** | I (private) | `bb2ee63` / `master` | **first remote** — greenfield, no host move. Auth = existing `GITHUB_TOKEN` (aDNA-Network); **no new credential**. `default_branch=master` (GitHub auto-resolved). Anon-clone refused ✓. |
| `ComfyUI.aDNA` | *(none — local-only)* | **L** | `e42e2f9` / `master` | **class-L declaration**: no remote, nothing pushed. GitHub-private only if ever remoted (**never Codeberg**); a remote is a later operator decision. Defensive gitleaks hook installed. |
| `Warp.aDNA` | `https://github.com/aDNA-Network/Warp.aDNA.git` **(NEW)** | I (private) | `fee4dff` / `master` | **first remote** — greenfield, no host move (2026-06-25, `…_wave3_harness_ss_warp`). Operator: first-remote → GitHub-**private** (never Codeberg — internal config-overlay). Auth = existing `GITHUB_TOKEN`; **no new credential**. `default_branch=master` (auto-resolved). Anon HTTP-404 refused ✓. |

- **No new credential** — RemoteControl uses the already-provisioned `GITHUB_TOKEN` (Hestia broker, Rule 6); nothing to add to `inventory_credentials.md`.
- **No §C shim** — neither graph has a `rollback` remote or a redirect to retire. (Contrast the Wave-3b native-rename/transfer entries in `coord_2026_06_24_git_wave3b_hestia_redirect_shims.md`.)
- **Inventory touch (optional):** if Home tracks per-vault origins, add the RemoteControl row above; ComfyUI stays "local-only / class L".

## Not in this batch (held)

- ~~`Warp.aDNA` — 3c, first-remote-or-L undecided; held (live `warp_ep4_gateway_deploy`).~~ **✅ RESOLVED 2026-06-25** — operator chose **first-remote → GitHub-private** (greenfield); recorded in the table above. **Wave 3c is now ✅ COMPLETE (3/3).**
