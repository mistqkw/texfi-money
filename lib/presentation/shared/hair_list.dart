import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import 'hair_icon.dart';

/// Группа строк в общей рамке 1px: строки разделены тонкими линиями.
/// Так устроены настройки и любые списки действий.
class HairGroup extends StatelessWidget {
  const HairGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.cardMediumAll,
        border: Border.all(color: colors.divider, width: AppRadius.hairline),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Container(height: AppRadius.hairline, color: colors.divider),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Строка списка: иконка, название, пояснение и справа — значение, галочка,
/// стрелка или любой виджет. На нажатие подсвечивается плавно.
class HairRow extends StatefulWidget {
  const HairRow({
    super.key,
    required this.label,
    this.icon,
    this.subtitle,
    this.value,
    this.trailing,
    this.selected = false,
    this.chevron = false,
    this.color,
    this.labelStyle,
    this.enabled = true,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final String? subtitle;

  /// Текущее значение справа (серым).
  final String? value;

  /// Свой виджет справа; перекрывает галочку и стрелку.
  final Widget? trailing;

  /// Выбранный вариант — справа акцентная галочка.
  final bool selected;

  /// Строка ведёт на другой экран — справа стрелка.
  final bool chevron;

  final Color? color;
  final TextStyle? labelStyle;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  State<HairRow> createState() => _HairRowState();
}

class _HairRowState extends State<HairRow> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value || widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = widget.enabled
        ? (widget.color ?? colors.textPrimary)
        : colors.textTertiary;

    final Widget? right =
        widget.trailing ??
        (widget.selected
            ? HairIcon(HairIcons.check, size: 18, color: colors.accent)
            : widget.chevron
            ? HairIcon(
                HairIcons.chevronRight,
                size: 18,
                color: colors.textTertiary,
              )
            : null);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.enabled ? widget.onTap : null,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        color: _pressed ? colors.surfaceVariant : Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: 14,
        ),
        child: Row(
          children: [
            if (widget.icon != null) ...[
              HairIcon(
                widget.icon!,
                size: 20,
                color: widget.color ?? colors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: (widget.labelStyle ?? context.text.title).copyWith(
                      color: fg,
                    ),
                  ),
                  if (widget.subtitle case final subtitle?) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: context.text.caption),
                  ],
                ],
              ),
            ),
            if (widget.value != null) ...[
              const SizedBox(width: AppSpacing.md),
              Flexible(
                child: Text(
                  widget.value!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.body,
                ),
              ),
            ],
            if (right != null) ...[const SizedBox(width: AppSpacing.md), right],
          ],
        ),
      ),
    );
  }
}
