import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Slow, three-layer starfield radiating outward from a central vanishing
/// point — the feeling of drifting forward, never warp speed. No streaks,
/// no meteors, no lens flare (spec section 9).
class ShuttleStarfield extends StatefulWidget {
  const ShuttleStarfield({super.key, required this.reducedMotion});

  final bool reducedMotion;

  @override
  State<ShuttleStarfield> createState() => _ShuttleStarfieldState();
}

class _ShuttleStarfieldState extends State<ShuttleStarfield>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static const _fullCycle = Duration(seconds: 46);
  static const _reducedMotionCycle = Duration(seconds: 46 * 8);

  late final AnimationController _controller;
  late final List<_Star> _farStars;
  late final List<_Star> _midStars;
  late final List<_Star> _nearStars;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(
      vsync: this,
      duration: widget.reducedMotion ? _reducedMotionCycle : _fullCycle,
    )..repeat();
    final random = math.Random(370);
    // Far: tiny, dim, dense. Mid: a bit larger/brighter. Near: sparse
    // highlights only — never streaks (spec section 9).
    _farStars = _Star.generate(
      random,
      count: 70,
      speed: 0.55,
      maxOpacity: 0.32,
    );
    _midStars = _Star.generate(random, count: 34, speed: 0.8, maxOpacity: 0.5);
    _nearStars = _Star.generate(
      random,
      count: 10,
      speed: 1.15,
      maxOpacity: 0.75,
    );
  }

  @override
  void didUpdateWidget(covariant ShuttleStarfield oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reducedMotion != widget.reducedMotion) {
      _controller.stop();
      _controller.duration = widget.reducedMotion
          ? _reducedMotionCycle
          : _fullCycle;
      _controller.repeat();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!_controller.isAnimating) {
          _controller.repeat();
        }
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _controller.stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _StarfieldPainter(
            progress: _controller.value,
            farStars: _farStars,
            midStars: _midStars,
            nearStars: _nearStars,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _Star {
  const _Star({
    required this.angle,
    required this.phase,
    required this.radiusScale,
    required this.speed,
    required this.maxOpacity,
  });

  /// Direction from the vanishing point, in radians.
  final double angle;

  /// Phase offset (0..1) so stars in one layer don't all respawn together.
  final double phase;

  /// Per-star size multiplier, 0.6..1.4 of its layer's base radius.
  final double radiusScale;
  final double speed;
  final double maxOpacity;

  static List<_Star> generate(
    math.Random random, {
    required int count,
    required double speed,
    required double maxOpacity,
  }) {
    return [
      for (var i = 0; i < count; i++)
        _Star(
          angle: random.nextDouble() * math.pi * 2,
          phase: random.nextDouble(),
          radiusScale: 0.6 + random.nextDouble() * 0.8,
          speed: speed,
          maxOpacity: maxOpacity,
        ),
    ];
  }
}

class _StarfieldPainter extends CustomPainter {
  const _StarfieldPainter({
    required this.progress,
    required this.farStars,
    required this.midStars,
    required this.nearStars,
  });

  final double progress;
  final List<_Star> farStars;
  final List<_Star> midStars;
  final List<_Star> nearStars;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.4);
    final maxRadius = size.longestSide * 0.62;
    final paint = Paint();
    _paintLayer(canvas, farStars, center, maxRadius, 0.9, paint);
    _paintLayer(canvas, midStars, center, maxRadius, 1.4, paint);
    _paintLayer(canvas, nearStars, center, maxRadius, 2.0, paint);
  }

  void _paintLayer(
    Canvas canvas,
    List<_Star> stars,
    Offset center,
    double maxRadius,
    double baseRadius,
    Paint paint,
  ) {
    for (final star in stars) {
      final t = (progress * star.speed + star.phase) % 1.0;
      final radius = t * maxRadius;
      // Fade in near the vanishing point, fade out near the window edge —
      // avoids a pop-in/pop-out at either end of the travel.
      final envelope = math.sin(t * math.pi).clamp(0.0, 1.0);
      final offset =
          center + Offset(math.cos(star.angle), math.sin(star.angle)) * radius;
      paint.color = Colors.white.withValues(alpha: star.maxOpacity * envelope);
      canvas.drawCircle(offset, baseRadius * star.radiusScale, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
