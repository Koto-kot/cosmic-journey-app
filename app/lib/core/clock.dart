/// Wall-clock source. Production uses the system clock; tests inject a fake.
abstract class Clock {
  DateTime now();
}

/// Returns the current instant as UTC.
class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now().toUtc();
}

/// Mutable clock for tests. Always stores and returns UTC.
class FakeClock implements Clock {
  FakeClock(DateTime now) : _now = now.toUtc();

  DateTime _now;

  @override
  DateTime now() => _now;

  void setNow(DateTime value) {
    _now = value.toUtc();
  }

  void advance(Duration duration) {
    _now = _now.add(duration);
  }
}
