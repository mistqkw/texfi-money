import 'package:flutter/material.dart';

/// Цвета, не зависящие от выбранной темы — используются в местах без
/// доступа к BuildContext (сидинг категорий в БД) и как палитра выбора
/// цвета категории/цели, единая для всех тем.
abstract final class AppColors {
  static const Color accent = Color(0xFF4A7DFB);
  static const Color income = Color(0xFF3ED598);
  static const Color expense = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFB648);

  /// Порядок задаёт приоритет выбора при автосоздании.
  static const List<Color> categoryPalette = [
    accent,
    income,
    expense,
    warning,
    Color(0xFFB980FF),
    Color(0xFF3ED5D5),
    Color(0xFFFF8FCF),
    Color(0xFFC8D96F),
  ];
}
