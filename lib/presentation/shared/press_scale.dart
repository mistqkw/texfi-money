import 'package:flutter/material.dart';

import '../../core/theme/app_motion.dart';

/// Лёгкое «сжатие» при нажатии поверх виджетов со своей встроенной
/// анимацией (FloatingActionButton и т.п.) — не перехватывает сам тап,
/// только отслеживает press-состояние через свой собственный распознаватель
/// в той же арене жестов.
class PressScale extends StatefulWidget {
  const PressScale({super.key, required this.child, this.scale = 0.92});

  final Widget child;
  final double scale;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1.0,
        duration: AppMotion.fast,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
