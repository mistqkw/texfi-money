import 'dart:math' as math;

import 'package:flutter/painting.dart';

/// Пятно беты «коллаж» — форма, будто вырезанная ножницами из цветной
/// бумаги, как синие пятна на картинке автора.
///
/// Контур — замкнутая кривая через точки вокруг центра со случайным
/// радиусом. Часть отрезков — плавные дуги, часть — прямые срезы: ровно
/// так выглядит бумага, которую резали, поворачивая лист, — то мягко,
/// то одним движением. Чисто плавное пятно читалось бы как капля или
/// облачко из детской иллюстрации, а не как вырезка.
///
/// Форма задаётся зерном ([seed]) и детерминирована: одно и то же зерно
/// даёт одно и то же пятно на каждом кадре и каждом запуске.
abstract final class CollageBlob {
  /// Контур пятна в прямоугольнике [bounds].
  ///
  /// [morphTo] и [t] — плавный переход к форме с другим зерном: радиусы
  /// и углы точек перетекают, пятно «переминается», а не прыгает.
  static Path path(
    Rect bounds,
    int seed, {
    int? morphTo,
    double t = 0,
    int points = 7,
    bool calm = false,
  }) {
    final a = _shape(seed, points, calm: calm);
    final b = morphTo == null ? a : _shape(morphTo, points, calm: calm);
    final center = bounds.center;
    final rx = bounds.width / 2;
    final ry = bounds.height / 2;

    final pts = <Offset>[];
    final cuts = <bool>[];
    for (var i = 0; i < points; i++) {
      final angle = _lerp(a.angles[i], b.angles[i], t);
      final radius = _lerp(a.radii[i], b.radii[i], t);
      pts.add(center + Offset(math.cos(angle) * rx * radius, math.sin(angle) * ry * radius));
      cuts.add(t < 0.5 ? a.cuts[i] : b.cuts[i]);
    }

    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (var i = 0; i < points; i++) {
      final p0 = pts[(i - 1 + points) % points];
      final p1 = pts[i];
      final p2 = pts[(i + 1) % points];
      final p3 = pts[(i + 2) % points];
      if (cuts[i]) {
        path.lineTo(p2.dx, p2.dy);
        continue;
      }
      // Катмулл — Ром через соседние точки: дуга проходит через обе
      // опорные точки и гладко стыкуется с соседними дугами.
      const k = 1 / 6;
      final c1 = p1 + (p2 - p0) * k;
      final c2 = p2 - (p3 - p1) * k;
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }
    return path..close();
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  /// [calm] — спокойная вырезка: без острого хвоста и почти без
  /// провалов. Нужна там, где пятно — подложка под словом: у рваного
  /// пятна слово вылезает за края.
  static _Shape _shape(int seed, int points, {bool calm = false}) {
    final rng = math.Random(seed * 7919 + 17);
    final angles = <double>[];
    final radii = <double>[];
    final cuts = <bool>[];
    final step = 2 * math.pi / points;
    final start = rng.nextDouble() * step;
    for (var i = 0; i < points; i++) {
      angles.add(start + i * step + (rng.nextDouble() - 0.5) * step * 0.6);
      // Один луч из семи вытянут — острый «хвост», как у верхнего пятна
      // на картинке; остальные гуляют в пределах трети радиуса.
      radii.add(calm
          ? 0.86 + rng.nextDouble() * 0.14
          : i == seed % points
              ? 1.0
              : 0.62 + rng.nextDouble() * 0.33);
      cuts.add(rng.nextDouble() < (calm ? 0.2 : 0.28));
    }
    return _Shape(angles, radii, cuts);
  }
}

class _Shape {
  const _Shape(this.angles, this.radii, this.cuts);

  final List<double> angles;
  final List<double> radii;
  final List<bool> cuts;
}

