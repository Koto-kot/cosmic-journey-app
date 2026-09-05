import 'package:shared_preferences/shared_preferences.dart';

abstract class AudioPreferenceStore {
  Future<bool> loadEnabled();

  Future<void> saveEnabled(bool enabled);

  Future<String?> loadSoundscapeId();

  Future<void> saveSoundscapeId(String id);
}

class SharedPreferencesAudioPreferenceStore implements AudioPreferenceStore {
  SharedPreferencesAudioPreferenceStore(this._prefs);

  static const enabledKey = 'ambient_audio_enabled_v1';
  static const soundscapeKey = 'ambient_soundscape_id_v1';

  final SharedPreferences _prefs;

  @override
  Future<bool> loadEnabled() async => _prefs.getBool(enabledKey) ?? false;

  @override
  Future<void> saveEnabled(bool enabled) async {
    await _prefs.setBool(enabledKey, enabled);
  }

  @override
  Future<String?> loadSoundscapeId() async {
    final value = _prefs.getString(soundscapeKey);
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  @override
  Future<void> saveSoundscapeId(String id) async {
    await _prefs.setString(soundscapeKey, id);
  }
}

class InMemoryAudioPreferenceStore implements AudioPreferenceStore {
  InMemoryAudioPreferenceStore({this._enabled = false, this._soundscapeId});

  bool _enabled;
  String? _soundscapeId;

  @override
  Future<bool> loadEnabled() async => _enabled;

  @override
  Future<void> saveEnabled(bool enabled) async {
    _enabled = enabled;
  }

  @override
  Future<String?> loadSoundscapeId() async => _soundscapeId;

  @override
  Future<void> saveSoundscapeId(String id) async {
    _soundscapeId = id;
  }
}
