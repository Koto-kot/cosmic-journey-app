# Ideas — free, Pro, and the philosophy around the odometer

**Status:** Notebook, not a spec. Nothing here is scheduled.  
Phase 3 (stores, ads, subscription, widgets, Scientific Mode) stays in
[`PHASE_3.md`](PHASE_3.md). If an idea here would change a published rule
(ads on Pulse, accounts, one-time vs subscription), it needs an ADR first.

Cosmic Journey is a **personal live odometer**: you watch kilometres and
seconds accumulate because Earth never stops. The emotional effect is
presence, not prediction. Ideas below should deepen that feeling, not turn
the main screen into a magazine.

---

## What must stay true

These constraints are already product law ([`AGENTS.md`](../AGENTS.md),
[ADR 0002](adr/0002-monetization-ads-and-pro-subscription.md)):

- The live screen stays almost empty: distance, days, seconds, Earth, language,
  atmosphere, menu. No paragraphs, no ads, no horoscope banner.
- Birth data stays on the device. No account required for the core loop.
- Distance is an **estimated path length** relative to a chosen frame (CMB
  rest frame in MVP). Never “from the centre of the Universe.”
- Free is a finished odometer, not a locked demo of the numbers.
- Pro is a yearly subscription. Ads only in `AdSlot` on Menu / Science /
  Styles / Statistics.

A good idea either (a) lives in the menu, Science, or a quiet extra screen,
  or (b) is a Pro atmosphere / style / widget that does not clutter Pulse.

---

## Philosophy the product already implies

Write copy and features as if these sentences are true:

1. **You are already underway.** The app does not start a journey. It names
   one that began at birth.
2. **Stillness is an illusion of scale.** Sitting still on Earth is still
   hundreds of kilometres per second relative to the CMB.
3. **Time can be a distance.** Days and seconds are the same lifetime as
   the kilometre count; Pulse keeps them honest (one timestamp).
4. **Precision is a kindness, not a verdict.** Year-only is enough. Month,
   day, and time are optional humility, not a demand for a birth certificate.
5. **Science and wonder can share a room** if science is labelled as science
   and metaphor is labelled as metaphor.
6. **The sky of a birthday is a map, not a script.** Stars were in real
   places at a real time. That is astronomy. “You will meet a stranger”
   is not this app.

Tone: pale blue dot, quiet spacecraft, Ukrainian and English without
slogans. Avoid guru language, “the universe chose you,” or ranking people
by how far they have “won.”

---

## Free vs Pro — how to split future ideas

| Keep free | Make Pro |
| --- | --- |
| The live odometer (Pulse + Flow) | Extra atmospheres and styles |
| Year-only start + optional date/time | Home / lock widgets |
| Science: what 370 km/s means | Scientific Mode (time-varying vectors) |
| Basic milestones (10M / 100M / 1B km) | Custom intervals, chimes, extra stats |
| Plain share of the numbers | Designed share cards |
| One local profile | Household profiles, replay |
| Sky-at-birth as **facts** (Sun in which constellation *astronomically*, day length, season) | Full natal *chart as sky map*, extra frames, export |
| Ads on allowed secondary screens | No ads |

Do not put a paywall on watching the numbers move. Pro is atmosphere,
precision tools, and deeper rooms off the odometer.

---

## Astrology, sky, and “the day you began”

Astrology is culturally close to birth time. The honest product angle is
**the sky as it actually was**, plus optional cultural labels.

### Free — Sky of the first day

A menu row **Sky**, never on Pulse.

- Season in the birth hemisphere (if month is known).
- Approximate **solar longitude**: which constellation the Sun was in on that
  calendar date, with a one-line disclaimer that this is the *astronomical*
  constellation (IAU boundaries), not a newspaper sun-sign column. They
  often disagree (the “13th sign” / Ophiuchus conversation belongs here as
  science, not as a roast).
- Length of that calendar day (if date is known): hours of daylight at a
  default latitude, or “unknown until a place is set.”
- Moon phase as a **computed disk**, not “your luck.” Phase is geometry.
- “You have completed *N* trips around the Sun” — that is orbital mechanics,
  and it belongs next to days.

If only a year is known, show less and say so. Do not invent a rising sign
from 1 July noon without labelling it approximate.

### Pro — Chart as a map

- Optional **place of birth** (city search, coordinates stored locally).
  This is the first time location is justified. GPS is still forbidden
  unless the user picks a city. Never send coordinates to analytics.
