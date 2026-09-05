import 'package:cosmic_journey/core/time/approximate_birth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('year-only convention is 1 July 12:00 local converted to UTC', () {
    final utc = ApproximateBirth.canonicalUtc(
      year: 1991,
      localOffset: const Duration(hours: 3),
    );
    expect(utc, DateTime.utc(1991, 7, 1, 9));
  });

  test(
    'DST: summer offset and winter offset produce different UTC instants',
    () {
      final july = ApproximateBirth.canonicalUtc(
        year: 2024,
        localOffset: const Duration(hours: 3),
      );
      final january = ApproximateBirth.canonicalUtc(
        year: 2024,
        localOffset: const Duration(hours: 2),
        month: 1,
        day: 1,
      );
      expect(july, DateTime.utc(2024, 7, 1, 9));
      expect(january, DateTime.utc(2024, 1, 1, 10));
      expect(july.timeZoneName, 'UTC');
      expect(january.timeZoneName, 'UTC');
    },
  );

  test('negative offset (west of UTC) is added when converting to UTC', () {
    final utc = ApproximateBirth.canonicalUtc(
      year: 2000,
      localOffset: const Duration(hours: -5),
    );
    expect(utc, DateTime.utc(2000, 7, 1, 17));
  });

  test('falls back to 1 January if 1 July is still in the future', () {
    final now = DateTime.utc(2024, 3, 1, 12);
    final resolved = ApproximateBirth.resolveCanonicalUtc(
      year: 2024,
      localOffset: Duration.zero,
      nowUtc: now,
    );
    expect(resolved, DateTime.utc(2024, 1, 1, 12));
  });

  test(
    'falls back to now if the whole selected year is still in the future',
    () {
      final now = DateTime.utc(2020, 6, 1);
      final resolved = ApproximateBirth.resolveCanonicalUtc(
        year: 2021,
        localOffset: Duration.zero,
        nowUtc: now,
      );
      expect(resolved, now);
    },
  );

  test('a full local date converts to UTC and is never in the future', () {
    final utc = ApproximateBirth.resolve(
      year: 1991,
      month: 8,
      day: 24,
      hour: 6,
      minute: 30,
      localOffset: const Duration(hours: 3),
      nowUtc: DateTime.utc(2026, 9, 5),
    );
    expect(utc, DateTime.utc(1991, 8, 24, 3, 30));
  });

  test('supported years are 1900 through the current year', () {
    expect(ApproximateBirth.isSupportedYear(1899, 2026), isFalse);
    expect(ApproximateBirth.isSupportedYear(1900, 2026), isTrue);
    expect(ApproximateBirth.isSupportedYear(2026, 2026), isTrue);
    expect(ApproximateBirth.isSupportedYear(2027, 2026), isFalse);
  });
}
