import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

import '../local_storage/audio_preference_store.dart';
import 'ambient_audio_controller.dart';
import 'soundscape.dart';

/// Fade-in duration when a loop starts, per the Codex ambient-audio spec
/// (recommended 1-2 seconds).
const _fadeInDuration = Duration(milliseconds: 1500);
const _fadeSteps = 15;

class AudioplayersAmbientAudioController extends AmbientAudioController {
  AudioplayersAmbientAudioController({
    required AudioPreferenceStore store,
    required bool enabled,
    String? soundscapeId,
    double volume = defaultAmbientVolume,
    AudioPlayer? player,
    // `store`/`enabled` stay plain params (not `this._x`) so main.dart can
    // keep passing them by their friendly names.
  }) : // ignore: prefer_initializing_formals
       _store = store,
       // ignore: prefer_initializing_formals
       _enabled = enabled,
       _soundscapeId = SoundscapeCatalog.resolve(soundscapeId).id,
       _volume = volume.clamp(0.0, 1.0),
       _player = player ?? AudioPlayer();

  final AudioPreferenceStore _store;
  final AudioPlayer _player;
  bool _enabled;
  String _soundscapeId;
  double _volume;
  bool _foreground = true;
  bool _playing = false;
  bool _configured = false;
  Timer? _fadeTimer;

  @override
  bool get enabled => _enabled;

  @override
  String get soundscapeId => _soundscapeId;

  @override
  double get volume => _volume;

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
  Future<void> setVolume(double value) async {
    final clamped = value.clamp(0.0, 1.0);
    if (clamped == _volume) {
      return;
    }
    _volume = clamped;
    notifyListeners();
    await _store.saveVolume(clamped);
    if (_playing) {
      _fadeTimer?.cancel();
      await _player.setVolume(clamped);
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
        _fadeTimer?.cancel();
        await _player.pause();
        _playing = false;
    }
  }

  Future<void> _startIfAllowed() async {
    if (!_enabled || !_foreground || _playing) {
      // Already playing (or not allowed to start): never restart an active
      // loop, so we neither create overlapping instances nor cut the loop
      // back to zero.
      return;
    }
    try {
      if (!_configured) {
        await _player.setReleaseMode(ReleaseMode.loop);
        _configured = true;
      }
      await _player.setVolume(0);
      final bytes = SoundscapeCatalog.resolve(_soundscapeId).loopBuilder();
      await _player.play(BytesSource(bytes, mimeType: 'audio/wav'));
      _playing = true;
      _fadeIn();
    } catch (_) {
      _playing = false;
    }
  }

  void _fadeIn() {
    _fadeTimer?.cancel();
    var step = 0;
    final stepDuration = Duration(
      microseconds: _fadeInDuration.inMicroseconds ~/ _fadeSteps,
    );
    _fadeTimer = Timer.periodic(stepDuration, (timer) {
      step += 1;
      final level = (_volume * step / _fadeSteps).clamp(0.0, _volume);
      unawaited(_player.setVolume(level));
      if (step >= _fadeSteps) {
        timer.cancel();
      }
    });
  }

  Future<void> _stop() async {
    _fadeTimer?.cancel();
    await _player.stop();
    _playing = false;
  }

  @override
  void dispose() {
    _fadeTimer?.cancel();
    _player.dispose();
    super.dispose();
  }
}
