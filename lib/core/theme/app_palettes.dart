import 'package:flutter/material.dart';

import '../constants/app_theme_variant.dart';
import 'app_colors_ext.dart';

/// Палитры для трёх тем. Акцент `#4a7dfb` общий для всех.
abstract final class AppPalettes {
  static const Color _accent = Color(0xFF4A7DFB);
  static const Color _onAccent = Color(0xFFFFFFFF);

  static const AppColorsExt dark = AppColorsExt(
    background: Color(0xFF0D0D10),
    surface: Color(0xFF17171B),
    surfaceVariant: Color(0xFF202026),
    divider: Color(0xFF2A2A31),
    accent: _accent,
    onAccent: _onAccent,
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF9A9AA5),
    textTertiary: Color(0xFF5C5C66),
    income: Color(0xFF3ED598),
    expense: Color(0xFFFF6B6B),
    warning: Color(0xFFFFB648),
  );

  /// Чистый чёрный OLED: та же тёмная тема, но фон и поверхности — #000000
  /// (экономия батареи на AMOLED-экранах), карточки отделяются рамкой.
  static const AppColorsExt oled = AppColorsExt(
    background: Color(0xFF000000),
    surface: Color(0xFF000000),
    surfaceVariant: Color(0xFF0D0D0F),
    divider: Color(0xFF232327),
    accent: _accent,
    onAccent: _onAccent,
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF9A9AA5),
    textTertiary: Color(0xFF5C5C66),
    income: Color(0xFF3ED598),
    expense: Color(0xFFFF6B6B),
    warning: Color(0xFFFFB648),
  );

  static const AppColorsExt light = AppColorsExt(
    background: Color(0xFFF7F7F9),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEDEDF2),
    divider: Color(0xFFE1E1E7),
    accent: _accent,
    onAccent: _onAccent,
    textPrimary: Color(0xFF14141A),
    textSecondary: Color(0xFF63636E),
    textTertiary: Color(0xFFA0A0AA),
    income: Color(0xFF1FAE74),
    expense: Color(0xFFDB3B35),
    warning: Color(0xFFC97A0A),
  );

  static AppColorsExt forVariant(AppThemeVariant variant) => switch (variant) {
        AppThemeVariant.dark => dark,
        AppThemeVariant.light => light,
        AppThemeVariant.oled => oled,
      };
}
