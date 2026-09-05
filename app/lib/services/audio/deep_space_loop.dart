import 'dart:math' as math;
import 'dart:typed_data';

/// Original Deep Space drone for the free ambient loop.
///
/// Generated in-app so the loop is seamless, commercially clear, and has no
/// one-second tick. Length is an integer number of cycles of every partial.
abstract final class DeepSpaceLoop {
  static const int sampleRate = 22050;
  static const int durationSeconds = 16;

  static Uint8List build() {
    const frames = sampleRate * durationSeconds;
    final pcm = Int16List(frames);
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
      pcm[i] = (sample.clamp(-1.0, 1.0) * 32767).round();
    }
    return wrapWav(pcm);
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
