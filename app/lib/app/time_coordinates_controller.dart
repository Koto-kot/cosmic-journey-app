import 'package:flutter/foundation.dart';

import '../services/local_storage/time_coordinates_preference_store.dart';

/// Whether the optional, visually secondary start/now date-time block is
/// shown on the main screen. Defaults OFF (see ADR 0007).
class TimeCoordinatesController extends ChangeNotifier {
  TimeCoordinatesController({required this.store, bool storedEnabled = false})
    : enabled = storedEnabled;

  final TimeCoordinatesPreferenceStore store;
  bool enabled;

  Future<void> setEnabled(bool value) async {
    if (enabled == value) {
      return;
    }
    enabled = value;
    notifyListeners();
    await store.saveEnabled(value);
  }
}
