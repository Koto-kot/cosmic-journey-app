import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme_tokens.dart';

/// Painted globe used on iOS/Android, tests, Share, and as a web fallback.
class EarthFallbackGlobe extends StatefulWidget {
  const EarthFallbackGlobe({
    super.key,
    required this.size,
    required this.reducedMotion,
  });

  final double size;
  final bool reducedMotion;

  @override
  State<EarthFallbackGlobe> createState() => _EarthFallbackGlobeState();
}

class _EarthFallbackGlobeState extends State<EarthFallbackGlobe>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120),
    );
    if (!widget.reducedMotion) {
      _spin.repeat();
    }
  }

  @override
  void didUpdateWidget(EarthFallbackGlobe oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reducedMotion) {
      _spin.stop();
      _spin.value = 0;
    } else if (!_spin.isAnimating) {
      _spin.repeat();
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Size(widget.size, widget.size);
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _spin,
            builder: (context, child) {
              return Transform.rotate(
                angle: widget.reducedMotion ? 0 : _spin.value * 2 * math.pi,
                child: child,
              );
            },
            child: CustomPaint(size: size, painter: EarthGlobePainter()),
          ),
          CustomPaint(size: size, painter: EarthRingPainter()),
        ],
      ),
    );
  }
}

class EarthGlobePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.26;

    final glow = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14)
      ..color = CosmicTokens.accent.withValues(alpha: 0.16);
    canvas.drawCircle(center + Offset(-radius * 0.32, 0), radius * 1.02, glow);

    final globeRect = Rect.fromCircle(center: center, radius: radius);
    final globe = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.55, -0.1),
        radius: 1.05,
        colors: [
          Color(0xFF7EC8FF),
          Color(0xFF163A66),
          Color(0xFF070B12),
          Color(0xFF020308),
        ],
        stops: [0.0, 0.38, 0.72, 1],
      ).createShader(globeRect);
    canvas.drawCircle(center, radius, globe);

    final night = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.55, 0.1),
        radius: 0.85,
        colors: [
          const Color(0xFF020308).withValues(alpha: 0.05),
          const Color(0xFF020308).withValues(alpha: 0.82),
        ],
      ).createShader(globeRect);
    canvas.drawCircle(center, radius, night);

    final continent = Paint()
      ..color = const Color(0xFF1A2A22).withValues(alpha: 0.55);
    _continentBlob(canvas, center, radius, continent);

    final lights = Paint()..color = const Color(0xFFFFE7A3);
    final random = math.Random(42);
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );
    for (var i = 0; i < 70; i++) {
      final ang = random.nextDouble() * math.pi * 2;
      final dist = random.nextDouble() * radius * 0.82;
      final pos = center + Offset(math.cos(ang) * dist, math.sin(ang) * dist);
      lights
        ..color = Color.fromRGBO(
          255,
          220,
          140,
          0.15 + random.nextDouble() * 0.55,
        )
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          0.4 + random.nextDouble(),
        );
      canvas.drawCircle(pos, 0.5 + random.nextDouble() * 0.8, lights);
    }
    canvas.restore();

    final atmosphere = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..shader = SweepGradient(
        colors: [
          CosmicTokens.accent.withValues(alpha: 0),
          CosmicTokens.accent.withValues(alpha: 0.7),
          CosmicTokens.accent.withValues(alpha: 0),
          Colors.transparent,
        ],
        stops: const [0.05, 0.22, 0.38, 1],
        transform: const GradientRotation(-0.4),
      ).createShader(globeRect);
    canvas.drawCircle(center, radius + 1.2, atmosphere);
  }

  void _continentBlob(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    final path = Path()
      ..addOval(
        Rect.fromCenter(
          center: center + Offset(-radius * 0.15, -radius * 0.05),
          width: radius * 0.7,
          height: radius * 0.95,
        ),
      )
      ..addOval(
        Rect.fromCenter(
          center: center + Offset(radius * 0.28, radius * 0.22),
          width: radius * 0.42,
          height: radius * 0.28,
        ),
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EarthRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.26;
    _paintRing(canvas, center, radius * 1.48);
  }

  void _paintRing(Canvas canvas, Offset center, double ringRadius) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-0.52);
    canvas.scale(1, 0.36);
    final rect = Rect.fromCircle(center: Offset.zero, radius: ringRadius);
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          CosmicTokens.accent.withValues(alpha: 0.1),
          CosmicTokens.accent.withValues(alpha: 0.55),
          CosmicTokens.accent.withValues(alpha: 0.12),
          Colors.transparent,
        ],
        stops: const [0.05, 0.28, 0.48, 0.62, 0.85],
      ).createShader(rect);
    final core = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          const Color(0xFFB8ECFF),
          CosmicTokens.accent,
          Colors.transparent,
        ],
        stops: const [0.18, 0.4, 0.52, 0.78],
      ).createShader(rect);
    canvas.drawOval(rect, glow);
    canvas.drawOval(rect, core);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
