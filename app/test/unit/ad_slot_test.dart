import 'package:cosmic_journey/core/entitlement/entitlement.dart';
import 'package:cosmic_journey/core/widgets/ad_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AdSlot is empty while ads are not allowed', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Column(
          children: [
            AdSlot(entitlement: Entitlement.testing, placement: 'menu'),
          ],
        ),
      ),
    );
    expect(tester.getSize(find.byType(AdSlot)).height, 0);
  });

  testWidgets('AdSlot stays empty even when ads are allowed', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Column(
          children: [
            AdSlot(
              entitlement: Entitlement(isPro: false, adsAllowed: true),
              placement: 'science',
            ),
          ],
        ),
      ),
    );
    expect(tester.getSize(find.byType(AdSlot)).height, 0);
  });
}
