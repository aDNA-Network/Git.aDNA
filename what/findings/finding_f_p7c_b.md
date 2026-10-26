---
type: finding
finding_id: F-P7c-b
status: open
class: reading_older_than_the_state_it_describes
opened: 2026-10-26
closed: null
campaign: campaign_git_genesis
phase: P7c
last_edited_by: agent_stanley
tags: [finding, git, p7c, ours, adr_014_a6, replica_build_home, stale_reading, dark_forge, f_p7c_b]
---

# F-P7c-b — the only reading of who builds on the forge is 58 days old, taken before the forge went dark

## Shape

- **REPORTED** (ADR-014 A6 §3.3, labelled *non-normative* on its own face): on **2026-08-29**, three mesh replicas were `REPLICA_BUILD_HOME` on the R&D forge (`aDNALabs` 8 runs · `Network` 21 · `WGS` 2), and six were `LATENT`·pre-landing.
- **REPORTED** (Forgejo.aDNA STATE, 2026-09-17): the forge has been **DARK since 2026-09-10T21:36Z**. No later reading is on disk in Forgejo.aDNA or Home's inventory (**VERIFIED** by grep, 2026-10-26).
- So the CI/CD-to-Forgejo card (P7c) has to plan from a population it cannot measure today. On the day the snapshot was taken, A6 itself found that the ruling it formalized was already false.

⇒ A6 §3 is right that membership is **whatever the instrument reports at the moment of reading**. No reading has been possible for 46 days, and nothing on disk says so as a standing item.

## Closes when

`check_replica_actions_posture.sh` (Forgejo.aDNA) runs against an answering forge, and its classes are mapped onto A6 §2's predicates (§5.2, never by string). That is P7c L0.4.
