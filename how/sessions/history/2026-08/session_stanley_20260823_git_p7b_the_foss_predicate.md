---
type: session
session_id: session_stanley_20260823_git_p7b_the_foss_predicate
date: 2026-08-23        # session date = the operator's local/system date at open (2026-08-23 ~20:40 PDT). ⚠ Act timestamps below are UTC (2026-08-24T0x:xxZ). This is the SECOND sitting on this local date — `the_second_end` closed earlier the same day at a2fc74d. Basis stated rather than inferred, per that sitting's own note.
persona: hopper
executor_tier: opus
status: completed
campaign: campaign_git_genesis
phase: "P7b — stage obj 5 (mirror-mesh) NON-OUTWARD · file F-P7b-j · surface the four held ratifications"
door: "§1 open sweep · §2 baseline instruments · §3 F-P7b-j measurement · §4 stage the obj 5 runbook · §5 stage two memos · §6 ratification packet · §7 spec footer true-up · §8 verify · §9 close"
plan: please-read-the-claude-md-replicated-abelson
head_at_open: a2fc74d
head_at_close: see_tracking_commit
inbound_at_open: 0     # clean tree, zero untracked files anywhere in the vault
inbound_at_close: 0    # re-swept at close per the both-ends doctrine — 0 new arrivals. F-INTAKE-04 did NOT fire; second consecutive sitting it has not.
leases_at_open: "⚠ PROVISIONAL, NOT A MEASUREMENT (F-P7b-i). ours 0 · aDNA.aDNA 0 · Jupyter.aDNA 0 · Network.aDNA 1 · Home.aDNA 1. ⛔ This sitting SENDS NOTHING, so no act depends on this line — both authored memos are staged undelivered and their delivery takes its own gate with `probe_peer_state.sh --exec`."
operator_rulings:
  - "Scope = STAGE obj 5 only; NO outward act (AskUserQuestion, this sitting)"
  - "Obj 5 shape = Forgejo → Codeberg push-mirror (AskUserQuestion, this sitting)"
  - "Surface all four pending amendments (ADR-011 A3/A4/A5 + ADR-014 A4) as a ratification packet (AskUserQuestion, this sitting)"
declared_files:
  - how/campaigns/campaign_git_genesis/missions/p7b_staging/mirror_mesh_runbook.md   # §4 — new, fires nothing
  - what/inventory/foss_predicate_measurement.md                                     # §3 — new, the F-P7b-j measurement
  - who/coordination/                                                                # §5 — two memos AUTHORED, delivery fields null
  - who/governance/                                                                  # §6 — ratification packet
  - what/specs/spec_gitops_provider_abstraction.md                                   # §7 — harness footer ONLY
  - how/campaigns/campaign_git_genesis/missions/p7_mesh_git_spike.md                 # §9 — obj 5 staging note; mission stays active
  - STATE.md                                                                         # §9
  - CHANGELOG.md                                                                     # §9
out_of_scope:
  - "⛔ ANY outward act — no push, no `configure-mirror`, no repo creation, no Codeberg call, no host move, no hook install, no wrapper repoint"
  - "⛔ Delivery of either memo — authored ≠ delivered; each send takes its own gate and re-probes at the act"
  - "`.adna/` edits (Standing Rule 1) — R4 lives in their tree; we author the finding, Rosetta ships the fix"
  - "any peer-vault write"
  - "stamping any amendment — the packet surfaces, the operator ratifies (§7.7)"
  - "the intake-log backfill (06-24→08-08 + all three 08-21 sittings) — still its own pass"
  - "obj 5 EXECUTION — this stages it; firing it is a later gate that must clear P7 and P8"
tags: [session, git, p7b, obj_5, mirror_mesh, f_p7b_j, foss_predicate, licensing, ratification_packet, non_outward, staged]
---

# Session — P7b, the FOSS predicate

> **This sitting fires nothing outward.** It stages obj 5, files a finding against a policy this vault
> owns, and puts four held ratifications in front of the operator. The one thing it discovered is that
> the shape the operator chose at the gate has a precondition nobody had measured.

## §1 · Open sweep (both ends, per F-P7b-i)

HEAD `a2fc74d` · tree **clean** · **0** untracked inbound · our leases **0**.
Peer leases: `aDNA.aDNA` 0 · `Jupyter.aDNA` 0 · `Network.aDNA` 1 · `Network`/`Home` both hold one and
neither is a target of this sitting. **Nothing here authorises a send, and nothing is sent.**

## §2 · Baseline instruments — run before anything was written

| Instrument | Reading | Note |
|---|---|---|
| `dryrun_gitops.sh` | **31 passed, 0 failed** | the number the spec footer must carry — taken from the harness, not from STATE.md |
| `preflight_context_sync.sh` | **8 PASS / 0 warn / 0 BLOCK / 0 UNKNOWN** @ `a2fc74d` | baseline; re-run at close to prove no regression |
| `probe_peer_state.sh --meta` | every fixture reached failure · all 6 controls passed · `--exec` gated **both** ways | the instrument that caught itself last sitting, re-validated |

## §3 · F-P7b-j — and the measurement corrected the finding twice

