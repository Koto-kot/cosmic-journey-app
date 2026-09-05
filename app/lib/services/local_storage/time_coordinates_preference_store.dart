import 'package:shared_preferences/shared_preferences.dart';

abstract class TimeCoordinatesPreferenceStore {
  Future<bool> loadEnabled();

  Future<void> saveEnabled(bool enabled);
}

class SharedPreferencesTimeCoordinatesPreferenceStore
    implements TimeCoordinatesPreferenceStore {
  SharedPreferencesTimeCoordinatesPreferenceStore(this._prefs);

  static const key = 'show_time_coordinates_v1';

  final SharedPreferences _prefs;

  @override
  Future<bool> loadEnabled() async => _prefs.getBool(key) ?? false;

  @override
  Future<void> saveEnabled(bool enabled) async {
    await _prefs.setBool(key, enabled);
  }
}

class InMemoryTimeCoordinatesPreferenceStore
    implements TimeCoordinatesPreferenceStore {
  InMemoryTimeCoordinatesPreferenceStore([this._enabled = false]);

  bool _enabled;

  @override
  Future<bool> loadEnabled() async => _enabled;

  @override
  Future<void> saveEnabled(bool enabled) async {
    _enabled = enabled;
  }
}
