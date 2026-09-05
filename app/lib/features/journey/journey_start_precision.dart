import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

import '../../core/formatters/journey_date_formatter.dart';
import '../../services/journey_calculator/journey_profile.dart';

/// Human-readable birth precision, used by the Journey Start menu subtitle
/// and edit screen. Never renders a fabricated exact date for a year-only
/// profile.
abstract final class JourneyStartPrecision {
  static String subtitle(
    JourneyProfile profile,
    AppLocalizations l10n,
    Locale locale,
  ) {
    if (!profile.hasDate) {
      return l10n.journeyStartApproxYear(profile.birthYear.toString());
    }
    final date = JourneyDateFormatter.date(profile.canonicalBirthUtc, locale);
    if (!profile.hasTime) {
      return l10n.journeyStartTimeUnknown(date);
    }
    return JourneyDateFormatter.dateAndTime(profile.canonicalBirthUtc, locale);
  }
}
