import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../core/science_constants.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/cosmic_backdrop.dart';

class ScienceScreen extends StatelessWidget {
  const ScienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: CosmicTokens.background,
      body: CosmicBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(8, 0, 24, 32),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 0, 20),
                child: Text(
                  l10n.scienceTitle,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _ScienceParagraph(l10n.sciencePathLength),
              _ScienceParagraph(l10n.scienceNotCentre),
              _ScienceParagraph(
                l10n.scienceSpeed(
                  ScienceConstants.averageCmbSpeedKmPerSecond.toStringAsFixed(
                    0,
                  ),
                ),
              ),
              _ScienceParagraph(l10n.scienceFrame),
            ],
          ),
        ),
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
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
      child: Text(
        text,
        style: const TextStyle(
          color: CosmicTokens.muted,
          height: 1.5,
          fontSize: 15,
        ),
      ),
    );
  }
}
