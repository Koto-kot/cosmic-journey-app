# ADR 0006: Generated in-app soundscapes

- **Status:** Accepted
- **Date:** 2026-09-05
- **Supersedes:** none

## Context

Atmosphere needs looping beds with a clear commercial license. Shipping
third-party WAVs means attribution, store size, and “can we sell this in Pro?”
questions. The first Deep Space loop is already synthesized in Dart.

## Decision

All catalog beds are **generated in-app** as seamless PCM loops
(`DeepSpaceLoop.wrapWav` / `ProSoundscapes._harmonic`).

- Free: `deep_space` only.
- Pro: additional harmonic beds registered on `SoundscapeCatalog` (Orbital
  Drift, Aurora, Blue Planet, Interstellar, Voyager, Deep Silence, Solar Wind,
  Ionosphere, Red Dwarf, Quiet Station, Comet Tail, Magnetosphere).
- New beds add an id, a builder, ENG/UA names, and a catalog entry. They do
  not touch the live journey screen.
- No audible one-second tick. Reduced motion does not have to mute audio;
  the existing on/off toggle does.

Licensed or recorded space audio would need a new ADR and a license file.

## Consequences

- Loops are small in source and commercially clear.
- Timbre variety is limited compared with real field recordings; that is an
  accepted trade for Phase 2/3.
- Unlocking a bed is an entitlement check, not a download.
