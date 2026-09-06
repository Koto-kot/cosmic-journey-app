import 'package:cosmic_journey/app/journey_style_controller.dart';
import 'package:cosmic_journey/core/journey_style/journey_style.dart';
import 'package:cosmic_journey/services/local_storage/journey_style_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defaults to Cosmic Minimal and remembers Shuttle Cockpit', () async {
    final store = InMemoryJourneyStyleStore();
    final controller = JourneyStyleController(store: store);
    expect(controller.style, JourneyStyle.cosmicMinimal);

    await controller.setStyle(JourneyStyle.shuttleCockpit);
    expect(controller.style, JourneyStyle.shuttleCockpit);
    expect(await store.loadStyleId(), 'shuttle_cockpit');

    final restored = JourneyStyleController(
      store: store,
      storedId: await store.loadStyleId(),
    );
    expect(restored.style, JourneyStyle.shuttleCockpit);
  });

  test(
    'setting the same style twice does not notify or rewrite storage',
    () async {
      final store = InMemoryJourneyStyleStore();
      final controller = JourneyStyleController(store: store);
      var notifications = 0;
      controller.addListener(() => notifications += 1);

      await controller.setStyle(JourneyStyle.cosmicMinimal);
      expect(notifications, 0);
      expect(await store.loadStyleId(), isNull);
    },
  );

  test('unresolved/garbage stored id falls back to Cosmic Minimal', () {
    expect(JourneyStyleCodec.resolve(null), JourneyStyle.cosmicMinimal);
    expect(JourneyStyleCodec.resolve('nonsense'), JourneyStyle.cosmicMinimal);
    expect(
      JourneyStyleCodec.resolve('shuttle_cockpit'),
      JourneyStyle.shuttleCockpit,
    );
  });
}
