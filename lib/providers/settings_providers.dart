import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/settings.dart';
import '../data/repositories/in_memory_settings_repository.dart';
import '../data/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => InMemorySettingsRepository(),
);

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier(this._repository) : super(const Settings()) {
    _load();
  }

  final SettingsRepository _repository;

  Future<void> _load() async {
    state = await _repository.loadSettings();
  }

  Future<void> setSfx({required bool enabled}) async {
    final updated = state.copyWith(sfxEnabled: enabled);
    await _repository.saveSettings(updated);
    state = updated;
  }

  Future<void> setBgm({required bool enabled}) async {
    final updated = state.copyWith(bgmEnabled: enabled);
    await _repository.saveSettings(updated);
    state = updated;
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(ref.read(settingsRepositoryProvider)),
);
