import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'app_colors_ext.dart';
import 'app_motion.dart';
import 'page_sheet.dart';

/// Переход между экранами в духе ретро-игр: новый экран «проявляется»
/// пиксельными блоками (dissolve), поверх один раз пробегают сканлайны.
///
/// Тот же эффект, что в TexFi f0kus, и это главная причина его здесь
/// завести. Приложения экосистемы делят шрифт, палитру, иконки и
/// длительности анимаций — а переход между экранами был единственным
/// местом, где m0ney выглядел обычным материалом: подъём на шесть
/// процентов высоты и fade. Стилистика, которая держится на всём, кроме
/// самого заметного движения в интерфейсе, не держится.
///
/// Эффект намеренно сдержанный — он длится ~260 мс и не мешает навигации.
/// Реализован через маску из блоков фиксированного размера: каждый блок
/// исчезает на своём пороге, порог берётся из детерминированного хеша
/// координат, поэтому картинка не «шумит» между кадрами.
class PixelDissolvePageTransitionsBuilder extends PageTransitionsBuilder {
  const PixelDissolvePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return PixelDissolveTransition(animation: animation, child: child);
  }
}

/// Системный переход iOS (свайп от края — часть жеста, его не трогаем),
/// но страница — на своём листе: экраны прозрачные, и без листа при
/// свайпе сквозь уходящую страницу просвечивала бы предыдущая.
class SheetedCupertinoPageTransitionsBuilder extends PageTransitionsBuilder {
  const SheetedCupertinoPageTransitionsBuilder();

  static const _system = CupertinoPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T>? route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Маршрута может не быть (переход собирают вне Navigator) — тогда и
    // системного перехода нет, только лист.
    if (route == null) return PageSheet(child: child);
    return _system.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      PageSheet(child: child),
    );
  }
}

class PixelDissolveTransition extends StatelessWidget {
  const PixelDissolveTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final curved = CurvedAnimation(
      parent: animation,
      curve: AppMotion.enter,
      reverseCurve: AppMotion.exit,
    );

    return AnimatedBuilder(
      animation: curved,
      // Страница — на своём листе: экраны прозрачные, фон и сетку им
      // подкладывает лист, см. [PageSheet].
      child: PageSheet(child: child),
      builder: (context, child) {
        final t = curved.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            // Небольшой сдвиг вверх — движение читается даже там, где
            // dissolve почти незаметен (например, на тёмном фоне).
            Transform.translate(
              offset: Offset(0, (1 - t) * 8),
              child: Opacity(
                opacity: (0.35 + 0.65 * t).clamp(0.0, 1.0),
                child: child,
              ),
            ),
            if (t < 1)
              IgnorePointer(
                child: CustomPaint(
                  painter: _PixelDissolvePainter(
                    progress: t,
                    blockColor: colors.background,
                    // Отдельного токена под сканлайн в палитре нет и не
                    // заводится: в f0kus он есть потому, что там сканлайны
                    // лежат на фонах, карточках и кнопках, а здесь — ровно
                    // в этом переходе. Разделитель того же семейства:
                    // еле заметная линия поверх фона.
                    scanlineColor: colors.divider,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PixelDissolvePainter extends CustomPainter {
  _PixelDissolvePainter({
    required this.progress,
    required this.blockColor,
    required this.scanlineColor,
  });

  /// 0 — экран полностью закрыт блоками, 1 — блоков нет.
  final double progress;
  final Color blockColor;
  final Color scanlineColor;

  static const double _block = 18;
  static const double _scanlineStep = 4;

  /// Детерминированный «шум» в диапазоне 0..1 по координатам блока —
  /// обычный целочисленный хеш, без Random: картинка обязана быть
  /// одинаковой на каждом кадре анимации.
  double _threshold(int x, int y) {
    var h = x * 374761393 + y * 668265263;
    h = (h ^ (h >> 13)) * 1274126177;
    h = h ^ (h >> 16);
    return (h & 0xFFFF) / 0xFFFF;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = blockColor;
    final cols = (size.width / _block).ceil();
    final rows = (size.height / _block).ceil();

    for (var y = 0; y < rows; y++) {
      for (var x = 0; x < cols; x++) {
        // Блоки уходят волной сверху вниз: к порогу шума добавляем
        // вертикальную составляющую, иначе dissolve выглядит статичным.
        final wave = rows == 0 ? 0.0 : y / rows * 0.35;
        final threshold = (_threshold(x, y) * 0.65 + wave).clamp(0.0, 1.0);
        if (progress < threshold) {
          canvas.drawRect(
            Rect.fromLTWH(x * _block, y * _block, _block, _block),
            paint,
          );
        }
      }
    }

    // Сканлайны: ярче в начале перехода, к концу полностью исчезают.
    final scanAlpha = (1 - progress) * 0.9;
    if (scanAlpha > 0.01) {
      final scanPaint = Paint()
        ..color = scanlineColor.withValues(alpha: scanlineColor.a * scanAlpha)
        ..strokeWidth = 1;
      for (var y = 0.0; y < size.height; y += _scanlineStep) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), scanPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_PixelDissolvePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.blockColor != blockColor ||
      oldDelegate.scanlineColor != scanlineColor;
}

/// Явный маршрут с тем же эффектом — для переходов, которые открываются
/// не через `MaterialPageRoute`.
PageRoute<T> pixelDissolveRoute<T>(
  Widget page, {
  bool fullscreenDialog = false,
}) {
  return PageRouteBuilder<T>(
    fullscreenDialog: fullscreenDialog,
    transitionDuration: AppMotion.route,
    reverseTransitionDuration: AppMotion.route,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        PixelDissolveTransition(animation: animation, child: child),
  );
}
