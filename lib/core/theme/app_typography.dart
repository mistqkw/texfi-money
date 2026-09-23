import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_font.dart';
import 'app_colors_ext.dart';

/// Семейства, вшитые в сборку (`pubspec.yaml` → `flutter: fonts:`).
///
/// Раньше вся типографика шла через `google_fonts`, то есть скачивалась по
/// сети при первом запуске. Для приложения, которое само себя называет
/// офлайновым, это худший из возможных вариантов: на свежей установке без
/// интернета гарнитуры не приезжали, и приложение рисовало всё системным
/// Roboto — включая пиксельные заголовки. Стиль, который виден только при
/// наличии сети, стилем не является.
///
/// Обе вшитые гарнитуры покрывают кириллицу полностью (проверено по cmap:
/// А-я, 64 глифа), поэтому русские заголовки — настоящий пиксель, а не
/// системная подстановка посимвольно.
const String kPixelFamily = 'PressStart2P';
const String kBodyFamily = 'Inter';

/// Строит [TextTheme] под выбранный шрифт и палитру. Слоты сопоставлены
/// с именованными стилями приложения (см. `AppTextStyles`):
/// balance→displayLarge, amountLarge→displayMedium, amountMedium→displaySmall,
/// headline→headlineMedium, pixelAccent→titleLarge, title→titleMedium,
/// body→bodyMedium, caption→bodySmall, label→labelMedium, mono→labelSmall.
///
/// Пиксельный шрифт — заголовки экранов и секций, крупные акцентные числа
/// и короткие акцентные метки. Остальные суммы (история, счета, цели,
/// бюджеты) — обычной гарнитурой: bitmap на 13-16px читается медленнее, а
/// колонку сумм именно читают.
TextTheme buildAppTextTheme({required AppFont font, required AppColorsExt colors}) {
  TextStyle style({
    required double size,
    required FontWeight weight,
    required Color color,
    double? letterSpacing,
    double height = 1.2,
    List<FontFeature>? features,
  }) {
    final base = TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      fontFeatures: features ?? const [FontFeature.tabularFigures()],
      height: height,
    );
    // Inter вшит; остальные варианты остаются через google_fonts — это
    // необязательный выбор пользователя, и если сеть недоступна, он честно
    // откатывается к системной гарнитуре, не ломая приложение.
    return switch (font) {
      AppFont.inter => base.copyWith(fontFamily: kBodyFamily),
      AppFont.roboto => GoogleFonts.roboto(textStyle: base),
      AppFont.manrope => GoogleFonts.manrope(textStyle: base),
      AppFont.system => base,
    };
  }

  TextStyle pixel({
    required double size,
    required Color color,
    double letterSpacing = 0,
    double height = 1.4,
  }) {
    return TextStyle(
      fontFamily: kPixelFamily,
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color,
      letterSpacing: letterSpacing,
      fontFeatures: const [FontFeature.tabularFigures()],
      height: height,
    );
  }

  return TextTheme(
    displayLarge: pixel(size: 28, color: colors.textPrimary, height: 1.25),
    displayMedium: style(size: 26, weight: FontWeight.w600, color: colors.textPrimary, letterSpacing: -0.5),
    displaySmall: style(size: 17, weight: FontWeight.w600, color: colors.textPrimary),
    headlineMedium: pixel(size: 13, color: colors.textPrimary, letterSpacing: 0.5),
    titleLarge: pixel(size: 10, color: colors.textPrimary, height: 1.2),
    titleMedium: style(size: 16, weight: FontWeight.w500, color: colors.textPrimary),
    bodyMedium: style(size: 14, weight: FontWeight.w400, color: colors.textSecondary, height: 1.35),
    bodySmall: style(
      size: 12,
      weight: FontWeight.w400,
      color: colors.textTertiary,
      letterSpacing: 0.2,
      height: 1.3,
    ),
    labelMedium: style(
      size: 13,
      weight: FontWeight.w500,
      color: colors.textSecondary,
      letterSpacing: 0.1,
    ),
    // Мелкая служебная метка над значением: капслок и разрядка вместо
    // моноширинного JetBrains Mono. Моно здесь был последним следом
    // терминального оформления — он тянул за собой третью гарнитуру ради
    // подписей в два слова.
    labelSmall: style(
      size: 10,
      weight: FontWeight.w600,
      color: colors.textTertiary,
      letterSpacing: 1.2,
      height: 1.2,
    ),
  );
}
