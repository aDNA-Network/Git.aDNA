---
type: decision
adr_id: adr_015
title: "ADR-015 — Lighthouse Integration Architecture (addressing/TLS · identity bridge · context-sync · production placement · host-move sequencing)"
status: proposed   # joint ADR — pending Venus (Network.aDNA) concurrence + operator ratification (§7.7)
created: 2026-08-19
updated: 2026-08-19
last_edited_by: agent_stanley
joint_with: venus (Network.aDNA)
ratifies_at: "operator §7.7 gate + Venus concurrence memo — this is the P7a exit-gate integration ADR"
depends_on: [adr_010, adr_012, adr_013, adr_014]
amends: []
tags: [decision, adr, adr_015, git, p7a, lighthouse, addressing, tls, identity_bridge, context_sync, mesh, proposed, operation_free_harbor]
---

# ADR-015 — Lighthouse Integration Architecture

**Status**: `proposed` — the **P7a exit-gate integration ADR** ([[../../how/campaigns/campaign_git_genesis/missions/p7a_integration_architecture|mission card]]), joint with **Venus (Network.aDNA)**. Binding only after (a) Venus's concurrence memo and (b) operator ratification (§7.7). Fixes the four seams ADR-012's open-questions block routed here — addressing/DNS+TLS · identity bridge · context-sync reconciliation · forge placement — plus the fleet host-move sequencing the [[../inventory/disposition_ledger|disposition ledger]] assigned to the P7a block.

## Context

