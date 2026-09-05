import 'package:flutter/material.dart';

import '../entitlement/entitlement.dart';

/// Secondary-screen ad footer.
///
/// Renders nothing while [Entitlement.adsAllowed] is false. When ads go live,
/// only this widget should start a network. Never place it on the Pulse
/// screen, the year wheel, or a share sheet.
class AdSlot extends StatelessWidget {
  const AdSlot({super.key, required this.entitlement, this.placement = ''});

  final Entitlement entitlement;
  final String placement;

  @override
  Widget build(BuildContext context) {
    if (!entitlement.adsAllowed) {
      return const SizedBox.shrink();
    }
    // Phase 3 will load a real banner here. Keep the slot dark until then.
    return const SizedBox.shrink();
  }
}
