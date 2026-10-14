import 'package:flutter/material.dart';

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
const String kDisplayFamily = 'Unbounded';
const String kMonoFamily = 'JetBrainsMono';
const String kBodyFamily = 'Inter';

/// Строит [TextTheme] под выбранный шрифт и палитру. Слоты сопоставлены
/// с именованными стилями приложения (см. `AppTextStyles`):
/// balance→displayLarge, amountLarge→displayMedium, amountMedium→displaySmall,
/// headline→headlineMedium, pixelAccent→titleLarge, title→titleMedium,
/// body→bodyMedium, caption→bodySmall, label→labelMedium, mono→labelSmall.
///
/// Зона пиксельного шрифта сужена до опознавательного знака: словесный
/// знак «m0ney» в шапке, заставка и редкие короткие латинские бейджи.
///
/// Раньше bitmap стоял на заголовках экранов и на балансе. Проблема не в
/// читаемости — кириллица в гарнитуре есть, — а в том, какой это сигнал:
/// самый крупный элемент финансового экрана, набранный шрифтом из аркады,
/// читается как счёт очков, а не как остаток на счету. Стиль экосистемы
/// держат рамка 2px, офсетная тень, квадратная геометрия и синий #4a7dfb;
/// они остаются нетронутыми. Гарнитура содержания — гротеск.
TextTheme buildAppTextTheme({
  required AppFont font,
  required AppColorsExt colors,
}) {
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
    return switch (font) {
      AppFont.inter => base.copyWith(fontFamily: kBodyFamily),
      AppFont.system => base,
    };
  }

  TextStyle display({
    required double size,
    required Color color,
    FontWeight weight = FontWeight.w600,
    double letterSpacing = -0.6,
    double height = 1.1,
  }) {
    return TextStyle(
      fontFamily: kDisplayFamily,
      fontFamilyFallback: const [kBodyFamily],
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      fontFeatures: const [FontFeature.tabularFigures()],
      height: height,
    );
  }

  TextStyle mono({
    required double size,
    required Color color,
    double letterSpacing = 1.1,
    double height = 1.3,
  }) {
    return TextStyle(
      fontFamily: kMonoFamily,
      fontFamilyFallback: const [kBodyFamily],
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  return TextTheme(
    displayLarge: display(
      size: 30,
      color: colors.textPrimary,
      letterSpacing: -1.2,
      height: 1.05,
    ),
    displayMedium: display(
      size: 22,
      color: colors.textPrimary,
      letterSpacing: -0.8,
    ),
    displaySmall: style(
      size: 17,
      weight: FontWeight.w600,
      color: colors.textPrimary,
    ),
    headlineMedium: display(
      size: 19,
      color: colors.textPrimary,
      letterSpacing: -0.6,
      height: 1.15,
    ),
    titleLarge: mono(size: 11, color: colors.textPrimary),
    titleSmall: display(
      size: 16,
      color: colors.textPrimary,
      weight: FontWeight.w800,
      letterSpacing: -0.8,
    ),
    titleMedium: style(
      size: 16,
      weight: FontWeight.w500,
      color: colors.textPrimary,
    ),
    bodyMedium: style(
      size: 14,
      weight: FontWeight.w400,
      color: colors.textSecondary,
      height: 1.35,
    ),
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
    // Подписи — JetBrains Mono, как на сайте: 10–11px, разрядка, капслок
    // задаётся местом использования.
    labelSmall: mono(
      size: 10.5,
      color: colors.textTertiary,
      letterSpacing: 1.1,
    ),
  );
}
