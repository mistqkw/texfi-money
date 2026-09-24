import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_palettes.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/haptics.dart';
import '../shared/beta_glyph.dart';
import '../shared/collage_blob.dart';
import '../shared/collage_text.dart';

/// Смена стиля целиком — через занавес, а не через подмену темы.
///
/// Обычная смена темы плавно перетекает цвета за 220 мс. Для бета-стиля
/// так нельзя: меняется гарнитура, а шрифты не перетекают — на середине
/// перехода текст скачком перепрыгивает из пикселя в антикву, и экран
/// выглядит сломанным. Поэтому интерфейс закрывается волной нового фона
/// от точки нажатия, под ней тема меняется целиком, а на занавесе тем
/// временем прорисовывается знак: сначала контур, потом заливка. Потом
/// занавес растворяется — и под ним уже другое приложение.
///
/// [onSwitch] вызывается, когда экран закрыт полностью. [targetBackground]
/// — фон стиля, в который переходим: волна должна быть того же цвета,
/// что и то, что под ней откроется, иначе в конце мелькнёт третий цвет.
Future<void> playBetaStyleReveal(
  BuildContext context, {
  required Offset origin,
  required bool enabling,
  required Color targetBackground,
  required VoidCallback onSwitch,
  String glyph = r'$',
  bool collage = false,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  final done = Completer<void>();
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _BetaReveal(
      origin: origin,
      enabling: enabling,
      background: targetBackground,
      onSwitch: onSwitch,
      glyph: glyph,
      collage: collage,
      onDone: () {
        entry.remove();
        if (!done.isCompleted) done.complete();
      },
    ),
  );
  overlay.insert(entry);
  return done.future;
}

class _BetaReveal extends StatefulWidget {
  const _BetaReveal({
    required this.origin,
    required this.enabling,
    required this.background,
    required this.onSwitch,
    required this.onDone,
    required this.glyph,
    this.collage = false,
  });

  /// Знак на занавесе.
  final String glyph;

  /// Занавес коллажа: волна — синее вырезанное пятно, в центре вместо
  /// знака собирается «TexFi StyLE» из разных шрифтов.
  final bool collage;

  final Offset origin;
  final bool enabling;
  final Color background;
  final VoidCallback onSwitch;
  final VoidCallback onDone;

  @override
  State<_BetaReveal> createState() => _BetaRevealState();
}

class _BetaRevealState extends State<_BetaReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _switched = false;

  /// Момент, когда волна закрыла экран, — в нём и меняется тема.
  static const double _switchAt = 0.42;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            // Включение — событие: у него есть время показать знак. Выключение
            // — возврат к привычному, его не заставляют ждать.
            duration: Duration(milliseconds: widget.enabling ? 1900 : 1200),
          )
          ..addListener(_tick)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) widget.onDone();
          });
    Haptics.select();
    _controller.forward();
  }

  void _tick() {
    if (!_switched && _controller.value >= _switchAt) {
      _switched = true;
      widget.onSwitch();
      if (widget.enabling) Haptics.success();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Доля отрезка [begin, end] шкалы, пройденная к моменту [t], с кривой.
  static double _seg(
    double t,
    double begin,
    double end, [
    Curve curve = Curves.linear,
  ]) {
    final v = ((t - begin) / (end - begin)).clamp(0.0, 1.0);
    return curve.transform(v);
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          final size = MediaQuery.sizeOf(context);
          final wave = _seg(t, 0, _switchAt, Curves.easeInOutCubic);
          final fadeOut = _seg(
            t,
            widget.enabling ? 0.74 : 0.62,
            1,
            Curves.easeInCubic,
          );

          // Знак проводится контуром, наливается и чуть подрастает, пока
          // занавес растворяется. При выключении знака нет: возвращается
          // привычное, представлять его незачем — хватает одной волны.
          final stroke = _seg(t, 0.18, 0.52, Curves.easeOutCubic);
          final fill = _seg(t, 0.40, 0.66, Curves.easeOut);
          final glyphScale =
              0.86 +
              0.14 * _seg(t, 0.18, 0.66, Curves.easeOutBack) +
              0.06 * fadeOut;
          final caption = widget.enabling ? _seg(t, 0.5, 0.68) : 0.0;
          final glyphSize = size.shortestSide * 0.62;

          return Opacity(
            opacity: 1 - fadeOut,
            child: CustomPaint(
              size: size,
              painter: _WavePainter(
                origin: widget.origin,
                progress: wave,
                color: widget.background,
                edge: AppPalettes.betaStroke,
                blob: widget.collage,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.enabling && widget.collage && stroke > 0.3)
                      CollageText(
                        'TexFi StyLE',
                        shuffle: true,
                        style: const TextStyle(
                          fontSize: 48,
                          color: Color(0xFF000000),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    if (widget.enabling && !widget.collage)
                      Transform.scale(
                        scale: glyphScale,
                        child: Opacity(
                          opacity: stroke.clamp(0.0, 1.0),
                          child: BetaGlyph(
                            glyph: widget.glyph,
                            size: glyphSize,
                            strokeProgress: stroke,
                            fillOpacity: BetaGlyph.fillAlpha * fill,
                          ),
                        ),
                      ),
                    if (!widget.collage)
                      Opacity(
                        opacity: caption,
                        child: Transform.translate(
                          offset: Offset(0, 8 * (1 - caption)),
                          child: Text(
                            'm0ney · beta',
                            textScaler: TextScaler.noScaling,
                            style: TextStyle(
                              fontFamily: kSerifFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              letterSpacing: 1.5,
                              color: AppPalettes.betaStroke.withValues(
                                alpha: 0.9,
                              ),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Волна нового фона от точки нажатия со светлой кромкой.
class _WavePainter extends CustomPainter {
  const _WavePainter({
    required this.origin,
    required this.progress,
    required this.color,
    required this.edge,
    this.blob = false,
  });

  final Offset origin;
  final double progress;
  final Color color;
  final Color edge;

  /// Волна — вырезанное пятно, а не круг (занавес коллажа).
  final bool blob;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    // Радиус до самого дальнего угла: волна обязана закрыть экран
    // целиком, откуда бы её ни запустили.
    final corners = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ];
    final maxRadius = corners
        .map((c) => (c - origin).distance)
        .reduce(math.max);
    final radius = maxRadius * progress;

    if (blob) {
      // Пятно неровное, поэтому берём его с запасом: самая короткая
      // его «сторона» тоже обязана дойти до дальнего угла.
      canvas.drawPath(
        CollageBlob.path(
          Rect.fromCircle(center: origin, radius: radius * 1.6),
          41,
        ),
        Paint()..color = color,
      );
      return;
    }
    canvas.drawCircle(origin, radius, Paint()..color = color);

    // Кромка гаснет по мере того, как волна добегает до краёв: к моменту
    // смены темы экран — ровный фон без следов.
    final edgeAlpha = 0.7 * (1 - progress);
    if (edgeAlpha > 0.01) {
      canvas.drawCircle(
        origin,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = edge.withValues(alpha: edgeAlpha),
      );
    }
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) =>
      oldDelegate.blob != blob ||
      oldDelegate.progress != progress ||
      oldDelegate.origin != origin ||
      oldDelegate.color != color;
}
