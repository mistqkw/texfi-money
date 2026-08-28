enum AppFont {
  inter,
  roboto,
  manrope,
  system;

  String get storageKey => name;

  static AppFont fromStorageKey(String? key) {
    return AppFont.values.firstWhere(
      (f) => f.storageKey == key,
      orElse: () => AppFont.inter,
    );
  }
}
