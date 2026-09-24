import 'package:flutter/material.dart';

/// Геометрия и «материал» интерфейса — то, что в бета-стиле меняется
/// вместе с палитрой и гарнитурой.
///
/// Пиксельный язык держится не только на цветах: рубленые радиусы,
/// рамка в 2px и сплошная тень со смещением — это его половина. Если
/// бета-стиль поменяет только цвета и шрифт, получится пиксельное
/// приложение в бежевом, а не другой стиль. Поэтому общие примитивы
/// (карточка, кнопка, тень, переключатель) читают геометрию отсюда, а не
/// напрямую из [AppRadius].
class AppStyleExt extends ThemeExtension<AppStyleExt> {
  const AppStyleExt({
    required this.beta,
    required this.cardRadius,
    required this.controlRadius,
    required this.borderWidth,
    required this.flat,
  });

  /// Пиксельный стиль — основной.
  static const AppStyleExt pixel = AppStyleExt(
    beta: false,
    cardRadius: BorderRadius.all(Radius.circular(10)),
    controlRadius: BorderRadius.all(Radius.circular(4)),
    borderWidth: 2,
    flat: false,
  );

  /// Бета-стиль «бумага и чернила»: у печатной страницы нет ни
  /// скруглённых плашек, ни теней — блоки отделяются линейками, а
  /// объём держит только типографика.
  static const AppStyleExt paper = AppStyleExt(
    beta: true,
    cardRadius: BorderRadius.zero,
    controlRadius: BorderRadius.all(Radius.circular(3)),
    borderWidth: 1,
    flat: true,
  );

  final bool beta;
  final BorderRadius cardRadius;
  final BorderRadius controlRadius;
  final double borderWidth;

  /// Плоский стиль: элементы не отбрасывают тени вовсе.
  final bool flat;

  @override
  AppStyleExt copyWith({
    bool? beta,
    BorderRadius? cardRadius,
    BorderRadius? controlRadius,
    double? borderWidth,
    bool? flat,
  }) {
    return AppStyleExt(
      beta: beta ?? this.beta,
      cardRadius: cardRadius ?? this.cardRadius,
      controlRadius: controlRadius ?? this.controlRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      flat: flat ?? this.flat,
    );
  }

  @override
  AppStyleExt lerp(ThemeExtension<AppStyleExt>? other, double t) {
    if (other is! AppStyleExt) return this;
    return AppStyleExt(
      beta: t < 0.5 ? beta : other.beta,
      cardRadius: BorderRadius.lerp(cardRadius, other.cardRadius, t)!,
      controlRadius: BorderRadius.lerp(controlRadius, other.controlRadius, t)!,
      borderWidth: borderWidth + (other.borderWidth - borderWidth) * t,
      flat: t < 0.5 ? flat : other.flat,
    );
  }
}

extension AppStyleContextX on BuildContext {
  /// Геометрия текущего стиля. Тема без расширения (виджет-тест с голым
  /// `ThemeData`) получает пиксельную — основной стиль приложения.
  AppStyleExt get style =>
      Theme.of(this).extension<AppStyleExt>() ?? AppStyleExt.pixel;
}
