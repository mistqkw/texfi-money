import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'pixel_icon.dart';

/// Линейный набор бета-стиля — те же знаки, что в [PixelIcons], только
/// перерисованные пером: контур в 1.6 единицы на поле 24×24, скруглённые
/// концы и стыки.
///
/// Пиксельные спрайты рядом с антиквой выглядели обломками другого
/// интерфейса: рубленый квадратный силуэт спорит с засечками и мягкими
/// плоскостями. Брать готовый набор (Material, Cupertino) нельзя по той же
/// причине, по которой его нет в основном стиле, — у приложения свой
/// рисунок. Поэтому знаки нарисованы здесь, по одному на каждый спрайт.
///
/// Соответствие ищется по самому спрайту, а не по имени: спрайты —
/// константы, и `PixelIcons.wallet` — буквально тот же список, что
/// `PixelIcons.budgets`. Так ни один вызов `PixelIcon(...)` в приложении
/// не приходится трогать: в бета-стиле он сам рисует линейный знак.
abstract final class BetaIcons {
  static final Map<List<String>, _Draw> _byPattern =
      Map<List<String>, _Draw>.identity()
        ..addAll({
          // --- Навигация ---
          PixelIcons.home: _home,
          PixelIcons.history: _history,
          PixelIcons.budgets: _wallet,
          PixelIcons.goals: _target,
          PixelIcons.statistics: _bars,
          // --- Категории ---
          PixelIcons.groceries: _cart,
          PixelIcons.restaurant: _cutlery,
          PixelIcons.food: _bowl,
          PixelIcons.transport: _car,
          PixelIcons.health: _health,
          PixelIcons.education: _cap,
          PixelIcons.entertainment: _play,
          PixelIcons.travel: _suitcase,
          PixelIcons.pets: _paw,
          PixelIcons.fitness: _dumbbell,
          PixelIcons.gifts: _gift,
          PixelIcons.bills: _receipt,
          PixelIcons.clothes: _shirt,
          PixelIcons.salary: _banknote,
          PixelIcons.freelance: _laptop,
          PixelIcons.investments: _trend,
          PixelIcons.savings: _coins,
          PixelIcons.money: _coin,
          PixelIcons.other: _dots,
          // --- Служебные ---
          PixelIcons.add: _add,
          PixelIcons.check: _check,
          PixelIcons.chevronRight: _chevronRight,
          PixelIcons.chevronDown: _chevronDown,
          PixelIcons.close: _close,
          PixelIcons.category: _grid,
          PixelIcons.settings: _sliders,
          PixelIcons.language: _speech,
          PixelIcons.themeDark: _moon,
          PixelIcons.themeLight: _sun,
          PixelIcons.themeContrast: _contrast,
          PixelIcons.font: _letter,
          PixelIcons.profiles: _people,
          PixelIcons.backupUp: _upload,
          PixelIcons.backupDown: _download,
          PixelIcons.danger: _warning,
          PixelIcons.info: _info,
          PixelIcons.delete: _trash,
          PixelIcons.edit: _pencil,
          PixelIcons.lock: _lock,
          PixelIcons.calendar: _calendar,
          PixelIcons.clock: _clock,
          PixelIcons.person: _person,
          PixelIcons.globe: _globe,
          PixelIcons.heart: _heart,
          PixelIcons.code: _code,
          PixelIcons.replay: _replay,
          PixelIcons.terminal: _terminal,
          PixelIcons.license: _document,
          PixelIcons.linkOut: _linkOut,
          PixelIcons.camera: _camera,
          PixelIcons.netWorth: _bank,
          PixelIcons.subscriptions: _repeat,
          PixelIcons.reports: _report,
          PixelIcons.cashFlow: _flow,
          PixelIcons.advice: _bulb,
          PixelIcons.risk: _shield,
          PixelIcons.flowIncome: _arrowIn,
          PixelIcons.flowLiability: _arrowOut,
          PixelIcons.flowNeutral: _arrowBoth,
          PixelIcons.creditCard: _card,
        });

