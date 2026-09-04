import 'package:flutter/material.dart';
import 'package:cosmic_journey/l10n/app_localizations.dart';

import '../core/theme_tokens.dart';
import 'app_dependencies.dart';
import 'theme.dart';
import '../features/bootstrap/bootstrap_screen.dart';

class CosmicJourneyApp extends StatelessWidget {
  const CosmicJourneyApp({
    super.key,
    required this.dependencies,
    this.localeOverride,
  });

  final AppDependencies dependencies;
  final Locale? localeOverride;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: buildCosmicTheme(),
      locale: localeOverride,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return ColoredBox(
          color: CosmicTokens.background,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: BootstrapScreen(dependencies: dependencies),
    );
  }
}