- A quiet **sky map** for the canonical UTC birth: ecliptic, Sun, Moon,
  major planets as dots, not as personality essays.
- Sidereal vs tropical as a **toggle with a Science paragraph**, not as a
  hidden default that looks like destiny.
- Houses / aspects only if we can say in one sentence that these are
  *traditional geometric constructions*, not physics. Prefer shipping the
  map first and copy later.
- Pairing: “same sky, two local profiles” for a household — still on-device.

### What not to ship as Cosmic Journey

- Daily horoscope notifications.
- Compatibility scores between two users (that wants accounts and drama).
- “Mercury retrograde will slow your odometer.” It will not.
- Paid fortune-telling, celebrity charts, or scraping other people’s birth
  data.

If a horoscope feed is ever wanted, it is a **different product** or a
clearly named optional pack with its own ADR.

---

## More rooms that fit the odometer

### Relatives of the kilometre count (mostly Pro, one teaser free)

Show conversions as extra Science / Statistics rows, not as Pulse chrome:

| Idea | Why it is interesting |
| --- | --- |
| Light-travel time of your path | “If this path were a radio pulse, it would still be in flight for …” |
| AU and light-minutes to the Sun | Ties 370 km/s to the Solar System they already know |
| Fraction of a galactic year | ~230 million years; a lifetime is a thin slice |
| Lunar distances | How many Earth–Moon gaps the path equals |
| “Compared with Voyager 1” | Same spirit as human-scale subtitles, not a leaderboard |

Keep the same calculator boundary: new units are formatters over
`JourneySnapshot`, not a second physics engine.

### Time as a landscape (Pro)

- **Journey replay:** scrub from birth to now on a dedicated screen. Pulse
  stays live. Replay is history class, not a second odometer.
- **This day last year / a billion km ago:** a quiet card in Statistics.
- **Midnight ceremony:** days tick; a single optional chime (already
  sketched for milestones). No interstitial.

### Place and frame (Scientific Mode and after)

- Alternate frames, clearly named: CMB, heliocentric, galactocentric.
  Switching frames **changes the number**; Science must say so.
- “If you had been born on Mars” as a *toy profile*, labelled
  hypothetical, never mixed with the real birth.

### Atmosphere and style (catalog already exists)

More generated beds in the same ADR 0006 pattern (no licensed NASA audio
without a new ADR):

- Radio hiss / “empty channel”
- Subsonic Earth-hum
- Eclipse quiet
- Polar night

Visuals that still leave the numbers as hero: very slow terminator on
Earth, a thinner star field, an OLED-only hairline. No daily wallpaper ads.

### Sharing without becoming social

- Free: copy integers (already shipped).
- Pro: a still image of Earth + the three numbers + “since YEAR,” no
  tracker URL.
- Optional **letter to a future self** stored only locally (unlock on a
  milestone). Not email.

### Language and culture

- More locales with the same restraint (no machine-translated mysticism).
- Ukrainian/English already set the bar: short, precise, unsentimental.
- Optional **calendar systems** (Gregorian default; Julian historical
  dates if we ever support pre-1582 — that needs a Science note).

---

## Ideas that sound related but will fight the product

| Idea | Why it is a poor fit |
| --- | --- |
| Step counter / Health | Implies the body is the journey; we mean the planet |
| Live ISS tracker on Pulse | Splits attention; belongs in a different app |
| News of solar flares on the odometer | Anxiety, network on the sacred screen |
| Leaderboard of “farthest humans” | Ageism dressed as cosmos |
| Chat with an “AI astronomer” on launch | Noise; birth dates must never leave the device |
| AR walking-through-space | Fun once; kills battery and calm |

---

## Suggested order if we ever pick from this list

1. Finish Phase 3 as written (money, widgets, Scientific Mode).
2. **Sky of the first day** (free, facts only) — high wonder, low risk.
3. Light-time / AU / galactic-year rows in Statistics.
4. Pro sky map + optional birth place, local only.
5. Replay and extra atmospheres.

Each of 2–4 can ship behind the existing menu. None of them should add a
second number engine on the live screen.

---

## How to use this file

- Steal a heading into a future `PHASE_4.md` when something is actually
  scheduled.
- Do not treat a bullet here as a promise in store listings.
- Prefer one complete room (Sky, Replay) over five half-built metaphors.
