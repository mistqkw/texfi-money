import 'package:flutter/widgets.dart';

/// Радиусы пиксельного языка TexFi — та же шкала, что в TexFi f0kus.
///
/// Раньше здесь было три значения (6/8/10) без разделения на карточки и
/// управление, и это давало едва заметный, но постоянный разъезд: кнопка
/// в m0ney скруглялась на 8, а та же кнопка в f0kus — на 4. По отдельности
/// незаметно, рядом на одном экране — видно, что приложения собраны
/// разными руками.
///
/// Разделение осмысленное: карточка — плоскость, ей позволено быть мягче;
/// управление — деталь, оно почти прямоугольное.
abstract final class AppRadius {
  // --- Карточки и плоскости: 8–12 ---
  static const double cardSmall = 8;
  static const double cardMedium = 10;
  static const double cardLarge = 12;

  static const BorderRadius cardSmallAll =
      BorderRadius.all(Radius.circular(cardSmall));
  static const BorderRadius cardMediumAll =
      BorderRadius.all(Radius.circular(cardMedium));
  static const BorderRadius cardLargeAll =
      BorderRadius.all(Radius.circular(cardLarge));

  // --- Управление: 0–4 ---
  static const double controlNone = 0;
  static const double controlTiny = 2;
  static const double controlSmall = 4;

  static const BorderRadius controlNoneAll = BorderRadius.zero;
  static const BorderRadius controlTinyAll =
      BorderRadius.all(Radius.circular(controlTiny));
  static const BorderRadius controlSmallAll =
      BorderRadius.all(Radius.circular(controlSmall));

  /// Толщина всех рамок в интерфейсе.
  static const double pixelBorder = 2;

  /// Смещение сплошной ретро-тени. Единственное место, где это число
  /// задано, — его читает [PixelShadowBox].
  static const double pixelShadowOffset = 3;
}

// Шкала отступов жила здесь же и почти не использовалась — из-за этого
// расстояния по экранам подбирались вручную. Переехала в app_spacing.dart.
