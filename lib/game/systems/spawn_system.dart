import 'dart:math';

import 'package:flame/components.dart';

import '../../core/constants.dart';
import '../components/obstacles/bin_obstacle.dart';
import '../components/obstacles/dog_obstacle.dart';
import '../components/obstacles/fence_obstacle.dart';
import '../components/obstacles/obstacle_component.dart';
import '../components/obstacles/puddle_obstacle.dart';
import '../feline_dash_game.dart';

/// Spawns obstacles off the right edge of the screen and recycles them via a
/// pool once they scroll past the left edge.
///
/// The spawn interval shrinks linearly as [DifficultySystem.speed] increases,
/// clamped to [GameConstants.minObstacleInterval] and
/// [GameConstants.maxObstacleInterval].
class SpawnSystem extends Component with HasGameReference<FelineDashGame> {
  SpawnSystem({Random? random}) : _random = random ?? Random();

  final Random _random;

  double _elapsed = 0.0;
  double _nextInterval = GameConstants.maxObstacleInterval;

  // ── Obstacle pools ────────────────────────────────────────────────────────

  final List<DogObstacle> _dogPool = [];
  final List<BinObstacle> _binPool = [];
  final List<FenceObstacle> _fencePool = [];
  final List<PuddleObstacle> _puddlePool = [];

  // ── Spawn types ───────────────────────────────────────────────────────────

  static const int _obstacleTypeCount = 4;

  @override
  void update(double dt) {
    super.update(dt);

    _elapsed += dt;
    if (_elapsed >= _nextInterval) {
      _elapsed = 0.0;
      _nextInterval = _computeInterval();
      _spawnNext();
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  /// Lerp the interval from max → min as speed goes from initialSpeed → maxSpeed.
  double _computeInterval() {
    final t = ((game.difficultySystem.speed - GameConstants.initialSpeed) /
            (GameConstants.maxSpeed - GameConstants.initialSpeed))
        .clamp(0.0, 1.0);
    final base = GameConstants.maxObstacleInterval +
        t * (GameConstants.minObstacleInterval - GameConstants.maxObstacleInterval);
    // Add a small random jitter (±20 %) to break rhythmic patterns.
    final jitter = ((_random.nextDouble() * 2) - 1) * base * 0.2;
    return (base + jitter)
        .clamp(GameConstants.minObstacleInterval, GameConstants.maxObstacleInterval);
  }

  void _spawnNext() {
    final type = _random.nextInt(_obstacleTypeCount);
    switch (type) {
      case 0:
        game.add(_acquire(_dogPool, DogObstacle.new));
      case 1:
        game.add(_acquire(_binPool, BinObstacle.new));
      case 2:
        game.add(_acquire(_fencePool, FenceObstacle.new));
      case 3:
        game.add(_acquire(_puddlePool, PuddleObstacle.new));
    }
  }

  /// Returns a pooled instance if one is available, otherwise creates a new one.
  T _acquire<T extends ObstacleComponent>(
    List<T> pool,
    T Function() factory,
  ) {
    if (pool.isNotEmpty) {
      final obstacle = pool.removeLast();
      // Reset position to spawn point; onLoad already ran so skip full reload.
      obstacle.position.x = game.size.x + obstacle.size.x;
      obstacle.position.y = GameConstants.groundY - obstacle.size.y;
      return obstacle;
    }
    return factory();
  }

  /// Called by [ObstacleComponent] (or the game) to return an obstacle to the pool.
  void recycle(ObstacleComponent obstacle) {
    switch (obstacle) {
      case DogObstacle dog:
        _dogPool.add(dog);
      case BinObstacle bin:
        _binPool.add(bin);
      case FenceObstacle fence:
        _fencePool.add(fence);
      case PuddleObstacle puddle:
        _puddlePool.add(puddle);
    }
  }
}
