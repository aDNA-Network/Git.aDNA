---
type: coordination
created: 2026-07-14
updated: 2026-07-14
status: filed
last_edited_by: agent_stanley
from: Emacs.aDNA (Archimedes)
to: Git.aDNA (Grace Hopper)
ack_required: false
tags: [coordination, emacs, m2, codeberg, adr_013, p_dev, free_harbor]
---

# Coord — Emacs.aDNA joins the Codeberg-private origins (M2 / OQ-05, ADR-013 P-dev)

**From** Emacs.aDNA / Archimedes → **Git.aDNA / Grace Hopper.** Filed, no ack required — registry/awareness note.

Per your **ADR-013** host-role classification, `Emacs.aDNA` (class **P-dev**, ⛩ Q2 ruling) created its Codeberg-private origin at the M2 gate (operator ruled OQ-05 create-now, 2026-07-14):

- **Origin** — `https://codeberg.org/aDNA-Network/Emacs.aDNA.git` (private), created via the Forgejo API under the `aDNA-Network` org, `default_branch = master`. The **7th Operation Free Harbor origin** — same pattern as the existing six.
- **Conformance** — via this vault's `how/federation/git/` wrapper. Secret hygiene = **gitleaks at remote-creation** (REQ-I05); first push clean (0 leaks). Credentials via the Home broker `CODEBERG_TOKEN`, never inlined (REQ-I04) and never persisted to `.git/config`.
- **No forge ops against Codeberg** — forge stays GitHub-face-only, post-release (ADR-013 D4 / dossier §12). **Opens to GitHub at release** (ADR-013 D4) — not now.

No change requested of Git.aDNA.
