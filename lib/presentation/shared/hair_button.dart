import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/haptics.dart';
import 'hair_icon.dart';
import 'hair_spinner.dart';

/// Кнопка приложения (дизайн «hairline»): основная — заливка основным
/// цветом текста с контрастной подписью, второстепенная — прозрачная с
/// рамкой 1px. Подпись — JetBrains Mono 11px, капслок, разрядка. Нажатие:
/// сдвиг на 1px вниз и лёгкое притухание, без теней.
class HairButton extends StatefulWidget {
  const HairButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.filled = true,
    this.expand = true,
    this.danger = false,
    this.busy = false,
  });

  /// Подпись. Короткая: это кнопка действия, а не абзац.
  final String label;

  /// `null` выключает кнопку.
  final VoidCallback? onPressed;

  /// Линейная иконка слева от подписи.
  final IconData? icon;

  /// Основное действие (заливка) или второстепенное (рамка).
  final bool filled;

  /// Растянуть на всю ширину родителя.
  final bool expand;

  /// Разрушающее действие — красная заливка.
  final bool danger;

  /// Действие выполняется: вместо подписи — индикатор, нажатия не
  /// принимаются.
  final bool busy;

  @override
  State<HairButton> createState() => _HairButtonState();
}

class _HairButtonState extends State<HairButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.busy;

  void _setPressed(bool value) {
    if (!_enabled || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final Color background;
    final Color foreground;
    final Color border;

    if (!_enabled && !widget.busy) {
      background = widget.filled ? colors.surfaceVariant : Colors.transparent;
      foreground = colors.textTertiary;
      border = colors.divider;
    } else if (widget.filled) {
      background = widget.danger ? colors.expense : colors.textPrimary;
      foreground = widget.danger ? Colors.white : colors.background;
      border = background;
    } else {
      background = Colors.transparent;
      foreground = widget.danger ? colors.expense : colors.textPrimary;
      border = _pressed
          ? foreground
          : (widget.danger
                ? colors.expense.withValues(alpha: 0.5)
                : colors.border);
    }

    final labelStyle = TextStyle(
      fontFamily: kMonoFamily,
      fontSize: 11.5,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.2,
      height: 1.3,
      color: foreground,
    );

    final label = Text(
      widget.label.toUpperCase(),
      textAlign: TextAlign.center,
      // Две строки, а не одна: длинная подпись на пустом состоянии не
      // должна обрезаться до непонятного огрызка.
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: labelStyle,
    );

    final Widget child = widget.busy
        ? Stack(
            alignment: Alignment.center,
            children: [
              // Высоту держит невидимая подпись: форма не прыгает.
              Opacity(opacity: 0, child: label),
              HairSpinner(size: 16, color: foreground),
            ],
          )
        : Row(
            mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                HairIcon(widget.icon!, size: 16, color: foreground),
                const SizedBox(width: 8),
              ],
              Flexible(child: label),
            ],
          );

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        onTap: _enabled
            ? () {
                Haptics.select();
                widget.onPressed!.call();
              }
            : null,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.standard,
          transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
          decoration: BoxDecoration(
            color: _pressed && widget.filled
                ? background.withValues(alpha: 0.88)
                : background,
            borderRadius: AppRadius.controlSmallAll,
            border: Border.all(color: border, width: AppRadius.hairline),
          ),
          child: child,
        ),
      ),
    );
  }
}
