# Science model (MVP)

This document records the scientific assumptions used in Milestone 1.

## What the number means

The displayed distance is an **estimated path length** relative to the
**cosmic microwave background (CMB) rest frame**.

It is **not**:
- distance from the centre of the Universe;
- a measured GPS path;
- an absolute position.

## Average speed

`AverageCmbJourneyCalculator` uses one constant:

```text
distanceKm = elapsedSeconds × 370 km/s
```

The constant lives in `app/lib/core/science_constants.dart` as
`ScienceConstants.averageCmbSpeedKmPerSecond`.

370 km/s approximates the Solar System barycentre velocity implied by the
CMB dipole (Planck 2018: 369.82 ± 0.11 km/s). Earth's orbital motion
(~30 km/s) and time-varying vector geometry are **not** included in this
mode.

## Time

- Internal timestamps are UTC.
- If the user supplies only a birth year, the app uses **1 July, 12:00
  local time at setup**, then stores the canonical UTC instant.
- If that instant is still in the future, the app falls back to 1 January
  12:00 local, then 1 January 00:00 local, then "now".
- Year-only results are marked `isApproximate = true`.

## Replaceability

A future Scientific Mode may replace this calculator without changing the
UI, as long as it returns the same `JourneySnapshot` shape.
