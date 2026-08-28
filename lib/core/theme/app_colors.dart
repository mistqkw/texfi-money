import 'package:flutter/material.dart';

/// Цветовая палитра TexFi m0ney. Тёмная тема — единственная в MVP.
abstract final class AppColors {
  // Фон
  static const Color background = Color(0xFF0D0D10);
  static const Color surface = Color(0xFF17171B);
  static const Color surfaceVariant = Color(0xFF202026);
  static const Color divider = Color(0xFF2A2A31);

  // Акцент
  static const Color accent = Color(0xFF4A7DFB);
  static const Color onAccent = Color(0xFFFFFFFF);

  // Текст
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9A9AA5);
  static const Color textTertiary = Color(0xFF5C5C66);

  // Финансовая семантика
  static const Color income = Color(0xFF3ED598);
  static const Color expense = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFB648);

  // Палитра для категорий и графиков (порядок задаёт приоритет выбора)
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
