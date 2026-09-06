import 'package:flutter/material.dart';

/// Shuttle Cockpit's own visual identity: near-black graphite/navy, cyan/
/// cold-blue accents (spec section 27). Deliberately fixed rather than
/// driven by [CosmicPalette] — the cockpit is a distinct interface style,
/// not another color palette, and a warm palette like Aurora would clash
/// with "premium, calm, restrained sci-fi" (spec section 26).
abstract final class CockpitTokens {
  static const Color deepSpace = Color(0xFF04070C);
  static const Color panelBackground = Color(0xFF0B1118);
  static const Color panelBorder = Color(0xFF223041);
  static const Color windowFrame = Color(0xFF1A222C);
  static const Color coldWhite = Color(0xFFE7EEF5);
  static const Color cyan = Color(0xFF5FD8E0);
  static const Color mutedTeal = Color(0xFF7C93A0);
  static const Color steelGray = Color(0xFF4C5A68);
}
