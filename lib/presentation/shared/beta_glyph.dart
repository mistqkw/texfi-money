import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_palettes.dart';
import '../../core/theme/app_typography.dart';

/// Знак бета-стиля — буква антиквой с полупрозрачной заливкой и светлой
/// обводкой. Параметры сняты с эталона 736×736, где буква набрана кеглем
/// 600: Source Serif 4 SemiBold, заливка `#D6B28E` ≈27%, обводка
/// `#E8CDAA` ≈78% толщиной 6px.
///
/// Толщина обводки задана долей кегля (6/600), а не пикселями: знак
/// рисуется и в полэкрана на анимации включения, и водяным знаком в углу,
/// и в строке меню — при фиксированных 6px маленькая буква заплыла бы
/// обводкой, а большая выглядела бы нарисованной волоском.
class BetaGlyph extends StatelessWidget {
  const BetaGlyph({
    super.key,
    this.glyph = 'm',
    required this.size,
    this.fillOpacity = fillAlpha,
    this.strokeOpacity = strokeAlpha,
    this.strokeProgress = 1,
  });

  static const double fillAlpha = 0.27;
  static const double strokeAlpha = 0.78;

  /// Толщина обводки к кеглю — 6px на 600px эталона.
  static const double strokeRatio = 6 / 600;

  final String glyph;

  /// Кегль.
  final double size;
  final double fillOpacity;
  final double strokeOpacity;

  /// 0..1 — насколько обводка «набрала» толщину. Анимация включения
  /// сначала проводит контур, потом наливает букву.
  final double strokeProgress;

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      fontFamily: kSerifFamily,
      fontWeight: FontWeight.w600,
      fontSize: size,
      height: 1,
    );
    final stroke = size * strokeRatio * strokeProgress.clamp(0.0, 1.0);

    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          glyph,
          textScaler: TextScaler.noScaling,
          style: base.copyWith(
            color: AppPalettes.betaFill.withValues(alpha: fillOpacity),
          ),
        ),
        if (stroke > 0)
          Text(
            glyph,
            textScaler: TextScaler.noScaling,
            style: base.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = stroke
                ..strokeJoin = StrokeJoin.round
                ..color = AppPalettes.betaStroke.withValues(alpha: strokeOpacity),
            ),
          ),
      ],
    );
  }
}

/// Фон бета-стиля: сплошная тёплая заливка и крупный знак, наполовину
/// уходящий за правый нижний край. Вместо пиксельного крапа — один
/// предмет, и он же напоминает, что включена бета.
///
/// Знак приглушён целиком ([Opacity] поверх его собственных 27/78%):
/// в полную силу он спорил бы со списком операций, который лежит сверху.
class BetaBackground extends StatelessWidget {
  const BetaBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Не scaffoldBackgroundColor: в бета-стиле он прозрачный как раз
    // ради этого фона.
    final background = context.colors.background;
    return DecoratedBox(
      decoration: BoxDecoration(color: background),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -90,
            bottom: -170,
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: Opacity(
                  opacity: 0.22,
                  child: RepaintBoundary(child: BetaGlyph(size: 520)),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
