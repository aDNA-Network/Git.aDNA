---
type: decision
adr_id: adr_015
title: "ADR-015 — Lighthouse Integration Architecture (addressing/TLS · identity bridge · context-sync · production placement · host-move sequencing)"
status: proposed   # joint ADR — pending Venus (Network.aDNA) concurrence + operator ratification (§7.7), both against rev 4
revision: 4        # rev 4 (2026-08-20) — §D1.5a's probe measurement made falsifiable (F-F25); D1.3's fallback corrected; see §Revision log
created: 2026-08-19
updated: 2026-08-20
last_edited_by: agent_stanley
joint_with: venus (Network.aDNA)
ratifies_at: "operator §7.7 gate + Venus concurrence memo — this is the P7a exit-gate integration ADR"
depends_on: [adr_010, adr_012, adr_013, adr_014]
amends: []
tags: [decision, adr, adr_015, git, p7a, lighthouse, addressing, tls, identity_bridge, context_sync, mesh, egress, allow_private, name_allowlist, probe_contract, falsifiable, f_f25, proposed, operation_free_harbor]
---

# ADR-015 — Lighthouse Integration Architecture

**Status**: `proposed` — **rev 4** (§D1.5a's probe measurement made falsifiable 2026-08-20 — the previous form could not fail; D1.3's fallback corrected against Network's actual CA inventory; see [[#Revision log]]) — the **P7a exit-gate integration ADR** ([[../../how/campaigns/campaign_git_genesis/missions/p7a_integration_architecture|mission card]]), joint with **Venus (Network.aDNA)**. Binding only after (a) Venus's concurrence memo and (b) operator ratification (§7.7). Fixes the four seams ADR-012's open-questions block routed here — addressing/DNS+TLS · identity bridge · context-sync reconciliation · forge placement — plus the fleet host-move sequencing the [[../inventory/disposition_ledger|disposition ledger]] assigned to the P7a block.

## Context

The P7b spike instance is **live**: Forgejo 15.0.6 LTS on the aDNA-Labs R&D Node (Ubuntu, Nebula `10.43.0.28`), mesh-only binds (`127.0.0.1` + mesh addr on 3300/2222, never `0.0.0.0`), 15 repos / 5 users at the 08-18 restore drill, portable CI green on runner label `rd-node` (ADR-008 proven). Access today is **hostname-less**: git-over-HTTP at `http://10.43.0.28:3300` and git-over-SSH L4-direct on `:2222` (Forgejo's built-in sshd — a declared **non-seam**: never proxied through Caddy). That IP-literal HTTP surface forced the Exchange to relax **all four** of its egress-guard defaults at once (ADR-038 §2.7: `http` scheme · port 3300 · private range · IP literal), carried by Ilmarinen's M08 as a **dated** downgrade whose retirement condition is this mission. *(rev 3: they were relaxed as one unit; they do **not** retire as one — see §D1.5a.)* Meanwhile ADR-014 A2 §4 made ssh-config `Host` aliases the fleet law for mesh-forge SSH — while ADR-010 D1's on-ramp premise is "only the `host` field changes." Those two doctrines meet here.

**Constraint inputs (verified at source this session):** Venus's scoped §8 R&D ruling (`Network.aDNA/who/governance/ruling_2026_08_07_scoped_s8_rd_forge.md`) resolves placement *for the R&D window only* (revisit-at-production clause). Forgejo OAuth2 has **no scope enforcement** (Forgejo.aDNA D12 §D.6). The Exchange's anonymous fetcher sets `follow_redirects=False` and consumes the raw-fetch shape `branch/<branch>/<path>`. Exchange ADR-041 (ratified 2026-08-15) fixed `Git.aDNA`'s manifest lane: **public → `aDNA-Commons`**.

## Decisions

### D1 — Addressing & TLS (the two-leg contract)

1. **Name scheme**: each subnet forge is addressed **`git.<subnet>.adna.network`**, where `<subnet>` is the fabric-id already in use by ADR-014 D2 remote naming (`mesh-<fabric-id>`). The R&D fabric's id is `rd` ⇒ the first concrete binding is **`git.rd.adna.network`**. **Network owns the name**: the fabric-id registry, DNS zone, and resolver mechanism are Venus's (ADR-010 D4); Git.aDNA specifies only that the name MUST resolve **mesh-internal only** — no public A/AAAA record for any R&D-window forge. Public DNS ever appearing for a forge surface is a production-phase, operator-gated decision, and then only for read-only surfaces.
2. **TLS termination**: Caddy (the Portunus brick) terminates **HTTPS on 443** on the forge's own data-plane box (co-tenant, per the Am6 hardening posture + the alpha-root cotenancy note), reverse-proxying to the mesh-bound Forgejo HTTP listener. `:443` and `:80` are both free on the box (measured 2026-08-19). Two clauses that **rev 2 promotes from assumption to requirement**, on Ilmarinen's instance audit:
   - **Bind discipline is NOT inherited — it must be written.** Every live listener on the box is `127.0.0.1` + `10.43.0.28` only, never `0.0.0.0`; but Caddy's *default* site address binds all interfaces. The Caddyfile MUST therefore name its bind addresses explicitly (`127.0.0.1` + the mesh addr). A Caddyfile that omits them silently converts a mesh-only forge into a publicly-bound one — the exact posture §8 and the Am6 hardening forbid.
   - **Automatic-HTTPS is a redirect hazard, and D1.5 forbids redirects.** Caddy by default claims `:80` and answers it with an HTTP→HTTPS **301** — precisely the class the redirect-free contract prohibits. The flip moves the Exchange's fetcher to `https://` directly so it should not be exercised, but the contract is one default away from being broken by a config nobody re-read. The `:80` disposition is an explicit decision in the Caddyfile, not a default.
3. **Certificates**: preferred issuance is **ACME DNS-01** against the `adna.network` zone — real certificates for mesh-internal names with zero inbound exposure and zero client trust-store distribution. **DNS-01 requires no public `A`/`AAAA` record**: it validates on a TXT record at `_acme-challenge.<name>`, so the preferred path is compatible with D1.1's mesh-internal-only constraint rather than in tension with it. *(Stated explicitly in rev 4 because rev 1–3 left a reader to reconcile "public ACME" against "no public record" unaided, and the wrong resolution — publishing an `A` record to satisfy the CA — breaks D1.1 permanently.)* Fallback where DNS-01 delegation isn't available: **stand up a Network-operated internal X.509 CA, distinct from the Nebula mesh CA**, with the trust anchor distributed through Home.aDNA's node-inventory channel. Venus co-decides the issuance mechanism; the *requirement* (browser/git-client-valid TLS on 443, no per-client insecure-skip flags, ever) is binding either way.

   **⚠ The fallback is a build, not a fall-back** (rev 4 — **Venus's correction**, re-verified at source here). Rev 1–3 said "a Network-operated internal CA" as though one were in hand. The CA Network operates is the **`Lattice Mesh CA`** (`267978824feba1…`, key at `/opt/homebrew/etc/nebula/pki/ca.key`, expiry 2028-04-04) — a **Nebula** CA, minted and managed by `nebula-cert`. It signs *mesh host certificates* and **cannot issue browser- or git-client-valid TLS**; the two are different certificate classes with different consumers. Choosing the fallback therefore means **standing up a second CA of a different class**, with its own key custody, rotation ceremony, and trust-anchor distribution — real work on Venus's lane, not a switch. This does not change the decision (DNS-01 stays preferred, the TLS requirement stays binding); it changes what the fallback *costs*, which is the number a flip window is actually scheduled against.
4. **The two-leg contract** (reconciles ADR-010 D1 "one-field-swap" with ADR-014 A2 §4):
   - **HTTPS leg** — conforms to the one-field promise: a `git/` declaration moves hosts by rewriting only the host field to `git.<subnet>.adna.network`; scheme/port collapse to `https`/443 defaults.
   - **SSH leg** — stays **L4-direct on 2222** (the Forgejo built-in sshd non-seam; Caddy never proxies SSH). It conforms via **alias form only**: an ssh-config `Host` alias (recommended name **`git-<fabric-id>`**, e.g. `git-rd`) with `IdentitiesOnly yes` + a dedicated key; `HostName` inside the alias moves from IP literal to the D1.1 DNS name once resolvable — **the alias is the stable surface, its HostName is the movable field**. Raw `ssh://git@<ip>:2222/…` URLs remain non-conformant for fleet use (A2 §4).
   The one-field-swap doctrine is therefore **per-leg**: hostname for HTTPS, alias-HostName for SSH. Declarations record both legs.
5. **§2.7 retirement condition (dated, binding on our side of the seam)**: the Exchange's four-part egress downgrade retires **three-part-plus-one** — not as one unit, which **rev 3 corrects** (see §D1.5a). When the TLS front is live and the fetcher's URL flips to `https://git.<subnet>.adna.network/...`, the Exchange restores **`schemes: https` · `ports: {443}` · `allow_ip_literal = False`** together, never piecewise among themselves. The fourth control, **`allow_private = False`, is gated on a separate precondition** — the Exchange's name-allowlist exemption being built and released (§D1.5a) — and restores when that lands, which may be later and has **no committed date**. The front MUST serve the anonymous raw-fetch shape (`branch/<branch>/<path>`) **redirect-free** — the fetcher sets `follow_redirects=False`, so any Caddy-introduced redirect (http→https upgrade hop, trailing-slash 303, canonical-host bounce) is a breaking change; transparent proxying is the contract, verified by a fetcher-shaped probe **before** the Exchange restores its defaults. **That probe corpus retains the deliberate `404` negative control** from the pre-state baseline below — confirmed to Hermes as binding, not a courtesy: a probe that only requests files that exist cannot detect a canonicalisation bounce on the ones that don't.

   ### D1.5a — why `allow_private` is a separate limb (rev 3; the Exchange's ruling, sustained)

   Rev 1 flagged this as a *residual* — *"the Exchange's guard needs a name-allowlist rather than a range re-open; that residual design is the Exchange's call, flagged not decided here."* The Exchange has ruled it, and **objects to the word "residual"** ([[../../who/coordination/coord_2026_08_19_hermes_to_hopper_adr015_egress_precondition|Hermes memo, 2026-08-19]]). The objection is sustained in full, because it is not a preference — it carries code as evidence:

   **The unitary restore is unsatisfiable, and it fails silently in the worst place.** D1.1 requires `git.rd.adna.network` to resolve **mesh-internal only** — today `10.43.0.28`, RFC1918 via Nebula. In `what/exchange/src/adna_exchange/egress.py` the checks run in this order:

   | Line | Check | Result for an **allowlisted** mesh-internal name |
   |---|---|---|
   | `163` | `allow_hosts` membership | **passes** — the name is on the allowlist |
   | `165-166` | `if policy.allow_private: return None` | **skipped** — it is `False` |
   | `172-178` | `resolve()` → `_is_globally_routable()` per address | **rejected** — *"host … resolves to a non-routable address"* |

   **The allowlist is consulted before the private-address check and grants no exemption from it.** So restoring the four controls as one unit does not leave a design question open — **it closes the door the retirement exists to open.** The flip would move the fetcher from working-but-downgraded to hardened-and-broken. Worse for diagnosis: the fetcher-shaped probe this clause (correctly) requires *before* the restore **would pass**, because it runs against the pre-restore policy — so the failure would surface after the flip, at the Exchange, and **would look like a Caddy fault**.

   **A second fact rev 1 did not account for: two of the four controls are process-global.** `ADNA_EXCHANGE_{LANE}_ALLOW_SCHEMES` and `..._ALLOW_PORTS` are **per-lane**; `ADNA_EXCHANGE_EGRESS_ALLOW_PRIVATE` and `..._ALLOW_IP_LITERAL` carry **no lane prefix**. Two lanes build egress policies — `REMOTE` (the forge lane) and `SUBSCRIBE` (webhook targets) — and the scheme/port widening touched only `REMOTE` while the private-range and IP-literal widening **touched both**. The downgrade therefore opened the private range on the subscribe lane for a forge-fetch reason that has nothing to do with it. The Exchange records this as **their own defect, filed against themselves**; it is restated here because it materially strengthens the case against a range re-open and because a reader of this ADR cannot otherwise know the four controls are asymmetric.

   **The shape the Exchange will build** (their call, recorded not specified): allowlist membership makes the private-address check **conditional**, rather than a global flag disabling it — an allowlisted host may resolve to a mesh-private address, an unallowlisted host may not. This keeps SSRF closed against every unvetted name, is **lane-scoped by construction** (the allowlist is per-lane; the flag is not), and leaves the DNS-rebinding residual exactly where it already sits.

   **⛔ The honest bound — no date is committed, and this ADR does not invent one.** The Exchange is in Tier-0-complete watch-state; the work is unscheduled, and watch-state does not imply build capacity (their SO-6). If our flip window arrives before theirs, exactly two dispositions are lawful: **(a)** hold `allow_private = True` as a **named, dated exception** — recorded in the ledger with an owner, never carried unremarked; or **(b)** the flip waits. What must **not** happen is this clause ratifying as four-as-one-unit and the restore being attempted.

   **Probe pre-state (measured 2026-08-19, before Caddy exists).** Exactly one of the 15 repos is public — `adna-commons/exchange-proof` — so that repo *is* the entire anonymous surface. Anonymous `GET`, no follow: `README.md` → `200` · `manifest.json` → `200` · `index.json` → **`404`**. This is the shape the post-flip probe MUST reproduce **through Caddy**, the 404 included: a probe that only requests files that exist cannot detect a canonicalisation bounce on the ones that don't, so the negative control is part of the contract, not a courtesy. *(The rev-2/rev-3 form of this paragraph also recorded "redirect `[]`" against each row. That field is struck — see §D1.5b for why it was unfalsifiable and what replaces it. What is retained above is the historical measurement; the definition of the check now lives in §D1.5b.)*

   ### D1.5b — how the probe decides pass/fail (rev 4; **F-F25**, Ilmarinen's, sustained)

   **The previous measurement could not fail.** §D1.5a's pre-state recorded "redirect `[]`" per row and required the post-flip probe to reproduce it. Under `follow_redirects=False` — the fetcher's own setting, and the only honest way to run this probe — **the redirect chain is empty by construction**: httpx's `response.history` is `[]`, curl's `%{num_redirects}` is `0` without `-L`. **A redirect does not appear as a chain. It appears as a 3xx status with a `Location` header.** So a check written literally against that column returns "empty", and therefore *passes*, on precisely the failure the probe exists to catch.

   **The binding form** — every row of the through-Caddy corpus must satisfy both halves:

   > **status is *exactly* the expected code, AND no `Location` header is present.**

   Neither half alone is the control. A `200` carrying a `Location` is not a pass; a `303` whose body happens to be right is not a pass.

   **⚠ This is the second instance of one class inside this ADR, not an isolated slip.** §D1.5a already establishes that the pre-restore egress probe *passes* on the failure it exists to catch, because it runs against the pre-restore policy. Here the probe passes on the failure it exists to catch because the column it reads cannot vary. Both are instruments that report health in the presence of the exact condition they were built to detect. **Two instances make it a class**, and this ADR is the wrong place to discover the third: any probe added to this contract later must state, at the point of definition, *what result would constitute a failure*.

   **⛔ And it made D1.2's named hazard undetectable at the same time.** D1.2 names Caddy's automatic-HTTPS `:80` **301** as a redirect hazard, and offers an out-clause — *"or document why a 301 there cannot reach the fetcher."* Under the struck column, a `:80` `301`, a trailing-slash `303`, or a canonical-host bounce that *did* reach the probe would still have recorded "empty" and passed. **The hazard was documented and undetectable in the same document.** The out-clause is only discharged by evidence under the §D1.5b form.

   **Positive control (required, and live).** A guard that has only ever passed is untested. Measured 2026-08-20 on this surface, one path segment from the protected corpus:

   ```
   GET /aDNA-Commons/exchange-proof/raw/main/README.md
     -> 303  Location: /aDNA-Commons/exchange-proof/raw/branch/main/README.md
   ```

   A canonicalisation bounce **on the raw-fetch family itself**. It does not touch the current fetcher, which consumes the `branch/<branch>/<path>` shape — and that is precisely why D1.5 specifies that shape rather than leaving it to a caller's convenience. **This request is a required positive control**: it must be issued alongside the corpus and must be observed to fail the §D1.5b test, before any row in a capture is trusted. If it stops returning a `303`, the instrument is unproven for that run, whatever the other rows say.

   **Anonymity self-check (required).** `GET /api/v1/user` must return **`401`** on every run. An authenticated client measures a different surface than the Exchange's fetcher, so without this every row in the capture is a claim about the wrong client.

   **Instrument tests are never promoted to baselines.** A capture taken to prove the tool works is labelled as such and stays labelled; a baseline is a capture taken **at the window**, per D1.5's pre-restore sequencing. Renaming the first into the second is how a claim becomes a control without anyone deciding it should.

   **Forge-side, the flip is a coordinated config event — and rev 2 fixes what it consists of** (Ilmarinen's read-only instance audit, 2026-08-19; every value below measured on the live box, expectations named before each probe ran):

   | `app.ini` key | Live | Post-flip |
   |---|---|---|
   | `PROTOCOL` | `http` | `https` |
   | `DOMAIN` | `10.43.0.28` | `git.rd.adna.network` |
   | `ROOT_URL` | `http://10.43.0.28:3300/` | `https://git.rd.adna.network/` |
   | `SSH_DOMAIN` | `10.43.0.28` | `git.rd.adna.network` |

   **Four keys, not three** — `PROTOCOL` was missing from the rev-1 text. `HTTP_PORT = 3000` and `SSH_PORT = 2222` do **not** move (3000 is container-internal behind the `:3300` publish; SSH stays L4-direct per the declared non-seam). `LOCAL_ROOT_URL` is **absent** ⇒ defaults to `http://localhost:3000/`, container-internal and unaffected — so Forgejo's internal API calls never straddle the two names, closing the failure mode this clause was written to guard. `DEFAULT_ACTIONS_URL = https://code.forgejo.org` is external and unaffected; named here so no sweep mistakes it for an in-scope absolute URL. The window is sequenced with Ilmarinen so replica remotes and CI checkout URLs never straddle two names, and the restart is a **fleet-pull outage** (Forgejo.aDNA D-9) — scheduled, never opportunistic.

   **⛔ Binding precondition — pin `NO_REPLY_ADDRESS` in the flip window or earlier.** `NO_REPLY_ADDRESS` is absent from the live `app.ini`, so Forgejo derives it as `noreply.<DOMAIN>`; three of five users carry `keep_email_private`, and their commits are **already authored** as `<user>@noreply.10.43.0.28` — read first-hand out of a live payload and six activity records. Git objects are immutable, so that suffix is in the repos' history permanently. Move `DOMAIN` and the derived suffix moves with it, and Forgejo's commit-author→user map stops resolving **every pre-flip commit by those three users**, with no config change able to repair it afterwards. Therefore: set `NO_REPLY_ADDRESS = noreply.10.43.0.28` **explicitly**, decoupling it from `DOMAIN`, **before or within the same window** as the `DOMAIN` move. This is recorded as a *precondition*, not a step, because it is the only item in the flip with no post-hoc remedy. *(Honesty marker, carried from source: the config derivation and the user counts are measured first-hand; the author-resolution mechanism is documented upstream behaviour, not observed by executing a flip. Treat as high-confidence, not as witnessed.)*

   **Corrected — the runner is not a flip step.** Rev 1 implied a `ROOT_URL`↔runner-registration coupling (inferred from an earlier finding that the runner rejected re-pointing at `10.43.0.28:3300`). Measured: `.runner` holds `"address": "http://forgejo:3000"` — the **compose service name**. Changing a *registration address* is a different operation from moving `ROOT_URL`; the runner follows neither. `ROOT_URL` can flip without touching runner registration at all.

   **Consequence, accepted not engineered around — stored Actions payloads are historical.** `action_run.event_payload` bakes absolute URLs at dispatch time (32 keys per payload carry the address, including the `clone_url`/`ssh_url` pair `actions/checkout` consumes). New runs re-derive from the current `ROOT_URL` and follow the flip automatically; **re-running one of the 27 stored pre-flip runs would attempt checkout from the old address** and fail once it is gone. After the flip, pre-flip runs are re-run-only-by-pushing-again. **⛔ Do not rewrite these tables.** `action_run` (27 rows) and `action` (10) are the only two places in the database holding the IP literal — established by dumping the DB and attributing every match to its table, not by guessing which tables to inspect. Both are historical records; rewriting them would falsify the audit trail to fix a cosmetic staleness.

### D2 — Identity bridge (interim posture + production path)

1. **Layer split (binding)**: Network owns **node** identity (Nebula certs / node DIDs / membership); the forge owns **user** accounts. The bridge is a **mapping registry, not a federation**: each forge account maps to an operator identity and that operator's node set, recorded in Network's membership inventory. No protocol glue in the R&D window.
2. **No OIDC/OAuth federation in the R&D window.** Forgejo OAuth2 lacks scope enforcement ⇒ **first-party-apps-only** posture stands until upstream ships scopes. The production path — an OIDC provider fronting the forge (Authentik-class, per the seed corpus) — is a **`Lighthouse.aDNA` deployable concern**, adopted there when the deployable composes it, not retrofitted onto the R&D instance. *(Rev 2, measured: the instance carries **three** OAuth apps, not zero — `tea`, `git-credential-oauth`, `Git Credential Manager`, all auto-created by the DB migration at first forge start, no operator hand. All three redirect to the **client's** loopback (`http(s)://127.0.0.1`), so they are decoupled from `ROOT_URL` by construction and are **not** D1.5 flip steps. The correct standing sentence is "three exist and all are loopback-by-design", never "there are none" — a future **operator-created** OAuth app would store an absolute redirect URI and would become a flip step. Re-check at production, when D2's OIDC path lands.)*
3. **Cross-node machine read credential = repo-scoped read-only deploy keys** (the Archimedes-proven pattern): revocable via `DELETE /repos/{owner}/{repo}/keys/{id}`, verified by a *refused* push (exit 128, no ref left behind). The inherited-ACL cross-node write path is **do-not-generalize** (pattern doc, [[../doctrine/doctrine_cross_node_mesh_mirror|doctrine_cross_node_mesh_mirror]]).
4. **Write credentials**: per-operator SSH keys under D1.4 aliases; agent tokens are **named** Home-brokered credentials (`FORGEJO_TOKEN` class, Rule 6) — values never transit a conversation (ADR-007).

### D3 — Context-sync reconciliation (converge-or-coexist: **coexist now, converge at production, by lane**)

1. **Two lanes, both sanctioned, neither subsumes the other in the R&D window**:
   - **Git lane (continuous)** — mesh replicas under ADR-014 (A3 freshness modes, PR-return re-entry) are the sync fabric for **git-homed graphs**. This is ADR-012 D2's git-as-context-sync, running live on the R&D forge.
   - **Ceremony lane (episodic)** — Network's tarball-transmission ceremony remains the mechanism for **admission/identity payloads** (Home.aDNA transmissions to the Einstein node) and any non-git payload. It is a consent ceremony, not a staleness-bounded sync — the lanes differ in kind, not maturity.
2. **Convergence criterion (dated by event, not calendar)**: when the subnet forge passes its production revisit (D4), scheduled tarball transmission **of git-homed vaults** retires in favor of forge replicas; the ceremony lane persists for what it is actually for. Venus co-signs this clause — both mechanisms are hers to operate.
3. P7b objectives 4–5 (context-sync round-trip · mirror-mesh federation) execute **against this D3 shape**; their results feed the production revisit.

### D4 — Production placement revisit (the half §8 left open)

**Default answer, proposed jointly**: at production the forge runs on a **data-plane node the lighthouse coordinates** — the R&D ruling's shape, made permanent — and that node is **registered in Network's inventory under an explicit `forge` service class**. This folds the "Network-blessed forge-hub class" alternative *into* the data-plane answer instead of opposing it: placement stays data-plane (§8's control-plane prohibition holds absolutely); the *blessing* becomes a classification fact in Network's inventory rather than a different topology. **Revisit trigger**: the `Lighthouse.aDNA` deployable go/no-go (P7 exit) — noting Venus's own B3 production-eligibility flip (2026-08-08) means the Network-side gate is already open; the remaining gate is ours.

### D5 — Fleet host-move wave sequencing (Cartographer's open item, answered)

Which repos flip `origin` to a subnet forge, in what order, under what criteria. **This D fixes sequence + criteria; it fires nothing** — every flip remains a DP5 operator-gated wave event executing the ADR-006 D3 host-move sequence + ADR-014 A2 graduation semantics.

1. **Class constraint first**: only graphs whose ADR-013 lane is *interim-GitHub-private → self-hosted post-P7* (class **I** / **I-strict**) are host-move candidates. P-released (GitHub-public) and P-dev (Codeberg-private) graphs keep their canonical homes; the forge serves them as `mesh` replicas only. Class-L/local-only vaults never graduate (A3 §4).
2. **Addressing before flipping**: no origin flips to the forge until **D1 addressing is live** — origin URLs are written once, in alias/hostname form, never as IP literals that would need a second fleet-wide rewrite. (LAVG, the already-graduated reference case, wrote alias form and is conformant; it does not re-fire.)
3. **Machinery before volume**: the ADR-014 A2 runner machinery (`state: graduated` field · denominator provenance · GREEN mixed runs) must be live on Operations' side before any wave beyond n=1.
4. **Order within the candidate set**: (i) repos already replicated on the forge and quiet (lowest delta — the replica *is* the rehearsal); (ii) class-I graphs with active rd-side co-development (highest value from forge-canonical); (iii) **I-strict last, one per gate, each on a fresh full-history scan + operator sign-off** (F-W5-a elevation stands — clinical/client graphs never move in bulk).
5. **Scan posture**: replica seeding already ran each repo's ADR-011 A1 first-share gate; graduation itself adds **no new scan** unless the repo's content class changed since seeding (then A1 re-runs).

## Consequences

- Ilmarinen's M08 gets its dated retirement target; **three quarters of** the Exchange's §2.7 downgrade stops being load-bearing the day the TLS front passes the fetcher-shaped probe. (rev 3) The `allow_private` quarter outlives the flip by an **undated** interval owned by the Exchange — so M08's retirement is genuinely partial, and recording it as complete at flip-time would be false.
- (rev 3) **This ADR now binds a third vault's runtime with that vault's concurrence.** The Exchange is not in the P7a gate and does not ask to be — placement, TLS and identity are Git.aDNA's and Venus's. But §D1.5 is the one clause whose correctness **neither gating party can check**, because the failure lives in Exchange code. Hermes's memo is taken as the concurrence we did not ask for; if §D1.5 changes materially again before ratification, it goes back to them first.
- (rev 2) The flip is **executable** rather than sketched: [[../../how/campaigns/campaign_git_genesis/missions/p7a_flip_staging/flip_runbook|the flip runbook]] stages D1.5 step-by-step across its lanes. The `NO_REPLY_ADDRESS` pin is a precondition rather than a step, because it is the only part of the flip that **cannot be repaired after the fact**. *(rev 3: the runbook now carries **five** preconditions, and the two that are `⛔` are `⛔` for opposite reasons — P3 because it is unrepairable, P5 because it is undated and owned by another vault. Neither is a step; they fail differently and must not be collapsed into one class.)*
- The ADR-010 "one-field-swap" promise survives contact with the SSH alias doctrine as a per-leg contract — no doctrine retcon needed.
- `Lighthouse.aDNA` inherits three explicit intake items: the Caddy/TLS profile (D1.2–D1.3), the OIDC production path (D2.2), and the go/no-go that triggers D4's revisit.
- P7b objectives 4–5 have a ratified shape to execute against; the fleet host-move wave has criteria and an order instead of an open item.
- Venus's ceremony lane is affirmed, not deprecated — convergence is scoped to git-homed vaults at production, nothing before.

## Alternatives considered

- **Public ACME HTTP-01 with a public A record** — rejected for the R&D window: exposes an inbound surface solely to mint certs; DNS-01 gets the same certs with none of it.
- **Proxying SSH through Caddy (single-port story)** — rejected: Forgejo's built-in sshd is a declared non-seam (Forgejo.aDNA §B); L4 SSH proxying adds a failure mode and breaks the alias doctrine's direct-key discipline for no consumer benefit.
- **Converging context-sync now (retiring the tarball ceremony)** — rejected: the ceremony is a consent ritual for admission/identity payloads; git replicas can't carry that meaning, and forcing them to would put §8-class governance inside a repo push.
- **A distinct "forge hub" node class as a topology** (vs D4's classification fold) — rejected as topology: any placement outside the data-plane re-opens §8; as *classification* it's adopted inside D4.
- **Piecewise §2.7 restoration** (e.g. keep port 3300 open but require https) — **still rejected, but the reasoning is narrowed at rev 3.** Piecewise *by preference* stays rejected for exactly the original reason: partial states multiply the guard's test matrix and invite permanent half-downgrades. What rev 3 adopts is a different thing — **piecewise by necessity**, which the guard's implementation compels (D1.5a): three controls that *can* retire together and one that provably cannot until an exemption exists. Rev 1's "four relaxed as one unit retire as one unit" was a symmetry argument about how they were *relaxed*; it does not survive the fact that two of the four are process-global and one is refused by the check order. Recording the distinction rather than deleting the bullet, because the anti-half-downgrade principle is still the right default for every case that isn't this one.

## Revision log

### rev 4 — 2026-08-20 — the probe measurement made falsifiable; D1.3's fallback corrected

Two sources, both **accepting rev 3** and both handing back a defect in it. Rev 3 was never ratified, so this is again a revision of the proposal rather than an amendment — **concurrence and §7.7 ratification apply to rev 4**.

| # | Change | Class |
|---|---|---|
| 1 | **§D1.5a's probe measurement was unfalsifiable and is replaced.** "redirect `[]`" is `[]` by construction under `follow_redirects=False`, so the column passed on the failure it existed to catch. New **§D1.5b** states the binding form — *status exactly the expected code **and** no `Location` header* — and names this as the **second instance in this ADR** of an instrument reporting health in the presence of its target condition. | **Correction — rev 2/rev 3 specified a check that cannot fail** |
| 2 | **A live `303` promoted to a required positive control.** `/raw/main/README.md` → `303 Location: /raw/branch/main/README.md`, measured on this surface one path segment from the protected corpus. It must be observed to *fail* the §D1.5b test before any capture is trusted. Plus a required `/api/v1/user` → `401` anonymity self-check. | **New — makes the instrument provable, not merely defined** |
| 3 | **D1.2's `:80` 301 hazard was documented and undetectable simultaneously** — under the struck column, a 301 reaching the probe would still have recorded "empty". D1.2's out-clause is now discharged only by evidence under §D1.5b. | **New — a consequence of item 1, stated where it bites** |
| 4 | **D1.3's fallback corrected: it is a build, not a fall-back.** Network's `Lattice Mesh CA` (`267978…447e`) is a **Nebula** CA and cannot issue browser/git-client-valid TLS; the fallback means standing up a **second CA of a different class**. Also stated explicitly: **ACME DNS-01 requires no public `A` record** (TXT `_acme-challenge`), so D1.3's primary and D1.1's mesh-internal-only constraint do not conflict. | **Correction — rev 1–3 implied a capability that does not exist** |

**Sources, credited.** Item 1–3: **Ilmarinen (Forgejo.aDNA)**, [[../../who/coordination/coord_2026_08_20_ilmarinen_to_hopper_rev3_verified_p3_p4_accepted|**F-F25**]] — filed against §2/§5 of the flip runbook; sustained, and it reaches one level further than he claimed, into this ADR, which is the runbook's named authority. Item 4: **Venus (Network.aDNA)**, whose concurrence memo carries the correction. *(Both the CA class and the DNS-01 property were **re-verified at source** here rather than transcribed — see the note below on why that mattered.)*

**⛔ Recorded against ourselves — twice.**

**(a) Rev 4 moves the object after Venus concurred against rev 3.** Her concurrence is affirmative and was made against the ADR file itself at `revision: 3` (`7f4bd48`), which is the right way to concur and is now, through no fault of hers, a concurrence against superseded text. This is **F-P7a-b's shape for the third consecutive revision** — an artifact moving between a peer's read and our act. What differs this time is only mitigation, not avoidance: the delta is **scoped to §D1.5a/§D1.5b and D1.3**, and it is disclosed to her *before* she is asked to extend, not discovered by her afterwards. D1.1 · D1.2 · D1.4 · D1.5's egress logic · D2 · D3 · D4 · D5 are untouched, so her rev-3 concurrence stands over all of them.

**(b) We read her staged concurrence at source, and it is not delivered.** Her memo is `status: staged` in her own tree under a per-send operator GO, with no `delivered_*` fields. We have **not** counted it as received and the P7a gate is **not** recorded as half-closed. But we did read it, and item 4 originates there — so rather than build a binding clause on a document its author has not released, the CA class and the DNS-01 property were **independently verified at source** and are cited as our own findings with her credited as the pointer. Disclosed to her in the rev-4 memo, because the alternative is her discovering that we acted on an unsent document. *(This is the fifth instance in eight days of the staged-memo-already-readable class — her F-S390-01, Berthier's F-S218-01, our F-P7a-b and F-P7a-d. Per her STATE, the operator has ruled: file the finding, install no rule.)*

### rev 3 — 2026-08-19 — D1.5's egress restore corrected against the Exchange's guard implementation

Source: **Hermes (Exchange.aDNA)**, [[../../who/coordination/coord_2026_08_19_hermes_to_hopper_adr015_egress_precondition|"concur on the contract, object to the unitary restore"]] — `ack_required`, delivered 18:29, answering **before** the gate closed rather than inheriting the clause afterwards. Rev 2 was never ratified, so this is again a revision of the proposal rather than an amendment — **concurrence and §7.7 ratification apply to rev 3**.

They found ADR-015 by sweeping our `STATE.md` on their recon channel. Nothing was owed for that — but the clause binds their runtime and they learned of it by grep, which is worth recording next to how we then handled their answer (item 3).

| # | Change | Class |
|---|---|---|
| 1 | **D1.5 restated three-part-plus-one** — `schemes`/`ports`/`allow_ip_literal` retire with the flip; **`allow_private = False` is gated on the Exchange's name-allowlist exemption**, with no committed date and two named lawful dispositions if our window lands first. New **§D1.5a** carries the evidence: the guard checks the allowlist at `egress.py:163` **before** the private-address check at `172-178` and grants no exemption from it, so the unitary restore closes the door the retirement exists to open — and the pre-restore probe passes, so it would surface as a Caddy fault. | **Correction — rev 1/rev 2 specified an unsatisfiable end-state** |
| 2 | **Two of the four controls are process-global, not per-lane** (`..._EGRESS_ALLOW_PRIVATE` / `..._ALLOW_IP_LITERAL` carry no lane prefix) ⇒ the downgrade reached the `SUBSCRIBE` lane for a `REMOTE`-lane reason. The Exchange files this against themselves; restated here because the asymmetry is invisible from this side and strengthens the case against a range re-open. | **New — a fact rev 2 assumed away** |
| 3 | **The `404` negative control is confirmed binding** in the through-Caddy probe corpus (Hermes's ask 2), not merely baselined. | **Confirmation** |
| 4 | **Alternatives: "piecewise §2.7 restoration"** narrowed — piecewise *by preference* stays rejected; piecewise *by necessity* is what item 1 adopts. | **Correction — the bullet contradicted the decision** |
| 5 | **Consequences**: M08's retirement is explicitly **partial** at flip-time; and the ADR now records that it binds a third vault's runtime with that vault's concurrence, obtained after the fact. | **New** |

**⛔ Recorded against ourselves, because the revision log is where it belongs.** Hermes's memo arrived at 18:29 and was **committed at 19:xx into `0725d63` — the same commit that authored rev 2 of the clause it objects to — and read for the first time the following session.** Rev 2 was therefore drafted while an unread, code-backed objection to §D1.5 sat in our own tree, and the `ack_required` memo asking Venus to concur against rev 2 went out afterwards. Nothing broke, only because Venus had already closed her session and never read it. Filed as **F-P7a-d**: intake-by-directory-add is not intake — an inbound file entering a commit must be enumerated and dispositioned in that commit's message. This is the second consecutive revision caused by an artifact that moved between the read and the act (rev 2's cause was **F-P7a-b**), which makes it a class rather than an incident.

### rev 2 — 2026-08-19 — D1 corrected against the live instance

Source: Ilmarinen's read-only, zero-mutation audit of the R&D forge ([[../../who/coordination/coord_2026_08_19_ilmarinen_to_hopper_d15_flip_audit_from_the_instance|memo]]), answering the one sanity-check this ADR's rev 1 asked for before the flip runbook was written. Every probe named its expected value before running; **two expectations were wrong, and both wrong ones are where the corrections are.** Rev 1 was never ratified, so this is a revision of the proposal rather than an amendment — **concurrence and §7.7 ratification apply to rev 2**.

| # | Change | Class |
|---|---|---|
| 1 | **D1.5 key list: four keys, not three** — `PROTOCOL` (`http`→`https`) was omitted. `HTTP_PORT`/`SSH_PORT` explicitly do not move; `LOCAL_ROOT_URL` absent ⇒ internal calls never straddle names. | **Correction** — rev 1 was incomplete |
| 2 | **D1.5 `NO_REPLY_ADDRESS` pin, binding precondition** — derived from `DOMAIN`, already written into immutable git objects for 3 of 5 users; unfixable after the flip. | **New, and the reason this revision could not wait** |
| 3 | **D1.5 runner coupling struck** — `.runner` registers against the compose service name, never `ROOT_URL`. Rev 1's inference was reasonable and wrong. | **Correction — inverted** |
| 4 | **D1.5 stored-payload consequence + do-not-rewrite rule** — `action_run`(27)/`action`(10) are the only IP-literal holders and are historical records. | **New** |
| 5 | **D1.5 probe pre-state baselined** — the three-request shape incl. the deliberate `404` negative control, against the sole public repo. | **New — makes the probe testable** |
| 6 | **D1.2 bind discipline promoted from assumption to explicit requirement**, + the automatic-HTTPS `:80` 301 hazard named. | **Correction — rev 1 asserted inheritance that does not hold** |
| 7 | **D2.2 OAuth apps: three exist, loopback-by-design**, with the operator-created-app caveat. | **Clarification** |

D2.1/D2.3/D2.4, D3, D4 and D5 are **unchanged** from rev 1. *(Rev 3 touches D1.5 and D1.5a only; D1.1–D1.4 are unchanged from rev 2. **Rev 4 touches §D1.5a's probe-measurement paragraph — adding §D1.5b — and D1.3, and nothing else**; D1.5's egress logic, D1.1, D1.2, D1.4, D2, D3, D4 and D5 are unchanged from rev 3.)*

## Ratification

- **decision**: ADR-015 D1–D5 **as at rev 4** (2026-08-20)
- **ratified-by**: *(pending — operator §7.7 + Venus concurrence memo, both against rev 4. Her rev-3 concurrence is written and affirmative but **held `staged` under a per-send operator GO in her vault and never delivered**; it is recorded here as observed-at-source, **not** as received, and the gate is **not** half-closed on it. The rev-4 ask is scoped: extend over §D1.5a/§D1.5b and D1.3, the only clauses that moved.)*
- **date**: *(pending)*
- **status**: `proposed`
