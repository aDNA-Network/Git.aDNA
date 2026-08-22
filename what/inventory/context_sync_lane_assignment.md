---
type: inventory
title: "Context-sync lane assignment — which vaults ride the git lane, which ride the ceremony lane, and the three things D3 assumes that measurement does not support"
created: 2026-08-21
updated: 2026-08-22
status: active
last_edited_by: agent_stanley
measured_at: 2026-08-21T23:40Z    # ⛔ UNCHANGED — the body is a dated reading. The 2026-08-22 edits are Venus's RULINGS on findings this document reported; no row was re-measured. A ruling folded in is not a fresh measurement.
measured_commit: c5dddfe          # Git.aDNA HEAD at measurement
adjudicated_at: 2026-08-22        # Venus S398 — F-P7b-a ruled (a)/prospective → ADR-015 A1 · F-P7b-b class corrected to TWO members · F-P7b-c concurred
ratified_at: 2026-08-22           # ⛩ F-P7b-a's remedy is RATIFIED: operator signed shape (a) at Venus's S399 gate (receipt coord_2026_08_22_venus_to_hopper_d3_s2_ratified_shape_a). ADR-015 A1 §1 = accepted; §2–§3 non-normative. Scope = D3 §2 only; no rev 5.
measures: [adr_015_d3, p7b_obj_4, adr_004, adr_020, adr_014_a3, adr_014_a4]
findings: [F-P7b-a, F-P7b-b, F-P7b-c]
tags: [inventory, context_sync, lanes, ceremony, git_lane, p7b, obj_4, adr_015_d3, mesh_replica, freshness, adr_015_a1, venus_ruling, adr_006, adr_019]
---

# Context-sync lane assignment

