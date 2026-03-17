import 'package:feline_dash/core/constants.dart';
import 'package:feline_dash/game/components/obstacles/bin_obstacle.dart';
import 'package:feline_dash/game/components/obstacles/dog_obstacle.dart';
import 'package:feline_dash/game/components/obstacles/fence_obstacle.dart';
import 'package:feline_dash/game/components/obstacles/obstacle_component.dart';
import 'package:feline_dash/game/components/obstacles/puddle_obstacle.dart';
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

  // ── Type hierarchy ────────────────────────────────────────────────────────

  group('DogObstacle', () {
    tester.testGameWidget(
      'is an ObstacleComponent',
      verify: (game, _) async {
        final obstacle = DogObstacle();
        expect(obstacle, isA<ObstacleComponent>());
      },
    );

    tester.testGameWidget(
      'has a RectangleHitbox after load',
      verify: (game, _) async {
        final obstacle = DogObstacle();
        await game.add(obstacle);
        await game.ready();
        final hitboxes = obstacle.children.whereType<RectangleHitbox>();
        expect(hitboxes, isNotEmpty);
      },
    );

    tester.testGameWidget(
      'hitbox height is tall (>= 56 px)',
      verify: (game, _) async {
        final obstacle = DogObstacle();
        await game.add(obstacle);
        await game.ready();
        final hitbox = obstacle.children.whereType<RectangleHitbox>().first;
        expect(hitbox.size.y, greaterThanOrEqualTo(56.0));
      },
    );

    tester.testGameWidget(
      'hitbox size matches DogObstacle spec from SpriteConfig',
      verify: (game, _) async {
        final obstacle = DogObstacle();
        await game.add(obstacle);
        await game.ready();
        final hitbox = obstacle.children.whereType<RectangleHitbox>().first;
        expect(hitbox.size.x, closeTo(SpriteConfig.dogHitboxWidth, 0.1));
        expect(hitbox.size.y, closeTo(SpriteConfig.dogHitboxHeight, 0.1));
      },
    );

    tester.testGameWidget(
      'sits on the ground (bottom edge at groundY)',
      verify: (game, _) async {
        final obstacle = DogObstacle();
        await game.add(obstacle);
        await game.ready();
        expect(
          obstacle.position.y + obstacle.size.y,
          closeTo(GameConstants.groundY, 1.0),
        );
      },
    );

    tester.testGameWidget(
      'scrolls left each frame',
      verify: (game, _) async {
        final obstacle = DogObstacle();
        await game.add(obstacle);
        await game.ready();
        final xBefore = obstacle.position.x;
        game.update(0.1);
        expect(obstacle.position.x, lessThan(xBefore));
      },
    );
  });

  // ── BinObstacle ───────────────────────────────────────────────────────────

  group('BinObstacle', () {
    tester.testGameWidget(
      'is an ObstacleComponent',
      verify: (game, _) async {
        final obstacle = BinObstacle();
        expect(obstacle, isA<ObstacleComponent>());
      },
    );

    tester.testGameWidget(
      'has a RectangleHitbox after load',
      verify: (game, _) async {
        final obstacle = BinObstacle();
        await game.add(obstacle);
        await game.ready();
        final hitboxes = obstacle.children.whereType<RectangleHitbox>();
        expect(hitboxes, isNotEmpty);
      },
    );

    tester.testGameWidget(
      'hitbox is medium size (width and height between 32–64 px)',
      verify: (game, _) async {
        final obstacle = BinObstacle();
        await game.add(obstacle);
        await game.ready();
        final hitbox = obstacle.children.whereType<RectangleHitbox>().first;
        expect(hitbox.size.x, closeTo(SpriteConfig.binHitboxWidth, 0.1));
        expect(hitbox.size.y, closeTo(SpriteConfig.binHitboxHeight, 0.1));
      },
    );

    tester.testGameWidget(
      'sits on the ground (bottom edge at groundY)',
      verify: (game, _) async {
        final obstacle = BinObstacle();
        await game.add(obstacle);
        await game.ready();
        expect(
          obstacle.position.y + obstacle.size.y,
          closeTo(GameConstants.groundY, 1.0),
        );
      },
    );

    tester.testGameWidget(
      'scrolls left each frame',
      verify: (game, _) async {
        final obstacle = BinObstacle();
        await game.add(obstacle);
        await game.ready();
        final xBefore = obstacle.position.x;
        game.update(0.1);
        expect(obstacle.position.x, lessThan(xBefore));
      },
    );
  });

  // ── FenceObstacle ─────────────────────────────────────────────────────────

  group('FenceObstacle', () {
    tester.testGameWidget(
      'is an ObstacleComponent',
      verify: (game, _) async {
        final obstacle = FenceObstacle();
        expect(obstacle, isA<ObstacleComponent>());
      },
    );

    tester.testGameWidget(
      'has a RectangleHitbox after load',
      verify: (game, _) async {
        final obstacle = FenceObstacle();
        await game.add(obstacle);
        await game.ready();
        final hitboxes = obstacle.children.whereType<RectangleHitbox>();
        expect(hitboxes, isNotEmpty);
      },
    );

    tester.testGameWidget(
      'hitbox is short and wide (width > height, height <= 32 px)',
      verify: (game, _) async {
        final obstacle = FenceObstacle();
        await game.add(obstacle);
        await game.ready();
        final hitbox = obstacle.children.whereType<RectangleHitbox>().first;
        expect(hitbox.size.x, closeTo(SpriteConfig.fenceHitboxWidth, 0.1));
        expect(hitbox.size.y, closeTo(SpriteConfig.fenceHitboxHeight, 0.1));
        expect(hitbox.size.x, greaterThan(hitbox.size.y));
      },
    );

    tester.testGameWidget(
      'sits on the ground (bottom edge at groundY)',
      verify: (game, _) async {
        final obstacle = FenceObstacle();
        await game.add(obstacle);
        await game.ready();
        expect(
          obstacle.position.y + obstacle.size.y,
          closeTo(GameConstants.groundY, 1.0),
        );
      },
    );

    tester.testGameWidget(
      'scrolls left each frame',
      verify: (game, _) async {
        final obstacle = FenceObstacle();
        await game.add(obstacle);
        await game.ready();
        final xBefore = obstacle.position.x;
        game.update(0.1);
        expect(obstacle.position.x, lessThan(xBefore));
      },
    );
  });

  // ── PuddleObstacle ────────────────────────────────────────────────────────

  group('PuddleObstacle', () {
    tester.testGameWidget(
      'is an ObstacleComponent',
      verify: (game, _) async {
        final obstacle = PuddleObstacle();
        expect(obstacle, isA<ObstacleComponent>());
      },
    );

    tester.testGameWidget(
      'has a RectangleHitbox after load',
      verify: (game, _) async {
        final obstacle = PuddleObstacle();
        await game.add(obstacle);
        await game.ready();
        final hitboxes = obstacle.children.whereType<RectangleHitbox>();
        expect(hitboxes, isNotEmpty);
      },
    );

    tester.testGameWidget(
      'hitbox is very short and very wide (height <= 18 px, width >= 80 px)',
      verify: (game, _) async {
        final obstacle = PuddleObstacle();
        await game.add(obstacle);
        await game.ready();
        final hitbox = obstacle.children.whereType<RectangleHitbox>().first;
        expect(hitbox.size.x, closeTo(SpriteConfig.puddleHitboxWidth, 0.1));
        expect(hitbox.size.y, closeTo(SpriteConfig.puddleHitboxHeight, 0.1));
        expect(hitbox.size.x, greaterThan(hitbox.size.y * 4));
      },
    );

    tester.testGameWidget(
      'sits on the ground (bottom edge at groundY)',
      verify: (game, _) async {
        final obstacle = PuddleObstacle();
        await game.add(obstacle);
        await game.ready();
        expect(
          obstacle.position.y + obstacle.size.y,
          closeTo(GameConstants.groundY, 1.0),
        );
      },
    );

    tester.testGameWidget(
      'scrolls left each frame',
      verify: (game, _) async {
        final obstacle = PuddleObstacle();
        await game.add(obstacle);
        await game.ready();
        final xBefore = obstacle.position.x;
        game.update(0.1);
        expect(obstacle.position.x, lessThan(xBefore));
      },
    );
  });

  // ── Scroll-off removal ────────────────────────────────────────────────────

  group('obstacle removal', () {
    tester.testGameWidget(
      'DogObstacle is removed from parent when scrolled off-screen left',
      verify: (game, _) async {
        final obstacle = DogObstacle();
        await game.add(obstacle);
        await game.ready();
        // Move far off-screen
        obstacle.position.x = -obstacle.width - 10;
        game.update(0.016);
        expect(obstacle.isMounted, isFalse);
      },
    );

    tester.testGameWidget(
      'PuddleObstacle is removed from parent when scrolled off-screen left',
      verify: (game, _) async {
        final obstacle = PuddleObstacle();
        await game.add(obstacle);
        await game.ready();
        obstacle.position.x = -obstacle.width - 10;
        game.update(0.016);
        expect(obstacle.isMounted, isFalse);
      },
    );
  });
}
