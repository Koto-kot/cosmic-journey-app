import 'package:cosmic_journey/app/theme_controller.dart';
import 'package:cosmic_journey/core/theme/cosmic_palette.dart';
import 'package:cosmic_journey/core/theme_tokens.dart';
import 'package:cosmic_journey/services/local_storage/theme_preference_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('theme controller persists OLED and updates tokens on apply', () async {
    final store = InMemoryThemePreferenceStore();
    final controller = ThemeController(store: store);
    expect(controller.paletteId, CosmicPaletteCatalog.voidId);

    await controller.setPalette(CosmicPaletteCatalog.oled);
    expect(controller.paletteId, CosmicPaletteCatalog.oledId);
    expect(await store.loadPaletteId(), CosmicPaletteCatalog.oledId);

    CosmicTokens.apply(controller.palette);
    expect(CosmicTokens.nebula, CosmicPaletteCatalog.oled.nebula);
    CosmicTokens.apply(CosmicPaletteCatalog.voidBlack);
    controller.dispose();
  });
}
