import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import 'pixel_icon.dart';

/// Плавающая кнопка добавления в пиксель-стиле экосистемы TexFi: квадрат
/// вместо круглого Material FAB, 2px рамка и сплошная офсетная тень —
/// заменяет `FloatingActionButton` во всех местах с действием «добавить».
class PixelFab extends StatefulWidget {
  const PixelFab({
    super.key,
    required this.onPressed,
    this.pattern = PixelIcons.add,
    this.heroTag,
    this.tooltip,
  });

  final VoidCallback onPressed;
  final List<String> pattern;
  final Object? heroTag;
  final String? tooltip;

  @override
  State<PixelFab> createState() => _PixelFabState();
}

class _PixelFabState extends State<PixelFab> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const size = 56.0;
    const shadowOffset = 4.0;

    Widget button = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.accent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.onAccent, width: 2),
        boxShadow: [
          BoxShadow(color: colors.textPrimary.withValues(alpha: 0.45), offset: const Offset(shadowOffset, shadowOffset)),
        ],
      ),
      child: PixelIcon(widget.pattern, size: 22, color: colors.onAccent),
    );

    button = GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: AppMotion.fast,
        curve: Curves.easeOut,
        child: button,
      ),
    );

    if (widget.heroTag != null) {
      button = Hero(tag: widget.heroTag!, child: button);
    }
    if (widget.tooltip != null) {
      button = Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }
}
