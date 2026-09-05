import 'package:cosmic_journey/services/journey_calculator/journey_snapshot.dart';
import 'package:cosmic_journey/services/statistics/journey_statistics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('averages are distance divided by elapsed time', () {
    final snapshot = JourneySnapshot(
      elapsedSeconds: 86400,
      fullDays: 1,
      distanceKm: 31968000,
      speedKmPerSecond: 370,
      isApproximate: true,
      calculatedAt: DateTime.utc(2000, 1, 2),
    );
    final stats = JourneyStatistics.fromSnapshot(snapshot);
    expect(stats.kmPerDay, closeTo(31968000, 0.01));
    expect(stats.kmPerYear, closeTo(31968000 * 365.25, 1));
    expect(stats.nextBillion.thresholdKm, 1000000000);
  });
}
