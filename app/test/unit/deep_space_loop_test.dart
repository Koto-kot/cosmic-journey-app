import 'dart:convert';
import 'dart:typed_data';

import 'package:cosmic_journey/services/audio/deep_space_loop.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Deep Space loop is a seamless 16-bit WAV with no tick accent', () {
    final bytes = DeepSpaceLoop.build();
    expect(ascii.decode(bytes.sublist(0, 4)), 'RIFF');
    expect(ascii.decode(bytes.sublist(8, 12)), 'WAVE');
    expect(bytes.length, greaterThan(44));

    final first = bytes.buffer.asByteData().getInt16(44, Endian.little);
    final last = bytes.buffer.asByteData().getInt16(
      bytes.length - 2,
      Endian.little,
    );
    expect(first.abs(), lessThan(400));
    expect(last.abs(), lessThan(400));
  });
}
