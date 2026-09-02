import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_font.dart';
import 'app_colors_ext.dart';

/// Строит [TextTheme] под выбранный шрифт и палитру. Слоты сопоставлены
/// с именованными стилями приложения (см. `AppTextStyles`):
/// balance→displayLarge, amountLarge→displayMedium, amountMedium→displaySmall,
/// headline→headlineMedium, pixelAccent→titleLarge, title→titleMedium,
/// body→bodyMedium, caption→bodySmall, label→labelMedium, mono→labelSmall.
///
/// Пиксельный шрифт (Press Start 2P) — только на заголовках экранов/секций
/// (headlineMedium) и на самом крупном акцентном числе — балансе
/// (displayLarge) и компактных акцентных числах вроде процентов на
/// донат-чарте (titleLarge/pixelAccent). Остальные суммы (amountLarge/
/// amountMedium — история, счета, цели, бюджеты) — на обычном шрифте
/// пользователя, чтобы оставаться читаемыми в списках; их табличное
/// выравнивание цифр обеспечивается фичей ниже, а не сменой шрифта.
TextTheme buildAppTextTheme({required AppFont font, required AppColorsExt colors}) {
  TextStyle style({
    required double size,
    required FontWeight weight,
    required Color color,
    double? letterSpacing,
    List<FontFeature>? features,
  }) {
    final resolvedFeatures = features ?? const [FontFeature.tabularFigures()];
    final base = TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      fontFeatures: resolvedFeatures,
      height: 1.15,
    );
    return switch (font) {
      AppFont.inter => GoogleFonts.inter(textStyle: base),
      AppFont.roboto => GoogleFonts.roboto(textStyle: base),
      AppFont.manrope => GoogleFonts.manrope(textStyle: base),
      AppFont.system => base,
    };
  }

  // Пиксельный bitmap-шрифт (Press Start 2P) — визуальный язык, общий для
  // всей линейки TexFi (взят из TexFi f0kus). Используется только там, где
  // текст короткий и в основном латиница/цифры: крупные суммы и заголовки
  // экранов/секций. Основной текст остаётся на выбранном пользователем
  // шрифте — Press Start 2P не покрывает кириллицу, и Flutter аккуратно
  // подставляет системный шрифт посимвольно там, где глифов не хватает,
  // так что переведённые заголовки не превращаются в тофу-квадраты.
  TextStyle pixelStyle({
    required double size,
    required Color color,
    double? letterSpacing,
    double height = 1.4,
  }) {
    return GoogleFonts.pressStart2p(
      textStyle: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: color,
        letterSpacing: letterSpacing,
        fontFeatures: const [FontFeature.tabularFigures()],
        height: height,
      ),
    );
  }

  return TextTheme(
    displayLarge: pixelStyle(size: 30, color: colors.textPrimary, letterSpacing: 0),
    displayMedium: style(size: 26, weight: FontWeight.w700, color: colors.textPrimary, letterSpacing: -0.5),
    displaySmall: style(size: 17, weight: FontWeight.w600, color: colors.textPrimary),
    headlineMedium: pixelStyle(size: 14, color: colors.textPrimary, letterSpacing: 0.5),
    // Компактные акцентные пиксельные числа вне основной шкалы сумм —
    // проценты на донат-чарте и подобные короткие акцентные бейджи.
    titleLarge: pixelStyle(size: 11, color: colors.textPrimary, letterSpacing: 0, height: 1.2),
    titleMedium: style(size: 16, weight: FontWeight.w500, color: colors.textPrimary),
    bodyMedium: style(size: 14, weight: FontWeight.w400, color: colors.textSecondary),
    bodySmall: style(
      size: 12,
      weight: FontWeight.w400,
      color: colors.textTertiary,
      letterSpacing: 0.2,
    ),
    labelMedium: style(
      size: 13,
      weight: FontWeight.w500,
      color: colors.textSecondary,
      letterSpacing: 0.1,
    ),
    // Терминальные метки/метаданные — всегда моноширинный JetBrains Mono,
    // независимо от выбранного пользователем основного шрифта.
    labelSmall: GoogleFonts.jetBrainsMono(
      textStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        height: 1.2,
        color: colors.textSecondary,
      ),
    ),
  );
}
