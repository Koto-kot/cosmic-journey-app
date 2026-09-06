import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/time_coordinates_controller.dart';
import '../theme_tokens.dart';

/// Compact icon-only toggle for the main Journey screen, mirroring
/// [AtmosphereToggle]/[ReadoutModeToggle]. Shares the same
/// [TimeCoordinatesController] as the Settings toggle, so either control
/// flips the same persisted state.
class TimeCoordinatesToggle extends StatelessWidget {
  const TimeCoordinatesToggle({super.key, required this.controller});

  final TimeCoordinatesController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final enabled = controller.enabled;
        return IconButton(
          tooltip: enabled
              ? l10n.hideTimeCoordinatesTooltip
              : l10n.showTimeCoordinatesTooltip,
          onPressed: () => controller.setEnabled(!enabled),
          icon: Icon(
            enabled ? Icons.schedule : Icons.schedule_outlined,
            size: 22,
            color: enabled ? CosmicTokens.accent : CosmicTokens.muted,
          ),
        );
      },
    );
  }
}