The gate chose **Forgejo → Codeberg**. ADR-013 conditions the whole Codeberg lane on the work being
FOSS — *"Codeberg-private is ToS-OK **only** for FOSS-bound work"* (row 2), 🚩 *"Codeberg = FOSS-only"*
(line 39). So the staging question is: **is it?**

⛔ **First reading was wrong, and it was wrong in the flattering direction.** Planning measured a
**hand-picked list of 7** graphs assembled *from the STATE narrative* and reported **0 of 7 licensed**.
Re-measured against the **actual population** — every vault whose `origin` resolves to `codeberg.org`,
deduplicated to distinct repos because three canonical dirs share a repo with a shim —

> **19 distinct Codeberg repos · 18 unlicensed · 1 licensed** (`Exchange.aDNA`, MIT).

The narrative sample **understated the population by 12** and **overstated the defect rate** (0/7 reads
worse than 1/19). ⭐ *That is ADR-011 **A4 §4** — "the population is the denominator" — firing against
this vault's own staging, one sitting after we wrote it down, and it is **F-P7b-b's exact shape**: we
wrote "the single exception" without sweeping for the class, and Venus swept and found a second member.
**Here nobody had to correct us; the sweep is one command and we ran it before publishing.** That is
the only difference, and it is the whole difference.*

⛔ **Second correction: this is not a Codeberg finding.** Measured on the other side of ADR-013's table,
the **public** lane is proportionally worse — of the four GitHub-public graphs, only `aDNA.aDNA` carries
a license. **`Git.aDNA` itself — this vault, publicly readable since 2026-06-20 — is unlicensed.** The
Codeberg set is private and undistributed; the public set is *actually being distributed* under
all-rights-reserved. **We found it in the lane we were staging and it bites hardest in the other one.**

⭐ **Root cause, and it is a deliberate rule doing exactly what it says.**
`.adna/how/skills/skill_project_fork.md:100` — `rm -f LICENSE  # R4: no template LICENSE (project picks
own license)`. The template **carries** a LICENSE; fork **removes it by rule**; and **nothing anywhere
ever asks the project to pick one** — no gate, no precondition, no line in `doctrine_gitops_block.md`
(which contains no license/FOSS/ToS token at all). Then ADR-013 places the graph on a host whose ToS
assumes the answer.

> **R4 is defensible in isolation and incoherent in composition.** It keys the license to a **phase**
> ("the project picks one later"); ADR-013 keys host placement to an **observable it assumes already
> exists**. Nothing bridges them, so "later" never arrives. ⭐ **This is verbatim the rule Pandora paid
> for and we recorded five days ago in F-C36: *key a condition to the observable it waits for, never to
> a phase expected to deliver it.* We wrote it down, and had it in our own tree the whole time.**

The two licensed graphs (`Exchange.aDNA` MIT · `Astro.aDNA` BSL-1.1) are exactly the two where someone
made an explicit licensing decision. **The mechanism works whenever it is invoked; it is simply never
invoked.**

## §4 · What this sitting produced

| Artifact | Kind | State |
|---|---|---|
| `p7b_staging/mirror_mesh_runbook.md` | obj 5 runbook | **staged — fires nothing**; P7/P8 marked ⛔ NOT SATISFIED / UNKNOWN |
| `what/inventory/foss_predicate_measurement.md` | measurement | 19-repo table + the public-lane rows + residual stated |
| `coord_…_hopper_to_berthier_…` | memo | **authored, undelivered** — all three delivery fields `null` |
| `coord_…_hopper_to_rosetta_…` | memo | **authored, undelivered** — R4 is theirs; Standing Rule 1 |
| `who/governance/ratification_packet_20260823.md` | packet | **surfaces, does not stamp** |
| `spec_gitops_provider_abstraction.md` | true-up | footer `23/23` → **31/31**, measured |

⚠ **Two memos, not the one the plan named.** The finding has two owners and they are not
interchangeable: the *license choice* is org/legal (**Berthier**), the *root cause* is R4 inside
`.adna/` (**Rosetta**, Standing Rule 1 — we never edit it). Routing only the org half would be filing
at the instance and leaving the generator running.

## §5 · SITREP

**Scope held.** The operator scoped this sitting to **staging**, and it staged. **Zero outward acts** —
no push, no forge call, no repo created, no mirror configured, no peer-vault write, no `.adna/` edit.
Both memos are authored with all three delivery fields `null`; all four amendments still read `proposed`.

**Obj 5 is staged and is now known to be blocked on three preconditions**, two of which did not exist in
writing this morning. **Both were found by preparing to fire, not by planning to.** That is the second
consecutive objective where staging-before-execution paid: obj 4's staging found two checks that could
not pass; obj 5's found two preconditions that are not met.

⭐ **The sequencing consequence is the load-bearing one**: F-P7b-k makes obj 5 **transitively gated on
the P7a flip's TLS work.** Obj 5 is the campaign's *last* objective and it is **no longer its next
action** — a dependency that existed nowhere until the §4.4 request was written out in full rather than
described.

