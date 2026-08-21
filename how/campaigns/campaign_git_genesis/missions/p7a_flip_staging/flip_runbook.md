---
type: runbook
runbook_id: p7a_flip_runbook
campaign: campaign_git_genesis
phase: R3/P7a
title: "The Flip — R&D forge onto git.rd.adna.network + TLS, and the §2.7 retirement that follows"
created: 2026-08-19
updated: 2026-08-21
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
tags: [runbook, p7a, flip, root_url, no_reply_address, tls, caddy, dns, adr_015, adr_038_s2_7, redirect_free, allow_private, name_allowlist, probe_contract, f_f25, ca_custody, regency_p1, f_k_04, f_k_05, staged]
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

**The authority for every requirement below is [[../../../../../what/decisions/adr_015_lighthouse_integration_architecture|ADR-015 rev 4]],
⛩ which is `accepted` — RATIFIED 2026-08-21** (Venus's concurrence delivered S392 and extended to
rev 4; operator §7.7 the same sitting). **Ratification changed no D**, so nothing in this document
moved with it.

> *As-was, kept rather than rewritten:* through 2026-08-20 this paragraph read *"which is `proposed`
> … staged against an unratified ADR **by design**: it exists so the ADR can be ratified knowing what
> its D1 actually costs to execute."* **That design worked and is worth preserving as a record** —
> the runbook was written first, the ADR was ratified second, and the ratifier knew D1's execution
> cost because this document existed. The standing clause survives ratification unchanged: **if a D
> ever moves, this document changes with it before anything fires.**

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

**Update 2026-08-20 (ADR-015 rev 4).** Two changes, from two peers who both *accepted* rev 3 and both
handed back a defect in it.

1. **The verification bar this lane owns could not fail.** §2 and §5 measured "redirect chain: empty",
   which under `follow_redirects=False` is empty by construction — the column passed on the exact
   failure it existed to catch (**F-F25**, Ilmarinen). §2's table and §5's row 1 now test **status
   exactly, and `Location` absent**, and §2 carries two controls on the instrument itself, including a
   **live `303`** measured one path segment from our own corpus. Binding definition: ADR-015 §D1.5b.
   The struck column is named as struck in three places so nobody restores it.
2. **§1 gains P6–P8** (and P2 is corrected): four capabilities D1/D4 assign to Network that **do not
   exist yet** — resolver, fabric-id registry, `forge` service class, and a CA of the right class.
   Venus raised all four about her own lane; each was re-verified at source. See **§1c**. They block the
   flip, not the ADR.

Still nothing fires. §3, §4, §6, §7 and §8 are unchanged.

---

## §1 — Preconditions (eight; P1–P4 + P6–P8 before §4 opens, P5 before §6b)

**The two `⛔` rows are `⛔` for opposite reasons and must not be collapsed into one class.** P3 is
unrepairable — get it wrong and no later config fixes it. P5 is perfectly repairable but **undated and
owned by another vault** — it cannot be scheduled, only waited on. P1–P4 and P6–P8 gate the flip
itself; **P5 gates only the `allow_private` limb of the §2.7 restore** and does not hold up §2–§5.

**P6–P8 are additions of 2026-08-20** and are a different kind again: they are not risks to manage but
**capabilities that do not exist yet**, three of which ADR-015 assigns to Network as though they did.
They block the *flip*; they do **not** block the ADR's binding. Venus said so first and said it about
her own lane; the facts below were re-verified at source here. See §1c.

