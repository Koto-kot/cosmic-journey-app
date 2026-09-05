import 'package:shared_preferences/shared_preferences.dart';

abstract class ReadoutModeStore {
  Future<String?> loadModeId();

  Future<void> saveModeId(String id);
}

class SharedPreferencesReadoutModeStore implements ReadoutModeStore {
  SharedPreferencesReadoutModeStore(this._prefs);

  static const key = 'readout_mode_v1';

  final SharedPreferences _prefs;

  @override
  Future<String?> loadModeId() async {
    final value = _prefs.getString(key);
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  @override
  Future<void> saveModeId(String id) async {
    await _prefs.setString(key, id);
  }
}

class InMemoryReadoutModeStore implements ReadoutModeStore {
  InMemoryReadoutModeStore([this._modeId]);

  String? _modeId;

  @override
  Future<String?> loadModeId() async => _modeId;

  @override
  Future<void> saveModeId(String id) async {
    _modeId = id;
  }
}
