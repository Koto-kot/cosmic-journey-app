import 'package:flutter/material.dart';

import '../../app/app_dependencies.dart';
import '../../core/journey_style/journey_style.dart';
import '../../core/readout/readout_mode.dart';
import '../../core/theme_tokens.dart';
import '../../core/widgets/cosmic_backdrop.dart';
import '../../services/journey_calculator/journey_profile.dart';
import '../menu/menu_screen.dart';
import 'live_journey_controller.dart';
import 'views/cosmic_minimal/cosmic_minimal_view.dart';
import 'views/shuttle_cockpit/shuttle_cockpit_view.dart';

/// Container for the live journey: owns the lifecycle, the shared
/// [LiveJourneyController] (one ticker, one calculator — see ADR 0010), and
/// switches which [JourneyStyle] view renders the data. The math and the
/// presentation are deliberately separate.
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
    return Scaffold(
      backgroundColor: CosmicTokens.background,
      body: CosmicBackdrop(
        child: SafeArea(
          child: ListenableBuilder(
            listenable: widget.dependencies.journeyStyleController,
            builder: (context, _) {
              final reducedMotion = MediaQuery.disableAnimationsOf(context);
              final style = widget.dependencies.journeyStyleController.style;
              return AnimatedSwitcher(
                // Style switch never resets journey state: the same
                // LiveJourneyController/profile keep running underneath,
                // only the presentation widget swaps (spec section 21).
                duration: reducedMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: KeyedSubtree(
                  key: ValueKey(style),
                  child: switch (style) {
                    JourneyStyle.cosmicMinimal => CosmicMinimalView(
                      dependencies: widget.dependencies,
                      profile: widget.profile,
                      controller: _controller,
                      pulse: _pulse,
                      onMenuTap: _openMenu,
                    ),
                    JourneyStyle.shuttleCockpit => ShuttleCockpitView(
                      dependencies: widget.dependencies,
                      profile: widget.profile,
                      controller: _controller,
                      pulse: _pulse,
                      onMenuTap: _openMenu,
                    ),
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
