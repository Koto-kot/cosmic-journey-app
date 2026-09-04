import 'package:cosmic_journey/core/science_constants.dart';
import 'package:cosmic_journey/services/journey_calculator/journey_snapshot.dart';
import 'package:cosmic_journey/services/journey_calculator/live_journey_interpolator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const interpolator = LiveJourneyInterpolator();

  JourneySnapshot base({
    required DateTime at,
    double elapsedSeconds = 100,
    double speed = 370,
  }) {
    return JourneySnapshot(
      elapsedSeconds: elapsedSeconds,
      fullDays: elapsedSeconds ~/ 86400,
      distanceKm: elapsedSeconds * speed,
      speedKmPerSecond: speed,
      isApproximate: true,
      calculatedAt: at,
    );
  }

  test('interpolates distance as base + speed * elapsedSinceBase', () {
    final t0 = DateTime.utc(2024, 1, 1, 12);
    final snapshot = interpolator.interpolate(
      base: base(at: t0, elapsedSeconds: 1000, speed: 370),
      now: t0.add(const Duration(milliseconds: 2500)),
    );
    expect(snapshot.elapsedSeconds, closeTo(1002.5, 1e-9));
    expect(snapshot.distanceKm, closeTo(1002.5 * 370, 1e-6));
  });

  test('days roll over when interpolated seconds cross a day boundary', () {
    final t0 = DateTime.utc(2024, 1, 1);
    final snapshot = interpolator.interpolate(
      base: base(at: t0, elapsedSeconds: 86399.5, speed: 370),
      now: t0.add(const Duration(seconds: 1)),
    );
    expect(snapshot.elapsedSeconds, closeTo(86400.5, 1e-9));
    expect(snapshot.fullDays, 1);
  });

  test('does not go negative if the clock jumps backwards', () {
    final t0 = DateTime.utc(2024, 1, 1, 12);
    final snapshot = interpolator.interpolate(
      base: base(at: t0, elapsedSeconds: 10, speed: 370),
      now: t0.subtract(const Duration(seconds: 30)),
    );
    expect(snapshot.elapsedSeconds, 0);
    expect(snapshot.distanceKm, 0);
    expect(snapshot.fullDays, 0);
  });

  test('keeps the average CMB speed on the interpolated snapshot', () {
    final t0 = DateTime.utc(2024, 6, 1);
    final snapshot = interpolator.interpolate(
      base: base(at: t0),
      now: t0.add(const Duration(seconds: 1)),
    );
    expect(
      snapshot.speedKmPerSecond,
      ScienceConstants.averageCmbSpeedKmPerSecond,
    );
  });
}
