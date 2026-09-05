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

  /// Whole seconds for the Cosmic Pulse readout (never fractional).
  int get wholeElapsedSeconds {
    if (!elapsedSeconds.isFinite) {
      return 0;
    }
    final floored = elapsedSeconds.floor();
    return floored < 0 ? 0 : floored;
  }

  /// Integer kilometres for the Cosmic Pulse readout.
  int get wholeDistanceKm {
    if (!distanceKm.isFinite) {
      return 0;
    }
    return distanceKm.round();
  }
}
