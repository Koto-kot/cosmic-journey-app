import 'package:flutter/material.dart';

import '../services/local_storage/locale_store.dart';

/// Persisted UI locale. Same idea as CardMedic: one tap rewrites every string.
class LocaleController extends ChangeNotifier {
  LocaleController({
    required this.store,
    String? storedCode,
    Locale? deviceLocale,
  }) : locale = resolve(storedCode: storedCode, deviceLocale: deviceLocale);

  static const english = Locale('en');
  static const ukrainian = Locale('uk');
  static const supported = [english, ukrainian];

  final LocaleStore store;

  Locale locale;

  static Locale resolve({required String? storedCode, Locale? deviceLocale}) {
    final stored = fromCode(storedCode);
    if (stored != null) {
      return stored;
    }
    return fromCode(deviceLocale?.languageCode) ?? english;
  }

  static Locale? fromCode(String? code) {
    if (code == 'uk') {
      return ukrainian;
    }
    if (code == 'en') {
      return english;
    }
    return null;
  }

  Future<void> setLocale(Locale next) async {
    final resolved = fromCode(next.languageCode) ?? english;
    if (resolved == locale) {
      return;
    }
    locale = resolved;
    notifyListeners();
    await store.saveLanguageCode(resolved.languageCode);
  }
}
