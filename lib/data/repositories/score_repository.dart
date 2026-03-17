import '../models/score_record.dart';

abstract interface class ScoreRepository {
  Future<int> getHighScore();
  Future<void> saveHighScore(int score);
  Future<List<ScoreRecord>> getRecentScores();
}
