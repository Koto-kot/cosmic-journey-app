# ADR 0001: Record architecture decisions in-repo

- **Status:** Accepted
- **Date:** 2026-09-05
- **Supersedes:** none

## Context

Cosmic Journey started from a product spec that assumed a one-time Cosmic Pro
purchase, Pulse-only live numbers, and store release as a later milestone.
Those documents live under `docs/` and are easy to edit in place. In-place
edits hide *when* a rule changed and *why*.

We now have a public GitHub repo, a hosted web preview, and a Phase 3 plan
that will change money, ads, and store wiring. Specs will keep moving. Without
a decision log, later work will re-argue settled questions (ads on the live
screen, one-time vs subscription, GitHub Pages vs a backend).

## Decision

Keep Architecture Decision Records in `docs/adr/`.

- One markdown file per decision, numbered, never deleted.
- Current specs (`PRODUCT_SPEC.md`, `AGENTS.md`, `PHASE_*.md`) stay the
  working description of the product.
- When a decision changes a published rule, update the spec **and** add or
  supersede an ADR in the same change.
- ADRs are the history. Specs are the present tense.

## Consequences

- Product changes such as “Pro is now a subscription” are visible as ADR 0002
  rather than a silent rewrite of `AGENTS.md`.
- Agents and humans read `docs/adr/README.md` before reversing a constraint.
- Small implementation notes do not need an ADR. Use one when the choice is
  costly to undo, user-visible, or contradicts an earlier spec.
