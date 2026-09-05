import 'package:cosmic_journey/core/formatters/journey_date_formatter.dart';
import 'package:cosmic_journey/features/journey/journey_start_precision.dart';
import 'package:cosmic_journey/l10n/app_localizations_en.dart';
import 'package:cosmic_journey/l10n/app_localizations_uk.dart';
import 'package:cosmic_journey/services/journey_calculator/journey_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final en = AppLocalizationsEn();
  final uk = AppLocalizationsUk();
  const locale = Locale('en');

  JourneyProfile profileWith({int? month, int? day, int? hour, int? minute}) {
    return JourneyProfile.fromParts(
      year: 1966,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      nowUtc: DateTime.utc(2026, 9, 5),
      localOffset: Duration.zero,
    );
  }

  test('year-only profile never shows a fabricated exact date', () {
    final profile = profileWith();
    expect(profile.hasDate, isFalse);
    expect(
      JourneyStartPrecision.subtitle(profile, en, locale),
      '1966 · approximate',
    );
    expect(
      JourneyStartPrecision.subtitle(profile, uk, const Locale('uk')),
      '1966 · приблизно',
    );
  });

  test('date known but time unknown shows the date with a time-unknown tag', () {
    final profile = profileWith(month: 4, day: 1);
    expect(profile.hasDate, isTrue);
    expect(profile.hasTime, isFalse);
    final expectedDate = JourneyDateFormatter.date(
      profile.canonicalBirthUtc,
      locale,
    );
    expect(
      JourneyStartPrecision.subtitle(profile, en, locale),
      '$expectedDate · time unknown',
    );
  });

  test('exact date and time render as date and time, not a bare year', () {
    final profile = profileWith(month: 4, day: 1, hour: 8, minute: 45);
    expect(profile.hasDate, isTrue);
    expect(profile.hasTime, isTrue);
    expect(profile.isApproximate, isFalse);
    final expected = JourneyDateFormatter.dateAndTime(
      profile.canonicalBirthUtc,
      locale,
    );
    expect(JourneyStartPrecision.subtitle(profile, en, locale), expected);
    expect(expected, isNot(contains('approximate')));
    expect(expected, isNot(contains('unknown')));
  });
}
