import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/app_dependencies.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/secondary_scaffold.dart';

class ProScreen extends StatelessWidget {
  const ProScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SecondaryScaffold(
      title: l10n.proItem,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        children: [
          Text(
            l10n.proUnlockedTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.proUnlockedBody,
            style: TextStyle(color: CosmicTokens.muted, height: 1.45),
          ),
          const SizedBox(height: 20),
          _Included(l10n.stylesItem),
          _Included(l10n.atmosphereItem),
          _Included(l10n.statisticsItem),
          _Included(l10n.widgetsItem),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.restorePurchasesEmpty)),
              );
            },
            child: Text(l10n.restorePurchases),
          ),
        ],
      ),
    );
  }
}

class _Included extends StatelessWidget {
  const _Included(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check, color: CosmicTokens.accent, size: 18),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}
