import 'package:cosmic_journey/services/journey_calculator/journey_profile.dart';
import 'package:cosmic_journey/services/local_storage/profile_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('round-trips a year-only profile through JSON', () {
    final original = JourneyProfile.approximateYear(
      year: 1994,
      nowUtc: DateTime.utc(2026, 9, 4),
      localOffset: const Duration(hours: 3),
    );
    final restored = JourneyProfile.tryFromJson(original.toJson());
    expect(restored, isNotNull);
    expect(restored!.birthYear, 1994);
    expect(restored.isApproximate, isTrue);
    expect(restored.canonicalBirthUtc, original.canonicalBirthUtc);
    expect(restored.canonicalBirthUtc.isUtc, isTrue);
  });

  test('corrupt JSON is treated as missing local state', () {
    expect(JourneyProfile.tryFromJson({'birthYear': 'nope'}), isNull);
    expect(JourneyProfile.tryFromJson({}), isNull);
  });

  test('in-memory store persists and can be cleared', () async {
    final store = InMemoryProfileStore();
    expect(await store.load(), isNull);
    final profile = JourneyProfile.approximateYear(
      year: 1988,
      nowUtc: DateTime.utc(2026, 1, 1),
      localOffset: Duration.zero,
    );
    await store.save(profile);
    expect((await store.load())!.birthYear, 1988);
    await store.clear();
    expect(await store.load(), isNull);
  });
}
