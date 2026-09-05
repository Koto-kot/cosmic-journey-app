import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/app_dependencies.dart';
import '../../core/formatters/journey_number_formatter.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/secondary_scaffold.dart';
import '../../services/journey_calculator/journey_snapshot.dart';
import '../../services/statistics/journey_statistics.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({
    super.key,
    required this.dependencies,
    required this.snapshot,
    required this.formatter,
    required this.isApproximate,
  });

  final AppDependencies dependencies;
  final JourneySnapshot snapshot;
  final JourneyNumberFormatter formatter;
  final bool isApproximate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stats = JourneyStatistics.fromSnapshot(snapshot);
    return SecondaryScaffold(
      title: l10n.statisticsTitle,
      entitlement: dependencies.entitlement,
      adPlacement: 'statistics',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: [
          _StatCard(
            kicker: l10n.statKmPerDay,
            value: '${formatter.formatFullNumber(stats.kmPerDay.round())} km',
          ),
          const SizedBox(height: 10),
          _StatCard(
            kicker: l10n.statKmPerYear,
            value: '${formatter.formatFullNumber(stats.kmPerYear.round())} km',
          ),
          const SizedBox(height: 10),
          _StatCard(
            kicker: l10n.statNextBillion,
            value: l10n.milestoneCountdown(
              stats.nextBillion.remaining.inDays.toString(),
              formatter.clockHms(stats.nextBillion.remaining),
            ),
          ),
          const SizedBox(height: 10),
          _StatCard(
            kicker: l10n.statPrecision,
            value: isApproximate ? l10n.statApproximate : l10n.statExact,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.kicker, required this.value});

  final String kicker;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: CosmicTokens.card,
        borderRadius: BorderRadius.circular(CosmicTokens.cardRadius),
        border: Border.all(color: CosmicTokens.cardStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            kicker,
            style: TextStyle(
              color: CosmicTokens.muted,
              fontSize: 11,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
