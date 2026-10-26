---
type: finding
finding_id: F-P7c-a
status: open
class: owner_of_record_without_a_record
opened: 2026-10-26
closed: null
campaign: campaign_git_genesis
phase: P7c
last_edited_by: agent_stanley
tags: [finding, git, p7c, ours, runner, f_port_24, wildcard_bind, launchagent, owner_of_record, names_only, f_p7c_a]
---

# F-P7c-a — Home rows two runners on this node as Git.aDNA's, and Git.aDNA has no record of either

## Shape

- **REPORTED** (Home `inventory_launchagents`, read 2026-10-26): the LaunchAgent `com.adna.forgejo-runner-macos` is listed with **`owner_vault: Git.aDNA`**. Its config lives under `~/.adna/forgejo-runner-macos/`.
- **REPORTED** (Home F-PORT-24, re-read 2026-10-25 23:52 PDT; a memo to this desk is **staged** at Home and not delivered): that process listens on **two wildcard binds**, 49397 and 49398. Home's 08-04 port list records the same runner on 50098–50099, so the ports move between restarts. **INFERRED**: an ephemeral job-side cache or artifact server.
- **REPORTED** (Forgejo.aDNA memo, 2026-08-19): a second L1 runner, `adna-l1-Dyrnwyn` (Docker), is registered to **codeberg.org** with label `adna-linux`.
- **VERIFIED** (grep of this vault for `forgejo-runner-macos`, `runner-macos` and `adna-l1-Dyrnwyn`, 2026-10-26): **none of these appears here as a runner record.** The only hits are label *examples* (`adna-l1-macos-arm64`) in ADR-008 A1 and the mesh-mirror doctrine.

⇒ The owner of record cannot answer F-PORT-24. Nobody here can say what the binds serve, which forge the macOS runner is registered to, or which labels it carries. ADR-008 D4 places runner *provisioning* outside this vault ("a host concern"), but Home's register routes the *row* here, and the two disagree about who holds it.

## Closes when

At a GO'd sitting, either (a) this vault records both L1 runners (names, labels, registration target, bind role; **never** the `.runner` token file's contents) and answers F-PORT-24, or (b) ownership is re-routed by memo to the lane that provisions them (Forgejo.aDNA, by ADR-008 D4) and Home re-rows it. The choice is P7c docket **CI-10**.
