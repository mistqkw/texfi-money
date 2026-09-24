import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_style_ext.dart';
import 'beta_icons.dart';
import 'collage_blob.dart';
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

    // В бета-стиле — круглый оттиск тушью без тени, как печать на
    // полях: единственное тёмное пятно на странице и так заметно.
    final beta = context.style.beta;
    final decoration = beta
        ? BoxDecoration(
            color: colors.textPrimary,
            borderRadius: const BorderRadius.all(Radius.circular(size / 2)),
          )
        : null;

    // Коллаж: кнопка — синее вырезанное пятно с чёрным плюсом. Нажатие
    // не утапливает её, а переминает: пятно меняет форму и отпускает.
    final Widget? collageButton = context.style.isCollage
        ? TweenAnimationBuilder<double>(
            tween: Tween(end: _pressed ? 1 : 0),
            duration: AppMotion.pop,
            curve: AppMotion.snap,
            builder: (context, t, _) => SizedBox(
              width: size + 8,
              height: size + 8,
              child: BlobShape(
                seed: 23,
                morphTo: 29,
                t: t.clamp(0.0, 1.0),
                color: colors.accent,
                child: Center(
                  child: BetaIcon(
                    pattern: widget.pattern,
                    size: 26,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            ),
          )
        : null;

    Widget button = collageButton ?? Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: decoration ?? BoxDecoration(
        color: colors.accent,
        borderRadius: AppRadius.cardMediumAll,
        border: Border.all(color: colors.onAccent, width: 2),
        boxShadow: [
          BoxShadow(color: colors.textPrimary.withValues(alpha: 0.45), offset: const Offset(shadowOffset, shadowOffset)),
        ],
      ),
      child: PixelIcon(
        widget.pattern,
        size: beta ? 24 : 22,
        color: beta ? colors.background : colors.onAccent,
      ),
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
