// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Космічна подорож';

  @override
  String get whenDidJourneyBegin => 'Коли почалася твоя подорож?';

  @override
  String get birthYearLabel => 'Рік народження';

  @override
  String get beginJourney => 'Почати подорож';

  @override
  String get privacyNote => 'Рік народження зберігається на цьому пристрої.';

  @override
  String get daysLabel => 'днів';

  @override
  String get secondsLabel => 'секунд';

  @override
  String get kmLabel => 'km';

  @override
  String get menuTooltip => 'Меню';

  @override
  String get languageTooltip => 'Мова';

  @override
  String get languageEnglish => 'ENG';

  @override
  String get languageUkrainian => 'UA';

  @override
  String get enableAtmosphere => 'Увімкнути атмосферу';

  @override
  String get muteAtmosphere => 'Вимкнути атмосферу';

  @override
  String get soundscapeDeepSpace => 'Глибокий космос';

  @override
  String humanScale(String value) {
    return '≈ $value';
  }

  @override
  String humanScaleKm(String value) {
    return '≈ $value km';
  }

  @override
  String get menuTitle => 'Меню';

  @override
  String get menuPlaceholder => 'Інші функції з\'являться пізніше.';

  @override
  String get close => 'Закрити';

  @override
  String get preparingJourney => 'Готуємо твою подорож';

  @override
  String get nextMilestone => 'НАСТУПНА ВІХА';

  @override
  String get currentSpeed => 'ШВИДКІСТЬ ЗАРАЗ';

  @override
  String milestoneCountdown(String days, String clock) {
    return 'ще $days дні $clock';
  }

  @override
  String get widgetsItem => 'ВІДЖЕТИ';

  @override
  String get stylesItem => 'СТИЛІ';

  @override
  String get scienceItem => 'ПОЯСНЕННЯ РОЗРАХУНКУ';

  @override
  String get proItem => 'COSMIC PRO';

  @override
  String get proSubtitle => 'Pro: віджети, стилі, теми';

  @override
  String get settingsTitle => 'НАЛАШТУВАННЯ';

  @override
  String get saveBirthYear => 'Зберегти рік народження';

  @override
  String get widgetsSoon => 'Віджети з’являться разом із Cosmic Pro.';

  @override
  String get stylesSoon => 'Теми та стилі з’являться разом із Cosmic Pro.';

  @override
  String get proSoon =>
      'Cosmic Pro буде річною підпискою. У цій збірці її ще немає.';

  @override
  String get scienceTitle => 'Як рахується відстань';

  @override
  String get sciencePathLength =>
      'Це орієнтовна довжина шляху відносно системи спокою реліктового випромінювання.';

  @override
  String get scienceNotCentre =>
      'Це не відстань від центру Всесвіту і не GPS-маршрут.';

  @override
  String scienceSpeed(String speed) {
    return 'Базовий режим множить минулі секунди на середню швидкість Сонячної системи $speed km/s.';
  }

  @override
  String get scienceFrame =>
      'Орбітальний рух Землі тут не моделюється. Пізніше Scientific Mode зможе замінити цей калькулятор, не змінюючи живий екран.';

  @override
  String semanticDistance(String distance) {
    return 'Орієнтовна пройдена відстань: $distance кілометрів';
  }

  @override
  String semanticDays(String days) {
    return '$days днів від початку подорожі';
  }

  @override
  String semanticSeconds(String seconds) {
    return '$seconds секунд від початку подорожі';
  }

  @override
  String get milestonesItem => 'ВІХИ';

  @override
  String get statisticsItem => 'СТАТИСТИКА';

  @override
  String get shareItem => 'ПОДІЛИТИСЯ';

  @override
  String get atmosphereItem => 'АТМОСФЕРА';

  @override
  String get saveBirthDetails => 'Зберегти дату народження';

  @override
  String get birthMonthLabel => 'Місяць (необов’язково)';

  @override
  String get birthDayLabel => 'День (необов’язково)';

  @override
  String get birthTimeLabel => 'Час (необов’язково)';

  @override
  String get birthPrecisionHint =>
      'Якщо відомий лише рік, відлік іде від 1 липня опівдні за місцевим часом. Дата і час роблять одометр точнішим.';

  @override
  String get monthNotSet => 'Лише рік';

  @override
  String get dayNotSet => 'Не задано';

  @override
  String get timeNotSet => 'Опівдні';

  @override
  String get clearOptional => 'Скинути';

  @override
  String get proUnlockedTitle => 'У тебе Cosmic Pro';

  @override
  String get proUnlockedBody =>
      'У цій тестовій збірці всі поверхні Cosmic Pro відкриті. У магазині Cosmic Pro буде річною підпискою. Restore Purchases підключить Apple і Google у Phase 3.';

  @override
  String get restorePurchases => 'Відновити покупки';

  @override
  String get restorePurchasesEmpty => 'У цій збірці відновлювати нічого.';

  @override
  String get milestonesTitle => 'Віхи';

  @override
  String get milestoneReached => 'Досягнуто';

  @override
  String milestoneRemaining(String days, String clock) {
    return 'ще $days дні $clock';
  }

  @override
  String get milestoneCustom => 'Власна';

  @override
  String get customIntervalLabel => 'Власний інтервал (km)';

  @override
  String get customIntervalHint =>
      'Додаткові позначки між базовими. Мінімум 1 мільйон km.';

  @override
  String get saveCustomInterval => 'Зберегти інтервал';

  @override
  String get shareTitle => 'Поділитися';

  @override
  String get shareCopied => 'Скопійовано';

  @override
  String get shareIntro => 'Простий текстовий знімок живих чисел.';

  @override
  String get copyJourney => 'Копіювати подорож';

  @override
  String get stylesTitle => 'Стилі';

  @override
  String get styleVoid => 'Void';

  @override
  String get styleOled => 'OLED';

  @override
  String get styleMidnight => 'Midnight';

  @override
  String get styleAurora => 'Aurora';

  @override
  String get styleVoidSubtitle => 'Оригінальний вигляд Pulse';

  @override
  String get styleOledSubtitle => 'Чистий чорний, без туманності';

  @override
  String get styleMidnightSubtitle => 'Глибокий індиго, холодніше світло';

  @override
  String get styleAuroraSubtitle => 'Бірюзовий відблиск на лісовому чорному';

  @override
  String get atmosphereTitle => 'Атмосфера';

  @override
  String get soundscapeOrbitalDrift => 'Орбітальний дрейф';

  @override
  String get soundscapeAuroraName => 'Аврора';

  @override
  String get soundscapeBluePlanet => 'Блакитна планета';

  @override
  String get soundscapeInterstellar => 'Інтерстелар';

  @override
  String get soundscapeVoyager => 'Вояджер';

  @override
  String get soundscapeDeepSilence => 'Глибока тиша';

  @override
  String get soundscapeSolarWind => 'Сонячний вітер';

  @override
  String get soundscapeIonosphere => 'Іоносфера';

  @override
  String get soundscapeRedDwarf => 'Червоний карлик';

  @override
  String get soundscapeQuietStation => 'Тиха станція';

  @override
  String get soundscapeCometTail => 'Хвіст комети';

  @override
  String get soundscapeMagnetosphere => 'Магнітосфера';

  @override
  String get soundscapeSelected => 'Зараз грає';

  @override
  String get statisticsTitle => 'Статистика';

  @override
  String get statKmPerDay => 'Середні кілометри на день';

  @override
  String get statKmPerYear => 'Середні кілометри на рік';

  @override
  String get statNextBillion => 'Час до наступного мільярда кілометрів';

  @override
  String get statPrecision => 'Точність дати народження';

  @override
  String get statApproximate => 'Приблизно (рік або дата без часу)';

  @override
  String get statExact => 'Дата і час';

  @override
  String get widgetsStillSoon =>
      'Віджети домашнього екрана потребують збірки App Store або Play. Це Phase 3.';

  @override
  String get proIncluded => 'Входить у Cosmic Pro';

  @override
  String get readoutModeLabel => 'Рух лічильника';

  @override
  String get readoutPulse => 'Cosmic Pulse';

  @override
  String get readoutPulseHint =>
      'Відстань і секунди оновлюються разом раз на секунду.';

  @override
  String get readoutFlow => 'Безперервний';

  @override
  String get readoutFlowHint =>
      'Відстань і секунди оновлюються кілька разів на секунду цілими числами.';

  @override
  String get readoutSwitchToFlow => 'Перемкнути на безперервний відлік';

  @override
  String get readoutSwitchToPulse => 'Перемкнути на Cosmic Pulse';

  @override
  String get journeyStartItem => 'ПОЧАТОК ПОДОРОЖІ';

  @override
  String get journeyStartTitle => 'Початок подорожі';

  @override
  String journeyStartApproxYear(String year) {
    return '$year · приблизно';
  }

  @override
  String journeyStartTimeUnknown(String date) {
    return '$date · час невідомий';
  }

  @override
  String get journeyStartCoordLabel => 'ПОЧАТОК';

  @override
  String get nowCoordLabel => 'ЗАРАЗ';

  @override
  String get showTimeCoordinatesLabel => 'Показувати часові координати';

  @override
  String get atmosphereVolumeLabel => 'Гучність';
}
