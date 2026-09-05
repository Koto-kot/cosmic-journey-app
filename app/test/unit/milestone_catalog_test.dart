import 'package:cosmic_journey/core/science_constants.dart';
import 'package:cosmic_journey/services/milestones/milestone_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('presets mark 10M as reached after one day at CMB speed', () {
    const distance = 86400 * ScienceConstants.averageCmbSpeedKmPerSecond;
    final items = MilestoneCatalog.evaluate(
      distanceKm: distance,
      speedKmPerSecond: ScienceConstants.averageCmbSpeedKmPerSecond,
    );
    expect(items.length, 3);
    expect(items[0].thresholdKm, 10000000);
    expect(items[0].reached, isTrue);
    expect(items[1].thresholdKm, 100000000);
    expect(items[1].reached, isFalse);
    expect(items[2].thresholdKm, 1000000000);
  });

  test('custom interval adds the next multiple beyond current distance', () {
    final items = MilestoneCatalog.evaluate(
      distanceKm: 25000000,
      speedKmPerSecond: 370,
      customIntervalKm: 10000000,
    );
    expect(items.last.custom, isTrue);
    expect(items.last.thresholdKm, 30000000);
    expect(items.last.reached, isFalse);
  });
}
