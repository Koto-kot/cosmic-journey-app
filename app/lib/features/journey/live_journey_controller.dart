import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../../core/clock.dart';
import '../../core/readout/readout_mode.dart';
import '../../services/journey_calculator/journey_calculator.dart';
import '../../services/journey_calculator/journey_profile.dart';
import '../../services/journey_calculator/journey_snapshot.dart';

/// Owns the live ticker. Pulse publishes one snapshot per second. Flow
/// recalculates every frame so kilometres and seconds move on screen.
///
/// Widgets must not compute distance or elapsed time themselves.
class LiveJourneyController extends ChangeNotifier {
  LiveJourneyController({
    required this.clock,
    required this.calculator,
    required this.profile,
    this.pulseEvery = const Duration(seconds: 1),
    this.mode = ReadoutMode.pulse,
  });

  final Clock clock;
  final JourneyCalculator calculator;
  final JourneyProfile profile;
  final Duration pulseEvery;
  ReadoutMode mode;

  Ticker? _ticker;
  JourneySnapshot? _base;
  bool _paused = true;
  bool reducedMotion = false;
  int pulseEpoch = 0;

  JourneySnapshot get snapshot => _base ?? _calculateNow();

  bool get isPaused => _paused;

  void setMode(ReadoutMode next) {
    if (mode == next) {
      return;
    }
    mode = next;
    _pulse(initial: true);
    notifyListeners();
  }

  void start(TickerProvider vsync) {
    _ticker?.dispose();
    _pulse(initial: true);
    _paused = false;
    _ticker = vsync.createTicker(_onTick)..start();
    notifyListeners();
  }

  void pause() {
    if (_paused) {
      return;
    }
    _paused = true;
    _ticker?.stop();
    notifyListeners();
  }

  /// Recalculate from wall-clock time, then restart the ticker.
  void resume() {
    _pulse(initial: true);
    _paused = false;
    if (_ticker != null && !_ticker!.isActive) {
      _ticker!.start();
    }
    notifyListeners();
  }

  void setReducedMotion(bool value) {
    if (reducedMotion == value) {
      return;
    }
    reducedMotion = value;
    notifyListeners();
  }

  @visibleForTesting
  void reconcileNow() {
    _pulse(initial: true);
    notifyListeners();
  }

  void _onTick(Duration elapsed) {
    if (_paused) {
      return;
    }
    if (mode == ReadoutMode.flow) {
      _base = _calculateNow();
      notifyListeners();
      return;
    }
    final now = clock.now();
    final last = _base?.calculatedAt;
    if (last != null && now.difference(last) < pulseEvery) {
      return;
    }
    _pulse();
    notifyListeners();
  }

  void _pulse({bool initial = false}) {
    _base = _calculateNow();
    if (!initial && mode == ReadoutMode.pulse) {
      pulseEpoch += 1;
    }
  }

  JourneySnapshot _calculateNow() {
    return calculator.calculate(at: clock.now(), profile: profile);
  }

  @override
  void dispose() {
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;
    super.dispose();
  }
}
