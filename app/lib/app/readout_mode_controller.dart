import 'package:flutter/material.dart';

import '../core/readout/readout_mode.dart';
import '../services/local_storage/readout_mode_store.dart';

class ReadoutModeController extends ChangeNotifier {
  ReadoutModeController({required this.store, String? storedId})
    : mode = ReadoutModeCodec.resolve(storedId);

  final ReadoutModeStore store;
  ReadoutMode mode;

  Future<void> setMode(ReadoutMode next) async {
    if (next == mode) {
      return;
    }
    mode = next;
    notifyListeners();
    await store.saveModeId(next.id);
  }
}
