import 'package:flutter/material.dart';

import '../../core/utils/haptics.dart';
import 'brand_glyph.dart';

const _brandName = 'texfi m0ney';
const _accent = Color(0xFF4A7DFB);

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
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [_accent.withValues(alpha: 0.22), Colors.transparent],
                    ),
                  ),
                  child: FadeTransition(
                    opacity: logoAnim,
                    child: ScaleTransition(
                      scale: Tween(begin: 0.7, end: 1.0).animate(logoAnim),
                      child: const BrandGlyph(height: 56),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(children: [
                    const TextSpan(
                      text: '❯ ',
                      style: TextStyle(
                        color: _accent,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: _brandName.substring(0, charCount),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.4,
                      ),
                    ),
                    TextSpan(
                      text: '_',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: _cursorController.value),
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
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
