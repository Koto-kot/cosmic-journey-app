import 'package:flutter/foundation.dart';

import '../core/journey_style/journey_style.dart';
import '../services/local_storage/journey_style_store.dart';

/// Which main-screen interface style is active (Cosmic Minimal or Shuttle
/// Cockpit). Independent of [ThemeController]'s color palette — see ADR 0010.
class JourneyStyleController extends ChangeNotifier {
  JourneyStyleController({required this.store, String? storedId})
    : style = JourneyStyleCodec.resolve(storedId);

  final JourneyStyleStore store;
  JourneyStyle style;

  Future<void> setStyle(JourneyStyle next) async {
    if (next == style) {
      return;
    }
    style = next;
    notifyListeners();
    await store.saveStyleId(next.id);
  }
}
