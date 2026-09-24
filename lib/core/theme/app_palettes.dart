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

  /// Бета-стиль. Палитра снята с аватарки автора, на которой и стоит
  /// эталонный «$»: тёмно-синий — волосы (`#172636`), сланцевый серый —
  /// фон (`#495154`), бежевый — руки (`#C0A589`, он же в заливке знака
  /// `#D6B28E`), светлый — рубашка. Рисунок плоский, в несколько тонов без
  /// градиентов, и стиль держит то же правило: сплошные поля цвета,
  /// линейки, никаких теней.
  ///
  /// Светлый вариант — рубашка вместо листа и тёмно-синие чернила вместо
  /// чёрной туши: текст того же цвета, что волосы на рисунке.
  static const AppColorsExt beta = AppColorsExt(
    background: Color(0xFFE9E3D8),
    surface: Color(0xFFEFEAE1),
    surfaceVariant: Color(0xFFDCD3C5),
    divider: Color(0xFFCBC1B1),
    border: Color(0xFFA5907A),
    shadow: Color(0x00000000),
    accent: Color(0xFF7D5F43),
    accentShadow: betaFill,
    onAccent: Color(0xFFEFEAE1),
    textPrimary: betaInk,
    textSecondary: Color(0xFF495154),
    textTertiary: Color(0xFF7C8384),
    income: Color(0xFF2E6B4E),
    expense: Color(0xFFA5412E),
    warning: Color(0xFF946A1E),
    noise: Color(0x0D172636),
  );

  /// Чернила светлого варианта — тёмно-синий волос с рисунка.
  static const Color betaInk = Color(0xFF172636);

  /// Тёмный вариант — сама аватарка: тёмно-синее поле, сланцевые линии,
  /// текст цвета рубашки, акцент — бежевый рук. На этом фоне эталонный
  /// «$» выглядит ровно так, как на рисунке.
  static const AppColorsExt betaNight = AppColorsExt(
    background: Color(0xFF172636),
    surface: Color(0xFF1C2C3D),
    surfaceVariant: Color(0xFF26374A),
    divider: Color(0xFF34454F),
    border: Color(0xFF495154),
    shadow: Color(0x00000000),
    accent: betaFill,
    accentShadow: Color(0xFFA5907A),
    onAccent: Color(0xFF172636),
    textPrimary: Color(0xFFEDE4D6),
    textSecondary: Color(0xFFC0A589),
    textTertiary: Color(0xFF8A9295),
    income: Color(0xFF9CC4A2),
    expense: Color(0xFFE3957F),
    warning: Color(0xFFDDB268),
    noise: Color(0x0FEDE4D6),
  );

  /// OLED: самая тёмная тень волос на рисунке, доведённая до чёрного, —
  /// синий остаётся в поверхностях и линиях.
  static final AppColorsExt betaBlack = betaNight.copyWith(
    background: const Color(0xFF000000),
    surface: const Color(0xFF0B1118),
    surfaceVariant: const Color(0xFF121A23),
    divider: const Color(0xFF26323D),
    noise: const Color(0x0AEDE4D6),
  );

  /// Палитра беты под выбранную тему: бета меняет материал, но не
  /// спорит с тем, светлым или тёмным пользователь хочет видеть экран.
  static AppColorsExt betaFor(AppThemeVariant variant) => switch (variant) {
        AppThemeVariant.light => beta,
        AppThemeVariant.dark => betaNight,
        AppThemeVariant.oled => betaBlack,
      };

  // --- Бета «коллаж» — TexFi Style ------------------------------------
  //
  // Цвета сняты с картинки автора точными значениями: белый лист, синий
  // в трёх глубинах, приглушённый сине-серый прямоугольник, чёрный
  // текст. Главный синий — тот же `#4A7DFB`, что акцент m0ney и f0kus:
  // стиль продолжает семью TexFi.

  static const Color collageBlue = Color(0xFF4A7DFB);
  static const Color collageBlueMid = Color(0xFF436ED9);
  static const Color collageBlueDeep = Color(0xFF3A60BE);
  static const Color collageSlate = Color(0xFF5A72AB);

  /// Синие пятна по порядку: у каждого пятна своя глубина, как на
  /// картинке, где три пятна — три разных синих.
  static const List<Color> collageBlues = [
    collageBlue,
    collageBlueMid,
    collageBlueDeep,
  ];

  /// Коллаж на белом — как на картинке. Доход — синим, расход — чёрным:
  /// в стиле два цвета, и деньги говорят на нём же; направление суммы
  /// всё равно читается по знаку.
  static const AppColorsExt collage = AppColorsExt(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF0F2F8),
    divider: Color(0xFFE2E5EE),
    border: Color(0xFF000000),
    shadow: Color(0x00000000),
    accent: collageBlue,
    accentShadow: collageBlueDeep,
    onAccent: Color(0xFF000000),
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF383B44),
    textTertiary: Color(0xFF7A7F8C),
    income: collageBlueDeep,
    expense: Color(0xFF000000),
    warning: Color(0xFFD9861A),
    noise: Color(0x00000000),
  );

  /// Коллаж на тёмном: тот же набор, вывернутый — лист почти чёрный с
  /// синим отливом, текст белый, синие те же.
  static const AppColorsExt collageNight = AppColorsExt(
    background: Color(0xFF0B0D14),
    surface: Color(0xFF0B0D14),
    surfaceVariant: Color(0xFF171B28),
    divider: Color(0xFF252A3A),
    border: Color(0xFFFFFFFF),
    shadow: Color(0x00000000),
    accent: collageBlue,
    accentShadow: collageBlueDeep,
    onAccent: Color(0xFF000000),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFC4C8D4),
    textTertiary: Color(0xFF7C8294),
    income: Color(0xFF7FA2FF),
    expense: Color(0xFFFFFFFF),
    warning: Color(0xFFF0A33A),
    noise: Color(0x00000000),
  );

  static AppColorsExt collageFor(AppThemeVariant variant) => switch (variant) {
        AppThemeVariant.light => collage,
        AppThemeVariant.dark => collageNight,
        AppThemeVariant.oled => collageNight.copyWith(
            background: const Color(0xFF000000),
            surface: const Color(0xFF000000),
          ),
      };

  /// Цвет категории, пересчитанный под лист беты: наполовину приглушённый
  /// и смешанный с чернилами (на тёмном листе — со светлыми). Палитра
  /// категорий подобрана под экран — на
  /// тёмном фоне неоновый зелёный и электрический синий хороши, на
  /// бумаге они выглядят наклейками. Оттенок остаётся узнаваемым, так
  /// что категорию по-прежнему находят по цвету.
  static Color inkify(Color color, {bool dark = false}) {
    final hsl = HSLColor.fromColor(color);
    if (dark) {
      final muted = hsl.withSaturation(hsl.saturation * 0.55).toColor();
      return Color.lerp(muted, betaNight.textPrimary, 0.15)!;
    }
    final muted = hsl
        .withSaturation(hsl.saturation * 0.62)
        .withLightness((hsl.lightness * 0.72).clamp(0.0, 1.0))
        .toColor();
    return Color.lerp(muted, betaInk, 0.18)!;
  }

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
