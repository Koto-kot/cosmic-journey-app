import 'package:cosmic_journey/core/science_constants.dart';
import 'package:cosmic_journey/services/milestones/milestone_estimator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('next milestone is the next whole billion kilometres', () {
    final next = MilestoneEstimator.next(
      distanceKm: 674218493771.842,
      speedKmPerSecond: ScienceConstants.averageCmbSpeedKmPerSecond,
    );
    expect(next.thresholdKm, 675000000000);
    expect(next.remainingKm, closeTo(781506228.158, 0.01));
  });

  test('exact billion steps to the following billion', () {
    final next = MilestoneEstimator.next(
      distanceKm: 675000000000,
      speedKmPerSecond: 370,
    );
    expect(next.thresholdKm, 676000000000);
  });

  test('remaining duration is remaining km divided by speed', () {
    final next = MilestoneEstimator.next(distanceKm: 0, speedKmPerSecond: 370);
    expect(next.thresholdKm, 1000000000);
    expect(next.remaining.inSeconds, (1000000000 / 370).floor());
  });
}
