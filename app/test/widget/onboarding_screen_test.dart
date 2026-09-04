import 'package:cosmic_journey/app/app_dependencies.dart';
import 'package:cosmic_journey/app/cosmic_journey_app.dart';
import 'package:cosmic_journey/core/clock.dart';
import 'package:cosmic_journey/services/journey_calculator/average_cmb_journey_calculator.dart';
import 'package:cosmic_journey/services/local_storage/profile_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('first launch asks for a birth year and then shows the journey', (
    tester,
  ) async {
    final clock = FakeClock(DateTime.utc(2026, 9, 4, 12));
    await tester.pumpWidget(
      CosmicJourneyApp(
        localeOverride: const Locale('en'),
        dependencies: AppDependencies(
          clock: clock,
          calculator: const AverageCmbJourneyCalculator(),
          profileStore: InMemoryProfileStore(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('When did your journey begin?'), findsOneWidget);
    expect(find.text('Your birth year stays on this device.'), findsOneWidget);

    await tester.tap(find.text('Begin journey'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.text('km'), findsOneWidget);
    expect(find.text('days'), findsOneWidget);
    expect(find.text('seconds'), findsOneWidget);
    expect(find.byTooltip('Menu'), findsOneWidget);
  });

  testWidgets('Ukrainian copy is used when the locale is uk', (tester) async {
    await tester.pumpWidget(
      CosmicJourneyApp(
        localeOverride: const Locale('uk'),
        dependencies: AppDependencies(
          clock: FakeClock(DateTime.utc(2026, 9, 4)),
          calculator: const AverageCmbJourneyCalculator(),
          profileStore: InMemoryProfileStore(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.text('Коли почалася твоя подорож?'), findsOneWidget);
    expect(find.text('Почати подорож'), findsOneWidget);
  });
}
