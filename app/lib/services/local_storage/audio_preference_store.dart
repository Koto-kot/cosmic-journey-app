import 'package:shared_preferences/shared_preferences.dart';

/// Default ambient bed volume. Kept low/ambient per the Codex audio spec
/// (recommended range 0.15-0.25).
const double defaultAmbientVolume = 0.2;

abstract class AudioPreferenceStore {
  Future<bool> loadEnabled();

  Future<void> saveEnabled(bool enabled);

  Future<String?> loadSoundscapeId();

  Future<void> saveSoundscapeId(String id);

  Future<double> loadVolume();

  Future<void> saveVolume(double volume);
}

class SharedPreferencesAudioPreferenceStore implements AudioPreferenceStore {
  SharedPreferencesAudioPreferenceStore(this._prefs);

  static const enabledKey = 'ambient_audio_enabled_v1';
  static const soundscapeKey = 'ambient_soundscape_id_v1';
  static const volumeKey = 'ambient_audio_volume_v1';

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

  @override
  Future<double> loadVolume() async =>
      _prefs.getDouble(volumeKey) ?? defaultAmbientVolume;

  @override
  Future<void> saveVolume(double volume) async {
    await _prefs.setDouble(volumeKey, volume);
  }
}

class InMemoryAudioPreferenceStore implements AudioPreferenceStore {
  InMemoryAudioPreferenceStore({
    this._enabled = false,
    this._soundscapeId,
    double volume = defaultAmbientVolume,
  }) : _volume = volume;

  bool _enabled;
  String? _soundscapeId;
  double _volume;

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

  @override
  Future<double> loadVolume() async => _volume;

  @override
  Future<void> saveVolume(double volume) async {
    _volume = volume;
  }
}
