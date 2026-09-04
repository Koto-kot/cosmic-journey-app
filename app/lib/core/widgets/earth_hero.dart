import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme_tokens.dart';
import 'earth_orbit_bytes.dart';

class EarthHero extends StatelessWidget {
  const EarthHero({super.key, this.size = 196});

  final double size;

  @override
  Widget build(BuildContext context) {
    Widget image;
    try {
      image = Image.memory(
        EarthOrbitAsset.bytes,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        gaplessPlayback: true,
        semanticLabel: 'Earth',
        errorBuilder: (context, error, stack) => _fallback(),
      );
    } catch (_) {
      image = _fallback();
    }
    return SizedBox(width: size, height: size, child: image);
  }

  Widget _fallback() {
    return CustomPaint(size: Size(size, size), painter: EarthFallbackPainter());
  }
}

class EarthFallbackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.28;

    final glow = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18)
      ..color = CosmicTokens.accent.withValues(alpha: 0.22);
    canvas.drawCircle(center + Offset(-radius * 0.35, 0), radius * 1.05, glow);

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
      ..strokeWidth = 3
      ..shader = SweepGradient(
        colors: [
          CosmicTokens.accent.withValues(alpha: 0),
          CosmicTokens.accent.withValues(alpha: 0.95),
          CosmicTokens.accent.withValues(alpha: 0),
          Colors.transparent,
        ],
        stops: const [0.05, 0.22, 0.38, 1],
        transform: const GradientRotation(-0.4),
      ).createShader(globeRect);
    canvas.drawCircle(center, radius + 1.5, atmosphere);

    _paintRing(canvas, center, radius * 1.55);
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

  void _paintRing(Canvas canvas, Offset center, double ringRadius) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-0.52);
    canvas.scale(1, 0.36);
    final rect = Rect.fromCircle(center: Offset.zero, radius: ringRadius);
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6)
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          CosmicTokens.accent.withValues(alpha: 0.15),
          CosmicTokens.accent,
          CosmicTokens.accent.withValues(alpha: 0.2),
          Colors.transparent,
        ],
        stops: const [0.05, 0.28, 0.48, 0.62, 0.85],
      ).createShader(rect);
    final core = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
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
