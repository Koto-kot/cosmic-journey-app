# Phase 2

**Status:** Built (2.1–2.8). Testing rule: everyone is Cosmic Pro. Ads stay off.  
**Later:** flip entitlement flags. Do not rewrite screens.

Phase 1 is the Pulse odometer: year-only onboarding, live integers,
human-scale subtitles, language switch, Deep Space (off by default), science,
and settings. Continuous readout (integer, ~10Hz) is an opt-in (ADR 0003,
ADR 0007).

Phase 2 is in the tree: entitlement flags, optional birth date/time (its own
Journey Start screen), milestones, share, styles, extra soundscapes,
statistics, optional time coordinates, and the Cosmic Pro status screen.
Scientific Mode, store widgets, live ads, and the Pro **subscription** are
**Phase 3** — see [`PHASE_3.md`](PHASE_3.md) and
[`MONETIZATION.md`](MONETIZATION.md).

---

## Principle

Build the full surface as if Pro is unlocked.

Keep one entitlement object. Screens ask:

- `isPro`
- `adsAllowed`

While testing:

```text
isPro = true
adsAllowed = false
```

When the store ships, those two booleans change. Feature screens stay.

Do not sprinkle `if (pro)` through the live journey screen. The main screen
never carries ads, Pro CTAs, or extra stats.

---

## What stays free (when we split)

The core loop must remain complete without paying:

| Surface | Free |
|---|---|
| Birth year onboarding | yes |
| Cosmic Pulse live screen | yes |
| Human-scale subtitles | yes |
| ENG / UA | yes |
| Deep Space on/off | yes |
| Menu: next milestone + current speed | yes |
| Science explanation | yes |
| Settings: birth year | yes |
| Basic milestone list (10M / 100M / 1B km) | yes |
| Share of the current numbers (plain) | yes |
| Optional month/day/time (more accurate, still local) | yes |

Free is a finished odometer, not a demo with a lock on the numbers.

---

## What becomes Pro (when we split)

| Surface | Why it is Pro |
|---|---|
| Extra soundscapes (Orbital Drift, Aurora, …) | atmosphere catalog |
| Styles / themes / OLED / custom colour | visual pack |
| Home / lock-screen widgets | OS integration |
| Custom milestone interval | power user |
| Milestone notifications + chime | attention |
| Premium share cards | export |
| Advanced statistics | extra screens |
| Multiple local profiles | household |
| Journey replay | extra |
| Scientific Mode | Phase 3 calculator |
| Ad removal | automatic once `isPro` |

During Phase 2 testing, all of these are **visible and usable**. A small PRO
badge can stay on the row so we remember the split. Do not block taps.

---

## Ads (designed now, dark during testing)

Hard rules (already in the product spec):

- never on the live journey screen
- never on the birth-year wheel
- never as a launch interstitial
- never a rewarded-video overlay on the counters
- Pro removes ads

Allowed slots, all **below the fold of secondary screens**:

1. **Menu** — after the last row (Settings), a single anchored banner slot.
   Not between Next Milestone and the list. The two info cards stay clean.
2. **Science** — after the last paragraph.
3. **Styles / Widgets / Statistics** — native list footer, not a popup.
4. **Share sheet** — no ad. Sharing is a quiet moment.

Not allowed:

- interstitial when opening or closing the menu
- banner over Earth or the pulse numbers
- audio ads, or ads that duck Deep Space

Implementation: an `AdSlot` widget that renders nothing while
`adsAllowed == false`. When ads go live, only that widget starts a network.
No other file should import an ads SDK.

---

## Phase 2 build order

Build in this order so each slice is usable on web while we test as Pro.

### 2.1 Entitlement + flags (small)

- `Entitlement` with `isPro` / `adsAllowed`
- default: Pro on, ads off
- persist later; for now a constant is enough
- `AdSlot` that is empty in tests

### 2.2 More precise birth

- Settings: optional month, day, time
- year-only remains the default path
- still `isApproximate` until date+time exist
- same Pulse screen; only the canonical UTC birth changes

### 2.3 Milestones as a real screen

- list presets: 10M, 100M, 1B km (already estimated in the menu card)
- show reached / next / remaining
- optional gentle chime on crossing (off by default, not a 1s tick)
- local notifications later in 2.6; UI first

### 2.4 Share

- share current integer km, days, seconds + human-scale line
- plain text first (works on web)
- image card can follow; treat the designed card as Pro later

### 2.5 Styles

- 2–3 full themes that keep the same layout (free black + 1–2 Pro looks)
- OLED true-black as one of them
- live screen reads tokens only; no layout fork

### 2.6 Atmosphere catalog

- Deep Space stays free
- picker: Orbital Drift, Aurora, Blue Planet, Interstellar, Voyager,
  Deep Silence, Solar Wind, Ionosphere, Red Dwarf, Quiet Station, Comet Tail,
  Magnetosphere (all generated; ADR 0006)
- generate or license loops the same way as Deep Space
- Pulse still has no audible tick

### 2.7 Statistics

- average km/day, km/year
- time to next billion
- “since you opened the app” is unnecessary; keep it lifetime
- lives in the menu, never on the odometer

### 2.8 Cosmic Pro screen

- explain that Cosmic Pro will be a yearly subscription on the stores
- Restore Purchases button (no-op until Phase 3)
- while testing: “You have Cosmic Pro” and no paywall

Skip for Phase 2 (need a store binary or a heavier science engine):

- home-screen widgets
- StoreKit / Play Billing
- real ad network
- Scientific Mode integration

---

## Screen map (Phase 2)

```text
Onboarding (year) → Pulse
                      ├ menu
                      │   ├ next milestone + speed     (free)
                      │   ├ Milestones                 (build now; custom interval Pro later)
                      │   ├ Statistics                 (build now; mark Pro later)
                      │   ├ Share                      (plain free; card Pro later)
                      │   ├ Widgets                    (placeholder until mobile)
                      │   ├ Styles                     (build now; extra themes Pro later)
                      │   ├ Science                    (free; ad slot at end)
                      │   ├ Atmosphere / soundscapes   (Deep Space free; others Pro later)
                      │   ├ Cosmic Pro                 (status + restore)
                      │   └ Settings                   (birth precision, notifications)
                      └ language + atmosphere toggle stay on Pulse
```

Ad slot only at the bottom of Menu, Science, Styles, Statistics.

---

## Entitlement shape (do not over-build)

```text
Entitlement
- isPro
- adsAllowed          // isPro ? false : true  (when ads exist)
- soundscapeUnlocked(id)
- themeUnlocked(id)
- widgetsUnlocked
- customMilestonesUnlocked
```

Pulse, science copy, and the calculator never read this object except:

- atmosphere picker filtering soundscapes
- styles picker filtering themes
- `AdSlot`

---

## What Phase 3 is

Detailed plan: [`PHASE_3.md`](PHASE_3.md).

- App Store / Play binaries, yearly Pro subscription, restore
- `isPro` from the store; ads on for free users (`AdSlot` only)
- home/lock widgets
- Scientific Mode calculator behind the same live screen
- milestone notifications, multiple profiles, journey replay

Phase 2 should already look like the paid app. Phase 3 only turns on money
and the two heavy platform features.
