import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../../core/clock.dart';
import '../../services/journey_calculator/journey_calculator.dart';
import '../../services/journey_calculator/journey_profile.dart';
import '../../services/journey_calculator/journey_snapshot.dart';
import '../../services/journey_calculator/live_journey_interpolator.dart';

/// Owns the live ticker and snapshot interpolation.
///
/// Widgets must not compute distance or elapsed time themselves.
class LiveJourneyController extends ChangeNotifier {
  LiveJourneyController({
    required this.clock,
    required this.calculator,
    required this.profile,
    this.interpolator = const LiveJourneyInterpolator(),
    this.reconcileEvery = const Duration(seconds: 5),
  });

  final Clock clock;
  final JourneyCalculator calculator;
  final JourneyProfile profile;
  final LiveJourneyInterpolator interpolator;
  final Duration reconcileEvery;

  Ticker? _ticker;
  JourneySnapshot? _base;
  bool _paused = true;
  bool reducedMotion = false;
  DateTime? _lastReducedNotifyAt;

  JourneySnapshot get snapshot {
    final base = _base;
    if (base == null) {
      return _calculateNow();
    }
    if (_paused) {
      return base;
    }
    return interpolator.interpolate(base: base, now: clock.now());
  }

  bool get isPaused => _paused;

  void start(TickerProvider vsync) {
    _ticker?.dispose();
    _reconcile();
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
    _reconcile();
    _paused = false;
    _lastReducedNotifyAt = null;
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
    _reconcile();
    notifyListeners();
  }

  void _onTick(Duration elapsed) {
    if (_paused) {
      return;
    }
    final now = clock.now();
    if (reducedMotion) {
      final last = _lastReducedNotifyAt;
      if (last != null && now.difference(last) < const Duration(seconds: 1)) {
        return;
      }
      _lastReducedNotifyAt = now;
    }
    if (now.difference(_base!.calculatedAt) >= reconcileEvery) {
      _reconcile();
    }
    notifyListeners();
  }

  void _reconcile() {
    _base = _calculateNow();
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
