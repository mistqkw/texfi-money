import 'package:flutter/material.dart';

import '../../core/theme/app_typography.dart';
import '../../core/utils/haptics.dart';

const _brandName = 'texfi m0ney';
const _accent = Color(0xFF4A7DFB);
const _bg = Color(0xFF0A0A0C);
const _fg = Color(0xFFF4F4F6);

/// Первый кадр приложения: знак TexFi (три полосы, синий квадрат) плавно
/// выезжает полосами, под ним проявляется название. Цвета не зависят от
/// выбранной темы: это фирменный момент, а не тематизируемый экран.
class LaunchSplash extends StatefulWidget {
  const LaunchSplash({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<LaunchSplash> createState() => _LaunchSplashState();
}

class _LaunchSplashState extends State<LaunchSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    Haptics.select();
    _controller.forward().whenComplete(() {
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _step(double from, double to, {Curve curve = Curves.easeOutCubic}) =>
      curve.transform(
        ((_controller.value - from) / (to - from)).clamp(0.0, 1.0),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 84,
                  height: 48,
                  child: CustomPaint(
                    painter: _MarkPainter(
                      a: _step(0.0, 0.45),
                      b: _step(0.12, 0.57),
                      c: _step(0.28, 0.65),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Opacity(
                  opacity: _step(0.55, 0.9),
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - _step(0.55, 0.9))),
                    child: const Text(
                      _brandName,
                      style: TextStyle(
                        fontFamily: kDisplayFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                        color: _fg,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  _MarkPainter({required this.a, required this.b, required this.c});

  final double a;
  final double b;
  final double c;

  @override
  void paint(Canvas canvas, Size size) {
    const r = Radius.circular(2);
    final white = Paint()..color = _fg;
    // Верхняя полоса растёт слева направо.
    if (a > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, 84 * a, 12), r),
        white,
      );
    }
    // Нижняя — справа налево.
    if (b > 0) {
      final w = 66 * b;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(84 - w, 18, w, 12), r),
        white,
      );
    }
    // Синий квадрат проявляется.
    if (c > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(72, 36, 12, 12), r),
        Paint()..color = _accent.withValues(alpha: c),
      );
    }
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.a != a || old.b != b || old.c != c;
}
