# ADR 0004: GitHub Pages as the web host

- **Status:** Accepted
- **Date:** 2026-09-05
- **Supersedes:** none

## Context

The public GitHub repository `Koto-kot/cosmic-journey-app` is the URL people
open in a browser. Cursor also keeps a working copy on a separate git remote.
If only one remote receives Dart changes, the tab icon can update (favicon)
while the hosted Flutter app stays an old build.

GitHub Actions `GITHUB_TOKEN` cannot enable Pages via the REST API
(`Resource not accessible by integration`, HTTP 403). Pages must be set to
**Source: GitHub Actions** once in the GitHub UI.

## Decision

- Host the Flutter **web** release on GitHub Pages from `main`.
- CI: format, analyze, test on every push/PR; `flutter build web` +
  `deploy-pages` only on `main`.
- Do not call the Pages create/update API from the workflow.
- `--base-href` comes from `actions/configure-pages` so the project site
  works under `/cosmic-journey-app/`.
- Copy `index.html` to `404.html` so nested refreshes still boot the app.
- Favicon and PWA icons are the painted Earth (`favicon.svg` plus
  `tool/generate_web_icons.py` at deploy time). Do not rely on MCP to upload
  PNG binaries.
- Product Dart must land on **GitHub `main`**, not only on the Cursor remote,
  or the public site will stay stale.

## Consequences

- Public preview URL:
  https://koto-kot.github.io/cosmic-journey-app/
- No StoreKit, Play Billing, or AdMob on this host (see ADR 0002).
- Custom domain / Firebase Hosting remains optional (`docs/DEPLOYMENT.md`).
- Every feature meant to be “on the web version” has to be committed to the
  GitHub repo or it will not appear, even if a local preview is current.
