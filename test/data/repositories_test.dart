import 'package:feline_dash/data/repositories/in_memory_score_repository.dart';
import 'package:feline_dash/data/repositories/in_memory_settings_repository.dart';
import 'package:feline_dash/data/models/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InMemoryScoreRepository', () {
    late InMemoryScoreRepository repo;

    setUp(() => repo = InMemoryScoreRepository());

    test('initial high score is 0', () async {
      expect(await repo.getHighScore(), 0);
    });

    test('saves a new high score', () async {
      await repo.saveHighScore(500);
      expect(await repo.getHighScore(), 500);
    });

    test('does not overwrite a higher score with a lower one', () async {
      await repo.saveHighScore(500);
      await repo.saveHighScore(200);
      expect(await repo.getHighScore(), 500);
    });

    test('getRecentScores returns submitted scores', () async {
      await repo.saveHighScore(100);
      await repo.saveHighScore(200);
      final records = await repo.getRecentScores();
      expect(records.length, 2);
      expect(records.map((r) => r.score), containsAll([100, 200]));
    });
  });

  group('InMemorySettingsRepository', () {
    late InMemorySettingsRepository repo;

    setUp(() => repo = InMemorySettingsRepository());

    test('default settings have sfx and bgm enabled', () async {
      final s = await repo.loadSettings();
      expect(s.sfxEnabled, isTrue);
      expect(s.bgmEnabled, isTrue);
    });

    test('persists saved settings', () async {
      await repo.saveSettings(
        const Settings(sfxEnabled: false, bgmEnabled: false),
      );
      final s = await repo.loadSettings();
      expect(s.sfxEnabled, isFalse);
      expect(s.bgmEnabled, isFalse);
    });
  });
}
