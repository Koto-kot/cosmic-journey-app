import '../../core/science_constants.dart';

class MilestoneProgress {
  const MilestoneProgress({
    required this.thresholdKm,
    required this.reached,
    required this.remainingKm,
    required this.remaining,
    this.custom = false,
  });

  final double thresholdKm;
  final bool reached;
  final double remainingKm;
  final Duration remaining;
  final bool custom;
}

/// Basic 10M / 100M / 1B checkpoints, plus an optional custom interval.
abstract final class MilestoneCatalog {
  static const presetsKm = <double>[10000000, 100000000, 1000000000];

  static const int minimumCustomIntervalKm = 1000000;

  static List<MilestoneProgress> evaluate({
    required double distanceKm,
    required double speedKmPerSecond,
    int? customIntervalKm,
  }) {
    final items = [
      for (final threshold in presetsKm)
        progress(
          thresholdKm: threshold,
          distanceKm: distanceKm,
          speedKmPerSecond: speedKmPerSecond,
        ),
    ];
    if (customIntervalKm != null &&
        customIntervalKm >= minimumCustomIntervalKm) {
      var next = (distanceKm / customIntervalKm).ceil() * customIntervalKm;
      if (next <= distanceKm) {
        next += customIntervalKm;
      }
      items.add(
        progress(
          thresholdKm: next.toDouble(),
          distanceKm: distanceKm,
          speedKmPerSecond: speedKmPerSecond,
          custom: true,
        ),
      );
    }
    return items;
  }

  static MilestoneProgress progress({
    required double thresholdKm,
    required double distanceKm,
    required double speedKmPerSecond,
    bool custom = false,
  }) {
    if (distanceKm >= thresholdKm) {
      return MilestoneProgress(
        thresholdKm: thresholdKm,
        reached: true,
        remainingKm: 0,
        remaining: Duration.zero,
        custom: custom,
      );
    }
    final remainingKm = thresholdKm - distanceKm;
    final speed = speedKmPerSecond <= 0
        ? ScienceConstants.averageCmbSpeedKmPerSecond
        : speedKmPerSecond;
    final seconds = remainingKm / speed;
    final microseconds = (seconds * 1e6).round().clamp(0, 1 << 62);
    return MilestoneProgress(
      thresholdKm: thresholdKm,
      reached: false,
      remainingKm: remainingKm,
      remaining: Duration(microseconds: microseconds),
      custom: custom,
    );
  }
}