  /// Есть ли у спрайта линейная пара. Спрайт без пары рисуется мягкой
  /// версией пиксельного — см. [BetaIcon].
  static bool has(List<String> pattern) => _byPattern.containsKey(pattern);

  /// Все спрайты, у которых есть линейная пара, — для проверки набора.
  static Iterable<List<String>> get covered => _byPattern.keys;
}

/// Линейный знак для спрайта [pattern].
class BetaIcon extends StatelessWidget {
  const BetaIcon({
    super.key,
    required this.pattern,
    required this.size,
    required this.color,
  });

  final List<String> pattern;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _BetaIconPainter(
          draw: BetaIcons._byPattern[pattern],
          pattern: pattern,
          color: color,
        ),
      ),
    );
  }
}

typedef _Draw = void Function(_Pen p);

class _BetaIconPainter extends CustomPainter {
  const _BetaIconPainter({
    required this.draw,
    required this.pattern,
    required this.color,
  });

  final _Draw? draw;
  final List<String> pattern;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 24;
    canvas.save();
    canvas.scale(scale);
    final draw = this.draw;
    if (draw != null) {
      // На мелком кегле (шеврон в 14px) 1.6 единицы сжимались бы в
      // волосок меньше пикселя — перо не бывает тоньше 1.2px.
      final width = math.max(1.6, 1.2 / scale);
      draw(_Pen(canvas, color, width));
    } else {
      _softSprite(canvas);
    }
    canvas.restore();
  }

  /// Запасной путь для спрайта без линейной пары: пиксели становятся
  /// скруглёнными точками — рисунок тот же, но без рубленых ступенек.
  void _softSprite(Canvas canvas) {
    final rows = pattern.length;
    if (rows == 0) return;
    final cell = 24 / rows;
    final solid = Paint()..color = color;
    final shade = Paint()..color = color.withValues(alpha: 0.4);
    for (var y = 0; y < rows; y++) {
      final row = pattern[y];
      for (var x = 0; x < row.length; x++) {
        final paint = switch (row[x]) {
          '#' => solid,
          '+' => shade,
          _ => null,
        };
        if (paint == null) continue;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x * cell, y * cell, cell, cell).deflate(0.25),
            Radius.circular(cell * 0.4),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_BetaIconPainter oldDelegate) =>
      oldDelegate.color != color || !identical(oldDelegate.pattern, pattern);
}

/// Перо: всё, чем рисуются знаки, в координатах поля 24×24.
class _Pen {
  _Pen(this.canvas, Color color, double width)
      : stroke = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..isAntiAlias = true,
        fill = Paint()
          ..color = color
          ..style = PaintingStyle.fill,
        tint = Paint()
          ..color = color.withValues(alpha: 0.22)
          ..style = PaintingStyle.fill;

  final Canvas canvas;
  final Paint stroke;
  final Paint fill;

  /// Лёгкая подложка — второй тон знака, как полутон у спрайтов.
  final Paint tint;

  void line(double x1, double y1, double x2, double y2) =>
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), stroke);

  /// Ломаная по парам координат.
  void poly(List<double> xy, {bool close = false}) {
    final path = Path()..moveTo(xy[0], xy[1]);
    for (var i = 2; i < xy.length; i += 2) {
      path.lineTo(xy[i], xy[i + 1]);
    }
    if (close) path.close();
    canvas.drawPath(path, stroke);
  }

  void circle(double x, double y, double r) =>
      canvas.drawCircle(Offset(x, y), r, stroke);

  void dot(double x, double y, [double r = 1.1]) =>
      canvas.drawCircle(Offset(x, y), r, fill);

  void rrect(double l, double t, double w, double h, double r,
      {bool tinted = false}) {
    final rr = RRect.fromRectAndRadius(
      Rect.fromLTWH(l, t, w, h),
      Radius.circular(r),
    );
    if (tinted) canvas.drawRRect(rr, tint);
    canvas.drawRRect(rr, stroke);
  }

  void oval(double l, double t, double w, double h) =>
      canvas.drawOval(Rect.fromLTWH(l, t, w, h), stroke);

  /// Дуга окружности; углы в градусах, по часовой от «трёх часов».
  void arc(double cx, double cy, double r, double start, double sweep) {
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      start * math.pi / 180,
      sweep * math.pi / 180,
      false,
      stroke,
    );
  }

  void path(Path p, {bool tinted = false}) {
    if (tinted) canvas.drawPath(p, tint);
    canvas.drawPath(p, stroke);
  }

  void fillPath(Path p) => canvas.drawPath(p, fill);
}

