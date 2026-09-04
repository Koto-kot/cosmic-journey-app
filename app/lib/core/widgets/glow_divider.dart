import 'package:flutter/material.dart';

import '../theme_tokens.dart';

class GlowDivider extends StatelessWidget {
  const GlowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 18,
      width: double.infinity,
      child: CustomPaint(painter: _GlowDividerPainter()),
    );
  }
}

class _GlowDividerPainter extends CustomPainter {
  const _GlowDividerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final line = Rect.fromLTWH(0, y - 0.5, size.width, 1);
    final fade = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          CosmicTokens.accent.withValues(alpha: 0.18),
          CosmicTokens.accent.withValues(alpha: 0.95),
          CosmicTokens.accent.withValues(alpha: 0.18),
          Colors.transparent,
        ],
        stops: const [0, 0.22, 0.5, 0.78, 1],
      ).createShader(line);
    canvas.drawRect(line, fade);

    final flare = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..shader =
          RadialGradient(
            colors: [
              CosmicTokens.accent.withValues(alpha: 0.85),
              CosmicTokens.accent.withValues(alpha: 0),
            ],
          ).createShader(
            Rect.fromCenter(
              center: Offset(size.width / 2, y),
              width: size.width * 0.42,
              height: 16,
            ),
          );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, y),
          width: size.width * 0.36,
          height: 10,
        ),
        const Radius.circular(99),
      ),
      flare,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
