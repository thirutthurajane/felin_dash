import 'package:feline_dash/core/constants.dart';
import 'package:feline_dash/game/systems/score_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScoreSystem', () {
    late ScoreSystem scoreSystem;

    setUp(() {
      scoreSystem = ScoreSystem();
    });

    // ── Initial state ──────────────────────────────────────────────────────

    test('score starts at zero', () {
      expect(scoreSystem.score, equals(0));
    });

    test('multiplier starts at 1', () {
      expect(scoreSystem.multiplier, equals(1));
    });

    test('fishCount starts at zero', () {
      expect(scoreSystem.fishCount, equals(0));
    });

    // ── addFish ────────────────────────────────────────────────────────────

    test('addFish increments score by fishTokenValue with multiplier 1', () {
      scoreSystem.addFish();
      expect(scoreSystem.score, equals(GameConstants.fishTokenValue));
    });

    test('addFish increments fishCount', () {
      scoreSystem.addFish();
      expect(scoreSystem.fishCount, equals(1));
    });

    test(
        'multiplier increases by 1 after collecting multiplierFishThreshold fish',
        () {
      for (var i = 0; i < GameConstants.multiplierFishThreshold; i++) {
        scoreSystem.addFish();
      }
      expect(scoreSystem.multiplier, equals(2));
    });

    test('multiplier applies to subsequent fish score', () {
      // Collect threshold fish to bump multiplier to 2
      for (var i = 0; i < GameConstants.multiplierFishThreshold; i++) {
        scoreSystem.addFish();
      }
      final scoreBeforeNextFish = scoreSystem.score;
      scoreSystem.addFish();
      expect(
        scoreSystem.score - scoreBeforeNextFish,
        equals(GameConstants.fishTokenValue * 2),
      );
    });

    test('multiplier increases again after another threshold batch', () {
      for (var i = 0; i < GameConstants.multiplierFishThreshold * 2; i++) {
        scoreSystem.addFish();
      }
      expect(scoreSystem.multiplier, equals(3));
    });

    // ── addDistanceScore ───────────────────────────────────────────────────

    test('addDistanceScore adds score proportional to dt', () {
      scoreSystem.addDistanceScore(1.0);
      expect(
        scoreSystem.score,
        equals((GameConstants.scorePerMeter * 1.0).round()),
      );
    });

    test('addDistanceScore applies multiplier', () {
      for (var i = 0; i < GameConstants.multiplierFishThreshold; i++) {
        scoreSystem.addFish();
      }
      // multiplier is now 2
      final scoreBeforeDistance = scoreSystem.score;
      scoreSystem.addDistanceScore(1.0);
      expect(
        scoreSystem.score - scoreBeforeDistance,
        equals((GameConstants.scorePerMeter * 1.0 * 2).round()),
      );
    });

    // ── reset ──────────────────────────────────────────────────────────────

    test('reset clears score to zero', () {
      scoreSystem.addFish();
      scoreSystem.reset();
      expect(scoreSystem.score, equals(0));
    });

    test('reset clears multiplier to 1', () {
      for (var i = 0; i < GameConstants.multiplierFishThreshold; i++) {
        scoreSystem.addFish();
      }
      scoreSystem.reset();
      expect(scoreSystem.multiplier, equals(1));
    });

    test('reset clears fishCount to zero', () {
      scoreSystem.addFish();
      scoreSystem.reset();
      expect(scoreSystem.fishCount, equals(0));
    });
  });
}
