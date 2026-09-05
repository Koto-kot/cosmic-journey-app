import 'dart:math' as math;
import 'dart:typed_data';

import 'deep_space_loop.dart';

/// A looping ambient bed. New Pro soundscapes register here without
/// touching the live journey screen.
class Soundscape {
  const Soundscape({required this.id, required this.loopBuilder});

  final String id;
  final Uint8List Function() loopBuilder;
}

abstract final class SoundscapeCatalog {
  static const deepSpaceId = 'deep_space';
  static const orbitalDriftId = 'orbital_drift';
  static const auroraId = 'aurora';
  static const bluePlanetId = 'blue_planet';
  static const interstellarId = 'interstellar';
  static const voyagerId = 'voyager';
  static const deepSilenceId = 'deep_silence';
  static const solarWindId = 'solar_wind';
  static const ionosphereId = 'ionosphere';
  static const redDwarfId = 'red_dwarf';
  static const quietStationId = 'quiet_station';
  static const cometTailId = 'comet_tail';
  static const magnetosphereId = 'magnetosphere';

  static const proIds = <String>[
    orbitalDriftId,
    auroraId,
    bluePlanetId,
    interstellarId,
    voyagerId,
    deepSilenceId,
    solarWindId,
    ionosphereId,
    redDwarfId,
    quietStationId,
    cometTailId,
    magnetosphereId,
  ];

  static const Soundscape deepSpace = Soundscape(
    id: deepSpaceId,
    loopBuilder: DeepSpaceLoop.build,
  );

  static const Soundscape orbitalDrift = Soundscape(
    id: orbitalDriftId,
    loopBuilder: ProSoundscapes.orbitalDrift,
  );

  static const Soundscape aurora = Soundscape(
    id: auroraId,
    loopBuilder: ProSoundscapes.aurora,
  );

  static const Soundscape bluePlanet = Soundscape(
    id: bluePlanetId,
    loopBuilder: ProSoundscapes.bluePlanet,
  );

  static const Soundscape interstellar = Soundscape(
    id: interstellarId,
    loopBuilder: ProSoundscapes.interstellar,
  );

  static const Soundscape voyager = Soundscape(
    id: voyagerId,
    loopBuilder: ProSoundscapes.voyager,
  );

  static const Soundscape deepSilence = Soundscape(
    id: deepSilenceId,
    loopBuilder: ProSoundscapes.deepSilence,
  );

  static const Soundscape solarWind = Soundscape(
    id: solarWindId,
    loopBuilder: ProSoundscapes.solarWind,
  );

  static const Soundscape ionosphere = Soundscape(
    id: ionosphereId,
    loopBuilder: ProSoundscapes.ionosphere,
  );

  static const Soundscape redDwarf = Soundscape(
    id: redDwarfId,
    loopBuilder: ProSoundscapes.redDwarf,
  );

  static const Soundscape quietStation = Soundscape(
    id: quietStationId,
    loopBuilder: ProSoundscapes.quietStation,
  );

  static const Soundscape cometTail = Soundscape(
    id: cometTailId,
    loopBuilder: ProSoundscapes.cometTail,
  );

  static const Soundscape magnetosphere = Soundscape(
    id: magnetosphereId,
    loopBuilder: ProSoundscapes.magnetosphere,
  );

  static const List<Soundscape> free = [deepSpace];

  static const List<Soundscape> all = [
    deepSpace,
    orbitalDrift,
    aurora,
    bluePlanet,
    interstellar,
    voyager,
    deepSilence,
    solarWind,
    ionosphere,
    redDwarf,
    quietStation,
    cometTail,
    magnetosphere,
  ];

  static Soundscape resolve(String? id) {
    for (final soundscape in all) {
      if (soundscape.id == id) {
        return soundscape;
      }
    }
    return deepSpace;
  }

  static bool isFree(String id) =>
      free.any((soundscape) => soundscape.id == id);
}

/// Distinct harmonic beds for the Pro catalog. Same WAV wrapper as Deep Space.
abstract final class ProSoundscapes {
  static Uint8List orbitalDrift() => _harmonic(
    partials: const [(36.67, 0.24), (55.0, 0.18), (73.33, 0.10), (110.0, 0.05)],
    breathHz: 0.0625,
    gain: 0.42,
  );

