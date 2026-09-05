import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

import '../local_storage/audio_preference_store.dart';
import 'ambient_audio_controller.dart';
import 'soundscape.dart';

class AudioplayersAmbientAudioController extends AmbientAudioController {
  AudioplayersAmbientAudioController({
    required this._store,
    required this._enabled,
    String? soundscapeId,
    AudioPlayer? player,
  }) : _soundscapeId = SoundscapeCatalog.resolve(soundscapeId).id,
       _player = player ?? AudioPlayer();

  final AudioPreferenceStore _store;
  final AudioPlayer _player;
  bool _enabled;
  String _soundscapeId;
  bool _foreground = true;
  bool _playing = false;
  bool _configured = false;

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
    if (value) {
      await _startIfAllowed();
    } else {
      await _stop();
    }
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
    if (_enabled && _foreground) {
      await _stop();
      await _startIfAllowed();
    }
  }

  @override
  Future<void> handleLifecycle(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        _foreground = true;
        await _startIfAllowed();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _foreground = false;
        await _player.pause();
        _playing = false;
    }
  }

  Future<void> _startIfAllowed() async {
    if (!_enabled || !_foreground) {
      return;
    }
    try {
      if (!_configured) {
        await _player.setReleaseMode(ReleaseMode.loop);
        await _player.setVolume(0.32);
        _configured = true;
      }
      final bytes = SoundscapeCatalog.resolve(_soundscapeId).loopBuilder();
      await _player.play(BytesSource(bytes, mimeType: 'audio/wav'));
      _playing = true;
    } catch (_) {
      _playing = false;
    }
  }

  Future<void> _stop() async {
    if (!_playing) {
      await _player.stop();
      return;
    }
    await _player.stop();
    _playing = false;
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
