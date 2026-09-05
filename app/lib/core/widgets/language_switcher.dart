import 'package:cosmic_journey/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../app/locale_controller.dart';
import '../theme_tokens.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key, required this.controller});

  final LocaleController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final current = controller.locale.languageCode;
    return PopupMenuButton<Locale>(
      tooltip: l10n.languageTooltip,
      offset: const Offset(0, 40),
      color: CosmicTokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: CosmicTokens.hairline),
      ),
      onSelected: controller.setLocale,
      itemBuilder: (context) {
        return [
          _item(
            LocaleController.english,
            l10n.languageEnglish,
            current == 'en',
          ),
          _item(
            LocaleController.ukrainian,
            l10n.languageUkrainian,
            current == 'uk',
          ),
        ];
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language, size: 22, color: CosmicTokens.accent),
            const SizedBox(width: 6),
            Text(
              current == 'uk' ? l10n.languageUkrainian : l10n.languageEnglish,
              style: TextStyle(
                color: CosmicTokens.accent,
                fontSize: 13,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<Locale> _item(Locale locale, String label, bool selected) {
    return PopupMenuItem<Locale>(
      value: locale,
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: selected
                ? Icon(Icons.check, size: 16, color: CosmicTokens.accent)
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: selected ? CosmicTokens.accent : CosmicTokens.onBackground,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
