import '../../core/formatters/journey_number_formatter.dart';
import '../journey_calculator/journey_snapshot.dart';

abstract final class JourneyShareText {
  static String plain({
    required JourneySnapshot snapshot,
    required JourneyNumberFormatter formatter,
    required String appTitle,
    required String kmLabel,
    required String daysLabel,
    required String secondsLabel,
  }) {
    final km = formatter.formatFullNumber(snapshot.wholeDistanceKm);
    final scale = formatter.formatHumanScale(snapshot.wholeDistanceKm);
    final days = formatter.days(snapshot.fullDays);
    final seconds = formatter.formatFullNumber(snapshot.wholeElapsedSeconds);
    return [
      appTitle,
      '$km $kmLabel',
      '≈ $scale $kmLabel',
      '$days $daysLabel',
      '$seconds $secondsLabel',
    ].join('\n');
  }
}
