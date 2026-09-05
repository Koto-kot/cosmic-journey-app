# Phase 3 plan

**Status:** Planned. Phase 2 surfaces are in the tree and still run as
`Entitlement.testing` (Pro on, ads off).  
**Depends on:** [ADR 0002](adr/0002-monetization-ads-and-pro-subscription.md),
[ADR 0005](adr/0005-entitlement-flags-before-store.md),
[`MONETIZATION.md`](MONETIZATION.md), [`DEPLOYMENT.md`](DEPLOYMENT.md).

Phase 3 is not a redesign. Phase 2 already looks like the paid app. Phase 3
connects **stores**, **money**, and the **two heavy platform features**
(widgets, Scientific Mode), plus notifications and extra local profiles.

Do not auto-publish store binaries on every `main` push. Keep GitHub Pages
as the web preview.

---

## Goal

A person can:

1. Install Cosmic Journey from TestFlight or Play internal testing.
2. Use the free odometer with ads only on the allowed secondary screens.
3. Subscribe to Cosmic Pro (yearly), restore on a second device, and lose ads.
4. See a home-screen widget with the current distance class of number.
5. Optionally turn on Scientific Mode without a different live layout.

Web on GitHub Pages remains usable as a full preview. Charging on the web is
an explicit sub-decision (see 3.8), not a default.

---

## What is already done (do not rebuild)

| Surface | State |
| --- | --- |
| Pulse / Flow live screen | Shipped (ADR 0003) |
| Year-only onboarding + optional month/day/time | Shipped |
| Menu, Science, Settings, Share, Statistics, Styles | Shipped |
| Atmosphere catalog (generated beds, ADR 0006) | Shipped |
| `Entitlement` + empty `AdSlot` | Shipped (flags still testing) |
| Cosmic Pro screen + Restore stub | Shipped (no-op) |
| ENG / UA | Shipped |
| GitHub Actions + Pages | Shipped (ADR 0004) |

---

## Workstreams

Do them in the order below unless a note says they can overlap. Each
workstream should land with tests, ENG/UA copy, and an ADR only if it changes
a published rule.

### 3.1 Store presence (binaries exist)

**Why first:** ads and subscriptions cannot earn until Apple and Google have
an app record and a signed build.

- Privacy policy URL (GitHub Pages `/privacy` is enough). State: birth data
  on device; no account; AdMob on free iOS/Android; purchases via the stores.
- App icon 1024×1024 (replace the Flutter default). Screenshots of Pulse.
- Android upload keystore, backed up offline; `key.properties` not committed.
- Apple bundle id `com.cosmicjourney.cosmic_journey` in App Store Connect.
- Play: Data safety, content rating, closed-test 12×14 if the account is
  personal ([`DEPLOYMENT.md`](DEPLOYMENT.md)).
- CI: tag `vX.Y.Z` → AAB / IPA. **Manual** promote to production.
- Codemagic or GitHub macOS + Fastlane for iOS; Linux Actions can keep
  building the Android AAB.

**Exit:** a TestFlight build and a Play internal (or closed) track install
on real phones. Web Pages still deploys from `main`.

### 3.2 Cosmic Pro subscription

**Depends on:** 3.1. Follow [`MONETIZATION.md`](MONETIZATION.md) §2.

- App Store Connect subscription group + `cosmic_pro_yearly`.
- Play Billing base plan `cosmic_pro_yearly`.
- Banking/tax on both stores (otherwise you will not be paid).
- Flutter: `in_app_purchase` **or** RevenueCat, isolated in
  `services/purchases/`. Screens still only read `Entitlement`.
- Map active / grace / billing-retry → `isPro`. Expired → `isPro false`.
- Restore Purchases on the Cosmic Pro screen (replace the snackbar).
- Sandbox / license testers: subscribe, expire, restore, family of devices.
- Copy: yearly renewal, what Pro includes, ads removed. ENG + UA.
- Debug overlay or flavor to force free vs Pro **without** rewriting screens.

**Exit:** a sandbox subscriber is Pro; a lapsed sandbox user is free; Restore
works offline for a previously purchased subscription (store cache).

**ADR:** only if you add monthly SKUs in a second group, lifetime IAP, or
web Stripe. Same group + same `isPro` does not need a new ADR (ADR 0002).

### 3.3 Ads on the free app

**Depends on:** 3.1. Can overlap 3.2. Follow [`MONETIZATION.md`](MONETIZATION.md) §1.

- AdMob iOS + Android apps, **test** banner units first.
- `app-ads.txt` at the developer site.
- `google_mobile_ads` loaded only from `AdSlot` / `services/ads/`.
- `adsAllowed = !isPro` in the store-backed `Entitlement`.
- Four placements: Menu, Science, Styles, Statistics footers. Nothing else.
- `kIsWeb` → empty. No AdSense on Pages.
- iOS: SKAdNetwork list; ATT only if personalized ads are on (default off).
- Production ad unit IDs in release; test IDs in debug/CI.
- Manual QA: Pro user never sees a banner; free user never sees a banner on
  Pulse, year wheel, or share.

**Exit:** test ads fill on a free debug build; Pro build shows none; analyze
and tests still do not need a network.

### 3.4 Home / lock-screen widgets

**Depends on:** 3.1 (native projects). Pro-gated (`widgetsUnlocked`).

- iOS WidgetKit + Android glance / home widgets.
- Show a compact distance (for example `674.2B km`) and optionally days.
- Respect OS update budgets; **do not** run the astronomy integrator in the
  widget process. Read a small snapshot written by the app on a timer or on
  resume (distance itself is still not a “saved journey”; it is recomputed
  from birth + now when the widget refreshes).
