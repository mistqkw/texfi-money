import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/haptics.dart';
import 'brand_glyph.dart';

const _brandName = 'texfi m0ney';
const _accent = Color(0xFF4A7DFB);
const _accentShadow = Color(0xFF2B4FB0);

/// Пиксельный шрифт — тот же, что на заголовках экранов и на сайте.
/// Раньше здесь стоял родовой `fontFamily: 'monospace'`, то есть системный
/// моноширинный: на каждом устройстве свой и ни на одном не фирменный.
final TextStyle _nameStyle = GoogleFonts.pressStart2p(
  textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 13,
    height: 1.4,
  ),
);
final TextStyle _promptStyle = _nameStyle.copyWith(color: _accent);

/// Анимация запуска: логотип всплывает, затем построчно печатается
/// "❯ texfi m0ney_" — на каждом старте приложения, поверх нативного
/// сплэша. Чёрный фон и белый/акцентный текст не зависят от выбранной
/// темы — это фирменный момент, а не тематизируемый экран.
class LaunchSplash extends StatefulWidget {
  const LaunchSplash({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<LaunchSplash> createState() => _LaunchSplashState();
}

class _LaunchSplashState extends State<LaunchSplash> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _cursorController;
  late final CurvedAnimation _logoAnim;
  late final CurvedAnimation _typeAnim;
  int _lastCharCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _cursorController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..repeat(reverse: true);
    _logoAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.45, curve: Curves.easeOutBack),
    );
    _typeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.9, curve: Curves.easeIn),
    );

    // Тик на каждый новый напечатанный символ — сплэш ощущается как
    // настоящий терминал, а не просто анимация.
    _controller.addListener(() {
      final charCount = (_brandName.length * _typeAnim.value).clamp(0, _brandName.length).floor();
      if (charCount > _lastCharCount) {
        _lastCharCount = charCount;
        Haptics.select();
      }
    });

    _controller.forward().whenComplete(() {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) widget.onFinished();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoAnim = _logoAnim;
    final typeAnim = _typeAnim;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_controller, _cursorController]),
          builder: (context, _) {
            final charCount = (_brandName.length * typeAnim.value).clamp(0, _brandName.length).floor();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Знак стоит в пиксельной рамке со смещённой тенью, а не
                // в размытом синем ореоле. Ореол был единственным blur-ом
                // во всём приложении: в языке, где объём даёт только
                // сдвинутый на три пикселя прямоугольник, мягкое свечение
                // читается как чужая вставка — и именно на первом кадре,
                // который видят каждый запуск.
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(color: _accent, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: _accentShadow, offset: Offset(3, 3)),
                    ],
                  ),
                  child: FadeTransition(
                    opacity: logoAnim,
                    child: ScaleTransition(
                      scale: Tween(begin: 0.7, end: 1.0).animate(logoAnim),
                      child: const BrandGlyph(height: 56),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text.rich(
                  TextSpan(children: [
                    TextSpan(text: '❯ ', style: _promptStyle),
                    TextSpan(
                      text: _brandName.substring(0, charCount),
                      style: _nameStyle,
                    ),
                    // Курсор мигает шагами, а не затуханием: у курсора в
                    // терминале, с которого списан этот кадр, ровно два
                    // состояния. Плавная прозрачность превращала его в
                    // дышащее пятно — единственную мягкую анимацию здесь.
                    TextSpan(
                      text: '_',
                      style: _nameStyle.copyWith(
                        color: _cursorController.value < 0.5
                            ? Colors.transparent
                            : Colors.white,
                      ),
                    ),
                  ]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
