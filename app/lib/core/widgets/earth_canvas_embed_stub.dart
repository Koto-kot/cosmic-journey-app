import 'package:flutter/widgets.dart';

import 'earth_fallback.dart';

Widget buildEarthCanvasEmbed({
  required double size,
  required bool reducedMotion,
}) {
  return EarthFallbackGlobe(size: size, reducedMotion: reducedMotion);
}
