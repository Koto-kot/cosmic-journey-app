import 'package:cosmic_journey/app/locale_controller.dart';
import 'package:cosmic_journey/services/local_storage/locale_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('stored Ukrainian preference wins over an English device', () {
    expect(
      LocaleController.resolve(
        storedCode: 'uk',
        deviceLocale: const Locale('en', 'US'),
      ),
      LocaleController.ukrainian,
    );
  });

  test('device Ukrainian is used when nothing is stored', () {
    expect(
      LocaleController.resolve(
        storedCode: null,
        deviceLocale: const Locale('uk', 'UA'),
      ),
      LocaleController.ukrainian,
    );
  });

  test('unsupported device language falls back to English', () {
    expect(
      LocaleController.resolve(
        storedCode: null,
        deviceLocale: const Locale('de'),
      ),
      LocaleController.english,
    );
  });

  test('setLocale persists the language code', () async {
    final store = InMemoryLocaleStore();
    final controller = LocaleController(store: store);
    await controller.setLocale(LocaleController.ukrainian);
    expect(controller.locale, LocaleController.ukrainian);
    expect(await store.loadLanguageCode(), 'uk');
  });
}
