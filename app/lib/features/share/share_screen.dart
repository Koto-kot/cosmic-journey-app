import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/formatters/journey_number_formatter.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/earth_hero.dart';
import '../../core/widgets/secondary_scaffold.dart';
import '../../services/journey_calculator/journey_snapshot.dart';
import '../../services/share/journey_share_text.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({
    super.key,
    required this.snapshot,
    required this.formatter,
  });

  final JourneySnapshot snapshot;
  final JourneyNumberFormatter formatter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = JourneyShareText.plain(
      snapshot: snapshot,
      formatter: formatter,
      appTitle: l10n.appTitle,
      kmLabel: l10n.kmLabel,
      daysLabel: l10n.daysLabel,
      secondsLabel: l10n.secondsLabel,
    );
    return SecondaryScaffold(
      title: l10n.shareTitle,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: [
          Text(
            l10n.shareIntro,
            style: TextStyle(color: CosmicTokens.muted, height: 1.4),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            decoration: BoxDecoration(
              color: CosmicTokens.card,
              borderRadius: BorderRadius.circular(CosmicTokens.cardRadius),
              border: Border.all(color: CosmicTokens.cardStroke),
            ),
            child: Column(
              children: [
                const EarthHero(size: 88),
                const SizedBox(height: 16),
                Text(
                  l10n.appTitle.toUpperCase(),
                  style: TextStyle(
                    color: CosmicTokens.accent,
                    letterSpacing: 2.2,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  formatter.formatFullNumber(snapshot.wholeDistanceKm),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                Text(l10n.kmLabel, style: TextStyle(color: CosmicTokens.muted)),
                const SizedBox(height: 8),
                Text(
                  l10n.humanScaleKm(
                    formatter.formatHumanScale(snapshot.wholeDistanceKm),
                  ),
                  style: TextStyle(color: CosmicTokens.muted),
                ),
                const SizedBox(height: 16),
                Text(
                  '${formatter.days(snapshot.fullDays)} ${l10n.daysLabel}',
                  style: const TextStyle(
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  '${formatter.formatFullNumber(snapshot.wholeElapsedSeconds)} ${l10n.secondsLabel}',
                  style: TextStyle(
                    color: CosmicTokens.muted,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: text));
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(l10n.shareCopied)));
              }
            },
            child: Text(l10n.copyJourney),
          ),
        ],
      ),
    );
  }
}
