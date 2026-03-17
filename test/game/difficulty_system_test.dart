import 'package:feline_dash/core/constants.dart';
import 'package:feline_dash/game/feline_dash_game.dart';
import 'package:feline_dash/game/systems/difficulty_system.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final gameTester = FlameTester(FelineDashGame.new);

  group('DifficultySystem', () {
    gameTester.testGameWidget(
      'speed starts at initialSpeed',
      verify: (game, _) async {
        expect(
          game.difficultySystem.speed,
          equals(GameConstants.initialSpeed),
        );
      },
    );

    gameTester.testGameWidget(
      'speed increments by speedIncrement * dt each frame',
      verify: (game, _) async {
        game.sfxEnabled = false;
        const dt = 1.0; // 1 second
        game.update(dt);
        expect(
          game.difficultySystem.speed,
          closeTo(
            GameConstants.initialSpeed + GameConstants.speedIncrement * dt,
            0.1,
          ),
        );
      },
    );

    gameTester.testGameWidget(
      'speed is hard-capped at maxSpeed',
      verify: (game, _) async {
        game.sfxEnabled = false;
        // Advance enough time for speed to exceed maxSpeed
        // From 300 to 900 at 15/s = 40 seconds
        for (int i = 0; i < 50; i++) {
          game.update(1.0);
        }
        expect(
          game.difficultySystem.speed,
          equals(GameConstants.maxSpeed),
        );
      },
    );

    gameTester.testGameWidget(
      'distance accumulates based on speed * dt',
      verify: (game, _) async {
        game.sfxEnabled = false;
        const dt = 1.0;
        final speedBefore = game.difficultySystem.speed;
        game.update(dt);
        // Distance after first frame should be approximately speedBefore * dt
        // (speed also changes during the frame, but close enough)
        expect(game.difficultySystem.distanceTravelled, greaterThan(0));
        expect(
          game.difficultySystem.distanceTravelled,
          closeTo(speedBefore * dt, GameConstants.speedIncrement * dt),
        );
      },
    );

    gameTester.testGameWidget(
      'milestone callback fires at 500m',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final milestones = <double>[];
        game.difficultySystem.onMilestone = (distance) {
          milestones.add(distance);
        };
        // Advance until past 500m at initial speed of 300 px/s
        // 500 / 300 ≈ 1.67s, use small steps
        for (int i = 0; i < 200; i++) {
          game.update(0.01);
        }
        expect(
          game.difficultySystem.distanceTravelled,
          greaterThanOrEqualTo(GameConstants.milestoneInterval),
        );
        expect(milestones, contains(GameConstants.milestoneInterval));
      },
    );

    gameTester.testGameWidget(
      'milestone callback fires again at 1000m',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final milestones = <double>[];
        game.difficultySystem.onMilestone = (distance) {
          milestones.add(distance);
        };
        // Advance until past 1000m
        for (int i = 0; i < 400; i++) {
          game.update(0.01);
        }
        expect(milestones, contains(GameConstants.milestoneInterval));
        expect(milestones, contains(GameConstants.milestoneInterval * 2));
      },
    );

    gameTester.testGameWidget(
      'milestone callback does not fire between milestones',
      verify: (game, _) async {
        game.sfxEnabled = false;
        final milestones = <double>[];
        game.difficultySystem.onMilestone = (distance) {
          milestones.add(distance);
        };
        // Advance just a tiny bit — well under 500m
        game.update(0.1);
        expect(milestones, isEmpty);
      },
    );
  });
}
