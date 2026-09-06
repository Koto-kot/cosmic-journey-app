# Cosmic Journey — Interface Styles + Shuttle Cockpit
## Нове технічне та дизайн-ТЗ для Codex

**Статус:** актуальне, замінює попереднє ТЗ `COSMIC_JOURNEY_SHUTTLE_COCKPIT_FULL_SPEC_UA.md`  
**Продукт:** Cosmic Journey  
**Мета:** додати в застосунок повноцінний вибір між двома різними інтерфейсними стилями, не дублюючи математичний двигун і не змішуючи layout-теми з кольоровими палітрами.

---

# 1. Головне архітектурне рішення

У застосунку мають існувати **два окремі рівні персоналізації**:

## A. Interface Style
Визначає композицію головного екрана, спосіб представлення даних, анімації та візуальну метафору.

Початково:

1. `Cosmic Minimal`
   - поточний головний екран;
   - Земля / космос;
   - три основні лічильники;
   - мінімалістична композиція.

2. `Shuttle Cockpit`
   - новий інтерфейс;
   - вид із капітанського крісла;
   - переднє вікно шатла;
   - повільний зоряний потік;
   - два головні табло:
     - `DISTANCE`
     - `FLIGHT TIME`.

## B. Color Palette
Визначає лише кольори та токени оформлення.

Поточні палітри:
- Void
- OLED
- Midnight
- Aurora

**Не перетворювати Shuttle Cockpit на ще одну палітру.**

Інтерфейсний стиль і кольорова палітра повинні бути незалежними.

---

# 2. Ключовий принцип даних

Не створювати окрему математику для Shuttle Cockpit.

Використовувати один спільний engine:

```text
Clock
  ↓
JourneyCalculator
  ↓
LiveJourneyController
  ↓
JourneySnapshot
      ├── CosmicMinimalView
      └── ShuttleCockpitView
```

Обидва стилі отримують однакові:
- profile;
- distance;
- elapsed time;
- current speed;
- readout mode;
- time coordinates state;
- audio state;
- locale.

**Одна математика → різні способи подачі.**

---

# 3. Новий Interface Style controller

Створити окремий controller, наприклад:

`JourneyStyleController`

Не використовувати для цього наявний `ThemeController`, оскільки він уже відповідає за color palettes.

Рекомендований enum:

```dart
enum JourneyStyle {
  cosmicMinimal,
  shuttleCockpit,
}
```

Рекомендований persistence key:

```text
journey_style_v1
```

Поведінка:
- вибраний стиль зберігається локально;
- після перезапуску застосунок відкриває останній вибраний стиль;
- default = `cosmicMinimal`.

---

# 4. Рекомендована структура коду

```text
app/
  journey_style_controller.dart

core/
  journey_style/
    journey_style.dart

services/
  local_storage/
    journey_style_store.dart

features/
  journey/
    journey_screen.dart
    live_journey_controller.dart

    views/
      cosmic_minimal/
        cosmic_minimal_view.dart

      shuttle_cockpit/
        shuttle_cockpit_view.dart
        shuttle_window.dart
        shuttle_starfield.dart
        distance_panel.dart
        flight_time_panel.dart
        cockpit_controls.dart
        cockpit_indicators.dart
        cockpit_theme_tokens.dart
```

Допускається адаптація до існуючої архітектури, але:
- не дублювати controller logic;
- не дублювати journey calculations;
- не створювати два незалежні timer engines.

---

# 5. JourneyScreen після рефакторингу

`JourneyScreen` має стати контейнером.

Його відповідальність:
- lifecycle;
- LiveJourneyController;
- shared clock;
- shared audio;
- shared readout mode;
- shared time coordinates;
- selected interface style;
- routing/menu.

Візуальна частина:

```dart
switch (journeyStyle) {
  case JourneyStyle.cosmicMinimal:
    return CosmicMinimalView(...);

  case JourneyStyle.shuttleCockpit:
    return ShuttleCockpitView(...);
}
```

