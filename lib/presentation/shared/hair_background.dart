import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';

/// Фон экрана: цвет темы и едва заметная сетка точек, как на сайте.
/// [density] — прозрачность сетки относительно базовой; 0 отключает её.
class HairBackground extends StatelessWidget {
  const HairBackground({super.key, required this.child, this.density = 1});

  final Widget child;
  final double density;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.background),
      child: density <= 0
          ? child
          : CustomPaint(
              painter: _DotGridPainter(
                color: colors.noise.withValues(alpha: colors.noise.a * density),
              ),
              child: child,
            ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  const _DotGridPainter({required this.color});

  final Color color;

  static const double _step = 26;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var y = _step / 2; y < size.height; y += _step) {
      for (var x = _step / 2; x < size.width; x += _step) {
        canvas.drawCircle(Offset(x, y), 0.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter oldDelegate) => oldDelegate.color != color;
}
