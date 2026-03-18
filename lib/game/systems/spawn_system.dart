import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../core/constants.dart';
import '../components/collectibles/catnip_powerup.dart';
import '../components/collectibles/fish_token.dart';
import '../components/collectibles/milk_bottle.dart';
import '../components/collectibles/yarn_ball.dart';
import '../components/obstacles/bin_obstacle.dart';
import '../components/obstacles/dog_obstacle.dart';
import '../components/obstacles/fence_obstacle.dart';
import '../components/obstacles/puddle_obstacle.dart';
import '../feline_dash_game.dart';

/// Handles obstacle and collectible spawning using a timer-based approach.
///
/// Spawn intervals shrink as [DifficultySystem.speed] increases.
/// Collectibles are spawned on a separate, randomised interval.
class SpawnSystem extends Component with HasGameReference<FelineDashGame> {
  final _rng = Random();

  double _obstacleElapsed = 0.0;
  double _collectibleElapsed = 0.0;

  double _nextObstacleInterval = 0.0;
  double _nextCollectibleInterval = 0.0;

  @override
  void onMount() {
    super.onMount();
    _nextObstacleInterval = _computeObstacleInterval();
    _nextCollectibleInterval = _computeCollectibleInterval();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _obstacleElapsed += dt;
    _collectibleElapsed += dt;

    if (_obstacleElapsed >= _nextObstacleInterval) {
      _obstacleElapsed = 0;
      _nextObstacleInterval = _computeObstacleInterval();
      _spawnObstacle();
    }

    if (_collectibleElapsed >= _nextCollectibleInterval) {
      _collectibleElapsed = 0;
      _nextCollectibleInterval = _computeCollectibleInterval();
      _spawnCollectible();
    }
  }

  // ── Interval computation ──────────────────────────────────────────────────

  double _computeObstacleInterval() {
    final speedRange =
        GameConstants.maxSpeed - GameConstants.initialSpeed;
    final t = ((game.difficultySystem.speed - GameConstants.initialSpeed) /
            speedRange)
        .clamp(0.0, 1.0);
    return lerpDouble(
      GameConstants.maxObstacleInterval,
      GameConstants.minObstacleInterval,
      t,
    )!;
  }

  double _computeCollectibleInterval() {
    return GameConstants.minCollectibleInterval +
        _rng.nextDouble() *
            (GameConstants.maxCollectibleInterval -
                GameConstants.minCollectibleInterval);
  }

  // ── Spawners ─────────────────────────────────────────────────────────────

  void _spawnObstacle() {
    final obstacle = switch (_rng.nextInt(4)) {
      0 => DogObstacle(),
      1 => BinObstacle(),
      2 => FenceObstacle(),
      _ => PuddleObstacle(),
    };
    game.add(obstacle);
  }

  void _spawnCollectible() {
    final spawnX = game.size.x + SpriteConfig.fishTokenSize;

    // 70 % chance of a fish token, 10 % each for the three power-ups.
    final roll = _rng.nextDouble();
    if (roll < 0.70) {
      game.add(FishToken(spawnX: spawnX));
    } else if (roll < 0.80) {
      game.add(CatnipPowerup(spawnX: spawnX));
    } else if (roll < 0.90) {
      game.add(YarnBall(spawnX: spawnX));
    } else {
      game.add(MilkBottle(spawnX: spawnX));
    }
  }
}
