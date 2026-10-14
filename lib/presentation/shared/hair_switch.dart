import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import 'hair_icon.dart';

/// Переключатель: капсула с плавающей ручкой. Включён — акцент.
class HairSwitch extends StatelessWidget {
  const HairSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const width = 44.0;
    const height = 26.0;
    const knob = 20.0;

    return Semantics(
      toggled: value,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: AppMotion.normal,
          curve: AppMotion.standard,
          width: width,
          height: height,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: value ? colors.accent : Colors.transparent,
            border: Border.all(color: value ? colors.accent : colors.border),
            borderRadius: BorderRadius.circular(height),
          ),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: AnimatedContainer(
            duration: AppMotion.normal,
            curve: AppMotion.standard,
            width: knob,
            height: knob,
            decoration: BoxDecoration(
              color: value ? Colors.white : colors.textTertiary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

/// Флажок: скруглённый квадрат, галочка проявляется плавно.
class HairCheckbox extends StatelessWidget {
  const HairCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.size = 20,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: AnimatedContainer(
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value ? colors.accent : Colors.transparent,
          border: Border.all(
            color: value ? colors.accent : colors.border,
            width: AppRadius.hairline,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: AnimatedOpacity(
          duration: AppMotion.fast,
          opacity: value ? 1 : 0,
          child: HairIcon(
            HairIcons.check,
            size: size * 0.8,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
