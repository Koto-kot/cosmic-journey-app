import 'package:cosmic_journey/app/app_dependencies.dart';
import 'package:cosmic_journey/core/clock.dart';
import 'package:cosmic_journey/core/science_constants.dart';
import 'package:cosmic_journey/features/journey/journey_screen.dart';
import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:cosmic_journey/services/journey_calculator/average_cmb_journey_calculator.dart';
import 'package:cosmic_journey/services/journey_calculator/journey_profile.dart';
import 'package:cosmic_journey/services/local_storage/profile_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeClock clock;
  late JourneyProfile profile;
  late AppDependencies dependencies;

  setUp(() {
    clock = FakeClock(DateTime.utc(2000, 1, 2));
    profile = JourneyProfile(
      birthYear: 2000,
      canonicalBirthUtc: DateTime.utc(2000, 1, 1),
      isApproximate: true,
      createdAt: DateTime.utc(2000, 1, 1),
      updatedAt: DateTime.utc(2000, 1, 1),
    );
    dependencies = AppDependencies(
      clock: clock,
      calculator: const AverageCmbJourneyCalculator(),
      profileStore: InMemoryProfileStore(profile),
    );
  });

  testWidgets('main screen renders distance, days and seconds', (tester) async {
    await tester.pumpWidget(
      _wrap(JourneyScreen(dependencies: dependencies, profile: profile)),
    );
    await tester.pump();

    expect(find.text('km'), findsOneWidget);
    expect(find.text('days'), findsOneWidget);
    expect(find.text('seconds'), findsOneWidget);
    expect(find.byTooltip('Menu'), findsOneWidget);

    const distance =
        86400 * ScienceConstants.averageCmbSpeedKmPerSecond; // 31,968,000
    expect(find.text('31\u202F968\u202F000.000'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('86\u202F400.000'), findsOneWidget);
    expect(distance, 31968000);
  });

  testWidgets('fake time changes the live values after a frame', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(JourneyScreen(dependencies: dependencies, profile: profile)),
    );
    await tester.pump();
    expect(find.text('86\u202F400.000'), findsOneWidget);

    clock.advance(const Duration(seconds: 2));
    await tester.pump();
    expect(find.text('86\u202F402.000'), findsOneWidget);
    expect(find.text('31\u202F968\u202F740.000'), findsOneWidget);
  });

  testWidgets('background pause freezes numbers until resume', (tester) async {
    await tester.pumpWidget(
      _wrap(JourneyScreen(dependencies: dependencies, profile: profile)),
    );
    await tester.pump();

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    clock.advance(const Duration(seconds: 8));
    await tester.pump();
    expect(find.text('86\u202F400.000'), findsOneWidget);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(find.text('86\u202F408.000'), findsOneWidget);
  });
}

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: child,
  );
}
