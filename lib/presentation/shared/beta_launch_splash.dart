import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_palettes.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/beta_options.dart';
import '../../core/utils/haptics.dart';
import 'beta_glyph.dart';

/// Заставка бета-стиля: вместо пиксельной сборки монеты — знак «$»,
/// который проступает снизу вверх, как чернила, поднимающиеся по бумаге,
/// затем наливается заливкой, и под ним по линейке выходит название.
///
/// Пиксельная сборка на бете выглядела бы входом в другое приложение:
/// первое, что видно при запуске, обязано быть тем же стилем, что и всё
/// остальное. Длительность та же, что у основной заставки, — полторы
/// секунды потолок, заставка должна произойти, а не задержать.
///
/// Цвета — из темы беты: на тёмном листе знак эталонный, как на
/// аватарке; на светлом заливка остаётся бежевой, а обводка набрана
/// чернилами, иначе светлый контур на светлом листе пропадает.
class BetaLaunchSplash extends StatefulWidget {
  const BetaLaunchSplash({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<BetaLaunchSplash> createState() => _BetaLaunchSplashState();
}

class _BetaLaunchSplashState extends State<BetaLaunchSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rise;
  late final Animation<double> _fill;
  late final Animation<double> _rule;
  late final Animation<double> _name;
  bool _ticked = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _rise = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.5, curve: Curves.easeInOutCubic),
    );
    _fill = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
    );
    _rule = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.75, curve: Curves.easeOutCubic),
    );
    _name = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 0.88, curve: Curves.easeOut),
    );

    // Один тик — в момент, когда контур дописан: знак «встал». Ритм
    // основной заставки (тик на каждую четверть сборки) здесь не к месту:
    // нечему щёлкать, чернила текут непрерывно.
    _controller.addListener(() {
      if (!_ticked && _rise.value >= 1) {
        _ticked = true;
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
    final colors = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final glyphSize = MediaQuery.sizeOf(context).shortestSide * 0.62;

    return ColoredBox(
      color: colors.background,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Проступание снизу вверх — маской с мягким краем, а не
                // ростом: знак не вырастает, он уже есть на бумаге и
                // становится видимым.
                ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (rect) {
                    final edge = 1 - _rise.value * 1.15;
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: const [
                        Color(0x00000000),
                        Color(0xFF000000),
                      ],
                      stops: [
                        edge.clamp(0.0, 1.0),
                        (edge + 0.15).clamp(0.0, 1.0),
                      ],
                    ).createShader(rect);
                  },
                  child: BetaGlyph(
                    glyph: context.betaOptions.glyph.animationGlyph,
                    size: glyphSize,
                    fillOpacity: BetaGlyph.fillAlpha * _fill.value,
                    strokeColor:
                        dark ? AppPalettes.betaStroke : colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 18),
                // Линейка растёт из центра, название выходит над ней.
                Container(
                  width: 120 * _rule.value,
                  height: 1,
                  color: colors.textPrimary.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 14),
                Opacity(
                  opacity: _name.value,
                  child: Transform.translate(
                    offset: Offset(0, 6 * (1 - _name.value)),
                    child: Text(
                      'm0ney',
                      textScaler: TextScaler.noScaling,
                      style: TextStyle(
                        fontFamily: kSerifFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        height: 1,
                        letterSpacing: -0.3,
                        color: colors.textPrimary,
                        // Ноль — цифрой, а не старостильной «о».
                        fontFeatures: const [FontFeature.liningFigures()],
                        decoration: TextDecoration.none,
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