// --- Навигация --------------------------------------------------------

void _home(_Pen p) {
  p.path(
    Path()
      ..moveTo(4.5, 10)
      ..lineTo(4.5, 20)
      ..lineTo(19.5, 20)
      ..lineTo(19.5, 10),
  );
  p.poly([2.5, 11.5, 12, 3.5, 21.5, 11.5]);
  p.poly([10, 20, 10, 14.5, 14, 14.5, 14, 20]);
}

void _history(_Pen p) {
  // Циферблат с разрывом слева и стрелкой назад.
  p.arc(12, 12, 8.5, 180, 300);
  p.poly([1.8, 9.2, 3.5, 12, 6.3, 10.3]);
  p.poly([12, 7.5, 12, 12, 15.2, 14]);
}

void _wallet(_Pen p) {
  p.rrect(3, 6.5, 18, 13.5, 3);
  p.poly([5.5, 6.5, 15.5, 3.5, 16.8, 6.5]);
  p.rrect(14.5, 11, 6.5, 5, 2, tinted: true);
  p.dot(17.2, 13.5, 1);
}

void _target(_Pen p) {
  p.circle(12, 12, 8.5);
  p.circle(12, 12, 5);
  p.dot(12, 12, 1.6);
}

void _bars(_Pen p) {
  p.line(3.5, 20.5, 20.5, 20.5);
  p.line(6.5, 17.5, 6.5, 12.5);
  p.line(12, 17.5, 12, 5.5);
  p.line(17.5, 17.5, 17.5, 9.5);
}

// --- Категории --------------------------------------------------------

void _cart(_Pen p) {
  p.poly([2.5, 4, 5.3, 4, 7.4, 15.5, 18, 15.5, 20.5, 7.5, 6.2, 7.5]);
  p.circle(9, 19.3, 1.4);
  p.circle(16.5, 19.3, 1.4);
}

void _cutlery(_Pen p) {
  // Вилка.
  p.line(8, 3.5, 8, 20.5);
  p.path(
    Path()
      ..moveTo(5, 3.5)
      ..lineTo(5, 8)
      ..quadraticBezierTo(5, 10.8, 8, 10.8)
      ..quadraticBezierTo(11, 10.8, 11, 8)
      ..lineTo(11, 3.5),
  );
  // Нож.
  p.path(
    Path()
      ..moveTo(16.5, 20.5)
      ..lineTo(16.5, 3.5)
      ..cubicTo(19.5, 5, 20, 10, 19.5, 13)
      ..lineTo(16.5, 13),
  );
}

void _bowl(_Pen p) {
  p.path(
    Path()
      ..moveTo(3, 11)
      ..lineTo(21, 11)
      ..cubicTo(21, 16.5, 17, 20, 12, 20)
      ..cubicTo(7, 20, 3, 16.5, 3, 11)
      ..close(),
    tinted: true,
  );
  p.path(
    Path()
      ..moveTo(9, 8)
      ..quadraticBezierTo(7.5, 6, 9, 4.2)
      ..moveTo(13, 8)
      ..quadraticBezierTo(11.5, 5.5, 13, 3.2)
      ..moveTo(17, 8)
      ..quadraticBezierTo(15.5, 6, 17, 4.2),
  );
}

