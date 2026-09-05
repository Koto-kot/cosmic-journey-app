import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Cosmic Journey'**
  String get appTitle;

  /// No description provided for @whenDidJourneyBegin.
  ///
  /// In en, this message translates to:
  /// **'When did your journey begin?'**
  String get whenDidJourneyBegin;

  /// No description provided for @birthYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth year'**
  String get birthYearLabel;

  /// No description provided for @beginJourney.
  ///
  /// In en, this message translates to:
  /// **'Begin journey'**
  String get beginJourney;

  /// No description provided for @privacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your birth year stays on this device.'**
  String get privacyNote;

  /// No description provided for @daysLabel.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get daysLabel;

  /// No description provided for @secondsLabel.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get secondsLabel;

  /// No description provided for @kmLabel.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get kmLabel;

  /// No description provided for @menuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTooltip;

  /// No description provided for @languageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTooltip;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'ENG'**
  String get languageEnglish;

  /// No description provided for @languageUkrainian.
  ///
  /// In en, this message translates to:
  /// **'UA'**
  String get languageUkrainian;

  /// No description provided for @enableAtmosphere.
  ///
  /// In en, this message translates to:
  /// **'Enable atmosphere'**
  String get enableAtmosphere;

  /// No description provided for @muteAtmosphere.
  ///
  /// In en, this message translates to:
  /// **'Mute atmosphere'**
  String get muteAtmosphere;

  /// No description provided for @soundscapeDeepSpace.
  ///
  /// In en, this message translates to:
  /// **'Deep Space'**
  String get soundscapeDeepSpace;

  /// No description provided for @humanScale.
  ///
  /// In en, this message translates to:
  /// **'≈ {value}'**
  String humanScale(String value);

  /// No description provided for @humanScaleKm.
  ///
  /// In en, this message translates to:
  /// **'≈ {value} km'**
  String humanScaleKm(String value);

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @menuPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'More features will arrive in a later version.'**
  String get menuPlaceholder;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @preparingJourney.
  ///
  /// In en, this message translates to:
  /// **'Preparing your journey'**
  String get preparingJourney;

  /// No description provided for @nextMilestone.
  ///
  /// In en, this message translates to:
  /// **'NEXT MILESTONE'**
  String get nextMilestone;

  /// No description provided for @currentSpeed.
  ///
  /// In en, this message translates to:
  /// **'CURRENT SPEED'**
  String get currentSpeed;

  /// No description provided for @milestoneCountdown.
  ///
  /// In en, this message translates to:
  /// **'in {days} days {clock}'**
  String milestoneCountdown(String days, String clock);

  /// No description provided for @widgetsItem.
  ///
  /// In en, this message translates to:
  /// **'WIDGETS'**
  String get widgetsItem;

  /// No description provided for @stylesItem.
  ///
  /// In en, this message translates to:
  /// **'STYLES'**
  String get stylesItem;

  /// No description provided for @scienceItem.
  ///
  /// In en, this message translates to:
  /// **'CALCULATION EXPLANATION'**
  String get scienceItem;

  /// No description provided for @proItem.
  ///
  /// In en, this message translates to:
  /// **'COSMIC PRO'**
  String get proItem;

  /// No description provided for @proSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pro: widgets, styles, themes'**
  String get proSubtitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsTitle;

  /// No description provided for @saveBirthYear.
  ///
  /// In en, this message translates to:
  /// **'Save birth year'**
  String get saveBirthYear;

  /// No description provided for @widgetsSoon.
  ///
  /// In en, this message translates to:
  /// **'Home-screen widgets will arrive with Cosmic Pro.'**
  String get widgetsSoon;

  /// No description provided for @stylesSoon.
  ///
  /// In en, this message translates to:
  /// **'Themes and colour styles will arrive with Cosmic Pro.'**
  String get stylesSoon;

  /// No description provided for @proSoon.
  ///
  /// In en, this message translates to:
  /// **'Cosmic Pro will be a yearly subscription. It is not for sale in this build.'**
  String get proSoon;

  /// No description provided for @scienceTitle.
  ///
  /// In en, this message translates to:
  /// **'How the distance is calculated'**
  String get scienceTitle;

  /// No description provided for @sciencePathLength.
  ///
  /// In en, this message translates to:
  /// **'The number is an estimated path length relative to the cosmic microwave background rest frame.'**
  String get sciencePathLength;

  /// No description provided for @scienceNotCentre.
  ///
  /// In en, this message translates to:
  /// **'It is not distance from the centre of the Universe, and it is not a GPS path.'**
  String get scienceNotCentre;

  /// No description provided for @scienceSpeed.
  ///
  /// In en, this message translates to:
  /// **'Base mode multiplies elapsed seconds by an average Solar-System speed of {speed} km/s.'**
  String scienceSpeed(String speed);

  /// No description provided for @scienceFrame.
  ///
  /// In en, this message translates to:
  /// **'Earth’s orbital motion is not modelled here. A later Scientific Mode can replace this calculator without changing the live screen.'**
  String get scienceFrame;

  /// No description provided for @semanticDistance.
  ///
  /// In en, this message translates to:
  /// **'Estimated distance travelled: {distance} kilometres'**
  String semanticDistance(String distance);

  /// No description provided for @semanticDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days since your journey began'**
  String semanticDays(String days);

  /// No description provided for @semanticSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds since your journey began'**
  String semanticSeconds(String seconds);

  /// No description provided for @milestonesItem.
  ///
  /// In en, this message translates to:
  /// **'MILESTONES'**
  String get milestonesItem;

  /// No description provided for @statisticsItem.
  ///
  /// In en, this message translates to:
  /// **'STATISTICS'**
  String get statisticsItem;

  /// No description provided for @shareItem.
  ///
  /// In en, this message translates to:
  /// **'SHARE'**
  String get shareItem;

  /// No description provided for @atmosphereItem.
  ///
  /// In en, this message translates to:
  /// **'ATMOSPHERE'**
  String get atmosphereItem;

  /// No description provided for @saveBirthDetails.
  ///
  /// In en, this message translates to:
  /// **'Save birth details'**
  String get saveBirthDetails;

  /// No description provided for @birthMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month (optional)'**
  String get birthMonthLabel;

  /// No description provided for @birthDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day (optional)'**
  String get birthDayLabel;

  /// No description provided for @birthTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time (optional)'**
  String get birthTimeLabel;

  /// No description provided for @birthPrecisionHint.
  ///
  /// In en, this message translates to:
  /// **'Year only uses 1 July at noon, local time. Add a date and time for a more precise odometer.'**
  String get birthPrecisionHint;

  /// No description provided for @monthNotSet.
  ///
  /// In en, this message translates to:
  /// **'Year only'**
  String get monthNotSet;

  /// No description provided for @dayNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get dayNotSet;

  /// No description provided for @timeNotSet.
  ///
  /// In en, this message translates to:
  /// **'Noon'**
  String get timeNotSet;

  /// No description provided for @clearOptional.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearOptional;

  /// No description provided for @proUnlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'You have Cosmic Pro'**
  String get proUnlockedTitle;

  /// No description provided for @proUnlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Every Cosmic Pro surface is unlocked in this testing build. On the store, Cosmic Pro will be a yearly subscription. Restore Purchases will connect to Apple and Google in Phase 3.'**
  String get proUnlockedBody;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @restorePurchasesEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing to restore in this build.'**
  String get restorePurchasesEmpty;

  /// No description provided for @milestonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get milestonesTitle;

  /// No description provided for @milestoneReached.
  ///
  /// In en, this message translates to:
  /// **'Reached'**
  String get milestoneReached;

  /// No description provided for @milestoneRemaining.
  ///
  /// In en, this message translates to:
  /// **'{days} days {clock} remaining'**
  String milestoneRemaining(String days, String clock);

  /// No description provided for @milestoneCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get milestoneCustom;

  /// No description provided for @customIntervalLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom interval (km)'**
  String get customIntervalLabel;

  /// No description provided for @customIntervalHint.
  ///
  /// In en, this message translates to:
  /// **'Extra checkpoints between the presets. Minimum 1 million km.'**
  String get customIntervalHint;

  /// No description provided for @saveCustomInterval.
  ///
  /// In en, this message translates to:
  /// **'Save interval'**
  String get saveCustomInterval;

  /// No description provided for @shareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareTitle;

  /// No description provided for @shareCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get shareCopied;

  /// No description provided for @shareIntro.
  ///
  /// In en, this message translates to:
  /// **'A plain-text snapshot of the live integers.'**
  String get shareIntro;

  /// No description provided for @copyJourney.
  ///
  /// In en, this message translates to:
  /// **'Copy journey'**
  String get copyJourney;

  /// No description provided for @stylesTitle.
  ///
  /// In en, this message translates to:
  /// **'Styles'**
  String get stylesTitle;

  /// No description provided for @styleVoid.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get styleVoid;

  /// No description provided for @styleOled.
  ///
  /// In en, this message translates to:
  /// **'OLED'**
  String get styleOled;

  /// No description provided for @styleMidnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight'**
  String get styleMidnight;

  /// No description provided for @styleAurora.
  ///
  /// In en, this message translates to:
  /// **'Aurora'**
  String get styleAurora;

  /// No description provided for @styleVoidSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The original Pulse look'**
  String get styleVoidSubtitle;

  /// No description provided for @styleOledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'True black, no nebula wash'**
  String get styleOledSubtitle;

  /// No description provided for @styleMidnightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deep navy, cooler light'**
  String get styleMidnightSubtitle;

  /// No description provided for @styleAuroraSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Teal glow over forest black'**
  String get styleAuroraSubtitle;

  /// No description provided for @atmosphereTitle.
  ///
  /// In en, this message translates to:
  /// **'Atmosphere'**
  String get atmosphereTitle;

  /// No description provided for @soundscapeOrbitalDrift.
  ///
  /// In en, this message translates to:
  /// **'Orbital Drift'**
  String get soundscapeOrbitalDrift;

  /// No description provided for @soundscapeAuroraName.
  ///
  /// In en, this message translates to:
  /// **'Aurora'**
  String get soundscapeAuroraName;

  /// No description provided for @soundscapeBluePlanet.
  ///
  /// In en, this message translates to:
  /// **'Blue Planet'**
  String get soundscapeBluePlanet;

  /// No description provided for @soundscapeInterstellar.
  ///
  /// In en, this message translates to:
  /// **'Interstellar'**
  String get soundscapeInterstellar;

  /// No description provided for @soundscapeVoyager.
  ///
  /// In en, this message translates to:
  /// **'Voyager'**
  String get soundscapeVoyager;

  /// No description provided for @soundscapeDeepSilence.
  ///
  /// In en, this message translates to:
  /// **'Deep Silence'**
  String get soundscapeDeepSilence;

  /// No description provided for @soundscapeSolarWind.
  ///
  /// In en, this message translates to:
  /// **'Solar Wind'**
  String get soundscapeSolarWind;

  /// No description provided for @soundscapeIonosphere.
  ///
  /// In en, this message translates to:
  /// **'Ionosphere'**
  String get soundscapeIonosphere;

  /// No description provided for @soundscapeRedDwarf.
  ///
  /// In en, this message translates to:
  /// **'Red Dwarf'**
  String get soundscapeRedDwarf;

  /// No description provided for @soundscapeQuietStation.
  ///
  /// In en, this message translates to:
  /// **'Quiet Station'**
  String get soundscapeQuietStation;

  /// No description provided for @soundscapeCometTail.
  ///
  /// In en, this message translates to:
  /// **'Comet Tail'**
  String get soundscapeCometTail;

  /// No description provided for @soundscapeMagnetosphere.
  ///
  /// In en, this message translates to:
  /// **'Magnetosphere'**
  String get soundscapeMagnetosphere;

  /// No description provided for @soundscapeSelected.
  ///
  /// In en, this message translates to:
  /// **'Now playing'**
  String get soundscapeSelected;

  /// No description provided for @statisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsTitle;

  /// No description provided for @statKmPerDay.
  ///
  /// In en, this message translates to:
  /// **'Average kilometres per day'**
  String get statKmPerDay;

  /// No description provided for @statKmPerYear.
  ///
  /// In en, this message translates to:
  /// **'Average kilometres per year'**
  String get statKmPerYear;

  /// No description provided for @statNextBillion.
  ///
  /// In en, this message translates to:
  /// **'Time to the next billion kilometres'**
  String get statNextBillion;

  /// No description provided for @statPrecision.
  ///
  /// In en, this message translates to:
  /// **'Birth precision'**
  String get statPrecision;

  /// No description provided for @statApproximate.
  ///
  /// In en, this message translates to:
  /// **'Approximate (year or date without time)'**
  String get statApproximate;

  /// No description provided for @statExact.
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get statExact;

  /// No description provided for @widgetsStillSoon.
  ///
  /// In en, this message translates to:
  /// **'Home-screen widgets need an App Store or Play build. They stay in Phase 3.'**
  String get widgetsStillSoon;

  /// No description provided for @proIncluded.
  ///
  /// In en, this message translates to:
  /// **'Included with Cosmic Pro'**
  String get proIncluded;

  /// No description provided for @readoutModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Readout'**
  String get readoutModeLabel;

  /// No description provided for @readoutPulse.
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get readoutPulse;

  /// No description provided for @readoutPulseHint.
  ///
  /// In en, this message translates to:
  /// **'Distance and seconds update together once a second.'**
  String get readoutPulseHint;

  /// No description provided for @readoutFlow.
  ///
  /// In en, this message translates to:
  /// **'Flow'**
  String get readoutFlow;

  /// No description provided for @readoutFlowHint.
  ///
  /// In en, this message translates to:
  /// **'Distance and seconds move continuously on screen.'**
  String get readoutFlowHint;

  /// No description provided for @readoutSwitchToFlow.
  ///
  /// In en, this message translates to:
  /// **'Switch to Flow readout'**
  String get readoutSwitchToFlow;

  /// No description provided for @readoutSwitchToPulse.
  ///
  /// In en, this message translates to:
  /// **'Switch to Pulse readout'**
  String get readoutSwitchToPulse;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
