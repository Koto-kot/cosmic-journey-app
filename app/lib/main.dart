import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_dependencies.dart';
import 'app/cosmic_journey_app.dart';
import 'core/clock.dart';
import 'services/journey_calculator/average_cmb_journey_calculator.dart';
import 'services/local_storage/profile_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    CosmicJourneyApp(
      dependencies: AppDependencies(
        clock: const SystemClock(),
        calculator: const AverageCmbJourneyCalculator(),
        profileStore: SharedPreferencesProfileStore(prefs),
      ),
    ),
  );
}
