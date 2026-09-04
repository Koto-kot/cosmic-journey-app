import '../science_constants.dart';

/// Year-only birth convention used in Milestone 1.
///
/// Product spec: if only a year is known, use 1 July, 12:00 local time at
/// setup, convert to a canonical UTC timestamp, and mark the profile as
/// approximate.
abstract final class ApproximateBirth {
  static const int midYearMonth = 7;
  static const int midYearDay = 1;
  static const int localHour = 12;
  static const int localMinute = 0;

  /// Converts a local civil time to UTC using a fixed offset.
  ///
  /// [localOffset] is the offset of the user's local zone at setup
  /// (`DateTime.now().timeZoneOffset`).
  static DateTime canonicalUtc({
    required int year,
    required Duration localOffset,
    int month = midYearMonth,
    int day = midYearDay,
    int hour = localHour,
    int minute = localMinute,
  }) {
    final localAsUtc = DateTime.utc(year, month, day, hour, minute);
    return localAsUtc.subtract(localOffset);
  }

  /// Resolves a year-only birth to a UTC instant that is never in the future.
  ///
  /// Fallback order:
  /// 1. 1 July 12:00 local
  /// 2. 1 January 12:00 local
  /// 3. 1 January 00:00 local
  /// 4. [nowUtc]
  static DateTime resolveCanonicalUtc({
    required int year,
    required Duration localOffset,
    required DateTime nowUtc,
  }) {
    final now = nowUtc.toUtc();
    final candidates = <DateTime>[
      canonicalUtc(year: year, localOffset: localOffset),
      canonicalUtc(year: year, localOffset: localOffset, month: 1, day: 1),
      canonicalUtc(
        year: year,
        localOffset: localOffset,
        month: 1,
        day: 1,
        hour: 0,
        minute: 0,
      ),
    ];
    for (final candidate in candidates) {
      if (!candidate.isAfter(now)) {
        return candidate;
      }
    }
    return now;
  }

  static bool isSupportedYear(int year, int currentYear) {
    return year >= ScienceConstants.earliestSupportedBirthYear &&
        year <= currentYear;
  }
}
