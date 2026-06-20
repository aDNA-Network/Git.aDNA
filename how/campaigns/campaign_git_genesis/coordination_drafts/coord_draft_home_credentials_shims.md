---
type: coordination
created: 2026-06-19
updated: 2026-06-19
status: draft
last_edited_by: agent_stanley
to: "Home.aDNA (Hestia)"
deliver_at: "P2 (credential ADR) / P5 (beachhead) / P6 (waves)"
tags: [coordination, draft, git, home, credentials, shim_registry, operation_free_harbor]
---

# Coord Draft → Home.aDNA (Hestia): Multi-Provider Credentials + Remote-Repoint Shim Registry

**Status**: DRAFT — staged at genesis P0; **deliver at P2** (credential model), then operationally at **P5/P6**. Not yet sent.

## Two asks

### 1. A Codeberg/Forgejo token under the broker (Standing Rule 6)
The provider abstraction needs a **second provider credential** alongside the GitHub token: a Codeberg/Forgejo API token (for `tea`/REST: create-repo, mirror, release). Provision it on the **Keychain-primary + 1P-backup** substrate, with the same non-TTY agentic-access pattern (per-credential ACL grant + `~/.zshrc` export). Add a NAMES-ONLY entry to `inventory_credentials.md`. Needed by P5 (beachhead) at the latest; the credential **model** is decided in a P2 ADR.

### 2. Shim-registry entries for every remote re-point (Standing Rule 9)
The P6 fleet migration re-points dozens of graph remotes (GitHub→Codeberg). Each re-point is a reversible change that must be **registered in the shim ledger** (`Home.aDNA` disposition_ledger §C) with class, rollback condition, and owner — so a half-migrated fleet is never invisible and every move has a rollback path. The seed set's `git remote rename origin → harbor` preserve-rollback mechanic is the model (generalized to `mirror`/`origin`).

## Why Home owns this
Home.aDNA is the credential broker (Rule 6) + the standing shim registry (Rule 9). Git.aDNA defines *what* credentials/remotes the abstraction needs; Home *holds* them. Decision Points 2, 4, 5.

## Boundary
Git.aDNA never stores tokens or edits the broker substrate — it specifies the requirement and consumes via the broker pattern. Credentials never transit the conversation (Rule 5/6).
