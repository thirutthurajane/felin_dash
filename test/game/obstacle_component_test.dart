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
  final tester = FlameTester(FelineDashGame.new);

  // ── Helpers ────────────────────────────────────────────────────────────────

  Future<T> addAndLoad<T extends ObstacleComponent>(
    FelineDashGame game,
    T obstacle,
  ) async {
    await game.add(obstacle);
    await game.ready();
    return obstacle;
  }

  // ── DogObstacle ────────────────────────────────────────────────────────────

  group('DogObstacle', () {
    tester.testGameWidget(
      'size is 64 × 64',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final dog = await addAndLoad(game, DogObstacle());
        expect(dog.size.x, closeTo(64.0, 0.1));
        expect(dog.size.y, closeTo(64.0, 0.1));
      },
    );

    tester.testGameWidget(
      'spawns off the right edge of the screen',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final dog = await addAndLoad(game, DogObstacle());
        expect(dog.position.x, greaterThanOrEqualTo(game.size.x));
      },
    );

    tester.testGameWidget(
      'bottom edge sits at groundY',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final dog = await addAndLoad(game, DogObstacle());
        expect(
          dog.position.y + dog.size.y,
          closeTo(GameConstants.groundY, 0.1),
        );
      },
    );

    tester.testGameWidget(
      'has a RectangleHitbox child',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final dog = await addAndLoad(game, DogObstacle());
        final hitboxes = dog.children.whereType<RectangleHitbox>();
        expect(hitboxes, isNotEmpty);
      },
    );

    tester.testGameWidget(
      'scrolls left each frame',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final dog = await addAndLoad(game, DogObstacle());
        final xBefore = dog.position.x;
        const dt = 0.1;
        game.update(dt);
        expect(dog.position.x, lessThan(xBefore));
      },
    );

    tester.testGameWidget(
      'scroll distance matches difficultySystem.speed * dt',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final dog = await addAndLoad(game, DogObstacle());
        final xBefore = dog.position.x;
        final speed = game.difficultySystem.speed;
        const dt = 0.1;
        game.update(dt);
        expect(
          xBefore - dog.position.x,
          closeTo(speed * dt, 5.0), // allow for speed changing mid-frame
        );
      },
    );

    tester.testGameWidget(
      'is removed when fully past the left edge',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final dog = await addAndLoad(game, DogObstacle());
        // Force the obstacle far to the left.
        dog.position.x = -dog.size.x - 1;
        game.update(0.016);
        expect(dog.isMounted, isFalse);
      },
    );
  });

  // ── BinObstacle ────────────────────────────────────────────────────────────

  group('BinObstacle', () {
    tester.testGameWidget(
      'size is 48 × 48',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final bin = await addAndLoad(game, BinObstacle());
        expect(bin.size.x, closeTo(48.0, 0.1));
        expect(bin.size.y, closeTo(48.0, 0.1));
      },
    );

    tester.testGameWidget(
      'bottom edge sits at groundY',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final bin = await addAndLoad(game, BinObstacle());
        expect(
          bin.position.y + bin.size.y,
          closeTo(GameConstants.groundY, 0.1),
        );
      },
    );

    tester.testGameWidget(
      'has a RectangleHitbox child',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final bin = await addAndLoad(game, BinObstacle());
        expect(bin.children.whereType<RectangleHitbox>(), isNotEmpty);
      },
    );
  });

  // ── FenceObstacle ──────────────────────────────────────────────────────────

  group('FenceObstacle', () {
    tester.testGameWidget(
      'is wider than it is tall (slide-under shape)',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final fence = await addAndLoad(game, FenceObstacle());
        expect(fence.size.x, greaterThan(fence.size.y));
      },
    );

    tester.testGameWidget(
      'bottom edge sits at groundY',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final fence = await addAndLoad(game, FenceObstacle());
        expect(
          fence.position.y + fence.size.y,
          closeTo(GameConstants.groundY, 0.1),
        );
      },
    );

    tester.testGameWidget(
      'height is short enough for cat slide to clear (< catSlideFrameHeight)',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final fence = await addAndLoad(game, FenceObstacle());
        // Fence must be shorter than the cat's full height so the player can
        // choose to slide instead of jump.
        expect(fence.size.y, lessThan(64.0));
      },
    );

    tester.testGameWidget(
      'has a RectangleHitbox child',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final fence = await addAndLoad(game, FenceObstacle());
        expect(fence.children.whereType<RectangleHitbox>(), isNotEmpty);
      },
    );
  });

  // ── PuddleObstacle ─────────────────────────────────────────────────────────

  group('PuddleObstacle', () {
    tester.testGameWidget(
      'is very flat (width > 4× height)',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final puddle = await addAndLoad(game, PuddleObstacle());
        expect(puddle.size.x, greaterThan(puddle.size.y * 4));
      },
    );

    tester.testGameWidget(
      'bottom edge sits at groundY',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final puddle = await addAndLoad(game, PuddleObstacle());
        expect(
          puddle.position.y + puddle.size.y,
          closeTo(GameConstants.groundY, 0.1),
        );
      },
    );

    tester.testGameWidget(
      'has a RectangleHitbox child',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final puddle = await addAndLoad(game, PuddleObstacle());
        expect(puddle.children.whereType<RectangleHitbox>(), isNotEmpty);
      },
    );
  });
}