  static Uint8List aurora() => _harmonic(
    partials: const [(82.5, 0.12), (165.0, 0.10), (220.0, 0.07), (330.0, 0.04)],
    breathHz: 0.1875,
    shimmerHz: 0.5,
    gain: 0.34,
  );

  static Uint8List bluePlanet() => _harmonic(
    partials: const [(48.0, 0.18), (96.0, 0.14), (144.0, 0.08), (192.0, 0.04)],
    breathHz: 0.1,
    gain: 0.36,
  );

  static Uint8List interstellar() => _harmonic(
    partials: const [(27.5, 0.28), (41.25, 0.12), (82.5, 0.06)],
    breathHz: 0.05,
    gain: 0.40,
  );

  static Uint8List voyager() => _harmonic(
    partials: const [
      (110.0, 0.10),
      (247.5, 0.06),
      (330.0, 0.04),
      (440.0, 0.025),
    ],
    breathHz: 0.25,
    shimmerHz: 0.5,
    gain: 0.30,
  );

  static Uint8List deepSilence() => _harmonic(
    partials: const [(27.5, 0.12), (41.25, 0.04)],
    breathHz: 0.03125,
    gain: 0.18,
  );

  static Uint8List solarWind() => _harmonic(
    partials: const [(64.0, 0.16), (128.0, 0.10), (192.0, 0.06), (384.0, 0.03)],
    breathHz: 0.22,
    shimmerHz: 0.9,
    gain: 0.32,
  );

  static Uint8List ionosphere() => _harmonic(
    partials: const [
      (98.0, 0.14),
      (196.0, 0.10),
      (294.0, 0.06),
      (392.0, 0.035),
    ],
    breathHz: 0.14,
    shimmerHz: 0.7,
    gain: 0.33,
  );

  static Uint8List redDwarf() => _harmonic(
    partials: const [(32.0, 0.26), (48.0, 0.12), (64.0, 0.06)],
    breathHz: 0.04,
    gain: 0.38,
  );

  static Uint8List quietStation() => _harmonic(
    partials: const [(55.0, 0.10), (82.5, 0.05), (220.0, 0.02)],
    breathHz: 0.08,
    shimmerHz: 0.125,
    gain: 0.22,
  );

  static Uint8List cometTail() => _harmonic(
    partials: const [
      (146.8, 0.08),
      (293.7, 0.07),
      (440.0, 0.05),
      (587.3, 0.03),
    ],
    breathHz: 0.3,
    shimmerHz: 1.1,
    gain: 0.28,
  );

  static Uint8List magnetosphere() => _harmonic(
    partials: const [(36.0, 0.20), (37.5, 0.16), (72.0, 0.08), (108.0, 0.04)],
    breathHz: 0.045,
    shimmerHz: 0.18,
    gain: 0.36,
  );

  static Uint8List _harmonic({
    required List<(double hz, double amp)> partials,
    double breathHz = 0.125,
    double shimmerHz = 0.25,
    double gain = 0.38,
  }) {
    const sampleRate = DeepSpaceLoop.sampleRate;
    const frames = sampleRate * DeepSpaceLoop.durationSeconds;
    final pcm = Int16List(frames);
    const twoPi = math.pi * 2;
    for (var i = 0; i < frames; i++) {
      final t = i / sampleRate;
      final breath = 0.84 + 0.16 * math.sin(twoPi * breathHz * t);
      final shimmer = 0.5 + 0.5 * math.sin(twoPi * shimmerHz * t);
      var sample = 0.0;
      for (var p = 0; p < partials.length; p++) {
        final (hz, amp) = partials[p];
        final voice = math.sin(twoPi * hz * t);
        sample += amp * voice * (p == partials.length - 1 ? shimmer : 1);
      }
      sample *= breath * gain;
      pcm[i] = (sample.clamp(-1.0, 1.0) * 32767).round();
    }
    return DeepSpaceLoop.wrapWav(pcm);
  }
}
