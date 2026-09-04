import '../../core/science_constants.dart';

/// Next round-number distance threshold derived from the current journey.
class NextMilestone {
  const NextMilestone({
    required this.thresholdKm,
    required this.remainingKm,
    required this.remaining,
  });

  final double thresholdKm;
  final double remainingKm;
  final Duration remaining;
}

abstract final class MilestoneEstimator {
  /// Next whole billion kilometres, matching the live-screen milestone card.
  static const double stepKm = 1000000000;

  static NextMilestone next({
    required double distanceKm,
    required double speedKmPerSecond,
  }) {
    final speed = speedKmPerSecond <= 0
        ? ScienceConstants.averageCmbSpeedKmPerSecond
        : speedKmPerSecond;
    var threshold = (distanceKm / stepKm).ceil() * stepKm;
    if (threshold <= distanceKm) {
      threshold += stepKm;
    }
    final remainingKm = threshold - distanceKm;
    final seconds = remainingKm / speed;
    final microseconds = (seconds * 1e6).round().clamp(0, 1 << 62);
    return NextMilestone(
      thresholdKm: threshold,
      remainingKm: remainingKm,
      remaining: Duration(microseconds: microseconds),
    );
  }
}
