import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/app_dependencies.dart';
import '../../app/readout_mode_controller.dart';
import '../../app/time_coordinates_controller.dart';
import '../../core/readout/readout_mode.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/cosmic_backdrop.dart';
import '../../core/widgets/language_switcher.dart';
import '../../services/journey_calculator/journey_profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.dependencies,
    required this.profile,
  });

  final AppDependencies dependencies;
  final JourneyProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: CosmicTokens.background,
      body: CosmicBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                    const Spacer(),
                    LanguageSwitcher(controller: dependencies.localeController),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 0, 12),
                  child: Text(
                    l10n.settingsTitle,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(left: 16),
                    children: [
                      _ReadoutModePicker(
                        controller: dependencies.readoutModeController,
                      ),
                      const SizedBox(height: 20),
                      _TimeCoordinatesToggle(
                        controller: dependencies.timeCoordinatesController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadoutModePicker extends StatelessWidget {
  const _ReadoutModePicker({required this.controller});

  final ReadoutModeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.readoutModeLabel,
              style: TextStyle(
                color: CosmicTokens.muted,
                letterSpacing: 1.4,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            _ReadoutModeTile(
              title: l10n.readoutPulse,
              subtitle: l10n.readoutPulseHint,
              selected: controller.mode == ReadoutMode.pulse,
              icon: Icons.radio_button_checked,
              onTap: () => controller.setMode(ReadoutMode.pulse),
            ),
            const SizedBox(height: 8),
            _ReadoutModeTile(
              title: l10n.readoutFlow,
              subtitle: l10n.readoutFlowHint,
              selected: controller.mode == ReadoutMode.flow,
              icon: Icons.waves,
              onTap: () => controller.setMode(ReadoutMode.flow),
            ),
          ],
        );
      },
    );
  }
}

class _ReadoutModeTile extends StatelessWidget {
  const _ReadoutModeTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? CosmicTokens.accent : CosmicTokens.cardStroke,
            ),
            color: CosmicTokens.card,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? CosmicTokens.accent : CosmicTokens.muted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: CosmicTokens.muted,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check, color: CosmicTokens.accent, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeCoordinatesToggle extends StatelessWidget {
  const _TimeCoordinatesToggle({required this.controller});

  final TimeCoordinatesController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final enabled = controller.enabled;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.setEnabled(!enabled),
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: CosmicTokens.cardStroke),
                color: CosmicTokens.card,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.showTimeCoordinatesLabel,
                      style: const TextStyle(
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Switch(
                    value: enabled,
                    activeThumbColor: CosmicTokens.accent,
                    onChanged: controller.setEnabled,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
