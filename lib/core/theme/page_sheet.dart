import 'package:flutter/material.dart';

import 'app_colors_ext.dart';

/// Лист страницы: заливка фона и сетка редких точек — миллиметровка.
///
/// Сетка раньше жила одним слоем под всем приложением — и её не было
/// видно вовсе: каждый экран закрывал её непрозрачной заливкой
/// `Scaffold`. Теперь экраны прозрачные, а лист подкладывается под каждую
/// страницу отдельно — в переходе между экранами (см.
/// `PixelDissolveTransition`). Отдельный лист нужен и затем, чтобы новая
/// страница при переходе честно закрывала старую, а не просвечивала.
class PageSheet extends StatelessWidget {
  const PageSheet({super.key, required this.child});

  final Widget child;

  /// Рисовать ли сетку. Выключается из меню разработчика — сравнивать
  /// скриншоты без фактуры.
  static bool texture = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.background),
      child: CustomPaint(
        painter: texture ? _DotGridPainter(colors.noise) : null,
        child: child,
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  const _DotGridPainter(this.color);

  final Color color;

  /// Шаг сетки и размер точки.
  ///
  /// Случайный крап, который был здесь раньше, читался как пыль на
  /// экране — дёшево для приложения про деньги. Ровная сетка — бумага
  /// для расчётов: та же фактура, но собранная, а не рассыпанная.
  static const double _step = 16;
  static const double _dot = 2;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    for (var y = _step / 2; y < size.height; y += _step) {
      for (var x = _step / 2; x < size.width; x += _step) {
        path.addRect(Rect.fromLTWH(x, y, _dot, _dot));
      }
    }
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_DotGridPainter oldDelegate) => oldDelegate.color != color;
}
