import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_font.dart';
import 'app_colors_ext.dart';

/// Строит [TextTheme] под выбранный шрифт и палитру. Слоты сопоставлены
/// с именованными стилями приложения (см. `AppTextStyles`):
/// balance→displayLarge, amountLarge→displayMedium, amountMedium→displaySmall,
/// headline→headlineMedium, title→titleMedium, body→bodyMedium,
/// caption→bodySmall, label→labelMedium.
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

  return TextTheme(
    displayLarge: style(size: 44, weight: FontWeight.w700, color: colors.textPrimary, letterSpacing: -1),
    displayMedium: style(size: 28, weight: FontWeight.w700, color: colors.textPrimary, letterSpacing: -0.5),
    displaySmall: style(size: 17, weight: FontWeight.w600, color: colors.textPrimary),
    headlineMedium: style(size: 20, weight: FontWeight.w600, color: colors.textPrimary, features: const []),
    titleMedium: style(size: 16, weight: FontWeight.w500, color: colors.textPrimary, features: const []),
    bodyMedium: style(size: 14, weight: FontWeight.w400, color: colors.textSecondary, features: const []),
    bodySmall: style(
      size: 12,
      weight: FontWeight.w400,
      color: colors.textTertiary,
      letterSpacing: 0.2,
      features: const [],
    ),
    labelMedium: style(
      size: 13,
      weight: FontWeight.w500,
      color: colors.textSecondary,
      letterSpacing: 0.1,
      features: const [],
    ),
  );
}
