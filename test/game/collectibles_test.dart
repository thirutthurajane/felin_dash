import 'package:feline_dash/core/constants.dart';
import 'package:feline_dash/game/components/collectibles/catnip_powerup.dart';
import 'package:feline_dash/game/components/collectibles/fish_token.dart';
import 'package:feline_dash/game/components/collectibles/milk_bottle.dart';
import 'package:feline_dash/game/components/collectibles/power_up_type.dart';
import 'package:feline_dash/game/components/collectibles/yarn_ball.dart';
import 'package:feline_dash/game/feline_dash_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tester = FlameTester(() {
    final game = FelineDashGame();
    game.sfxEnabled = false;
    return game;
  });

  // ── FishToken ─────────────────────────────────────────────────────────────

  group('FishToken', () {
    tester.testGameWidget(
      'has a CircleHitbox',
      verify: (game, _) async {
        final token = FishToken(spawnX: 500);
        await game.add(token);
        await game.ready();
        final hitboxes = token.children.whereType<CircleHitbox>();
        expect(hitboxes, isNotEmpty);
      },
    );

    tester.testGameWidget(
      'CircleHitbox is not solid',
      verify: (game, _) async {
        final token = FishToken(spawnX: 500);
        await game.add(token);
        await game.ready();
        final hitbox = token.children.whereType<CircleHitbox>().first;
        expect(hitbox.isSolid, isFalse);
      },
    );

    tester.testGameWidget(
      'collecting fish increments score by fishTokenValue',
      verify: (game, _) async {
        final initialScore = game.scoreSystem.score;
        game.onFishCollected();
        expect(
          game.scoreSystem.score - initialScore,
          equals(GameConstants.fishTokenValue),
        );
      },
    );

    tester.testGameWidget(
      'collecting fish increments fishCount',
      verify: (game, _) async {
        game.onFishCollected();
        expect(game.scoreSystem.fishCount, equals(1));
      },
    );

    tester.testGameWidget(
      'multiplier activates after multiplierFishThreshold consecutive fish',
      verify: (game, _) async {
        for (var i = 0; i < GameConstants.multiplierFishThreshold; i++) {
          game.onFishCollected();
        }
        expect(game.scoreSystem.multiplier, equals(2));
      },
    );

    tester.testGameWidget(
      'FishToken scrolls left each update',
      verify: (game, _) async {
        final token = FishToken(spawnX: 500);
        await game.add(token);
        await game.ready();
        final initialX = token.position.x;
        game.update(0.1);
        expect(token.position.x, lessThan(initialX));
      },
    );

    tester.testGameWidget(
      'FishToken is removed when it scrolls off the left edge',
      verify: (game, _) async {
        // Place token well past the left edge so the first update removes it.
        final token = FishToken(spawnX: -200);
        await game.add(token);
        await game.ready();
        // First update: component calls removeFromParent()
        game.update(0.016);
        // Second update: removal is actually processed and isMounted → false
        game.update(0.016);
        expect(token.isMounted, isFalse);
      },
    );
  });

  // ── Power-ups ─────────────────────────────────────────────────────────────

  group('CatnipPowerup', () {
    tester.testGameWidget(
      'activating catnip sets isInvincible to true',
      verify: (game, _) async {
        game.activatePowerUp(PowerUpType.catnip);
        expect(game.isInvincible, isTrue);
      },
    );

    tester.testGameWidget(
      'catnip invincibility expires after catnipDuration',
      verify: (game, _) async {
        game.activatePowerUp(PowerUpType.catnip);
        game.update(GameConstants.catnipDuration + 0.1);
        expect(game.isInvincible, isFalse);
      },
    );

    tester.testGameWidget(
      'CatnipPowerup has a non-solid RectangleHitbox',
      verify: (game, _) async {
        final powerUp = CatnipPowerup(spawnX: 500);
        await game.add(powerUp);
        await game.ready();
        final hitbox = powerUp.children.whereType<RectangleHitbox>().first;
        expect(hitbox.isSolid, isFalse);
      },
    );
  });

  group('YarnBall', () {
    tester.testGameWidget(
      'activating yarn ball reduces effective speed',
      verify: (game, _) async {
        final normalSpeed = game.effectiveSpeed;
        game.activatePowerUp(PowerUpType.yarnBall);
        expect(game.effectiveSpeed, lessThan(normalSpeed));
      },
    );

    tester.testGameWidget(
      'yarn ball slowdown expires after yarnDuration',
      verify: (game, _) async {
        game.activatePowerUp(PowerUpType.yarnBall);
        game.update(GameConstants.yarnDuration + 0.1);
        // Multiplier restored — effectiveSpeed == difficultySystem.speed
        expect(
          game.effectiveSpeed,
          closeTo(game.difficultySystem.speed, 0.1),
        );
      },
    );

    tester.testGameWidget(
      'YarnBall has a non-solid RectangleHitbox',
      verify: (game, _) async {
        final powerUp = YarnBall(spawnX: 500);
        await game.add(powerUp);
        await game.ready();
        final hitbox = powerUp.children.whereType<RectangleHitbox>().first;
        expect(hitbox.isSolid, isFalse);
      },
    );
  });

  group('MilkBottle', () {
    tester.testGameWidget(
      'activating milk bottle increments lives by 1',
      verify: (game, _) async {
        final initialLives = game.lives;
        game.activatePowerUp(PowerUpType.milkBottle);
        expect(game.lives, equals(initialLives + 1));
      },
    );

    tester.testGameWidget(
      'milk bottle does not exceed maxLives',
      verify: (game, _) async {
        // Fill lives to max
        for (var i = game.lives; i < GameConstants.maxLives; i++) {
          game.activatePowerUp(PowerUpType.milkBottle);
        }
        game.activatePowerUp(PowerUpType.milkBottle); // one more
        expect(game.lives, equals(GameConstants.maxLives));
      },
    );

    tester.testGameWidget(
      'MilkBottle has a non-solid RectangleHitbox',
      verify: (game, _) async {
        final powerUp = MilkBottle(spawnX: 500);
        await game.add(powerUp);
        await game.ready();
        final hitbox = powerUp.children.whereType<RectangleHitbox>().first;
        expect(hitbox.isSolid, isFalse);
      },
    );
  });

  // ── Power-up replacement ─────────────────────────────────────────────────

  group('Power-up exclusivity', () {
    tester.testGameWidget(
      'activating a new power-up cancels the previous one',
      verify: (game, _) async {
        game.activatePowerUp(PowerUpType.catnip);
        expect(game.isInvincible, isTrue);
        game.activatePowerUp(PowerUpType.yarnBall);
        // catnip is cancelled — no longer invincible
        expect(game.isInvincible, isFalse);
        // yarn ball is active
        expect(game.effectiveSpeed, lessThan(game.difficultySystem.speed));
      },
    );

    tester.testGameWidget(
      'activating catnip over yarn ball restores speed and grants invincibility',
      verify: (game, _) async {
        game.activatePowerUp(PowerUpType.yarnBall);
        game.activatePowerUp(PowerUpType.catnip);
        expect(game.isInvincible, isTrue);
        expect(game.effectiveSpeed, closeTo(game.difficultySystem.speed, 0.1));
      },
    );
  });

  // ── Invincibility during obstacle collision ────────────────────────────────

  group('Invincibility collision guard', () {
    tester.testGameWidget(
      'handleCatDeath is ignored when cat is invincible',
      verify: (game, _) async {
        game.activatePowerUp(PowerUpType.catnip);
        game.handleCatDeath();
        expect(game.cat.isDead, isFalse);
      },
    );

    tester.testGameWidget(
      'handleCatDeath kills cat when not invincible',
      verify: (game, _) async {
        game.handleCatDeath();
        expect(game.cat.isDead, isTrue);
      },
    );
  });
}