⚠ **The sitting corrected itself once, in the flattering direction, before publishing.** Planning read
**0 of 7** from a sample assembled out of this vault's own STATE narrative; the real population is
**19 repos / 18 unlicensed**. Understated the population by 12, overstated the defect rate. That is
**A4 §4 firing against its own author** and **F-P7b-b's exact shape** — the only difference being that
the sweep ran *before* publication. **The sweep is one command.**

### Verification

| # | Check | Result |
|---|---|---|
| 1 | remotes unchanged; changes confined to `Git.aDNA` | ✅ 4 modified + 6 new, all declared; `git remote -v` identical |
| 2 | §4 `fails_when:` walked — each can fail **and** can succeed | ✅ incl. the anchored `^` license grep and the "two tips must differ" guard |
| 3 | F-P7b-j re-measured independently at `HEAD` trees | ✅ **19 repos · 18 unlicensed · 1 licensed** |
| 4 | `preflight_context_sync.sh` | ✅ **8 PASS / 0 BLOCK / 0 UNKNOWN** post-commit *(read 7/1 pre-commit on `clean_tree` — this sitting's own uncommitted work, exactly as obj 4's staging predicted and cleared)* |
| 5 | `dryrun_gitops.sh` — spec footer must match the harness | ✅ **31/31**, and the footer now says 31 |
| 6 | `probe_peer_state.sh --meta` | ✅ every fixture reached failure · all 6 controls passed · `--exec` gated **both** ways |
| 7 | memos undelivered; zero files of ours in any peer tree | ✅ verified by name across all peer vaults |
| 8 | ratification integrity | ✅ 4× `status = proposed`, 4× `ratified-by = (pending)` |
| 9 | close-end sweep | ✅ **0 new inbound** (the only untracked files in `who/coordination/` are our own two authored memos) — **but see below on leases** |

### ⚠ The close-end lease sweep disagreed with the open one, again

Open sweep read `aDNA.aDNA` **0**. At close it reads **1 active**. **Nothing in this sitting depended on
that number** — we sent nothing — so the drift cost exactly zero, which is the only reason it is a note
and not a finding.

⭐ **But it is F-P7b-i's phenomenon recurring, three sittings running, and this time it is free
evidence**: a peer-state reading has now moved mid-sitting in *both* directions across three
consecutive sittings — 08-22 (0 → active, and **two authorized sends were correctly refused**), 08-23
morning (active → clear, and **an operator's conditional authorization was rendered moot**), and now
(0 → active, **cost nothing**). ⛔ **The Rosetta delivery queued as next-session item (2) must therefore
probe at the act and must not inherit this line** — which is precisely what `--exec` makes structural
rather than remembered.

## §6 · Next Session Prompt

> **Read `CLAUDE.md`, then `STATE.md`'s top queued row, then this SITREP.** Open sweep **both ends**
> (inbound **and** leases — the lease end is only guarded by running `probe_peer_state.sh`, never by
> reading a previous sitting's number).
>
> **The queue, in the order the dependencies actually run — not in objective order:**
>
> 1. ⭐ **Operator §7.7 on [[../../../who/governance/ratification_packet_20260823|the packet]] — per row, not blanket.**
>    ADR-014 A4 is the cheapest act available that unblocks **11 unmeasured mesh rows**; ADR-011 A5 gets
>    more expensive the moment Rosetta's undated template gate fires.
> 2. **Deliver the two staged memos** (Berthier = org/legal license call · Rosetta = R4 in `.adna/`).
>    Each takes its **own** gate and goes via
>    `probe_peer_state.sh --target … --write-dir who/coordination --dest-file … --exec 'cp …'` — the
>    gate authorises the send, the probe governs the moment. Stamp `delivered_commit` **before** the
>    copy (F-F23) so src and dst are zero-delta.
> 3. ⛔ **Obj 5 is NOT next.** It is blocked on **P7** (F-P7b-j, others' call), **P8** (Codeberg-accepts-
>    this-*use* — **never asked**; answering it means reading their ToS and possibly asking them), and
>    **P9** (F-P7b-k — needs the P7a flip's TLS). ⇒ **the P7a flip's 8 preconditions are the real
>    critical path now.**
> 4. **Ours, and named as ours**: `doctrine_gitops_block.md` carries **no licensing line**, and ADR-013
>    states a FOSS predicate while assigning **nobody** to establish it. ⚠ Deliberately **not** ridden in
>    on a mirror-mesh runbook — a doctrine change that ships to every aligned graph deserves its own
>    sitting, and it is downstream of Berthier's license decision anyway.
> 5. Then: shape B at the D4 revisit · the fleet host-move wave (D5-unblocked) · the 9-row repoint
>    runbook · the intake-log backfill (**06-24→08-08 + all three 08-21 sittings**) and the **CHANGELOG
>    gap (08-21, 08-22, 08-23 have no entries)** — **both their own pass**, because filling either while
>    writing over it is what makes a gap unfindable.
>
> **If the operator says only "continue the campaign": start at (1).** It costs one decision, it is the
> only item that unblocks somebody else's work, and three of the four amendments have been held for
> five days while every instrument in this vault runs on them.
