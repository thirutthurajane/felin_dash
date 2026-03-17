import '../../core/constants.dart';

/// Pure Dart scoring logic — no Flame dependency.
class ScoreSystem {
  int _score = 0;
  int _fishCount = 0;
  int _multiplier = 1;

  int get score => _score;
  int get multiplier => _multiplier;

  void addDistanceScore(double dt) {
    _score += (GameConstants.scorePerMeter * dt * _multiplier).round();
  }

  void addFish() {
    _score += GameConstants.fishTokenValue * _multiplier;
    _fishCount++;
    if (_fishCount % GameConstants.multiplierFishThreshold == 0) {
      _multiplier++;
    }
  }

  void reset() {
    _score = 0;
    _fishCount = 0;
    _multiplier = 1;
  }
}
