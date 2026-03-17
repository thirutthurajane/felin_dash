class Settings {
  final bool sfxEnabled;
  final bool bgmEnabled;

  const Settings({
    this.sfxEnabled = true,
    this.bgmEnabled = true,
  });

  Settings copyWith({bool? sfxEnabled, bool? bgmEnabled}) {
    return Settings(
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      bgmEnabled: bgmEnabled ?? this.bgmEnabled,
    );
  }
}
