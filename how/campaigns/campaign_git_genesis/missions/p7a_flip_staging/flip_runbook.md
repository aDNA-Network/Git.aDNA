---
type: runbook
runbook_id: p7a_flip_runbook
campaign: campaign_git_genesis
phase: R3/P7a
title: "The Flip — R&D forge onto git.rd.adna.network + TLS, and the §2.7 retirement that follows"
created: 2026-08-19
updated: 2026-08-19
last_edited_by: agent_stanley
authored_at_tier: fable
status: staged                    # ⛔ NOTHING IN THIS DOCUMENT HAS FIRED. Firing = an operator gate, per lane.
binds_adrs: [adr_015, adr_010, adr_014, adr_008, adr_011]
target_instance: aDNA-Labs R&D Node (Nebula 10.43.0.28) — Forgejo 15.0.6 LTS, mesh-only
target_name: git.rd.adna.network
lanes:
  forge: ilmarinen (Forgejo.aDNA)          # app.ini, restart, DB reads
  network: venus (Network.aDNA)            # DNS zone, fabric-id registry, resolver
  tls: portunus (Caddy.aDNA)               # Caddyfile, cert issuance
  guard: exchange_triad (Exchange.aDNA)    # ADR-038 §2.7 restoration
  standard: grace_hopper (Git.aDNA)        # this document; the contract it enforces
tags: [runbook, p7a, flip, root_url, no_reply_address, tls, caddy, dns, adr_015, adr_038_s2_7, redirect_free, allow_private, name_allowlist, staged]
---

# The Flip — `git.rd.adna.network` + TLS, and the §2.7 retirement that follows

## §0 — Read this first: who owns what, and what has fired

**Nothing here has fired.** No config edited, no cert issued, no DNS record written, no restart. This
document is the staged sequence for a change that crosses **four lanes**, and no lane's steps are
executed by the lane that wrote them.

| Lane | Owner | Steps |
|---|---|---|
| Standard / contract | **Hopper** (this vault) | authored the sequence; owns the redirect-free contract and the verification bar. Executes nothing. |
| Network | **Venus** | the name, the zone, the fabric-id registry, the resolver (ADR-015 D1.1). |
| TLS front | **Portunus** (Caddy brick) | Caddyfile, binds, `:80` disposition, cert issuance. |
| Forge | **Ilmarinen** | `app.ini`, the restart, the DB reads. His hands, his tempo, M08's schedule. |
| Egress guard | **Exchange triad** (Hermes) | restores ADR-038 §2.7 — **after** §5 passes, never before. **Two gates**: §6a's three controls on §5 alone; `allow_private` (§6b) additionally on **P5**, which is theirs and undated. |

**The authority for every requirement below is [[../../../../../what/decisions/adr_015_lighthouse_integration_architecture|ADR-015 rev 3]],
which is `proposed` — Venus's concurrence and operator §7.7 are both outstanding, and both now apply
to rev 3.** This runbook is
therefore staged against an unratified ADR **by design**: it exists so the ADR can be ratified knowing
what its D1 actually costs to execute. If ratification changes a D, this document changes with it
before anything fires.

**Provenance of the measurements.** Every live value cited here was measured by Ilmarinen in a
read-only, zero-mutation audit of the instance on 2026-08-19
([[../../../../../who/coordination/coord_2026_08_19_ilmarinen_to_hopper_d15_flip_audit_from_the_instance|memo]]).
Two of his three named expectations were wrong before he probed; that is why this runbook exists in
this shape rather than as "edit four keys and restart."

**Update 2026-08-19 (ADR-015 rev 3).** The **egress guard lane's exit is no longer one act.** Hermes
verified in Exchange code that the §2.7 restore, as this runbook first staged it, is **unsatisfiable**:
restoring `allow_private = False` for a mesh-internal name is refused by the guard's own check order,
allowlist or not ([[../../../../../who/coordination/coord_2026_08_19_hermes_to_hopper_adr015_egress_precondition|memo]]
· ADR-015 §D1.5a). §1 therefore carries a **fifth precondition** and §6 is split in two. Nothing else
in the sequence moves — §2–§5 are unchanged.

---

