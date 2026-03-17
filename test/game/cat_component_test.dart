import 'package:feline_dash/core/constants.dart';
import 'package:feline_dash/game/components/player/cat_component.dart';
import 'package:feline_dash/game/components/player/cat_state.dart';
import 'package:feline_dash/game/feline_dash_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tester = FlameTester(FelineDashGame.new);

  group('CatComponent', () {
    tester.testGameWidget(
      'starts in running state',
      verify: (game, _) async {
        expect(game.cat.state, equals(CatState.running));
      },
    );

    tester.testGameWidget(
      'is fixed at CatComponent.fixedX on the x-axis',
      verify: (game, _) async {
        expect(game.cat.position.x, closeTo(CatComponent.fixedX, 0.1));
      },
    );

    tester.testGameWidget(
      'top edge sits at groundY minus cat height',
      verify: (game, _) async {
        final expectedY = GameConstants.groundY - game.cat.size.y;
        expect(game.cat.position.y, closeTo(expectedY, 1.0));
      },
    );

    tester.testGameWidget(
      'has a non-null animation with 8 frames',
      verify: (game, _) async {
        expect(game.cat.animation, isNotNull);
        expect(game.cat.animation!.frames.length,
            equals(SpriteConfig.catRunFrames));
      },
    );

    tester.testGameWidget(
      'has a RectangleHitbox child',
      verify: (game, _) async {
        final hitboxes = game.cat.children.whereType<RectangleHitbox>();
        expect(hitboxes, isNotEmpty);
      },
    );

    // ── Jump physics tests ──────────────────────────────────────────────────

    tester.testGameWidget(
      'isOnGround is true initially',
      verify: (game, _) async {
        expect(game.cat.isOnGround, isTrue);
      },
    );

    tester.testGameWidget(
      'jump() applies jumpImpulse to velocityY',
      verify: (game, _) async {
        game.cat.jump();
        expect(
          game.cat.velocityY,
          closeTo(GameConstants.jumpImpulse, 0.1),
        );
      },
    );

    tester.testGameWidget(
      'jump() sets state to jumping',
      verify: (game, _) async {
        game.cat.jump();
        expect(game.cat.state, equals(CatState.jumping));
      },
    );

    tester.testGameWidget(
      'jump() sets isOnGround to false',
      verify: (game, _) async {
        game.cat.jump();
        expect(game.cat.isOnGround, isFalse);
      },
    );

    tester.testGameWidget(
      'gravity accumulates velocityY each frame while airborne',
      verify: (game, _) async {
        game.cat.jump();
        final velocityAfterJump = game.cat.velocityY;
        const dt = 0.1;
        game.update(dt);
        expect(
          game.cat.velocityY,
          closeTo(velocityAfterJump + GameConstants.gravity * dt, 1.0),
        );
      },
    );

    tester.testGameWidget(
      'cat returns to groundY and isOnGround after landing',
      verify: (game, _) async {
        game.cat.jump();
        // Advance enough time for full jump arc to complete
        game.update(2.0);
        expect(game.cat.isOnGround, isTrue);
        expect(
          game.cat.position.y,
          closeTo(GameConstants.groundY - game.cat.size.y, 1.0),
        );
      },
    );

    tester.testGameWidget(
      'jump() is ignored when already in air',
      verify: (game, _) async {
        game.cat.jump();
        final velocityAfterFirstJump = game.cat.velocityY;
        game.update(0.05); // Move into air
        game.cat.jump(); // Should be ignored
        // Gravity has been applied for 0.05s, so velocity should be
        // jumpImpulse + gravity*dt, NOT a fresh jumpImpulse
        expect(
          game.cat.velocityY,
          isNot(closeTo(GameConstants.jumpImpulse, 0.1)),
        );
        expect(
          game.cat.velocityY,
          closeTo(
              velocityAfterFirstJump + GameConstants.gravity * 0.05, 1.0),
        );
      },
    );
  });
}
