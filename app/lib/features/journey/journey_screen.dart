import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/app_dependencies.dart';
import '../../core/clock.dart';
import '../../core/formatters/journey_number_formatter.dart';
import '../../core/readout/readout_mode.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/atmosphere_toggle.dart';
import '../../core/widgets/cosmic_backdrop.dart';
import '../../core/widgets/earth_hero.dart';
import '../../core/widgets/glow_divider.dart';
import '../../core/widgets/language_switcher.dart';
import '../../core/widgets/readout_mode_toggle.dart';
import '../../services/journey_calculator/journey_profile.dart';
import '../../services/journey_calculator/journey_snapshot.dart';
import '../menu/menu_screen.dart';
import 'live_journey_controller.dart';
import 'time_coordinates_block.dart';

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
  late final AnimationController _pulse;
  int _lastPulseEpoch = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _controller = LiveJourneyController(
      clock: widget.dependencies.clock,
      calculator: widget.dependencies.calculator,
      profile: widget.profile,
      mode: widget.dependencies.readoutModeController.mode,
    )..addListener(_onJourneyTick);
    _controller.start(this);
    widget.dependencies.readoutModeController.addListener(_syncReadoutMode);
    widget.dependencies.ambientAudio.handleLifecycle(AppLifecycleState.resumed);
  }

  void _syncReadoutMode() {
    _controller.setMode(widget.dependencies.readoutModeController.mode);
  }

  void _onJourneyTick() {
    if (_controller.mode != ReadoutMode.pulse) {
      return;
    }
    if (_controller.pulseEpoch == _lastPulseEpoch) {
      return;
    }
    _lastPulseEpoch = _controller.pulseEpoch;
    if (_controller.reducedMotion) {
      _pulse.value = 0;
      return;
    }
    _pulse.forward(from: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.setReducedMotion(MediaQuery.disableAnimationsOf(context));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    widget.dependencies.ambientAudio.handleLifecycle(state);
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
    widget.dependencies.readoutModeController.removeListener(_syncReadoutMode);
    _controller
      ..removeListener(_onJourneyTick)
      ..dispose();
    _pulse.dispose();
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
              Positioned(
                top: 4,
                right: 4,
                child: LanguageSwitcher(
                  controller: widget.dependencies.localeController,
                ),
              ),
              Positioned(
                bottom: 4,
                left: 4,
                child: AtmosphereToggle(
                  controller: widget.dependencies.ambientAudio,
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: ReadoutModeToggle(
                  controller: widget.dependencies.readoutModeController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CosmicTokens.pagePadding,
                ),
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _controller,
                    _pulse,
                    widget.dependencies.timeCoordinatesController,
                  ]),
                  builder: (context, _) {
                    return _JourneyReadout(
                      snapshot: _controller.snapshot,
                      formatter: formatter,
                      l10n: l10n,
                      mode: _controller.mode,
                      glow: _controller.mode == ReadoutMode.flow
                          ? 0.22
                          : (_controller.reducedMotion
                                ? 0
                                : pulseGlow(_pulse.value)),
                      reducedMotion: _controller.reducedMotion,
                      showTimeCoordinates:
                          widget.dependencies.timeCoordinatesController
                              .enabled,
                      profile: widget.profile,
                      clock: widget.dependencies.clock,
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
    required this.mode,
    required this.glow,
    required this.reducedMotion,
    required this.showTimeCoordinates,
    required this.profile,
    required this.clock,
  });

  final JourneySnapshot snapshot;
  final JourneyNumberFormatter formatter;
  final AppLocalizations l10n;
  final ReadoutMode mode;
  final double glow;
  final bool reducedMotion;
  final bool showTimeCoordinates;
  final JourneyProfile profile;
  final Clock clock;

  @override
  Widget build(BuildContext context) {
    final flow = mode == ReadoutMode.flow;
    // Continuous (flow) mode still refreshes several times a second, but the
    // main-screen readout is always the whole-number odometer — no decimal
    // noise in either mode (ADR 0007).
    final distanceKm = snapshot.wholeDistanceKm.toDouble();
    final seconds = snapshot.wholeElapsedSeconds.toDouble();
    final distance = formatter.formatFullNumber(snapshot.wholeDistanceKm);
    final days = formatter.days(snapshot.fullDays);
    final secondsText = formatter.formatFullNumber(
      snapshot.wholeElapsedSeconds,
    );
    final distanceScale = l10n.humanScaleKm(
      formatter.formatHumanScale(distanceKm),
    );
    final secondsScale = l10n.humanScale(formatter.formatHumanScale(seconds));
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 640;
        final earthSize = compact ? 118.0 : 168.0;
        return Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Semantics(
              container: true,
              liveRegion: false,
              label:
                  '${l10n.semanticDistance(distanceScale)}. '
                  '${l10n.semanticDays(days)}. '
                  '${l10n.semanticSeconds(secondsScale)}',
              child: ExcludeSemantics(
                child: Column(
                  children: [
                    SizedBox(height: compact ? 28 : 40),
                    EarthHero(size: earthSize),
                    SizedBox(height: compact ? 12 : 20),
                    if (showTimeCoordinates)
                      TimeCoordinatesBlock(clock: clock, profile: profile),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _LabeledNumber(
                            value: distance,
                            label: l10n.kmLabel,
                            scale: distanceScale,
                            compact: compact,
                            large: true,
                            pulse: !flow,
                            reducedMotion: reducedMotion,
                          ),
                          GlowDivider(glow: glow),
                          _LabeledNumber(
                            value: days,
                            label: l10n.daysLabel,
                            compact: compact,
                            pulse: false,
                            reducedMotion: reducedMotion,
                          ),
                          GlowDivider(glow: glow),
                          _LabeledNumber(
                            value: secondsText,
                            label: l10n.secondsLabel,
                            scale: secondsScale,
                            compact: compact,
                            pulse: !flow,
                            reducedMotion: reducedMotion,
                          ),
                          SizedBox(height: compact ? 8 : 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
    required this.reducedMotion,
    this.scale,
    this.large = false,
    this.pulse = false,
  });

  final String value;
  final String label;
  final String? scale;
  final bool compact;
  final bool large;
  final bool pulse;
  final bool reducedMotion;

  @override
  Widget build(BuildContext context) {
    final size = large ? (compact ? 30.0 : 36.0) : (compact ? 28.0 : 34.0);
    final number = FittedBox(
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
    );
    return Column(
      children: [
        if (pulse)
          AnimatedSwitcher(
            duration: reducedMotion
                ? Duration.zero
                : const Duration(milliseconds: 320),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              if (reducedMotion) {
                return child;
              }
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.992, end: 1).animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(key: ValueKey(value), child: number),
          )
        else
          number,
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: CosmicTokens.onBackground,
            letterSpacing: 0.4,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (scale != null) ...[
          const SizedBox(height: 6),
          Text(
            scale!,
            style: TextStyle(
              color: CosmicTokens.muted,
              letterSpacing: 0.2,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