void _car(_Pen p) {
  p.path(
    Path()
      ..moveTo(4.5, 11.5)
      ..lineTo(6.8, 6.5)
      ..lineTo(17.2, 6.5)
      ..lineTo(19.5, 11.5),
  );
  p.rrect(2.5, 11.5, 19, 5.5, 2, tinted: true);
  p.line(5, 17, 5, 19.5);
  p.line(19, 17, 19, 19.5);
  p.dot(6.8, 14.2);
  p.dot(17.2, 14.2);
}

void _health(_Pen p) {
  p.rrect(3.5, 3.5, 17, 17, 5, tinted: true);
  p.line(12, 8, 12, 16);
  p.line(8, 12, 16, 12);
}

void _cap(_Pen p) {
  p.poly([2, 9.5, 12, 4.5, 22, 9.5, 12, 14.5], close: true);
  p.path(
    Path()
      ..moveTo(6.5, 12)
      ..lineTo(6.5, 16.5)
      ..quadraticBezierTo(12, 20.5, 17.5, 16.5)
      ..lineTo(17.5, 12),
  );
  p.line(22, 9.5, 22, 15);
}

void _play(_Pen p) {
  p.rrect(2.5, 4.5, 19, 15, 3.5);
  p.poly([10, 8.8, 15.5, 12, 10, 15.2], close: true);
}

void _suitcase(_Pen p) {
  p.rrect(3, 7.5, 18, 12.5, 3, tinted: true);
  p.poly([9, 7.5, 9, 4.5, 15, 4.5, 15, 7.5]);
  p.line(8, 7.5, 8, 20);
  p.line(16, 7.5, 16, 20);
}

void _paw(_Pen p) {
  p.path(
    Path()
      ..moveTo(12, 12.5)
      ..cubicTo(15.5, 12.5, 18.5, 16.5, 17, 19)
      ..cubicTo(15.8, 21, 13.5, 19.5, 12, 19.5)
      ..cubicTo(10.5, 19.5, 8.2, 21, 7, 19)
      ..cubicTo(5.5, 16.5, 8.5, 12.5, 12, 12.5)
      ..close(),
    tinted: true,
  );
  p.circle(5, 10.5, 1.8);
  p.circle(9, 6, 1.8);
  p.circle(15, 6, 1.8);
  p.circle(19, 10.5, 1.8);
}

void _dumbbell(_Pen p) {
  p.line(7.5, 12, 16.5, 12);
  p.rrect(4, 7.5, 3.5, 9, 1.2);
  p.rrect(16.5, 7.5, 3.5, 9, 1.2);
  p.line(2.2, 10, 2.2, 14);
  p.line(21.8, 10, 21.8, 14);
}

void _gift(_Pen p) {
  p.rrect(4, 11, 16, 9.5, 1.8);
  p.rrect(3, 7, 18, 4, 1.5, tinted: true);
  p.line(12, 7, 12, 20.5);
  p.path(
    Path()
      ..moveTo(12, 7)
      ..cubicTo(9.5, 2.5, 5.5, 4.5, 8, 7)
      ..moveTo(12, 7)
      ..cubicTo(14.5, 2.5, 18.5, 4.5, 16, 7),
  );
}

void _receipt(_Pen p) {
  p.poly([
    5, 3.5, 19, 3.5, 19, 20.5, //
    16.7, 19, 14.3, 20.5, 12, 19, 9.7, 20.5, 7.3, 19, 5, 20.5,
  ], close: true);
  p.line(8.5, 8, 15.5, 8);
  p.line(8.5, 11.5, 15.5, 11.5);
  p.line(8.5, 15, 12.5, 15);
}

void _shirt(_Pen p) {
  p.path(
    Path()
      ..moveTo(8.5, 3.5)
      ..lineTo(3, 6.5)
      ..lineTo(5, 10.5)
      ..lineTo(7, 9.5)
      ..lineTo(7, 20.5)
      ..lineTo(17, 20.5)
      ..lineTo(17, 9.5)
      ..lineTo(19, 10.5)
      ..lineTo(21, 6.5)
      ..lineTo(15.5, 3.5)
      ..quadraticBezierTo(12, 7, 8.5, 3.5)
      ..close(),
    tinted: true,
  );
}

