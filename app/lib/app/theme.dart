import 'package:flutter/material.dart';

import '../core/theme_tokens.dart';

ThemeData buildCosmicTheme() {
  final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: CosmicTokens.background,
    colorScheme: const ColorScheme.dark(
      surface: CosmicTokens.surface,
      onSurface: CosmicTokens.onBackground,
      primary: CosmicTokens.accent,
      onPrimary: CosmicTokens.background,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: CosmicTokens.onBackground,
      displayColor: CosmicTokens.onBackground,
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(CosmicTokens.onBackground),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: CosmicTokens.accent,
        foregroundColor: Colors.black,
        minimumSize: const Size.fromHeight(52),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    ),
  );
}
