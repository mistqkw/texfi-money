import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_spacing.dart';

/// Сетка 8dp поверх интерфейса и поля экрана — чтобы проверить на глаз,
/// что отступы берутся из шкалы, а не подбираются по месту.
///
/// Линия каждые 8dp — тонкая, каждые 32dp — плотнее; поля экрана
/// ([AppSpacing.page]) — акцентом. Слой не ловит касания.
class LayoutGridOverlay extends StatelessWidget {
  const LayoutGridOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        IgnorePointer(
          child: CustomPaint(
            painter: _GridPainter(context.colors.accent),
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter(this.color);

  final Color color;

  static const double _step = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final minor = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    final major = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..strokeWidth = 1;
    var i = 0;
    for (var x = 0.0; x <= size.width; x += _step, i++) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), i % 4 == 0 ? major : minor);
    }
    i = 0;
    for (var y = 0.0; y <= size.height; y += _step, i++) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), i % 4 == 0 ? major : minor);
    }
    final margin = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 1;
    const page = AppSpacing.page;
    canvas.drawLine(const Offset(page, 0), Offset(page, size.height), margin);
    canvas.drawLine(
      Offset(size.width - page, 0),
      Offset(size.width - page, size.height),
      margin,
    );
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => oldDelegate.color != color;
}

/// Кружки под пальцами — для записи экрана: на видео иначе не понять,
/// куда нажали. Касания проходят насквозь, слой их только видит.
class TouchIndicatorOverlay extends StatefulWidget {
  const TouchIndicatorOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<TouchIndicatorOverlay> createState() => _TouchIndicatorOverlayState();
}

class _TouchIndicatorOverlayState extends State<TouchIndicatorOverlay> {
  final Map<int, Offset> _touches = {};

  void _update(PointerEvent event) =>
      setState(() => _touches[event.pointer] = event.localPosition);

  void _remove(PointerEvent event) =>
      setState(() => _touches.remove(event.pointer));

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _update,
      onPointerMove: _update,
      onPointerUp: _remove,
      onPointerCancel: _remove,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          IgnorePointer(
            child: CustomPaint(
              painter: _TouchPainter(
                touches: _touches.values.toList(),
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TouchPainter extends CustomPainter {
  const _TouchPainter({required this.touches, required this.color});

  final List<Offset> touches;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = color.withValues(alpha: 0.18);
    final ring = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final touch in touches) {
      canvas.drawCircle(touch, 22, fill);
      canvas.drawCircle(touch, 22, ring);
    }
  }

  @override
  bool shouldRepaint(_TouchPainter oldDelegate) => true;
}
