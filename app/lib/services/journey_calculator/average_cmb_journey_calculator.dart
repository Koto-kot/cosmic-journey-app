import '../../core/science_constants.dart';
import 'journey_calculator.dart';
import 'journey_profile.dart';
import 'journey_snapshot.dart';

/// MVP engine: elapsed seconds × a constant CMB-relative average speed.
class AverageCmbJourneyCalculator implements JourneyCalculator {
  const AverageCmbJourneyCalculator({
    this.speedKmPerSecond = ScienceConstants.averageCmbSpeedKmPerSecond,
  });

  final double speedKmPerSecond;

  @override
  JourneySnapshot calculate({
    required DateTime at,
    required JourneyProfile profile,
  }) {
    final now = at.toUtc();
    final birth = profile.canonicalBirthUtc.toUtc();
    final rawSeconds =
        now.difference(birth).inMicroseconds / Duration.microsecondsPerSecond;
    final elapsedSeconds = rawSeconds < 0 ? 0.0 : rawSeconds;
    final fullDays = elapsedSeconds ~/ ScienceConstants.secondsPerDay;
    return JourneySnapshot(
      elapsedSeconds: elapsedSeconds,
      fullDays: fullDays,
      distanceKm: elapsedSeconds * speedKmPerSecond,
      speedKmPerSecond: speedKmPerSecond,
      isApproximate: profile.isApproximate,
      calculatedAt: now,
    );
  }

  @override
  double currentSpeed({required DateTime at, required JourneyProfile profile}) {
    return speedKmPerSecond;
  }
}
