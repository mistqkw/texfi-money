import 'package:flutter/material.dart';

/// Цвета, зависящие от выбранной темы (тёмная/светлая/OLED).
/// Доступ из виджетов — через `context.colors`.
class AppColorsExt extends ThemeExtension<AppColorsExt> {
  const AppColorsExt({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.divider,
    required this.border,
    required this.shadow,
    required this.accent,
    required this.accentShadow,
    required this.onAccent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.income,
    required this.expense,
    required this.warning,
    required this.noise,
  });

  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color divider;

  /// Рамка карточек, кнопок и полей — отдельно от [divider].
  ///
  /// Раньше и то и другое было одним тусклым серым. На тёмном фоне
  /// рамка 2px цветом `#2A2A31` не видна вовсе: весь пиксельный «объём»
  /// существовал в коде и не доходил до экрана. Разделительная линия
  /// внутри списка обязана быть тихой, а контур карточки — заметным,
  /// это разные задачи и разные цвета.
  final Color border;

  /// Сплошная тень со смещением под обычной карточкой или кнопкой.
  /// Ещё темнее фона в тёмных темах и тёплая коричневая в светлой —
  /// тень должна читаться как тень, а не как вторая рамка.
  final Color shadow;

  final Color accent;

  /// Цвет сплошной тени под акцентным элементом. Отдельный токен, а не
  /// «акцент потемнее»: в светлой теме фон кремовый, и синий блок под
  /// синей кнопкой сливается с ней в одно пятно — там тень тёплая
  /// оранжевая. Имя совпадает с f0kus намеренно: один и тот же токен в
  /// двух приложениях семьи не должен называться по-разному.
  final Color accentShadow;
  final Color onAccent;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color income;
  final Color expense;
  final Color warning;

  /// Цвет фоновой крапинки. Очень слабый — глаз замечает её как фактуру,
  /// но не как шум под текстом.
  final Color noise;

  @override
  AppColorsExt copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? divider,
    Color? border,
    Color? shadow,
    Color? accent,
    Color? accentShadow,
    Color? onAccent,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? income,
    Color? expense,
    Color? warning,
    Color? noise,
  }) {
    return AppColorsExt(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      divider: divider ?? this.divider,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      accent: accent ?? this.accent,
      accentShadow: accentShadow ?? this.accentShadow,
      onAccent: onAccent ?? this.onAccent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      warning: warning ?? this.warning,
      noise: noise ?? this.noise,
    );
  }

  @override
  AppColorsExt lerp(ThemeExtension<AppColorsExt>? other, double t) {
    if (other is! AppColorsExt) return this;
    return AppColorsExt(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      border: Color.lerp(border, other.border, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentShadow: Color.lerp(accentShadow, other.accentShadow, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      noise: Color.lerp(noise, other.noise, t)!,
    );
  }
}

extension AppColorsContextX on BuildContext {
  AppColorsExt get colors => Theme.of(this).extension<AppColorsExt>()!;
}
