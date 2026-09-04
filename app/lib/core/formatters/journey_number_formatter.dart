import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Formats the huge live values shown on the main screen.
///
/// Grouping uses a narrow no-break space so numbers do not wrap mid-value.
/// Decimal separators follow the active locale.
class JourneyNumberFormatter {
  const JourneyNumberFormatter({
    this.decimalSeparator = '.',
    this.groupingSeparator = '\u202F',
  });

  factory JourneyNumberFormatter.fromLocale(Locale locale) {
    if (locale.languageCode == 'uk') {
      return const JourneyNumberFormatter(decimalSeparator: ',');
    }
    return const JourneyNumberFormatter();
  }

  final String decimalSeparator;
  final String groupingSeparator;

  String distanceKm(double value, {int fractionDigits = 3}) {
    return formatFixed(value, fractionDigits: fractionDigits);
  }

  String days(int value) => _groupInteger(_whole(value.toDouble()));

  String seconds(double value, {int fractionDigits = 3}) {
    return formatFixed(value, fractionDigits: fractionDigits);
  }

  /// Compact form for later widgets/share cards, e.g. `674.2B`.
  String speedKmPerSecond(double value, {int fractionDigits = 1}) {
    final formatted = formatFixed(value.abs(), fractionDigits: fractionDigits);
    return value < 0 ? '-$formatted' : '+$formatted';
  }

  String clockHms(Duration remaining) {
    final safe = remaining.isNegative ? Duration.zero : remaining;
    final hours = (safe.inHours % 24).toString().padLeft(2, '0');
    final minutes = (safe.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (safe.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String compact(double value, {int fractionDigits = 1}) {
    final abs = value.abs();
    final sign = value < 0 ? '-' : '';
    final suffixes = <(double, String)>[
      (1e12, 'T'),
      (1e9, 'B'),
      (1e6, 'M'),
      (1e3, 'K'),
    ];
    for (final (threshold, suffix) in suffixes) {
      if (abs >= threshold) {
        final scaled = abs / threshold;
        return '$sign${_plainFixed(scaled, fractionDigits)}$suffix';
      }
    }
    return '$sign${_plainFixed(abs, fractionDigits)}';
  }

  String formatFixed(double value, {required int fractionDigits}) {
    final negative = value.isNegative && value != 0;
    final abs = value.abs();
    final factor = math.pow(10, fractionDigits).toInt();
    final rounded = (abs * factor).round();
    final whole = rounded ~/ factor;
    final fraction = (rounded % factor).toString().padLeft(fractionDigits, '0');
    final grouped = _groupInteger(whole.toString());
    final sign = negative ? '-' : '';
    if (fractionDigits == 0) {
      return '$sign$grouped';
    }
    return '$sign$grouped$decimalSeparator$fraction';
  }

  String _groupInteger(String digits) {
    if (digits.length <= 3) {
      return digits;
    }
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(groupingSeparator);
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  String _whole(double value) => value.round().abs().toString();

  String _plainFixed(double value, int fractionDigits) {
    return value.toStringAsFixed(fractionDigits);
  }
}
