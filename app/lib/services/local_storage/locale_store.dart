import 'package:shared_preferences/shared_preferences.dart';

abstract class LocaleStore {
  Future<String?> loadLanguageCode();

  Future<void> saveLanguageCode(String languageCode);
}

class SharedPreferencesLocaleStore implements LocaleStore {
  SharedPreferencesLocaleStore(this._prefs);

  static const key = 'app_locale_v1';

  final SharedPreferences _prefs;

  @override
  Future<String?> loadLanguageCode() async {
    final value = _prefs.getString(key);
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  @override
  Future<void> saveLanguageCode(String languageCode) async {
    await _prefs.setString(key, languageCode);
  }
}

class InMemoryLocaleStore implements LocaleStore {
  InMemoryLocaleStore([this._languageCode]);

  String? _languageCode;

  @override
  Future<String?> loadLanguageCode() async => _languageCode;

  @override
  Future<void> saveLanguageCode(String languageCode) async {
    _languageCode = languageCode;
  }
}
