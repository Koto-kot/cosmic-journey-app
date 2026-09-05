import 'package:cosmic_journey/core/widgets/earth_fallback.dart';
import 'package:cosmic_journey/core/widgets/earth_hero.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EarthHero paints a fallback globe on VM tests', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: EarthHero(size: 120))),
      ),
    );
    await tester.pump();

    expect(find.byType(EarthHero), findsOneWidget);
    expect(find.byType(EarthFallbackGlobe), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('reduced motion does not keep the fallback spinning', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          );
        },
        home: const Scaffold(body: Center(child: EarthHero(size: 120))),
      ),
    );
    await tester.pump();
    final globe = tester.widget<EarthFallbackGlobe>(
      find.byType(EarthFallbackGlobe),
    );
    expect(globe.reducedMotion, isTrue);
  });
}