---

# 6. Cosmic Minimal

Поточний інтерфейс зберегти як окремий стиль.

Не ламати існуючий дизайн.

Основні елементи:
- Земля;
- distance;
- total days;
- total seconds;
- human-readable scale;
- AUDIO / TIME / MODE controls;
- Cosmic Pulse;
- Continuous mode.

Рефакторинг дозволений лише настільки, наскільки потрібно для винесення UI в `CosmicMinimalView`.

---

# 7. Shuttle Cockpit — головна концепція

Користувач бачить інтерфейс ніби з капітанського крісла персонального зорельота.

Верх:
- панорамне переднє вікно шатла;
- глибокий космос;
- зорі повільно рухаються назустріч.

Нижче:
- основна приборна панель.

Два головні табло:

1. `DISTANCE`
2. `FLIGHT TIME`

Стиль:
- premium;
- calm;
- restrained sci-fi;
- не бойовий;
- не gamer HUD;
- не cyberpunk.

---

# 8. Shuttle Cockpit — структура головного екрана

## 8.1. Top bar

Ліворуч:
- menu.

Праворуч:
- locale.

Опційно по центру:
- `FLIGHT ACTIVE`

Не використовувати великий title `Cosmic Journey`.

---

## 8.2. Shuttle Window

Переднє вікно:
- широке;
- панорамне;
- легка перспектива;
- темна графітова рамка;
- без копіювання конкретного NASA cockpit.

За вікном:
- black/deep navy space;
- кілька шарів зір;
- дуже повільний рух до користувача.

---

# 9. Starfield animation

Рекомендовано 3 шари:

## Far stars
- дуже дрібні;
- дуже повільні;
- low opacity.

## Mid stars
- трохи більші;
- рух трохи швидший.

## Near highlights
- дуже мало;
- трохи яскравіші;
- без довгих шлейфів.

Напрям:
- від центральної точки перспективи назовні;
- створює відчуття польоту вперед.

Не використовувати:
- warp speed;
- довгі streaks;
- метеори;
- вибухи;
- lens flare;
- швидкі зірки.

---

# 10. DISTANCE panel

Головний дисплей Shuttle Cockpit.

Приклад:

```text
DISTANCE

702 691 673 279
KM

≈ 702,7 млрд км
```

Вимоги:
- найбільше число на екрані;
- whole kilometres only;
- no decimals;
- tabular figures;
- технічний, але читабельний шрифт;
- м’яке внутрішнє світіння;
- тонка дисплейна рамка;
- без важкого неону.

Optional status line:

```text
NAV LOCK    CMB REF
```

---

# 11. FLIGHT TIME panel

Другий головний дисплей.

Затверджений базовий формат:

```text
FLIGHT TIME

21981     14     26
DAYS      HRS    SEC
```

Логіка:
- `DAYS` = повні дні від початку подорожі;
- `HRS` = залишкові години після повних днів;
- `SEC` = поточні секунди після повної хвилини.

Секунди рухаються щосекунди.

## Важливо про minutes

На цьому етапі **не додавати MIN за замовчуванням**.

Але реалізація повинна дозволяти легко протестувати альтернативний layout:

```text
DAYS / HRS / MIN / SEC
```

Це може бути окремий UX experiment перед фінальним релізом.

Не змінювати затверджений базовий формат без окремого рішення.

---

# 12. Cosmic Pulse у Shuttle Cockpit

Cosmic Pulse залишається default режимом.

Раз на секунду синхронно оновлюються:
- DISTANCE;
- FLIGHT TIME seconds;
- NOW time, якщо TIME увімкнено.

Усе має походити від одного authoritative clock.

Не використовувати окремий Timer для NOW.

---

# 13. Continuous mode

Зберегти існуючий Continuous mode.

Вимоги:
- 5–10 Hz presentation refresh;
- distance = whole kilometres only;
- seconds = integer only;
- no `.000`;
- no fractional seconds.

---

