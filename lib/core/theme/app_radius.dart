import 'package:flutter/widgets.dart';

/// Плоский дизайн: сдержанные радиусы, без переборов.
abstract final class AppRadius {
  static const double small = 8;
  static const double medium = 10;
  static const double large = 12;

  static const BorderRadius smallAll = BorderRadius.all(Radius.circular(small));
  static const BorderRadius mediumAll = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius largeAll = BorderRadius.all(Radius.circular(large));
}

// Шкала отступов жила здесь же и почти не использовалась — из-за этого
// расстояния по экранам подбирались вручную. Переехала в app_spacing.dart.
