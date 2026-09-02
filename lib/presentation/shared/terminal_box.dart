import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text_styles_ext.dart';

/// Пиксель-карточка экосистемы TexFi (PixelCard, как в TexFi f0kus): почти
/// прямые углы, плотная 2px рамка и сплошная офсетная тень без blur —
/// поверх сохранён терминальный приём m0ney с меткой, врезанной прямо
/// в линию рамки. Метка рисуется поверх разрыва в обводке, который
/// вычисляется по размеру её текста.
class TerminalBox extends StatefulWidget {
  const TerminalBox({
    super.key,
    required this.child,
    this.label,
    this.prompt = true,
    this.labelColor,
    this.borderColor,
    this.fillColor,
    this.padding = const EdgeInsets.fromLTRB(14, 16, 14, 14),
    this.radius = 8,
    this.borderWidth = 2,
    this.shadowOffset = 3,
    this.onTap,
  });

  final Widget child;
  final String? label;
  final bool prompt;
  final Color? labelColor;
  final Color? borderColor;
  final Color? fillColor;
  final EdgeInsets padding;
  final double radius;
  final double borderWidth;
  final double shadowOffset;
  final VoidCallback? onTap;

  @override
  State<TerminalBox> createState() => _TerminalBoxState();
}

class _TerminalBoxState extends State<TerminalBox> {
  static const double _labelLeft = 12;
  static const double _labelPadH = 6;

  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    final prompt = widget.prompt;
    final labelColor = widget.labelColor;
    final borderColor = widget.borderColor;
    final fillColor = widget.fillColor;
    final padding = widget.padding;
    final radius = widget.radius;
    final borderWidth = widget.borderWidth;
    final shadowOffset = widget.shadowOffset;
    final onTap = widget.onTap;
    final child = widget.child;
    final resolvedBorder = borderColor ?? context.colors.textPrimary.withValues(alpha: 0.28);
    final resolvedFill = fillColor ?? context.colors.surface;
    final hardShadow = [
      BoxShadow(color: resolvedBorder, offset: Offset(shadowOffset, shadowOffset)),
    ];

    Widget content;

    if (label == null || label.isEmpty) {
      content = Container(
        decoration: BoxDecoration(
          color: resolvedFill,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: resolvedBorder, width: borderWidth),
          boxShadow: hardShadow,
        ),
        padding: padding,
        child: child,
      );
    } else {
      final resolvedLabelColor = labelColor ?? context.colors.accent;
      final promptStyle = context.text.mono.copyWith(color: resolvedLabelColor, fontWeight: FontWeight.w600);
      final labelStyle = context.text.mono.copyWith(
        color: resolvedLabelColor.withValues(alpha: 0.75),
        fontWeight: FontWeight.w600,
      );

      final span = TextSpan(children: [
        if (prompt) TextSpan(text: '❯ ', style: promptStyle),
        TextSpan(text: label, style: labelStyle),
      ]);

      final painter = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textScaler: MediaQuery.textScalerOf(context),
      )..layout();
      final labelH = painter.height;
      final gap = Rect.fromLTWH(
        _labelLeft - _labelPadH,
        -labelH / 2,
        painter.width + _labelPadH * 2,
        labelH,
      );

      content = Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(top: labelH / 2),
            child: CustomPaint(
              foregroundPainter: _TerminalBorderPainter(
                color: resolvedBorder,
                radius: radius,
                gap: gap,
                strokeWidth: borderWidth,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: resolvedFill,
                  borderRadius: BorderRadius.circular(radius),
                  boxShadow: hardShadow,
                ),
                padding: padding,
                child: child,
              ),
            ),
          ),
          Positioned(
            left: _labelLeft - _labelPadH,
            top: 0,
            child: ColoredBox(
              color: resolvedFill,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: _labelPadH),
                child: Text.rich(span),
              ),
            ),
          ),
        ],
      );
    }

    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      borderRadius: BorderRadius.circular(radius),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: AppMotion.fast,
        curve: Curves.easeOut,
        child: content,
      ),
    );
  }
}

class _TerminalBorderPainter extends CustomPainter {
  _TerminalBorderPainter({
    required this.color,
    required this.radius,
    required this.gap,
    required this.strokeWidth,
  });

  final Color color;
  final double radius;
  final Rect gap;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(strokeWidth / 2),
      Radius.circular(radius),
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.save();
    canvas.clipRect(gap, clipOp: ui.ClipOp.difference);
    canvas.drawRRect(rrect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TerminalBorderPainter oldDelegate) {
    return color != oldDelegate.color ||
        radius != oldDelegate.radius ||
        gap != oldDelegate.gap ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
