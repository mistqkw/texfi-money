enum AppThemeVariant {
  dark,
  light,
  oled;

  String get storageKey => name;

  static AppThemeVariant fromStorageKey(String? key) {
    return AppThemeVariant.values.firstWhere(
      (v) => v.storageKey == key,
      orElse: () => AppThemeVariant.dark,
    );
  }
}
