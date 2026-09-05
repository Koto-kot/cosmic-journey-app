import 'package:shared_preferences/shared_preferences.dart';

abstract class MilestonePreferenceStore {
  Future<int?> loadCustomIntervalKm();

  Future<void> saveCustomIntervalKm(int? km);
}

class SharedPreferencesMilestonePreferenceStore
    implements MilestonePreferenceStore {
  SharedPreferencesMilestonePreferenceStore(this._prefs);

  static const key = 'custom_milestone_interval_km_v1';

  final SharedPreferences _prefs;

  @override
  Future<int?> loadCustomIntervalKm() async {
    return _prefs.getInt(key);
  }

  @override
  Future<void> saveCustomIntervalKm(int? km) async {
    if (km == null) {
      await _prefs.remove(key);
      return;
    }
    await _prefs.setInt(key, km);
  }
}

class InMemoryMilestonePreferenceStore implements MilestonePreferenceStore {
  InMemoryMilestonePreferenceStore([this._intervalKm]);

  int? _intervalKm;

  @override
  Future<int?> loadCustomIntervalKm() async => _intervalKm;

  @override
  Future<void> saveCustomIntervalKm(int? km) async {
    _intervalKm = km;
  }
}
