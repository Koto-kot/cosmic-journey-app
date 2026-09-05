# Cosmic Journey

A Flutter app that shows, in real time, how far and how long you have travelled
through space since birth.

The main screen is a Cosmic Pulse odometer: kilometres and seconds update
together once per second, a human-scale subtitle explains the magnitude, and
days stay still between midnight boundaries.

## Milestone 1

This repository currently implements the first working slice:

- onboarding with birth **year** only
- local storage of that year
- `AverageCmbJourneyCalculator` (constant CMB-relative speed)
- live main screen: integer distance, days, seconds, human-scale subtitles
- Cosmic Pulse (one shared timestamp per second, soft 320 ms transition)
- optional Deep Space ambient loop, off by default
- ENG/UA language switch that persists locally
- animation pauses in the background and recalculates from wall-clock time on resume

Menu destinations:

- next milestone + current speed
- milestones (10M / 100M / 1B, plus a custom interval)
- statistics
- share (copy the live integers)
- widgets (still Phase 3)
- styles (Void, OLED, Midnight, Aurora)
- atmosphere catalog
- science
- Cosmic Pro (unlocked in this build)
- settings (optional month, day, time)

## Repository layout

```text
├── AGENTS.md
├── docs/
│   ├── README.md              index
│   ├── MONETIZATION.md        ads + Pro subscription payouts
│   ├── PHASE_2.md
│   ├── PHASE_3.md
│   ├── IDEAS.md               later free/Pro ideas (sky, philosophy)
│   ├── adr/                   decision history (do not delete)
│   └── …specs and science
└── app/                       Flutter project (iOS, Android, web)
```

Read `AGENTS.md`, `docs/README.md`, and `docs/adr/README.md` before changing
behaviour. How to get paid: [`docs/MONETIZATION.md`](docs/MONETIZATION.md).

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
analyze, and tests, then hosts a **new** Flutter web build on GitHub Pages.
Each deploy writes `build.json` with the commit SHA. The PWA service worker
is off so the browser cannot keep a stale app. Cursor `git push` does not
reach that GitHub repo; only commits on GitHub `main` are published.

Hosted URL after the first green deploy:

https://koto-kot.github.io/cosmic-journey-app/

The workflow deploys with `actions/configure-pages` and `actions/deploy-pages`.
It does **not** call the Pages create/update API: `GITHUB_TOKEN` cannot enable
Pages (`Resource not accessible by integration`, HTTP 403). Set this once in
the GitHub UI:

1. **Settings → Pages → Source: GitHub Actions**
2. Approve the `github-pages` environment under **Settings → Environments**

Details and store-release notes are in [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md).

## Science, in one line

Distance is `elapsedSeconds × 370 km/s`, an estimated path length relative to
the CMB rest frame — not a distance from the centre of the Universe. See
`docs/SCIENCE_MODEL.md`.
