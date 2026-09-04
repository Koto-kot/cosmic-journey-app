import 'package:flutter/foundation.dart';

/// Authoritative calculation result at a single instant.
@immutable
class JourneySnapshot {
  const JourneySnapshot({
    required this.elapsedSeconds,
    required this.fullDays,
    required this.distanceKm,
    required this.speedKmPerSecond,
    required this.isApproximate,
    required this.calculatedAt,
  });

  final double elapsedSeconds;
  final int fullDays;
  final double distanceKm;
  final double speedKmPerSecond;
  final bool isApproximate;
  final DateTime calculatedAt;
}
