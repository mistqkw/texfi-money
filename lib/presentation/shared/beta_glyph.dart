import 'dart:ui' show PointMode;

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

/// Фон бета-стиля: некрашеная бумага с зерном.
///
/// Зерно — редкие точки в пиксель тушью с непрозрачностью в несколько
/// процентов. Без него ровная заливка читается как экран, а не как лист;
/// с водяным знаком, который здесь был раньше, — как заставка.
class BetaBackground extends StatelessWidget {
  const BetaBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.background),
      child: Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(painter: _PaperGrainPainter(colors.noise)),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _PaperGrainPainter extends CustomPainter {
  const _PaperGrainPainter(this.color);

  final Color color;

  static const double _cell = 3;

  /// Тот же целочисленный хеш, что у пиксельного крапа: зерно обязано
  /// стоять на месте между кадрами, иначе бумага «кипит».
  double _noise(int x, int y) {
    var h = x * 73856093 ^ y * 19349663;
    h = (h ^ (h >> 13)) * 1274126177;
    h = h ^ (h >> 16);
    return (h & 0xFFFF) / 0xFFFF;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final points = <Offset>[];
    final cols = (size.width / _cell).ceil();
    final rows = (size.height / _cell).ceil();
    for (var y = 0; y < rows; y++) {
      for (var x = 0; x < cols; x++) {
        final n = _noise(x, y);
        if (n > 0.3) continue;
        // Сдвиг внутри ячейки — чтобы зерно не складывалось в сетку.
        points.add(Offset(x * _cell + n * 7 % _cell, y * _cell + n * 11 % _cell));
      }
    }
    canvas.drawPoints(
      PointMode.points,
      points,
      Paint()
        ..color = color
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_PaperGrainPainter oldDelegate) =>
      oldDelegate.color != color;
}
