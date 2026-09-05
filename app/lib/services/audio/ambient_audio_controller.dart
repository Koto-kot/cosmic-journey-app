import 'package:flutter/widgets.dart';

import '../local_storage/audio_preference_store.dart';
import 'soundscape.dart';

/// Optional ambient bed. The live screen only toggles on/off; Pro can later
/// call [setSoundscape] without rewriting Cosmic Pulse.
abstract class AmbientAudioController extends ChangeNotifier {
  bool get enabled;

  String get soundscapeId;

  Future<void> setEnabled(bool value);

  Future<void> setSoundscape(String id);

  Future<void> handleLifecycle(AppLifecycleState state);
}

class SilentAmbientAudioController extends AmbientAudioController {
  SilentAmbientAudioController({
    AudioPreferenceStore? store,
    bool enabled = false,
    String? soundscapeId,
  }) : _store = store ?? InMemoryAudioPreferenceStore(enabled: enabled),
       _enabled = enabled,
       _soundscapeId = SoundscapeCatalog.resolve(soundscapeId).id;

  final AudioPreferenceStore _store;
  bool _enabled;
  String _soundscapeId;

  @override
  bool get enabled => _enabled;

  @override
  String get soundscapeId => _soundscapeId;

  @override
  Future<void> setEnabled(bool value) async {
    if (_enabled == value) {
      return;
    }
    _enabled = value;
    notifyListeners();
    await _store.saveEnabled(value);
  }

  @override
  Future<void> setSoundscape(String id) async {
    final resolved = SoundscapeCatalog.resolve(id).id;
    if (resolved == _soundscapeId) {
      return;
    }
    _soundscapeId = resolved;
    notifyListeners();
    await _store.saveSoundscapeId(resolved);
  }

  @override
  Future<void> handleLifecycle(AppLifecycleState state) async {}
}