# 14. Shuttle Cockpit — візуальний Cosmic Pulse

Під час 1Hz pulse:
- цифри можуть зробити soft fade/roll;
- один маленький indicator може м’яко пульсувати;
- glow може коротко підсилитися.

Тривалість:
- 250–400 ms.

Не використовувати:
- blink;
- aggressive zoom;
- bounce;
- white flash.

---

# 15. Cockpit status indicators

Максимум 3–5 одночасно.

Можливі:

- `NAV LOCK`
- `CMB REF`
- `FLIGHT ACTIVE`
- `SYSTEM NOMINAL`
- `CLOCK SYNC`
- `PULSE`
- `CRUISE`

Стиль:

```text
● NAV LOCK
```

або:

```text
[ NAV ]
```

Кольори:
- cyan;
- blue-white;
- muted teal.

Red не використовувати у normal state.

---

# 16. AUDIO / TIME / MODE на головному екрані

У Shuttle Cockpit це частина приборної панелі.

Базові controls:

```text
AUDIO
TIME
MODE
```

Можливе представлення:

```text
AUDIO ●
TIME  ○
MODE  PULSE
```

Вимоги:
- компактно;
- touch target ≥ 44x44 logical px;
- accessibility labels;
- не конкурують із двома головними табло.

---

# 17. TIME control

TIME має працювати прямо з головного екрана.

Не змушувати користувача йти в Settings.

Використовувати existing `TimeCoordinatesController`.

Settings toggle залишити як дублюючий control.

---

# 18. Time Coordinates у Shuttle Cockpit

Коли TIME = ON:

рекомендований формат:

```text
START  01.04.1966 08:45
NOW    06.09.2026 22:10:14
```

Стиль:
- 11–13 px;
- muted;
- opacity 55–70%;
- tabular figures;
- без окремої великої картки.

Якщо відомий лише рік:

```text
START  1966 · приблизно
```

Не показувати fake exact date.

---

# 19. Audio / Atmosphere

Shuttle Cockpit використовує існуючий audio controller.

Free sound:
- `Deep Space`

Shuttle-specific atmosphere може містити:
- low spacecraft hum;
- subtle electronic air;
- distant navigation texture;
- very quiet system ambience.

Не використовувати:
- alarms;
- vocals;
- drums;
- one-second audible tick.

---

# 20. Audio playback state

Веб playback повинен мати реальний стан, а не лише `enabled`.

Рекомендована модель:

```text
off
starting
playing
blocked
error
```

Якщо браузер блокує playback:
- не показувати фальшивий playing state;
- дати користувачу зрозумілий tap-to-enable control.

---

# 21. Перемикання стилів

Перемикання між `Cosmic Minimal` і `Shuttle Cockpit`:

- без reload;
- без втрати profile;
- без reset counters;
- без нового calculator;
- без restart journey.

Рекомендована анімація:
- crossfade 250–400 ms.

Після switch значення мають одразу бути актуальними.

---

# 22. Styles screen — нова структура

Переробити екран `Styles` на два незалежні блоки.

## INTERFACE STYLE

### Cosmic Minimal
- current interface;
- free/default.

### Shuttle Cockpit
- new interface.

Під кожним:
- title;
- subtitle;
- small preview;
- selected state;
- optional Pro badge later.

## COLOR PALETTE

Залишити:
- Void
- OLED
- Midnight
- Aurora.

---

# 23. Preview cards

Для interface styles бажано зробити preview-картки.

### Cosmic Minimal preview
- Earth;
- 3 counters.

### Shuttle Cockpit preview
- window;
- small starfield;
- distance panel;
- flight time panel.

Preview може бути статичним або дуже легким animated preview.

---

# 24. Free / Pro behavior під час розробки

На етапі розробки:

- `Cosmic Minimal` — доступний;
- `Shuttle Cockpit` — також доступний.

**Не блокувати Shuttle Cockpit під Pro під час тестування.**

Причина:
- потрібно тестувати UX;
- потрібно порівняти стилі;
- потрібно оцінити performance;
- Pro gate не має заважати QA.

