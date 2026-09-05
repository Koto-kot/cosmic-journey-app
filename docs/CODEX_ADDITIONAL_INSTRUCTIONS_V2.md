# Cosmic Journey — Additional Codex Instructions

## Scope

Implement the next UX/behaviour iteration for the current Cosmic Journey web application.

This instruction supplements the existing project files:

- `AGENTS.md`
- `PRODUCT_SPEC.md`
- `ARCHITECTURE.md`
- `COSMIC_PULSE_TECH_SPEC.md`
- `COSMIC_PULSE_CHANGE_REQUEST.md`

Read those files first.

Do not redesign the product architecture from scratch.

The current application already calculates the journey correctly. This task is focused on:

1. improving birth-date precision;
2. fixing ambient audio behaviour;
3. cleaning up number display in Continuous mode;
4. adding an optional visible start/current date-time layer;
5. keeping Cosmic Pulse as the default counter mode.

---

# 1. Birth date precision — add optional day/month/time editing

## Current problem

The app currently allows the user to start with a birth year, but there is no clear place where the user can later optionally add:

- month;
- day;
- exact birth time.

This needs to be added.

## Product rule

The simple onboarding remains unchanged:

- user may enter only a birth year;
- app immediately works;
- exact date is optional.

Do not force exact date/time during first onboarding.

## Required new menu item

Add a secondary menu item:

**Ukrainian**  
`ПОЧАТОК ПОДОРОЖІ`

**English**  
`JOURNEY START`

Suggested subtitle examples:

If only year is known:

`1966 · приблизно`

English:

`1966 · approximate`

If full date is known:

`01.04.1966 · 08:45`

If date is known but time is not:

`01.04.1966 · час невідомий`

## Edit screen

Create a dedicated edit screen/modal/sheet for journey start.

Fields:

- Year — required
- Month — optional
- Day — optional
- Birth time — optional
- `Time unknown` option

Recommended flow:

1. Keep the existing year.
2. Allow user to optionally add month.
3. Allow day only when month is selected.
4. Allow time only when full date is known.
5. Save locally.
6. Immediately recalculate all counters after save.

## Approximate state

If only year is known:

- keep `isApproximate = true`;
- do not display a fake exact date on the main screen;
- do not pretend the app knows the exact start moment.

If full date is known but time is not:

- use a documented internal fallback time;
- keep a precision flag so the UI can still indicate that time is approximate.

If exact date and exact time are known:

- set `isApproximate = false`.

## Local persistence

Persist locally:

- year;
- month if known;
- day if known;
- time if known;
- precision flags.

Do not require account or cloud storage.

---

# 2. Ambient audio — make it actually playable

## Current problem

The UI contains atmosphere/audio functionality, but the music is not actually playing.

## Required behaviour

There must be one working free ambient soundscape.

Working name:

`Deep Space`

## Web playback behaviour

Do not rely on automatic audible playback immediately on page load.

Implement sound start from a user interaction.

Recommended flow:

1. App loads with audio OFF or pending.
2. User taps the sound icon or `Увімкнути атмосферу`.
3. Start audio playback.
4. Fade in smoothly.
5. Remember preference locally.
6. If a later session cannot start audible playback automatically, show the control in OFF/paused state rather than pretending audio is playing.

## Audio controls

Add a small, visually secondary control.

States:

- Audio ON
- Audio OFF

Optional settings:

- volume;
- selected soundscape.

## Volume

Default volume should be low and ambient.

Recommended starting range:

`0.15–0.25`

Exact value may be adjusted after testing.

## Loop

The track must:

- loop seamlessly;
- avoid audible gaps;
- avoid clicks at loop boundary.

## Fade

Recommended:

- fade-in: ~1–2 seconds;
- fade-out: optional, ~0.5–1 second.

## Do not

Do not:

- add a one-second audible tick;
- synchronise music rhythm with Cosmic Pulse;
- autoplay loudly on first launch;
- interrupt the counter with a full-screen audio prompt.

## Pro architecture

Free:

- one ambient track: `Deep Space`

Pro-ready architecture:

- multiple soundscapes later;
- selection UI;
- one-time Pro unlock;
- no subscription requirement.

