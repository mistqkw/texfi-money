import 'dart:math' as math;

import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'app_colors_ext.dart';
import 'app_motion.dart';
import 'app_style_ext.dart';
import 'beta_options.dart';
import 'collage_shapes.dart';
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
    return PixelDissolveTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      child: child,
    );
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
    this.secondaryAnimation,
    required this.child,
  });

  final Animation<double> animation;

  /// Анимация экрана, который открывают поверх этого. Нужна только
  /// бета-стилю: там уходящая страница чуть отъезжает под новую.
  final Animation<double>? secondaryAnimation;
  final Widget child;

  /// Лист, на котором лежит страница в бета-стиле, — фон с зерном и
  /// знаком «$». Задаётся из `main.dart`: сам лист — виджет слоя
  /// представления, и тема не должна о нём знать.
  ///
  /// Лист нужен каждой странице свой. В бете экраны прозрачные, и при
  /// перелистывании старая страница просвечивала бы сквозь новую; с
  /// собственным листом новая честно её закрывает. Знак на всех листах
  /// стоит в одном и том же месте, поэтому по окончании перехода разницы
  /// с общим фоном не видно.
  static Widget Function(Widget child)? betaSheetBuilder;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final curved = CurvedAnimation(
      parent: animation,
      curve: AppMotion.enter,
      reverseCurve: AppMotion.exit,
    );

    // В бета-стиле — перелистывание, а не пиксельный распад: блоки и
    // сканлайны поверх антиквы читались бы как сбой отрисовки.
    if (context.style.beta) {
      final sheet = betaSheetBuilder ?? (Widget c) => c;
      switch (context.betaOptions.transition) {
        case BetaTransition.pageTurn when context.style.isCollage:
          return _BlobCut(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: sheet(child),
          );
        case BetaTransition.pageTurn:
          return _PageTurn(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            sheet: betaSheetBuilder,
            child: child,
          );
        case BetaTransition.fade:
          // Проявление: страница всплывает на своём листе. Лист нужен и
          // здесь — иначе старая страница просвечивала бы сквозь новую.
          return FadeTransition(
            opacity: curved,
            child: sheet(
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.02),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            ),
          );
        case BetaTransition.instant:
          return sheet(child);
      }
    }

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
        PixelDissolveTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        ),
  );
}

/// Перелистывание бета-стиля: новая страница задвигается справа поверх
/// старой, по её краю идёт чернильная линейка; содержимое старой
/// страницы отъезжает влево и бледнеет. Назад — то же в обратную сторону.
///
/// Двигается только содержимое, лист со знаком «$» стоит на месте: знак
/// нарисован на каждом листе в одной и той же точке, и если бы листы
/// ехали целиком, на переходе было бы видно два разъехавшихся знака.
/// Так страницы скользят по неподвижной бумаге.
class _PageTurn extends StatelessWidget {
  const _PageTurn({
    required this.animation,
    required this.secondaryAnimation,
    required this.sheet,
    required this.child,
  });

  final Animation<double> animation;
  final Animation<double>? secondaryAnimation;
  final Widget Function(Widget child)? sheet;
  final Widget child;

  static const Curve _curve = Curves.easeInOutCubic;

  @override
  Widget build(BuildContext context) {
    final ink = context.colors.textPrimary;
    final covering = secondaryAnimation;
    final onSheet = sheet ?? (Widget c) => c;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return AnimatedBuilder(
          animation: Listenable.merge([animation, ?covering]),
          child: child,
          builder: (context, child) {
            final t = _curve.transform(animation.value);
            final s = covering == null ? 0.0 : _curve.transform(covering.value);

            // Содержимое страницы, которую накрывают, — отъезжает на
            // треть ширины и бледнеет, уступая место новой.
            Widget content = child!;
            if (s > 0) {
              content = Opacity(
                opacity: 1 - 0.6 * s,
                child: Transform.translate(
                  offset: Offset(-width * 0.3 * s, 0),
                  child: content,
                ),
              );
            }

            if (t >= 1) return onSheet(content);

            final edge = width * (1 - t);
            return Stack(
              fit: StackFit.expand,
              children: [
                ClipRect(
                  clipper: _FromEdgeClipper(edge),
                  child: onSheet(
                    Transform.translate(
                      offset: Offset(edge, 0),
                      child: content,
                    ),
                  ),
                ),
                if (t > 0)
                  Positioned(
                    left: edge - 0.75,
                    top: 0,
                    bottom: 0,
                    width: 1.5,
                    child: IgnorePointer(
                      // Линейка видна в движении и гаснет к концам: в
                      // покое на краю экрана ей делать нечего.
                      child: ColoredBox(
                        color: ink.withValues(
                          alpha: 0.8 * math.sin(math.pi * t),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

/// Оставляет видимой часть страницы правее [left].
class _FromEdgeClipper extends CustomClipper<Rect> {
  const _FromEdgeClipper(this.left);

  final double left;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTRB(left.clamp(0.0, size.width), 0, size.width, size.height);

  @override
  bool shouldReclip(_FromEdgeClipper oldClipper) => oldClipper.left != left;
}

/// Переход беты «коллаж»: новая страница вырезается сквозь пятно, которое
/// растёт из правого нижнего угла — оттуда, где лежит кнопка «+» и куда
/// тянется большой палец. По краю выреза идёт синяя кромка, как край
/// цветной бумаги под вырезанным листом. Старая страница под ним чуть
/// отступает вглубь.
class _BlobCut extends StatelessWidget {
  const _BlobCut({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  final Animation<double> animation;
  final Animation<double>? secondaryAnimation;
  final Widget child;

  static const Curve _curve = Curves.easeInOutCubic;
  static const int _seed = 41;
  static const Color _rim = Color(0xFF4A7DFB);

  @override
  Widget build(BuildContext context) {
    final covering = secondaryAnimation;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final origin = Offset(size.width * 0.86, size.height * 0.88);
        final reach = size.longestSide * 1.35;

        return AnimatedBuilder(
          animation: Listenable.merge([animation, ?covering]),
          child: child,
          builder: (context, child) {
            final t = _curve.transform(animation.value);
            final s = covering == null ? 0.0 : _curve.transform(covering.value);

            Widget page = child!;
            if (s > 0) {
              page = Transform.scale(scale: 1 - 0.04 * s, child: page);
            }
            if (t >= 1) return page;
            if (t <= 0) return const SizedBox.shrink();

            final radius = reach * t;
            final cut = CollageBlob.path(
              Rect.fromCircle(center: origin, radius: radius),
              _seed,
            );
            final rim = CollageBlob.path(
              Rect.fromCircle(center: origin, radius: radius * 1.07 + 6),
              _seed,
            );
            return Stack(
              fit: StackFit.expand,
              children: [
                IgnorePointer(
                  child: CustomPaint(
                    painter: _PathPainter(
                      rim,
                      _rim.withValues(alpha: math.sin(math.pi * t)),
                    ),
                  ),
                ),
                ClipPath(clipper: _PathClipper(cut), child: page),
              ],
            );
          },
        );
      },
    );
  }
}

class _PathClipper extends CustomClipper<Path> {
  const _PathClipper(this.path);

  final Path path;

  @override
  Path getClip(Size size) => path;

  @override
  bool shouldReclip(_PathClipper oldClipper) => oldClipper.path != path;
}

class _PathPainter extends CustomPainter {
  const _PathPainter(this.path, this.color);

  final Path path;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) => canvas.drawPath(path, Paint()..color = color);

  @override
  bool shouldRepaint(_PathPainter oldDelegate) =>
      oldDelegate.path != path || oldDelegate.color != color;
}
