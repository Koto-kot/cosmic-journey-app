import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme_tokens.dart';

class CosmicBackdrop extends StatelessWidget {
  const CosmicBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: CosmicTokens.background),
        const CustomPaint(
          painter: StarfieldPainter(),
          child: SizedBox.expand(),
        ),
        child,
      ],
    );
  }
}

class StarfieldPainter extends CustomPainter {
  const StarfieldPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final nebula = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.72),
        radius: 0.9,
        colors: [
          CosmicTokens.nebula.withValues(alpha: 0.55),
          CosmicTokens.background,
        ],
        stops: const [0, 1],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, nebula);

    final random = math.Random(370);
    final starPaint = Paint();
    for (var i = 0; i < 90; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 0.9 + 0.15;
      final alpha = 0.18 + random.nextDouble() * 0.55;
      starPaint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