void _banknote(_Pen p) {
  p.rrect(2.5, 6.5, 19, 11, 2.5, tinted: true);
  p.circle(12, 12, 2.8);
  p.dot(6, 12);
  p.dot(18, 12);
}

void _laptop(_Pen p) {
  p.rrect(4.5, 5, 15, 10, 1.8, tinted: true);
  p.poly([4.5, 15, 2.5, 19, 21.5, 19, 19.5, 15]);
}

void _trend(_Pen p) {
  p.poly([3, 17.5, 9, 11.5, 13, 15, 20.5, 7.5]);
  p.poly([15.5, 7.5, 20.5, 7.5, 20.5, 12.5]);
}

void _coins(_Pen p) {
  p.oval(5, 4, 14, 5);
  p.line(5, 6.5, 5, 17.5);
  p.line(19, 6.5, 19, 17.5);
  p.arc(12, 11, 7, 0, 180);
  p.arc(12, 14.5, 7, 0, 180);
  // Нижний край — тот же эллипс, что сверху, сжатый по высоте.
  p.canvas.drawArc(
    const Rect.fromLTWH(5, 15, 14, 5),
    0,
    math.pi,
    false,
    p.stroke,
  );
}

void _coin(_Pen p) {
  p.circle(12, 12, 8.5);
  p.line(12, 6.5, 12, 17.5);
  p.path(
    Path()
      ..moveTo(15, 9.3)
      ..cubicTo(14.3, 7.8, 9, 7.6, 9, 10.2)
      ..cubicTo(9, 12.6, 15, 11.6, 15, 14.1)
      ..cubicTo(15, 16.6, 9.7, 16.4, 9, 14.8),
  );
}

void _dots(_Pen p) {
  p.dot(6, 12, 1.6);
  p.dot(12, 12, 1.6);
  p.dot(18, 12, 1.6);
}

// --- Служебные --------------------------------------------------------

void _add(_Pen p) {
  p.line(12, 5, 12, 19);
  p.line(5, 12, 19, 12);
}

void _check(_Pen p) => p.poly([4.5, 12.5, 9.5, 17.5, 19.5, 6.5]);

void _chevronRight(_Pen p) => p.poly([9, 5, 16, 12, 9, 19]);

void _chevronDown(_Pen p) => p.poly([5, 9, 12, 16, 19, 9]);

void _close(_Pen p) {
  p.line(6, 6, 18, 18);
  p.line(18, 6, 6, 18);
}

void _grid(_Pen p) {
  p.rrect(3.5, 3.5, 7, 7, 2);
  p.rrect(13.5, 3.5, 7, 7, 2, tinted: true);
  p.rrect(3.5, 13.5, 7, 7, 2, tinted: true);
  p.rrect(13.5, 13.5, 7, 7, 2);
}

void _sliders(_Pen p) {
  p.line(3.5, 7, 7, 7);
  p.line(11, 7, 20.5, 7);
  p.circle(9, 7, 2);
  p.line(3.5, 12, 13, 12);
  p.line(17, 12, 20.5, 12);
  p.circle(15, 12, 2);
  p.line(3.5, 17, 6, 17);
  p.line(10, 17, 20.5, 17);
  p.circle(8, 17, 2);
}

void _speech(_Pen p) {
  p.path(
    Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(3, 4, 18, 13),
          const Radius.circular(3.5),
        ),
      ),
  );
  p.poly([8, 17, 7, 21, 12, 17]);
  p.poly([8.5, 14, 12, 7, 15.5, 14]);
  p.line(9.8, 11.5, 14.2, 11.5);
}

void _moon(_Pen p) {
  final crescent = Path.combine(
    PathOperation.difference,
    Path()..addOval(Rect.fromCircle(center: const Offset(11, 13), radius: 8)),
    Path()..addOval(Rect.fromCircle(center: const Offset(16, 8), radius: 6.5)),
  );
  p.path(crescent, tinted: true);
}

