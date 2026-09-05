import 'package:cosmic_journey/features/journey/journey_screen.dart';
import 'package:cosmic_journey/features/journey/journey_start_screen.dart';
import 'package:cosmic_journey/features/pro/pro_screen.dart';
import 'package:cosmic_journey/features/settings/settings_screen.dart';
import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:cosmic_journey/services/journey_calculator/journey_profile.dart';
import 'package:cosmic_journey/services/local_storage/profile_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_dependencies.dart';

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

  testWidgets('Journey Start offers optional month, day and time', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: JourneyStartScreen(
          dependencies: testDependencies(),
          profile: profile,
        ),
      ),
    );
    expect(find.textContaining('1 July'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Month (optional)'), 200);
    expect(find.text('Month (optional)'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Day (optional)'), 200);
    expect(find.text('Day (optional)'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Time (optional)'), 200);
    expect(find.text('Time (optional)'), findsOneWidget);
    expect(find.text('Save birth details'), findsOneWidget);
  });

  testWidgets(
    'Settings offers counter motion and time-coordinates toggle, no birth fields',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsScreen(
            dependencies: testDependencies(),
            profile: profile,
          ),
        ),
      );
      expect(find.text('Cosmic Pulse'), findsOneWidget);
      expect(find.text('Continuous'), findsOneWidget);
      expect(find.text('Show time coordinates'), findsOneWidget);
      expect(find.text('Month (optional)'), findsNothing);
      expect(find.text('Save birth details'), findsNothing);
    },
  );

  testWidgets('Cosmic Pro screen says the purchase is already unlocked', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ProScreen(dependencies: testDependencies()),
      ),
    );
    expect(find.text('You have Cosmic Pro'), findsOneWidget);
    expect(find.text('Restore Purchases'), findsOneWidget);
    expect(find.textContaining('yearly subscription'), findsOneWidget);
  });

  testWidgets('menu opens Cosmic Pro instead of a placeholder', (tester) async {
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
    await tester.scrollUntilVisible(find.text('COSMIC PRO'), 200);
    await tester.tap(find.text('COSMIC PRO'));
    await tester.pumpAndSettle();
    expect(find.text('You have Cosmic Pro'), findsOneWidget);
  });
}
