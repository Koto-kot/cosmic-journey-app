import 'package:flutter/foundation.dart';

/// Feature flags for Cosmic Pro and ads.
///
/// Phase 2 testing uses [testing]: Pro is on, ads stay off. Screens read
/// these booleans instead of talking to a store. Phase 3 maps a yearly
/// subscription receipt onto [isPro] and sets [adsAllowed] to `!isPro`.
@immutable
class Entitlement {
  const Entitlement({required this.isPro, required this.adsAllowed});

  /// Everyone is Cosmic Pro. No ad network.
  static const testing = Entitlement(isPro: true, adsAllowed: false);

  final bool isPro;
  final bool adsAllowed;

  bool soundscapeUnlocked(String id) => isPro || id == 'deep_space';

  bool themeUnlocked(String id) => isPro || id == 'void';

  bool get widgetsUnlocked => isPro;

  bool get customMilestonesUnlocked => isPro;

  bool get premiumShareUnlocked => isPro;

  bool get statisticsUnlocked => isPro;
}
