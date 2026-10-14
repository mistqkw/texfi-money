import 'package:flutter/material.dart';

import '../constants/app_theme_variant.dart';
import 'app_colors_ext.dart';

/// Палитры для трёх тем. Акцент `#4a7dfb` общий для всех.
abstract final class AppPalettes {
  static const Color _accent = Color(0xFF4A7DFB);

  /// Тень под акцентной кнопкой в тёмных темах — глубокий синий.
  static const Color _accentShadowDark = Color(0xFF2B4FB0);
  static const Color _onAccent = Color(0xFFFFFFFF);

  static const AppColorsExt dark = AppColorsExt(
    background: Color(0xFF0D0D10),
    // Поверхность заметно светлее фона: раньше разница между #0D0D10 и
    // #17171B была на грани различимого, и карточка читалась как пятно,
    // а не как предмет.
    surface: Color(0xFF1C1C22),
    surfaceVariant: Color(0xFF26262E),
    divider: Color(0xFF2A2A31),
    border: Color(0xFF45454F),
    // Тень темнее фона — иначе на чёрном она превращается во вторую
    // рамку и карточка выглядит обведённой дважды.
    shadow: Color(0xFF000000),
    accent: _accent,
    accentShadow: _accentShadowDark,
    onAccent: _onAccent,
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF9A9AA5),
    textTertiary: Color(0xFF5C5C66),
    income: Color(0xFF3ED598),
    expense: Color(0xFFFF6B6B),
    warning: Color(0xFFFFB648),
    noise: Color(0x0DFFFFFF),
  );

  /// Чистый чёрный OLED: та же тёмная тема, но фон и поверхности — #000000
  /// (экономия батареи на AMOLED-экранах), карточки отделяются рамкой.
  static const AppColorsExt oled = AppColorsExt(
    background: Color(0xFF000000),
    surface: Color(0xFF000000),
    surfaceVariant: Color(0xFF0D0D0F),
    divider: Color(0xFF232327),
    // На чистом чёрном тень невидима по определению, поэтому объём здесь
    // держит только рамка — и она ярче, чем в обычной тёмной теме.
    border: Color(0xFF3E3E48),
    shadow: Color(0xFF1A1A1F),
    accent: _accent,
    accentShadow: _accentShadowDark,
    onAccent: _onAccent,
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFF9A9AA5),
    textTertiary: Color(0xFF5C5C66),
    income: Color(0xFF3ED598),
    expense: Color(0xFFFF6B6B),
    warning: Color(0xFFFFB648),
    noise: Color(0x0DFFFFFF),
  );

  /// Светлая тема hairline: нейтральная, не «бумажная».
  static const AppColorsExt light = AppColorsExt(
    background: Color(0xFFF6F6F3),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEFEFEB),
    divider: Color(0xFFDCDCD6),
    border: Color(0xFFC9C9C2),
    shadow: Color(0xFFDCDCD6),
    accent: _accent,
    accentShadow: Color(0xFF2B4FB0),
    onAccent: _onAccent,
    textPrimary: Color(0xFF0C0C0F),
    textSecondary: Color(0xFF55555E),
    textTertiary: Color(0xFF8A8A92),
    income: Color(0xFF1B9E66),
    expense: Color(0xFFD64545),
    warning: Color(0xFFD98A2B),
    noise: Color(0x14000000),
  );

  static AppColorsExt forVariant(AppThemeVariant variant) => switch (variant) {
        AppThemeVariant.dark => dark,
        AppThemeVariant.light => light,
        AppThemeVariant.oled => oled,
      };
}
