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
      'Cosmic Pro — разова покупка. У цій збірці її ще немає.';

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
}
