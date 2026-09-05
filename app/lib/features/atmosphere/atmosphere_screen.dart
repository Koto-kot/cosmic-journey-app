import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/app_dependencies.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/pro_badge.dart';
import '../../core/widgets/secondary_scaffold.dart';
import '../../services/audio/soundscape.dart';

class AtmosphereScreen extends StatelessWidget {
  const AtmosphereScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListenableBuilder(
      listenable: dependencies.ambientAudio,
      builder: (context, _) {
        final selected = dependencies.ambientAudio.soundscapeId;
        return SecondaryScaffold(
          title: l10n.atmosphereTitle,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            children: [
              for (final soundscape in SoundscapeCatalog.all) ...[
                _SoundscapeTile(
                  title: _name(l10n, soundscape.id),
                  selected: selected == soundscape.id,
                  pro: !SoundscapeCatalog.isFree(soundscape.id),
                  onTap: () async {
                    if (!dependencies.entitlement.soundscapeUnlocked(
                      soundscape.id,
                    )) {
                      return;
                    }
                    await dependencies.ambientAudio.setSoundscape(
                      soundscape.id,
                    );
                    if (!dependencies.ambientAudio.enabled) {
                      await dependencies.ambientAudio.setEnabled(true);
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        );
      },
    );
  }

  String _name(AppLocalizations l10n, String id) {
    return switch (id) {
      SoundscapeCatalog.orbitalDriftId => l10n.soundscapeOrbitalDrift,
      SoundscapeCatalog.auroraId => l10n.soundscapeAuroraName,
      SoundscapeCatalog.bluePlanetId => l10n.soundscapeBluePlanet,
      SoundscapeCatalog.interstellarId => l10n.soundscapeInterstellar,
      SoundscapeCatalog.voyagerId => l10n.soundscapeVoyager,
      SoundscapeCatalog.deepSilenceId => l10n.soundscapeDeepSilence,
      SoundscapeCatalog.solarWindId => l10n.soundscapeSolarWind,
      SoundscapeCatalog.ionosphereId => l10n.soundscapeIonosphere,
      SoundscapeCatalog.redDwarfId => l10n.soundscapeRedDwarf,
      SoundscapeCatalog.quietStationId => l10n.soundscapeQuietStation,
      SoundscapeCatalog.cometTailId => l10n.soundscapeCometTail,
      SoundscapeCatalog.magnetosphereId => l10n.soundscapeMagnetosphere,
      _ => l10n.soundscapeDeepSpace,
    };
  }
}

class _SoundscapeTile extends StatelessWidget {
  const _SoundscapeTile({
    required this.title,
    required this.selected,
    required this.pro,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final bool pro;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? CosmicTokens.accent : CosmicTokens.cardStroke,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.graphic_eq : Icons.nights_stay_outlined,
                color: selected ? CosmicTokens.accent : CosmicTokens.muted,
              ),
              const SizedBox(width: 14),
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
                    if (selected)
                      Text(
                        l10n.soundscapeSelected,
                        style: TextStyle(
                          color: CosmicTokens.muted,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              if (pro) const ProBadge(compact: true),
            ],
          ),
        ),
      ),
    );
  }
}