> **What this is.** P7b objective 4 requires the round-trip to be *reconciled with Network's
> transmission ceremony* (mission card §4; ADR-015 **D3**). This is that reconciliation, measured at
> source in `Network.aDNA` and across the fleet's live remotes rather than transcribed from any memo.
>
> **Every number below carries `measured_at`.** A measurement recorded without its timestamp is a claim
> with a hidden expiry (**F-DECL-03**, Pythia's, adopted here 2026-08-20).
>
> ⛔ **This document changed nothing.** Read-only throughout: `git ls-remote`, `git cat-file`,
> `remote -v`, and file reads in peer vaults. No push, no repo creation, no peer-vault write.

---

## §1 — The two lanes, as ratified

ADR-015 **D3** (`accepted` rev 4, 2026-08-21) sanctions both, neither subsuming the other:

| Lane | Cadence | Carries | Owner |
|---|---|---|---|
| **Git lane** | continuous | git-homed graphs, full history, ADR-014 replicas | operated by each graph; forge is Network-placed |
| **Ceremony lane** | episodic | admission/identity payloads, non-git payloads | Venus (`Network.aDNA`) |

D3 §2's convergence criterion: *when the subnet forge passes its production revisit (D4), scheduled
tarball transmission **of git-homed vaults** retires in favour of forge replicas; the ceremony lane
persists for what it is actually for.*

**§2–§4 measure whether that sentence describes the fleet. On three points it does not.**

---

## §2 — The ceremony lane, as actually operated

Source: `Network.aDNA/what/network/nodes/*/transmissions/` · `who/governance/adr_004_node_adna_transmission_contract.md` · `who/governance/adr_020_campaign_state_transmission_slice.md`

**9 node mirrors, 9 tarball payloads. Every one is a node vault:**

```
node_adna_adna_lighthouse_pi_20260614T032940Z.tar.gz    node_adna_jake_laptop_20260723T192140Z.tar.gz
node_adna_ally_l1_20260729T022829Z.tar.gz               node_adna_lattice_lab_pi_20260611T172435Z.tar.gz
node_adna_emer_laptop_20260622T051448Z.tar.gz           node_adna_mccoy_laptop_20260624T230934Z.tar.gz
node_adna_forge_20260801T024057Z.tar.gz                 node_adna_wga_l1_20260624T040119Z.tar.gz
node_adna_jake_l1_20260808T221732Z.tar.gz
```

**ADR-004 §a.1 fixes the payload**: a full `node.aDNA/` directory tarball — `MANIFEST.md` + `STATE.md` +
`who/identity/` + `what/inventory/` — and it **excludes `.git/` by contract**. Detached Ed25519 sig;
placement at `what/network/nodes/<hostname>.aDNA/`.

### ⛔ F-P7b-a — D3 §2's convergence criterion has an empty subject set, on two independent axes

> ⛩ **CLOSED — RATIFIED 2026-08-22.** Ruled **shape (a), prospective-only** by Venus (S398) and **signed by
> the operator at her S399 gate** ([[../../who/coordination/coord_2026_08_22_venus_to_hopper_d3_s2_ratified_shape_a|receipt]]);
> the remedy is [[../decisions/adr_015_lighthouse_integration_architecture#Amendment A1 — D3 §2 is prospective the clause has no subject resolves F-P7b-a — §1 accepted 2026-08-22 · §2–§3 non-normative|**ADR-015 Amendment A1 §1**]] (`accepted`; §2–§3 non-normative). ⭐ **A third axis was added by her and it is the one that
> decided the shape: the set is empty DEFINITIONALLY — D3 §1, one paragraph above, already assigns
> git-homed graphs to the git lane, so §2 contradicts §1 of the same D.** The measurement below stands as
> taken and is *not* rewritten; it is now the empirical confirmation of something the text had already
> ruled out. ⛔ **The hazard this finding named is foreclosed in text, not merely retired**: A1 §1's
> out-of-scope block protects the ADR-020 consent slice and the nightly reconciliation pass by name.

> *"scheduled tarball transmission **of git-homed vaults**"* — measured, **neither half of that phrase
> refers to anything the fleet does.**

**Axis 1 — "of git-homed vaults": empty.** All nine payloads are **node vaults** (`Home.aDNA`-class),
and the contract governing them excludes git history. **No git-homed graph is transmitted by ceremony.**

**Axis 2 — "scheduled": transmissions are event-driven, not scheduled.** Payload timestamps show no
cadence (`06-11 · 06-14 · 06-22 · 06-24 ×2 · 07-23 · 07-29 · 08-01 · 08-08`); ADR-004 triggers them on
admission and refresh events. The **only** nightly schedule in the lane is a *reconciliation pass over
already-placed mirrors* (`spec_node_adna_transmission_registration.md:422`, default `0 2 * * *`) — a
different operation, over different objects, which a clause about *transmissions* would not retire.

⇒ **At D4 the clause fires and nothing retires.** Direct sibling of **F-P7a-f** (*a measurement that
cannot fail is not a control*), one level up: **a retirement criterion with no subject retires nothing.**

### ⚠ And the adjacent set is *not* empty — which is where the real hazard is

Project-graph state **does** ride the ceremony lane, but not as a vault: **ADR-020** (`accepted`
2026-08-01) adds an optional **`campaign_state/` slice** *inside* the ADR-004 node tarball —
`campaign_id · status_rollup · progress · mission_count`, **titles per-node opt-in**, with a **NEVER
transits** list, per-node consent, and one-line revocation.

**A loose reading of D3 §2 at D4 — "forge replicas carry the context now, retire the tarballs" — would
sweep that slice away and replace a four-field consented summary with whole repositories.** Forge
replicas carry full history and honour no allow-list. That is a **consent regression**, not a
convergence, and D3 §2 as written does not forbid it.

**Recommendation (Venus's clause to rule on, not ours):** D3 §2 either states it is **prospective-only**
— binding on git-homed vaults *if* any are ever ceremony-transmitted — or it is amended to name its real
subject. Either way it must say **explicitly** that the ADR-020 slice and the nightly reconciliation pass
are **out of scope of the retirement**. D4's production revisit is the wrong place to discover which.

---

## §3 — The git lane, as actually operated

Source: `git remote -v` + read-only `git ls-remote` across all root-level `.aDNA` graphs.

**Fleet remote posture** — 95 root graphs carry `.git`; **71 have a remote**, 24 are local-only.

### ⛔ F-P7b-b — the git lane is already live; obj 4 and D3 both read as though it is greenfield

**11 distinct vaults already replicate to the R&D forge** over `rd-forge:` (14 remote-carrying paths
minus 3 shims — `Lab.aDNA`→`Jupyter`, `MoleculeForge.aDNA`→`Molecules`, `aDNANetwork.aDNA`→`Network`;
**a shim and its target are ONE repo**, ADR-011 A4 §4).

⚠ **And the R&D fabric is not the whole lane.** A labelled re-measurement (below) found enrollment
across **three** mesh fabrics: `mesh-rd` (11 vaults, answering) · `luke-mesh` (5) · `mesh` (6). Counting
distinct vaults with at least one mesh remote: **20**. *The first pass of this section said "11", which
was true of the R&D fabric and false of the lane* — the instrument had been matching only the remote it
was pointed at. Corrected here rather than left standing, because the number a reader takes from a lane
inventory is the size of the lane.

The mission card says *"point a graph's `git/` at `git.<subnet>.adna.network`… push/clone via the Forgejo
backend"* and *"sync a vault as the subnet's context"* — phrased as work not yet begun. **It has been
begun; `Git.aDNA` is itself enrolled.** Obj 4's real content is therefore **not** *make the lane exist*
but *prove the round-trip and measure what is true of the lane that exists.* Recorded because a runbook
written against the greenfield reading would have staged the wrong work.

**Replica freshness, measured `2026-08-21T23:49Z`** — `bash how/tests/preflight_context_sync.sh --lanes`.
**One row per mesh remote, and the remote is named in the row:**

| Vault | remote | local | mesh | state |
|---|---|---|---|---|
| `Molecules.aDNA` | `mesh-rd` | `c7d2bbb` | `c7d2bbb` | IN-SYNC |
| `LlamaCppForge.aDNA` | `mesh-rd` | `e966511` | `e966511` | IN-SYNC |
| `WGS.aDNA` | `mesh-rd` | `0e6ca1c` | `0e6ca1c` | IN-SYNC |
| `WilhelmAI.aDNA` | `mesh-rd` | `6362d1a` | `6362d1a` | IN-SYNC |
| `LAVentureGraph.aDNA` | **`origin`** | `3fe62d8` | `3fe62d8` | IN-SYNC |
| `Git.aDNA` | `mesh-rd` | `c5dddfe` | `169eff4` | **DIVERGED** |
| `Network.aDNA` | `mesh-rd` | `75d11fb` | `024ccce` | **DIVERGED** |
| `aDNALabs.aDNA` | `mesh-rd` | `13a96b9` | `df74887` | **DIVERGED** |
| `Forgejo.aDNA` | `mesh-rd` | `ec57ac9` | `902a29d` | **DIVERGED** |
| `Jupyter.aDNA` | `mesh-rd` | `f3bed58` | `8eebd6d` | **DIVERGED** |
| `Inference.aDNA` | `mesh-rd` | `523fc76` | `90f39eb` | **DIVERGED** |
| `Caddy` · `ComfyUI` · `Container` · `Forgejo` · `Nebula` | `luke-mesh` | — | — | **UNREACHABLE ×5** |
| `Canvas` · `Regenesis` · `RemoteControl` · `wga` · `WilhelmAI` · `WorldGenome` | `mesh` | — | — | **UNREACHABLE ×6** |

**5 in-sync · 6 diverged · 11 unreachable.**

⚠ **"DIVERGED" is not a verdict of "stale" or "wrong".** Under ADR-014 A3 a replica may lawfully lag.
Whether any row is a *defect* is exactly what §4 shows cannot currently be decided. The table reports
tips; it deliberately does not adjudicate them.

⚠ **"UNREACHABLE" is not a verdict of "broken" either** — `luke-mesh` and `mesh` are peer fabrics that
simply are not answering from this node right now. It means **unmeasured**, which is the one thing a
coverage table must never render as health (**F-P7a-h**, the census's own lesson, applied here).

⛔ **Two instrument defects were found and fixed while producing this table** — both recorded because
each would have put a wrong number into this document:

1. **The remote was not named in the row.** `Forgejo.aDNA` read `DIVERGED` when measured against
   `mesh-rd` by name and `UNREACHABLE` in the sweep — *same tree, minutes apart, both correct*, because
   it is enrolled on **two** fabrics and the sweep silently took whichever remote matched first. An
   unlabelled row is not a measurement. Now: **one row per mesh remote, labelled.**
2. **`size-pack` alone under-reported transfer cost, toward "cheap".** `LAVentureGraph.aDNA` reported
   `0 bytes` while holding **26 MiB of loose objects** (never gc'd). A cost column that reads zero on a
   non-empty repo cannot report the condition it exists to report. Now both halves are summed and the
   split printed.

*(Also observed, not a defect: `aDNALabs.aDNA` moved from `9063efd` to `13a96b9` **during this session**
— nine minutes between two readings. The fleet does not hold still for a measurement, which is why every
row above carries `measured_at` rather than a bare tip.)*

### ⭐ Independent convergence — Ilmarinen found defect (1) in the census, the same day, from the other side

Arriving mid-session (untracked at our open sweep — **F-INTAKE-04** again), `coord_2026_08_21_ilmarinen_to_hopper_census_remote_column_undercounts` reports the **same class of defect in
`census_secret_gate.sh`'s `remote` column**: it prints **one** remote for a repo that has **three**.
His own — `Forgejo.aDNA` — carries `luke-mesh` (the only one printed), `mesh-rd`, **and** a public
Codeberg `origin`.

Neither of us had read the other. **He found it by hand-checking a repo he owns; we found it because
the same repo returned two different answers to the same question.** His sentence for why it matters is
better than ours:

> *"Not a verdict defect — the gate is per-repo … It is a **reporting defect in the column a reader uses
> to judge exposure**. ⚠ The direction is the flattering one … fewer remotes reads as less exposure."*

That is **F-P7a-h's shape** — under-enumeration rendering as nothing-to-see rather than as unmeasured —
and his triage example is exact: the census flags `ComfyUI.aDNA` ⚠ for pushing to a peer node's bare
repo, while `Forgejo.aDNA`, which does that **and** pushes to the R&D forge **and** to public Codeberg,
is sized at **one-third of the truth**.

⛔ **CARRY, AND IT IS NOT DONE.** We fixed **this** instrument. **`census_secret_gate.sh`'s `remote`
column still has the defect** — the fix there is his suggested `remote_count` beside the joined column,
so a `1` that should be `3` is visible. **Recorded as debt, not as fixed.** *A finding closed at its
instance is not a finding closed* — that is F-Astro's lesson, whose second instance sat live for two
months, and it applies here with the ink still wet.

### ⚠ `LAVentureGraph.aDNA` — the replica is its `origin`

```
origin    rd-forge:aDNA-Network/LAVentureGraph.aDNA.git
rollback  https://github.com/aDNA-Network/LAVentureGraph.aDNA.git
```

Two things, and the second matters more than the first:

1. **Naming**: ADR-014 D2 binds mesh remotes to `mesh-<fabric-id>`. This one is `origin`. Every other
   enrolled vault uses `mesh-rd`; this is the single exception.
2. ⛔ **Posture**: `origin` *is* the mesh forge and GitHub is demoted to `rollback` — so this graph's
   **primary home is the R&D spike instance**, which `p7_mesh_git_spike.md` calls in terms *"a spike,
   not production."* Whether that was a deliberate host-move or a repoint that took the default remote
   name is **not determinable from this vault** and is not ours to change. **Flagged, not edited** —
   filed for the owning graph and for Venus's placement lane.

#### ⭐ CORRECTION 2026-08-22 — ~~the single exception~~ **the class has two members, and they are not the same case**

*Source: **Venus** (`Network.aDNA`, S398), ruling on this finding —
[[../../who/coordination/coord_2026_08_22_venus_to_hopper_d3_s2_prospective_and_the_class_has_two|memo §4]].
Confirmed at the object, not from our report.*

⛔ **The §2 claim above — *"this is the single exception"* — is struck.** It is preserved rather than
rewritten because the defect is in the **method, not the arithmetic**: we found one instance and did not
sweep for the class. Venus swept every `*.aDNA` in the workspace for the same shape and it returned **two**:

| graph | `origin` | ruling |
|---|---|---|
| `LAVentureGraph.aDNA` | `rd-forge:aDNA-Network/LAVentureGraph.aDNA.git` | ⛔ **misplaced** — see below |
| `operations_jake.aDNA` | `ssh://git@10.43.0.5:2222/…` | ✅ **not touched** — see below |

⭐ **And the ruling that matters is that they are *not* the same case.** The rule is **not** *"no graph may
have a forge `origin`"*; under **ADR-006** it is *"`origin` = the graph's canonical home."* For
`operations_jake.aDNA` — Jake's vault, on Jake's lane, under ADR-019 — the subnet forge plausibly **is**
canonical, and Venus declined to touch it **on a naming convention**. For `LAVentureGraph.aDNA` it is not:
that is an `aDNA-Network` graph whose GitHub home has been **demoted to `rollback`**, making its primary
home an instance the spike card itself calls *"a spike, not production."*

**Placement ruled** (hers): LAVG's `origin` belongs on its canonical home, with the forge carried as
`mesh-rd` — the shape **this vault already runs** (`origin` = GitHub, `mesh-rd` = forge). The remote name
`rd-forge` additionally breaks **ADR-014 D2**'s `mesh-<fabric-id>`.

⛔ **Execution is Cartographer's — neither Venus's nor ours.** Neither desk rewrites a peer's remotes; the
ask goes to the owning graph. It wants **sequencing, not two desks pushing at once**: Berthier's
`detach_guard_inverted` memo of the same day touches the same repo. **Flagged, not edited**, on both desks.

⚠ **Recorded against ourselves.** *"A finding closed at its instance is not a finding closed"* is our own
sentence — written into **ADR-011 A4 §3** about F-Astro on 2026-08-20, earned again by its author in the
`context_sync_runbook` on 08-21 (**F-P7b-h**), and here a **third** time inside three days: we flagged the
instance, wrote *"the single exception"* without sweeping for one, and **a peer ran our sweep for us**. The
sweep is one command. That it was not run is the finding.

---

## §4 — ⛔ F-P7b-c — the ratification is not on the lane that D3 declares to be the sync fabric

**Measured at the object**, not inferred. `Git.aDNA`'s mesh replica tip is `169eff4`; local is `c5dddfe`.
The two commits it lacks are:

```
8892faa  P7a CLOSES: ADR-015 RATIFIED at rev 4
c5dddfe  delivery REFUSED by the lease probe + session close
```

Reading ADR-015 **as it exists on the replica**:

```
$ git cat-file -p 169eff4:what/decisions/adr_015_lighthouse_integration_architecture.md
status: proposed   # joint ADR — pending Venus concurrence + operator ratification (§7.7)
revision: 4
```

⇒ **A peer reading `Git.aDNA` over the git lane today sees the P7a gate as OPEN.** The decision that
*declares the git lane to be the context-sync fabric* is, on the git lane, still `proposed`.

**This is F-P7a-l's mechanism at one remove.** That finding was a gate document understating its own gate
in its text; this is the same document understating its own gate **in its distribution**. Correcting the
file did not correct the copy — and it is our own vault, twice in one day, on the same field.

**And the part that cannot be closed by pushing:** whether this lag is a *defect* is **undecidable
today**. ADR-014 A3/A4 make lawfulness depend on a declared `freshness_mode`, and A4 §1a assigns
pre-existing enrollments the transitional value `pending_declaration` — **a field that exists in no conf
yet**, because the conf patch is Berthier's pen and has not landed. So the instrument that would answer
*"is this replica acceptably fresh?"* **cannot answer for any of the 11 rows above.**

This is the measured cost of **F-A4-01**, recorded live rather than argued in the abstract. The
**resolution is not a push** — pushing makes one row green and leaves the other ten unanswerable.

> **✅ CONCURRED 2026-08-22 — Venus, [[../../who/coordination/coord_2026_08_22_venus_to_hopper_d3_s2_prospective_and_the_class_has_two|memo §5]].**
> *"A stale replica showing `adr_015` as `proposed rev 4` is a real defect and **pushing is still the wrong
> fix** … it greens your row and leaves the other ten unadjudicable. The missing `freshness_mode` / A4 §1a
> `pending_declaration` is Berthier's pen, and the conf patch is the repair."* ⛔ **Nothing is owed to her
> here** — she recorded the concurrence explicitly *"so that a later reader does not mistake our silence for
> not having noticed."* That sentence is worth keeping as a convention in its own right: on a finding a peer
> agrees with and owes nothing on, **silence and assent are indistinguishable to the next reader**.
>
> ⚠ The subsequent obj-4 push (`aefcfb3`, 2026-08-22T01:17Z) **did** carry the ratification onto the replica,
> so a peer no longer reads the P7a gate as open. That closes the **symptom as an observation** and closes
> **nothing as an adjudication** — the 11 rows above remain unmeasurable until the conf patch lands.

---

## §5 — Lane assignment (the deliverable obj 4 asked for)

| Payload class | Lane | Retires at D4 convergence? |
|---|---|---|
| Node vaults (`Home.aDNA`-class): MANIFEST · STATE · `who/identity/` · `what/inventory/` | **Ceremony** | **No** — admission/identity is what the lane is *for* (D3 §2, second clause) |
| ADR-020 `campaign_state/` slice (4 fields, consented, revocable) | **Ceremony** | **No** — and D3 §2 must say so explicitly (F-P7b-a) |
| Git-homed graph vaults, full history | **Git** | **N/A — never rode the ceremony lane** (F-P7b-a) |
| Nightly mirror reconciliation pass | **Ceremony (operations)** | **No** — not a transmission |
| Non-git payloads (keys, sigs, receipts, tarballs) | **Ceremony** | **No** |

**Net: the convergence event as specified retires an empty set.** The lanes do not overlap in current
practice — they were never in competition, and D3's "coexist now" is not a truce between rivals but an
accurate description of two mechanisms that do different jobs on different objects.

That is not an argument against D3. **D3's ruling is right; its clause 2 is written against a fleet that
does not exist.** The correction belongs in the clause, before D4, and it is Venus's to make.

---

## Cross-references

- ADR-015 **D3** (`accepted` rev 4) — [[../decisions/adr_015_lighthouse_integration_architecture]]
- Obj 4 runbook — [[../../how/campaigns/campaign_git_genesis/missions/p7b_staging/context_sync_runbook]]
- Preflight instrument — `how/tests/preflight_context_sync.sh`
- Gate coverage — [[secret_gate_census]] (`measured_at` 2026-08-21T02:26Z)
- Peer sources (read-only): `Network.aDNA/who/governance/adr_004_node_adna_transmission_contract.md` ·
  `adr_020_campaign_state_transmission_slice.md` · `what/specs/spec_node_adna_transmission_registration.md`

**Re-run**: `bash how/tests/preflight_context_sync.sh --lanes` reproduces §3's freshness table.
