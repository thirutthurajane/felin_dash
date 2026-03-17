import '../models/settings.dart';

abstract interface class SettingsRepository {
  Future<Settings> loadSettings();
  Future<void> saveSettings(Settings settings);
}
