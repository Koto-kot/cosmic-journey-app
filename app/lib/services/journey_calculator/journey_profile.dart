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
  });

  final int birthYear;
  final int? birthMonth;
  final int? birthDay;
  final DateTime canonicalBirthUtc;
  final bool isApproximate;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory JourneyProfile.approximateYear({
    required int year,
    required DateTime nowUtc,
    required Duration localOffset,
  }) {
    final now = nowUtc.toUtc();
    return JourneyProfile(
      birthYear: year,
      canonicalBirthUtc: ApproximateBirth.resolveCanonicalUtc(
        year: year,
        localOffset: localOffset,
        nowUtc: now,
      ),
      isApproximate: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'birthYear': birthYear,
      'birthMonth': birthMonth,
      'birthDay': birthDay,
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
      birthMonth: json['birthMonth'] as int?,
      birthDay: json['birthDay'] as int?,
      canonicalBirthUtc: canonicalUtc,
      isApproximate: approximate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
