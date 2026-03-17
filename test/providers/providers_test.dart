import 'package:feline_dash/providers/score_providers.dart';
import 'package:feline_dash/providers/settings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('highScoreProvider', () {
    test('initial state is 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(highScoreProvider), 0);
    });

    test('submitScore updates state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(highScoreProvider.notifier).submitScore(1000);
      expect(container.read(highScoreProvider), 1000);
    });

    test('lower score does not replace existing high score', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(highScoreProvider.notifier).submitScore(1000);
      await container.read(highScoreProvider.notifier).submitScore(500);
      expect(container.read(highScoreProvider), 1000);
    });
  });

  group('settingsProvider', () {
    test('initial sfxEnabled is true', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(settingsProvider).sfxEnabled, isTrue);
    });

    test('setSfx(false) updates state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(settingsProvider.notifier).setSfx(enabled: false);
      expect(container.read(settingsProvider).sfxEnabled, isFalse);
    });

    test('setBgm(false) updates state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(settingsProvider.notifier).setBgm(enabled: false);
      expect(container.read(settingsProvider).bgmEnabled, isFalse);
    });
  });
}
