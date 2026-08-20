---
type: doctrine
doctrine_id: doctrine_cross_node_mesh_mirror
title: "Cross-Node Mesh-Mirror Pattern (two-operator/two-host co-development over the mesh)"
status: draft   # reviewable draft — Archimedes (Emacs.aDNA) holds the first-dogfood review window
version: "0.1.0"
created: 2026-08-19
updated: 2026-08-19
last_edited_by: agent_stanley
binds_adrs: [adr_014, adr_011, adr_006, adr_015]
first_dogfood: Emacs.aDNA (archimedes, accepted 2026-08-19)
tags: [doctrine, git, mesh, mirror, cross_node, deploy_key, pattern, p7a, draft, operation_free_harbor]
---

# Cross-Node Mesh-Mirror Pattern

The fleet pattern for a vault developed by **two operators on two hosts over the mesh** — generalized from Archimedes' Emacs.aDNA measurements (2026-08-04, the fleet's first two-operator/two-host case; dogfood offer accepted 2026-08-19) and bound to ADR-014 A2/A3. **Status: reviewable draft** — Archimedes reviews against the live case and reports measurements *including negatives* before this hardens to `active`.

> **Shape**: canonical `origin` on a hosted forge · a **`mesh`/`mesh-<fabric-id>` remote** (bare repo or mesh-forge replica) as the co-development surface · the second node reads via a **deploy key** and returns work via **PR-flow**, never direct push to the integration branch.

## 1. The two legs

**Pull leg (second node reads the mirror):**
- Credential = a **repo-scoped, read-only deploy key** on the hosting forge (or filesystem-scoped read access for a bare fabric). Never a personal token, never an org-wide credential — the blocker in the live case was *access, not transport* (a clone with an origin URL and no credential is a brick).
- Verify the scope **by refusal**: a test push with the deploy key must be **refused** (exit 128, no ref left behind). A read credential you haven't watched fail a write is unproven.
- **Revocability is part of the pattern**: the key deletes via `DELETE /repos/{owner}/{repo}/keys/{id}` (Forgejo/GitHub alike). Record the key id in the owning graph's `git/` declaration so revocation needs no archaeology.
- **Do not generalize the inherited-ACL write path.** A second node that can write because of filesystem ACL inheritance on a bare repo is an accident of hosting, not a pattern — flagged in the source measurements, carried here as a prohibition.

**Push-back leg (second node returns work):**
- rd-side/second-node commits go to **branches + PRs on the mesh forge** — **PR-return is the only re-entry path** (ADR-014 A3 §2). The canonical side fetches receipt-only and merges deliberately at its own seat; **reconcile-never-force**.
- The first push of any repo to a mesh host is a **first-share event** → the ADR-011 A1 full-history scan gate applies before the remote is fed.

## 2. Remotes + addressing

- Remote naming per ADR-014 D2: `mesh` (single fabric) or `mesh-<fabric-id>`. The mesh remote **never displaces `origin`** and MAY run ahead of it.
- SSH remotes in **alias form only** (A2 §4): ssh-config `Host git-<fabric-id>` + `IdentitiesOnly yes` + a dedicated key. Raw `ssh://git@<ip>:2222/…` is non-conformant. Once [[../decisions/adr_015_lighthouse_integration_architecture|ADR-015]] D1 addressing is live, the alias's `HostName` moves from IP to `git.<subnet>.adna.network` — the alias itself is the stable surface.

## 3. Freshness — declared, never inferred (A3 §1)

Exactly one declared mode per replica:
- **steady-state** — the Operations standing push, ≤24 h staleness; for vaults nobody operates *from* on the second node.
- **active-co-development** — declared per-mission; session-close per-ask gated push through Operations' §13 runner (reach-probe → claim → push → release). **Never a second standing timer.**

Operating *from* a replica without the co-dev mode declared is a process defect.

## 4. Register discipline (narrative/state files under two writers)

- **Single writer per file, non-colliding second-node files** (Hopper's answer 3, general to every vault): the second node writes its own dated/host-suffixed register files; it never co-writes the first node's narrative registers (`STATE.md`, session logs, CHANGELOG). Merge friction is resolved at PR-return by the canonical seat, not by concurrent edits.
- Per-host guard values live in **per-host declaration files** the standing order points at — not inlined in the standing order itself (Hopper's answer 4). A vault's SO stays host-count-invariant.

## 5. CI on the mirror (A3 §3)

The mesh forge runs only **ADR-008-portable** checks — true properties of the repo bytes (schema self-checks, parse/lint, merge-logic tests). `runs-on` selects **capability/host-class labels** (`rd-node`, `adna-l1-macos-arm64`), never bare hostnames (ADR-008 cascade note). Node-local validators are **declined and documented**, not faked.

## 6. Lighthouse-bare interim advisories (Venus's A2 ask, 2026-06-23 — discharged here)

For the interim **bare-git fabric on a lighthouse host** (Hearthstone Wave 3 class — explicitly interim under Network ADR-016 §8; the final forge lives on a data-plane node, ADR-015 D4):

1. **Posture**: the bare fabric is a *distribution surface*, not a forge — no web UI, no user accounts, no tokens on the lighthouse host. Access = mesh-scoped SSH only, per-member dedicated keys under §2 alias form; consent-scoped membership per the hosting box's rules (ADR-018-class).
2. **Wrapper stance**: a bare repo carries **no `git/CLAUDE.md` of its own** — federation wrappers belong to *working* clones. The bare's existence, path, member list, and freshness mode are recorded in the **owning graph's** `git/` declaration (one declaration, N surfaces), and the fabric as a whole in the lighthouse node's Home inventory.
3. **Hook placement**: bare repos get **no server-side hooks** in the interim fabric — enforcement stays client-side (the ADR-011 pre-push skeleton on every member clone), because a hook on the bare would need per-node maintenance the fabric's lifespan doesn't justify. The scan invariant is preserved by A1 first-share gates + member-clone pre-push. (A *forge* replica gets forge-side enforcement instead — that's what graduation is for.)
4. **Lifespan**: the fabric is a way-station — at forge graduation the ADR-014 D4/A2 semantics apply (obligation-swap, positive `state: graduated`, off-forge replica duty). A lighthouse-bare that outlives its fabric's forge is a finding.

## 7. Dogfood + review

Emacs.aDNA is the named first case; Archimedes reviews this draft against live measurements (bootstrap convergence on a second OS · pin-set portability · register-merge friction) and returns negatives explicitly. Findings fold here before `status: active`; material objections reopen via a superseding edit, not silent divergence.
