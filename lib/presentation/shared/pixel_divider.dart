import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';

/// Разделитель внутри карточки или списка.
///
/// Material `Divider` рисует линию в один логический пиксель — на экране
/// с плотностью 3x это волосок, который рядом с рамками в
/// [AppRadius.pixelBorder] выглядит браком печати, а не оформлением.
/// Здесь та же толщина, что у всех остальных границ.
///
/// Второе отличие: `Divider(height:)` задаёт высоту всей коробки вместе с
/// отступами, а не зазор, — и это регулярно принимают за отступ. Тут
/// [gap] — именно зазор с каждой стороны от линии.
class PixelDivider extends StatelessWidget {
  const PixelDivider({super.key, this.gap = AppSpacing.md});

  final double gap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: gap),
      child: SizedBox(
        height: AppRadius.pixelBorder,
        child: DecoratedBox(
          decoration: BoxDecoration(color: context.colors.divider),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

/// Разделитель с меткой по центру — группировка списка по дню или месяцу.
///
/// Раньше линии по бокам были Material-волосками в один пиксель, а метка
/// набиралась моноширинным. Теперь линия той же толщины, что все рамки, а
/// метка — тем же стилем подписи, что заголовки карточек: в интерфейсе не
/// должно быть двух шрифтов для одной роли.
class PixelLabelDivider extends StatelessWidget {
  const PixelLabelDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rule = SizedBox(
      height: AppRadius.pixelBorder,
      child: DecoratedBox(
        decoration: BoxDecoration(color: colors.divider),
        child: const SizedBox.expand(),
      ),
    );

    return Row(
      children: [
        Expanded(child: rule),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label.toUpperCase(),
            style: context.text.caption.copyWith(color: colors.textTertiary),
          ),
        ),
        Expanded(child: rule),
      ],
    );
  }
}
