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
  /// **'Cosmic Pro is a one-time purchase. It is not for sale in this build.'**
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
