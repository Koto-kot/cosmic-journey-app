import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Locale-aware date/time strings for birth precision and time-coordinate
/// display. Never hardcodes month names; delegates to `intl` per locale.
abstract final class JourneyDateFormatter {
  /// `01.04.1966` (uk) / `01 Apr 1966` (en). Renders in the device's local
  /// time zone, matching how the value was originally entered.
  static String date(DateTime utc, Locale locale) {
    final pattern = locale.languageCode == 'uk' ? 'dd.MM.yyyy' : 'dd MMM yyyy';
    return DateFormat(pattern, locale.toString()).format(utc.toLocal());
  }

  /// `08:45`.
  static String time(DateTime utc, Locale locale) {
    return DateFormat('HH:mm', locale.toString()).format(utc.toLocal());
  }

  /// `05.09.2026 · 14:21:07` (uk) / `05 Sep 2026 · 14:21:07` (en).
  static String dateTimeWithSeconds(DateTime utc, Locale locale) {
    final pattern = locale.languageCode == 'uk'
        ? 'dd.MM.yyyy · HH:mm:ss'
        : 'dd MMM yyyy · HH:mm:ss';
    return DateFormat(pattern, locale.toString()).format(utc.toLocal());
  }

  /// `01.04.1966 · 08:45`.
  static String dateAndTime(DateTime utc, Locale locale) {
    return '${date(utc, locale)} · ${time(utc, locale)}';
  }
}
