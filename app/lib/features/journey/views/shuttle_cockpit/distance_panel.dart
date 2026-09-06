import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'cockpit_indicators.dart';
import 'cockpit_theme_tokens.dart';

/// The cockpit's main display: whole kilometres only, tabular figures, a
/// soft inner glow that briefly intensifies on each Cosmic Pulse tick (spec
/// sections 10 and 14).
class DistancePanel extends StatelessWidget {
  const DistancePanel({
    super.key,
    required this.valueText,
    required this.scaleText,
    required this.pulse,
    required this.glow,
    required this.reducedMotion,
  });

  final String valueText;
  final String scaleText;

  /// Whether the digits should soft fade/roll on change (Cosmic Pulse) —
  /// off in Continuous mode, which already refreshes too fast for that.
  final bool pulse;
  final double glow;
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
        boxShadow: [
          BoxShadow(
            color: CockpitTokens.cyan.withValues(alpha: 0.08 + glow * 0.14),
            blurRadius: 18 + glow * 10,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.shuttleDistanceLabel,
            style: const TextStyle(
              color: CockpitTokens.mutedTeal,
              fontSize: 12,
              letterSpacing: 2.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: pulse
                ? AnimatedSwitcher(
                    duration: reducedMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 320),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      if (reducedMotion) {
                        return child;
                      }
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: _DistanceNumber(
                      key: ValueKey(valueText),
                      valueText: valueText,
                    ),
                  )
                : _DistanceNumber(valueText: valueText),
          ),
          const SizedBox(height: 2),
          Text(
            'KM',
            style: const TextStyle(
              color: CockpitTokens.mutedTeal,
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            scaleText,
            style: const TextStyle(
              color: CockpitTokens.steelGray,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          const CockpitIndicators(),
        ],
      ),
    );
  }
}

class _DistanceNumber extends StatelessWidget {
  const _DistanceNumber({super.key, required this.valueText});

  final String valueText;

  @override
  Widget build(BuildContext context) {
    return Text(
      valueText,
      maxLines: 1,
      style: const TextStyle(
        color: CockpitTokens.coldWhite,
        fontSize: 44,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }
}
