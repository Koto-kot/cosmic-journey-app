import 'package:shared_preferences/shared_preferences.dart';

abstract class JourneyStyleStore {
  Future<String?> loadStyleId();

  Future<void> saveStyleId(String id);
}

class SharedPreferencesJourneyStyleStore implements JourneyStyleStore {
  SharedPreferencesJourneyStyleStore(this._prefs);

  static const key = 'journey_style_v1';

  final SharedPreferences _prefs;

  @override
  Future<String?> loadStyleId() async => _prefs.getString(key);

  @override
  Future<void> saveStyleId(String id) async {
    await _prefs.setString(key, id);
  }
}

class InMemoryJourneyStyleStore implements JourneyStyleStore {
  InMemoryJourneyStyleStore([this._id]);

  String? _id;

  @override
  Future<String?> loadStyleId() async => _id;

  @override
  Future<void> saveStyleId(String id) async {
    _id = id;
  }
}
