import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_dependencies.dart';
import 'app/cosmic_journey_app.dart';
import 'app/locale_controller.dart';
import 'app/readout_mode_controller.dart';
import 'app/theme_controller.dart';
import 'app/time_coordinates_controller.dart';
import 'core/clock.dart';
import 'services/audio/audioplayers_ambient_audio_controller.dart';
import 'services/journey_calculator/average_cmb_journey_calculator.dart';
import 'services/local_storage/audio_preference_store.dart';
import 'services/local_storage/locale_store.dart';
import 'services/local_storage/milestone_preference_store.dart';
import 'services/local_storage/profile_store.dart';
import 'services/local_storage/readout_mode_store.dart';
import 'services/local_storage/theme_preference_store.dart';
import 'services/local_storage/time_coordinates_preference_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final localeStore = SharedPreferencesLocaleStore(prefs);
  final localeController = LocaleController(
    store: localeStore,
    storedCode: await localeStore.loadLanguageCode(),
    deviceLocale: WidgetsBinding.instance.platformDispatcher.locale,
  );
  final audioStore = SharedPreferencesAudioPreferenceStore(prefs);
  final themeStore = SharedPreferencesThemePreferenceStore(prefs);
  final readoutStore = SharedPreferencesReadoutModeStore(prefs);
  final timeCoordinatesStore = SharedPreferencesTimeCoordinatesPreferenceStore(
    prefs,
  );
  runApp(
    CosmicJourneyApp(
      dependencies: AppDependencies(
        clock: const SystemClock(),
        calculator: const AverageCmbJourneyCalculator(),
        profileStore: SharedPreferencesProfileStore(prefs),
        localeController: localeController,
        ambientAudio: AudioplayersAmbientAudioController(
          store: audioStore,
          enabled: await audioStore.loadEnabled(),
          soundscapeId: await audioStore.loadSoundscapeId(),
          volume: await audioStore.loadVolume(),
        ),
        themeController: ThemeController(
          store: themeStore,
          storedId: await themeStore.loadPaletteId(),
        ),
        readoutModeController: ReadoutModeController(
          store: readoutStore,
          storedId: await readoutStore.loadModeId(),
        ),
        milestoneStore: SharedPreferencesMilestonePreferenceStore(prefs),
        timeCoordinatesController: TimeCoordinatesController(
          store: timeCoordinatesStore,
          storedEnabled: await timeCoordinatesStore.loadEnabled(),
        ),
      ),
    ),
  );
}
