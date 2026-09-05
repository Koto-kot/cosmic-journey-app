# Cosmic Journey — Additional Technical Specification

## Feature package: Cosmic Pulse + Human-readable scale + Ambient audio

**Status:** Approved product direction  
**Applies to:** Current MVP / web prototype and future Flutter mobile app  
**Priority:** High  
**Purpose:** Improve readability, emotional impact, and calm rhythm of the live journey screen.

---

## 1. Product decision

The main live counter will use the **Cosmic Pulse** interaction model.

Instead of updating the distance many times per second, the application will update:

- total seconds;
- cosmic distance;

**once per second, synchronously.**

The UI should feel like one calm pulse per second.

The intent is:

> One second passes → the user immediately sees how many kilometres were added to the journey.

This is now the preferred default behaviour.

---

## 2. Main screen — approved structure

The main screen should remain minimal.

It should contain only:

1. Earth / subtle cosmic visual at the top;
2. total cosmic distance;
3. human-readable distance scale;
4. total days;
5. total seconds;
6. human-readable seconds scale;
7. minimal menu control;
8. optional sound control.

Do not add:

- speed explanation;
- milestones;
- scientific explanation;
- ads;
- Pro promotion;
- long text;
- charts.

All secondary information belongs in the menu.

---

## 3. Distance display

### 3.1 Main value

Display distance as an integer.

Example:

`702 673 018 501`

Unit:

`km`

### 3.2 Remove decimal digits

Do not show:

`702 673 018 500.660`

Do not show rapidly changing decimal fractions.

Reason:

- decimal digits create visual noise;
- they move too fast to be cognitively useful;
- integer kilometres already change dramatically every second.

### 3.3 Update frequency

Distance updates exactly once per second together with the seconds counter.

At each pulse:

- read/recalculate the current authoritative distance;
- round to an integer kilometre for display;
- update the visible value.

---

## 4. Seconds display

Display total elapsed seconds as an integer.

Example:

`1 899 116 266`

Unit:

`SECONDS`

or locale equivalent.

Update exactly once per second.

Do not show fractional seconds on the default main screen.

---

## 5. Cosmic Pulse behaviour

### 5.1 Timing

Use a one-second display pulse.

Distance and seconds must update from the same time source.

They must not use separate drifting timers.

Preferred logical sequence:

1. obtain current time;
2. calculate elapsed seconds;
3. calculate distance for the same timestamp;
4. render both values together;
5. schedule the next pulse.

### 5.2 Synchronisation

The two visible values must change in the same UI update.

Avoid a visible sequence where seconds change first and distance changes later, or vice versa.

### 5.3 Visual transition

The pulse should feel soft, not mechanical.

Recommended transition duration:

**250–400 ms**

Possible visual treatment:

- numeric crossfade;
- subtle vertical digit roll;
- soft opacity transition;
- very small scale transition;
- subtle glow pulse.

Do not use:

- aggressive bounce;
- large zoom;
- flashing;
- heavy neon;
- mechanical clock flip animation unless later user testing prefers it.

### 5.4 Divider glow

At the same one-second pulse, the small centre glow / divider point may gently brighten and fade.

This should be subtle.

It is decorative and must never distract from the numbers.

---

## 6. Human-readable large-number scale

Large values are difficult to interpret immediately.

The application should show a secondary compact representation below the full number.

### 6.1 Distance example

Primary:

`702 673 018 501`

`km`

Secondary:

`≈ 702.7 billion km`

Ukrainian:

`≈ 702,7 млрд км`

### 6.2 Seconds example

Primary:

`1 899 116 266`

`SECONDS`

Secondary:

`≈ 1.90 billion`

Ukrainian:

`≈ 1,90 млрд`

The unit does not need to be repeated in the compact secondary line if it is already visually obvious.

### 6.3 Scale rules

The formatter should support at minimum:

- thousand;
- million;
- billion;
- trillion.

Ukrainian:

- тис.
- млн
- млрд
- трлн

English:

