
import 'package:flutter/material.dart';

import '../../core/theme/app_typography.dart';
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
/// Теперь это пиксельная сборка: монета набирается из собственных ячеек
/// волной по диагонали, каждая появляется мгновенно, без плавного
/// проявления. Порядок задан целочисленным хешем, тем же, что у перехода
/// между экранами: узор обязан быть одинаковым на каждом запуске, иначе
/// сборка читается как сбой отрисовки.
///
/// Раньше собиралась абстрактная сетка 8×8, а под ней проявлялся знак из
/// трёх столбиков — логотип ранних сборок. Иконку приложения с тех пор
/// перерисовали в монету, и первое, что видел пользователь при запуске,
/// не совпадало с тем, по чему он только что ткнул на домашнем экране.
/// Теперь собирается ровно та же монета, ячейка в ячейку.
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
      duration: const Duration(milliseconds: 1200),
    );
    _assemble = CurvedAnimation(
      parent: _controller,
      // Сборка занимает почти весь кадр, а не первую его треть: при
      // коротком интервале волна проскакивала за пару кадров, знак
      // появлялся раньше, чем её успевали прочитать, и «пиксельная
      // сборка» превращалась в обычное проявление.
      curve: const Interval(0, 0.78, curve: Curves.linear),
    );
    _name = CurvedAnimation(
      parent: _controller,
      // Название начинает проступать, пока знак ещё дособирается: раньше
      // между готовой монетой и появлением надписи висела треть заставки,
      // на которой не происходило ничего.
      curve: const Interval(0.62, 0.92, curve: Curves.easeOut),
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
                  width: 112,
                  height: 112,
                  child: CustomPaint(
                    painter: _AssemblePainter(progress: _assemble.value),
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

/// Название фирменным пиксельным шрифтом. Шрифт вшит в сборку: на экране
/// запуска сеть заведомо не успела бы ничего скачать, и заставка показывала
/// бы название системной гарнитурой — то есть чужой.
const TextStyle _nameStyle = TextStyle(
  fontFamily: kPixelFamily,
  color: Colors.white,
  fontSize: 13,
  height: 1.4,
  letterSpacing: 0.5,
);

/// Монета, набирающаяся из собственных ячеек волной по диагонали.
///
/// Это не отдельная анимация поверх знака, а сам знак в процессе
/// появления: painter рисует те же ячейки [kBrandMark], просто ещё не
/// все. Когда сборка доходит до единицы, на экране остаётся ровно то же,
/// что рисует [BrandMarkPainter] — иконка приложения.
class _AssemblePainter extends CustomPainter {
  const _AssemblePainter({required this.progress});

  /// 0..1 — доля собранных ячеек.
  final double progress;

  /// Сколько сборка держит ячейку подсвеченной, прежде чем та примет свой
  /// настоящий цвет. Вспышка нужна белым ячейкам знака валюты: без неё
  /// они просто возникают белыми и выпадают из общей волны.
  static const double _flash = 0.08;

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
    final cell = size.shortestSide / kBrandMarkGrid;
    final paint = Paint();

    for (var y = 0; y < kBrandMarkGrid; y++) {
      final row = kBrandMark[y];
      for (var x = 0; x < kBrandMarkGrid; x++) {
        final code = row[x];
        if (code == '.') continue;

        // Волна идёт по диагонали, хеш только слегка сбивает её ровность —
        // иначе видно марширующую линию, а не сборку. Порог укладывается
        // в 0..0.85, чтобы последняя ячейка успела встать на место и
        // отгореть до конца анимации, а не осталась висеть вспышкой на
        // самом заметном кадре.
        final (first, last) = kBrandMarkDiagonalRange;
        final wave = (x + y - first) / (last - first);
        final threshold = wave * 0.78 + _noise(x, y) * 0.12;
        if (progress < threshold) continue;

        final settled = ((progress - threshold) / _flash).clamp(0.0, 1.0);
        final target = code == 'W' ? Colors.white : _accent;
        paint.color = Color.lerp(_accentShadow, target, settled)!;

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
