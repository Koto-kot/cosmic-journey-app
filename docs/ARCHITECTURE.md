# Architecture

## Goal
Keep the first version small, local, testable and replaceable.

The calculation engine must be independent of UI so the simple average-speed model can later be replaced or supplemented by Scientific Mode.

## Recommended stack

### Client
Flutter / Dart

### State management
Use one lightweight approach:
- Riverpod, or
- Bloc/Cubit, or
- simple ValueNotifier where enough.

Do not mix multiple state-management systems.

### Storage
Use simple local persistence for MVP.
Move to a structured local database only if future features require it.

### Notifications
Local notifications through a maintained Flutter plugin.

### Purchases
A maintained Flutter-compatible abstraction for:
- Apple StoreKit 2 (auto-renewable Cosmic Pro yearly);
- Google Play Billing subscriptions.

Screens read `Entitlement` only. Store SDKs stay in `services/purchases/`.
See `docs/adr/0002-monetization-ads-and-pro-subscription.md`.

### Ads
Optional layer, isolated from journey logic. Only `AdSlot` may load an ads
SDK (AdMob on iOS/Android). Never on the live journey screen.

## Suggested folders

```text
app/
└── lib/
    ├── main.dart
    ├── app/
    ├── core/
    ├── features/
    │   ├── onboarding/
    │   ├── journey/
    │   ├── milestones/
    │   ├── science/
    │   ├── settings/
    │   └── pro/
    └── services/
        ├── journey_calculator/
        ├── local_storage/
        ├── notifications/
        └── purchases/
```

## Journey calculation boundary

Define an abstraction such as:

```text
JourneyCalculator
- JourneySnapshot calculate(at, profile)
- double currentSpeed(at, profile)
```

### JourneySnapshot
- elapsedSeconds
- fullDays
- distanceKm
- speedKmPerSecond
- isApproximate
- calculatedAt

UI depends on this abstraction, not on formula details.

## MVP calculator
`AverageCmbJourneyCalculator`

Responsibilities:
- receive canonical birth timestamp;
- receive current timestamp;
- calculate elapsed time;
- multiply elapsed seconds by configured average speed;
- return snapshot.

## Future calculator
`ScientificCmbJourneyCalculator`

May include:
- Earth's orbital state;
- vector math;
- speed calculation;
- numerical integration;
- caching.

Both calculators should satisfy the same interface.

## Live ticker
Separate physics from presentation.

Calculation layer:
- refresh authoritative snapshot periodically.

Presentation layer:
- interpolate from last snapshot.

Concept:

`displayDistance = baseDistance + speed * elapsedSinceBase`

## Lifecycle

### Foreground
- ticker active;
- values animate;
- periodic reconciliation.

### Background
- stop visual ticker.

### Resume
- get current time;
- calculate new snapshot;
- refresh UI;
- restart ticker.

## Persistence
Persist profile/settings, not live distance.

Distance is always derived from time.

## Time source
Wrap time behind a `Clock` abstraction.

Production:
- system clock.

Tests:
- fake/fixed clock.

## Formatting
Dedicated formatters for:
- kilometres;
- days;
- seconds;
- compact billions/trillions as full words (`billion` / `млрд`);
- locale decimals.

Both readout modes read integers only on the main screen (`formatFullNumber`)
and show a secondary `formatHumanScale` line — Pulse recalculates once a
second, Continuous recalculates on a throttled ~10Hz presentation ticker.
Neither mode shows decimal digits on the main counters, and live
interpolation between frames is not used on the default journey screen. See
`docs/adr/0007-continuous-mode-journey-start-and-time-coordinates.md`.

## Audio
Ambient sound is a separate service from Cosmic Pulse.

- free catalog currently contains one original loop, Deep Space
- preference is off by default and persisted locally
- Pro soundscape ids can be added to the catalog later without changing the live screen
- the pulse must never emit an audible one-second tick

## Notifications
Milestones should be scheduled from derived thresholds, not background counting.

Flow:
1. calculate current distance;
2. find next threshold;
3. estimate crossing timestamp;
4. schedule local notification;
5. reschedule if model/settings change.

## Purchases
Use a dedicated purchase service.

UI asks only:
- is Pro active?
- can purchase?
- restore purchase?

## Themes
Use theme tokens, not hard-coded values.

Free and Pro themes share the same layout.

## Scientific configuration
Keep physical constants/source notes in one module, for example:

```text
ScienceConstants
- averageCmbSpeedKmPerSecond
- modelVersion
- referenceFrameName
- sourceNotes
```

## Tests

### Unit
- journey calculator;
- clock;
- approximate date conversion;
- number formatter;
- milestone calculator.

### Widget
- main screen renders three values;
- fake time changes values;
- localisation;
- reduced motion.

### Integration
- onboarding to main screen;
- save/relaunch;
- restore settings;
- notification configuration;
- Pro gating.

## CI
GitHub Actions (`.github/workflows/ci.yml`) on push/PR:
1. install Flutter 3.47.2 stable;
2. flutter pub get;
3. dart format --output=none --set-exit-if-changed .;
4. flutter analyze;
5. flutter test.

On a successful push to `main` the same workflow also:
6. flutter build web --release;
7. deploy `app/build/web` to GitHub Pages.

Store uploads (TestFlight / Play) are not automatic. See `docs/DEPLOYMENT.md`.

## First implementation sequence
1. Repository + Flutter scaffold
2. Clock/profile/calculation engine
3. Onboarding + local persistence
4. Main live screen
5. Menu + Science + Settings
6. Milestones + notifications
7. Cosmic Pro + themes
8. Widgets + advanced features

## Non-goals
Do not start with:
- microservices;
- remote database;
- GraphQL;
- authentication;
- event streaming;
- unnecessary architecture boilerplate.