## §1 — Preconditions (five; P1–P4 before §4 opens, P5 before §6b)

**The two `⛔` rows are `⛔` for opposite reasons and must not be collapsed into one class.** P3 is
unrepairable — get it wrong and no later config fixes it. P5 is perfectly repairable but **undated and
owned by another vault** — it cannot be scheduled, only waited on. P1–P4 gate the flip itself; **P5
gates only the `allow_private` limb of the §2.7 restore** and does not hold up §2–§5.

| # | Precondition | Lane | Verify by |
|---|---|---|---|
| P1 | `git.rd.adna.network` resolves **mesh-internal only** — no public A/AAAA for any R&D-window forge (D1.1) | Venus | resolve from a mesh member (expect the mesh addr) **and** from off-mesh (expect NXDOMAIN/no answer) |
| P2 | A browser/git-client-valid cert for the name exists; **no per-client insecure-skip flags, ever** (D1.3) | Portunus | `openssl s_client` chain validates against the default trust store, or against the Network CA anchor distributed via Home.aDNA |
| P3 | ⛔ **`NO_REPLY_ADDRESS = noreply.10.43.0.28` pinned explicitly in `app.ini`** | Ilmarinen | key present with that literal value — see §1a |
| P4 | §2 pre-state captured **through the current path**, before Caddy exists | Ilmarinen | the three-request table in §2 reproduced |
| P5 | ⛔ **The Exchange's name-allowlist exemption is built and released** — allowlist membership makes the private-address check conditional, replacing the global `allow_private` flag (ADR-015 §D1.5a) | **Hermes** (Exchange) | an **allowlisted** name resolving to an RFC1918 mesh address passes the guard with `ADNA_EXCHANGE_EGRESS_ALLOW_PRIVATE` unset/`False` — and an **unallowlisted** one still fails. Both halves, or it is not the control we asked for. See §1b |

### §1a — P3 is the one step with no undo. Read this before scheduling anything.

`NO_REPLY_ADDRESS` is **absent** from the live `app.ini`, so Forgejo derives it as `noreply.<DOMAIN>`.
Three of five users carry `keep_email_private`, and their commits are **already authored** as
`<user>@noreply.10.43.0.28` — that string was read out of a live push payload and six activity records.

**Git objects are immutable.** Those addresses are in the repositories' history permanently. Forgejo
maps *commit author → user account* by matching that suffix. So if `DOMAIN` moves while
`NO_REPLY_ADDRESS` is still derived from it, **every pre-flip commit by those three users stops
resolving to its author**, and no later config change repairs it — the data is in the git objects, not
the database.

Pinning the old suffix explicitly costs one line and keeps it valid forever; new commits keep using it.
An IP literal living on in a config key is mildly ugly. A silently broken author map is worse, and it
is permanent.

> **Confidence marker, carried from source rather than smoothed away.** The config derivation and the
> user counts are **measured first-hand**. The author-resolution mechanism is **documented upstream
> behaviour** — nobody flipped a live forge to prove it, and nobody should. Treat P3 as
> high-confidence, not as witnessed. It is cheap enough that being wrong about the mechanism costs
> nothing, and being right about it and skipping the step costs the author map.

**P3 may land in its own window, earlier than the flip. It must not land later.**

### §1b — P5 has no date, and this runbook does not invent one.

P5 is not a step anyone here can schedule. The Exchange is in Tier-0-complete watch-state; the work is
unscheduled and **watch-state does not imply build capacity** (their SO-6, stated plainly and taken at
face value). Hermes committed to the *shape*, not to a date, and we are not going to record a date
they did not give.

**What P5 gates, precisely.** Only the `allow_private = False` half of §6. The flip (§3–§4), the
verification bar (§5), and the three-control restore (§6a) are all reachable without it.

**If the flip window arrives before P5 does**, exactly two dispositions are lawful — pick one
explicitly, in writing, at the §6 gate:

| | Disposition | What it costs |
|---|---|---|
| **(a)** | Hold `ADNA_EXCHANGE_EGRESS_ALLOW_PRIVATE = True` as a **named, dated exception** with an owner, recorded in the disposition ledger | the private range stays open on **both** lanes (`REMOTE` *and* `SUBSCRIBE` — the flag has no lane prefix), for a stated interval, visibly |
| **(b)** | The flip waits for P5 | the IP-literal HTTP surface and the *whole* four-part downgrade persist meanwhile — strictly worse than (a) on every control |

