# Cosmic Journey — Change Request

## Approved changes after reviewing the live web prototype

The current prototype is already calculating the journey successfully.  
The next iteration should focus on **readability, rhythm and atmosphere**, not on adding more information.

---

## 1. Replace rapid counter motion with Cosmic Pulse

**Approved decision:** use **Cosmic Pulse** as the default behaviour.

Distance and total seconds should update **once per second, at the same moment**.

Why:

- the current decimals change too quickly;
- the user cannot meaningfully read them;
- synchronising distance and seconds makes the idea instantly understandable;
- one second becomes a visible unit of cosmic travel;
- the interface becomes calmer and more premium.

---

## 2. Remove decimal digits

### Distance

Before:

`702 673 018 500,660 km`

After:

`702 673 018 501 km`

### Seconds

Before:

`1 899 116 266,218`

After:

`1 899 116 266`

Decimals are removed from the default main screen.

---

## 3. Explain scale without adding explanatory text

The complete number stays large because it creates the live “odometer” effect.

Below it, add a small compact interpretation.

Example:

`702 673 018 501 km`

`≈ 702,7 млрд км`

For seconds:

`1 899 116 266 секунд`

`≈ 1,90 млрд`

This solves the problem that very large numbers are hard to mentally classify.

---

## 4. Keep days visually stable

The days block stays unchanged between day boundaries.

Example:

`21 980`

`днів`

This gives the screen a stable centre between two live counters.

---

## 5. Make the pulse soft

At every one-second update:

- distance changes;
- seconds change;
- optional small centre glow gently pulses.

Recommended transition:

**250–400 ms**

No aggressive animation.

---

## 6. Fix the Earth image

The current Earth image shows a visible rectangular black background.

Change to:

- transparent PNG/WebP;
- approximately 15–25% smaller Earth;
- subtle orbit glow only.

The Earth should support the atmosphere, not compete with the counters.

---

## 7. Refine divider lines

Current lines feel too much like dashboard/table separators.

Change to:

- shorter centred lines;
- roughly 60–70% width;
- fading edges;
- subtle blue centre glow.

---

## 8. Add ambient sound

Add one optional ambient loop to the free version.

Working name:

**Deep Space**

Desired mood:

- calm;
- slow;
- atmospheric;
- seamless;
- no vocals;
- no percussion;
- no audible one-second tick.

Sound should be optional and user-controlled.

Do not auto-play loudly on first launch.

---

## 9. Expand soundscapes in Cosmic Pro

Cosmic Pro was specified here as a **one-time purchase**. That rule is
**superseded** by [ADR 0002](adr/0002-monetization-ads-and-pro-subscription.md)
(yearly subscription). Keep this file as the Pulse request; do not treat this
paragraph as current product law.

Possible premium soundscape choices:

- Orbital Drift
- Aurora
- Blue Planet
- Interstellar
- Voyager
- Deep Silence

These are working names, not final assets.

The audio architecture should allow new soundscapes without changing the main screen logic.

---

## 10. Milestone sound

Later, milestones may use a short gentle chime.

Do not make this part of the one-second pulse.

The ambient soundtrack remains continuous and calm.

---

## 11. Keep the main screen minimal

Do **not** add to the main screen:

- current speed;
- CMB explanation;
- next milestone;
- birth date;
- Pro advertisement;
- statistics;
- charts;
- advertising.

All of these remain in secondary screens/menu.

---

## 12. Intended final feeling

The screen should communicate, without text:

> A second passed.  
> The journey continued.  
> Hundreds of kilometres were added.

This should feel calm, almost meditative, rather than like a fast technical dashboard.
