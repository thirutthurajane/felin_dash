import '../models/score_record.dart';
import 'score_repository.dart';

/// In-memory stub implementation used until persistent storage is wired up.
class InMemoryScoreRepository implements ScoreRepository {
  int _highScore = 0;
  final List<ScoreRecord> _records = [];

  @override
  Future<int> getHighScore() async => _highScore;

  @override
  Future<void> saveHighScore(int score) async {
    if (score > _highScore) _highScore = score;
    _records.add(ScoreRecord(score: score, achievedAt: DateTime.now()));
  }

  @override
  Future<List<ScoreRecord>> getRecentScores() async =>
      List.unmodifiable(_records);
}
