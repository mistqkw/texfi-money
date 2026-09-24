import 'dart:ui' show PointMode;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_palettes.dart';
import '../../core/theme/app_typography.dart';

/// Знак бета-стиля — «$» антиквой с полупрозрачной заливкой и светлой
/// обводкой, тот же, что на аватарке автора. Параметры сняты с эталона
/// 736×736, где знак набран кеглем 600: Source Serif 4 SemiBold, заливка
/// `#D6B28E` с альфой 70/255 (≈27%), обводка `#E8CDAA` с альфой 200/255
/// (≈78%) толщиной 6px. Бежевый заливки взят с рук на том же рисунке.
///
/// Толщина обводки задана долей кегля (6/600), а не пикселями: знак
/// рисуется и во весь экран фоном, и на анимации включения, и в строке
/// меню — при фиксированных 6px маленький знак заплыл бы обводкой, а
/// большой выглядел бы нарисованным волоском.
class BetaGlyph extends StatelessWidget {
  const BetaGlyph({
    super.key,
    this.glyph = r'$',
    required this.size,
    this.fillOpacity = fillAlpha,
    this.strokeOpacity = strokeAlpha,
    this.strokeProgress = 1,
    this.fillColor = AppPalettes.betaFill,
    this.strokeColor = AppPalettes.betaStroke,
  });

  static const double fillAlpha = 70 / 255;
  static const double strokeAlpha = 200 / 255;

  /// Толщина обводки к кеглю — 6px на 600px эталона.
  static const double strokeRatio = 6 / 600;

  final String glyph;

  /// Кегль.
  final double size;
  final double fillOpacity;
  final double strokeOpacity;

  /// 0..1 — насколько обводка «набрала» толщину. Анимация включения
  /// сначала проводит контур, потом наливает знак.
  final double strokeProgress;

  /// Цвета знака. По умолчанию — эталонные; на светлом листе их
  /// заменяют чернилами, иначе светлый знак на светлом фоне пропадает.
  final Color fillColor;
  final Color strokeColor;

  @override
  Widget build(BuildContext context) {
    // decoration: none — обязательно. Фон лежит над навигатором, где у
    // текста нет DefaultTextStyle, и Flutter подставляет отладочный
    // стиль с жёлтым двойным подчёркиванием — под знаком во весь экран
    // это была жёлтая полоса.
    final base = TextStyle(
      fontFamily: kSerifFamily,
      fontWeight: FontWeight.w600,
      fontSize: size,
      height: 1,
      decoration: TextDecoration.none,
    );
    final stroke = size * strokeRatio * strokeProgress.clamp(0.0, 1.0);

    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          glyph,
          textScaler: TextScaler.noScaling,
          style: base.copyWith(
            color: fillColor.withValues(alpha: fillOpacity),
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
                ..color = strokeColor.withValues(alpha: strokeOpacity),
            ),
          ),
      ],
    );
  }
}

/// Фон бета-стиля: лист с зерном и большой «$» посередине — та же
/// композиция, что на аватарке: знак кеглем 600/736 от ширины, по центру.
///
/// На тёмном листе знак эталонный, как на аватарке. На светлом эталонный
/// знак невидим — бежевый с полупрозрачностью на светлом фоне сливается
/// с бумагой, — поэтому там тот же рецепт (заливка плюс более плотная
/// обводка) набран тёмно-синими чернилами.
///
/// Знак дополнительно приглушён целиком: на аватарке он лежит поверх
/// картинки, а здесь — под текстом, который нужно читать.
class BetaBackground extends StatelessWidget {
  const BetaBackground({super.key, required this.child});

  final Widget child;

  /// Кегль знака к ширине экрана — как 600 к 736 на аватарке.
  static const double glyphToWidth = 600 / 736;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
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
          IgnorePointer(
            child: ExcludeSemantics(
              child: LayoutBuilder(
                builder: (context, constraints) => Center(
                  child: Opacity(
                    opacity: dark ? 0.45 : 1,
                    child: RepaintBoundary(
                      child: dark
                          ? BetaGlyph(size: constraints.maxWidth * glyphToWidth)
                          : BetaGlyph(
                              size: constraints.maxWidth * glyphToWidth,
                              fillColor: colors.textPrimary,
                              strokeColor: colors.textPrimary,
                              fillOpacity: 0.035,
                              strokeOpacity: 0.12,
                            ),
                    ),
                  ),
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
