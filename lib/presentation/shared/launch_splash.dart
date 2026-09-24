import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_typography.dart';
import '../../core/utils/haptics.dart';
import 'brand_glyph.dart';

const _bg = Color(0xFF090B11);
const _accent = Color(0xFF4A7DFB);
const _accentLight = Color(0xFF9DB8FF);
const _accentDeep = Color(0xFF2B4FB0);
const _face = Color(0xFFFFFFFF);
const _faceShade = Color(0xFFC6D4FF);
const _gold = Color(0xFFEBBE52);
const _goldLight = Color(0xFFFFE7A6);
const _text = Color(0xFFF3F5FA);
const _textDim = Color(0xFF5F6679);

/// Первый кадр приложения: монета чеканится.
///
/// Монета — та же, что на иконке, ячейка в ячейку (см. [kBrandMark]):
/// первое, что видит пользователь при запуске, обязано совпадать с тем,
/// по чему он только что ткнул на домашнем экране.
///
/// Раньше монета собиралась из ячеек волной — пиксельно, но плоско:
/// набор квадратиков, а не предмет. Теперь это предмет с весом: монета
/// падает сверху, вращаясь так, как вращают монеты в пиксельной графике —
/// ширина меняется ступенями, без плавного сжатия, — приземляется с
/// отскоком, по ней пробегает блик, вокруг вспыхивают искры. Затем по
/// буквам выходит название, ноль в нём — золотой, как монета в руке.
///
/// Полторы секунды — потолок из фирменного стиля: заставка должна
/// успеть произойти, а не задержать.
class LaunchSplash extends StatefulWidget {
  const LaunchSplash({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<LaunchSplash> createState() => _LaunchSplashState();
}

class _LaunchSplashState extends State<LaunchSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _landed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    )..addListener(() {
        // Один отчётливый удар — в момент, когда монета легла. Ритм по
        // ходу падения превращал бы заставку в дребезг.
        if (!_landed && _controller.value >= _land) {
          _landed = true;
          Haptics.select();
        }
      });
    _controller.forward().whenComplete(() {
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Момент приземления на шкале 0..1.
  static const double _land = 0.36;

  double _seg(double begin, double end, [Curve curve = Curves.linear]) {
    final v = ((_controller.value - begin) / (end - begin)).clamp(0.0, 1.0);
    return curve.transform(v);
  }

  @override
  Widget build(BuildContext context) {
    // Фон и цвета не зависят от выбранной темы: это фирменный момент, а
    // не тематизируемый экран.
    return ColoredBox(
      color: _bg,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value;

            // Падение с отскоком: сверху до места, лёгкий подскок.
            final fall = _seg(0, _land, Curves.easeIn);
            final bounce = t < _land
                ? 0.0
                : math.sin(_seg(_land, _land + 0.14) * math.pi) * 10;
            final dy = -150 * (1 - fall) - bounce;

            // Вращение: полтора оборота за падение, ширина — ступенями.
            final turn = _seg(0, _land) * 3 * math.pi;
            final width = t >= _land ? 1.0 : _step(math.cos(turn).abs());

            final shine = _seg(_land + 0.04, _land + 0.3, Curves.easeInOut);
            final sparks = _seg(_land + 0.08, _land + 0.42);
            final name = _seg(0.56, 0.86);
            final glow = _seg(_land - 0.05, _land + 0.25, Curves.easeOut);

            return SizedBox(
              width: 260,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Отсвет под монетой — точками, как у главной карточки.
                  Positioned(
                    top: 20,
                    child: Opacity(
                      opacity: glow,
                      child: const SizedBox(
                        width: 220,
                        height: 180,
                        child: CustomPaint(painter: _HaloPainter()),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    child: Transform.translate(
                      offset: Offset(0, dy),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.diagonal3Values(width, 1, 1),
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: CustomPaint(
                            painter: _CoinPainter(
                              shine: shine,
                              // Ребром монета — тёмная: свет падает на лицо.
                              edge: width < 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (sparks > 0 && sparks < 1)
                    Positioned(
                      top: 20,
                      child: SizedBox(
                        width: 220,
                        height: 180,
                        child: CustomPaint(painter: _SparksPainter(sparks)),
                      ),
                    ),
                  Positioned(
                    top: 206,
                    child: _Wordmark(progress: name),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Пиксельное вращение: ширина монеты — одна из четырёх ступеней.
  static double _step(double v) {
    if (v > 0.82) return 1;
    if (v > 0.5) return 0.66;
    if (v > 0.2) return 0.36;
    return 0.12;
  }
}

/// Название: буквы выходят по одной, ноль — золотой.
class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.progress});

  final double progress;

  static const _letters = 'm0ney';

  @override
  Widget build(BuildContext context) {
    final shown = (progress * (_letters.length + 1)).floor();
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < _letters.length; i++)
              Opacity(
                opacity: i < shown ? 1 : 0,
                child: Text(
                  _letters[i],
                  style: TextStyle(
                    fontFamily: kPixelFamily,
                    fontSize: 22,
                    height: 1.2,
                    color: _letters[i] == '0' ? _gold : _text,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Opacity(
          opacity: shown > _letters.length ? 1 : 0,
          child: const Text(
            'TEXFI',
            style: TextStyle(
              fontFamily: kPixelFamily,
              fontSize: 8,
              letterSpacing: 4,
              color: _textDim,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}

/// Монета из [kBrandMark] со светом сверху: верхняя кромка — блик,
/// нижняя — глубокая тень, лицо с тенью по нижнему краю. [shine] —
/// диагональная полоса блика, пробегающая по монете после приземления.
class _CoinPainter extends CustomPainter {
  const _CoinPainter({required this.shine, required this.edge});

  final double shine;
  final bool edge;

  bool _filled(int x, int y) =>
      x >= 0 &&
      y >= 0 &&
      x < kBrandMarkGrid &&
      y < kBrandMarkGrid &&
      kBrandMark[y][x] != '.';

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.shortestSide / kBrandMarkGrid;
    final paint = Paint();
    // Полоса блика идёт по диагонали x + y от левого верхнего угла к
    // правому нижнему; ширина полосы — три диагонали.
    final band = -4 + shine * (kBrandMarkGrid * 2 + 8);

    for (var y = 0; y < kBrandMarkGrid; y++) {
      for (var x = 0; x < kBrandMarkGrid; x++) {
        final code = kBrandMark[y][x];
        if (code == '.') continue;
        final face = code == 'W';
        final top = !_filled(x, y - 1);
        final bottom = !_filled(x, y + 1);

        Color color;
        if (edge) {
          color = face ? _faceShade : _accentDeep;
        } else if (face) {
          color = y + 1 < kBrandMarkGrid && kBrandMark[y + 1][x] != 'W' ? _faceShade : _face;
        } else if (top) {
          color = _accentLight;
        } else if (bottom) {
          color = _accentDeep;
        } else {
          color = _accent;
        }

        final d = (x + y) - band;
        if (shine > 0 && shine < 1 && d.abs() < 1.6) {
          color = Color.lerp(color, Colors.white, 0.75)!;
        }

        paint.color = color;
        canvas.drawRect(
          Rect.fromLTWH(x * cell, y * cell, cell + 0.5, cell + 0.5),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_CoinPainter oldDelegate) =>
      oldDelegate.shine != shine || oldDelegate.edge != edge;
}

/// Отсвет под монетой: круг, набранный редкими точками по матрице
/// Байера, — плотнее в центре, реже к краю.
class _HaloPainter extends CustomPainter {
  const _HaloPainter();

  static const List<int> _bayer = [
    0, 8, 2, 10, //
    12, 4, 14, 6,
    3, 11, 1, 9,
    15, 7, 13, 5,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const cell = 4.0;
    final cols = (size.width / cell).floor();
    final rows = (size.height / cell).floor();
    final center = Offset(cols / 2, rows / 2);
    final radius = rows / 2;
    final path = Path();
    for (var y = 0; y < rows; y++) {
      for (var x = 0; x < cols; x++) {
        final d = (Offset(x.toDouble(), y.toDouble()) - center).distance / radius;
        final density = (1 - d) * 0.7;
        final threshold = (_bayer[(y % 4) * 4 + x % 4] + 0.5) / 16;
        if (density > threshold) {
          path.addRect(Rect.fromLTWH(x * cell, y * cell, cell, cell));
        }
      }
    }
    canvas.drawPath(path, Paint()..color = _accent.withValues(alpha: 0.22));
  }

  @override
  bool shouldRepaint(_HaloPainter oldDelegate) => false;
}

/// Четыре пиксельные искры вокруг монеты: крестик, который вспыхивает
/// и гаснет, каждая со своим сдвигом во времени.
class _SparksPainter extends CustomPainter {
  const _SparksPainter(this.progress);

  final double progress;

  static const _spots = [
    (0.18, 0.2, 0.0),
    (0.84, 0.28, 0.12),
    (0.2, 0.72, 0.24),
    (0.8, 0.7, 0.36),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const px = 4.0;
    for (final (fx, fy, delay) in _spots) {
      final local = ((progress - delay) / 0.5).clamp(0.0, 1.0);
      if (local <= 0 || local >= 1) continue;
      // Вспыхнула — выросла до полного креста — сжалась в точку.
      final arm = (math.sin(local * math.pi) * 3).round();
      final c = Offset(size.width * fx, size.height * fy);
      final paint = Paint()..color = _gold;
      canvas.drawRect(Rect.fromCenter(center: c, width: px, height: px), Paint()..color = _goldLight);
      for (var i = 1; i <= arm; i++) {
        for (final dir in const [Offset(1, 0), Offset(-1, 0), Offset(0, 1), Offset(0, -1)]) {
          canvas.drawRect(
            Rect.fromCenter(center: c + dir * (px * i), width: px, height: px),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_SparksPainter oldDelegate) => oldDelegate.progress != progress;
}
