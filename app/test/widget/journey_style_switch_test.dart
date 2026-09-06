import 'package:cosmic_journey/app/journey_style_controller.dart';
import 'package:cosmic_journey/core/journey_style/journey_style.dart';
import 'package:cosmic_journey/core/clock.dart';
import 'package:cosmic_journey/core/science_constants.dart';
import 'package:cosmic_journey/features/journey/journey_screen.dart';
import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:cosmic_journey/services/journey_calculator/journey_profile.dart';
import 'package:cosmic_journey/services/local_storage/journey_style_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_dependencies.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}

void main() {
  late JourneyProfile profile;

  setUp(() {
    profile = JourneyProfile(
      birthYear: 2000,
      canonicalBirthUtc: DateTime.utc(2000, 1, 1),
      isApproximate: true,
      createdAt: DateTime.utc(2000, 1, 1),
      updatedAt: DateTime.utc(2000, 1, 1),
    );
  });

  testWidgets(
    'switching interface style keeps the same journey state running (no reset)',
    (tester) async {
      final clock = FakeClock(DateTime.utc(2000, 1, 2));
      final styleController = JourneyStyleController(
        store: InMemoryJourneyStyleStore(),
      );
      await tester.pumpWidget(
        _wrap(
          JourneyScreen(
            dependencies: testDependencies(
              clock: clock,
              journeyStyleController: styleController,
            ),
            profile: profile,
          ),
        ),
      );
      await tester.pump();

      const distance =
          86400 * ScienceConstants.averageCmbSpeedKmPerSecond; // 31,968,000
      expect(distance, 31968000);
      expect(find.text('31 968 000'), findsOneWidget);
      expect(find.text('86 400'), findsOneWidget);

      // Switch to Shuttle Cockpit: same distance/seconds must reappear,
      // formatted for the cockpit's DISTANCE/FLIGHT TIME panels — not reset
      // to zero and not recalculated from a new controller.
      await styleController.setStyle(JourneyStyle.shuttleCockpit);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 320));
      expect(find.text('DISTANCE'), findsOneWidget);
      expect(find.text('31 968 000'), findsOneWidget);
      expect(find.text('1'), findsOneWidget); // DAYS
      expect(find.text('00'), findsWidgets); // HRS/MIN/SEC

      // Advance the clock while in Shuttle Cockpit, then switch back: the
      // controller must have kept ticking, not paused/reset on switch.
      clock.advance(const Duration(seconds: 5));
      await tester.pump();
      await styleController.setStyle(JourneyStyle.cosmicMinimal);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 320));
      expect(find.text('86 405'), findsOneWidget);
    },
  );

  testWidgets('TIME and MODE controls share state across both styles', (
    tester,
  ) async {
    final styleController = JourneyStyleController(
      store: InMemoryJourneyStyleStore(),
    );
    await tester.pumpWidget(
      _wrap(
        JourneyScreen(
          dependencies: testDependencies(
            journeyStyleController: styleController,
          ),
          profile: profile,
        ),
      ),
    );
    await tester.pump();

    // Enable TIME in Cosmic Minimal.
    await tester.tap(find.byTooltip('Show time coordinates'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 260));
    expect(find.text('START'), findsOneWidget);

    // Switch to Shuttle Cockpit: TIME must already read as ON (shared
    // TimeCoordinatesController), not reset to OFF.
    await styleController.setStyle(JourneyStyle.shuttleCockpit);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 320));
    expect(find.byTooltip('Hide time coordinates'), findsOneWidget);
    expect(find.text('START'), findsOneWidget);

    // Switch MODE from the cockpit's inline control (inside a
    // SingleChildScrollView, so scroll it into view first).
    final modeButton = find.byTooltip('Switch to Continuous readout');
    await tester.ensureVisible(modeButton);
    await tester.pump();
    await tester.tap(modeButton);
    await tester.pump();

    await styleController.setStyle(JourneyStyle.cosmicMinimal);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 320));
    expect(find.byTooltip('Switch to Cosmic Pulse readout'), findsOneWidget);
  });
}