| # | Precondition | Lane | Verify by |
|---|---|---|---|
| P1 | `git.rd.adna.network` resolves **mesh-internal only** — no public A/AAAA for any R&D-window forge (D1.1) | Venus | resolve from a mesh member (expect the mesh addr) **and** from off-mesh (expect NXDOMAIN/no answer) |
| P2 | A browser/git-client-valid cert for the name exists; **no per-client insecure-skip flags, ever** (D1.3) | Portunus | `openssl s_client` chain validates against the default trust store, or against a **Network-operated X.509 CA anchor distributed via Home.aDNA — a CA distinct from the Nebula mesh CA, which cannot issue this class of certificate** (see §1c). ⛔ **If the fallback is the path, it is not merely expensive — it is GATED, and the gate has not opened in thirteen attempts. Read §1d before scheduling against it.** |
| P3 | ⛔ **`NO_REPLY_ADDRESS = noreply.10.43.0.28` pinned explicitly in `app.ini`** | Ilmarinen | key present with that literal value — see §1a |
| P4 | §2 pre-state captured **through the current path**, before Caddy exists | Ilmarinen | the §2 table reproduced **under the §D1.5b test** (status exact **and** `Location` absent), with both instrument controls fired — **not** the struck "redirect chain" column |
| P6 | **A mesh-internal resolver for `git.rd.adna.network` exists** (D1.1) | Venus | see §1c — Nebula ships no DNS, and the `adna.network` records that exist today are public |
| P7 | **A fabric-id registry exists and has issued `rd`** (D1.1) | Venus | see §1c — D1.1's `<subnet>` currently has no issuer |
| P8 | **The `forge` service class exists in Network's vocabulary** (D4) | Venus | see §1c — D4 does not classify a node into an existing vocabulary; it creates the vocabulary |
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

### §1c — P2 and P6–P8: four things this runbook assumed Network had

Added 2026-08-20. **Venus raised all four about her own lane, and each was re-verified at source here
before it was written down** — a peer volunteering that our ADR assigns them capabilities they do not
have is exactly the input a flip window needs, and it deserves to be recorded as evidence rather than
as a courtesy. None of it blocks ADR-015's binding. All of it blocks the flip.

| # | What D1/D4 assumes | What is actually there | Consequence for scheduling |
|---|---|---|---|
| **P2** | "fallback: a Network-operated internal CA" — as though one were in hand | The CA Network operates is the **`Lattice Mesh CA`** (`267978824feba1…`), a **Nebula** CA managed by `nebula-cert`. It signs mesh host certs and **cannot issue browser/git-client-valid TLS**. | The fallback is **standing up a second CA of a different class** — key custody, rotation ceremony, trust-anchor distribution. Prefer **ACME DNS-01**, which needs **no public `A` record** (TXT `_acme-challenge`) and so does not conflict with D1.1. ⛔ **And it is gated — §1d.** |
| **P6** | `git.rd.adna.network` resolves mesh-internal | **Nebula ships no DNS.** The `adna.network` A records that exist (`lighthouse`, `wga-lh`, `community`) are **public** — the opposite of what D1.1 requires. | A resolver has to be built or chosen. Until then P1 cannot be satisfied, and the temptation is to satisfy it with a public record, which breaks D1.1 permanently. |
| **P7** | `<subnet>` is "the fabric-id already in use" | **No registry.** `fabric_id` governs nothing; nothing has issued `rd`. | `git.rd.adna.network` is a name we chose, not a name that was allocated. Fine for one forge; not fine as the scheme D1.1 claims it is. |
| **P8** | D4 places the forge in the **`forge` service class** | `service_class` is **empty across Network's `what/`**. | D4 does not classify a node into an existing vocabulary — **it creates the vocabulary**. That is a decision on Venus's lane, not a lookup. |

**Why these are in the runbook and not in the ADR.** They are preconditions on execution, not defects in
the decision — D1.1's requirement (mesh-internal only) and D4's placement stay correct whether or not the
machinery exists yet. Putting them here keeps the ADR's rev-4 delta narrow enough that Venus's rev-3
concurrence extends over it, and puts the work where someone scheduling a window will actually read it.

### §1d — P2's fallback is not merely expensive. It is gated, and the gate has not opened in thirteen attempts.

