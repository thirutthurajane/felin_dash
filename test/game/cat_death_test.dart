import 'package:feline_dash/core/constants.dart';
import 'package:feline_dash/game/components/player/cat_state.dart';
import 'package:feline_dash/game/feline_dash_game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tester = FlameTester(FelineDashGame.new);

  group('CatComponent death mechanics', () {
    tester.testGameWidget(
      'isDead is false initially',
      verify: (game, _) async {
        expect(game.cat.isDead, isFalse);
      },
    );

    tester.testGameWidget(
      'die() sets isDead to true',
      verify: (game, _) async {
        game.cat.die();
        expect(game.cat.isDead, isTrue);
      },
    );

    tester.testGameWidget(
      'die() sets state to dead',
      verify: (game, _) async {
        game.cat.die();
        expect(game.cat.state, equals(CatState.dead));
      },
    );

    tester.testGameWidget(
      'die() switches to dead animation (6 frames, non-looping)',
      verify: (game, _) async {
        game.cat.die();
        expect(game.cat.animation, isNotNull);
        expect(game.cat.animation!.frames.length,
            equals(SpriteConfig.catDeadFrames));
        expect(game.cat.animation!.loop, isFalse);
      },
    );

    tester.testGameWidget(
      'die() freezes vertical physics – position.y unchanged after update',
      verify: (game, _) async {
        game.cat.jump();
        game.cat.die();
        final yBefore = game.cat.position.y;
        game.update(0.5);
        expect(game.cat.position.y, closeTo(yBefore, 1.0));
      },
    );

    tester.testGameWidget(
      'die() is idempotent – calling twice keeps state dead',
      verify: (game, _) async {
        game.cat.die();
        game.cat.die();
        expect(game.cat.isDead, isTrue);
        expect(game.cat.state, equals(CatState.dead));
      },
    );

    tester.testGameWidget(
      'jump() is ignored when dead',
      verify: (game, _) async {
        game.cat.die();
        game.cat.jump();
        expect(game.cat.state, equals(CatState.dead));
      },
    );

    tester.testGameWidget(
      'slide() is ignored when dead',
      verify: (game, _) async {
        game.cat.die();
        game.cat.slide();
        expect(game.cat.state, equals(CatState.dead));
        expect(game.cat.isSliding, isFalse);
      },
    );

    tester.testGameWidget(
      'canJump returns false when dead',
      verify: (game, _) async {
        game.cat.die();
        expect(game.cat.canJump, isFalse);
      },
    );

    tester.testGameWidget(
      'die() restores full hitbox size when called while sliding',
      verify: (game, _) async {
        game.cat.slide();
        game.cat.die();
        expect(
          game.cat.size.y,
          closeTo(SpriteConfig.catFrameHeight, 0.1),
        );
      },
    );
  });

  group('FelineDashGame death handling', () {
    tester.testGameWidget(
      'handleCatDeath() records death SFX path',
      verify: (game, _) async {
        game.sfxEnabled = false;
        game.handleCatDeath();
        expect(game.lastSfxRequested, equals(AudioAssets.sfxDeath));
      },
    );

    tester.testGameWidget(
      'handleCatDeath() sets cat state to dead',
      verify: (game, _) async {
        game.sfxEnabled = false;
        game.handleCatDeath();
        expect(game.cat.isDead, isTrue);
      },
    );

    tester.testGameWidget(
      'handleCatDeath() captures finalScore from difficulty system',
      verify: (game, _) async {
        game.sfxEnabled = false;
        // Advance game to accumulate some distance
        game.update(1.0);
        game.handleCatDeath();
        expect(game.finalScore, greaterThanOrEqualTo(0));
        expect(
          game.finalScore,
          equals(game.difficultySystem.distanceTravelled.toInt()),
        );
      },
    );

    tester.testGameWidget(
      'handleCatDeath() is idempotent – second call does not overwrite score',
      verify: (game, _) async {
        game.sfxEnabled = false;
        game.update(1.0);
        game.handleCatDeath();
        final score = game.finalScore;
        game.update(1.0); // distance would grow if not frozen
        game.handleCatDeath(); // second call ignored
        expect(game.finalScore, equals(score));
      },
    );
  });
}
