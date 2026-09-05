import 'package:cosmic_journey/app/app_dependencies.dart';
import 'package:cosmic_journey/app/locale_controller.dart';
import 'package:cosmic_journey/app/readout_mode_controller.dart';
import 'package:cosmic_journey/app/theme_controller.dart';
import 'package:cosmic_journey/app/time_coordinates_controller.dart';
import 'package:cosmic_journey/core/clock.dart';
import 'package:cosmic_journey/core/entitlement/entitlement.dart';
import 'package:cosmic_journey/services/audio/ambient_audio_controller.dart';
import 'package:cosmic_journey/services/journey_calculator/average_cmb_journey_calculator.dart';
import 'package:cosmic_journey/services/local_storage/locale_store.dart';
import 'package:cosmic_journey/services/local_storage/milestone_preference_store.dart';
import 'package:cosmic_journey/services/local_storage/profile_store.dart';
import 'package:cosmic_journey/services/local_storage/readout_mode_store.dart';
import 'package:cosmic_journey/services/local_storage/theme_preference_store.dart';
import 'package:cosmic_journey/services/local_storage/time_coordinates_preference_store.dart';

AppDependencies testDependencies({
  Clock? clock,
  ProfileStore? profileStore,
  LocaleController? localeController,
  AmbientAudioController? ambientAudio,
  ThemeController? themeController,
  ReadoutModeController? readoutModeController,
  Entitlement? entitlement,
  MilestonePreferenceStore? milestoneStore,
  TimeCoordinatesController? timeCoordinatesController,
}) {
  return AppDependencies(
    clock: clock ?? FakeClock(DateTime.utc(2000, 1, 2)),
    calculator: const AverageCmbJourneyCalculator(),
    profileStore: profileStore ?? InMemoryProfileStore(),
    localeController:
        localeController ?? LocaleController(store: InMemoryLocaleStore()),
    ambientAudio: ambientAudio ?? SilentAmbientAudioController(),
    themeController:
        themeController ??
        ThemeController(store: InMemoryThemePreferenceStore()),
    readoutModeController:
        readoutModeController ??
        ReadoutModeController(store: InMemoryReadoutModeStore()),
    entitlement: entitlement ?? Entitlement.testing,
    milestoneStore: milestoneStore ?? InMemoryMilestonePreferenceStore(),
    timeCoordinatesController:
        timeCoordinatesController ??
        TimeCoordinatesController(
          store: InMemoryTimeCoordinatesPreferenceStore(),
        ),
  );
}
