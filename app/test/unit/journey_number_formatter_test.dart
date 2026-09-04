import 'package:cosmic_journey/core/formatters/journey_number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const formatter = JourneyNumberFormatter();
  const uk = JourneyNumberFormatter(decimalSeparator: ',');

  test('groups thousands with a narrow no-break space', () {
    expect(
      formatter.distanceKm(674218493771.842),
      '674\u202F218\u202F493\u202F771.842',
    );
  });

  test('formats days as a grouped integer', () {
    expect(formatter.days(20948), '20\u202F948');
  });

  test('formats seconds with a fractional live component', () {
    expect(
      formatter.seconds(1809907218.742),
      '1\u202F809\u202F907\u202F218.742',
    );
  });

  test('Ukrainian locale uses a comma decimal separator', () {
    expect(uk.distanceKm(1234.5), '1\u202F234,500');
    expect(
      JourneyNumberFormatter.fromLocale(const Locale('uk')).decimalSeparator,
      ',',
    );
    expect(
      JourneyNumberFormatter.fromLocale(const Locale('en')).decimalSeparator,
      '.',
    );
  });

  test('compact formatter uses K/M/B/T suffixes', () {
    expect(formatter.compact(1234), '1.2K');
    expect(formatter.compact(12.4e6), '12.4M');
    expect(formatter.compact(674.2e9), '674.2B');
    expect(formatter.compact(1.5e12), '1.5T');
  });

  test('small values keep fraction digits without grouping', () {
    expect(formatter.distanceKm(12.5), '12.500');
    expect(formatter.days(3), '3');
  });
}