Potential future Pro soundscapes:

- Orbital Drift
- Aurora
- Blue Planet
- Interstellar
- Voyager
- Deep Silence

These names are placeholders only.

---

# 3. Counter modes

The application should support two display modes.

## Default mode — Cosmic Pulse

This remains the default mode.

Behaviour:

- distance updates once per second;
- total seconds update once per second;
- both update synchronously;
- values are derived from the same timestamp.

Do not use separate drifting timers.

## Alternative mode — Continuous

User can optionally select a faster continuous mode.

## Critical display change

In Continuous mode, REMOVE decimal digits.

Do not show:

`702 691 673 279,430`

Show:

`702 691 673 279`

The same rule applies to total seconds.

Do not show:

`1 899 166 684,539`

Show:

`1 899 166 684`

## Continuous update frequency

The visual value may refresh multiple times per second.

Recommended initial test:

- 5 Hz;
- or 10 Hz.

Do not render meaningless decimal fractions.

The integer kilometre value itself is enough to create visible motion.

## Settings control

Add to Settings:

### Ukrainian

`РУХ ЛІЧИЛЬНИКА`

- `Cosmic Pulse`
- `Безперервний`

### English

`COUNTER MOTION`

- `Cosmic Pulse`
- `Continuous`

Persist the selection locally.

---

# 4. Optional date/time coordinates on the main screen

## New option

Add an optional main-screen information layer showing:

- journey start date/time;
- current date/time.

This information must remain visually secondary.

It must not compete with:

1. distance;
2. days;
3. total seconds.

## Settings toggle

Add:

### Ukrainian

`Показувати часові координати`

### English

`Show time coordinates`

Default:

OFF

Persist locally.

---

# 5. Main-screen time-coordinate design

When enabled, show a small secondary block.

Preferred placement:

- below the Earth / visual area;
- above the main distance counter;

or another location that does not break the three-counter hierarchy.

## Full exact date example

### Ukrainian

`ПОЧАТОК`

`01.04.1966 · 08:45`

`ЗАРАЗ`

`05.09.2026 · 14:21:07`

## English

`START`

`01 Apr 1966 · 08:45`

`NOW`

`05 Sep 2026 · 14:21:07`

## If only birth year is known

Do not show a fabricated date.

Show:

`ПОЧАТОК`

`1966 · приблизно`

English:

`1966 · approximate`

## If date is known but time is unknown

Show:

`01.04.1966 · час невідомий`

English:

`01 Apr 1966 · time unknown`

---

# 6. Visual treatment of time coordinates

These values are informational, not primary.

Recommended styling:

- font size: approximately 12–13 px on mobile;
- muted colour;
- opacity around 55–70%;
- no large card;
- no heavy border;
- no bright glow;
- compact vertical spacing.

Use tabular numbers for time if available.

The current time may update every second.

Do not animate it aggressively.

---

# 7. Human-readable scale

Keep the current compact magnitude helper.

Examples:

Distance:

`702 691 673 279 km`

`≈ 702,7 млрд км`

Seconds:

`1 899 166 684 секунд`

`≈ 1,90 млрд`

Keep this feature enabled by default.

---

# 8. Main-screen hierarchy

The visual hierarchy must remain:

1. Distance
2. Days
3. Total seconds
4. Optional time coordinates
5. Decorative Earth / atmosphere
6. Secondary controls

Do not let the date/time block become a fourth major counter.

---

# 9. Menu changes

Recommended menu structure:

1. Next milestone
2. Current speed
3. Journey Start
4. Milestones
5. Statistics — Pro
6. Share
7. Widgets — Pro
8. Styles — Pro
9. Atmosphere
10. Calculation explanation
11. Cosmic Pro
12. Settings

Do not add unnecessary new top-level items beyond what is needed.

---

# 10. Settings changes

Add or confirm these settings.

## Counter

`Counter motion`

- Cosmic Pulse
- Continuous

## Main screen

`Show time coordinates`

ON/OFF

## Sound

`Atmosphere`

ON/OFF

`Soundscape`

Deep Space

Optional:

`Volume`

## Language

Existing language selection remains.

---

