import 'package:flutter/services.dart';

/// Единая точка тактильной обратной связи — чтобы вибрация по всему
/// приложению была последовательной и её было легко настроить в одном
/// месте (в том числе выключить целиком). Используется точечно, только
/// там, где отклик физически осмыслен — не на каждое нажатие.
abstract final class Haptics {
  /// Общий выключатель — синхронизируется с настройкой пользователя
  /// (см. haptics_provider.dart). Пока провайдер не создан, вибрация
  /// включена по умолчанию.
  static bool enabled = true;

  /// Лёгкий тик — переключение вкладки, сегмента, шаг онбординга,
  /// печатающийся текст на сплэше.
  static void select() {
    if (enabled) HapticFeedback.selectionClick();
  }

  /// Позитивное завершение нейтрального действия — взнос в цель,
  /// восстановление бэкапа.
  static void success() {
    if (enabled) HapticFeedback.lightImpact();
  }

  /// Доход — деньги зачислены на счёт.
  static void income() {
    if (enabled) HapticFeedback.lightImpact();
  }

  /// Расход — деньги списаны со счёта.
  static void expense() {
    if (enabled) HapticFeedback.mediumImpact();
  }

  /// Удаление — свайп или подтверждённое удаление записи.
  static void delete() {
    if (enabled) HapticFeedback.mediumImpact();
  }

  /// Ошибка ввода — не распознана строка быстрого ввода и т.п.
  static void error() {
    if (enabled) HapticFeedback.vibrate();
  }

  /// Необратимое/предупреждающее действие — сброс приложения.
  static void warning() {
    if (enabled) HapticFeedback.heavyImpact();
  }
}
