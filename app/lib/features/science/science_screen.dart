import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/app_dependencies.dart';
import '../../core/science_constants.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/secondary_scaffold.dart';

class ScienceScreen extends StatelessWidget {
  const ScienceScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SecondaryScaffold(
      title: l10n.scienceTitle,
      entitlement: dependencies.entitlement,
      adPlacement: 'science',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: [
          _ScienceParagraph(l10n.sciencePathLength),
          _ScienceParagraph(l10n.scienceNotCentre),
          _ScienceParagraph(
            l10n.scienceSpeed(
              ScienceConstants.averageCmbSpeedKmPerSecond.toStringAsFixed(0),
            ),
          ),
          _ScienceParagraph(l10n.scienceFrame),
        ],
      ),
    );
  }
}

class _ScienceParagraph extends StatelessWidget {
  const _ScienceParagraph(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: TextStyle(color: CosmicTokens.muted, height: 1.5, fontSize: 15),
      ),
    );
  }
}
