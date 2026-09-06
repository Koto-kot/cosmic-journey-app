import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../app/readout_mode_controller.dart';
import '../../../../app/time_coordinates_controller.dart';
import '../../../../core/widgets/atmosphere_toggle.dart';
import '../../../../core/widgets/readout_mode_toggle.dart';
import '../../../../core/widgets/time_coordinates_toggle.dart';
import '../../../../services/audio/ambient_audio_controller.dart';
import 'cockpit_theme_tokens.dart';

/// AUDIO / TIME / MODE, laid out as part of the instrument panel rather
/// than floating screen corners (spec section 16). Reuses the exact same
/// controllers/widgets as Cosmic Minimal — no duplicated toggle logic.
class CockpitControls extends StatelessWidget {
  const CockpitControls({
    super.key,
    required this.ambientAudio,
    required this.timeCoordinates,
    required this.readoutMode,
  });

  final AmbientAudioController ambientAudio;
  final TimeCoordinatesController timeCoordinates;
  final ReadoutModeController readoutMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: CockpitTokens.panelBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CockpitTokens.panelBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ControlSlot(
            label: l10n.shuttleAudioLabel,
            child: AtmosphereToggle(controller: ambientAudio),
          ),
          _ControlSlot(
            label: l10n.shuttleTimeLabel,
            child: TimeCoordinatesToggle(controller: timeCoordinates),
          ),
          _ControlSlot(
            label: l10n.shuttleModeLabel,
            child: ReadoutModeToggle(controller: readoutMode),
          ),
        ],
      ),
    );
  }
}

class _ControlSlot extends StatelessWidget {
  const _ControlSlot({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: CockpitTokens.mutedTeal,
            fontSize: 10,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
        // IconButton's default 48px min tap target already clears the
        // 44x44 logical-px requirement (spec section 16).
        child,
      ],
    );
  }
}
