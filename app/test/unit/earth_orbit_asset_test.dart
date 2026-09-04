import 'package:cosmic_journey/core/widgets/earth_orbit_bytes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('embedded Earth still is a JPEG', () {
    final bytes = EarthOrbitAsset.bytes;
    expect(bytes.length, greaterThan(1000));
    expect(bytes[0], 0xFF);
    expect(bytes[1], 0xD8);
  });
}
