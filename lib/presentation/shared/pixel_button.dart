import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/utils/haptics.dart';
import 'pixel_spinner.dart';

/// Кнопка экосистемы TexFi: 2px рамка, сплошная офсетная тень без blur и —
/// главное — отклик на нажатие, при котором кнопка визуально вдавливается.
///
/// Раньше основное действие во всех формах было обычным [ElevatedButton]
/// с белой рамкой: корректно, но неподвижно. В пиксельном языке объём даёт
/// только смещённая тень, и если она не уезжает под палец, кнопка читается
/// как нарисованная картинка, а не как элемент, который можно нажать.
/// Механика простая: на нажатии кнопка сдвигается на [_shadowOffset]
/// вниз-вправо, а тень на столько же схлопывается — суммарная геометрия
/// не меняется, соседние элементы не дёргаются.
class PixelButton extends StatefulWidget {
  const PixelButton({
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

  /// `null` выключает кнопку — она гаснет и перестаёт принимать нажатия.
  final VoidCallback? onPressed;

  final IconData? icon;

  /// Залитая акцентом (основное действие) или обведённая (второстепенное).
  final bool filled;

  /// Растянуть на всю ширину родителя.
  final bool expand;

  /// Разрушающее действие — красная заливка вместо акцентной.
  final bool danger;

  /// Действие выполняется: вместо подписи — пиксельное ожидание. Нажатия
  /// при этом не принимаются, чтобы форма не ушла в сохранение дважды.
  final bool busy;

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  static const double _shadowOffset = 3;

  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.busy;

  void _setPressed(bool value) {
    if (!_enabled || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;

    final base = widget.danger ? colors.expense : colors.accent;
    final shadow = widget.danger ? colors.expense : colors.accentShadow;

    final Color background;
    final Color foreground;
    final Color border;
    final Color shadowColor;

    if (!_enabled) {
      background = colors.surfaceVariant;
      foreground = colors.textTertiary;
      border = colors.divider;
      shadowColor = Colors.transparent;
    } else if (widget.filled) {
      background = base;
      foreground = colors.onAccent;
      border = shadow;
      shadowColor = shadow;
    } else {
      background = colors.surface;
      foreground = base;
      border = base;
      shadowColor = colors.divider;
    }

    // Тень и сдвиг меняются встречно: то, что кнопка «съедает» смещением,
    // она отдаёт схлопнувшейся тенью.
    final offset = _pressed ? _shadowOffset : 0.0;
    final shadowSize = _pressed ? 0.0 : _shadowOffset;

    if (widget.busy) {
      // Высоту держит невидимая подпись: без неё кнопка на время
      // сохранения схлопывается до размера индикатора, и форма прыгает.
      return _shell(
        background: background,
        foreground: foreground,
        border: border,
        shadowColor: shadowColor,
        offset: offset,
        shadowSize: shadowSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0,
              child: Text(widget.label, style: text.titleMedium),
            ),
            PixelSpinner(size: 5),
          ],
        ),
      );
    }

    final child = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 18, color: foreground),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: text.titleMedium?.copyWith(color: foreground),
          ),
        ),
      ],
    );

    return _shell(
      background: background,
      foreground: foreground,
      border: border,
      shadowColor: shadowColor,
      offset: offset,
      shadowSize: shadowSize,
      child: child,
    );
  }

  Widget _shell({
    required Color background,
    required Color foreground,
    required Color border,
    required Color shadowColor,
    required double offset,
    required double shadowSize,
    required Widget child,
  }) {
    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      child: GestureDetector(
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
          duration: AppMotion.instant,
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(offset, offset, 0),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: background,
            borderRadius: AppRadius.cardSmallAll,
            border: Border.all(color: border, width: 2),
            boxShadow: [
              BoxShadow(color: shadowColor, offset: Offset(shadowSize, shadowSize)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
