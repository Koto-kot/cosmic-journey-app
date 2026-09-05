# ADR 0008: WebGL Earth via React Three Fiber on Flutter web

- **Status:** Accepted
- **Date:** 2026-09-05
- **Supersedes:** none (narrows Cosmic Pulse tech spec §9 on **web** only)

## Context

The live screen used a CustomPaint globe (`EarthHero`) so the old JPEG’s
black rectangle would not sit on the cosmic backdrop. A later change
request asked for a slowly rotating **night** Earth with city lights,
atmosphere, and the existing blue orbital ring, implemented with
`three` / `@react-three/fiber` / `@react-three/drei`.

The product is still a Flutter app (`AGENTS.md`). Replacing the whole
client with React would throw away Pulse, l10n, entitlement, and the
store path. Running R3F inside iOS/Android would mean a WebView on the
sacred screen (battery, opacity, hit-testing).

## Decision

1. Keep Flutter as the application shell.
2. Ship an isolated reusable `EarthCanvas` in `earth_canvas/` (React +
   R3F). Flutter web mounts it in the existing Earth slot through
   `HtmlElementView.fromTagName`. The Canvas is alpha-cleared so the
   Cosmic backdrop shows through.
3. iOS, Android, VM tests, and the Share screen keep CustomPaint (Share
   must not start a second WebGL context).
4. No OrbitControls, no drag/zoom, `pointer-events: none`.
5. One sidereal-feeling spin of **120 seconds**. `prefers-reduced-motion`
   and Flutter `disableAnimations` stop the spin after a single frame.
6. Pause the R3F `frameloop` when the document is hidden.
7. Night texture is a **bundled** NASA Earth-at-night still (public
   domain), resized to 2048×1024. No runtime CDN.
8. Do not touch Cosmic Pulse / Flow number code.

## Consequences

- GitHub Pages and local `flutter run -d chrome` show the WebGL globe.
- CI must `npm ci && npm run build` in `earth_canvas/` before
  `flutter build web`.
- Native store builds look like the painted Earth until a future ADR
  chooses Impeller shaders or a native glTF. That is accepted.
- `three` is a large JS payload, loaded only with the Flutter web
  bundle, not on iOS/Android.

## Not decided here

Scientific Mode, sky maps, and any lat/long UI stay out (see `IDEAS.md`).
