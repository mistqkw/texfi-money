import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import 'hair_icon.dart';

/// Круглая кнопка основного действия: заливка основным цветом, тонкая
/// иконка, без тени. На нажатие чуть уменьшается.
class HairFab extends StatefulWidget {
  const HairFab({
    super.key,
    required this.onPressed,
    this.icon = HairIcons.add,
    this.heroTag,
    this.tooltip,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Object? heroTag;
  final String? tooltip;

  @override
  State<HairFab> createState() => _HairFabState();
}

class _HairFabState extends State<HairFab> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Widget button = Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.textPrimary,
        shape: BoxShape.circle,
      ),
      child: HairIcon(widget.icon, size: 24, color: colors.background),
    );

    button = GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        child: button,
      ),
    );

    if (widget.heroTag != null)
      button = Hero(tag: widget.heroTag!, child: button);
    if (widget.tooltip != null)
      button = Tooltip(message: widget.tooltip!, child: button);
    return button;
  }
}
