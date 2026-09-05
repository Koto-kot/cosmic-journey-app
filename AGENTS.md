# AGENTS.md

## Project
Cosmic Journey

## Mission
Build a calm, beautiful mobile app that visualises a person's journey through space from birth until the present moment.

## Technology
Use Flutter and Dart.
Prefer a single codebase for iOS and Android.
Do not add a backend unless a real product requirement later makes it necessary.

## Core rules
1. Main screen contains only:
   - cosmic distance and its human-scale subtitle;
   - total days;
   - total seconds and its human-scale subtitle;
   - Earth / quiet cosmic visual;
   - language switch;
   - optional atmosphere control;
   - minimal menu control.
2. Default live readout is Cosmic Pulse: distance and seconds update once
   per second from the same timestamp. Flow (per-frame decimals) is an
   optional, persisted mode. See `docs/adr/0003-dual-readout-pulse-and-flow.md`.
3. No explanatory paragraphs on the main screen.
4. No ads on the main screen.
5. No registration, email, phone, password, or account in MVP.
6. Birth data stays local in MVP.
7. Core experience works offline.
8. Base app is free.
9. Cosmic Pro is an auto-renewable **subscription** (yearly primary). The
   free app may show ads only in `AdSlot` on Menu / Science / Styles /
   Statistics. Never on Pulse, the year wheel, share, or as a launch
   interstitial. See `docs/adr/0002-monetization-ads-and-pro-subscription.md`
   and `docs/MONETIZATION.md`. Until store binaries exist, use
   `Entitlement.testing` (`isPro = true`, `adsAllowed = false`).
10. Never describe the distance as absolute distance or distance from the centre of the Universe.
11. Scientific assumptions must be documented.
12. Product-rule changes get an ADR in `docs/adr/`. Specs stay present-tense.

## UX priorities
1. Cosmic Pulse is the default calm update; Flow is opt-in.
2. Legibility.
3. Fast launch.
4. Calm visual hierarchy.
5. Battery efficiency.
6. Scientific transparency.

## Performance
- Pause animation when app is not visible.
- Recalculate from wall-clock time on resume.
- Avoid network calls on main screen.
- Avoid heavy calculations per frame.
- Keep calculation logic outside widgets.

## State
Store locally:
- birth year/date/time;
- whether birth data is approximate;
- theme;
- milestone settings;
- notification settings;
- Pro entitlement cache;
- locale/preferences;
- ambient audio on/off.

## Time handling
Use UTC internally.
Convert user-entered local birth time to a canonical timestamp.
If only a year is supplied, use a documented approximation.

## Scientific model
### MVP
Use one configurable average CMB-relative speed constant.

### Future Scientific Mode
May calculate:
- Solar System velocity relative to CMB;
- Earth's orbital velocity vector;
- time-dependent vector sum;
- numerical integration of speed.

Keep this replaceable and independent from UI.

## Code quality
- Null safety.
- Immutable models where practical.
- Small testable services.
- No business logic in widgets.
- Keep dependencies minimal.
- Add tests for formulas and time handling.

## Suggested folders
```text
lib/
├── app/
├── core/
├── features/
│   ├── onboarding/
│   ├── journey/
│   ├── milestones/
│   ├── settings/
│   └── pro/
└── services/
    ├── journey_calculator/
    ├── local_storage/
    ├── notifications/
    └── purchases/
```

## Test at minimum
- elapsed seconds;
- full days;
- approximate distance;
- leap years;
- timezone/DST transitions;
- app resume;
- large-number formatting;
- milestone threshold detection.

## For every substantial task
1. Read this file.
2. Read `docs/PRODUCT_SPEC.md` and `docs/adr/README.md`.
3. Implement the smallest coherent change.
4. Add/update tests.
5. Format/analyse/test.
6. Summarise changed files.
7. Call out assumptions or scientific changes.
8. If a published rule changed, add or supersede an ADR.

## Do not add unless requested
- authentication;
- backend (store webhooks / Stripe are Phase 3 only if 3.8 chooses them);
- analytics SDKs;
- trackers;
- launch interstitial ads;
- GPS/location permissions;
- health permissions;
- social-network features.
