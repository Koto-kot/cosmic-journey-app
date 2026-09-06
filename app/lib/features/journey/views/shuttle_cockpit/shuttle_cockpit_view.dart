import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_dependencies.dart';
import '../../../../core/formatters/journey_number_formatter.dart';
import '../../../../core/readout/readout_mode.dart';
import '../../../../core/widgets/glow_divider.dart';
import '../../../../services/journey_calculator/journey_profile.dart';
import '../../../../services/journey_calculator/journey_snapshot.dart';
import '../../journey_top_bar.dart';
import '../../live_journey_controller.dart';
import '../../time_coordinates_block.dart';
import 'cockpit_controls.dart';
import 'distance_panel.dart';
import 'flight_time_panel.dart';
import 'shuttle_window.dart';

/// Captain's-seat interface style: panoramic window, DISTANCE and FLIGHT
/// TIME panels, instrument-panel controls. Same [LiveJourneyController] and
/// [JourneySnapshot] as Cosmic Minimal — only the presentation differs
/// (ADR 0010, spec section 7-8).
class ShuttleCockpitView extends StatelessWidget {
  const ShuttleCockpitView({
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
          child: JourneyTopBar(
            onMenuTap: onMenuTap,
            localeController: dependencies.localeController,
            centerLabel: l10n.shuttleFlightActiveLabel,
          ),
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              controller,
              pulse,
              dependencies.timeCoordinatesController,
            ]),
            builder: (context, _) {
              return _CockpitBody(
                snapshot: controller.snapshot,
                formatter: formatter,
                mode: controller.mode,
                glow: controller.mode == ReadoutMode.flow
                    ? 0.22
                    : (controller.reducedMotion ? 0 : pulseGlow(pulse.value)),
                reducedMotion: controller.reducedMotion,
                showTimeCoordinates:
                    dependencies.timeCoordinatesController.enabled,
                profile: profile,
                dependencies: dependencies,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CockpitBody extends StatelessWidget {
  const _CockpitBody({
    required this.snapshot,
    required this.formatter,
    required this.mode,
    required this.glow,
    required this.reducedMotion,
    required this.showTimeCoordinates,
    required this.profile,
    required this.dependencies,
  });

  final JourneySnapshot snapshot;
  final JourneyNumberFormatter formatter;
  final ReadoutMode mode;
  final double glow;
  final bool reducedMotion;
  final bool showTimeCoordinates;
  final JourneyProfile profile;
  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pulse = mode != ReadoutMode.flow;
    final distanceKm = snapshot.wholeDistanceKm.toDouble();
    final distanceText = formatter.formatFullNumber(snapshot.wholeDistanceKm);
    final distanceScale = l10n.humanScaleKm(
      formatter.formatHumanScale(distanceKm),
    );

    final totalSeconds = snapshot.wholeElapsedSeconds;
    final days = totalSeconds ~/ 86400;
    final afterDays = totalSeconds % 86400;
    final hours = afterDays ~/ 3600;
    final afterHours = afterDays % 3600;
    final minutes = afterHours ~/ 60;
    final seconds = afterHours % 60;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 700;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShuttleWindow(
                    reducedMotion: reducedMotion,
                    height: compact ? 150 : 220,
                  ),
                  const SizedBox(height: 16),
                  DistancePanel(
                    valueText: distanceText,
                    scaleText: distanceScale,
                    pulse: pulse,
                    glow: glow,
                    reducedMotion: reducedMotion,
                  ),
                  const SizedBox(height: 14),
                  FlightTimePanel(
                    days: formatter.formatFullNumber(days),
                    hours: hours.toString().padLeft(2, '0'),
                    minutes: minutes.toString().padLeft(2, '0'),
                    seconds: seconds.toString().padLeft(2, '0'),
                    pulse: pulse,
                    reducedMotion: reducedMotion,
                  ),
                  const SizedBox(height: 14),
                  AnimatedSwitcher(
                    duration: reducedMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      if (reducedMotion) {
                        return child;
                      }
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: showTimeCoordinates
                        ? Padding(
                            key: const ValueKey('shuttle-time-on'),
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Opacity(
                              opacity: 0.9,
                              child: TimeCoordinatesBlock(
                                clock: dependencies.clock,
                                profile: profile,
                              ),
                            ),
                          )
                        : const SizedBox(key: ValueKey('shuttle-time-off')),
                  ),
                  CockpitControls(
                    ambientAudio: dependencies.ambientAudio,
                    timeCoordinates: dependencies.timeCoordinatesController,
                    readoutMode: dependencies.readoutModeController,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
