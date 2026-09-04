// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cosmic Journey';

  @override
  String get whenDidJourneyBegin => 'When did your journey begin?';

  @override
  String get birthYearLabel => 'Birth year';

  @override
  String get beginJourney => 'Begin journey';

  @override
  String get privacyNote => 'Your birth year stays on this device.';

  @override
  String get daysLabel => 'days';

  @override
  String get secondsLabel => 'seconds';

  @override
  String get kmLabel => 'km';

  @override
  String get menuTooltip => 'Menu';

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuPlaceholder => 'More features will arrive in a later version.';

  @override
  String get close => 'Close';

  @override
  String get preparingJourney => 'Preparing your journey';

  @override
  String get nextMilestone => 'NEXT MILESTONE';

  @override
  String get currentSpeed => 'CURRENT SPEED';

  @override
  String milestoneCountdown(String days, String clock) {
    return 'in $days days $clock';
  }

  @override
  String get widgetsItem => 'WIDGETS';

  @override
  String get stylesItem => 'STYLES';

  @override
  String get scienceItem => 'CALCULATION EXPLANATION';

  @override
  String get proItem => 'COSMIC PRO';

  @override
  String get proSubtitle => 'Pro: widgets, styles, themes';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get saveBirthYear => 'Save birth year';

  @override
  String get widgetsSoon => 'Home-screen widgets will arrive with Cosmic Pro.';

  @override
  String get stylesSoon =>
      'Themes and colour styles will arrive with Cosmic Pro.';

  @override
  String get proSoon =>
      'Cosmic Pro is a one-time purchase. It is not for sale in this build.';

  @override
  String get scienceTitle => 'How the distance is calculated';

  @override
  String get sciencePathLength =>
      'The number is an estimated path length relative to the cosmic microwave background rest frame.';

  @override
  String get scienceNotCentre =>
      'It is not distance from the centre of the Universe, and it is not a GPS path.';

  @override
  String scienceSpeed(String speed) {
    return 'Base mode multiplies elapsed seconds by an average Solar-System speed of $speed km/s.';
  }

  @override
  String get scienceFrame =>
      'Earth’s orbital motion is not modelled here. A later Scientific Mode can replace this calculator without changing the live screen.';

  @override
  String semanticDistance(String distance) {
    return 'Estimated distance travelled: $distance kilometres';
  }

  @override
  String semanticDays(String days) {
    return '$days days since your journey began';
  }

  @override
  String semanticSeconds(String seconds) {
    return '$seconds seconds since your journey began';
  }
}
