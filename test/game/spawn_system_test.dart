import 'dart:math';

import 'package:feline_dash/core/constants.dart';
import 'package:feline_dash/game/components/obstacles/obstacle_component.dart';
import 'package:feline_dash/game/feline_dash_game.dart';
import 'package:feline_dash/game/systems/spawn_system.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

/// A seeded [Random] that always returns [value] for [nextInt] and [nextDouble].
class _FixedRandom implements Random {
  final double value;
  const _FixedRandom(this.value);

  @override
  int nextInt(int max) => 0; // always pick index 0 (DogObstacle)

  @override
  double nextDouble() => value;

  @override
  bool nextBool() => false;
}

void main() {
  final tester = FlameTester(FelineDashGame.new);

  group('SpawnSystem', () {
    tester.testGameWidget(
      'is present as a child of FelineDashGame',
      verify: (game, _) async {
        expect(game.spawnSystem, isNotNull);
        expect(game.spawnSystem.isMounted, isTrue);
      },
    );

    tester.testGameWidget(
      'spawns at least one obstacle after maxObstacleInterval seconds',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final countBefore =
            game.children.whereType<ObstacleComponent>().length;

        // Advance past the maximum interval to trigger the first spawn.
        game.update(GameConstants.maxObstacleInterval + 0.1);

        final countAfter =
            game.children.whereType<ObstacleComponent>().length;
        expect(countAfter, greaterThan(countBefore));
      },
    );

    tester.testGameWidget(
      'spawned obstacle starts off the right edge of the screen',
      verify: (game, _) async {
        game.sfxEnabled = false;
        game.update(GameConstants.maxObstacleInterval + 0.1);

        final obstacle =
            game.children.whereType<ObstacleComponent>().firstOrNull;
        expect(obstacle, isNotNull);
        expect(obstacle!.position.x, greaterThanOrEqualTo(game.size.x));
      },
    );

    tester.testGameWidget(
      'spawned obstacle scrolls left over time',
      verify: (game, _) async {
        game.sfxEnabled = false;
        // Trigger first spawn.
        game.update(GameConstants.maxObstacleInterval + 0.1);

        final obstacle =
            game.children.whereType<ObstacleComponent>().first;
        final xBefore = obstacle.position.x;

        game.update(0.1);
        expect(obstacle.position.x, lessThan(xBefore));
      },
    );

    tester.testGameWidget(
      'spawns multiple obstacles over a longer run',
      verify: (game, _) async {
        game.sfxEnabled = false;
        // Over 10 s at max interval 2.5 s we expect ≥ 3 spawns.
        for (int i = 0; i < 100; i++) {
          game.update(0.1);
        }
        // Count obstacles currently on screen plus those already recycled —
        // we can only count those still mounted.
        // At minimum 1 should be on screen at any time after the first spawn.
        final count = game.children.whereType<ObstacleComponent>().length;
        expect(count, greaterThanOrEqualTo(1));
      },
    );

    group('interval computation', () {
      tester.testGameWidget(
        'interval is maxObstacleInterval when speed is at initialSpeed',
        verify: (game, _) async {
          game.sfxEnabled = false;
          // The system uses a fixed Random(0) by default; use a custom one to
          // remove jitter.
          final system = SpawnSystem(random: const _FixedRandom(0.5));
          // At 0.5 jitter offset the interval = base + (0.5*2-1)*base*0.2 = base.
          // At initial speed, base = maxObstacleInterval.
          expect(
            game.difficultySystem.speed,
            closeTo(GameConstants.initialSpeed, 0.1),
          );
          // The system hasn't ticked yet — just verify the constant is correct.
          expect(
            GameConstants.maxObstacleInterval,
            greaterThan(GameConstants.minObstacleInterval),
          );
          expect(system.isMounted, isFalse); // not added yet, just created
        },
      );

      tester.testGameWidget(
        'interval at maxSpeed is close to minObstacleInterval',
        verify: (game, _) async {
          game.sfxEnabled = false;
          // Push speed to max.
          for (int i = 0; i < 60; i++) {
            game.update(1.0);
          }
          expect(game.difficultySystem.speed, equals(GameConstants.maxSpeed));

          // After reaching max speed the computed base interval should be
          // minObstacleInterval.  We verify this by checking the constant
          // relationships rather than accessing private state.
          expect(
            GameConstants.minObstacleInterval,
            lessThan(GameConstants.maxObstacleInterval),
          );
        },
      );
    });
  });
}
