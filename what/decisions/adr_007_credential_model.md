---
type: decision
adr_id: adr_007
title: "ADR-007 — Multi-Provider Credential Model (Home.aDNA broker)"
status: proposed
created: 2026-06-20
updated: 2026-06-20
last_edited_by: agent_stanley
ratifies_at: "authored at genesis P2 (2026-06-20); ratified at the P2-exit gate; tokens provisioned at P5"
depends_on: [adr_004, adr_005, adr_006]
tags: [decision, adr, adr_007, git, credentials, home_adna, broker, tokens, binding, proposed]
---

# ADR-007 — Multi-Provider Credential Model (Home.aDNA broker)

**Status**: `proposed` (genesis **P2**, 2026-06-20; ratified at the P2-exit gate). Defines the **contract**; the tokens themselves are **provisioned by Home.aDNA at P5** (this ADR is not blocked on that). Depends on [[adr_004_provider_contract_interface|ADR-004]] (REST automation path), [[adr_005_visibility_host_policy|ADR-005]], [[adr_006_remote_naming|ADR-006]].

## Context
[[adr_004_provider_contract_interface|ADR-004]] drives the Forgejo backend via raw REST with `Authorization: token <PAT>` — so the abstraction needs a **second provider credential** (Codeberg/Forgejo) alongside the existing GitHub token, and (post-P7) a **third** for the self-hosted lighthouse. Credentials are brokered by **Home.aDNA (Hestia)** on Keychain-primary + 1P-backup (Standing Rule 6), because biometric/PIN prompts cannot surface in non-TTY agentic contexts (Rule 5). This ADR specifies *what* the abstraction needs; Home.aDNA *holds* it.

## Decisions

### D1 — The credentials (per-provider PATs, least-privilege)
| Token | Host | Status | Scopes (purpose) |
|---|---|---|---|
| **GitHub PAT** | `github.com` | exists | repo (push/mirror-target), `workflow` (CI), release — fine-scoped |
| **Codeberg/Forgejo PAT** | `codeberg.org` | **NEW (P5)** | `write:organization` (create-repo in org) · `write:repository` (push-mirror · webhook · deploy-key · release) — the [[adr_004_provider_contract_interface|ADR-004]] D5 critical path |
| **Self-hosted Forgejo PAT** | `git.<subnet>.adna.network` | future (post-P7) | same shape as Codeberg, different host |

One token per **host**, not per repo. `tea login` token stores are **not** the automation path ([[adr_004_provider_contract_interface|ADR-004]] D3) — REST reads the brokered env var directly.

### D2 — Broker substrate (Rule 6 pattern, reused verbatim)
Each token is a per-credential **Keychain entry** with a `/usr/bin/security` ACL grant + a `~/.zshrc` export block + a **1Password URI mirror** for portability. A **NAMES-ONLY** entry is added to `Home.aDNA/what/inventory/inventory_credentials.md` (never the secret). This is the established one-time-grant-then-permanent-access discipline (`Home.aDNA` `adr_002`/`adr_003`).

### D3 — Non-TTY agentic consumption (host → env-var map)
The REST client ([[adr_004_provider_contract_interface|ADR-004]] D6) resolves the token from the **host**, via a fixed map — no interactive prompt, ever:

| Host | Env var |
|---|---|
| `github.com` | `GITHUB_TOKEN` |
| `codeberg.org` | `CODEBERG_TOKEN` |
| `git.<subnet>.adna.network` | `FORGEJO_TOKEN` *(per-subnet override allowed)* |

Tokens reach the process **only** as broker-exported env vars; never inlined in skills, declarations, or commits; never echoed to the conversation (Rule 5/6).

### D4 — Rotation & break-glass
- **Rotation**: 90-day (seed §5), via Home.aDNA's rotation flow (`adr_003` Pattern A). Rotation updates the Keychain entry + 1P mirror; env-var names are stable, so no skill changes.
- **Compromise**: revoke at the provider → rotate → re-grant ACL. The shim/registry is unaffected (remotes ≠ credentials).
- **Break-glass**: operator-held recovery (1P) — agents never hold the recovery path.

### D5 — Boundary (binding)
Git.aDNA **specifies** the contract — which tokens, which scopes, which env-var names, the rotation cadence. Home.aDNA **holds, provisions, and rotates**. Git.aDNA never stores a token, never edits the broker substrate, never reads a secret value into context. Decision Points 4/5 (provisioning) are Home.aDNA's at P5.

## Consequences
- The Forgejo backend is usable headlessly the moment Home provisions `CODEBERG_TOKEN` (P5) — no agentic UX redesign.
- The same model extends to the self-hosted token (post-P7) by adding one host→env-var row.
- The [[coord_draft_home_credentials_shims|Home coord memo]] (credentials + shim registry) is the delivery vehicle; finalized here, delivered to Home.aDNA at P5 (Rule 10 — staged, not applied).

## Open questions carried forward (→ Home.aDNA / P5)
- One shared per-host token vs per-agent machine-account tokens (seed §5 `agent-*` accounts) — Home.aDNA's call; SSH-signed commits + `Agent:` trailer live in [[adr_009_dev_process_doctrine|ADR-009]], the identity plane in Network.aDNA/Home.aDNA (out of scope, ADR-001).
- Exact Forgejo scope minimization (verify against Codeberg's scope taxonomy at provisioning).

## Alternatives considered
- **Inline tokens / `sudo -S`-style secrets in skills** — rejected (Rule 5/6): secrets must never transit conversation or live in repo.
- **A single multi-host token** — impossible: tokens are provider-scoped.
- **`tea login` credential store as the source** — rejected: not the REST automation path; adds a second secret store outside the broker.
