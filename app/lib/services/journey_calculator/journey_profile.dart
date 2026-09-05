import 'package:flutter/foundation.dart';

import '../../core/time/approximate_birth.dart';

/// Locally stored birth profile. Distance is never persisted; it is derived.
@immutable
class JourneyProfile {
  const JourneyProfile({
    required this.birthYear,
    required this.canonicalBirthUtc,
    required this.isApproximate,
    required this.createdAt,
    required this.updatedAt,
    this.birthMonth,
    this.birthDay,
    this.birthHour,
    this.birthMinute,
  });

  final int birthYear;
  final int? birthMonth;
  final int? birthDay;
  final int? birthHour;
  final int? birthMinute;
  final DateTime canonicalBirthUtc;
  final bool isApproximate;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get hasDate => birthMonth != null && birthDay != null;

  bool get hasTime => birthHour != null && birthMinute != null;

  factory JourneyProfile.approximateYear({
    required int year,
    required DateTime nowUtc,
    required Duration localOffset,
  }) {
    return JourneyProfile.fromParts(
      year: year,
      nowUtc: nowUtc,
      localOffset: localOffset,
    );
  }

  factory JourneyProfile.fromParts({
    required int year,
    required DateTime nowUtc,
    required Duration localOffset,
    int? month,
    int? day,
    int? hour,
    int? minute,
    DateTime? createdAt,
  }) {
    final now = nowUtc.toUtc();
    final hasDate = month != null && day != null;
    final hasTime = hour != null && minute != null;
    final resolvedMonth = hasDate ? month : null;
    final resolvedDay = hasDate
        ? day.clamp(1, ApproximateBirth.daysInMonth(year, month))
        : null;
    return JourneyProfile(
      birthYear: year,
      birthMonth: resolvedMonth,
      birthDay: resolvedDay,
      birthHour: hasDate && hasTime ? hour : null,
      birthMinute: hasDate && hasTime ? minute : null,
      canonicalBirthUtc: ApproximateBirth.resolve(
        year: year,
        month: resolvedMonth,
        day: resolvedDay,
        hour: hasDate ? (hour ?? ApproximateBirth.localHour) : null,
        minute: hasDate ? (minute ?? ApproximateBirth.localMinute) : null,
        localOffset: localOffset,
        nowUtc: now,
      ),
      isApproximate: !(hasDate && hasTime),
      createdAt: createdAt?.toUtc() ?? now,
      updatedAt: now,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'birthYear': birthYear,
      'birthMonth': birthMonth,
      'birthDay': birthDay,
      'birthHour': birthHour,
      'birthMinute': birthMinute,
      'canonicalBirthUtc': canonicalBirthUtc.toUtc().toIso8601String(),
      'isApproximate': isApproximate,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  static JourneyProfile? tryFromJson(Map<String, Object?> json) {
    final year = json['birthYear'];
    final canonical = json['canonicalBirthUtc'];
    final approximate = json['isApproximate'];
    final created = json['createdAt'];
    final updated = json['updatedAt'];
    if (year is! int ||
        canonical is! String ||
        approximate is! bool ||
        created is! String ||
        updated is! String) {
      return null;
    }
    final canonicalUtc = DateTime.tryParse(canonical)?.toUtc();
    final createdAt = DateTime.tryParse(created)?.toUtc();
    final updatedAt = DateTime.tryParse(updated)?.toUtc();
    if (canonicalUtc == null || createdAt == null || updatedAt == null) {
      return null;
    }
    if (!ApproximateBirth.isSupportedYear(year, 3000)) {
      return null;
    }
    return JourneyProfile(
      birthYear: year,
      birthMonth: _readInt(json['birthMonth']),
      birthDay: _readInt(json['birthDay']),
      birthHour: _readInt(json['birthHour']),
      birthMinute: _readInt(json['birthMinute']),
      canonicalBirthUtc: canonicalUtc,
      isApproximate: approximate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static int? _readInt(Object? value) {
    if (value is int) {
      return value;
    }
    return null;
  }
}
