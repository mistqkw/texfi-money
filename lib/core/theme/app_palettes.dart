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

  /// «Ретро-бумага, Game Boy на солнце» — та же светлая палитра, что в
  /// TexFi f0kus и на сайте экосистемы, значение в значение.
  ///
  /// До этого здесь стоял серо-белый набор (#F7F7F9 / #FFFFFF): корректный,
  /// но ровно такой, какой Material отдаёт по умолчанию. Рядом с f0kus на
  /// одном экране это читалось как чужое приложение — светлая тема была
  /// единственным местом, где m0ney выпадал из семьи. Тёплый оранжево-
  /// бежевый ключ здесь не украшение, а признак принадлежности.
  static const AppColorsExt light = AppColorsExt(
    background: Color(0xFFFCF5E9),
    surface: Color(0xFFFFFBF3),
    surfaceVariant: Color(0xFFF3E6D2),
    divider: Color(0xFFE0CDB0),
    border: Color(0xFFB99C6E),
    shadow: Color(0xFFD6BE99),
    accent: _accent,
    accentShadow: Color(0xFFD98A2B),
    onAccent: _onAccent,
    textPrimary: Color(0xFF2A1F14),
    textSecondary: Color(0xFF6E5B45),
    textTertiary: Color(0xFFA08D72),
    // Доход и расход остаются семантическими: зелёный и красный здесь
    // подобраны под тёплый фон (на кремовом холодный #1FAE74 звенит), но
    // не уступают места фирменному синему — сумму читают по цвету раньше,
    // чем по знаку.
    income: Color(0xFF1B9E66),
    expense: Color(0xFFD64545),
    warning: Color(0xFFD98A2B),
    // Тёплая крапинка под цвет бумаги: белая на кремовом фоне не видна
    // вовсе, а серая делает его грязным.
    noise: Color(0x0F8A6A3D),
  );

  /// Бета-стиль «бумага и чернила». Фон — некрашеная бумага, текст —
  /// тёплая чёрная тушь, а бежевый с рисунка (`#D6B28E`) остаётся в
  /// знаке и в отметках, а не заливает весь экран: бумага, целиком
  /// окрашенная в бежевый, — это уже не бумага, а тема.
  ///
  /// Акцент — тот же бежевый, опущенный до тона, который читается
  /// текстом на бумаге: сам `#D6B28E` на ней почти не виден. Доход и
  /// расход — зелёные и красные чернила, а не экранные неоновые цвета.
  static const AppColorsExt beta = AppColorsExt(
    background: Color(0xFFF3EEE4),
    surface: Color(0xFFF7F3EB),
    surfaceVariant: Color(0xFFE9E2D5),
    divider: Color(0xFFD9CFBE),
    border: Color(0xFFB9AD99),
    shadow: Color(0x00000000),
    accent: Color(0xFF8A5B34),
    accentShadow: betaFill,
    onAccent: Color(0xFFF7F3EB),
    textPrimary: betaInk,
    textSecondary: Color(0xFF574D42),
    textTertiary: Color(0xFF8E8373),
    income: Color(0xFF2F6B3F),
    expense: Color(0xFFA63A28),
    warning: Color(0xFF9C6A14),
    noise: Color(0x0D1D1915),
  );

  /// Цвет категории, пересчитанный для бумаги: наполовину приглушённый
  /// и смешанный с тушью. Палитра категорий подобрана под экран — на
  /// тёмном фоне неоновый зелёный и электрический синий хороши, на
  /// бумаге они выглядят наклейками. Оттенок остаётся узнаваемым, так
  /// что категорию по-прежнему находят по цвету.
  static Color inkify(Color color) {
    final hsl = HSLColor.fromColor(color);
    final muted = hsl
        .withSaturation(hsl.saturation * 0.62)
        .withLightness((hsl.lightness * 0.72).clamp(0.0, 1.0))
        .toColor();
    return Color.lerp(muted, betaInk, 0.18)!;
  }

  /// Тушь бета-стиля — текст, линейки, кнопки.
  static const Color betaInk = Color(0xFF1D1915);

  /// Заливка знака бета-стиля (без прозрачности — её задаёт сам знак).
  static const Color betaFill = Color(0xFFD6B28E);

  /// Обводка знака бета-стиля.
  static const Color betaStroke = Color(0xFFE8CDAA);

  static AppColorsExt forVariant(AppThemeVariant variant) => switch (variant) {
        AppThemeVariant.dark => dark,
        AppThemeVariant.light => light,
        AppThemeVariant.oled => oled,
      };
}
