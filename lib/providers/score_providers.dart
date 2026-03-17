import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/in_memory_score_repository.dart';
import '../data/repositories/score_repository.dart';

final scoreRepositoryProvider = Provider<ScoreRepository>(
  (ref) => InMemoryScoreRepository(),
);

class HighScoreNotifier extends StateNotifier<int> {
  HighScoreNotifier(this._repository) : super(0) {
    _load();
  }

  final ScoreRepository _repository;

  Future<void> _load() async {
    state = await _repository.getHighScore();
  }

  /// Called after a game ends to persist and surface the new high score.
  Future<void> submitScore(int score) async {
    await _repository.saveHighScore(score);
    state = await _repository.getHighScore();
  }
}

final highScoreProvider = StateNotifierProvider<HighScoreNotifier, int>(
  (ref) => HighScoreNotifier(ref.read(scoreRepositoryProvider)),
);
