import 'dart:convert';
import 'dart:typed_data';

part 'earth_orbit_part1.dart';
part 'earth_orbit_part2.dart';
part 'earth_orbit_part3.dart';
part 'earth_orbit_part4.dart';

/// Compact Earth-with-orbit still, embedded so web and CI do not depend on a binary asset.
abstract final class EarthOrbitAsset {
  static Uint8List? _bytes;

  static Uint8List get bytes => _bytes ??= Uint8List.fromList(
    base64Decode(_jpegBase64.replaceAll(RegExp(r'\s+'), '')),
  );

  static const String _jpegBase64 =
      _jpegPart1 + _jpegPart2 + _jpegPart3 + _jpegPart4;
}
