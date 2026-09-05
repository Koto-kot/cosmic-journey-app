# ADR 0003: Dual readout — Pulse and Flow

- **Status:** Accepted
- **Date:** 2026-09-05
- **Supersedes:** “Pulse only” wording in `AGENTS.md` core rule 2 and the
  Cosmic Pulse change request as a hard exclusive.

## Context

Cosmic Pulse was specified as integer kilometres and seconds that update
together once per second, with a 320 ms fade. That is the calm default.

Some people want the original interpolated “moving decimal” odometer. Those
are two presentation modes of the **same** `JourneyCalculator` snapshot, not
two science models.

## Decision

Ship both:

| Mode | Behaviour |
| --- | --- |
| **Pulse** (default) | Integer km and seconds, one shared timestamp per second, 320 ms transition. Reduced motion: instant. |
| **Flow** | Recalculate every frame; show three decimal places. |

Persist the choice locally (`readout_mode_v1`). Toggle on the live screen
(bottom-right) and in Settings. Distance is still never stored.

## Consequences

- The calculator and science copy stay identical in both modes.
- Flow uses more frames; pause when the app is not visible, same as Pulse.
- Agents must not remove Pulse. New live-screen chrome must work in both
  modes.
