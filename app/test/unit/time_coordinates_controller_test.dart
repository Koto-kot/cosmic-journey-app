import 'package:cosmic_journey/app/time_coordinates_controller.dart';
import 'package:cosmic_journey/services/local_storage/time_coordinates_preference_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defaults OFF and remembers being switched on', () async {
    final store = InMemoryTimeCoordinatesPreferenceStore();
    final controller = TimeCoordinatesController(store: store);
    expect(controller.enabled, isFalse);
    expect(await store.loadEnabled(), isFalse);

    await controller.setEnabled(true);
    expect(controller.enabled, isTrue);
    expect(await store.loadEnabled(), isTrue);

    final restored = TimeCoordinatesController(
      store: store,
      storedEnabled: await store.loadEnabled(),
    );
    expect(restored.enabled, isTrue);
  });
}
