import 'package:cosmic_journey/core/formatters/journey_number_formatter.dart';
import 'package:cosmic_journey/services/journey_calculator/journey_snapshot.dart';
import 'package:cosmic_journey/services/share/journey_share_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('plain share text lists integer km, days and seconds', () {
    final snapshot = JourneySnapshot(
      elapsedSeconds: 86400,
      fullDays: 1,
      distanceKm: 31968000,
      speedKmPerSecond: 370,
      isApproximate: true,
      calculatedAt: DateTime.utc(2000, 1, 2),
    );
    final text = JourneyShareText.plain(
      snapshot: snapshot,
      formatter: const JourneyNumberFormatter(),
      appTitle: 'Cosmic Journey',
      kmLabel: 'km',
      daysLabel: 'days',
      secondsLabel: 'seconds',
    );
    expect(text, contains('Cosmic Journey'));
    expect(text, contains('31'));
    expect(text, contains('km'));
    expect(text, contains('days'));
    expect(text, contains('seconds'));
  });
}
