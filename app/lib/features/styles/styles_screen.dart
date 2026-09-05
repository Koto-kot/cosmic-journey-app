import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/app_dependencies.dart';
import '../../core/theme/cosmic_palette.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/pro_badge.dart';
import '../../core/widgets/secondary_scaffold.dart';

class StylesScreen extends StatelessWidget {
  const StylesScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: dependencies.themeController,
      builder: (context, _) {
        final selected = dependencies.themeController.paletteId;
        return SecondaryScaffold(
          title: l10n.stylesTitle,
          entitlement: dependencies.entitlement,
          adPlacement: 'styles',
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            children: [
              for (final palette in CosmicPaletteCatalog.all) ...[
                _StyleTile(
                  palette: palette,
                  title: _title(l10n, palette.id),
                  subtitle: _subtitle(l10n, palette.id),
                  selected: selected == palette.id,
                  pro: !CosmicPaletteCatalog.isFree(palette.id),
                  onTap: () {
                    if (!dependencies.entitlement.themeUnlocked(palette.id)) {
                      return;
                    }
                    dependencies.themeController.setPalette(palette);
                  },
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        );
      },
    );
  }

  String _title(AppLocalizations l10n, String id) {
    return switch (id) {
      CosmicPaletteCatalog.oledId => l10n.styleOled,
      CosmicPaletteCatalog.midnightId => l10n.styleMidnight,
      CosmicPaletteCatalog.auroraId => l10n.styleAurora,
      _ => l10n.styleVoid,
    };
  }

  String _subtitle(AppLocalizations l10n, String id) {
    return switch (id) {
      CosmicPaletteCatalog.oledId => l10n.styleOledSubtitle,
      CosmicPaletteCatalog.midnightId => l10n.styleMidnightSubtitle,
      CosmicPaletteCatalog.auroraId => l10n.styleAuroraSubtitle,
      _ => l10n.styleVoidSubtitle,
    };
  }
}

class _StyleTile extends StatelessWidget {
  const _StyleTile({
    required this.palette,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.pro,
    required this.onTap,
  });

  final CosmicPalette palette;
  final String title;
  final String subtitle;
  final bool selected;
  final bool pro;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? palette.accent : CosmicTokens.cardStroke,
            ),
            color: CosmicTokens.card,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.background,
                  border: Border.all(color: palette.accent, width: 3),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: CosmicTokens.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (pro) const ProBadge(compact: true),
              if (selected) ...[
                const SizedBox(width: 8),
                Icon(Icons.check, color: CosmicTokens.accent, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