- thousand;
- million;
- billion;
- trillion.

For the main product UI, prefer labels that are immediately understandable rather than finance-style abbreviations unless the selected design system uses them consistently.

### 6.4 Precision

Recommended:

- millions: 1 decimal;
- billions: 1–2 decimals;
- trillions: 1–2 decimals.

Examples:

- `≈ 847.2 million km`
- `≈ 702.7 billion km`
- `≈ 1.05 trillion km`

Do not over-precision the compact value.

---

## 7. Days display

Days remain an integer.

Example:

`21 980`

`DAYS`

Days do not animate every second.

They change only when a new full day is reached.

The days block acts as the visually stable anchor between two live values.

---

## 8. Main-screen rhythm

The intended perception is:

### Distance
Fast-changing meaning, but displayed calmly once per second.

### Days
Stable.

### Seconds
One new unit every second.

Distance and seconds update together.

---

## 9. Earth image / visual

### 9.1 Transparent asset

The Earth image must use a transparent background.

Preferred formats:

- PNG with alpha;
- WebP with alpha.

Do not use a rectangular black image that is visibly different from the page/app background.

### 9.2 Size

Reduce the Earth approximately 15–25% relative to the current prototype.

The Earth is an atmospheric element.

The numbers remain the hero of the screen.

### 9.3 Orbit glow

A subtle orbit trail is allowed.

Avoid oversized or overly bright effects.

---

## 10. Divider styling

Current full-width divider lines should be softened.

Recommended:

- width: approximately 60–70% of the content area;
- centred;
- gradient fade toward both edges;
- small central blue glow point.

The divider should feel cosmic rather than like a dashboard table border.

---

## 11. Ambient audio

Add optional ambient background audio.

### 11.1 Product purpose

Audio should deepen the contemplative / cosmic mood.

It must not behave like foreground music demanding attention.

Preferred character:

- slow;
- atmospheric;
- minimal;
- no vocals;
- no drums;
- no sharp rhythm;
- seamless looping;
- low cognitive load.

### 11.2 Free version

The free version includes one default ambient soundscape.

Working name:

**Deep Space**

### 11.3 Pro version

Cosmic Pro may unlock multiple ambient soundscapes.

Example directions:

- Deep Space
- Orbital Drift
- Aurora
- Blue Planet
- Interstellar
- Deep Silence
- Voyager

Names are working concepts only.

### 11.4 Playback rules

Audio must:

- be optional;
- remember user preference;
- loop seamlessly;
- pause/stop appropriately with app lifecycle according to platform conventions;
- respect system audio behaviour;
- avoid surprising the user.

### 11.5 First-run behaviour

Do not automatically start audible music at full volume on first launch.

Preferred options:

- sound off by default;
- or explicit user action: `Enable atmosphere`.

### 11.6 Sound control

Add a small unobtrusive audio control.

Possible states:

- sound on;
- sound off.

Keep it visually secondary to the counters.

---

## 12. Cosmic Pulse and audio relationship

Do not add a one-second tick to the music.

Do not rhythmically accent every second with audible sound.

Reason:

- it may become stressful;
- it turns the product into a clock;
- it conflicts with the ambient concept.

The pulse is primarily visual.

The soundtrack should remain slow and continuous.

---

## 13. Milestone sound

A milestone may optionally use a very short soft chime.

Examples:

- 100 million km;
- 1 billion km;
- large round-number milestone.

Requirements:

- subtle;
- short;
- non-alarming;
- different from notification sounds where needed;
- user-configurable.

This is a secondary feature and should not block the current Cosmic Pulse implementation.

---

## 14. Audio licensing requirement

Any audio shipped with the commercial application must have clear rights for commercial mobile-app distribution.

Allowed sources:

- original composition;
- commissioned composition;
- properly licensed commercial audio.

Do not assume that a track labelled only as “royalty free” is automatically safe for App Store / Google Play redistribution.

Maintain internal licence records for every shipped track.

---

## 15. App lifecycle

### Foreground

