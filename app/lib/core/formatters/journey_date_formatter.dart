import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// Locale-aware date/time strings for birth precision and time-coordinate
/// display. Never hardcodes month names; delegates to `intl` per locale.
abstract final class JourneyDateFormatter {
  static var _symbolsReady = false;

  static void _ensureSymbols() {
    if (_symbolsReady) {
      return;
    }
    // Local data is in-memory; the Future completes immediately.
    initializeDateFormatting();
    _symbolsReady = true;
  }

  static DateFormat _format(String pattern, Locale locale) {
    _ensureSymbols();
    return DateFormat(pattern, locale.toString());
  }

  /// `01.04.1966` (uk) / `01 Apr 1966` (en). Renders in the device's local
  /// time zone, matching how the value was originally entered.
  static String date(DateTime utc, Locale locale) {
    final pattern = locale.languageCode == 'uk' ? 'dd.MM.yyyy' : 'dd MMM yyyy';
    return _format(pattern, locale).format(utc.toLocal());
  }

  /// `08:45`.
  static String time(DateTime utc, Locale locale) {
    return _format('HH:mm', locale).format(utc.toLocal());
  }

  /// `05.09.2026 · 14:21:07` (uk) / `05 Sep 2026 · 14:21:07` (en).
  static String dateTimeWithSeconds(DateTime utc, Locale locale) {
    final pattern = locale.languageCode == 'uk'
        ? 'dd.MM.yyyy · HH:mm:ss'
        : 'dd MMM yyyy · HH:mm:ss';
    return _format(pattern, locale).format(utc.toLocal());
  }

  /// `01.04.1966 · 08:45`.
  static String dateAndTime(DateTime utc, Locale locale) {
    return '${date(utc, locale)} · ${time(utc, locale)}';
  }
}
