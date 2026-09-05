import 'package:flutter/material.dart';

import '../core/theme/cosmic_palette.dart';
import '../services/local_storage/theme_preference_store.dart';

class ThemeController extends ChangeNotifier {
  ThemeController({required this.store, String? storedId})
    : palette = CosmicPaletteCatalog.resolve(storedId);

  final ThemePreferenceStore store;
  CosmicPalette palette;

  String get paletteId => palette.id;

  Future<void> setPalette(CosmicPalette next) async {
    if (next.id == palette.id) {
      return;
    }
    palette = next;
    notifyListeners();
    await store.savePaletteId(next.id);
  }
}
