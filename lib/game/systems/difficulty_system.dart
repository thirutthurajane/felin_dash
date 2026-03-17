import 'package:flame/components.dart';

import '../../core/constants.dart';

/// Ramps world scroll speed from [GameConstants.initialSpeed] to [GameConstants.maxSpeed].
class DifficultySystem extends Component {
  double speed = GameConstants.initialSpeed;

  @override
  void update(double dt) {
    super.update(dt);
    if (speed < GameConstants.maxSpeed) {
      speed = (speed + GameConstants.speedIncrement * dt)
          .clamp(0, GameConstants.maxSpeed);
    }
  }
}