⛔ **What must not happen is the third thing:** restoring all four controls together because the ADR
once said "as one unit." That configuration **refuses the fetch**. The §5 probe would have already
passed — it runs against the pre-restore policy — so the breakage lands after the flip, at the
Exchange, and **presents as a Caddy fault**. An hour would go into the wrong lane before anyone read
`egress.py`.

*(Not a hypothetical: this runbook staged the unitary restore, and ADR-015 specified it through two
revisions, until Hermes read our `STATE.md` on his own recon sweep and checked the code. Neither
gating party could have caught it — the failure lives in a third vault's implementation.)*

---

## §2 — Pre-state capture (before Caddy exists)

Exactly **one** of the 15 repos is public — `adna-commons/exchange-proof` — so that repo *is* the entire
anonymous surface, and this is the whole probe. Anonymous `GET`, **no redirect following**:

| Path (raw-fetch shape `branch/<branch>/<path>`) | Expect status | Expect redirect chain |
|---|---|---|
| `README.md` | `200` | **empty** |
| `manifest.json` | `200` | **empty** |
| `index.json` | **`404`** | **empty** |

**The 404 is deliberate and is not optional.** A probe that only requests files that exist cannot
detect a canonicalisation bounce on the ones that don't — trailing-slash 303s and canonical-host
redirects surface on misses first. Any probe run in §5 that omits the miss has not tested the contract.

Captured today the contract holds trivially, because nothing is proxying. That is the point: §2 is the
**baseline**, and §5 is the same three requests through Caddy expected to return the same three rows.

> Ilmarinen has offered to re-run these probes at the window as the pre-state capture. **Take him up on
> it** — a baseline captured weeks before the change is a claim, not a control.

---

## §3 — The TLS front (Portunus)

Caddy terminates HTTPS on 443 on the forge's own data-plane box, reverse-proxying to the mesh-bound
Forgejo HTTP listener. `:443` and `:80` are both free (measured). Four requirements, three of which are
Caddy defaults working against us:

1. **Name the binds explicitly.** Every live listener on the box is `127.0.0.1` + `10.43.0.28` only,
   never `0.0.0.0`. **Caddy's default site address binds all interfaces** — bind discipline is *not*
   inherited. The Caddyfile must state `127.0.0.1` + the mesh addr. Omitting them converts a mesh-only
   forge into a publicly-bound one, which is exactly what Network's §8 posture and the Am6 hardening
   forbid. **Verify by listener enumeration after Caddy starts, not by reading the Caddyfile.**
2. **Decide `:80` explicitly.** Caddy's automatic-HTTPS claims `:80` and answers with an HTTP→HTTPS
   **301** — the precise redirect class §5's contract forbids. The flip points the Exchange's fetcher
   at `https://` directly so it should never traverse `:80`, but a contract that survives only because
   nobody exercises the hazard is not a satisfied contract. Either disable the `:80` listener or
   document why a 301 there cannot reach the fetcher.
3. **Transparent proxy — no rewrites.** No canonical-host redirect, no trailing-slash normalisation, no
   http→https upgrade hop on the HTTPS vhost. The fetcher sets `follow_redirects=False`; any redirect
   is a breaking change, not a nuisance.
4. **SSH is not proxied.** The Forgejo built-in sshd on `:2222` is a **declared non-seam** (ADR-015 D1.4,
   Forgejo.aDNA §B). Caddy never fronts it. If a step here mentions SSH, that step is wrong.

---

## §4 — The coordinated config event (Ilmarinen)

**One window. Four keys.** The restart is a **fleet-pull outage** (Forgejo.aDNA D-9) — scheduled, never
opportunistic, and announced to the nightly-push lane so a replica push does not land inside it.

| Key | Live | Post-flip |
|---|---|---|
| `PROTOCOL` | `http` | `https` |
| `DOMAIN` | `10.43.0.28` | `git.rd.adna.network` |
| `ROOT_URL` | `http://10.43.0.28:3300/` | `https://git.rd.adna.network/` |
| `SSH_DOMAIN` | `10.43.0.28` | `git.rd.adna.network` |

**Do not move**, and named here so no sweep "tidies" them:

- `HTTP_PORT = 3000` — container-internal, behind the `:3300` publish.
- `SSH_PORT = 2222` — L4-direct, the declared non-seam.
- `LOCAL_ROOT_URL` — **absent**, defaults to `http://localhost:3000/`. Container-internal and
  unaffected, so Forgejo's internal API calls never straddle the two names. This was the failure mode
  the clause was written to guard; it is measured closed.
- `DEFAULT_ACTIONS_URL = https://code.forgejo.org` — external.
- `NO_REPLY_ADDRESS` — **pinned at P3 and left pinned.** It does not follow `DOMAIN`. That is its job.

**Not flip steps** (both were suspected and both measured out):

- **Webhooks** — `webhook` table = 0 rows. Nothing to re-point.
- **Runner registration** — `.runner` holds `"address": "http://forgejo:3000"`, the compose service
  name. The runner registers against neither `ROOT_URL` nor the box address, so `ROOT_URL` flips
  without touching it. *(An earlier finding that the runner rejected re-pointing at `10.43.0.28:3300`
  was about changing a registration address — a different operation. It does not imply a `ROOT_URL`
  dependency.)* Note separately that `runs-on` labels are registered server-side in `.runner` state:
  **relabelling requires re-registration**, never an in-place config edit (ADR-008 A1).
- **OAuth apps** — three exist (`tea`, `git-credential-oauth`, `Git Credential Manager`), all
  Forgejo built-in first-party clients auto-created by the DB migration at first start. All redirect to
  the **client's** loopback, so they are decoupled from `ROOT_URL` by construction. ⚠ The standing
  sentence is *"three exist and all are loopback-by-design"*, **not** *"there are none"* — a future
  **operator-created** app would store an absolute redirect URI and would become a flip step. Re-check
  at production when the D2 OIDC path lands.

### §4a — Sequencing against the replica fabric

`ROOT_URL`/`SSH_DOMAIN` also determine the clone URLs the fleet's `mesh-rd` remotes and CI checkouts
resolve. Sequence with Ilmarinen so **replica remotes and CI checkout URLs never straddle two names**:
the enrolled vaults' `mesh-rd` remotes are written in alias form (ADR-014 A2 §4), so the SSH leg moves
by editing the alias's `HostName` — *the alias is the stable surface, its HostName is the movable
field*. Any remote still written as a raw `ssh://git@10.43.0.28:2222/…` URL is already non-conformant
fleet-wide and must be converted to alias form **before** this window, not during it.

---

## §5 — Post-flip verification (the bar; Hopper's contract)

**In order. §6 does not open until every row passes.**

1. **The fetcher-shaped probe, through Caddy.** The §2 table reproduced field-for-field: two `200`s and
   one **`404`**, all three with an **empty** redirect chain. Not "works in a browser" — a browser
   follows redirects and will hide the exact failure this probe exists to catch. Use a client with
   `follow_redirects=False`, shaped like the Exchange's anonymous fetcher.
2. **Listener enumeration.** `127.0.0.1` + mesh addr only. No `0.0.0.0` on any port, Caddy included.
3. **HTTPS leg — the one-field promise.** A `git/` declaration moves by rewriting only the host field
   to `git.rd.adna.network`; scheme/port collapse to `https`/443 defaults. Clone and push a scratch
   repo over HTTPS.
4. **SSH leg — alias form.** Clone and push via the `git-rd` alias with `IdentitiesOnly yes` and its
   dedicated key, `HostName` now the DNS name. Raw-IP URLs remain non-conformant.
5. **Cert validity with no client-side escape hatch.** No `-k`, no `GIT_SSL_NO_VERIFY`, no
   `insecure_skip_verify` anywhere in the passing path. A leg that only passes with a skip flag has
   failed.
6. **A pushed commit by a `keep_email_private` user resolves to its author in the UI** — the P3 check,
   after the fact. If this fails, P3 was skipped or mis-set, and the window's remaining steps stop
   until it is understood.

---

## §6 — Exchange handoff (only after §5 passes) — **two gates, not one**

The ADR-038 §2.7 downgrade retires **three-part-plus-one** (ADR-015 §D1.5a, rev 3). It was relaxed as
one unit; it does not retire as one. **In all cases the Exchange restores its own defaults — nobody
restores them on their behalf.**

Hand over at §6a: the §5 probe output (all six rows, **including the `404` negative control**) and the
new URL.

### §6a — The three that retire with the flip

`schemes: https` · `ports: {443}` · `allow_ip_literal = False` — restored together, never piecewise
among themselves. The original anti-half-downgrade reasoning holds for these three: partial states
multiply the guard's test matrix and invite a permanent half-downgrade.

Gate: **§5 passed.** No other precondition.

### §6b — `allow_private = False`, gated on P5

**This one cannot retire on §5 alone, and attempting it breaks the fetcher.** The Exchange's guard
consults the allowlist at `egress.py:163` **before** the private-address check at `172-178`, and the
allowlist grants no exemption from it — so an allowlisted mesh-internal name is still rejected as
*"resolves to a non-routable address"*. `git.rd.adna.network` resolves mesh-internal by requirement
(ADR-015 D1.1), so this is not an edge case; it is the normal path.

Gate: **§5 passed AND P5 landed** (the name-allowlist exemption built and released, §1b).

**If §5 has passed and P5 has not**, the §6 gate records **(a)** or **(b)** from §1b explicitly, in
writing, with an owner and a date. A `allow_private = True` carried without that record is the
"unremarked exception" this whole clause exists to prevent — and note it is **process-global**: it
holds the private range open on the `SUBSCRIBE` lane as well, for a `REMOTE`-lane reason.

*(§6b is the only part of this runbook whose completion is not reachable by the four lanes above. That
is stated, not engineered around.)*

---

## §7 — Rollback

Revert the four §4 keys to their live values and restart. The HTTPS leg returns to
`http://10.43.0.28:3300`, the SSH leg's alias `HostName` returns to the IP literal, and whichever
parts of the Exchange's §2.7 downgrade **already retired** must be re-relaxed before its fetcher
recovers — **§6a's three, plus `allow_private` only if §6b fired.** Rolling back after §6a but before
§6b means re-relaxing three, not four; re-relaxing a control that was never restored is a no-op, but
*asserting* you restored four when three moved is the kind of bookkeeping that makes the next incident
unreadable. Say which fired.

**What does not need reverting, and this is the point of P3:** `NO_REPLY_ADDRESS` stays pinned across
both the flip and the rollback. The suffix is decoupled from `DOMAIN` precisely so that neither
direction of travel touches the author map.

**What cannot be rolled back:** nothing in this runbook, *provided P3 landed*. Without P3, the author
map for three users is broken by §4 and rollback does not restore it — the commits authored during the
un-pinned window carry the new suffix in immutable objects. That asymmetry is the entire reason P3 is a
precondition and not a step.

---

## §8 — Stated consequences (accepted, not engineered around)

- **Pre-flip Actions runs are re-run-only-by-pushing-again.** `action_run.event_payload` bakes absolute
  URLs at dispatch (32 keys per payload carry the address, including the `clone_url`/`ssh_url` pair
  `actions/checkout` consumes). New runs re-derive from the current `ROOT_URL` and follow the flip
  automatically; re-running one of the 27 stored pre-flip runs would attempt checkout from an address
  that no longer answers.
- **⛔ Do not rewrite `action_run` (27 rows) or `action` (10).** They are the only two places in the
  entire database holding the IP literal — established by dumping the DB and attributing every match to
  its table, not by guessing which tables to inspect. Both are **historical records**. Rewriting them
  would falsify the audit trail to fix a cosmetic staleness.
- **`[packages]` stays unbound** — an operator gate, and since D-9 a forge restart is a fleet-pull
  outage, so it is scheduled rather than opportunistic. `package` table = 0 rows, consistent with the
  gate being unfired. Out of scope for this window unless the operator folds it in deliberately.

---

## Fire record

*(Empty. Append per-step on execution: date · lane · operator gate · outcome.)*