---

# 25. Pro behavior перед релізом

Пізніше рекомендовано:

### Free
- Cosmic Minimal.

### Pro
- Shuttle Cockpit.
- майбутні styles:
  - Navigation Console;
  - Mission Computer;
  - Observation Deck;
  - Deep Space Vessel.

Можливий preview для locked styles.

Наприклад:
- `Preview`;
- короткий live preview;
- `Use this style` → Pro unlock.

Не реалізовувати paywall у цьому завданні, якщо він ще не потрібен.

---

# 26. Color palette + interface combinations

Архітектура повинна дозволяти:

```text
Cosmic Minimal + Void
Cosmic Minimal + OLED
Cosmic Minimal + Midnight
Cosmic Minimal + Aurora

Shuttle Cockpit + Void
Shuttle Cockpit + OLED
Shuttle Cockpit + Midnight
Shuttle Cockpit + Aurora
```

Якщо окремі палітри не пасують Shuttle Cockpit, дозволяється додати cockpit-specific token mapping, але не змішувати interface id з palette id.

---

# 27. Shuttle Cockpit visual system

## Background
- near-black;
- graphite;
- deep navy.

## Main numbers
- cold white;
- pale blue-white.

## Accent
- cyan;
- cold blue;
- soft teal.

## Secondary
- steel gray;
- muted blue-gray.

---

# 28. Typography

Primary counters:
- mono / semi-mono;
- tabular figures;
- technical but premium.

Possible direction:
- IBM Plex Mono;
- JetBrains Mono;
- Roboto Mono;
- Space Mono;
- SF Mono-like.

Labels:
- Inter;
- Manrope;
- Sora;
- system sans.

Не використовувати:
- pixel font;
- arcade font;
- aggressive retro-terminal style.

---

# 29. Materials

Cockpit:
- matte composite;
- dark glass;
- subtle bevel;
- thin illuminated edge;
- light inner shadow.

Не використовувати:
- chrome overload;
- huge bolts;
- grunge;
- industrial military look.

---

# 30. Responsive layout

## Mobile portrait
Пріоритет:
1. shuttle window;
2. distance;
3. flight time;
4. controls.

Якщо мало висоти:
- зменшити window;
- status indicators приховати першими;
- не робити counters занадто малими.

## Tablet
- більша window area;
- виразніші physical panel frames.

## Desktop web
- centered composition;
- max width ~700–900 px;
- не розтягувати cockpit на всю ширину браузера.

---

# 31. Reduced Motion

Якщо reduced motion:

- starfield speed зменшити на 80–90% або зупинити;
- pulse transition = minimal crossfade;
- no scale pulse;
- no flashing indicator.

---

# 32. Performance

Вимоги:
- бажано 60 fps;
- 30 fps допустимо на слабких пристроях;
- starfield не повинен впливати на journey calculation;
- pause starfield when app/page hidden;
- resume без накопичення frames;
- no memory leaks;
- no duplicate ticker;
- no duplicate audio instance.

---

# 33. Accessibility

- sufficient contrast;
- 44x44 tap targets;
- accessibility labels;
- no forced screen-reader announcement every second;
- static semantic summary замість aggressive live region;
- reduced motion support.

---

# 34. Не змінювати

У цьому завданні не змінювати:

- science constants;
- distance formula;
- JourneyCalculator;
- birth date logic;
- JourneyProfile model без необхідності;
- CMB model;
- local profile persistence;
- localisation architecture;
- existing audio preference storage;
- existing readout mode storage.

---

# 35. Acceptance Criteria — architecture

1. Є `JourneyStyle` model/enum.
2. Є `JourneyStyleController`.
3. Є local persistence.
4. Default = Cosmic Minimal.
5. Shuttle Cockpit selectable.
6. Interface style і color palette незалежні.
7. Один LiveJourneyController використовується для обох views.
8. Немає дублювання calculator logic.
9. Switch не скидає journey state.
10. Switch не перезавантажує app.

