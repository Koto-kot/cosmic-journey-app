import 'package:cosmic_journey/core/clock.dart';
import 'package:cosmic_journey/core/science_constants.dart';
import 'package:cosmic_journey/features/journey/live_journey_controller.dart';
import 'package:cosmic_journey/services/journey_calculator/average_cmb_journey_calculator.dart';
import 'package:cosmic_journey/services/journey_calculator/journey_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeClock clock;
  late LiveJourneyController controller;
  late JourneyProfile profile;

  setUp(() {
    clock = FakeClock(DateTime.utc(2000, 1, 2));
    profile = JourneyProfile(
      birthYear: 2000,
      canonicalBirthUtc: DateTime.utc(2000, 1, 1),
      isApproximate: true,
      createdAt: DateTime.utc(2000, 1, 1),
      updatedAt: DateTime.utc(2000, 1, 1),
    );
    controller = LiveJourneyController(
      clock: clock,
      calculator: const AverageCmbJourneyCalculator(),
      profile: profile,
      reconcileEvery: const Duration(seconds: 5),
    );
  });

  tearDown(() {
    controller.dispose();
  });

  testWidgets('pause freezes values and resume recalculates from the clock', (
    tester,
  ) async {
    await tester.pumpWidget(_Harness(controller: controller));
    await tester.pump();

    expect(controller.snapshot.elapsedSeconds, 86400);
    expect(
      controller.snapshot.distanceKm,
      86400 * ScienceConstants.averageCmbSpeedKmPerSecond,
    );

    controller.pause();
    clock.advance(const Duration(seconds: 10));
    await tester.pump();
    expect(controller.isPaused, isTrue);
    expect(controller.snapshot.elapsedSeconds, 86400);

    controller.resume();
    await tester.pump();
    expect(controller.isPaused, isFalse);
    expect(controller.snapshot.elapsedSeconds, 86410);
    expect(
      controller.snapshot.distanceKm,
      86410 * ScienceConstants.averageCmbSpeedKmPerSecond,
    );
  });

  testWidgets(
    'foreground interpolation follows FakeClock without a new snapshot',
    (tester) async {
      await tester.pumpWidget(_Harness(controller: controller));
      await tester.pump();
      clock.advance(const Duration(milliseconds: 500));
      await tester.pump();
      expect(controller.snapshot.elapsedSeconds, closeTo(86400.5, 1e-9));
    },
  );
}

class _Harness extends StatefulWidget {
  const _Harness({required this.controller});

  final LiveJourneyController controller;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.start(this);
  }

  @override
  void dispose() {
    widget.controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