void _sun(_Pen p) {
  p.circle(12, 12, 4);
  for (var i = 0; i < 8; i++) {
    final a = i * math.pi / 4;
    p.line(
      12 + 6.8 * math.cos(a),
      12 + 6.8 * math.sin(a),
      12 + 9 * math.cos(a),
      12 + 9 * math.sin(a),
    );
  }
}

void _contrast(_Pen p) {
  p.circle(12, 12, 8.5);
  p.fillPath(
    Path()
      ..moveTo(12, 3.5)
      ..arcTo(
        Rect.fromCircle(center: const Offset(12, 12), radius: 8.5),
        -math.pi / 2,
        -math.pi,
        false,
      )
      ..close(),
  );
}

void _letter(_Pen p) {
  // «A» с засечками — знак шрифта в антиквенном стиле.
  p.poly([4.5, 19.5, 11, 4.5, 17.5, 19.5]);
  p.line(7, 14, 15, 14);
  p.line(2.8, 19.5, 6.5, 19.5);
  p.line(15.5, 19.5, 19.5, 19.5);
  p.line(9.5, 4.5, 12.5, 4.5);
}

void _people(_Pen p) {
  p.circle(9, 8.5, 3.2);
  p.path(
    Path()
      ..moveTo(3, 19.5)
      ..cubicTo(3, 15.5, 5.7, 13.5, 9, 13.5)
      ..cubicTo(12.3, 13.5, 15, 15.5, 15, 19.5),
  );
  p.arc(16.5, 8, 2.6, -110, 220);
  p.path(
    Path()
      ..moveTo(17, 13.5)
      ..cubicTo(19.5, 13.8, 21, 15.5, 21, 18.5),
  );
}

void _person(_Pen p) {
  p.circle(12, 8, 3.8);
  p.path(
    Path()
      ..moveTo(4.5, 20.5)
      ..cubicTo(4.5, 15.8, 8, 13.8, 12, 13.8)
      ..cubicTo(16, 13.8, 19.5, 15.8, 19.5, 20.5),
  );
}

void _upload(_Pen p) {
  p.poly([4, 14.5, 4, 19.5, 20, 19.5, 20, 14.5]);
  p.line(12, 15, 12, 4);
  p.poly([7.5, 8.5, 12, 4, 16.5, 8.5]);
}

void _download(_Pen p) {
  p.poly([4, 14.5, 4, 19.5, 20, 19.5, 20, 14.5]);
  p.line(12, 4, 12, 15);
  p.poly([7.5, 10.5, 12, 15, 16.5, 10.5]);
}

void _warning(_Pen p) {
  p.path(
    Path()
      ..moveTo(10.3, 4.6)
      ..quadraticBezierTo(12, 2, 13.7, 4.6)
      ..lineTo(20.8, 17.6)
      ..quadraticBezierTo(22, 20, 19.3, 20)
      ..lineTo(4.7, 20)
      ..quadraticBezierTo(2, 20, 3.2, 17.6)
      ..close(),
    tinted: true,
  );
  p.line(12, 9.5, 12, 13.5);
  p.dot(12, 16.8);
}

void _info(_Pen p) {
  p.circle(12, 12, 8.5);
  p.line(12, 11, 12, 16.5);
  p.dot(12, 7.8);
}

void _trash(_Pen p) {
  p.line(4, 6.5, 20, 6.5);
  p.poly([9.5, 6.5, 9.5, 4, 14.5, 4, 14.5, 6.5]);
  p.path(
    Path()
      ..moveTo(6, 6.5)
      ..lineTo(7, 20)
      ..lineTo(17, 20)
      ..lineTo(18, 6.5),
    tinted: true,
  );
  p.line(10, 10.5, 10, 16);
  p.line(14, 10.5, 14, 16);
}

