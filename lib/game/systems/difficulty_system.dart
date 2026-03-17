import 'package:flame/components.dart';

import '../../core/constants.dart';

/// Ramps world scroll speed from [GameConstants.initialSpeed] to [GameConstants.maxSpeed].
/// Tracks total distance travelled and fires [onMilestone] at every
/// [GameConstants.milestoneInterval] metres.
class DifficultySystem extends Component {
  double speed = GameConstants.initialSpeed;

  double _distanceTravelled = 0;
  double _lastMilestone = 0;

  /// Total distance the player has covered (in logical pixels ≈ metres).
  double get distanceTravelled => _distanceTravelled;

  /// Called when the player crosses a milestone distance (500 m, 1000 m, …).
  /// The argument is the milestone distance crossed.
  void Function(double distance)? onMilestone;

  @override
  void update(double dt) {
    super.update(dt);

    // Accumulate distance before speed changes this frame.
    _distanceTravelled += speed * dt;

    // Ramp speed linearly, hard-capped at maxSpeed.
    if (speed < GameConstants.maxSpeed) {
      speed = (speed + GameConstants.speedIncrement * dt)
          .clamp(0, GameConstants.maxSpeed);
    }

    // Check for milestone crossing.
    final nextMilestone = _lastMilestone + GameConstants.milestoneInterval;
    if (_distanceTravelled >= nextMilestone) {
      _lastMilestone = nextMilestone;
      onMilestone?.call(nextMilestone);
    }
  }
}
