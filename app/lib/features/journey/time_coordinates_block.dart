import 'dart:async';
import 'dart:ui';

import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../core/clock.dart';
import '../../core/formatters/journey_date_formatter.dart';
import '../../core/theme_tokens.dart';
import '../../services/journey_calculator/journey_profile.dart';
import 'journey_start_precision.dart';

/// Optional, visually secondary start/now date-time layer. Ticks on its own
/// 1Hz timer, independent of the readout mode's cadence, so it never
/// competes with (or is throttled/sped up by) the three main counters.
class TimeCoordinatesBlock extends StatefulWidget {
  const TimeCoordinatesBlock({
    super.key,
    required this.clock,
    required this.profile,
  });

  final Clock clock;
  final JourneyProfile profile;

  @override
  State<TimeCoordinatesBlock> createState() => _TimeCoordinatesBlockState();
}

class _TimeCoordinatesBlockState extends State<TimeCoordinatesBlock> {
  Timer? _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = widget.clock.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() => _now = widget.clock.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final startLabel = JourneyStartPrecision.subtitle(
      widget.profile,
      l10n,
      locale,
    );
    final nowLabel = JourneyDateFormatter.dateTimeWithSeconds(_now, locale);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 28,
        runSpacing: 4,
        children: [
          _Coordinate(kicker: l10n.journeyStartCoordLabel, value: startLabel),
          _Coordinate(kicker: l10n.nowCoordLabel, value: nowLabel),
        ],
      ),
    );
  }
}

class _Coordinate extends StatelessWidget {
  const _Coordinate({required this.kicker, required this.value});

  final String kicker;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.62,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            kicker,
            style: TextStyle(
              color: CosmicTokens.muted,
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: CosmicTokens.muted,
              fontSize: 12,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
