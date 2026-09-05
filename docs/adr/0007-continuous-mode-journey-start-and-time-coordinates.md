# ADR 0007: Continuous mode, Journey Start, and optional time coordinates

- **Status:** Accepted
- **Date:** 2026-09-05
- **Supersedes:** The "three decimal places" requirement for Flow in
  [ADR 0003](0003-dual-readout-pulse-and-flow.md). Pulse itself, and the rest
  of ADR 0003, are unchanged.

## Context

`docs/CODEX_ADDITIONAL_INSTRUCTIONS_V2.md` asked for five things that do not
fit inside the existing specs without a rule change:

1. Optional month/day/time precision editing needs its own menu entry
   ("Journey Start"), separate from Settings, with a subtitle that never
   fabricates an exact date for a year-only profile.
2. Ambient audio needed an audible fade-in and a default volume inside the
   recommended 0.15-0.25 range, plus a guard against restarting an
   already-playing loop.
3. The alternate readout mode ("Flow") was specified with three decimal
   places, updated every frame. The new instructions ask for whole numbers
   only, refreshed a few times a second (5-10Hz) instead of once per frame.
4. An optional, visually secondary start/current date-time layer.
5. Product-facing copy should call the alternate mode "Continuous", not
   "Flow".

## Decision

**Continuous mode** (`ReadoutMode.flow` — the persisted id and enum name are
unchanged to avoid a data migration; only product-facing copy changes):

- Shows integer kilometres and seconds only. No fractional digits anywhere
  on the main screen, in either mode.
- Refreshes on a throttled presentation ticker (`continuousEvery`, default
  100ms / 10Hz) instead of every frame. Every tick still recalculates from
  the actual clock (`JourneyCalculator.calculate`); the ticker only throttles
  how often the UI redraws, exactly as Pulse already does at 1Hz.
- UI label: "Continuous" / "Безперервний". Settings section label: "Counter
  motion" / "Рух лічильника".

**Journey Start** is a new menu item (`JOURNEY START` /
`ПОЧАТОК ПОДОРОЖІ`) and screen (`JourneyStartScreen`), carrying the
year/month/day/time editor that used to live inside Settings. Settings keeps
Counter motion, the time-coordinates toggle, and language. The menu subtitle
and the optional main-screen block both use `JourneyStartPrecision.subtitle`,
which never shows a fabricated exact date:

| Profile state | Subtitle |
| --- | --- |
| Year only | `{year} · approximate` |
| Date known, time unknown | `{date} · time unknown` |
| Date and time known | `{date} · {time}` |

**Time coordinates**: an optional block below the Earth visual and above the
distance counter, showing journey start (using the table above) and the
current date/time (`dd.MM.yyyy · HH:mm:ss` / `dd MMM yyyy · HH:mm:ss`). It
ticks on its own 1Hz timer, independent of the readout mode's cadence, so
switching to Continuous does not speed it up. Off by default
(`show_time_coordinates_v1`), visually secondary (small, muted, no border),
toggled in Settings.

**Ambient audio**: default volume lowered to 0.2 (was 0.32; recommended
range 0.15-0.25), fades in over ~1.5s from 0 to the configured volume, and
`_startIfAllowed` is now a no-op while already playing so re-entrant calls
(e.g. a lifecycle resume racing a manual enable) cannot restart the loop
from zero or create a second overlapping instance. Volume is user-adjustable
from the Atmosphere screen and persisted (`ambient_audio_volume_v1`).

## Consequences

- `AGENTS.md` core rule 2 is updated to describe Continuous instead of Flow.
- Existing Flow-mode tests that asserted three-decimal rendering and
  per-frame updates were rewritten for integer rendering and throttled
  cadence; no other Pulse behaviour changed.
- `SettingsScreen` no longer edits birth data; `phase2_screens_test.dart`
  was split so the birth-editing assertions target `JourneyStartScreen`.
- The real `audioplayers`-backed controller (fade-in, playback guard,
  lifecycle pause/resume) still has no automated test coverage — the same
  pre-existing gap noted before this change, since exercising the platform
  plugin needs channel-level mocking. `SilentAmbientAudioController` covers
  the persistence/state-machine logic that is testable without it.
