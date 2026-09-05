import 'package:cosmic_journey/features/journey/journey_screen.dart';
import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:cosmic_journey/services/journey_calculator/journey_profile.dart';
import 'package:cosmic_journey/services/local_storage/profile_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_dependencies.dart';

void main() {
  testWidgets('menu shows next milestone, speed and navigation rows', (
    tester,
  ) async {
    final profile = JourneyProfile(
      birthYear: 2000,
      canonicalBirthUtc: DateTime.utc(2000, 1, 1),
      isApproximate: true,
      createdAt: DateTime.utc(2000, 1, 1),
      updatedAt: DateTime.utc(2000, 1, 1),
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: JourneyScreen(
          dependencies: testDependencies(
            profileStore: InMemoryProfileStore(profile),
          ),
          profile: profile,
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byTooltip('Menu'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Menu'), findsWidgets);
    expect(find.text('NEXT MILESTONE'), findsOneWidget);
    expect(find.text('CURRENT SPEED'), findsOneWidget);
    expect(find.text('WIDGETS'), findsOneWidget);
    expect(find.text('STYLES'), findsOneWidget);
    expect(find.text('MILESTONES'), findsOneWidget);
    expect(find.text('STATISTICS'), findsOneWidget);
    expect(find.text('SHARE'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('ATMOSPHERE'), 300);
    expect(find.text('ATMOSPHERE'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('CALCULATION EXPLANATION'), 300);
    expect(find.text('CALCULATION EXPLANATION'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('COSMIC PRO'), 300);
    expect(find.text('COSMIC PRO'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('SETTINGS'), 300);
    expect(find.text('SETTINGS'), findsOneWidget);
  });
}
