import 'package:flutter/animation.dart';

/// Единые константы анимаций: переходы экранов, счётчики, spring-эффекты.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 450);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve spring = Curves.easeOutBack;
  static const Curve enter = Curves.easeOut;
  static const Curve exit = Curves.easeIn;
}
