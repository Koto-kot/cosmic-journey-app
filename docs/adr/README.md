# Architecture Decision Records

This folder is the versioned history of product and engineering decisions for
Cosmic Journey.

Specs in `docs/` describe the current intended product. ADRs record **why** a
decision was made, **what it replaced**, and **what we will not undo without a
new ADR**. When a spec and an ADR disagree, the newest accepted ADR wins, and
the spec should be updated in the same change.

## How to add one

1. Copy the next number (`0007`, `0008`, …). Do not reuse numbers.
2. Use kebab-case: `0007-short-title.md`.
3. Set **Status** to `Proposed` while drafting, then `Accepted` when the
   matching code or spec change lands.
4. If a later decision replaces this one, set Status to `Superseded by 00XX`
   and leave the old file in place.

## Index

| ADR | Title | Status |
| --- | --- |
| [0001](0001-record-architecture-decisions.md) | Record architecture decisions in-repo | Accepted |
| [0002](0002-monetization-ads-and-pro-subscription.md) | Ads for free users; Cosmic Pro is a subscription | Accepted |
| [0003](0003-dual-readout-pulse-and-flow.md) | Pulse and Flow readout modes | Accepted |
| [0004](0004-github-pages-as-web-host.md) | GitHub Pages hosts the Flutter web preview | Accepted |
| [0005](0005-entitlement-flags-before-store.md) | Testing entitlement before live billing | Accepted |
| [0006](0006-generated-in-app-soundscapes.md) | Generated ambient beds, no licensed stems | Accepted |

## Related docs

- [Product spec](../PRODUCT_SPEC.md)
- [Monetization setup](../MONETIZATION.md)
- [Phase 3 plan](../PHASE_3.md)
- [Ideas (not scheduled)](../IDEAS.md)
- [Phase 2 surfaces](../PHASE_2.md)
- [Deployment](../DEPLOYMENT.md)
