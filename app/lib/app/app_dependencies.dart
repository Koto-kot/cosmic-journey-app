import '../core/clock.dart';
import '../core/entitlement/entitlement.dart';
import '../services/audio/ambient_audio_controller.dart';
import '../services/journey_calculator/journey_calculator.dart';
import '../services/local_storage/journey_style_store.dart';
import '../services/local_storage/milestone_preference_store.dart';
import '../services/local_storage/profile_store.dart';
import '../services/local_storage/time_coordinates_preference_store.dart';
import 'journey_style_controller.dart';
import 'locale_controller.dart';
import 'readout_mode_controller.dart';
import 'theme_controller.dart';
import 'time_coordinates_controller.dart';

class AppDependencies {
  AppDependencies({
    required this.clock,
    required this.calculator,
    required this.profileStore,
    required this.localeController,
    required this.ambientAudio,
    required this.themeController,
    required this.readoutModeController,
    this.entitlement = Entitlement.testing,
    this.milestoneStore = const _DefaultMilestoneStore(),
    TimeCoordinatesController? timeCoordinatesController,
    JourneyStyleController? journeyStyleController,
  }) : timeCoordinatesController =
           timeCoordinatesController ??
           TimeCoordinatesController(
             store: InMemoryTimeCoordinatesPreferenceStore(),
           ),
       journeyStyleController =
           journeyStyleController ??
           JourneyStyleController(store: InMemoryJourneyStyleStore());

  final Clock clock;
  final JourneyCalculator calculator;
  final ProfileStore profileStore;
  final LocaleController localeController;
  final AmbientAudioController ambientAudio;
  final ThemeController themeController;
  final ReadoutModeController readoutModeController;
  final Entitlement entitlement;
  final MilestonePreferenceStore milestoneStore;
  final TimeCoordinatesController timeCoordinatesController;
  final JourneyStyleController journeyStyleController;
}

class _DefaultMilestoneStore implements MilestonePreferenceStore {
  const _DefaultMilestoneStore();

  @override
  Future<int?> loadCustomIntervalKm() async => null;

  @override
  Future<void> saveCustomIntervalKm(int? km) async {}
}
