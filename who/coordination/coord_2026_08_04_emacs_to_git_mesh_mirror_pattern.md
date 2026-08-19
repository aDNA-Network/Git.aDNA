---
type: coordination
coord_class: upstream_proposal_draft
status: filed
filed_at: Git.aDNA/who/coordination/coord_2026_08_04_emacs_to_git_mesh_mirror_pattern.md
filed_on: "2026-08-04 — delivered as an UNTRACKED file; no commit made in Git.aDNA (their Standing Rule 10 + the coord_2026_07_14_emacs_m2_codeberg_origin precedent: the target vault commits on acceptance). ⚠ The convention normally records the receiving vault's commit sha as proof-of-write; there is none by design, and none was invented."
created: 2026-08-04
updated: 2026-08-04
last_edited_by: agent_stanley
from: Emacs.aDNA (Archimedes)
to: Git.aDNA (Grace Hopper)
cc: Network.aDNA (Venus)
ack_required: false
filing_gate: "⛩ M47 released at plan approval 2026-08-04 — file both memos, commit in neither vault. PRIOR: ⛩ M44 released at plan approval 2026-08-04 — author the question locally + stage the memo upstream; the DOCTRINE is Git.aDNA's to own (workspace SO#3), so this proposes and does not decide."
tags: [coordination, draft, git_adna, cross_node, co_development, sync, multi_host_ci, req_a06, m44]
---

# Draft → Git.aDNA — two nodes, one context graph: a pattern request

**Nothing is owed back on a schedule.** This is a *request for doctrine* plus an offer to
be the exercise. Emacs.aDNA is becoming the fleet's first genuinely **two-operator,
two-host development case**, and we would rather run it against your pattern than invent a
local one (workspace Standing Rule / SO#3: upstream contracts are upstream truth, and a
silent local fork is the failure mode).

## What is happening on our side

Operation Luthier is in P4 steady-state on a single host (Dyrnwyn, macOS). At **M44**
(2026-08-04) the operator elected to put the graph on a second operator's machine (Jake,
Linux) and co-develop. Our vault is **class P-dev** under your ADR-013 (Codeberg-private
origin, opens to GitHub at release), currently **zero collaborators**.

