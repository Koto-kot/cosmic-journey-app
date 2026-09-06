import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'cockpit_theme_tokens.dart';

/// Small static status readouts — "NAV LOCK", "CMB REF". Purely decorative
/// framing, never red in normal state (spec section 15). Capped at a
/// handful so it never competes with the two main displays.
class CockpitIndicators extends StatelessWidget {
  const CockpitIndicators({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 18,
      runSpacing: 6,
      children: [
        _Indicator(label: l10n.shuttleNavLockLabel),
        _Indicator(label: l10n.shuttleCmbRefLabel),
      ],
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.circle, size: 6, color: CockpitTokens.cyan),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: CockpitTokens.mutedTeal,
            fontSize: 10,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
