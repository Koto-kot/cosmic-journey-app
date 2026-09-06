import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_dependencies.dart';
import '../../../../core/clock.dart';
import '../../../../core/formatters/journey_number_formatter.dart';
import '../../../../core/readout/readout_mode.dart';
import '../../../../core/theme_tokens.dart';
import '../../../../core/widgets/atmosphere_toggle.dart';
import '../../../../core/widgets/earth_hero.dart';
import '../../../../core/widgets/glow_divider.dart';
import '../../../../core/widgets/readout_mode_toggle.dart';
import '../../../../core/widgets/time_coordinates_toggle.dart';
import '../../../../services/journey_calculator/journey_profile.dart';
import '../../../../services/journey_calculator/journey_snapshot.dart';
import '../../journey_top_bar.dart';
import '../../live_journey_controller.dart';
import '../../time_coordinates_block.dart';

/// The original main screen (ADR 0007): Earth visual, three counters,
/// AUDIO/TIME/MODE corner controls. Extracted verbatim out of `JourneyScreen`
/// so it can sit side by side with `ShuttleCockpitView` — see ADR 0010.
class CosmicMinimalView extends StatelessWidget {
  const CosmicMinimalView({
    super.key,
    required this.dependencies,
    required this.profile,
    required this.controller,
    required this.pulse,
    required this.onMenuTap,
  });

  final AppDependencies dependencies;
  final JourneyProfile profile;
  final LiveJourneyController controller;
  final Animation<double> pulse;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final formatter = JourneyNumberFormatter.fromLocale(
      Localizations.localeOf(context),
    );
    return Stack(
      children: [
        Positioned(
          top: 4,
          left: 4,
          right: 4,
          child: JourneyTopBar(
            onMenuTap: onMenuTap,
            localeController: dependencies.localeController,
          ),
        ),
        Positioned(
          bottom: 4,
          left: 4,
          child: AtmosphereToggle(controller: dependencies.ambientAudio),
        ),
        Positioned(
          bottom: 4,
          left: 0,
          right: 0,
          child: Center(
            child: TimeCoordinatesToggle(
              controller: dependencies.timeCoordinatesController,
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: ReadoutModeToggle(
            controller: dependencies.readoutModeController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CosmicTokens.pagePadding,
          ),
          child: AnimatedBuilder(
            animation: Listenable.merge([
              controller,
              pulse,
              dependencies.timeCoordinatesController,
            ]),
            builder: (context, _) {
              return _JourneyReadout(
                snapshot: controller.snapshot,
                formatter: formatter,
                l10n: l10n,
                mode: controller.mode,
                glow: controller.mode == ReadoutMode.flow
                    ? 0.22
                    : (controller.reducedMotion ? 0 : pulseGlow(pulse.value)),
                reducedMotion: controller.reducedMotion,
                showTimeCoordinates:
                    dependencies.timeCoordinatesController.enabled,
                profile: profile,
                clock: dependencies.clock,
              );
            },
          ),
        ),
      ],
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
                    AnimatedSwitcher(
                      duration: reducedMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 250),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) {
                        if (reducedMotion) {
                          return child;
                        }
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, -0.15),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: showTimeCoordinates
                          ? TimeCoordinatesBlock(
                              key: const ValueKey('time-coordinates-on'),
                              clock: clock,
                              profile: profile,
                            )
                          : const SizedBox(
                              key: ValueKey('time-coordinates-off'),
                            ),
                    ),
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
