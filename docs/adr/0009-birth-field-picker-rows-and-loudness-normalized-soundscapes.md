# ADR 0009: Birth-field picker rows; loudness-normalized soundscapes

- **Status:** Accepted
- **Date:** 2026-09-06
- **Supersedes:** none (amends 0006's soundscape generation and the Journey
  Start screen introduced in 0007)

## Context

Two defects surfaced from real usage of the deployed web build:

1. **Journey Start's Month/Day fields used
   `DropdownButtonFormField`**, whose floating overlay menu read as broken —
   cramped, overlapping the Save button, easy to misread as non-functional.
   Year already used a plain wheel; Time already used a plain button opening
   `showTimePicker`. Month/Day were the odd ones out.
2. **Most Atmosphere soundscapes were inaudible, and the audible ones were
   very quiet.** Each preset's loop was generated with its own hand-picked
   partial amplitudes and a `gain` constant (`ProSoundscapes` in
   `soundscape.dart`), with no normalization step. Measuring the actual
   generated peaks showed up to an **8x loudness spread** between presets
   (`quiet_station`/`deep_silence` around 0.03-0.04 peak vs. `orbital_drift`
   around 0.24), then further attenuated by `defaultAmbientVolume` (0.2,
   lowered from 0.32 in the same session that added the fade-in). The
   quietest presets were not "quiet" — they were effectively silent on
   typical device speakers. Confirmed empirically: play() itself resolved
   without error for every preset (no functional/decode bug), so the report
   ("most don't work") was entirely a loudness-normalization gap, not a
   playback bug.

## Decision

**Journey Start**: Month and Day are now the same picker-row pattern as
Time — a tappable row (label + value + chevron, optional clear ✕) that opens
a `showModalBottomSheet` with a plain scrollable list of rows ("not set" +
the valid options), not a `DropdownButtonFormField`. `_showRowPicker` in
`journey_start_screen.dart` is the shared implementation; a sentinel int
(`_notSet = -1`) distinguishes "user picked not-set" from "sheet dismissed
without choosing" (both would otherwise resolve the picker's future to
`null`). `_OptionalDropdown` is removed.

Also fixed while touching this screen: `timeNotSet` ("Noon"/"Опівдні")
implied a time had already been chosen. It now reads "Not set"/"Не задано",
matching `dayNotSet`.

**Soundscapes**: `DeepSpaceLoop.normalizePeak` rescales every generated
waveform (Deep Space and all `ProSoundscapes._harmonic` beds) to a shared
`targetPeak` (0.92 of full scale) before quantizing to 16-bit PCM. Each
preset's `gain` and per-partial amplitudes now shape only *relative timbre*
(brightness, thinness), never overall loudness — normalization happens last.
`defaultAmbientVolume` raised from 0.2 to 0.45 now that a consistent peak
means "default volume" means the same thing for every preset.

`test/unit/soundscape_test.dart` locks in the normalized-peak invariant
across all 13 catalog entries. `deep_space_loop_test.dart`'s seamless-loop
assertion now scales its tolerance off `targetPeak` instead of a fixed
sample count tied to the old (lower, inconsistent) gain.

## Consequences

- Any new `ProSoundscapes` preset can pick whatever `gain`/partial balance
  sounds right for its timbre without separately worrying about matching
  loudness to the rest of the catalog — normalization handles that.
- The Atmosphere volume slider and `defaultAmbientVolume` now control
  perceived loudness consistently across every preset, not just the ones
  that happened to be generated loud.
- `_showRowPicker`'s sentinel-int pattern is the template for any future
  optional-int picker row in this codebase; do not reintroduce
  `DropdownButtonFormField` for this kind of field.
