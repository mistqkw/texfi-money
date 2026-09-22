
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/haptics.dart';
import 'brand_glyph.dart';

const _brandName = 'texfi m0ney';
const _accent = Color(0xFF4A7DFB);
const _accentShadow = Color(0xFF2B4FB0);
const _bg = Color(0xFF0D0D10);

/// Первый кадр приложения: знак собирается из пикселей, под ним проявляется
/// название.
///
/// До этого здесь был терминал: строка «❯ texfi m0ney_» печаталась по
/// символу, а курсор мигал. Приём остался от самых ранних сборок, когда
/// весь интерфейс был терминальным, и пережил их — хотя ни в f0kus, ни в
/// files, ни на сайте ничего подобного нет. Кадр, который видят каждый
/// запуск, обещал одно приложение, а за ним открывалось другое.
///
/// Теперь это пиксельная сборка: ячейки знака зажигаются не все сразу, а
/// волной по диагонали, каждая — мгновенно, без плавного проявления.
/// Порядок задан целочисленным хешем, тем же, что у перехода между
/// экранами: узор обязан быть одинаковым на каждом запуске, иначе сборка
/// читается как сбой отрисовки.
class LaunchSplash extends StatefulWidget {
  const LaunchSplash({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<LaunchSplash> createState() => _LaunchSplashState();
}

class _LaunchSplashState extends State<LaunchSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _assemble;
  late final Animation<double> _name;

  int _lastBeat = 0;

  @override
  void initState() {
    super.initState();
    // Полторы секунды — потолок из фирменного стиля: заставка должна
    // успеть произойти, а не задержать.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _assemble = CurvedAnimation(
      parent: _controller,
      // Сборка занимает почти весь кадр, а не первую его треть: при
      // коротком интервале волна проскакивала за пару кадров, знак
      // появлялся раньше, чем её успевали прочитать, и «пиксельная
      // сборка» превращалась в обычное проявление.
      curve: const Interval(0, 0.82, curve: Curves.linear),
    );
    _name = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.78, 1, curve: Curves.easeOut),
    );

    // Короткий тик на каждой четверти сборки: знак не просто появляется,
    // его слышно. Шаг крупный — тик на каждую ячейку превратился бы в
    // вибрацию-жужжание.
    _controller.addListener(() {
      final beat = (_assemble.value * 4).floor();
      if (beat != _lastBeat && beat > 0 && beat <= 4) {
        _lastBeat = beat;
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

  @override
  Widget build(BuildContext context) {
    // Фон и цвета не зависят от выбранной темы: это фирменный момент, а не
    // тематизируемый экран.
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
                  width: 96,
                  height: 96,
                  child: CustomPaint(
                    painter: _AssemblePainter(progress: _assemble.value),
                    child: Opacity(
                      // Знак проступает на последней четверти сборки —
                      // ячейки складываются в него, а не подменяются им.
                      opacity: ((_assemble.value - 0.6) / 0.3).clamp(0.0, 1.0),
                      child: const Center(child: BrandGlyph(height: 56)),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Opacity(
                  opacity: _name.value,
                  child: Text(_brandName, style: _nameStyle),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Название фирменным пиксельным шрифтом. Раньше здесь стоял родовой
/// `fontFamily: 'monospace'` — системный моноширинный, который на каждом
/// устройстве свой и ни на одном не фирменный.
final TextStyle _nameStyle = GoogleFonts.pressStart2p(
  textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 13,
    height: 1.4,
    letterSpacing: 0.5,
  ),
);

/// Сетка ячеек, зажигающихся волной по диагонали.
class _AssemblePainter extends CustomPainter {
  const _AssemblePainter({required this.progress});

  /// 0..1 — доля собранных ячеек.
  final double progress;

  static const int _grid = 8;

  /// Тот же целочисленный хеш, что у перехода между экранами: узор должен
  /// быть одним и тем же на каждом запуске.
  double _noise(int x, int y) {
    var h = x * 73856093 ^ y * 19349663;
    h = (h ^ (h >> 13)) * 1274126177;
    h = h ^ (h >> 16);
    return (h & 0xFFFF) / 0xFFFF;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final cell = size.width / _grid;
    final paint = Paint();

    for (var y = 0; y < _grid; y++) {
      for (var x = 0; x < _grid; x++) {
        // Волна идёт по диагонали, хеш только слегка сбивает её ровность —
        // иначе видно марширующую линию, а не сборку.
        //
        // Порог укладывается в 0..0.65, а не в 0..1, и догорание занимает
        // ещё 0.25: последняя ячейка обязана погаснуть до конца анимации.
        // При пороге почти в единицу она начинала гаснуть ровно тогда,
        // когда всё заканчивалось, и оставалась висеть рядом со знаком
        // недогоревшим огрызком — на самом заметном кадре.
        final wave = (x + y) / (2 * (_grid - 1));
        final threshold = wave * 0.5 + _noise(x, y) * 0.15;
        if (progress < threshold) continue;

        // Ячейка гаснет до конца, а не до остаточной прозрачности.
        //
        // Сначала здесь стояло `1 - fade * 0.85`, и каждая отработавшая
        // ячейка навсегда оставалась видна на 15%. По отдельности это
        // незаметно, но все шестьдесят четыре вместе складывались в
        // тёмный квадрат за знаком — подложку, которой в кадре быть не
        // должно: сборка обязана исчезнуть, оставив только знак.
        final fade = ((progress - threshold) / 0.25).clamp(0.0, 1.0);
        if (fade >= 1) continue;
        paint.color = Color.lerp(_accent, _accentShadow, fade)!
            .withValues(alpha: 1 - fade);

        // Рисуем с нахлёстом, а не с зазором: на субпиксельном рендере
        // между ячейками иначе появляются щели и контур рассыпается.
        canvas.drawRect(
          Rect.fromLTWH(x * cell, y * cell, cell + 0.5, cell + 0.5),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_AssemblePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
