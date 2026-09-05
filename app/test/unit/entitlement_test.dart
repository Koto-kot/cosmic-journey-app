import 'package:cosmic_journey/core/entitlement/entitlement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('testing entitlement is Pro with ads off', () {
    const entitlement = Entitlement.testing;
    expect(entitlement.isPro, isTrue);
    expect(entitlement.adsAllowed, isFalse);
    expect(entitlement.soundscapeUnlocked('deep_space'), isTrue);
    expect(entitlement.soundscapeUnlocked('aurora'), isTrue);
    expect(entitlement.themeUnlocked('void'), isTrue);
    expect(entitlement.customMilestonesUnlocked, isTrue);
  });

  test('free entitlement keeps Deep Space and Void unlocked', () {
    const entitlement = Entitlement(isPro: false, adsAllowed: true);
    expect(entitlement.soundscapeUnlocked('deep_space'), isTrue);
    expect(entitlement.soundscapeUnlocked('aurora'), isFalse);
    expect(entitlement.themeUnlocked('void'), isTrue);
    expect(entitlement.themeUnlocked('oled'), isFalse);
    expect(entitlement.adsAllowed, isTrue);
  });
}
