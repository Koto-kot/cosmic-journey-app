import 'package:cosmic_journey/core/science_constants.dart';
import 'package:cosmic_journey/services/journey_calculator/average_cmb_journey_calculator.dart';
import 'package:cosmic_journey/services/journey_calculator/journey_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculator = AverageCmbJourneyCalculator();

  JourneyProfile profileAt(DateTime birthUtc, {int year = 2000}) {
    return JourneyProfile(
      birthYear: year,
      canonicalBirthUtc: birthUtc,
      isApproximate: true,
      createdAt: birthUtc,
      updatedAt: birthUtc,
    );
  }

  test('elapsed seconds is the UTC difference', () {
    final birth = DateTime.utc(2000, 7, 1, 12);
    final now = DateTime.utc(2000, 7, 1, 13, 30, 15, 250);
    final snapshot = calculator.calculate(at: now, profile: profileAt(birth));
    expect(snapshot.elapsedSeconds, closeTo(5415.25, 1e-9));
  });

  test('full days are the floor of elapsed seconds / 86400', () {
    final birth = DateTime.utc(2000, 7, 1, 12);
    final now = DateTime.utc(2000, 7, 3, 11, 59, 59);
    final snapshot = calculator.calculate(at: now, profile: profileAt(birth));
    expect(snapshot.fullDays, 1);
    expect(snapshot.elapsedSeconds, lessThan(2 * 86400));
  });

  test('distance is elapsed seconds times the central CMB speed', () {
    final birth = DateTime.utc(2000, 1, 1);
    final now = DateTime.utc(2000, 1, 2);
    final snapshot = calculator.calculate(at: now, profile: profileAt(birth));
    expect(snapshot.elapsedSeconds, 86400);
    expect(
      snapshot.distanceKm,
      86400 * ScienceConstants.averageCmbSpeedKmPerSecond,
    );
    expect(
      snapshot.speedKmPerSecond,
      ScienceConstants.averageCmbSpeedKmPerSecond,
    );
  });

  test('leap year from 1 July 2003 to 1 July 2004 is 366 days', () {
    final snapshot = calculator.calculate(
      at: DateTime.utc(2004, 7, 1, 12),
      profile: profileAt(DateTime.utc(2003, 7, 1, 12), year: 2003),
    );
    expect(snapshot.fullDays, 366);
    expect(snapshot.elapsedSeconds, 366 * 86400);
  });

  test('non-leap year from 1 July 2001 to 1 July 2002 is 365 days', () {
    final snapshot = calculator.calculate(
      at: DateTime.utc(2002, 7, 1, 12),
      profile: profileAt(DateTime.utc(2001, 7, 1, 12), year: 2001),
    );
    expect(snapshot.fullDays, 365);
    expect(snapshot.elapsedSeconds, 365 * 86400);
  });

  test('future birth is clamped to zero elapsed time', () {
    final snapshot = calculator.calculate(
      at: DateTime.utc(2020, 1, 1),
      profile: profileAt(DateTime.utc(2030, 7, 1), year: 2030),
    );
    expect(snapshot.elapsedSeconds, 0);
    expect(snapshot.fullDays, 0);
    expect(snapshot.distanceKm, 0);
  });

  test('speed constant is read from ScienceConstants, not a local literal', () {
    expect(const AverageCmbJourneyCalculator().speedKmPerSecond, 370);
    expect(
      const AverageCmbJourneyCalculator().speedKmPerSecond,
      ScienceConstants.averageCmbSpeedKmPerSecond,
    );
  });

  test('local DateTime inputs are converted to UTC before subtraction', () {
    final birthLocal = DateTime(2000, 7, 1, 12);
    final nowLocal = DateTime(2000, 7, 2, 12);
    final snapshot = calculator.calculate(
      at: nowLocal,
      profile: profileAt(birthLocal),
    );
    final expected = nowLocal.toUtc().difference(birthLocal.toUtc());
    expect(
      snapshot.elapsedSeconds,
      expected.inMicroseconds / Duration.microsecondsPerSecond,
    );
  });
}
