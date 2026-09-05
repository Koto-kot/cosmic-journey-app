import 'package:cosmic_journey/app/cosmic_journey_app.dart';
import 'package:cosmic_journey/core/clock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_dependencies.dart';

void main() {
  testWidgets('language dropdown switches onboarding copy between ENG and UA', (
    tester,
  ) async {
    await tester.pumpWidget(
      CosmicJourneyApp(
        dependencies: testDependencies(
          clock: FakeClock(DateTime.utc(2026, 9, 4, 12)),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('When did your journey begin?'), findsOneWidget);
    expect(find.text('ENG'), findsOneWidget);

    await tester.tap(find.byTooltip('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('UA').last);
    await tester.pumpAndSettle();

    expect(find.text('Коли почалася твоя подорож?'), findsOneWidget);
    expect(find.text('Почати подорож'), findsOneWidget);
    expect(find.text('UA'), findsOneWidget);
  });
}
