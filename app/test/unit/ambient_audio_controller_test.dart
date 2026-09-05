import 'package:cosmic_journey/services/audio/ambient_audio_controller.dart';
import 'package:cosmic_journey/services/audio/soundscape.dart';
import 'package:cosmic_journey/services/local_storage/audio_preference_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('audio stays off by default and remembers an opt-in', () async {
    final store = InMemoryAudioPreferenceStore();
    final audio = SilentAmbientAudioController(store: store);
    expect(audio.enabled, isFalse);
    expect(await store.loadEnabled(), isFalse);

    await audio.setEnabled(true);
    expect(audio.enabled, isTrue);
    expect(await store.loadEnabled(), isTrue);
  });

  test('catalog ids can switch the silent controller', () async {
    final audio = SilentAmbientAudioController();
    expect(audio.soundscapeId, SoundscapeCatalog.deepSpaceId);
    await audio.setSoundscape('aurora');
    expect(audio.soundscapeId, 'aurora');
    expect(SoundscapeCatalog.proIds, contains('voyager'));
    expect(SoundscapeCatalog.resolve('voyager').id, 'voyager');
    expect(
      SoundscapeCatalog.proIds,
      containsAll([
        'solar_wind',
        'ionosphere',
        'red_dwarf',
        'quiet_station',
        'comet_tail',
        'magnetosphere',
      ]),
    );
    expect(SoundscapeCatalog.resolve('solar_wind').id, 'solar_wind');
    expect(SoundscapeCatalog.free, hasLength(1));
    expect(SoundscapeCatalog.all, hasLength(13));
  });

  test(
    'volume defaults into the recommended ambient range and persists',
    () async {
      final store = InMemoryAudioPreferenceStore();
      final audio = SilentAmbientAudioController(store: store);
      expect(audio.volume, inInclusiveRange(0.15, 0.25));
      expect(await store.loadVolume(), audio.volume);

      await audio.setVolume(0.42);
      expect(audio.volume, 0.42);
      expect(await store.loadVolume(), 0.42);
    },
  );

  test('volume is clamped to 0..1', () async {
    final audio = SilentAmbientAudioController();
    await audio.setVolume(2.5);
    expect(audio.volume, 1.0);
    await audio.setVolume(-1.0);
    expect(audio.volume, 0.0);
  });
}