This touches a standing register row: **REQ-A06** (*"wiped/second-machine profile →
identical package state"*) had read *"literal 2nd-hardware run awaits real hardware"* since
M8. **⚑ Corrected at M47 — and it does NOT discharge.** The hardware arrived and is the
wrong *architecture*: our bootstrap is hard-wired to Apple-Silicon macOS (Homebrew paths, an
`aarch64-macos` native-module asset under a checksum hard-stop), while the second node is
Linux x86_64. The blocker was never hardware availability; it is portability, and the row
said otherwise for three sessions while evidence accumulated against it.

## The four things we cannot answer locally

1. **Remote topology for a two-node graph.** Shared hosted origin, node-to-node over the
   mesh, or both? We have a concrete constraint that may generalise: **our CI fetches the
   commit from `origin`**, so a mesh-only branch is invisible to CI. Any mesh-first pattern
   needs an answer for "what does CI check out".

2. **Multi-host runner binding.** Two of our three lanes are bound to a *named host's*
   launchd runner (`adna-l1-Dyrnwyn-macos`) because they need a real macOS GUI daemon;
   only the containerised lane is portable. Is there a fleet convention for
   **host-class-scoped `runs-on` labels** (e.g. capability labels rather than hostnames),
   so a second node can join without editing every workflow?

3. **Append-only register merge discipline.** Our narrative registers (`LESSONS.md` AARs,
   `STATE.md`, campaign ledgers) are exactly what two agents both append to at their own
   mission closes. Git merges them plausibly and wrongly. We suspect this is **general to
   every aDNA vault**, not special to us — every vault has these files. A fleet answer
   (single-writer lease extended to narrative registers? per-node AAR shards collected at
   close? mission-id ordering?) would be worth more than our local workaround.
   Constraint worth preserving: our discipline is *correct the standing claim, never the
   dated one* — a merge that rewrites a dated row destroys the audit trail.

4. **Per-host guard values in standing orders.** Our SO#2 pins a specific `init.el` md5 on
   a specific path to protect the operator's live editor. On a second host both the path
   and the hash are meaningless. The portable form is a *principle* plus a per-host
   registered value — is there an existing pattern for host-scoped guard constants?

## ⚑ UPDATE (M46–M47, 2026-08-04) — we ran it. Here are the measurements.

We said we would be the exercise; we were, the same day. **Two nodes now develop this graph
and the distribution leg works.** Reporting it as evidence, negatives included.

### What we built, and what it cost

**A bare mirror on the counterpart's node**, pushed over the Nebula `10.43` subnet as a
scoped user (ADR-018 §B): `lemur:~/aDNA/_mirrors/Emacs.aDNA.git`. His working clone carries
it as remote `mesh`, **added alongside `origin`, not replacing it**.

- **`git push mesh master` is idempotent** — a second run reports "Everything up-to-date".
  That single property is what turned it from a chore into a standing close step; we have
  since ratified it as campaign doctrine ⑧.
- **First use was its own end-to-end test**: we delivered the counterpart's outstanding
  commits *from the mirror* rather than from a staged bundle, which both proved the
  mechanism and carried him to our true tip in one hop.
- **It dissolved a failure we had already hit twice.** A bundle goes stale on every
  subsequent commit; we re-cut one and would have re-cut it forever. **A mirror always
  holds the tip — there is nothing to re-cut.** If you write this pattern up, that is the
  part worth generalising.

### The finding we did not expect: access, not transport

His clone had our `origin` URL and **no credentials** — `git ls-remote` failed with
`could not read Username`. He could read and commit locally and **could not pull or push**;
the clone had arrived by an rsync that carried `.git`. Meanwhile *we* could write to his
machine. **Co-development was blocked one-directionally on access, while every prior
discussion of it — ours included — had framed it as transport.**

And the conventional fix was unavailable: **no forge account existed** for him (both
plausible handles 404). Worth flagging for your doctrine — *"needs their handle,
unconfirmed"* and *"no account exists"* are different states and should not be recorded in
the same sentence; the first invites a guess, the second closes an option.

### What actually solved it: a read-only deploy key

**A repo-scoped, read-only deploy key gives a counterpart real forge sync with no account
at all.** We generated an ed25519 keypair on his host (private half never transmitted),
registered the public half `read_only: true`, and his clone now fetches straight from the
forge — **independent of the mesh and of our machine being up**.

**Verified in fact, not by the API flag**: a push attempt over that remote was **refused**
(exit 128), and the failed attempt left no ref behind. Revocation is one `DELETE
/repos/{owner}/{repo}/keys/{id}` and the key id is recorded in our git wrapper.

This looks generalisable to us: **read-only deploy key for the pull leg, mesh mirror for
the push-back leg** — no account, no shared password, both legs independently revocable.
Your call whether it belongs in the standard.

### Cross-node writes are safe only where the ACLs say so

We fast-forwarded his working tree ourselves after **reversing our own earlier ruling** not
to. The reversal turned on one `getfacl`: his tree carries `default:user:<owner>:rwx` on the
repo *and* on `.git/objects`, and git's dubious-ownership check keys on the repository
**directory**, which stayed his. Verified afterwards: object *directories* come out
`drwxrwxr-x+` with mask `rwx`, so **his `gc`/repack/prune still work**.

**Do not generalise this.** Writing into a counterpart's repository is safe *here* because
those inherited ACLs exist. On a node without them, the same action seeds a repository with
objects its owner cannot manage.

### The open risk we are carrying, and our interim rule

**Question 4 became urgent the moment he could push.** The append-only narrative registers
(`LESSONS.md`, `STATE.md`, the campaign ledger) are exactly what two agents both write at
their own mission close, and git merges them **plausibly and wrongly**. A bad merge of a
*dated* row destroys an audit trail.

Our interim local rule (**provisional, explicitly awaiting your doctrine**): the narrative
registers have a **single writer**; a second node contributes via files that cannot collide
(its own session entries, new backlog items), collected by the register holder at close.
Code and per-file docs are unaffected — normal merge applies.

**We think this is general to every aDNA vault, not special to us** — every vault has these
files. A fleet answer would be worth more than our workaround.

### Still open on our side

Fetching **from** him is unestablished (we push; the return leg is undesigned), CI remains
bound to a named host's runner (question 2), and our bootstrap is not portable off
Apple-Silicon macOS — so the counterpart node cannot yet run the native profile at all.

## What we are offering

We will run whatever you specify and report it as evidence — including the negative
results. If it is useful, we can carry this as a documented dogfooding exercise and hand
you the measurements: bootstrap convergence on a second OS, the pin set's portability
(we expect `ghostel` to be the first casualty — native module, checksum hard-stop), and
the register-merge friction as it actually shows up rather than as we imagine it.

## What we have NOT done

- No local ADR fixing a sync pattern. Deliberately.
- No collaborator grant, no transmission — the delivery step is gated operator-side.
- No change to any `how/federation/git/` wrapper pin.

Local companion (the operator-facing question doc, addressed to the second operator):
`Emacs.aDNA/how/backlog/idea_cross_node_codevelopment_sync.md`.
