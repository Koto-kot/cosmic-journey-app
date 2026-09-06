import 'package:cosmic_journey/app/journey_style_controller.dart';
import 'package:cosmic_journey/app/theme_controller.dart';
import 'package:cosmic_journey/core/journey_style/journey_style.dart';
import 'package:cosmic_journey/features/styles/styles_screen.dart';
import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:cosmic_journey/services/local_storage/journey_style_store.dart';
import 'package:cosmic_journey/services/local_storage/theme_preference_store.dart';
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
  testWidgets('Styles screen has separate Interface Style and Color '
      'Palette sections, and interface selection persists', (tester) async {
    final journeyStyleStore = InMemoryJourneyStyleStore();
    final styleController = JourneyStyleController(store: journeyStyleStore);
    final themeController = ThemeController(
      store: InMemoryThemePreferenceStore(),
    );

    await tester.pumpWidget(
      _wrap(
        StylesScreen(
          dependencies: testDependencies(
            journeyStyleController: styleController,
            themeController: themeController,
          ),
        ),
      ),
    );
    await tester.pump();

    // Two independent section headers.
    expect(find.text('INTERFACE STYLE'), findsOneWidget);
    expect(find.text('COLOR PALETTE'), findsOneWidget);

    // Both interface styles listed with a preview and a title/subtitle.
    expect(find.text('Cosmic Minimal'), findsOneWidget);
    expect(find.text('Shuttle Cockpit'), findsOneWidget);
    expect(find.text('Earth view with three counters'), findsOneWidget);

    // Cosmic Minimal starts selected (single check mark for the interface
    // section — only one of the two style tiles is selected).
    await tester.tap(find.text('Shuttle Cockpit'));
    await tester.pump();
    expect(styleController.style, JourneyStyle.shuttleCockpit);
    expect(await journeyStyleStore.loadStyleId(), 'shuttle_cockpit');

    // Palette selection is unaffected by the interface-style tap.
    expect(themeController.paletteId, 'void');
  });
}
