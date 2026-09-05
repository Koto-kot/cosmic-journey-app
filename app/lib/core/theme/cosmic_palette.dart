import 'package:flutter/material.dart';

/// One full-screen look. Layout stays the same across palettes.
class CosmicPalette {
  const CosmicPalette({
    required this.id,
    required this.background,
    required this.nebula,
    required this.surface,
    required this.card,
    required this.onBackground,
    required this.muted,
    required this.accent,
    required this.hairline,
    required this.cardStroke,
  });

  final String id;
  final Color background;
  final Color nebula;
  final Color surface;
  final Color card;
  final Color onBackground;
  final Color muted;
  final Color accent;
  final Color hairline;
  final Color cardStroke;
}

abstract final class CosmicPaletteCatalog {
  static const voidId = 'void';
  static const oledId = 'oled';
  static const midnightId = 'midnight';
  static const auroraId = 'aurora';

  /// Current live-screen black with a faint navy nebula.
  static const voidBlack = CosmicPalette(
    id: voidId,
    background: Color(0xFF000000),
    nebula: Color(0xFF07101C),
    surface: Color(0xFF0A0A0F),
    card: Color(0xFF0B0B10),
    onBackground: Color(0xFFFFFFFF),
    muted: Color(0xFFA0A0A0),
    accent: Color(0xFF4FACFE),
    hairline: Color(0x22FFFFFF),
    cardStroke: Color(0x1AFFFFFF),
  );

  /// True black, no nebula wash.
  static const oled = CosmicPalette(
    id: oledId,
    background: Color(0xFF000000),
    nebula: Color(0xFF000000),
    surface: Color(0xFF000000),
    card: Color(0xFF050508),
    onBackground: Color(0xFFFFFFFF),
    muted: Color(0xFF8E8E8E),
    accent: Color(0xFF4FACFE),
    hairline: Color(0x18FFFFFF),
    cardStroke: Color(0x14FFFFFF),
  );

  static const midnight = CosmicPalette(
    id: midnightId,
    background: Color(0xFF030712),
    nebula: Color(0xFF0A1630),
    surface: Color(0xFF0B1220),
    card: Color(0xFF101A2C),
    onBackground: Color(0xFFF4F7FF),
    muted: Color(0xFF9AA8C2),
    accent: Color(0xFF8BB8FF),
    hairline: Color(0x22B8D4FF),
    cardStroke: Color(0x1AB8D4FF),
  );

  static const aurora = CosmicPalette(
    id: auroraId,
    background: Color(0xFF020805),
    nebula: Color(0xFF042018),
    surface: Color(0xFF07140F),
    card: Color(0xFF0C1C16),
    onBackground: Color(0xFFF3FFF8),
    muted: Color(0xFF97B5A8),
    accent: Color(0xFF5CFFC8),
    hairline: Color(0x225CFFC8),
    cardStroke: Color(0x1A5CFFC8),
  );

  static const List<CosmicPalette> all = [voidBlack, oled, midnight, aurora];

  static const List<String> proIds = [oledId, midnightId, auroraId];

  static CosmicPalette resolve(String? id) {
    for (final palette in all) {
      if (palette.id == id) {
        return palette;
      }
    }
    return voidBlack;
  }

  static bool isFree(String id) => id == voidId;
}
