import 'package:flutter/material.dart';
import 'package:cosmic_journey/l10n/app_localizations.dart';

import '../../app/app_dependencies.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/cosmic_backdrop.dart';
import '../journey/journey_screen.dart';
import '../onboarding/onboarding_screen.dart';

class BootstrapScreen extends StatefulWidget {
  const BootstrapScreen({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<BootstrapScreen> createState() => _BootstrapScreenState();
}

class _BootstrapScreenState extends State<BootstrapScreen> {
  late final Future<Widget> _next;

  @override
  void initState() {
    super.initState();
    _next = _resolve();
  }

  Future<Widget> _resolve() async {
    final profile = await widget.dependencies.profileStore.load();
    if (profile == null) {
      return OnboardingScreen(dependencies: widget.dependencies);
    }
    return JourneyScreen(dependencies: widget.dependencies, profile: profile);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<Widget>(
      future: _next,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        }
        return Scaffold(
          backgroundColor: CosmicTokens.background,
          body: CosmicBackdrop(
            child: Center(
              child: Text(
                l10n.preparingJourney,
                style: TextStyle(color: CosmicTokens.muted, letterSpacing: 0.6),
              ),
            ),
          ),
        );
      },
    );
  }
}
