import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/app_dependencies.dart';
import '../../core/formatters/journey_number_formatter.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/cosmic_backdrop.dart';
import '../../services/journey_calculator/journey_profile.dart';
import '../../services/journey_calculator/journey_snapshot.dart';
import '../../services/milestones/milestone_estimator.dart';
import '../journey/live_journey_controller.dart';
import '../science/science_screen.dart';
import '../settings/settings_screen.dart';
import 'coming_soon_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({
    super.key,
    required this.dependencies,
    required this.profile,
    required this.controller,
  });

  final AppDependencies dependencies;
  final JourneyProfile profile;
  final LiveJourneyController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final formatter = JourneyNumberFormatter.fromLocale(
      Localizations.localeOf(context),
    );
    return Scaffold(
      backgroundColor: CosmicTokens.background,
      body: CosmicBackdrop(
        child: SafeArea(
          child: ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              return _MenuBody(
                l10n: l10n,
                formatter: formatter,
                snapshot: controller.snapshot,
                dependencies: dependencies,
                profile: profile,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MenuBody extends StatelessWidget {
  const _MenuBody({
    required this.l10n,
    required this.formatter,
    required this.snapshot,
    required this.dependencies,
    required this.profile,
  });

  final AppLocalizations l10n;
  final JourneyNumberFormatter formatter;
  final JourneySnapshot snapshot;
  final AppDependencies dependencies;
  final JourneyProfile profile;

  @override
  Widget build(BuildContext context) {
    final milestone = MilestoneEstimator.next(
      distanceKm: snapshot.distanceKm,
      speedKmPerSecond: snapshot.speedKmPerSecond,
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            tooltip: l10n.close,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, size: 20),
          ),
        ),
        Text(
          l10n.menuTitle,
          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 22),
        _InfoCard(
          icon: Icons.flag_outlined,
          kicker: l10n.nextMilestone,
          title:
              '${formatter.distanceKm(milestone.thresholdKm, fractionDigits: 0)} km',
          subtitle: l10n.milestoneCountdown(
            milestone.remaining.inDays.toString(),
            formatter.clockHms(milestone.remaining),
          ),
        ),
        const SizedBox(height: 12),
        _InfoCard(
          icon: Icons.speed,
          kicker: l10n.currentSpeed,
          title:
              '${formatter.speedKmPerSecond(snapshot.speedKmPerSecond)} km/s',
        ),
        const SizedBox(height: 18),
        _MenuRow(
          icon: Icons.grid_view_rounded,
          label: l10n.widgetsItem,
          onTap: () => _openSoon(context, l10n.widgetsItem, l10n.widgetsSoon),
        ),
        _MenuRow(
          icon: Icons.auto_awesome,
          label: l10n.stylesItem,
          onTap: () => _openSoon(context, l10n.stylesItem, l10n.stylesSoon),
        ),
        _MenuRow(
          icon: Icons.help_outline,
          label: l10n.scienceItem,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ScienceScreen()),
            );
          },
        ),
        _MenuRow(
          leading: const _ProBadge(),
          label: l10n.proItem,
          subtitle: l10n.proSubtitle,
          onTap: () => _openSoon(context, l10n.proItem, l10n.proSoon),
        ),
        _MenuRow(
          icon: Icons.settings_outlined,
          label: l10n.settingsTitle,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => SettingsScreen(
                  dependencies: dependencies,
                  profile: profile,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _openSoon(BuildContext context, String title, String body) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ComingSoonScreen(title: title, body: body),
      ),
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: CosmicTokens.accent.withValues(alpha: 0.7)),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          color: CosmicTokens.accent,
          fontSize: 7,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.kicker,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final String kicker;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: CosmicTokens.card,
        borderRadius: BorderRadius.circular(CosmicTokens.cardRadius),
        border: Border.all(color: CosmicTokens.cardStroke),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: CosmicTokens.hairline),
            ),
            child: Icon(icon, color: CosmicTokens.muted, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kicker,
                  style: const TextStyle(
                    color: CosmicTokens.muted,
                    fontSize: 11,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: CosmicTokens.onBackground,
                      fontSize: 13,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.label,
    required this.onTap,
    this.icon,
    this.leading,
    this.subtitle,
  });

  final IconData? icon;
  final Widget? leading;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: CosmicTokens.cardStroke),
            ),
            child: Row(
              children: [
                leading ?? Icon(icon, color: CosmicTokens.muted, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          letterSpacing: 1.4,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            color: CosmicTokens.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: CosmicTokens.muted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
