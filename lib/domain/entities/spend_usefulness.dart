/// Оценка полезности траты — та, которую человек ставит сам.
///
/// Значения нет у большинства операций, и это отдельное состояние, а не
/// [SpendUsefulness.neutral]. Разница существенная: «нейтрально» — это
/// вывод, «не оценивал» — его отсутствие, и складывать их в статистике
/// значило бы посчитать за человека то, чего он не говорил.
enum SpendUsefulness {
  useful,
  useless,
  neutral;

  String get storageKey => name;

  /// `null` на входе — оценки нет; `null` на выходе означает то же самое.
  static SpendUsefulness? fromStorageKey(String? key) {
    if (key == null) return null;
    for (final value in SpendUsefulness.values) {
      if (value.storageKey == key) return value;
    }
    return null;
  }
}
