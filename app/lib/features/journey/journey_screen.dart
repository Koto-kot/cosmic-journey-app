import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/app_dependencies.dart';
import '../../core/formatters/journey_number_formatter.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/cosmic_backdrop.dart';
import '../../core/widgets/earth_hero.dart';
import '../../core/widgets/glow_divider.dart';
import '../../services/journey_calculator/journey_profile.dart';
import '../../services/journey_calculator/journey_snapshot.dart';
import '../menu/menu_screen.dart';
import 'live_journey_controller.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({
    super.key,
    required this.dependencies,
    required this.profile,
  });

  final AppDependencies dependencies;
  final JourneyProfile profile;

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final LiveJourneyController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = LiveJourneyController(
      clock: widget.dependencies.clock,
      calculator: widget.dependencies.calculator,
      profile: widget.profile,
    )..start(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.setReducedMotion(MediaQuery.disableAnimationsOf(context));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _controller.resume();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _controller.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  void _openMenu() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondary) {
          return FadeTransition(
            opacity: animation,
            child: MenuScreen(
              dependencies: widget.dependencies,
              profile: widget.profile,
              controller: _controller,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final formatter = JourneyNumberFormatter.fromLocale(
      Localizations.localeOf(context),
    );
    return Scaffold(
      backgroundColor: CosmicTokens.background,
      body: CosmicBackdrop(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 4,
                left: 4,
                child: IconButton(
                  tooltip: l10n.menuTooltip,
                  onPressed: _openMenu,
                  icon: const Icon(Icons.menu, size: 26),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CosmicTokens.pagePadding,
                ),
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) {
                    return _JourneyReadout(
                      snapshot: _controller.snapshot,
                      formatter: formatter,
                      l10n: l10n,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyReadout extends StatelessWidget {
  const _JourneyReadout({
    required this.snapshot,
    required this.formatter,
    required this.l10n,
  });

  final JourneySnapshot snapshot;
  final JourneyNumberFormatter formatter;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final distance = formatter.distanceKm(snapshot.distanceKm);
    final days = formatter.days(snapshot.fullDays);
    final seconds = formatter.seconds(snapshot.elapsedSeconds);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 640;
        final earthSize = compact ? 148.0 : 210.0;
        return Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                SizedBox(height: compact ? 28 : 40),
                EarthHero(size: earthSize),
                SizedBox(height: compact ? 12 : 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Semantics(
                        key: const ValueKey('journey-distance'),
                        label: l10n.semanticDistance(distance),
                        value: distance,
                        child: _LabeledNumber(
                          value: distance,
                          label: l10n.kmLabel,
                          compact: compact,
                          large: true,
                        ),
                      ),
                      const GlowDivider(),
                      Semantics(
                        key: const ValueKey('journey-days'),
                        label: l10n.semanticDays(days),
                        value: days,
                        child: _LabeledNumber(
                          value: days,
                          label: l10n.daysLabel,
                          compact: compact,
                        ),
                      ),
                      const GlowDivider(),
                      Semantics(
                        key: const ValueKey('journey-seconds'),
                        label: l10n.semanticSeconds(seconds),
                        value: seconds,
                        child: _LabeledNumber(
                          value: seconds,
                          label: l10n.secondsLabel,
                          compact: compact,
                        ),
                      ),
                      SizedBox(height: compact ? 8 : 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LabeledNumber extends StatelessWidget {
  const _LabeledNumber({
    required this.value,
    required this.label,
    required this.compact,
    this.large = false,
  });

  final String value;
  final String label;
  final bool compact;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? (compact ? 30.0 : 36.0) : (compact ? 28.0 : 34.0);
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            maxLines: 1,
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
              height: 1.05,
              color: CosmicTokens.onBackground,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: CosmicTokens.onBackground,
            letterSpacing: 0.4,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
