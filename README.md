# Cosmic Journey

A Flutter app that shows, in real time, how far and how long you have travelled
through space since birth.

The main screen is a live odometer: kilometres and seconds keep moving, days
accumulate, and nothing else competes for attention.

## Milestone 1

This repository currently implements the first working slice:

- onboarding with birth **year** only
- local storage of that year
- `AverageCmbJourneyCalculator` (constant CMB-relative speed)
- live main screen: distance, days, seconds, minimal menu
- animation pauses in the background and recalculates from wall-clock time on resume

Menu destinations for widgets, styles, and Cosmic Pro are visible placeholders.

## Repository layout

```text
├── AGENTS.md
├── docs/
│   ├── PRODUCT_OVERVIEW.md
│   ├── PRODUCT_SPEC.md
│   ├── ARCHITECTURE.md
│   ├── SCIENCE_MODEL.md
│   └── DEPLOYMENT.md
└── app/                  Flutter project (iOS, Android, web)
```

Read `AGENTS.md` and the files in `docs/` before changing behaviour.

## Run locally

You need [Flutter](https://docs.flutter.dev/install) stable (3.47 or later).

```bash
cd app
flutter pub get
flutter run
```

Web (useful for a quick desktop preview):

```bash
cd app
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 43151
```

## Test

```bash
cd app
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
```

## CI/CD and hosting

Pushing to `main` on GitHub (`Koto-kot/cosmic-journey-app`) runs format,
analyze, and tests, then hosts the Flutter **web** build on GitHub Pages.

Hosted URL after the first green deploy:

https://koto-kot.github.io/cosmic-journey-app/

The workflow tries to set Pages source to **GitHub Actions**. If the first
deploy waits, approve the `github-pages` environment under
**Settings → Environments**, and confirm **Settings → Pages → Source:
GitHub Actions**. Details and store-release notes are in
[`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md).

## Science, in one line

Distance is `elapsedSeconds × 370 km/s`, an estimated path length relative to
the CMB rest frame — not a distance from the centre of the Universe. See
`docs/SCIENCE_MODEL.md`.