Added 2026-08-21 (**Venus's E2**, offered as an addition to her rev-4 concurrence). **She offered two
homes for it — one sentence in D1.3, or here — and stated no preference.** It is here for two reasons:
this is where the person scheduling a window reads, which was our own argument back to her; and folding
it into D1.3 would have **moved the object at the ratification instant**, which is the exact F-P7a-b
class this campaign has filed three revisions running. ⛔ **Do not promote this into D1.3 later.** The
decision it qualifies is ratified; this is a cost, not a clause.

**Every fact below was verified in `Network.aDNA` at source, not transcribed from her memo** — and doing
so caught a drift, recorded in the last row.

| Fact | Source (read-only, `~/aDNA/Network.aDNA/`) |
|---|---|
| The existing root is **plaintext** — `NEBULA ED25519 PRIVATE KEY`, 174 b, `0600 stanley:admin`, unmodified since 2026-04-05 | `CHANGELOG.md` `[0.1.321]` (Regency **P0**, S353, 2026-08-07 — run **on the CA host**) |
| It exists in **exactly one place** — no Time Machine destination, no APFS snapshot, no external media — across **four independent search methods**. Host = a **daily-driver MacBook Pro**. | same — **F-K-04 confirmed in its hardest form** |
| fp `267978824feba1…`, key `/opt/homebrew/etc/nebula/pki/ca.key` (`0600 stanley`), wall **2028-04-04** | `what/network/access/access_inventory.md:282` |
| **F-K-05** — `nebula-cert ca -encrypt` **cannot be retrofitted**, so the existing root cannot be hardened in place | `CHANGELOG.md` `[0.1.321]` |
| ⭐ **The turn her memo did not carry: FileVault is ON, and that makes the LOSS case *worse*.** It is the key's only at-rest protection — theft posture genuinely improves, but a failure costing the FileVault key/recovery renders the CA **unrecoverable even holding the physical disk**. | same |
| **CA custody requires an explicit operator ruling before build.** The S380/S381 silence-grant is **scoped**: silence grants build authority for High-confidence items only; anything touching minors, legal exposure, **or CA custody** needs an explicit ruling first. | `STATE.md:230` |
| **D6 was GATED ×2**, one precondition being *"the Regency P1 root-custody ceremony completes **BEFORE** any intermediate is minted"* — and **D6 was only an *intermediate* mint.** A second **root** of a different class sits squarely inside that ruling. | `how/gates/gangway_phase_a_decision_package_s380.output.json:19` |
| ⚠ **Second authority**: PercySleep holds CA write authority until Waypoint M5. P0 measured **the file, not the authority graph**. | `STATE.md:432` |
| ⛔ **CORRECTION — the count is 13, not 12.** | `STATE.md:46` — *"P1 (helper-present; **13th** no-key NO-GO)"*; S382 recorded #12 (`STATE.md:247`) |

**On the correction.** Her memo says **twelve**, and twelve was **accurate when she wrote it**. Her own
STATE has since recorded a thirteenth no-key NO-GO. This is **F-DECL-03 exactly** — *a measurement
recorded without its timestamp is a claim with a hidden expiry* — and the only reason it did not enter
this runbook stale is that we re-read her records instead of copying her prose. **No fault attaches to
her; the finding is about transcription, and it is the practice this vault adopted from Pythia two days
ago paying for itself.** Note the 13th is logged *helper-present* — the blocker's shape has changed even
though its verdict has not.

**⚠ One thing that does NOT transfer, stated so nobody imports it wrongly.** F-S353-01 — `nebula-cert ca
-encrypt` refuses non-interactive input, so Regency P4 needs the operator at a real TTY — is
**`nebula-cert`-specific**. A second CA of the X.509 class is a different toolchain and inherits none of
it. Cite it about the *existing* root only.

**The scheduling consequence, in her words rather than ours:**

> a window budgeted for *"real work on Venus's lane"* is budgeted wrong if the real work is *"real work
> behind an operator gate that has not opened in twelve attempts."*

⛔ **This changes no decision.** DNS-01 stays preferred; the binding TLS requirement — client-valid on
443, **no per-client insecure-skip flags, ever** — holds either way; and **her concurrence was never
conditioned on any of it**. What it changes is the number a flip window is scheduled against. Choosing
the fallback means **minting a second root beside a first that has no hardware custody, behind a ceremony
deferred thirteen times, under a ruling that requires the operator to speak before the build starts.**

---

## §2 — Pre-state capture (before Caddy exists)

Exactly **one** of the 15 repos is public — `adna-commons/exchange-proof` — so that repo *is* the entire
anonymous surface, and this is the whole probe. Anonymous `GET`, **no redirect following**:

| Path (raw-fetch shape `branch/<branch>/<path>`) | Expect status | Expect `Location` header |
|---|---|---|
| `README.md` | **exactly** `200` | **absent** |
| `manifest.json` | **exactly** `200` | **absent** |
| `index.json` | **exactly** `404` | **absent** |

> **⚠ Why this table no longer has a "redirect chain" column (F-F25, Ilmarinen, 2026-08-20).** It used
> to, and the column **could not fail**. Under `follow_redirects=False` the chain is empty by
> construction — httpx's `response.history` is `[]`, curl's `%{num_redirects}` is `0` without `-L`.
> **A redirect is not a chain here; it is a 3xx status with a `Location` header.** The old column would
> have recorded "empty" and passed on exactly the failure this probe exists to catch. Do not
> reintroduce it, and do not write the falsifiable test *underneath* it — a column that cannot fail must
> not survive in a table someone executes at an awkward hour. Binding definition: ADR-015 **§D1.5b**.

**Both halves, per row.** A `200` carrying a `Location` is not a pass; a `303` with the right body is
not a pass.

**⚠ Two controls on the instrument itself — run them or the rows mean nothing** (ADR-015 §D1.5b):

- **Positive control.** `GET /aDNA-Commons/exchange-proof/raw/main/README.md` — the `main/` shape, not
  `branch/main/` — must return **`303`** with `Location: …/raw/branch/main/README.md`. That is a live
  canonicalisation bounce on the raw-fetch family, one path segment from our corpus, measured
  2026-08-20. It must be seen to **fail** the test above before any row in the capture is trusted. *A
  guard that has only ever passed is untested.*
- **Anonymity self-check.** `GET /api/v1/user` must return **`401`**. Otherwise every row measured the
  wrong client.

**The 404 is deliberate and is not optional.** A probe that only requests files that exist cannot
detect a canonicalisation bounce on the ones that don't — trailing-slash 303s and canonical-host
redirects surface on misses first. Any probe run in §5 that omits the miss has not tested the contract.

Captured today the contract holds trivially, because nothing is proxying. That is the point: §2 is the
**baseline**, and §5 is the same three requests through Caddy expected to return the same three rows.

> Ilmarinen has offered to re-run these probes at the window as the pre-state capture. **Take him up on
> it** — a baseline captured weeks before the change is a claim, not a control. Accepted; it is built as
> `Forgejo.aDNA/what/deploy/capture_flip_prestate.sh` (read-only, anonymous, no-follow, both controls
> above carried in-tool). **An instrument test is never promoted to a baseline by renaming it**: a run
> taken to prove the tool works stays labelled that way, and only a capture taken *at the window* is a
> control.

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
   **⚠ Note the out-clause was unverifiable until 2026-08-20**: under §2's struck "redirect chain"
   column, a `:80` `301` that *did* reach the probe would have recorded "empty" and passed. The hazard
   was named here and undetectable in §5 at the same time. Discharge it only against the §D1.5b test.
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
   one **`404`**, each with **no `Location` header** — status *exactly* the expected code **and**
   `Location` absent, both halves, per row (ADR-015 §D1.5b). Not "works in a browser" — a browser
   follows redirects and will hide the exact failure this probe exists to catch. Use a client with
   `follow_redirects=False`, shaped like the Exchange's anonymous fetcher. **Run §2's two instrument
   controls in the same pass**: the `main/`-shape request must still return `303` + `Location`, and
   `/api/v1/user` must still return `401`. A capture whose positive control did not fire is unproven
   for that run, whatever the three rows say.
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