# 11. Audio lifecycle

### When page/app is visible

- audio follows user preference;
- if playing, continue loop;
- keep volume low.

### When page/app loses focus or visibility

At minimum:

- do not create duplicate playback instances;
- do not restart from zero unexpectedly;
- do not create overlapping loops.

### On resume

- restore UI state;
- restore intended sound state;
- only start audible playback when permitted by the environment.

---

# 12. Timer architecture

Use a shared authoritative time source.

Do not create independent timers for:

- distance;
- seconds;
- current clock;
- milestones.

Preferred structure:

```text
Clock / currentTime
        ↓
Journey snapshot
        ↓
UI
```

For Cosmic Pulse:

- one update per second.

For Continuous:

- a higher-frequency presentation ticker;
- still derive values from actual current time.

Never increment counters by assuming previous value + fixed amount as the source of truth.

System time remains the source of truth.

---

# 13. Date formatting

Use locale-aware formatting.

## Ukrainian examples

`01.04.1966`

`05.09.2026 · 14:21:07`

## English examples

`01 Apr 1966`

`05 Sep 2026 · 14:21:07`

Do not hardcode English month names inside UI components.

---

# 14. Responsive behaviour

Test the new date/time block on:

- narrow mobile;
- normal mobile;
- tablet;
- desktop web preview.

Requirements:

- no text overlap;
- no horizontal scrolling;
- full counters remain readable;
- time coordinates wrap gracefully if required.

---

# 15. Accessibility

For continuously updating content:

- avoid forcing screen readers to announce every second;
- do not mark every live value as aggressively live;
- consider a static accessible summary;
- respect reduced-motion preferences.

Continuous mode should reduce animation if reduced-motion is enabled.

---

# 16. Do not change in this task

Do not:

- change the core distance formula;
- add authentication;
- add backend;
- add subscriptions;
- add ads to the main screen;
- remove Cosmic Pulse;
- add complex astronomy simulation;
- redesign the entire visual system;
- replace the existing menu architecture unless necessary.

---

# 17. Acceptance criteria

The task is complete when all of the following are true.

## Birth date

1. User can still start with only a birth year.
2. User can later open Journey Start.
3. User can add month/day.
4. User can optionally add birth time.
5. User can mark time as unknown.
6. Counters recalculate immediately after save.
7. Data persists locally.
8. Approximate values are clearly treated as approximate.

## Audio

9. Free ambient track can actually be started.
10. User can mute/unmute.
11. Track loops.
12. Preference persists.
13. No loud forced autoplay.
14. No one-second tick sound.
15. Audio layer is ready for multiple Pro tracks later.

## Counters

16. Cosmic Pulse remains default.
17. Distance + seconds update synchronously in Cosmic Pulse.
18. Continuous mode exists.
19. Continuous mode shows integer distance only.
20. Continuous mode shows integer seconds only.
21. No three-digit decimal fractions remain on the main counters.

## Time coordinates

22. User can enable/disable time coordinates.
23. When enabled, journey start is shown.
24. Current date/time is shown.
25. Exact start date is shown only when known.
26. Approximate year-only state is not rendered as a fake exact date.
27. The date/time block is visually secondary.
28. Three main counters remain dominant.

## Regression

29. Existing calculations still work.
30. Existing menu still works.
31. Existing localisation still works.
32. Main-screen mobile layout remains stable.

---

# 18. Testing requirements

Add/update tests for:

- year-only profile;
- full-date profile;
- full-date + time profile;
- unknown-time profile;
- save/edit journey start;
- recalculation after editing birth data;
- Cosmic Pulse synchronous update;
- Continuous mode integer formatting;
- time-coordinate visibility toggle;
- Ukrainian date formatting;
- English date formatting;
- audio preference persistence where testable;
- no duplicate audio instance creation.

---

# 19. Expected Codex output

After implementation, report:

1. files changed;
2. new components/services created;
3. how birth precision is represented;
4. how audio start is handled;
5. how Cosmic Pulse and Continuous modes differ;
6. how time-coordinate display is toggled;
7. tests added;
8. any assumptions;
9. any remaining browser-specific limitations.

Do not silently change scientific constants or product rules.
