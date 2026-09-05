# ADR 0002: Ads for free users; Cosmic Pro is a subscription

- **Status:** Accepted
- **Date:** 2026-09-05
- **Supersedes:** `AGENTS.md` rule 9 (“one-time purchase, no subscription”);
  `docs/PRODUCT_SPEC.md` §14 one-time IAP; `docs/PRODUCT_OVERVIEW.md` “One-time
  purchase. No subscription.”; `docs/DEPLOYMENT.md` “subscriptions are not in
  the product spec”; `docs/COSMIC_PULSE_CHANGE_REQUEST.md` one-time Pro note.

## Context

The original spec made Cosmic Pro a **one-time** In-App Purchase and forbade
subscriptions. The free app was allowed ads later, never on the live journey
screen.

The product owner now wants:

1. Revenue from **ads in the free app**.
2. Cosmic Pro sold as a **subscription**, with store payment set up for that.

GitHub Pages is a static Flutter web build. It cannot talk to StoreKit or Play
Billing. Web ads and web subscriptions need a different path than iOS/Android.

## Decision

### Free app

- The live Pulse/Flow screen, year wheel, share sheet, and launch path stay
  **ad-free forever**.
- When `adsAllowed` is true, a single `AdSlot` may show a banner at the bottom
  of Menu, Science, Styles, and Statistics only.
- No other file imports an ads SDK. No interstitial, rewarded, or audio ads.
- Expected network on iOS/Android: **Google AdMob** (optional mediation later).
- Flutter **web on GitHub Pages does not run AdMob**. Do not add AdSense to
  the Pages preview unless a later ADR says so. Web remains a try-before-store
  build until Phase 3 decides otherwise.

### Cosmic Pro

- Cosmic Pro is an **auto-renewable subscription**, not a one-time unlock.
- Primary product: **yearly**. A monthly SKU may be added later without a new
  ADR if it sits in the same subscription group and maps to the same
  `Entitlement.isPro`.
- `isPro == true` turns ads off (`adsAllowed` must be false) and unlocks the
  Pro catalog (extra atmospheres, extra styles, widgets, custom milestones,
  Scientific Mode, and the rest of the Phase 2/3 Pro list).
- Restore Purchases is required on iOS and Android.
- Until store binaries exist, keep `Entitlement.testing` (`isPro: true`,
  `adsAllowed: false`). Do not rewrite screens when flags flip. See ADR 0005.

### Money movement

Operational setup (accounts, product IDs, payouts) lives in
[`docs/MONETIZATION.md`](../MONETIZATION.md). That file is the runbook; this
ADR is the product rule.

### Web store

GitHub Pages will **not** take Apple/Google subscription money. Options for a
later ADR: Stripe + a tiny backend, RevenueCat Web Billing, or keep web as a
Pro-unlocked preview. Phase 3 must pick one before charging on the web.

## Consequences

- `AGENTS.md` rule 9 now says subscription, not one-time.
- Store listings, privacy questionnaires, and `app-ads.txt` become Phase 3
  work, not Phase 2.
- Apple and Google each take 15% or 30% of subscription proceeds. AdMob pays
  separately after its threshold, from a different Google payments profile.
- Users who expected a forever one-time unlock will instead renew yearly.
  Communicate that on the Cosmic Pro screen before the first store submit.
- Testing builds continue to look like the paid app so we do not design a
  second, locked UI.
