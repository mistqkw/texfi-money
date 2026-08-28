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

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}
