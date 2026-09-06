import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'cockpit_theme_tokens.dart';

/// Second cockpit display: DAYS / HRS / MIN / SEC, all whole numbers.
/// Seconds tick once a second under Cosmic Pulse (spec section 11 — a
/// minutes column was added per direct product feedback on top of the
/// written spec's base DAYS/HRS/SEC format).
class FlightTimePanel extends StatelessWidget {
  const FlightTimePanel({
    super.key,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.pulse,
    required this.reducedMotion,
  });

  final String days;
  final String hours;
  final String minutes;
  final String seconds;
  final bool pulse;
  final bool reducedMotion;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: CockpitTokens.panelBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CockpitTokens.panelBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.shuttleFlightTimeLabel,
            style: const TextStyle(
              color: CockpitTokens.mutedTeal,
              fontSize: 12,
              letterSpacing: 2.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _FlightField(
                  value: days,
                  label: l10n.daysLabel.toUpperCase(),
                ),
              ),
              Expanded(
                child: _FlightField(
                  value: hours,
                  label: l10n.hoursLabel.toUpperCase(),
                ),
              ),
              Expanded(
                child: _FlightField(
                  value: minutes,
                  label: l10n.minutesLabel.toUpperCase(),
                ),
              ),
              Expanded(
                child: _FlightField(
                  value: seconds,
                  label: l10n.secondsLabel.toUpperCase(),
                  pulse: pulse,
                  reducedMotion: reducedMotion,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlightField extends StatelessWidget {
  const _FlightField({
    required this.value,
    required this.label,
    this.pulse = false,
    this.reducedMotion = false,
  });

  final String value;
  final String label;
  final bool pulse;
  final bool reducedMotion;

  @override
  Widget build(BuildContext context) {
    final number = FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        value,
        maxLines: 1,
        style: const TextStyle(
          color: CockpitTokens.coldWhite,
          fontSize: 26,
          fontWeight: FontWeight.w500,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
    return Column(
      children: [
        pulse
            ? AnimatedSwitcher(
                duration: reducedMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  if (reducedMotion) {
                    return child;
                  }
                  return FadeTransition(opacity: animation, child: child);
                },
                child: KeyedSubtree(key: ValueKey(value), child: number),
              )
            : number,
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: CockpitTokens.mutedTeal,
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
