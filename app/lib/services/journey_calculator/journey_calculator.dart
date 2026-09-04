import 'journey_profile.dart';
import 'journey_snapshot.dart';

/// Replaceable calculation engine. UI depends on this, not on formulas.
abstract class JourneyCalculator {
  const JourneyCalculator();

  JourneySnapshot calculate({
    required DateTime at,
    required JourneyProfile profile,
  });

  double currentSpeed({required DateTime at, required JourneyProfile profile});
}
