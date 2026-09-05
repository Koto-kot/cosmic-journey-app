import '../../core/science_constants.dart';
import '../journey_calculator/journey_snapshot.dart';
import '../milestones/milestone_estimator.dart';

class JourneyStatistics {
  const JourneyStatistics({
    required this.kmPerDay,
    required this.kmPerYear,
    required this.nextBillion,
  });

  final double kmPerDay;
  final double kmPerYear;
  final NextMilestone nextBillion;

  static const secondsPerYear = 365.25 * 86400;

  factory JourneyStatistics.fromSnapshot(JourneySnapshot snapshot) {
    final elapsed = snapshot.elapsedSeconds <= 0
        ? 1.0
        : snapshot.elapsedSeconds;
    return JourneyStatistics(
      kmPerDay: snapshot.distanceKm / (elapsed / 86400),
      kmPerYear: snapshot.distanceKm / (elapsed / secondsPerYear),
      nextBillion: MilestoneEstimator.next(
        distanceKm: snapshot.distanceKm,
        speedKmPerSecond: snapshot.speedKmPerSecond <= 0
            ? ScienceConstants.averageCmbSpeedKmPerSecond
            : snapshot.speedKmPerSecond,
      ),
    );
  }
}
