import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/app_dependencies.dart';
import '../../core/formatters/journey_number_formatter.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/ad_slot.dart';
import '../../core/widgets/cosmic_backdrop.dart';
import '../../core/widgets/pro_badge.dart';
import '../../services/journey_calculator/journey_profile.dart';
import '../../services/journey_calculator/journey_snapshot.dart';
import '../../services/milestones/milestone_estimator.dart';
import '../atmosphere/atmosphere_screen.dart';
import '../journey/live_journey_controller.dart';
import '../milestones/milestones_screen.dart';
import '../pro/pro_screen.dart';
import '../science/science_screen.dart';
import '../settings/settings_screen.dart';
import '../share/share_screen.dart';
import '../statistics/statistics_screen.dart';
import '../styles/styles_screen.dart';
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
          icon: Icons.flag,
          label: l10n.milestonesItem,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => MilestonesScreen(
                  dependencies: dependencies,
                  snapshot: snapshot,
                  formatter: formatter,
                ),
              ),
            );
          },
        ),
        _MenuRow(
          icon: Icons.insights_outlined,
          label: l10n.statisticsItem,
          leadingBadge: true,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => StatisticsScreen(
                  dependencies: dependencies,
                  snapshot: snapshot,
                  formatter: formatter,
                  isApproximate: profile.isApproximate,
                ),
              ),
            );
          },
        ),
        _MenuRow(
          icon: Icons.ios_share,
          label: l10n.shareItem,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    ShareScreen(snapshot: snapshot, formatter: formatter),
              ),
            );
          },
        ),
        _MenuRow(
          icon: Icons.grid_view_rounded,
          label: l10n.widgetsItem,
          leadingBadge: true,
          onTap: () =>
              _openSoon(context, l10n.widgetsItem, l10n.widgetsStillSoon),
        ),
        _MenuRow(
          icon: Icons.auto_awesome,
          label: l10n.stylesItem,
          leadingBadge: true,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => StylesScreen(dependencies: dependencies),
              ),
            );
          },
        ),
        _MenuRow(
          icon: Icons.nights_stay_outlined,
          label: l10n.atmosphereItem,
          leadingBadge: true,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => AtmosphereScreen(dependencies: dependencies),
              ),
            );
          },
        ),
        _MenuRow(
          icon: Icons.help_outline,
          label: l10n.scienceItem,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ScienceScreen(dependencies: dependencies),
              ),
            );
          },
        ),
        _MenuRow(
          leading: const ProBadge(),
          label: l10n.proItem,
          subtitle: l10n.proSubtitle,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ProScreen(dependencies: dependencies),
              ),
            );
          },
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
        AdSlot(entitlement: dependencies.entitlement, placement: 'menu'),
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
                  style: TextStyle(
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
                    style: TextStyle(
                      color: CosmicTokens.onBackground,
                      fontSize: 13,
                      fontFeatures: const [FontFeature.tabularFigures()],
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
    this.leadingBadge = false,
  });

  final IconData? icon;
  final Widget? leading;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final bool leadingBadge;

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
                          style: TextStyle(
                            color: CosmicTokens.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (leadingBadge) ...[
                  const ProBadge(compact: true),
                  const SizedBox(width: 8),
                ],
                Icon(Icons.chevron_right, color: CosmicTokens.muted, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