- Placeholder “Widgets” menu row becomes the real explain + add instructions.
- Lock-screen / Play store widget where the OS allows it; skip rather than
  fake it on web.

**Exit:** widget on a device home screen updates at least hourly and after
app open; web still shows the Phase 3 explanation.

### 3.5 Scientific Mode

**Depends on:** nothing from the stores. Can start in parallel with 3.1.

- New `JourneyCalculator` implementation behind the existing interface
  (`ARCHITECTURE.md`). Default remains `AverageCmbJourneyCalculator`.
- `V_earth_cmb(t) = V_solar_cmb + V_earth_orbit(t)`, speed = magnitude,
  distance = integral over time. Document constants in `SCIENCE_MODEL.md`.
- Cache / coarse stepping so the live screen never integrates per frame.
- Pulse and Flow both consume the same snapshots.
- Settings toggle; Pro-gated. Science screen explains both models.
- Tests: leap years, known epoch vs NASA-ish order of magnitude, no claim of
  “distance from the centre of the Universe.”

**Exit:** toggling Scientific Mode changes the number, stays stable on
resume, and is documented.

### 3.6 Milestone notifications and chime

**Depends on:** 3.1 for permission prompts on real devices. Can be prototyped
on simulators.

- Local notifications only. No backend.
- Fire when a configured interval is crossed (10M / 100M / 1B / custom).
- Quiet copy: “You have travelled another 100,000,000 km.”
- Optional short chime; never on the Pulse tick itself.
- Settings: opt-in, respect OS permission denial (`PRODUCT_SPEC.md` §22).
- Pro-gated for custom interval + chime; basic 10M/100M/1B may stay free.

**Exit:** backgrounded app still delivers a local notification at the next
threshold (within OS limits); denied permission does not crash.

### 3.7 Multiple local profiles and journey replay

**Depends on:** storage model, not stores.

- More than one `JourneyProfile` on device (household / “what if”).
- Switcher off the live screen (Settings or a small list). No cloud, no
  account (still `AGENTS.md` rules 5–6).
- Replay: scrub a local timeline of the same calculator; do not persist
  distance. Pro-gated.
- Tests for switching profiles and for approximate vs exact births.

**Exit:** two profiles on one device; numbers follow the selected birth;
replay cannot be confused with the live odometer (different screen).

### 3.8 Web monetization decision

**Depends on:** 3.2 if you want the same SKU story.

Pick **one** and write an ADR before charging in the browser:

| Option | When to pick |
| --- | --- |
| A. Preview only | Default. Web stays demo/testing entitlement. Money on iOS/Android only. |
| B. Stripe + tiny backend | You want web subscribers and will operate webhooks. |
| C. RevenueCat Web Billing | You already use RevenueCat for mobile and accept their web flow. |

Do not put AdSense on GitHub Pages in Phase 3 unless a separate ADR covers
Google’s site requirements and the product still forbids ads on the odometer.

**Exit:** an accepted ADR 0007 (or similar) plus matching copy on the web
Pro screen (“Subscribe on iOS/Android” vs a real Checkout button).

---

## Suggested sequence

```text
3.5 Scientific Mode          ─┐
3.7 Profiles / replay        ─┼─ can overlap; no store account needed
3.1 Store listings/signing   ─┘
        │
        ├─► 3.2 Subscription + Restore
        ├─► 3.3 AdMob in AdSlot
        ├─► 3.4 Widgets
        └─► 3.6 Notifications
                │
                └─► 3.8 Web money ADR (only if you will charge on web)
```

Do not flip `Entitlement.testing` off in `main` until 3.2 and 3.3 are
verified on TestFlight/Play with **test** ads and **sandbox** purchases.

---

## Acceptance criteria

Phase 3 is done when:

1. TestFlight and Play internal builds exist for the same Flutter tree.
2. Free user: ads only in the four `AdSlot` footers; Pulse stays clean.
3. Subscriber: `isPro`, no ads, atmospheres/styles/widgets rules match
   Phase 2’s Pro list.
4. Restore Purchases recovers Pro on a second device of the same platform.
5. Privacy policy and store questionnaires match actual data use.
6. Scientific Mode is optional, documented, and behind the same live screen.
7. At least one home-screen widget works on iOS or Android.
8. Web preview still deploys from `main` and does not claim a fake web
   checkout unless 3.8 shipped.
9. No birth date leaves the device for analytics.
10. ADRs updated if any of 1–9 required a product-rule change.

---

## Out of scope (later than Phase 3)

Product ideas that might follow Phase 3 (sky of the first day, extra
stats, replay, astrology-as-map) live in [IDEAS.md](IDEAS.md). They are
not committed work.

- Accounts, email, cloud sync of birth dates.
- GPS / Health permissions.
- Launch interstitial or rewarded ads.
- Social graphs, public leaderboards.
- Auto-submit to App Store / Play production from CI.
- Replacing generated atmospheres with licensed NASA/ESA audio (would need
  a new ADR; see 0006).

---

## Docs to touch when a workstream lands

| Workstream | Update |
| --- | --- |
| 3.1 | `DEPLOYMENT.md` checklist; maybe `/privacy` |
| 3.2 / 3.3 | `MONETIZATION.md` product IDs; `AGENTS.md` only if rules change |
| 3.4 | `PRODUCT_SPEC.md` §15; Phase 2 widgets row |
| 3.5 | `SCIENCE_MODEL.md`, `ARCHITECTURE.md` |
| 3.8 | New ADR |

Keep old ADRs. Supersede them; do not rewrite history in place.
