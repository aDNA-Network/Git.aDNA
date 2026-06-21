---
type: coordination
created: 2026-06-19
updated: 2026-06-20
status: ready_to_deliver
delivery_held: "Home.aDNA has active session_hestia_20260620_p5_wrapper_refederation — deliver when clean (or operator-direct)"
last_edited_by: agent_stanley
to: "Home.aDNA (Hestia)"
deliver_at: "P2 (credential ADR) / P5 (beachhead) / P6 (waves)"
mirror: /Users/stanley/aDNA/Home.aDNA/who/coordination/coord_2026_06_20_codeberg_token_provisioning.md
tags: [coordination, ready_to_deliver, git, home, credentials, shim_registry, operation_free_harbor]
---

# Coord Draft → Home.aDNA (Hestia): Multi-Provider Credentials + Remote-Repoint Shim Registry

**Status**: **READY-TO-DELIVER — turnkey provisioning kit attached (§Provisioning Kit below); delivery HELD** because Home.aDNA has an **active Hestia session** (`session_hestia_20260620_p5_wrapper_refederation`) — writing into her vault now risks collision. The kit is one operator-mint + one stash-command from a live `CODEBERG_TOKEN`. Deliver the mirror note (`who/coordination/`) when Home.aDNA is clean, or at operator direction. Staged per Rule 10; tracked in [[coord_delivery_queue]] (row #2). Credential model bound — [[adr_007_credential_model|ADR-007]].

## Two asks

### 1. A Codeberg/Forgejo token under the broker (Standing Rule 6)
The provider abstraction needs a **second provider credential** alongside the GitHub token: a Codeberg/Forgejo API token (for `tea`/REST: create-repo, mirror, release). Provision it on the **Keychain-primary + 1P-backup** substrate, with the same non-TTY agentic-access pattern (per-credential ACL grant + `~/.zshrc` export). Add a NAMES-ONLY entry to `inventory_credentials.md`. Needed by P5 (beachhead) at the latest; the credential **model** is decided in a P2 ADR.

### 2. Shim-registry entries for every remote re-point (Standing Rule 9)
The P6 fleet migration re-points dozens of graph remotes (GitHub→Codeberg). Each re-point is a reversible change that must be **registered in the shim ledger** (`Home.aDNA` disposition_ledger §C) with class, rollback condition, and owner — so a half-migrated fleet is never invisible and every move has a rollback path. The seed set's `git remote rename origin → harbor` preserve-rollback mechanic is the model (generalized to `mirror`/`origin`).

## Why Home owns this
Home.aDNA is the credential broker (Rule 6) + the standing shim registry (Rule 9). Git.aDNA defines *what* credentials/remotes the abstraction needs; Home *holds* them. Decision Points 2, 4, 5.

## Boundary
Git.aDNA never stores tokens or edits the broker substrate — it specifies the requirement and consumes via the broker pattern. Credentials never transit the conversation (Rule 5/6).

---

## P2 finalization (2026-06-20) — model bound; deliver at P5

The credential **model** is now bound in [[adr_007_credential_model|ADR-007]]; the shim-registry tie-in is bound in [[adr_006_remote_naming|ADR-006]] D4. This memo stays **staged** (Standing Rule 10) — delivered to Home.aDNA at **P5** (provisioning), not applied now. Concrete asks, per ADR-007:

- **Token**: `CODEBERG_TOKEN` (host `codeberg.org`), least-privilege scopes `write:organization` (create-repo) + `write:repository` (push-mirror · webhook · deploy-key · release — the [[adr_004_provider_contract_interface|ADR-004]] D5 critical path). Keychain-primary + 1P-backup; NAMES-ONLY in `inventory_credentials.md`. *(Future: `FORGEJO_TOKEN` for the self-hosted lighthouse, post-P7.)*
- **Consumption**: host→env-var map (`github.com→GITHUB_TOKEN` · `codeberg.org→CODEBERG_TOKEN` · `git.<subnet>…→FORGEJO_TOKEN`); 90-day rotation; non-TTY agentic pattern (Rule 5/6). Git.aDNA specifies; Home holds.
- **Shim registry**: every remote re-point ([[adr_006_remote_naming|ADR-006]] D3) registered in `disposition_ledger §C` with class · window · retire-condition · owner.

---

## Provisioning Kit (turnkey — 2026-06-20) — `CODEBERG_TOKEN`

> **Discipline**: NAMES-ONLY (Home SO D4=A / Workspace Rule 6). The token **value** is minted by the operator and stashed via clipboard → Keychain; it **never** enters the conversation, argv, `.git/config`, or any log. Git.aDNA *specifies + consumes*; Home *holds*. Pattern mirrors the existing C47 (Cloudflare) / C51 (Duplo) / C57 (SwS-Gemini) Keychain-primary + 1P-backup rows.

### A. Operator mint steps (the only human-in-the-loop action; ~2 min)
1. Log into **codeberg.org** (account already exists — operator-confirmed 2026-06-20).
2. **Settings → Applications → "Manage Access Tokens"** (`https://codeberg.org/user/settings/applications`).
3. Token name: `adna-network-gitops`.
4. **Scopes (least-privilege, per [[adr_004_provider_contract_interface|ADR-004]] D5 critical path):** `write:organization` (create-repo under the org + org/team standup) **+** `write:repository` (push · push-mirror · webhook · deploy-key · release). Nothing else.
5. **Generate** → copy the token to the clipboard. **Do not paste it into chat.**

### B. Broker stash (Hestia runs; clipboard → Keychain-primary)
```bash
# token is on the clipboard from step A.5 — value never echoed
security add-generic-password -U -a "$USER" -s CODEBERG_TOKEN -T /usr/bin/security -w "$(pbpaste)"
```
- **1P backup-of-record** (create item `Codeberg Token`, field `credential` → `op://Personal/Codeberg Token/credential`).
- **`~/.zshrc` export** (so the dispatch lib resolves it by env-var name, out-of-band):
  ```bash
  export CODEBERG_TOKEN="$(security find-generic-password -s CODEBERG_TOKEN -w 2>/dev/null)"
  ```
- **Verify (NAMES-only — never echo the value):** open a fresh shell → `[ -n "$CODEBERG_TOKEN" ] && echo "CODEBERG_TOKEN: set" || echo "CODEBERG_TOKEN: MISSING"`.

### C. Ready-to-paste NAMES-ONLY inventory row (Hestia drops into `inventory_credentials.md`)
> Next free ID is **C58** (C57 = last app-tier `SWS_GEMINI_API_KEY`; note the pre-existing duplicate-`C55`). Place in the application-tier section.

```
| C58 | `CODEBERG_TOKEN` | Git.aDNA (provider abstraction — create-repo · push-mirror · release vs Codeberg/Forgejo REST `…/api/v1`); consumed via spec §6 host→env map `codeberg.org→CODEBERG_TOKEN` | macOS Keychain item `CODEBERG_TOKEN` (account `stanley`, ACL `/usr/bin/security`); env-var `CODEBERG_TOKEN` exported by `~/.zshrc` | `op://Personal/Codeberg Token/credential` (1P backup-of-record) | env-var-first; dispatch lib reads by name out-of-band (never argv/`.git/config`/logs; ADR-007 D3) | 90-day rotation (ADR-007; MUST touch BOTH Keychain AND 1P) | **LOW** (post-mint) | none |
```
*(Until minted, carry it as **RESERVED — awaiting operator mint**, mirroring the C56 `DUPLO_RDLAB_TOKEN` reserved-row precedent.)*

### D. Host→env-var map (spec §6 — for the broker's reference)
`github.com → GITHUB_TOKEN` (exists, C26/C42) · `codeberg.org → CODEBERG_TOKEN` (this kit) · `git.<subnet>.adna.network → FORGEJO_TOKEN` (future, post-P7 self-hosted lighthouse).

### E. Shim-registry tie-in (the second ask — activates at P6, not now)
The P6 fleet migration re-points dozens of remotes (GitHub→Codeberg). Each re-point registers in `disposition_ledger §C` (class · window · retire-condition · owner) per [[adr_006_remote_naming|ADR-006]] D3/D4. **No shim entries are created at this beachhead** beyond any Git.aDNA dogfood/pilot migrate at P5; the bulk lands at P6 waves.

### Boundary recap
Git.aDNA never stores the token or edits the broker substrate (Rule 6); it specifies the requirement + consumes via the broker pattern. Minting + stashing + the canonical inventory row are **Hestia's** to execute (this kit makes them turnkey). Credentials never transit the conversation (Rule 5/6).
