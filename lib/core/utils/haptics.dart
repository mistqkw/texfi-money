import 'package:flutter/services.dart';

/// Единая точка тактильной обратной связи — чтобы вибрация по всему
/// приложению была последовательной и её было легко настроить в одном
/// месте. Используется точечно, только там, где отклик физически осмыслен
/// (выбор, успех, удаление, предупреждение) — не на каждое нажатие.
abstract final class Haptics {
  /// Лёгкий тик — переключение вкладки, сегмента, шаг онбординга.
  static void select() => HapticFeedback.selectionClick();

  /// Позитивное завершение действия — транзакция добавлена, взнос в цель.
  static void success() => HapticFeedback.lightImpact();

  /// Удаление — свайп или подтверждённое удаление записи.
  static void delete() => HapticFeedback.mediumImpact();

  /// Ошибка ввода — не распознана строка быстрого ввода и т.п.
  static void error() => HapticFeedback.vibrate();

  /// Необратимое/предупреждающее действие — сброс приложения.
  static void warning() => HapticFeedback.heavyImpact();
}
