import 'package:flutter/material.dart';

import 'cockpit_theme_tokens.dart';
import 'shuttle_starfield.dart';

/// The panoramic front window: a wide, gently perspectived pane framed in
/// dark graphite, deep space and a slow starfield behind the glass.
/// Deliberately generic — not a copy of a specific NASA cockpit (spec
/// section 8.2).
class ShuttleWindow extends StatelessWidget {
  const ShuttleWindow({
    super.key,
    required this.reducedMotion,
    this.height = 220,
  });

  final bool reducedMotion;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: CockpitTokens.windowFrame, width: 10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 24,
              spreadRadius: -6,
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: CockpitTokens.deepSpace),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 1.1,
                  colors: [
                    CockpitTokens.panelBackground.withValues(alpha: 0.0),
                    CockpitTokens.deepSpace,
                  ],
                ),
              ),
            ),
            ShuttleStarfield(reducedMotion: reducedMotion),
            // A faint inner bevel so the glass reads as a physical pane,
            // not a flat rectangle.
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
