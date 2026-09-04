/// Physical constants and source notes for the MVP average-speed model.
///
/// Keep every CMB-relative speed assumption here so the calculator and UI
/// never hard-code a magic number.
abstract final class ScienceConstants {
  /// Average Solar-System speed relative to the CMB rest frame, in km/s.
  ///
  /// Planck 2018 CMB dipole corresponds to about 369.82 km/s, commonly
  /// rounded to 370 km/s. This is the single configurable constant used by
  /// [AverageCmbJourneyCalculator].
  static const double averageCmbSpeedKmPerSecond = 370.0;

  static const String modelVersion = 'average-cmb-v1';

  static const String referenceFrameName =
      'CMB rest frame (average Solar-System barycentre speed)';

  static const String sourceNotes =
      'Uses a constant average speed of 370 km/s, approximating the '
      'observed CMB dipole velocity of the Solar System '
      '(Planck 2018: 369.82 ± 0.11 km/s). '
      'Earth orbital motion (~30 km/s) is not modelled in this mode. '
      'The result is an estimated path length, not a position.';

  static const int secondsPerDay = 86400;

  static const int earliestSupportedBirthYear = 1900;
}
