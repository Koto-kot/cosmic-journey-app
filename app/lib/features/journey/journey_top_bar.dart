import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/locale_controller.dart';
import '../../core/widgets/language_switcher.dart';

/// Shared top bar for every [JourneyStyle] view: menu on the left, locale on
/// the right, an optional short center label (Shuttle Cockpit's
/// "FLIGHT ACTIVE"). Purely presentational — no controller/timer of its own.
class JourneyTopBar extends StatelessWidget {
  const JourneyTopBar({
    super.key,
    required this.onMenuTap,
    required this.localeController,
    this.centerLabel,
  });

  final VoidCallback onMenuTap;
  final LocaleController localeController;
  final String? centerLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        IconButton(
          tooltip: l10n.menuTooltip,
          onPressed: onMenuTap,
          icon: const Icon(Icons.menu, size: 26),
        ),
        if (centerLabel != null)
          Expanded(
            child: Text(
              centerLabel!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          const Spacer(),
        LanguageSwitcher(controller: localeController),
      ],
    );
  }
}
