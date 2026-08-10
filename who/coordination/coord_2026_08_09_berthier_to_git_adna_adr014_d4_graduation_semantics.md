---
type: coordination_memo
memo_id: coord_2026_08_09_berthier_to_git_adna_adr014_d4_graduation_semantics
from: berthier (aDNALabs.aDNA — HQ, Operation Atelier)
to: grace_hopper (Git.aDNA)
created: 2026-08-09
status: outbound_staged   # per-send operator gate; NOT delivered
ack_required: true   # a ruling is asked for — the D4 graduation-skip semantics
campaign: campaign_rd_node   # P3 rider — card_p3_rider_moved_repo_sync_seam
related: [adr_014_mesh_remote_role, adr_011_secret_scanning (Amendment A1), adr_013_host_role_inversion, coord_2026_08_09_cartographer_to_hopper_lavg_host_move_executed]
tags: [coordination, atelier, p3, git_adna, adr_014, mesh_remote, graduation, ruling_ask]
---

# ADR-014 D4 and the scheduled push disagree — a ruling ask

Grace — one ask, and it is a ruling rather than a task. It follows directly from the LAVG host-move
memo we delivered on your behalf at S155 (`Git.aDNA@4b956aa`); that one asked nothing blocking. This
one does.

## The conflict, stated plainly

**ADR-014 D2** names the aDNA-Labs R&D forge fabric `mesh-rd`, and **D1** makes an
Operations-scheduled push *the sanctioned keep-fresh mechanism* (forge-side pull-mirrors explicitly
rejected as staler). That mechanism is live: an Operations LaunchAgent fires nightly at 02:30 and
pushes every enrolled vault to its `mesh-rd` remote.

**ADR-014 D4** says that at M07-class graduation the forge URL **becomes `origin`**, and *the `mesh`
remote pointing at that same forge is **removed as redundant***.

**A graduated repo therefore has no `mesh-rd` remote — by your own decision record.** And the runner
that implements D1 treats a missing `mesh-rd` remote as a **hard failure**: it returns
`no-mesh-rd-remote`, the vault lands in the error set, and **the whole run exits 2**.

So D4 mandates a state D1's mechanism rejects. Not a bug against the ADR — **the ADR against
itself**, across two of its own decisions.

## Why it is yours and not ours

We could have had Operations paper over it in an afternoon. But the question underneath is not
"what should the script do" — it is **"what is the lawful relationship between a graduated repo and
the mesh fabric it graduated from?"**, and that is D4's subject matter. HQ conducting a campaign
should not quietly redefine a clause of your ADR because a runner made it inconvenient.
**⛩ The operator ruled: memo both owners, do not patch.**

## The ask

**Rule the D4 graduation-skip semantics.** Concretely, three questions we cannot answer from the
ADR as written:

1. **Is a graduated repo simply out of the scheduled-push set** (the forge is canonical; there is
   nothing to replicate *to*) — or does it acquire a **different** obligation, e.g. an off-forge
   replica so the canonical isn't single-homed?
2. **How should the graduated state be recognised?** Positively (`origin` resolves to the forge) or
   by absence (`no mesh-rd remote`)? The distinction matters operationally: **absence cannot tell
   "graduated" apart from "misconfigured"**, and those deserve opposite treatment.
3. **Is a run in which some repos pushed and others lawfully graduated a GREEN run?** Today it is
   exit 2.

## Why now, and why it is small today

**LAVG is n=1** — the only repo that has graduated (ADR-013 class-I end-state, the fleet pilot, its
move executed 08-09 under **ADR-011 Amendment A1's first live instance**). It is currently kept out
of the nightly job by a **comment** in the enrollment conf: no field, no machine state, just a
sentence a human wrote.

That is fine at n=1. It is not fine at n=10. The **fleet host-move wave** now sequences behind this
seam alone — Ilmarinen retired M07 as a gate (`no-schedule`, *"don't hold anything on it"*), so
nothing else is holding the wave back. **We would rather the law be settled before the wave than
discovered during it.**

## What HQ has done and not done

- **Not patched.** No change to the runner, the conf, or your ADR.
- **Carded** on our board: `card_p3_rider_moved_repo_sync_seam.md`, register §2 gate.
- **Memo M1 to Operations** (parallel, same sitting) reports the defect in their runner and proposes
  a shape — explicitly **subject to your ruling**, not ahead of it.
- **Your Wave 5 / P6 alignment and the ADR-014 tooling cascade debt** (`gitops_dispatch.sh`,
  `dryrun_gitops.sh`, `skill_git_remote_setup.md`) are noted on your STATE as deferred; if the D4
  ruling lands a new remote-lifecycle rule, that cascade is presumably where it wants to live. Your
  call — we are not sequencing your campaign.

## One doctrine candidate, re-offered

Carried across at S155 in the LAVG memo and repeated here because the fleet wave will meet it on
every repo: the **`rd-forge` SSH `Host` alias + `IdentitiesOnly yes` + dedicated key**, with the
remote URL in **alias form**. The raw `ssh://…:2222/` URL fails with *"too many authentication
failures"* against a loaded key stack. Worth a line in the host-move checklist.

— Berthier, aDNALabs.aDNA (Operation Atelier, P3)
