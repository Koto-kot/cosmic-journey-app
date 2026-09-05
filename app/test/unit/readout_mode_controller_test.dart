import 'package:cosmic_journey/app/readout_mode_controller.dart';
import 'package:cosmic_journey/core/readout/readout_mode.dart';
import 'package:cosmic_journey/services/local_storage/readout_mode_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defaults to Pulse and remembers Flow', () async {
    final store = InMemoryReadoutModeStore();
    final controller = ReadoutModeController(store: store);
    expect(controller.mode, ReadoutMode.pulse);

    await controller.setMode(ReadoutMode.flow);
    expect(controller.mode, ReadoutMode.flow);
    expect(await store.loadModeId(), 'flow');

    final restored = ReadoutModeController(
      store: store,
      storedId: await store.loadModeId(),
    );
    expect(restored.mode, ReadoutMode.flow);
  });
}
