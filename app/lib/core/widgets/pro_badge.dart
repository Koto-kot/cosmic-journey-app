import 'package:flutter/material.dart';

import '../theme_tokens.dart';

class ProBadge extends StatelessWidget {
  const ProBadge({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 22.0 : 28.0;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: CosmicTokens.accent.withValues(alpha: 0.7)),
      ),
      child: Text(
        'PRO',
        style: TextStyle(
          color: CosmicTokens.accent,
          fontSize: compact ? 6 : 7,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
