import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../services/audio/ambient_audio_controller.dart';
import '../theme_tokens.dart';

class AtmosphereToggle extends StatelessWidget {
  const AtmosphereToggle({super.key, required this.controller});

  final AmbientAudioController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final enabled = controller.enabled;
        return IconButton(
          tooltip: enabled ? l10n.muteAtmosphere : l10n.enableAtmosphere,
          onPressed: () => controller.setEnabled(!enabled),
          icon: Icon(
            enabled ? Icons.graphic_eq : Icons.graphic_eq_outlined,
            size: 22,
            color: enabled ? CosmicTokens.accent : CosmicTokens.muted,
          ),
        );
      },
    );
  }
}