- Cosmic Pulse timer active;
- distance + seconds update once per second;
- ambient audio follows current user setting.

### Background

- stop UI pulse;
- do not simulate missed UI frames;
- follow platform audio rules and product setting.

### Resume

1. read current time;
2. recalculate authoritative elapsed seconds;
3. recalculate distance;
4. update days;
5. render immediately;
6. resume one-second pulses.

---

## 16. Recommended implementation model

Use one shared ticker / clock source for the main screen.

Pseudo-flow:

```text
onPulse(now):
    elapsedSeconds = journeyCalculator.elapsedSeconds(now)
    distanceKm = journeyCalculator.distanceKm(now)
    fullDays = floor(elapsedSeconds / 86400)

    updateUI(
        seconds = floor(elapsedSeconds),
        distanceKm = round(distanceKm),
        days = fullDays
    )
```

Avoid multiple independent interval timers for the same screen.

---

## 17. Timer drift

Do not assume `setInterval(1000)` / equivalent is perfectly accurate forever.

The visible values must be derived from the actual current time on every pulse.

The timer only requests an update.

The system clock is the source of truth.

---

## 18. Formatting service

Create a dedicated large-number formatter.

Suggested interface:

```text
formatFullNumber(value, locale)
formatHumanScale(value, locale)
```

Examples:

```text
formatFullNumber(702673018501)
→ "702 673 018 501"

formatHumanScale(702673018501, uk)
→ "702,7 млрд"

formatHumanScale(702673018501, en)
→ "702.7 billion"
```

Do not embed formatting rules directly inside UI components.

---

## 19. Localisation

Support at least:

- Ukrainian;
- English.

Compact scale labels must be localised.

Do not hardcode language-specific scale words inside the main widget.

---

## 20. Accessibility

Cosmic Pulse must not create accessibility problems.

Requirements:

- avoid flashing;
- avoid high-frequency brightness changes;
- reduced-motion mode should replace digit roll with a simple crossfade or instant update;
- screen readers should not announce the entire giant number every second by default.

For accessibility, consider exposing a less frequent semantic update or a static summary.

---

## 21. Performance

The one-second Cosmic Pulse is intentionally lightweight.

Expected benefits over high-frequency numeric updates:

- lower rendering cost;
- lower battery usage;
- better readability;
- calmer experience.

No expensive astronomical calculation should run continuously between pulses.

---

## 22. Acceptance criteria

The feature is complete when:

1. Distance shows no decimal fraction on the main screen.
2. Seconds show no decimal fraction.
3. Distance and seconds update once per second.
4. They update from the same timestamp.
5. The update is visually synchronous.
6. The transition is calm and readable.
7. Human-readable distance scale appears below the full distance.
8. Human-readable seconds scale appears below total seconds.
9. Days remain stable between day boundaries.
10. Earth asset has transparent background.
11. Earth is visually secondary to numbers.
12. Divider lines are softer and shorter than the current prototype.
13. One optional ambient loop exists in the free version.
14. Audio can be enabled/disabled.
15. Audio preference persists.
16. Audio does not emit a one-second ticking sound.
17. Pro architecture allows additional soundscapes later.
18. App recalculates correctly after background/resume.
19. Formatting works in Ukrainian and English.
20. Reduced-motion mode remains usable.

---

## 23. Testing checklist

### Functional
- distance increments correctly;
- seconds increment correctly;
- both use the same timestamp;
- day rollover works;
- background/resume works;
- locale switching works.

### Visual
- no decimal noise;
- transition remains readable;
- no flicker;
- full number does not overflow;
- human-scale subtitle remains secondary;
- Earth has no visible rectangular background.

### Audio
- loop is seamless;
- mute works;
- preference persists;
- no unexpected autoplay;
- background behaviour is correct;
- Pro soundscape selection can be added without rewriting the audio layer.

---

## 24. Final UX target

The user should intuitively experience:

> One second of my life passed.  
> I also travelled hundreds of kilometres through space.

The interface should communicate this without explanatory text on the main screen.
