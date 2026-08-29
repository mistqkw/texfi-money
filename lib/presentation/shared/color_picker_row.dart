import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/haptics.dart';

/// Палитра выбора цвета — одна на все формы (категория, счёт, цель,
/// профиль), где раньше лежали четыре одинаковые копии.
///
/// Кружок видимый 36px, но зона нажатия доведена до 48px: это минимум,
/// ниже которого в мелкие цели стабильно не попадают пальцем.
class ColorPickerRow extends StatelessWidget {
  const ColorPickerRow({
    super.key,
    required this.selected,
    required this.onSelected,
    this.palette = AppColors.categoryPalette,
  });

  final Color selected;
  final ValueChanged<Color> onSelected;
  final List<Color> palette;

  static const double _dot = 36;
  static const double _target = 48;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: palette.map((color) {
        final isSelected = color.toARGB32() == selected.toARGB32();
        return Semantics(
          button: true,
          selected: isSelected,
          child: InkResponse(
            radius: _target / 2,
            onTap: () {
              Haptics.select();
              onSelected(color);
            },
            child: SizedBox(
              width: _target,
              height: _target,
              child: Center(
                child: AnimatedContainer(
                  duration: AppMotion.fast,
                  curve: AppMotion.standard,
                  width: _dot,
                  height: _dot,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: context.colors.textPrimary, width: 2)
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Подпись раздела формы — «Цвет», «Иконка», «Банк». Была продублирована
/// в каждой форме отдельной строкой с одинаковым стилем и отступом.
class FormSectionLabel extends StatelessWidget {
  const FormSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}
