import 'package:cosmic_journey/app/locale_controller.dart';
import 'package:cosmic_journey/app/readout_mode_controller.dart';
import 'package:cosmic_journey/app/time_coordinates_controller.dart';
import 'package:cosmic_journey/core/clock.dart';
import 'package:cosmic_journey/core/science_constants.dart';
import 'package:cosmic_journey/features/journey/journey_screen.dart';
import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:cosmic_journey/services/audio/ambient_audio_controller.dart';
import 'package:cosmic_journey/services/journey_calculator/journey_profile.dart';
import 'package:cosmic_journey/services/local_storage/locale_store.dart';
import 'package:cosmic_journey/services/local_storage/readout_mode_store.dart';
import 'package:cosmic_journey/services/local_storage/time_coordinates_preference_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_dependencies.dart';

void main() {
  late FakeClock clock;
  late JourneyProfile profile;
  late SilentAmbientAudioController audio;

  setUp(() {
    clock = FakeClock(DateTime.utc(2000, 1, 2));
    profile = JourneyProfile(
      birthYear: 2000,
      canonicalBirthUtc: DateTime.utc(2000, 1, 1),
      isApproximate: true,
      createdAt: DateTime.utc(2000, 1, 1),
      updatedAt: DateTime.utc(2000, 1, 1),
    );
    audio = SilentAmbientAudioController();
  });

  testWidgets('main screen renders integer distance, days, seconds and scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        JourneyScreen(
          dependencies: testDependencies(clock: clock, ambientAudio: audio),
          profile: profile,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('km'), findsOneWidget);
    expect(find.text('days'), findsOneWidget);
    expect(find.text('seconds'), findsOneWidget);
    expect(find.byTooltip('Menu'), findsOneWidget);
    expect(find.byTooltip('Enable atmosphere'), findsOneWidget);
    expect(find.byTooltip('Switch to Continuous readout'), findsOneWidget);

    const distance =
        86400 * ScienceConstants.averageCmbSpeedKmPerSecond; // 31,968,000
    expect(find.text('31\u202F968\u202F000'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('86\u202F400'), findsOneWidget);
    expect(find.text('≈ 32.0 million km'), findsOneWidget);
    expect(find.text('≈ 86.4 thousand'), findsOneWidget);
    expect(find.text('31\u202F968\u202F000.000'), findsNothing);
    expect(find.text('86\u202F400.000'), findsNothing);
    expect(distance, 31968000);
  });

  testWidgets('distance and seconds pulse together after a whole second', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        JourneyScreen(
          dependencies: testDependencies(clock: clock, ambientAudio: audio),
          profile: profile,
        ),
      ),
    );
    await tester.pump();
    expect(find.text('86\u202F400'), findsOneWidget);

    clock.advance(const Duration(milliseconds: 400));
    await tester.pump();
    expect(find.text('86\u202F400'), findsOneWidget);
    expect(find.text('31\u202F968\u202F000'), findsOneWidget);

    clock.advance(const Duration(milliseconds: 1600));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('86\u202F402'), findsOneWidget);
    expect(find.text('31\u202F968\u202F740'), findsOneWidget);
  });

  testWidgets('background pause freezes numbers until resume', (tester) async {
    await tester.pumpWidget(
      _wrap(
        JourneyScreen(
          dependencies: testDependencies(clock: clock, ambientAudio: audio),
          profile: profile,
        ),
      ),
    );
    await tester.pump();

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    clock.advance(const Duration(seconds: 8));
    await tester.pump();
    expect(find.text('86\u202F400'), findsOneWidget);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('86\u202F408'), findsOneWidget);
  });

  testWidgets('atmosphere toggle persists through the controller', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        JourneyScreen(
          dependencies: testDependencies(clock: clock, ambientAudio: audio),
          profile: profile,
        ),
      ),
    );
    await tester.pump();
    expect(audio.enabled, isFalse);

    await tester.tap(find.byTooltip('Enable atmosphere'));
    await tester.pump();
    expect(audio.enabled, isTrue);
    expect(find.byTooltip('Mute atmosphere'), findsOneWidget);
  });

  testWidgets('Ukrainian scale words appear under the live numbers', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        JourneyScreen(
          dependencies: testDependencies(
            clock: clock,
            ambientAudio: audio,
            localeController: LocaleController(
              store: InMemoryLocaleStore('uk'),
              storedCode: 'uk',
            ),
          ),
          profile: profile,
        ),
        locale: const Locale('uk'),
      ),
    );
    await tester.pump();
    expect(find.text('≈ 32,0 млн km'), findsOneWidget);
    expect(find.text('≈ 86,4 тис.'), findsOneWidget);
  });

  testWidgets('reduced motion still pulses once per second without glow', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        JourneyScreen(
          dependencies: testDependencies(clock: clock, ambientAudio: audio),
          profile: profile,
        ),
        disableAnimations: true,
      ),
    );
    await tester.pump();
    clock.advance(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('86\u202F401'), findsOneWidget);
  });

  testWidgets(
    'Continuous readout shows whole numbers only, refreshing faster than Pulse',
    (tester) async {
      final readout = ReadoutModeController(
        store: InMemoryReadoutModeStore('flow'),
        storedId: 'flow',
      );
      await tester.pumpWidget(
        _wrap(
          JourneyScreen(
            dependencies: testDependencies(
              clock: clock,
              ambientAudio: audio,
              readoutModeController: readout,
            ),
            profile: profile,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('86\u202F400'), findsOneWidget);
      expect(find.text('31\u202F968\u202F000'), findsOneWidget);
      expect(find.text('86\u202F400.000'), findsNothing);
      expect(find.text('31\u202F968\u202F000.000'), findsNothing);

      // Crosses the ~10Hz continuous cadence (100ms) but not a full second:
      // the whole-seconds counter stays put while distance still moves.
      clock.advance(const Duration(milliseconds: 100));
      await tester.pump();
      expect(find.text('86\u202F400'), findsOneWidget);
      expect(find.text('31\u202F968\u202F037'), findsOneWidget);
      expect(find.byTooltip('Switch to Cosmic Pulse readout'), findsOneWidget);
    },
  );

  testWidgets('time coordinates are hidden by default and shown when enabled', (
    tester,
  ) async {
    final coordinates = TimeCoordinatesController(
      store: InMemoryTimeCoordinatesPreferenceStore(),
    );
    await tester.pumpWidget(
      _wrap(
        JourneyScreen(
          dependencies: testDependencies(
            clock: clock,
            ambientAudio: audio,
            timeCoordinatesController: coordinates,
          ),
          profile: profile,
        ),
      ),
    );
    await tester.pump();
    expect(find.text('START'), findsNothing);
    expect(find.text('NOW'), findsNothing);

    await coordinates.setEnabled(true);
    await tester.pump();
    expect(find.text('START'), findsOneWidget);
    expect(find.text('NOW'), findsOneWidget);
    expect(find.text('2000 · approximate'), findsOneWidget);
  });
}

Widget _wrap(
  Widget child, {
  Locale locale = const Locale('en'),
  bool disableAnimations = false,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, nested) {
      final media = MediaQuery.of(context);
      return MediaQuery(
        data: media.copyWith(disableAnimations: disableAnimations),
        child: nested ?? const SizedBox.shrink(),
      );
    },
    home: child,
  );
}
