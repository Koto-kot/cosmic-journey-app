import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme_tokens.dart';

class GlowDivider extends StatelessWidget {
  const GlowDivider({super.key, this.glow = 0});

  /// 0–1 Cosmic Pulse intensity for the centre glow.
  final double glow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      width: double.infinity,
      child: CustomPaint(painter: _GlowDividerPainter(glow: glow)),
    );
  }
}

class _GlowDividerPainter extends CustomPainter {
  const _GlowDividerPainter({required this.glow});

  final double glow;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final lineWidth = size.width * 0.65;
    final left = (size.width - lineWidth) / 2;
    final line = Rect.fromLTWH(left, y - 0.5, lineWidth, 1);
    final fade = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          CosmicTokens.accent.withValues(alpha: 0.12),
          CosmicTokens.accent.withValues(alpha: 0.55 + 0.35 * glow),
          CosmicTokens.accent.withValues(alpha: 0.12),
          Colors.transparent,
        ],
        stops: const [0, 0.18, 0.5, 0.82, 1],
      ).createShader(line);
    canvas.drawRect(line, fade);

    final pulse = 0.28 + 0.55 * glow;
    final flare = Paint()
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6 + 4 * glow)
      ..shader =
          RadialGradient(
            colors: [
              CosmicTokens.accent.withValues(alpha: pulse),
              CosmicTokens.accent.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromCenter(
              center: Offset(size.width / 2, y),
              width: lineWidth * 0.38,
              height: 14,
            ),
          );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, y),
          width: lineWidth * 0.22,
          height: 8 + 4 * glow,
        ),
        const Radius.circular(99),
      ),
      flare,
    );
  }

  @override
  bool shouldRepaint(covariant _GlowDividerPainter oldDelegate) {
    return oldDelegate.glow != glow;
  }
}

/// Maps a 0–1 pulse animation into a soft rise-and-fall glow.
double pulseGlow(double t) => math.sin(math.pi * t.clamp(0.0, 1.0));