The P7b spike instance is **live**: Forgejo 15.0.6 LTS on the aDNA-Labs R&D Node (Ubuntu, Nebula `10.43.0.28`), mesh-only binds (`127.0.0.1` + mesh addr on 3300/2222, never `0.0.0.0`), 15 repos / 5 users at the 08-18 restore drill, portable CI green on runner label `rd-node` (ADR-008 proven). Access today is **hostname-less**: git-over-HTTP at `http://10.43.0.28:3300` and git-over-SSH L4-direct on `:2222` (Forgejo's built-in sshd — a declared **non-seam**: never proxied through Caddy). That IP-literal HTTP surface forced the Exchange to relax **all four** of its egress-guard defaults at once (ADR-038 §2.7: `http` scheme · port 3300 · private range · IP literal), carried by Ilmarinen's M08 as a **dated** downgrade whose retirement condition is this mission. Meanwhile ADR-014 A2 §4 made ssh-config `Host` aliases the fleet law for mesh-forge SSH — while ADR-010 D1's on-ramp premise is "only the `host` field changes." Those two doctrines meet here.

**Constraint inputs (verified at source this session):** Venus's scoped §8 R&D ruling (`Network.aDNA/who/governance/ruling_2026_08_07_scoped_s8_rd_forge.md`) resolves placement *for the R&D window only* (revisit-at-production clause). Forgejo OAuth2 has **no scope enforcement** (Forgejo.aDNA D12 §D.6). The Exchange's anonymous fetcher sets `follow_redirects=False` and consumes the raw-fetch shape `branch/<branch>/<path>`. Exchange ADR-041 (ratified 2026-08-15) fixed `Git.aDNA`'s manifest lane: **public → `aDNA-Commons`**.

## Decisions

### D1 — Addressing & TLS (the two-leg contract)

1. **Name scheme**: each subnet forge is addressed **`git.<subnet>.adna.network`**, where `<subnet>` is the fabric-id already in use by ADR-014 D2 remote naming (`mesh-<fabric-id>`). The R&D fabric's id is `rd` ⇒ the first concrete binding is **`git.rd.adna.network`**. **Network owns the name**: the fabric-id registry, DNS zone, and resolver mechanism are Venus's (ADR-010 D4); Git.aDNA specifies only that the name MUST resolve **mesh-internal only** — no public A/AAAA record for any R&D-window forge. Public DNS ever appearing for a forge surface is a production-phase, operator-gated decision, and then only for read-only surfaces.
2. **TLS termination**: Caddy (the Portunus brick) terminates **HTTPS on 443** on the forge's own data-plane box (co-tenant, per the Am6 hardening posture + the alpha-root cotenancy note), reverse-proxying to the mesh-bound Forgejo HTTP listener. Bind discipline is inherited unchanged: `127.0.0.1` + mesh addr only, never `0.0.0.0`.
3. **Certificates**: preferred issuance is **ACME DNS-01** against the `adna.network` zone — real certificates for mesh-internal names with zero inbound exposure and zero client trust-store distribution. Fallback where DNS-01 delegation isn't available: a Network-operated internal CA with the trust anchor distributed through Home.aDNA's node-inventory channel. Venus co-decides the issuance mechanism; the *requirement* (browser/git-client-valid TLS on 443, no per-client insecure-skip flags, ever) is binding either way.
4. **The two-leg contract** (reconciles ADR-010 D1 "one-field-swap" with ADR-014 A2 §4):
   - **HTTPS leg** — conforms to the one-field promise: a `git/` declaration moves hosts by rewriting only the host field to `git.<subnet>.adna.network`; scheme/port collapse to `https`/443 defaults.
   - **SSH leg** — stays **L4-direct on 2222** (the Forgejo built-in sshd non-seam; Caddy never proxies SSH). It conforms via **alias form only**: an ssh-config `Host` alias (recommended name **`git-<fabric-id>`**, e.g. `git-rd`) with `IdentitiesOnly yes` + a dedicated key; `HostName` inside the alias moves from IP literal to the D1.1 DNS name once resolvable — **the alias is the stable surface, its HostName is the movable field**. Raw `ssh://git@<ip>:2222/…` URLs remain non-conformant for fleet use (A2 §4).
   The one-field-swap doctrine is therefore **per-leg**: hostname for HTTPS, alias-HostName for SSH. Declarations record both legs.
5. **§2.7 retirement condition (dated, binding on our side of the seam)**: the Exchange's four-part egress downgrade retires **as one unit** when the TLS front is live and the fetcher's URL flips to `https://git.<subnet>.adna.network/...` — restoring `schemes: https` · `ports: {443}` · `allow_private = False`(†) · `allow_ip_literal = False` together, never piecewise. The front MUST serve the anonymous raw-fetch shape (`branch/<branch>/<path>`) **redirect-free** — the fetcher sets `follow_redirects=False`, so any Caddy-introduced redirect (http→https upgrade hop, trailing-slash 303, canonical-host bounce) is a breaking change; transparent proxying is the contract, verified by a fetcher-shaped probe **before** the Exchange restores its defaults. († `allow_private` interacts with mesh-internal resolution — if the DNS name resolves to a mesh-private address, the Exchange's guard needs a *name-allowlist* rather than a range re-open; that residual design is the Exchange's call, flagged not decided here.) Forge-side, the flip is a **coordinated config event**: `ROOT_URL`/`DOMAIN`/`SSH_DOMAIN` move to the DNS name in the same window (Forgejo generates absolute URLs from `ROOT_URL`), sequenced with Ilmarinen so replica remotes and CI checkout URLs never straddle two names.

### D2 — Identity bridge (interim posture + production path)

1. **Layer split (binding)**: Network owns **node** identity (Nebula certs / node DIDs / membership); the forge owns **user** accounts. The bridge is a **mapping registry, not a federation**: each forge account maps to an operator identity and that operator's node set, recorded in Network's membership inventory. No protocol glue in the R&D window.
2. **No OIDC/OAuth federation in the R&D window.** Forgejo OAuth2 lacks scope enforcement ⇒ **first-party-apps-only** posture stands until upstream ships scopes. The production path — an OIDC provider fronting the forge (Authentik-class, per the seed corpus) — is a **`Lighthouse.aDNA` deployable concern**, adopted there when the deployable composes it, not retrofitted onto the R&D instance.
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

- Ilmarinen's M08 gets its dated retirement target; the Exchange's §2.7 downgrade stops being load-bearing the day the TLS front passes the fetcher-shaped probe.
- The ADR-010 "one-field-swap" promise survives contact with the SSH alias doctrine as a per-leg contract — no doctrine retcon needed.
- `Lighthouse.aDNA` inherits three explicit intake items: the Caddy/TLS profile (D1.2–D1.3), the OIDC production path (D2.2), and the go/no-go that triggers D4's revisit.
- P7b objectives 4–5 have a ratified shape to execute against; the fleet host-move wave has criteria and an order instead of an open item.
- Venus's ceremony lane is affirmed, not deprecated — convergence is scoped to git-homed vaults at production, nothing before.

## Alternatives considered

- **Public ACME HTTP-01 with a public A record** — rejected for the R&D window: exposes an inbound surface solely to mint certs; DNS-01 gets the same certs with none of it.
- **Proxying SSH through Caddy (single-port story)** — rejected: Forgejo's built-in sshd is a declared non-seam (Forgejo.aDNA §B); L4 SSH proxying adds a failure mode and breaks the alias doctrine's direct-key discipline for no consumer benefit.
- **Converging context-sync now (retiring the tarball ceremony)** — rejected: the ceremony is a consent ritual for admission/identity payloads; git replicas can't carry that meaning, and forcing them to would put §8-class governance inside a repo push.
- **A distinct "forge hub" node class as a topology** (vs D4's classification fold) — rejected as topology: any placement outside the data-plane re-opens §8; as *classification* it's adopted inside D4.
- **Piecewise §2.7 restoration** (e.g. keep port 3300 open but require https) — rejected: four controls relaxed as one unit retire as one unit; partial states multiply the guard's test matrix and invite permanent half-downgrades.

## Ratification

- **decision**: ADR-015 D1–D5 as written
- **ratified-by**: *(pending — operator §7.7 + Venus concurrence memo)*
- **date**: *(pending)*
- **status**: `proposed`
