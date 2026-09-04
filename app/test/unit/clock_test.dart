import 'package:cosmic_journey/core/clock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FakeClock stores and returns UTC', () {
    final clock = FakeClock(DateTime(2024, 1, 1, 12));
    expect(clock.now().isUtc, isTrue);
  });

  test('FakeClock.advance moves the instant forward', () {
    final clock = FakeClock(DateTime.utc(2024, 1, 1));
    clock.advance(const Duration(days: 2, hours: 3));
    expect(clock.now(), DateTime.utc(2024, 1, 3, 3));
  });

  test('SystemClock returns a UTC instant near wall time', () {
    const clock = SystemClock();
    final before = DateTime.now().toUtc().subtract(const Duration(seconds: 1));
    final now = clock.now();
    final after = DateTime.now().toUtc().add(const Duration(seconds: 1));
    expect(now.isUtc, isTrue);
    expect(now.isAfter(before), isTrue);
    expect(now.isBefore(after), isTrue);
  });
}
