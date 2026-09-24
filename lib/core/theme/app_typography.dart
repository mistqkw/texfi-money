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
const String kPixelFamily = 'PressStart2P';
const String kBodyFamily = 'Inter';

/// Антиква бета-стиля: Source Serif 4 SemiBold. В бета-стиле она занимает
/// все слоты, где в основном стиле стоит пиксель.
const String kSerifFamily = 'SourceSerif4';

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
///
/// [beta] — бета-стиль «бумага и чернила», см. [_buildPaperTextTheme].
TextTheme buildAppTextTheme({
  required AppFont font,
  required AppColorsExt colors,
  bool beta = false,
  bool serifBody = true,
}) {
  if (beta) return _buildPaperTextTheme(colors, serifBody: serifBody);
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

/// Типографика бета-стиля: всё набрано одной антиквой, как страница.
///
/// Иерархию держат кегль и начертание, а не цвет плашек и не капс с
/// разрядкой. Мелкие служебные подписи — настоящие капители шрифта
/// (`c2sc`/`smcp`), а не прописные, растянутые трекингом: капители
/// нарисованы под свой размер и не кричат. В тексте — старостильные
/// цифры, в суммах — выровненные табличные, чтобы колонка читалась.
///
/// [serifBody] выключен — основной текст (подписи, абзацы, строки
/// списков) набран Inter, антиква остаётся в заголовках и суммах.
TextTheme _buildPaperTextTheme(AppColorsExt colors, {bool serifBody = true}) {
  const amounts = [
    FontFeature.liningFigures(),
    FontFeature.tabularFigures(),
  ];
  const prose = [FontFeature.oldstyleFigures()];
  const smallCaps = [
    FontFeature('c2sc'),
    FontFeature('smcp'),
    FontFeature.oldstyleFigures(),
  ];

  TextStyle serif({
    required double size,
    FontWeight weight = FontWeight.w400,
    required Color color,
    double height = 1.3,
    double letterSpacing = 0,
    List<FontFeature> features = prose,
    bool body = false,
  }) {
    final sans = body && !serifBody;
    return TextStyle(
      fontFamily: sans ? kBodyFamily : kSerifFamily,
      // У Inter очко крупнее, чем у антиквы того же кегля: без поправки
      // основной текст перерастал бы заголовки.
      fontSize: sans ? size * 0.92 : size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      fontFeatures: features,
    );
  }

  return TextTheme(
    // Баланс — главное число страницы, набранное как заголовок полосы.
    displayLarge: serif(
      size: 52,
      weight: FontWeight.w600,
      color: colors.textPrimary,
      height: 1.0,
      letterSpacing: -1.2,
      features: amounts,
    ),
    displayMedium: serif(
      size: 30,
      weight: FontWeight.w600,
      color: colors.textPrimary,
      height: 1.1,
      letterSpacing: -0.5,
      features: amounts,
    ),
    displaySmall: serif(
      size: 18,
      weight: FontWeight.w600,
      color: colors.textPrimary,
      features: amounts,
    ),
    // В заголовках — обычные цифры: старостильный ноль похож на «о», и
    // «m0ney» в шапке читался как «money».
    headlineMedium: serif(
      size: 24,
      weight: FontWeight.w600,
      color: colors.textPrimary,
      height: 1.15,
      letterSpacing: -0.3,
      features: const [FontFeature.liningFigures()],
    ),
    titleLarge: serif(
      size: 15,
      weight: FontWeight.w600,
      color: colors.textPrimary,
      height: 1.2,
      features: amounts,
    ),
    titleMedium: serif(
      size: 17,
      color: colors.textPrimary,
      height: 1.25,
      body: true,
    ),
    bodyMedium: serif(
      size: 15,
      color: colors.textSecondary,
      height: 1.45,
      body: true,
    ),
    bodySmall: serif(
      size: 13,
      color: colors.textTertiary,
      height: 1.35,
      body: true,
    ),
    labelMedium: serif(size: 14, color: colors.textSecondary, body: true),
    labelSmall: serif(
      size: 13,
      weight: FontWeight.w600,
      color: colors.textTertiary,
      height: 1.2,
      letterSpacing: 0.4,
      features: smallCaps,
    ),
  );
}
