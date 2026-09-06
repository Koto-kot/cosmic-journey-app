import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/app_dependencies.dart';
import '../../core/journey_style/journey_style.dart';
import '../../core/theme/cosmic_palette.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/pro_badge.dart';
import '../../core/widgets/secondary_scaffold.dart';
import '../journey/views/shuttle_cockpit/cockpit_theme_tokens.dart';

/// Two independent sections: which interface style renders the main
/// screen, and which color palette tints it. Never the same list — see
/// ADR 0010.
class StylesScreen extends StatelessWidget {
  const StylesScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([
        dependencies.journeyStyleController,
        dependencies.themeController,
      ]),
      builder: (context, _) {
        final selectedStyle = dependencies.journeyStyleController.style;
        final selectedPalette = dependencies.themeController.paletteId;
        return SecondaryScaffold(
          title: l10n.stylesTitle,
          entitlement: dependencies.entitlement,
          adPlacement: 'styles',
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            children: [
              Text(
                l10n.interfaceStyleSectionLabel,
                style: TextStyle(
                  color: CosmicTokens.muted,
                  letterSpacing: 1.4,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _InterfaceStyleTile(
                style: JourneyStyle.cosmicMinimal,
                title: l10n.interfaceCosmicMinimalTitle,
                subtitle: l10n.interfaceCosmicMinimalSubtitle,
                selected: selectedStyle == JourneyStyle.cosmicMinimal,
                preview: const _CosmicMinimalPreview(),
                onTap: () => dependencies.journeyStyleController.setStyle(
                  JourneyStyle.cosmicMinimal,
                ),
              ),
              const SizedBox(height: 10),
              _InterfaceStyleTile(
                style: JourneyStyle.shuttleCockpit,
                title: l10n.interfaceShuttleCockpitTitle,
                subtitle: l10n.interfaceShuttleCockpitSubtitle,
                selected: selectedStyle == JourneyStyle.shuttleCockpit,
                preview: const _ShuttleCockpitPreview(),
                onTap: () => dependencies.journeyStyleController.setStyle(
                  JourneyStyle.shuttleCockpit,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                l10n.colorPaletteSectionLabel,
                style: TextStyle(
                  color: CosmicTokens.muted,
                  letterSpacing: 1.4,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              for (final palette in CosmicPaletteCatalog.all) ...[
                _PaletteTile(
                  palette: palette,
                  title: _paletteTitle(l10n, palette.id),
                  subtitle: _paletteSubtitle(l10n, palette.id),
                  selected: selectedPalette == palette.id,
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

  String _paletteTitle(AppLocalizations l10n, String id) {
    return switch (id) {
      CosmicPaletteCatalog.oledId => l10n.styleOled,
      CosmicPaletteCatalog.midnightId => l10n.styleMidnight,
      CosmicPaletteCatalog.auroraId => l10n.styleAurora,
      _ => l10n.styleVoid,
    };
  }

  String _paletteSubtitle(AppLocalizations l10n, String id) {
    return switch (id) {
      CosmicPaletteCatalog.oledId => l10n.styleOledSubtitle,
      CosmicPaletteCatalog.midnightId => l10n.styleMidnightSubtitle,
      CosmicPaletteCatalog.auroraId => l10n.styleAuroraSubtitle,
      _ => l10n.styleVoidSubtitle,
    };
  }
}

class _InterfaceStyleTile extends StatelessWidget {
  const _InterfaceStyleTile({
    required this.style,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.preview,
    required this.onTap,
  });

  final JourneyStyle style;
  final String title;
  final String subtitle;
  final bool selected;
  final Widget preview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? CosmicTokens.accent : CosmicTokens.cardStroke,
            ),
            color: CosmicTokens.card,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(width: 64, height: 64, child: preview),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        letterSpacing: 1.1,
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
              if (selected)
                Icon(Icons.check, color: CosmicTokens.accent, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tiny static stand-in for the real Cosmic Minimal screen: a globe dot and
/// three counter bars.
class _CosmicMinimalPreview extends StatelessWidget {
  const _CosmicMinimalPreview();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CosmicTokens.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CosmicTokens.accent.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.5),
              child: Container(
                width: 30 - i * 6,
                height: 3,
                color: CosmicTokens.onBackground.withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }
}

/// Tiny static stand-in for the real Shuttle Cockpit screen: a window frame
/// over two panel bars.
class _ShuttleCockpitPreview extends StatelessWidget {
  const _ShuttleCockpitPreview();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: CockpitTokens.deepSpace,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: CockpitTokens.cyan, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              height: 8,
              decoration: BoxDecoration(
                color: CockpitTokens.panelBackground,
                border: Border.all(color: CockpitTokens.panelBorder),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: double.infinity,
              height: 8,
              decoration: BoxDecoration(
                color: CockpitTokens.panelBackground,
                border: Border.all(color: CockpitTokens.panelBorder),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaletteTile extends StatelessWidget {
  const _PaletteTile({
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
