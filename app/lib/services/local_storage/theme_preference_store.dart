import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemePreferenceStore {
  Future<String?> loadPaletteId();

  Future<void> savePaletteId(String id);
}

class SharedPreferencesThemePreferenceStore implements ThemePreferenceStore {
  SharedPreferencesThemePreferenceStore(this._prefs);

  static const key = 'cosmic_palette_id_v1';

  final SharedPreferences _prefs;

  @override
  Future<String?> loadPaletteId() async {
    final value = _prefs.getString(key);
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  @override
  Future<void> savePaletteId(String id) async {
    await _prefs.setString(key, id);
  }
}

class InMemoryThemePreferenceStore implements ThemePreferenceStore {
  InMemoryThemePreferenceStore([this._paletteId]);

  String? _paletteId;

  @override
  Future<String?> loadPaletteId() async => _paletteId;

  @override
  Future<void> savePaletteId(String id) async {
    _paletteId = id;
  }
}
