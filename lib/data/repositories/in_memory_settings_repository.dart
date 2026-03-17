import '../models/settings.dart';
import 'settings_repository.dart';

/// In-memory stub implementation used until shared_preferences wiring is added.
class InMemorySettingsRepository implements SettingsRepository {
  Settings _settings = const Settings();

  @override
  Future<Settings> loadSettings() async => _settings;

  @override
  Future<void> saveSettings(Settings settings) async {
    _settings = settings;
  }
}
