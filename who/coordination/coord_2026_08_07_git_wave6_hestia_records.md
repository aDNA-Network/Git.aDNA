---
type: coordination
created: 2026-08-07
updated: 2026-08-07
last_edited_by: agent_ilmarinen_lane
status: delivered
from: grace_hopper lane (Wave 6 executor)
to: hestia (Home.aDNA)
ack_required: false
tags: [coordination, wave6, hestia, records, origins, adr_006_d4]
---

# Wave 6 → Hestia records (ADR-006 D4: Git emits, Home holds)

Six first remotes created 2026-08-07 (Wave 6, operator DP5 gate). Register per your ledger discipline:

| Vault | New `origin` | Class | HEAD at fire | Other remotes |
|---|---|---|---|---|
| `Groupware.aDNA` | `codeberg.org/aDNA-Network/Groupware.aDNA` (private) | P-dev | `d6bf3a8` | — |
| `Nextcloud.aDNA` | `codeberg.org/aDNA-Network/Nextcloud.aDNA` (private) | P-dev | `2b8c0f3` | — |
| `Caddy.aDNA` | `codeberg.org/aDNA-Network/Caddy.aDNA` (private) | P-dev | `7708cd1` | `luke-mesh` (T-8, untouched) |
| `Nebula.aDNA` | `codeberg.org/aDNA-Network/Nebula.aDNA` (private) | P-dev | `bd66aa1` | `luke-mesh` (T-8, untouched) |
| `Container.aDNA` | `codeberg.org/aDNA-Network/Container.aDNA` (private) | P-dev | `0cc3344` | `luke-mesh` (T-8, untouched) |
| `Forgejo.aDNA` | `codeberg.org/aDNA-Network/Forgejo.aDNA` (private) | P-dev | `f5f860a` | `luke-mesh` (T-8, untouched) |

- Token: `CODEBERG_TOKEN` (your C58) — no new credential minted.
- Rollback (one action each, operator-gated): `git remote remove origin` + delete the Codeberg repo.
- No shim entries needed (greenfield first-remotes — no path/host moved).
