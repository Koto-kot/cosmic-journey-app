import 'package:cosmic_journey/app/journey_style_controller.dart';
import 'package:cosmic_journey/core/clock.dart';
import 'package:cosmic_journey/features/journey/journey_screen.dart';
import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:cosmic_journey/services/journey_calculator/journey_profile.dart';
import 'package:cosmic_journey/services/local_storage/journey_style_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_dependencies.dart';

Widget _wrap(Widget child, {bool disableAnimations = false}) {
  return MaterialApp(
    locale: const Locale('en'),
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

  Future<FakeClock> pumpShuttleCockpit(
    WidgetTester tester, {
    bool disableAnimations = false,
  }) async {
    final clock = FakeClock(DateTime.utc(2000, 1, 2, 3, 4, 5));
    await tester.pumpWidget(
      _wrap(
        JourneyScreen(
          dependencies: testDependencies(
            clock: clock,
            journeyStyleController: JourneyStyleController(
              store: InMemoryJourneyStyleStore('shuttle_cockpit'),
              storedId: 'shuttle_cockpit',
            ),
          ),
          profile: profile,
        ),
        disableAnimations: disableAnimations,
      ),
    );
    await tester.pump();
    return clock;
  }

  testWidgets('shows whole-number DISTANCE with no decimals', (tester) async {
    await pumpShuttleCockpit(tester);
    expect(find.text('DISTANCE'), findsOneWidget);
    // The big odometer is a grouped integer, never fractional km (the
    // "≈ X.Y million km" scale line below it legitimately has a decimal
    // point, same as Cosmic Minimal — that's not the odometer).
    expect(find.textContaining('.000'), findsNothing);
  });

  testWidgets('FLIGHT TIME breaks elapsed time into DAYS/HRS/MIN/SEC', (
    tester,
  ) async {
    // 1 day, 3h 4m 5s past the birth instant.
    await pumpShuttleCockpit(tester);
    expect(find.text('FLIGHT TIME'), findsOneWidget);
    expect(find.text('1'), findsOneWidget); // DAYS
    expect(find.text('03'), findsOneWidget); // HRS
    expect(find.text('04'), findsOneWidget); // MIN
    expect(find.text('05'), findsOneWidget); // SEC
  });

  testWidgets('seconds advance once a second under Cosmic Pulse', (
    tester,
  ) async {
    final clock = await pumpShuttleCockpit(tester);
    expect(find.text('05'), findsOneWidget);

    clock.advance(const Duration(seconds: 1));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 320));
    expect(find.text('06'), findsOneWidget);
    expect(find.text('05'), findsNothing);
  });

  testWidgets('renders without error under reduced motion', (tester) async {
    await pumpShuttleCockpit(tester, disableAnimations: true);
    expect(tester.takeException(), isNull);
    expect(find.text('DISTANCE'), findsOneWidget);
  });

  testWidgets('AUDIO/TIME/MODE controls are present on the cockpit panel', (
    tester,
  ) async {
    await pumpShuttleCockpit(tester);
    expect(find.byTooltip('Enable atmosphere'), findsOneWidget);
    expect(find.byTooltip('Show time coordinates'), findsOneWidget);
    expect(find.byTooltip('Switch to Continuous readout'), findsOneWidget);
  });
}
