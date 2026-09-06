import 'dart:typed_data';

import 'package:cosmic_journey/services/audio/deep_space_loop.dart';
import 'package:cosmic_journey/services/audio/soundscape.dart';
import 'package:flutter_test/flutter_test.dart';

int _peakSample(Uint8List wav) {
  final data = wav.buffer.asByteData(wav.offsetInBytes);
  var peak = 0;
  for (var offset = 44; offset + 1 < wav.length; offset += 2) {
    final sample = data.getInt16(offset, Endian.little).abs();
    if (sample > peak) {
      peak = sample;
    }
  }
  return peak;
}

void main() {
  test('every soundscape peaks at the same loudness, not just Deep Space', () {
    // Before normalization, quiet presets (e.g. quiet_station,
    // deep_silence) peaked around 8x quieter than louder ones like
    // orbital_drift — quiet enough to read as "doesn't play" rather than
    // "quiet". Every soundscape must now land on the same peak.
    final expectedPeak = (DeepSpaceLoop.targetPeak * 32767).round();
    for (final soundscape in SoundscapeCatalog.all) {
      final peak = _peakSample(soundscape.loopBuilder());
      expect(
        peak,
        closeTo(expectedPeak, 2),
        reason: '${soundscape.id} should peak at the normalized target',
      );
    }
  });
}
