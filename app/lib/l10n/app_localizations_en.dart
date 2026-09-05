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
  String get languageTooltip => 'Language';

  @override
  String get languageEnglish => 'ENG';

  @override
  String get languageUkrainian => 'UA';

  @override
  String get enableAtmosphere => 'Enable atmosphere';

  @override
  String get muteAtmosphere => 'Mute atmosphere';

  @override
  String get soundscapeDeepSpace => 'Deep Space';

  @override
  String humanScale(String value) {
    return '≈ $value';
  }

  @override
  String humanScaleKm(String value) {
    return '≈ $value km';
  }

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
      'Cosmic Pro will be a yearly subscription. It is not for sale in this build.';

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

  @override
  String get milestonesItem => 'MILESTONES';

  @override
  String get statisticsItem => 'STATISTICS';

  @override
  String get shareItem => 'SHARE';

  @override
  String get atmosphereItem => 'ATMOSPHERE';

  @override
  String get saveBirthDetails => 'Save birth details';

  @override
  String get birthMonthLabel => 'Month (optional)';

  @override
  String get birthDayLabel => 'Day (optional)';

  @override
  String get birthTimeLabel => 'Time (optional)';

  @override
  String get birthPrecisionHint =>
      'Year only uses 1 July at noon, local time. Add a date and time for a more precise odometer.';

  @override
  String get monthNotSet => 'Year only';

  @override
  String get dayNotSet => 'Not set';

  @override
  String get timeNotSet => 'Noon';

  @override
  String get clearOptional => 'Clear';

  @override
  String get proUnlockedTitle => 'You have Cosmic Pro';

  @override
  String get proUnlockedBody =>
      'Every Cosmic Pro surface is unlocked in this testing build. On the store, Cosmic Pro will be a yearly subscription. Restore Purchases will connect to Apple and Google in Phase 3.';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get restorePurchasesEmpty => 'Nothing to restore in this build.';

  @override
  String get milestonesTitle => 'Milestones';

  @override
  String get milestoneReached => 'Reached';

  @override
  String milestoneRemaining(String days, String clock) {
    return '$days days $clock remaining';
  }

  @override
  String get milestoneCustom => 'Custom';

  @override
  String get customIntervalLabel => 'Custom interval (km)';

  @override
  String get customIntervalHint =>
      'Extra checkpoints between the presets. Minimum 1 million km.';

  @override
  String get saveCustomInterval => 'Save interval';

  @override
  String get shareTitle => 'Share';

  @override
  String get shareCopied => 'Copied to clipboard';

  @override
  String get shareIntro => 'A plain-text snapshot of the live integers.';

  @override
  String get copyJourney => 'Copy journey';

  @override
  String get stylesTitle => 'Styles';

  @override
  String get styleVoid => 'Void';

  @override
  String get styleOled => 'OLED';

  @override
  String get styleMidnight => 'Midnight';

  @override
  String get styleAurora => 'Aurora';

  @override
  String get styleVoidSubtitle => 'The original Pulse look';

  @override
  String get styleOledSubtitle => 'True black, no nebula wash';

  @override
  String get styleMidnightSubtitle => 'Deep navy, cooler light';

  @override
  String get styleAuroraSubtitle => 'Teal glow over forest black';

  @override
  String get atmosphereTitle => 'Atmosphere';

  @override
  String get soundscapeOrbitalDrift => 'Orbital Drift';

  @override
  String get soundscapeAuroraName => 'Aurora';

  @override
  String get soundscapeBluePlanet => 'Blue Planet';

  @override
  String get soundscapeInterstellar => 'Interstellar';

  @override
  String get soundscapeVoyager => 'Voyager';

  @override
  String get soundscapeDeepSilence => 'Deep Silence';

  @override
  String get soundscapeSolarWind => 'Solar Wind';

  @override
  String get soundscapeIonosphere => 'Ionosphere';

  @override
  String get soundscapeRedDwarf => 'Red Dwarf';

  @override
  String get soundscapeQuietStation => 'Quiet Station';

  @override
  String get soundscapeCometTail => 'Comet Tail';

  @override
  String get soundscapeMagnetosphere => 'Magnetosphere';

  @override
  String get soundscapeSelected => 'Now playing';

  @override
  String get statisticsTitle => 'Statistics';

  @override
  String get statKmPerDay => 'Average kilometres per day';

  @override
  String get statKmPerYear => 'Average kilometres per year';

  @override
  String get statNextBillion => 'Time to the next billion kilometres';

  @override
  String get statPrecision => 'Birth precision';

  @override
  String get statApproximate => 'Approximate (year or date without time)';

  @override
  String get statExact => 'Date and time';

  @override
  String get widgetsStillSoon =>
      'Home-screen widgets need an App Store or Play build. They stay in Phase 3.';

  @override
  String get proIncluded => 'Included with Cosmic Pro';

  @override
  String get readoutModeLabel => 'Readout';

  @override
  String get readoutPulse => 'Pulse';

  @override
  String get readoutPulseHint =>
      'Distance and seconds update together once a second.';

  @override
  String get readoutFlow => 'Flow';

  @override
  String get readoutFlowHint =>
      'Distance and seconds move continuously on screen.';

  @override
  String get readoutSwitchToFlow => 'Switch to Flow readout';

  @override
  String get readoutSwitchToPulse => 'Switch to Pulse readout';
}
