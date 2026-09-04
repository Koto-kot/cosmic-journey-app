import '../../core/science_constants.dart';
import 'journey_snapshot.dart';

/// Cheap presentation-layer interpolation between authoritative snapshots.
///
/// `displayDistance = baseDistance + speed * elapsedSinceBase`
class LiveJourneyInterpolator {
  const LiveJourneyInterpolator();

  JourneySnapshot interpolate({
    required JourneySnapshot base,
    required DateTime now,
  }) {
    final extraSeconds =
        now.toUtc().difference(base.calculatedAt.toUtc()).inMicroseconds /
        Duration.microsecondsPerSecond;
    final elapsed = base.elapsedSeconds + extraSeconds;
    final clamped = elapsed < 0 ? 0.0 : elapsed;
    return JourneySnapshot(
      elapsedSeconds: clamped,
      fullDays: clamped ~/ ScienceConstants.secondsPerDay,
      distanceKm: clamped * base.speedKmPerSecond,
      speedKmPerSecond: base.speedKmPerSecond,
      isApproximate: base.isApproximate,
      calculatedAt: now.toUtc(),
    );
  }
}
