import '../../core/clock.dart';
import '../../services/journey_calculator/journey_calculator.dart';
import '../../services/local_storage/profile_store.dart';

class AppDependencies {
  const AppDependencies({
    required this.clock,
    required this.calculator,
    required this.profileStore,
  });

  final Clock clock;
  final JourneyCalculator calculator;
  final ProfileStore profileStore;
}