void _pencil(_Pen p) {
  p.poly([4, 20, 4.8, 16, 16, 4.8, 19.2, 8, 8, 19.2], close: true);
  p.line(13.8, 7, 17, 10.2);
}

void _lock(_Pen p) {
  p.rrect(5, 10.5, 14, 10, 2.5, tinted: true);
  p.path(
    Path()
      ..moveTo(8, 10.5)
      ..lineTo(8, 7.5)
      ..arcTo(const Rect.fromLTWH(8, 3.5, 8, 8), math.pi, math.pi, false)
      ..lineTo(16, 10.5),
  );
  p.line(12, 14.5, 12, 16.5);
}

void _calendar(_Pen p) {
  p.rrect(3.5, 5, 17, 15.5, 3);
  p.line(3.5, 10, 20.5, 10);
  p.line(8, 3, 8, 7);
  p.line(16, 3, 16, 7);
  p.dot(8, 14);
  p.dot(12, 14);
  p.dot(16, 14);
}

void _clock(_Pen p) {
  p.circle(12, 12, 8.5);
  p.poly([12, 7, 12, 12, 15.5, 14]);
}

void _globe(_Pen p) {
  p.circle(12, 12, 8.5);
  p.oval(8, 3.5, 8, 17);
  p.line(3.5, 12, 20.5, 12);
}

void _heart(_Pen p) {
  p.path(
    Path()
      ..moveTo(12, 20)
      ..cubicTo(5, 15.5, 2.5, 11.5, 3.5, 8)
      ..cubicTo(4.5, 4.5, 9.5, 3.5, 12, 7.5)
      ..cubicTo(14.5, 3.5, 19.5, 4.5, 20.5, 8)
      ..cubicTo(21.5, 11.5, 19, 15.5, 12, 20)
      ..close(),
    tinted: true,
  );
}

void _code(_Pen p) {
  p.poly([8.5, 7, 3.5, 12, 8.5, 17]);
  p.poly([15.5, 7, 20.5, 12, 15.5, 17]);
}

void _replay(_Pen p) {
  // Дуга по часовой с разрывом сверху; наконечник смотрит по касательной
  // в конце дуги.
  p.arc(12, 12.5, 7.5, -60, 300);
  p.poly([7.8, 9.2, 9.1, 5.5, 5.3, 4.8]);
}

void _terminal(_Pen p) {
  p.rrect(3, 4.5, 18, 15, 3);
  p.poly([7, 9.5, 10, 12, 7, 14.5]);
  p.line(12, 14.5, 16.5, 14.5);
}

void _document(_Pen p) {
  p.poly([6, 3.5, 14.5, 3.5, 18.5, 7.5, 18.5, 20.5, 6, 20.5], close: true);
  p.poly([14.5, 3.5, 14.5, 7.5, 18.5, 7.5]);
  p.line(9, 11.5, 15.5, 11.5);
  p.line(9, 15, 15.5, 15);
}

void _linkOut(_Pen p) {
  p.poly([17, 13.5, 17, 19.5, 4.5, 19.5, 4.5, 7, 10.5, 7]);
  p.line(10.5, 13.5, 19.5, 4.5);
  p.poly([14, 4.5, 19.5, 4.5, 19.5, 10]);
}

void _camera(_Pen p) {
  p.rrect(3, 7, 18, 13, 3);
  p.poly([8.5, 7, 10, 4.5, 14, 4.5, 15.5, 7]);
  p.circle(12, 13.5, 3.5);
}

void _bank(_Pen p) {
  p.poly([3, 9, 12, 3.5, 21, 9], close: true);
  for (final x in const <double>[6.5, 10, 14, 17.5]) {
    p.line(x, 11.5, x, 17);
  }
  p.line(3, 20, 21, 20);
}

void _repeat(_Pen p) {
  p.poly([5, 11.5, 5, 7.5, 18.5, 7.5]);
  p.poly([15.5, 4.5, 18.5, 7.5, 15.5, 10.5]);
  p.poly([19, 12.5, 19, 16.5, 5.5, 16.5]);
  p.poly([8.5, 13.5, 5.5, 16.5, 8.5, 19.5]);
}

