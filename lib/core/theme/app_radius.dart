import 'package:flutter/widgets.dart';

/// Пиксель-арт язык TexFi: почти прямые углы — квадратные карточки и кнопки,
/// минимально скруглённые (8-12px), как PixelCard/PixelButton в TexFi f0kus.
abstract final class AppRadius {
  static const double small = 6;
  static const double medium = 8;
  static const double large = 10;

  static const BorderRadius smallAll = BorderRadius.all(Radius.circular(small));
  static const BorderRadius mediumAll = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius largeAll = BorderRadius.all(Radius.circular(large));
}

// Шкала отступов жила здесь же и почти не использовалась — из-за этого
// расстояния по экранам подбирались вручную. Переехала в app_spacing.dart.
