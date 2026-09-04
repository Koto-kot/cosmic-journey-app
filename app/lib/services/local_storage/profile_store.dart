import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../journey_calculator/journey_profile.dart';

abstract class ProfileStore {
  Future<JourneyProfile?> load();

  Future<void> save(JourneyProfile profile);

  Future<void> clear();
}

class SharedPreferencesProfileStore implements ProfileStore {
  SharedPreferencesProfileStore(this._prefs);

  static const key = 'journey_profile_v1';

  final SharedPreferences _prefs;

  @override
  Future<JourneyProfile?> load() async {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return null;
      }
      return JourneyProfile.tryFromJson(decoded.cast<String, Object?>());
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> save(JourneyProfile profile) async {
    await _prefs.setString(key, jsonEncode(profile.toJson()));
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(key);
  }
}

class InMemoryProfileStore implements ProfileStore {
  InMemoryProfileStore([this._profile]);

  JourneyProfile? _profile;

  @override
  Future<JourneyProfile?> load() async => _profile;

  @override
  Future<void> save(JourneyProfile profile) async {
    _profile = profile;
  }

  @override
  Future<void> clear() async {
    _profile = null;
  }
}
