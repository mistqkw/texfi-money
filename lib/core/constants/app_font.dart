/// Гарнитура основного текста.
///
/// Вариантов было четыре: Inter, Roboto, Manrope и системный. Roboto и
/// Manrope приезжали по сети через google_fonts — в приложении, которое
/// не выходит в сеть вообще, это была настройка, работающая только у того,
/// у кого в этот момент есть интернет. Лучше честно не предлагать то, чего
/// нет, чем показать пункт, который иногда молча не срабатывает.
///
/// Потеря при этом почти нулевая: на Android системная гарнитура и есть
/// Roboto, так что отдельным пунктом он дублировал «Системный».
enum AppFont {
  inter,
  system;

  String get storageKey => name;

  static AppFont fromStorageKey(String? key) {
    // Сохранённый выбор из прошлых версий переносится осмысленно, а не
    // сбрасывается в значение по умолчанию: тому, кто выбрал Roboto,
    // ближе всего системная гарнитура — на Android это он и есть.
    if (key == 'roboto') return AppFont.system;
    if (key == 'manrope') return AppFont.inter;
    return AppFont.values.firstWhere(
      (f) => f.storageKey == key,
      orElse: () => AppFont.inter,
    );
  }
}
