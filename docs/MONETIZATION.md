# How Cosmic Journey makes money

This is the operational runbook. The product rules are
[ADR 0002](adr/0002-monetization-ads-and-pro-subscription.md): **ads on the
free app** (never on the live odometer), **Cosmic Pro as a yearly
subscription**. Phase 2 still uses `Entitlement.testing` (everyone is Pro, ads
off). Nothing below charges a real user until Phase 3 flips those flags.

There are two separate payouts:

| Stream | Who pays you | Where it runs | When cash arrives |
| --- | --- | --- | --- |
| Ads | Advertisers, via Google AdMob | Free iOS/Android only | After AdMob’s threshold, on AdMob’s schedule, to the Google payments profile |
| Cosmic Pro | People who subscribe | App Store and Google Play | Store deposits minus Apple/Google commission (15% or 30%) |

They do **not** share a dashboard. AdMob is advertising. Subscriptions are
In-App Purchase. You set both up; you get two bank relationships with Google
(AdMob vs Play) plus Apple.

The hosted web app on GitHub Pages is a **preview**. It cannot collect Apple
or Google subscription money, and this project does not put ads on Pages
(ADR 0002).

---

## 1. Money from ads (free version)

### What the user sees

Free users keep the full odometer: Pulse or Flow, birth year, science, basic
milestones, Deep Space, ENG/UA. They see a **banner** only at the bottom of:

- Menu
- Science
- Styles
- Statistics

Never on the live journey screen, the year wheel, a share sheet, or as a
launch interstitial. Cosmic Pro subscribers see no ads.

Implementation: `AdSlot` (`app/lib/core/widgets/ad_slot.dart`). When
`adsAllowed` is false it renders nothing. When ads go live, **only this
widget** starts the ads SDK.

### How the money is calculated

You are paid for **impressions** (and, if you later add mediation, for the
winning bid). Roughly:

```text
revenue ≈ (impressions / 1000) × eCPM
```

`eCPM` is what advertisers pay per thousand views. It moves with country,
season, and fill rate. A calm astronomy app will not match a game’s eCPM.
Honest expectation: ads are the **free-tier** stream; subscriptions are the
meaningful one if people love the odometer.

You do **not** get paid for “having an ad unit.” You get paid when a real
ad is shown on a store-distributed build with a production ad unit ID.

### Accounts to open

