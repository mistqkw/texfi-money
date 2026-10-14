import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';

/// Карточка приложения (дизайн «hairline»): поверхность, рамка 1px, радиус
/// 10, без тени. На нажатие рамка плавно темнеет — меняется цвет, а не
/// размер.
///
/// [label] — мелкая подпись над содержимым («лейбл сверху → значение»).
class HairCard extends StatefulWidget {
  const HairCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.card,
    this.onTap,
    this.onLongPress,
    this.accent = false,
    this.borderColor,
    this.background,
    this.label,
    this.labelColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  /// Долгое нажатие — для второстепенного действия.
  final VoidCallback? onLongPress;

  /// Выделенная карточка — рамка акцентом.
  final bool accent;

  final Color? borderColor;
  final Color? background;
  final String? label;
  final Color? labelColor;

  @override
  State<HairCard> createState() => _HairCardState();
}

class _HairCardState extends State<HairCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final interactive = widget.onTap != null || widget.onLongPress != null;

    var border =
        widget.borderColor ??
        (widget.accent ? colors.accent.withValues(alpha: 0.6) : colors.divider);
    if (_pressed && interactive) border = colors.textTertiary;

    final label = widget.label;
    final body = label == null || label.isEmpty
        ? widget.child
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: widget.labelColor == null
                    ? context.text.mono
                    : context.text.mono.copyWith(color: widget.labelColor),
              ),
              AppSpacing.gapSm,
              widget.child,
            ],
          );

    final content = AnimatedContainer(
      duration: AppMotion.fast,
      curve: AppMotion.standard,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: _pressed && interactive
            ? colors.surfaceVariant
            : (widget.background ?? colors.surface),
        borderRadius: AppRadius.cardMediumAll,
        border: Border.all(color: border, width: AppRadius.hairline),
      ),
      // ListTile и прочие Material-виджеты рисуют фон на ближайшем
      // Material-предке; без прослойки они оказались бы под заливкой.
      child: Material(type: MaterialType.transparency, child: body),
    );

    if (!interactive) return content;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: content,
    );
  }
}

/// Заголовок раздела: слева мелкая подпись mono, справа тонкая линия на
/// всю оставшуюся ширину — как номер и линия у заголовков сайта.
class HairSectionHeader extends StatelessWidget {
  const HairSectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Flexible(
            flex: 0,
            child: Text(
              title.toUpperCase(),
              style: context.text.mono.copyWith(
                color: context.colors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppSpacing.gapHMd,
          Expanded(
            child: Container(
              height: AppRadius.hairline,
              color: context.colors.divider,
            ),
          ),
          if (trailing != null) ...[AppSpacing.gapHMd, trailing!],
        ],
      ),
    );
  }
}
