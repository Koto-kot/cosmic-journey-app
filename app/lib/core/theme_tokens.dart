import 'package:flutter/material.dart';

import 'theme/cosmic_palette.dart';

/// Shared visual tokens. Free and Pro themes keep the same layout.
///
/// Colours come from the active [CosmicPalette]. Apply a palette from
/// [ThemeController] before rebuilding the tree.
abstract final class CosmicTokens {
  static CosmicPalette _palette = CosmicPaletteCatalog.voidBlack;

  static CosmicPalette get palette => _palette;

  static void apply(CosmicPalette next) {
    _palette = next;
  }

  static Color get background => _palette.background;
  static Color get nebula => _palette.nebula;
  static Color get surface => _palette.surface;
  static Color get card => _palette.card;
  static Color get onBackground => _palette.onBackground;
  static Color get muted => _palette.muted;
  static Color get accent => _palette.accent;
  static Color get hairline => _palette.hairline;
  static Color get cardStroke => _palette.cardStroke;

  static const double pagePadding = 24;
  static const double numberGap = 28;
  static const double cardRadius = 18;
}
