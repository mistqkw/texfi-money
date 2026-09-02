import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';

/// Квадратный пиксельный переключатель вместо стандартного Material
/// `Switch` — рамка без сглаживания, заливка блоком при включении, как
/// чекбоксы/радио в TexFi f0kus.
class PixelSwitch extends StatelessWidget {
  const PixelSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const width = 44.0;
    const height = 24.0;
    const knob = 16.0;
    const inset = 2.0;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: AppMotion.fast,
        width: width,
        height: height,
        padding: const EdgeInsets.all(inset),
        decoration: BoxDecoration(
          color: value ? colors.accent.withValues(alpha: 0.22) : colors.surfaceVariant,
          border: Border.all(color: value ? colors.accent : colors.divider, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: Curves.easeOut,
          width: knob,
          height: knob,
          decoration: BoxDecoration(
            color: value ? colors.accent : colors.textTertiary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

/// Квадратный чекбокс-метка: рамка + заливка блоком при выборе — используем
/// вместо `Icon(Icons.check)`-галочки там, где нужен явный чекбокс, а не
/// просто индикатор выбора в списке.
class PixelCheckbox extends StatelessWidget {
  const PixelCheckbox({super.key, required this.value, this.onChanged, this.size = 20});

  final bool value;
  final ValueChanged<bool>? onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: AnimatedContainer(
        duration: AppMotion.fast,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? colors.accent : Colors.transparent,
          border: Border.all(color: value ? colors.accent : colors.divider, width: 2),
          borderRadius: BorderRadius.circular(3),
        ),
        child: value
            ? Icon(Icons.check, size: size * 0.75, color: colors.onAccent)
            : null,
      ),
    );
  }
}
