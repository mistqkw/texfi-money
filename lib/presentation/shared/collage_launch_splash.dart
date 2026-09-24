import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_palettes.dart';
import '../../core/utils/haptics.dart';
import 'collage_blob.dart';
import 'collage_text.dart';

/// Заставка беты «коллаж»: картинка автора, собирающаяся на глазах.
///
/// Сначала одно за другим вырастают три синих пятна разной глубины,
/// сверху выезжает сине-серый прямоугольник, затем поверх ложится
/// название — каждое слово своим шрифтом, с коротким перебором
/// начертаний, как будто буквы подбирают, из какой газеты их вырезать.
/// Под ним — «TexFi StyLE», как на картинке.
///
/// Полторы секунды — потолок, как у остальных заставок.
class CollageLaunchSplash extends StatefulWidget {
  const CollageLaunchSplash({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<CollageLaunchSplash> createState() => _CollageLaunchSplashState();
}

class _CollageLaunchSplashState extends State<CollageLaunchSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _nameShown = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..addListener(() {
        // Название появляется, когда пятна уже легли, — и с этого
        // момента само перебирает шрифты (CollageText.shuffle).
        if (!_nameShown && _controller.value >= 0.4) {
          setState(() => _nameShown = true);
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

  double _seg(double begin, double end, [Curve curve = Curves.easeOutBack]) {
    final v = ((_controller.value - begin) / (end - begin)).clamp(0.0, 1.0);
    return curve.transform(v);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = MediaQuery.sizeOf(context);
    final w = size.width;
    final h = size.height;

    Widget blob(double begin, Rect rect, int seed, Color color) {
      final g = _seg(begin, begin + 0.3);
      return Positioned.fromRect(
        rect: rect,
        child: Transform.scale(
          scale: g,
          child: BlobShape(seed: seed, color: color),
        ),
      );
    }

    return ColoredBox(
      color: colors.background,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final rect = _seg(0.2, 0.45, Curves.easeOutCubic);
          return Stack(
            children: [
              // Пятна — ниже и правее названия: синие буквы названия
              // (T, F, ноль) обязаны стоять на белом, как на картинке, —
              // на синем пятне они пропадают.
              blob(0.0, Rect.fromLTWH(w * 0.36, h * 0.43, w * 0.62, h * 0.14), 3,
                  AppPalettes.collageBlue),
              blob(0.1, Rect.fromLTWH(w * 0.2, h * 0.5, w * 0.62, h * 0.2), 7,
                  AppPalettes.collageBlueMid),
              blob(0.18, Rect.fromLTWH(w * 0.02, h * 0.62, w * 0.42, h * 0.16), 11,
                  AppPalettes.collageBlueDeep),
              Positioned(
                left: w * 0.08,
                top: h * 0.28,
                width: w * 0.12,
                height: h * 0.3 * rect,
                child: ColoredBox(
                  color: AppPalettes.collageSlate.withValues(alpha: 0.9),
                ),
              ),
              if (_nameShown)
                Positioned(
                  left: w * 0.1,
                  right: w * 0.06,
                  top: h * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CollageText(
                        'm0ney',
                        shuffle: true,
                        style: TextStyle(
                          fontSize: 56,
                          color: colors.textPrimary,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.only(left: w * 0.22),
                        child: CollageText(
                          'TexFi StyLE',
                          shuffle: true,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 30,
                            color: colors.textPrimary,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