1. A Google account you control long-term.
2. [AdMob](https://admob.google.com) — create the account, accept the
   contract, add **two apps** (iOS bundle `com.cosmicjourney.cosmic_journey`,
   Android application id `com.cosmicjourney.cosmic_journey`).
3. A **Google payments profile** (bank account, address, tax info). AdMob
   pays this profile, not Play Console, not Apple.
4. Wait for AdMob to approve the apps. New accounts can sit in “Getting
   ready” until there is a store listing or enough traffic.

### Ad units

Create **banner** units only, named after the placement so reports make sense:

| Ad unit name | Screen |
| --- | --- |
| `menu_banner` | Menu footer |
| `science_banner` | Science footer |
| `styles_banner` | Styles footer |
| `stats_banner` | Statistics footer |

Use **test IDs** in debug and CI. Production IDs only in release store
binaries. Mixing them up can freeze the account.

### Platform extras (required before ads earn)

**Android**

- AdMob App ID in `AndroidManifest.xml`.
- Play app uploaded (even internal testing) so AdMob can match the package.
- [app-ads.txt](https://support.google.com/admob/answer/9363762) on the
  developer website that Play lists (a GitHub Pages `/app-ads.txt` is
  enough if that URL is the official site).

**iOS**

- AdMob App ID in `Info.plist`.
- App Tracking Transparency prompt **only if** you use personalized ads.
  You can start with non-personalized banners and skip ATT; revenue is
  lower, review is simpler.
- SKAdNetwork IDs that Google documents for AdMob.
- Privacy Nutrition Label: advertising data if you use AdMob.

**Both**

- Privacy policy URL that says: birth data stays on device; AdMob may
  collect advertising identifiers on free builds; Pro removes ads.
- No ads until `Entitlement.adsAllowed` is true for that user.

### Payout from AdMob

- AdMob holds earnings until you pass the **payout threshold** (commonly
  USD 100; check the current figure in the payments profile).
- Then it pays on AdMob’s monthly cycle, not the same day as impressions.
- Invalid traffic (clicking your own ads, incentivizing clicks) can zero
  the account. Never tap ads on your own devices; use test IDs.

### Flutter wiring (Phase 3, not this build)

1. Add `google_mobile_ads` **only** behind `AdSlot` (a small
   `services/ads/` wrapper is fine; journey screens still must not import it).
2. Initialize the SDK at app start **after** first frame, not on the Pulse
   screen.
3. `if (!entitlement.adsAllowed) return SizedBox.shrink();` stays the first
   line of `AdSlot`.
4. Web: do nothing. `kIsWeb` → empty slot.

### What not to do

- Rewarded video to “unlock” the odometer.
- Interstitial when opening Menu.
- Banner over Earth or the numbers.
- Ads that duck Deep Space.
- Putting AdSense on GitHub Pages “just to try.”

---

## 2. Money from Cosmic Pro (subscription)

### What you are selling

A **yearly auto-renewable subscription** named Cosmic Pro. It unlocks extra
atmospheres, extra styles, widgets, custom milestones, richer stats, Scientific
Mode (Phase 3), and **removes ads**.

Suggested product IDs (create them before writing store code):

| Store | Product ID | Type |
| --- | --- | --- |
| App Store Connect | `cosmic_pro_yearly` | Auto-renewable, 1 year |
| Google Play | `cosmic_pro_yearly` | Subscription, 1 year base plan |

Optional later: `cosmic_pro_monthly` in the **same** Apple subscription group
and the same Play subscription so a user has one Pro entitlement, not two
stacks.

Price is your choice in each store’s local price grid. Start from one
reference price (for example a low yearly amount) and let Apple/Google
localize.

### Apple (App Store)

1. Enroll in the [Apple Developer Program](https://developer.apple.com/programs/)
   (US$99 / year). See [`DEPLOYMENT.md`](DEPLOYMENT.md).
2. App Store Connect → the Cosmic Journey app → **Subscriptions**.
3. Create a **subscription group** (one group for Cosmic Pro).
4. Add the yearly product, localizations (English + Ukrainian), review
   screenshot, and privacy policy.
5. Paid Apps agreement + banking + tax in App Store Connect → Business.
   **No banking, no payouts**, even if the IAP is approved.
6. Implement StoreKit 2 (or RevenueCat, below). Sandbox testers first.
7. Restore Purchases on the Cosmic Pro screen.

Commission: **15%** if you qualify for the Small Business Program (under
US$1M/year) else **30%**. Apple pays after their fiscal calendar, to the
bank on the paid apps contract.

### Google Play

1. Play Console account (US$25 one-time). Personal accounts still need 12
   testers × 14 days before production. Details in [`DEPLOYMENT.md`](DEPLOYMENT.md).
2. Monetize → Products → Subscriptions → `cosmic_pro_yearly`.
3. Payments profile (can be the same Google payments profile as AdMob, but
   Play and AdMob reports stay separate).
4. Play Billing Library via `in_app_purchase` or RevenueCat.
5. Real-time developer notifications (RTDN) if you want reliable cancel /
   grace period handling. That **does** need a small backend or a vendor
   (RevenueCat) that receives them.

Commission: **15%** on the first US$1M/year of digital goods, **30%** after,
for this kind of consumer app.

### RevenueCat (optional, recommended for a one-person team)

[RevenueCat](https://www.revenuecat.com) sits between the app and both stores:

- One Flutter SDK instead of two billing implementations.
- Restore, intro offers, and webhook-style events without you hosting
  StoreKit server notifications on day one.
- A dashboard of MRR.

You still create the products in App Store Connect and Play Console.
RevenueCat does not replace Apple or Google accounts. It takes its own cut
on some plans; the free tier is enough to start.

### Wiring in this codebase

Today:

```text
Entitlement.testing  →  isPro = true, adsAllowed = false
```

Phase 3:

```text
isPro = store says subscription is active
adsAllowed = !isPro
```

Keep `Entitlement` as the only API screens use. Put StoreKit/Play/RevenueCat
behind `services/purchases/`. The Cosmic Pro screen’s Restore button stops
being a snackbar.

Do **not** unlock Pro from a homemade server receipt check unless you are
ready to run that server. For MVP, store-signed receipts + Restore is enough
on mobile.

### GitHub Pages / web

Static hosting cannot complete Apple or Google IAP. Choices (pick in Phase 3,
record in a new ADR if you charge on the web):

1. **Preview only** — web stays `Entitlement.testing` or a clearly labelled
   demo. Money only on iOS/Android. Simplest.
2. **Stripe Checkout** — needs a backend (Cloud Function / Cloud Run) and
   a customer portal. Not in this repo yet.
3. **RevenueCat Web Billing** — still needs their web flow and a place to
   host success/cancel URLs; GitHub Pages can be the front, not the webhook
   target.

Until one of those exists, **do not promise “Subscribe” on the web build.**

---

## 3. Order of operations (first real dollar)

Do this in order. Skipping privacy or test ads is how accounts get banned.

1. Privacy policy page on GitHub Pages (birth data local; ads; purchases).
2. Apple Developer + Play Console (see [`DEPLOYMENT.md`](DEPLOYMENT.md)).
3. AdMob apps + **test** banner units; Google payments profile.
4. App Store Connect + Play subscription products; store banking/tax.
5. `app-ads.txt` at the developer site URL.
6. TestFlight / Play internal: Restore, subscribe, cancel, ads shown only
   when not Pro, **no ads on Pulse**.
7. Production ad unit IDs and production product IDs in the release flavor.
8. Submit store listings. Do not auto-promote from every `main` push.

### First-year cash (indicative, not a forecast)

| Item | You pay |
| --- | --- |
| GitHub Pages | $0 (public repo) |
| Google Play | $25 once |
| Apple Developer | $99 / year |
| AdMob | $0 to join |
| RevenueCat | $0 on the free tier |

| Item | They pay you |
| --- | --- |
| AdMob | After threshold, minus nothing extra besides invalid-traffic risk |
| Apple / Google subscriptions | Price minus 15% or 30% |

---

## 4. What this repo will not do yet

- Live AdMob or StoreKit calls (Phase 2 stays testing entitlement).
- Clicking ads from CI or from developer devices with production IDs.
- A backend for web checkout.
- Analytics of birth dates.

When the first store binary is close, follow [`PHASE_3.md`](PHASE_3.md)
workstreams 3.2 and 3.3 and keep this runbook updated if product IDs change.
