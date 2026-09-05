import 'package:cosmic_journey/core/formatters/journey_date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Non-UTC DateTimes: `.toLocal()` inside the formatter is then a no-op
  // (DateTime.toLocal returns `this` when it's already local), so the
  // expected wall-clock values below hold regardless of the host's own
  // timezone.
  final start = DateTime(1966, 4, 1, 8, 45);
  final now = DateTime(2026, 9, 5, 14, 21, 7);

  test('formats English dates without hardcoded month tables', () {
    expect(JourneyDateFormatter.date(start, const Locale('en')), '01 Apr 1966');
    expect(JourneyDateFormatter.time(start, const Locale('en')), '08:45');
    expect(
      JourneyDateFormatter.dateAndTime(start, const Locale('en')),
      '01 Apr 1966 · 08:45',
    );
    expect(
      JourneyDateFormatter.dateTimeWithSeconds(now, const Locale('en')),
      '05 Sep 2026 · 14:21:07',
    );
  });

  test('formats Ukrainian dates in dd.MM.yyyy order', () {
    expect(JourneyDateFormatter.date(start, const Locale('uk')), '01.04.1966');
    expect(
      JourneyDateFormatter.dateAndTime(start, const Locale('uk')),
      '01.04.1966 · 08:45',
    );
    expect(
      JourneyDateFormatter.dateTimeWithSeconds(now, const Locale('uk')),
      '05.09.2026 · 14:21:07',
    );
  });
}
