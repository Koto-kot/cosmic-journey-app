# ADR 0010: Interface Styles (Cosmic Minimal / Shuttle Cockpit)

- **Status:** Accepted
- **Date:** 2026-09-06
- **Supersedes:** none — adds a new personalization axis alongside 0006's
  soundscapes and the existing color-palette system

## Context

The product needed a second way to *present* the same journey math: a
captain's-seat cockpit view (panoramic window, DISTANCE + FLIGHT TIME
panels) alongside the existing Earth/three-counters main screen. The
product spec (`COSMIC_JOURNEY_INTERFACE_STYLES_SHUTTLE_SPEC_UA.md`) was
explicit that this must be a second **interface style**, never confused
with the existing four **color palettes** (Void/OLED/Midnight/Aurora), and
must not duplicate the journey-calculation engine.

## Decision

**Two independent personalization axes:**

- `JourneyStyle` (`core/journey_style/journey_style.dart`): `cosmicMinimal`
  | `shuttleCockpit`. Controlled by `JourneyStyleController`
  (`app/journey_style_controller.dart`), persisted via
  `JourneyStyleStore`/`journey_style_v1` — the exact same
  controller/store/enum shape as `ReadoutModeController`.
- `ThemeController`'s color palette is untouched. The Styles screen now has
  two clearly separate sections (`INTERFACE STYLE`, `COLOR PALETTE`); every
  combination of style × palette is valid.

**One shared engine, two presentations:** `JourneyScreen` is now a
container. It owns the single `LiveJourneyController` (ticker, pulse
animation, lifecycle) exactly as before, and its `build()` does nothing
but switch which view renders the current `JourneySnapshot`:

```dart
switch (journeyStyleController.style) {
  case JourneyStyle.cosmicMinimal: CosmicMinimalView(...)
  case JourneyStyle.shuttleCockpit: ShuttleCockpitView(...)
}
```

wrapped in an `AnimatedSwitcher` (300ms crossfade, `Duration.zero` under
reduced motion) so switching never resets the controller, never recreates
the calculator, and never restarts the ticker — only the widget subtree
swaps.

`CosmicMinimalView` (`features/journey/views/cosmic_minimal/`) is the
previous `JourneyScreen` body extracted verbatim — same Stack layout, same
corner controls, same widgets. Both views share a `JourneyTopBar` (menu +
locale, optional center label) so neither duplicates that chrome.

`ShuttleCockpitView` (`features/journey/views/shuttle_cockpit/`):

- `ShuttleWindow`/`ShuttleStarfield`: a 3-layer starfield radiating from a
  vanishing point, ~46s per full traversal (8x slower under reduced
  motion), paused via `WidgetsBindingObserver` when the app backgrounds.
  No streaks, no warp speed.
- `DistancePanel`: the whole-km odometer, peak-normalized glow tied to the
  same `pulseGlow()` used by Cosmic Minimal's `GlowDivider`.
- `FlightTimePanel`: `DAYS / HRS / MIN / SEC`. The written spec's base
  format omitted minutes (`DAYS/HRS/SEC`); product feedback during
  implementation asked for the minutes column back in, so the shipped
  default is `DAYS/HRS/MIN/SEC` — all four derived from one integer
  (`wholeElapsedSeconds`) via a single divmod chain, never from
  independently-computed fields.
- `CockpitControls`: reuses `AtmosphereToggle`/`TimeCoordinatesToggle`/
  `ReadoutModeToggle` verbatim (same controllers as Cosmic Minimal) inside
  a labeled instrument-panel row — no duplicated toggle logic.
- `TimeCoordinatesBlock` (START/NOW) is reused as-is, not rebuilt, so no
  second 1Hz timer exists anywhere in the cockpit.
- `CockpitTokens`: a fixed graphite/cyan palette, independent of
  `CosmicPalette` — the cockpit is a distinct visual identity, not a fifth
  color palette. Page-level chrome (Scaffold background, toggle icon
  colors) still comes from `CosmicTokens`, so palette switching still has
  a (subtle) effect even in the cockpit.

**Not built:** the real per-viewer audio playback state machine
(off/starting/playing/blocked/error) the spec recommended — existing
`enabled` boolean audio state was reused instead. Pro-gating Shuttle
Cockpit was explicitly deferred per the spec's own instruction not to gate
it during development/QA.

## Consequences

- Adding a third `JourneyStyle` later means: one more enum value, one more
  view directory, one more `switch` arm in `JourneyScreen` — the shared
  controller/calculator/ticker are untouched by construction.
- Any state shared between styles (audio, time coordinates, readout mode)
  must go through the existing `AppDependencies` controllers, never a
  view-local field — `journey_style_switch_test.dart` asserts this
  explicitly (toggling TIME/MODE in one style must read back correctly
  after switching to the other).
- `FlightTimePanel`'s DAYS/HRS/MIN/SEC breakdown is a deliberate departure
  from the written spec's DAYS/HRS/SEC base format; if that's revisited,
  update this ADR rather than silently drifting from it again.
