import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'earth_canvas_embed.dart';
import 'earth_fallback.dart';

/// Live-screen Earth: WebGL night globe on Flutter web, painted fallback
/// everywhere else.
///
/// A JPEG with a black rectangle is never used on the live screen.
class EarthHero extends StatelessWidget {
  const EarthHero({super.key, this.size = 168, this.webGl = true});

  final double size;

  /// When false, always use CustomPaint (Share, tests that want a still).
  final bool webGl;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final child = webGl && kIsWeb
        ? buildEarthCanvasEmbed(size: size, reducedMotion: reducedMotion)
        : EarthFallbackGlobe(size: size, reducedMotion: reducedMotion);
    return SizedBox(width: size, height: size, child: child);
  }
}
