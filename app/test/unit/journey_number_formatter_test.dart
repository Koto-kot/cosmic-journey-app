import 'package:cosmic_journey/core/formatters/journey_number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const formatter = JourneyNumberFormatter();
  const uk = JourneyNumberFormatter(
    decimalSeparator: ',',
    thousandLabel: 'тис.',
    millionLabel: 'млн',
    billionLabel: 'млрд',
    trillionLabel: 'трлн',
  );

  test('groups thousands with a narrow no-break space', () {
    expect(
      formatter.formatFullNumber(674218493771.842),
      '674\u202F218\u202F493\u202F772',
    );
  });

  test('formats days as a grouped integer', () {
    expect(formatter.days(20948), '20\u202F948');
  });

  test('formats seconds as a grouped integer', () {
    expect(formatter.seconds(1809907218.742), '1\u202F809\u202F907\u202F219');
  });

  test('Ukrainian locale uses a comma decimal separator', () {
    expect(uk.distanceKm(1234.5, fractionDigits: 1), '1\u202F234,5');
    expect(
      JourneyNumberFormatter.fromLocale(const Locale('uk')).decimalSeparator,
      ',',
    );
    expect(
      JourneyNumberFormatter.fromLocale(const Locale('en')).decimalSeparator,
      '.',
    );
  });

  test('human scale uses full words, not finance abbreviations', () {
    expect(formatter.formatHumanScale(1234), '1.23 thousand');
    expect(formatter.formatHumanScale(12.4e6), '12.4 million');
    expect(formatter.formatHumanScale(674.2e9), '674.2 billion');
    expect(formatter.formatHumanScale(1.5e12), '1.50 trillion');
    expect(formatter.compact(847.2e6), '847.2 million');
  });

  test('human scale matches the Cosmic Pulse examples', () {
    expect(formatter.formatHumanScale(702673018501), '702.7 billion');
    expect(formatter.formatHumanScale(1899116266), '1.90 billion');
    expect(uk.formatHumanScale(702673018501), '702,7 млрд');
    expect(uk.formatHumanScale(1899116266), '1,90 млрд');
  });

  test('small values stay grouped integers without a scale word', () {
    expect(formatter.distanceKm(12.5), '13');
    expect(formatter.formatHumanScale(847), '847');
    expect(formatter.days(3), '3');
  });
}