---

# 36. Acceptance Criteria — Cosmic Minimal

11. Existing main UI збережено.
12. Existing Cosmic Pulse працює.
13. Existing Continuous працює.
14. Existing AUDIO/TIME/MODE працюють.
15. Existing localisation працює.

---

# 37. Acceptance Criteria — Shuttle Cockpit

16. Є captain-seat visual composition.
17. Є panoramic front window.
18. Є slow incoming starfield.
19. DISTANCE — головний дисплей.
20. FLIGHT TIME — другий дисплей.
21. FLIGHT TIME показує DAYS / HRS / SEC.
22. Seconds оновлюються 1Hz.
23. DISTANCE синхронізований із Cosmic Pulse.
24. TIME працює прямо на main screen.
25. AUDIO працює.
26. MODE працює.
27. No decimals.
28. Time coordinates visually secondary.
29. Reduced Motion supported.
30. Mobile layout stable.
31. Web layout stable.

---

# 38. Acceptance Criteria — styles screen

32. Styles screen має окремий блок Interface Style.
33. Styles screen має окремий блок Color Palette.
34. Cosmic Minimal і Shuttle Cockpit мають preview.
35. Selected state видно.
36. Interface style persistence працює.
37. Palette persistence продовжує працювати.

---

# 39. Tests

Додати/оновити тести:

- default style = cosmicMinimal;
- style persistence;
- switching interface styles;
- same snapshot used in both styles;
- no counter reset on switch;
- Shuttle Distance whole-number formatting;
- Shuttle Flight Time formatting;
- Shuttle seconds update;
- TIME toggle shared state;
- MODE shared state;
- reduced motion starfield;
- Styles screen interface/palette separation;
- Cosmic Minimal regression tests.

---

# 40. Необов’язковий UX experiment

Перед остаточним lock Shuttle Cockpit дозволено зробити dev-only comparison:

### Variant A
`DAYS / HRS / SEC`

### Variant B
`DAYS / HRS / MIN / SEC`

Це не user-facing setting.

Мета:
- порівняти читабельність;
- визначити, чи відсутність minutes виглядає природно.

Default у production-spec лишається:
`DAYS / HRS / SEC`.

---

# 41. Етапи реалізації

## Phase 1 — Architecture
- JourneyStyle;
- controller;
- storage;
- JourneyScreen refactor;
- CosmicMinimalView extraction.

## Phase 2 — Shuttle static UI
- cockpit layout;
- window;
- distance;
- flight time;
- controls.

## Phase 3 — Motion
- starfield;
- Cosmic Pulse response;
- crossfade between styles.

## Phase 4 — Integration
- TIME;
- AUDIO;
- MODE;
- palette compatibility.

## Phase 5 — Styles screen
- Interface Style section;
- Color Palette section;
- previews.

## Phase 6 — QA
- responsive;
- reduced motion;
- performance;
- audio web behavior;
- regression tests.

---

# 42. Очікуваний результат від Codex

Після виконання Codex має повідомити:

1. які файли створено;
2. які файли змінено;
3. як реалізовано `JourneyStyleController`;
4. як зберігається style selection;
5. як `JourneyScreen` ділиться між двома views;
6. як гарантовано один shared journey snapshot;
7. як реалізовано Shuttle starfield;
8. як реалізовано Flight Time;
9. як TIME/AUDIO/MODE використовують existing controllers;
10. які тести додано;
11. чи були performance compromises;
12. чи залишилися browser-specific limitations.

---

# 43. Final product principle

`Cosmic Minimal` і `Shuttle Cockpit` — це не дві різні програми.

Це два способи пережити ту саму подорож.

**Cosmic Minimal**
> Я спостерігаю свою подорож.

**Shuttle Cockpit**
> Я сиджу за штурвалом свого польоту.

Дані, математика та час повинні залишатися спільними.
Змінюється лише спосіб, у який людина бачить і відчуває свою подорож.
