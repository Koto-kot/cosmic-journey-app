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
   - cosmic distance;
   - total days;
   - total seconds;
   - minimal menu control.
2. No explanatory paragraphs on the main screen.
3. No ads on the main screen.
4. No registration, email, phone, password, or account in MVP.
5. Birth data stays local in MVP.
6. Core experience works offline.
7. Base app is free.
8. Cosmic Pro is a one-time purchase. No subscription.
9. Never describe the distance as absolute distance or distance from the centre of the Universe.
10. Scientific assumptions must be documented.

## UX priorities
1. Continuous live motion of numbers.
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
- locale/preferences.

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
2. Read `docs/PRODUCT_SPEC.md`.
3. Implement the smallest coherent change.
4. Add/update tests.
5. Format/analyse/test.
6. Summarise changed files.
7. Call out assumptions or scientific changes.

## Do not add unless requested
- authentication;
- backend;
- analytics SDKs;
- trackers;
- subscriptions;
- launch interstitial ads;
- GPS/location permissions;
- health permissions;
- social-network features.
