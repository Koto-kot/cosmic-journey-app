# Product Specification

## 1. Goal
Build a mobile app for iOS and Android that continuously shows:
1. estimated cosmic distance travelled since birth;
2. full days since birth;
3. total seconds since birth.

## 2. Platform
Recommended: Flutter.

## 3. MVP data model

### JourneyProfile
- birthYear
- birthMonth optional
- birthDay optional
- birthTime optional
- birthTimezone if needed
- isApproximate
- createdAt
- updatedAt

### UserPreferences
- locale
- themeId
- milestonesEnabled
- milestoneDistanceKm
- scientificModeEnabled
- proUnlocked

## 4. First launch

### Screen A — live demo
Show a rapidly increasing distance.

CTA:
**See my journey**

### Screen B — birth year
Question:
**When did your journey begin?**

Do not require month/day/time.

### Screen C — optional precision
Optional:
- month;
- day;
- time.

### Screen D — main journey
Open the live counter.

## 5. Main screen
Only:
- distance in km;
- days;
- total seconds;
- minimal menu;
- optional, visually secondary journey-start/current date-time block
  (off by default; see `docs/adr/0007-continuous-mode-journey-start-and-time-coordinates.md`).

No explanation.
No ad.
No large CTA.

## 6. Live animation
Recommended model:
1. calculate authoritative value at t0;
2. determine current speed;
3. interpolate cheaply between recalculations;
4. periodically refresh;
5. reconcile without visible jumps.

Do not run expensive physics calculations per frame.

On background:
- stop visual ticker.

On resume:
- get current time;
- recompute;
- resume ticker.

## 7. Time calculations
Use UTC internally.

`elapsedSeconds = nowTimestamp - birthTimestamp`

`days = floor(elapsedSeconds / 86400)`

Seconds may display a fractional component for the live effect.

## 8. Approximate birth-year mode
If only a year is known:
- mark result internally as approximate;
- use one documented convention.

Recommended MVP convention:
- July 1, 12:00 local time at setup.

Do not pretend the exact lifetime is known.

## 9. Base cosmic-distance model
MVP may use one configurable average CMB-relative speed.

`distanceKm = elapsedSeconds × averageSpeedKmPerSecond`

The constant must live in one source/configuration location.

## 10. Scientific Mode — future / Pro
Concept:

`V_earth_cmb(t) = V_solar_cmb + V_earth_orbit(t)`

`speed(t) = |V_earth_cmb(t)|`

`D = integral(speed(t), dt)`

Requirements:
- 3D vectors;
- astronomy separated from UI;
- numerical integration;
- caching;
- no historic recomputation at frame rate.

## 11. Menu
Suggested:
- Current speed
- Journey Start (edit birth year/month/day/time; subtitle shows precision,
  never a fabricated exact date for a year-only profile)
- Milestones
- Statistics
- Widgets
- Styles
- Science
- Share
- Cosmic Pro
- Settings

## 12. Milestones
Presets:
- 10,000,000 km
- 100,000,000 km
- 1,000,000,000 km

Future custom values.

## 13. Notifications
Use local notifications where platform rules allow.
No backend required.

Example:
**Cosmic milestone reached**
**You have travelled another 100,000,000 km.**

## 14. Cosmic Pro
Auto-renewable **subscription** (yearly primary). See
`docs/adr/0002-monetization-ads-and-pro-subscription.md` and
`docs/MONETIZATION.md`. This supersedes the earlier one-time IAP rule.

Potential entitlements:
- premium themes;
- OLED theme;
- widgets;
- custom milestone intervals;
- premium share cards;
- advanced statistics;
- Scientific Mode;
- multiple local profiles;
- journey replay;
- extra atmospheres;
- ad removal.

Implement Restore Purchases on iOS and Android.

The free app may show ads only via `AdSlot` on Menu, Science, Styles, and
Statistics. No ads on the live journey screen, year wheel, share sheet, or
launch interstitial.

## 15. Widgets
Pro feature.

Small:
`674.2B km`

Medium:
Distance + days

Large:
Distance + days + milestone/summary

Respect OS widget update limitations.

## 16. Offline
Core works offline:
- distance;
- days;
- seconds;
- local profile;
- settings;
- milestone logic.

Internet only when needed for:
- purchases;
- advertising;
- optional remote content.

## 17. Privacy
MVP:
- no account;
- no email;
- no phone;
- no cloud birth-date storage;
- no GPS;
- no unnecessary permissions.

## 18. Localisation
Initial:
- English
- Ukrainian

All user-visible strings must use localisation resources.

## 19. Number formatting
Support huge values and grouped thousands.

## 20. Accessibility
- sufficient contrast;
- semantic labels;
- reasonable dynamic text;
- respect reduced motion where practical.

## 21. Battery/performance
- no heavy background work;
- no per-frame network calls;
- no per-frame astronomical integration;
- pause ticker off-screen;
- recompute on resume.

## 22. Error handling
Handle:
- future birth date;
- impossible date;
- corrupted local state;
- timezone changes;
- device clock changes;
- purchase restore failures;
- notifications disabled.

## 23. Analytics
Do not add analytics in MVP by default.
Never send birth date as analytics data.

## 24. MVP screens
1. Splash/launch
2. Demo
3. Birth-year picker
4. Optional exact date/time
5. Main live journey
6. Menu
7. Science
8. Milestones
9. Settings
10. Cosmic Pro

## 25. Acceptance criteria
MVP passes initial testing when:
1. no account is required;
2. user selects a birth year;
3. approximate journey appears immediately;
4. main screen shows distance, days, seconds;
5. distance moves continuously;
6. seconds move continuously;
7. app can close/reopen;
8. values recalculate correctly;
9. core functions work offline;
10. no ad appears on main screen;
11. unit tests pass for core calculations;
12. leap years/timezone transitions are handled.