void _report(_Pen p) {
  p.rrect(4.5, 3.5, 15, 17, 2.5);
  p.line(8.5, 16.5, 8.5, 12.5);
  p.line(12, 16.5, 12, 8.5);
  p.line(15.5, 16.5, 15.5, 11);
}

void _flow(_Pen p) {
  p.line(8, 19.5, 8, 5);
  p.poly([4.5, 8.5, 8, 5, 11.5, 8.5]);
  p.line(16, 4.5, 16, 19);
  p.poly([12.5, 15.5, 16, 19, 19.5, 15.5]);
}

void _bulb(_Pen p) {
  p.path(
    Path()
      ..moveTo(9, 16.5)
      ..cubicTo(6.5, 14.8, 5.5, 12.3, 5.5, 10)
      ..cubicTo(5.5, 6.2, 8.5, 3.5, 12, 3.5)
      ..cubicTo(15.5, 3.5, 18.5, 6.2, 18.5, 10)
      ..cubicTo(18.5, 12.3, 17.5, 14.8, 15, 16.5)
      ..close(),
    tinted: true,
  );
  p.line(9.5, 20, 14.5, 20);
}

void _shield(_Pen p) {
  p.path(
    Path()
      ..moveTo(12, 3.3)
      ..lineTo(19.5, 6.3)
      ..lineTo(19.5, 11.5)
      ..cubicTo(19.5, 16, 16.2, 19.2, 12, 20.7)
      ..cubicTo(7.8, 19.2, 4.5, 16, 4.5, 11.5)
      ..lineTo(4.5, 6.3)
      ..close(),
    tinted: true,
  );
  p.line(12, 8.5, 12, 12.5);
  p.dot(12, 15.6);
}

void _arrowIn(_Pen p) {
  p.line(18, 6, 6.5, 17.5);
  p.poly([6.5, 9.5, 6.5, 17.5, 14.5, 17.5]);
}

void _arrowOut(_Pen p) {
  p.line(6, 18, 17.5, 6.5);
  p.poly([9.5, 6.5, 17.5, 6.5, 17.5, 14.5]);
}

void _arrowBoth(_Pen p) {
  p.line(4, 12, 20, 12);
  p.poly([7.5, 8.5, 4, 12, 7.5, 15.5]);
  p.poly([16.5, 8.5, 20, 12, 16.5, 15.5]);
}

void _card(_Pen p) {
  p.rrect(2.5, 5.5, 19, 13, 2.5);
  p.canvas.drawRect(const Rect.fromLTWH(2.5, 9, 19, 2.2), p.tint);
  p.line(2.5, 9, 21.5, 9);
  p.line(6, 15, 10, 15);
}

/// Знак беты «коллаж»: тот же рисунок пером, под ним — синий оттиск,
/// сдвинутый вниз-вправо, как краска, легшая мимо при печати. Тот же
/// приём, что у текста поверх синих пятен на картинке автора: чёрное
/// лежит на синем, но не совпадает с ним.
///
/// Если сам знак синий, оттиск — чёрный: синий на синем не читается.
class CollageIcon extends StatelessWidget {
  const CollageIcon({
    super.key,
    required this.pattern,
    required this.size,
    required this.color,
  });

  final List<String> pattern;
  final double size;
  final Color color;

  static const Color _blue = Color(0xFF4A7DFB);

  @override
  Widget build(BuildContext context) {
    final shift = size * 0.08;
    final print = color.toARGB32() == _blue.toARGB32()
        ? const Color(0xFF000000)
        : _blue;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: shift,
            top: shift,
            child: BetaIcon(
              pattern: pattern,
              size: size,
              color: print.withValues(alpha: 0.85),
            ),
          ),
          BetaIcon(pattern: pattern, size: size, color: color),
        ],
      ),
    );
  }
}
