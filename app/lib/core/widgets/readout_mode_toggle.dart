import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/readout_mode_controller.dart';
import '../readout/readout_mode.dart';
import '../theme_tokens.dart';

class ReadoutModeToggle extends StatelessWidget {
  const ReadoutModeToggle({super.key, required this.controller});

  final ReadoutModeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final pulse = controller.mode == ReadoutMode.pulse;
        return IconButton(
          tooltip: pulse ? l10n.readoutSwitchToFlow : l10n.readoutSwitchToPulse,
          onPressed: () {
            controller.setMode(pulse ? ReadoutMode.flow : ReadoutMode.pulse);
          },
          icon: Icon(
            pulse ? Icons.radio_button_checked : Icons.waves,
            size: 22,
            color: CosmicTokens.accent,
          ),
        );
      },
    );
  }
}
