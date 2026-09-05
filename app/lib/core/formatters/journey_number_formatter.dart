import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Formats the huge live values shown on the main screen.
///
/// Grouping uses a narrow no-break space so numbers do not wrap mid-value.
/// Decimal separators and human-scale words follow the active locale.
class JourneyNumberFormatter {
  const JourneyNumberFormatter({
    this.decimalSeparator = '.',
    this.groupingSeparator = '\u202F',
    this.thousandLabel = 'thousand',
    this.millionLabel = 'million',
    this.billionLabel = 'billion',
    this.trillionLabel = 'trillion',
  });

  factory JourneyNumberFormatter.fromLocale(Locale locale) {
    if (locale.languageCode == 'uk') {
      return const JourneyNumberFormatter(
        decimalSeparator: ',',
        thousandLabel: 'тис.',
        millionLabel: 'млн',
        billionLabel: 'млрд',
        trillionLabel: 'трлн',
      );
    }
    return const JourneyNumberFormatter();
  }

  final String decimalSeparator;
  final String groupingSeparator;
  final String thousandLabel;
  final String millionLabel;
  final String billionLabel;
  final String trillionLabel;

  /// Full grouped integer, e.g. `702 673 018 501`.
  String formatFullNumber(num value) {
    final negative = value.isNegative && value != 0;
    final grouped = _groupInteger(value.round().abs().toString());
    return negative ? '-$grouped' : grouped;
  }

  /// Compact scale, e.g. `702.7 billion` / `702,7 млрд`.
  String formatHumanScale(num value) {
    final negative = value.isNegative && value != 0;
    final abs = value.abs().toDouble();
    final sign = negative ? '-' : '';
    if (!abs.isFinite) {
      return '${sign}0';
    }
    if (abs < 1000) {
      return '$sign${formatFullNumber(abs)}';
    }
    final scales = <(double, String)>[
      (1e12, trillionLabel),
      (1e9, billionLabel),
      (1e6, millionLabel),
      (1e3, thousandLabel),
    ];
    for (final (threshold, label) in scales) {
      if (abs >= threshold) {
        final scaled = abs / threshold;
        final digits = scaled < 10 ? 2 : 1;
        return '$sign${_plainFixed(scaled, digits)} $label';
      }
    }
    return '$sign${formatFullNumber(abs)}';
  }

  String distanceKm(num value, {int fractionDigits = 0}) {
    if (fractionDigits == 0) {
      return formatFullNumber(value);
    }
    return formatFixed(value.toDouble(), fractionDigits: fractionDigits);
  }

  String days(int value) => formatFullNumber(value);

  String seconds(num value, {int fractionDigits = 0}) {
    if (fractionDigits == 0) {
      return formatFullNumber(value);
    }
    return formatFixed(value.toDouble(), fractionDigits: fractionDigits);
  }

  /// Compact form for later widgets/share cards.
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

  String compact(num value) => formatHumanScale(value);

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

  String _plainFixed(double value, int fractionDigits) {
    final factor = math.pow(10, fractionDigits).toInt();
    final rounded = (value * factor).round();
    final whole = rounded ~/ factor;
    final fraction = (rounded % factor).toString().padLeft(fractionDigits, '0');
    return '$whole$decimalSeparator$fraction';
  }
}
