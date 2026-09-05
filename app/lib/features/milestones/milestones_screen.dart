import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/app_dependencies.dart';
import '../../core/formatters/journey_number_formatter.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/secondary_scaffold.dart';
import '../../services/journey_calculator/journey_snapshot.dart';
import '../../services/milestones/milestone_catalog.dart';

class MilestonesScreen extends StatefulWidget {
  const MilestonesScreen({
    super.key,
    required this.dependencies,
    required this.snapshot,
    required this.formatter,
  });

  final AppDependencies dependencies;
  final JourneySnapshot snapshot;
  final JourneyNumberFormatter formatter;

  @override
  State<MilestonesScreen> createState() => _MilestonesScreenState();
}

class _MilestonesScreenState extends State<MilestonesScreen> {
  final _interval = TextEditingController();
  int? _customKm;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final stored = await widget.dependencies.milestoneStore
        .loadCustomIntervalKm();
    if (!mounted) {
      return;
    }
    setState(() {
      _customKm = stored;
      if (stored != null) {
        _interval.text = stored.toString();
      }
      _loaded = true;
    });
  }

  @override
  void dispose() {
    _interval.dispose();
    super.dispose();
  }

  Future<void> _saveInterval() async {
    final parsed = int.tryParse(_interval.text.replaceAll(' ', ''));
    final km =
        parsed != null && parsed >= MilestoneCatalog.minimumCustomIntervalKm
        ? parsed
        : null;
    await widget.dependencies.milestoneStore.saveCustomIntervalKm(km);
    if (!mounted) {
      return;
    }
    setState(() => _customKm = km);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = MilestoneCatalog.evaluate(
      distanceKm: widget.snapshot.distanceKm,
      speedKmPerSecond: widget.snapshot.speedKmPerSecond,
      customIntervalKm: widget.dependencies.entitlement.customMilestonesUnlocked
          ? _customKm
          : null,
    );
    return SecondaryScaffold(
      title: l10n.milestonesTitle,
      entitlement: widget.dependencies.entitlement,
      adPlacement: 'milestones',
      child: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              children: [
                for (final item in items) ...[
                  _MilestoneTile(
                    item: item,
                    formatter: widget.formatter,
                    l10n: l10n,
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 12),
                Text(
                  l10n.customIntervalLabel,
                  style: TextStyle(
                    color: CosmicTokens.muted,
                    letterSpacing: 1.4,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(l10n.customIntervalHint, style: _hintStyle),
                const SizedBox(height: 10),
                TextField(
                  controller: _interval,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: CosmicTokens.card,
                    hintText: '10000000',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _saveInterval,
                  child: Text(l10n.saveCustomInterval),
                ),
              ],
            ),
    );
  }

  TextStyle get _hintStyle =>
      TextStyle(color: CosmicTokens.muted, fontSize: 13, height: 1.4);
}

class _MilestoneTile extends StatelessWidget {
  const _MilestoneTile({
    required this.item,
    required this.formatter,
    required this.l10n,
  });

  final MilestoneProgress item;
  final JourneyNumberFormatter formatter;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final title =
        '${formatter.distanceKm(item.thresholdKm, fractionDigits: 0)} km';
    final subtitle = item.reached
        ? l10n.milestoneReached
        : l10n.milestoneRemaining(
            item.remaining.inDays.toString(),
            formatter.clockHms(item.remaining),
          );
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: CosmicTokens.card,
        borderRadius: BorderRadius.circular(CosmicTokens.cardRadius),
        border: Border.all(color: CosmicTokens.cardStroke),
      ),
      child: Row(
        children: [
          Icon(
            item.reached ? Icons.check_circle_outline : Icons.flag_outlined,
            color: item.reached ? CosmicTokens.accent : CosmicTokens.muted,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.custom)
                  Text(
                    l10n.milestoneCustom,
                    style: TextStyle(
                      color: CosmicTokens.accent,
                      fontSize: 11,
                      letterSpacing: 1.4,
                    ),
                  ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: CosmicTokens.muted, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
