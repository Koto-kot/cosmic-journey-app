import 'dart:math' as math;
import 'dart:typed_data';

/// Original Deep Space drone for the free ambient loop.
///
/// Generated in-app so the loop is seamless, commercially clear, and has no
/// one-second tick. Length is an integer number of cycles of every partial.
abstract final class DeepSpaceLoop {
  static const int sampleRate = 22050;
  static const int durationSeconds = 16;

  /// Every soundscape normalizes to this peak (of full scale) so switching
  /// between them never lands on one that's inaudibly quiet — see
  /// [normalizePeak].
  static const double targetPeak = 0.92;

  static Uint8List build() {
    const frames = sampleRate * durationSeconds;
    final samples = Float64List(frames);
    const twoPi = math.pi * 2;
    for (var i = 0; i < frames; i++) {
      final t = i / sampleRate;
      final breath = 0.84 + 0.16 * math.sin(twoPi * 0.125 * t);
      final shimmer = 0.5 + 0.5 * math.sin(twoPi * 0.25 * t);
      var sample = 0.0;
      sample += 0.22 * math.sin(twoPi * 55 * t);
      sample += 0.15 * math.sin(twoPi * 82.5 * t);
      sample += 0.10 * math.sin(twoPi * 110 * t);
      sample += 0.08 * math.sin(twoPi * 41.25 * t);
      sample += 0.04 * math.sin(twoPi * 165 * t) * shimmer;
      sample += 0.025 * math.sin(twoPi * 27.5 * t);
      sample *= breath * 0.38;
      samples[i] = sample;
    }
    return wrapWav(normalizePeak(samples));
  }

  /// Rescales `samples` so their peak absolute value hits [targetPeak] of
  /// full scale, then quantizes to 16-bit PCM. Each soundscape's `gain` and
  /// partial-amplitude constants (in [ProSoundscapes]) only shape relative
  /// timbre now, not overall loudness — before this, presets like
  /// `quietStation`/`deepSilence` peaked around 8x quieter than
  /// `orbitalDrift`, which read as "doesn't play" rather than "quiet".
  static Int16List normalizePeak(
    Float64List samples, {
    double target = targetPeak,
  }) {
    var peak = 0.0;
    for (final sample in samples) {
      final magnitude = sample.abs();
      if (magnitude > peak) {
        peak = magnitude;
      }
    }
    final scale = peak > 0 ? target / peak : 1.0;
    final pcm = Int16List(samples.length);
    for (var i = 0; i < samples.length; i++) {
      pcm[i] = ((samples[i] * scale).clamp(-1.0, 1.0) * 32767).round();
    }
    return pcm;
  }

  static Uint8List wrapWav(Int16List pcm) {
    const channels = 1;
    const bitsPerSample = 16;
    final byteRate = sampleRate * channels * bitsPerSample ~/ 8;
    final blockAlign = channels * bitsPerSample ~/ 8;
    final dataSize = pcm.length * 2;
    final bytes = ByteData(44 + dataSize);
    var o = 0;
    void ascii(String value) {
      for (final code in value.codeUnits) {
        bytes.setUint8(o, code);
        o += 1;
      }
    }

    ascii('RIFF');
    bytes.setUint32(o, 36 + dataSize, Endian.little);
    o += 4;
    ascii('WAVE');
    ascii('fmt ');
    bytes.setUint32(o, 16, Endian.little);
    o += 4;
    bytes.setUint16(o, 1, Endian.little);
    o += 2;
    bytes.setUint16(o, channels, Endian.little);
    o += 2;
    bytes.setUint32(o, sampleRate, Endian.little);
    o += 4;
    bytes.setUint32(o, byteRate, Endian.little);
    o += 4;
    bytes.setUint16(o, blockAlign, Endian.little);
    o += 2;
    bytes.setUint16(o, bitsPerSample, Endian.little);
    o += 2;
    ascii('data');
    bytes.setUint32(o, dataSize, Endian.little);
    o += 4;
    for (final sample in pcm) {
      bytes.setInt16(o, sample, Endian.little);
      o += 2;
    }
    return bytes.buffer.asUint8List();
  }
}
