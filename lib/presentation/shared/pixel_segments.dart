import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/haptics.dart';

/// Переключатель разделов внутри одной вкладки.
///
/// Не Material `TabBar`: тот рисует подчёркивание, которое ползёт за
/// пальцем со сглаживанием, и рябь `InkWell` при нажатии — две мягкие
/// анимации там, где весь остальной интерфейс переключается шагами.
/// Здесь сегмент либо залит акцентом, либо нет, промежуточных состояний
/// нет.
class PixelSegments extends StatelessWidget {
  const PixelSegments({
    super.key,
    required this.labels,
    required this.currentIndex,
    required this.onSelected,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.page,
      0,
      AppSpacing.page,
      AppSpacing.sm,
    ),
    this.selectedColor,
  });

  final List<String> labels;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  /// Поля вокруг переключателя. По умолчанию — поля экрана: чаще всего он
  /// стоит под шапкой вкладки. Внутри формы его задаёт сама форма.
  final EdgeInsets padding;

  /// Цвет выбранного сегмента. По умолчанию фирменный синий; переопределяют
  /// там, где выбор сам по себе имеет цвет, — расход красный, доход
  /// зелёный, и подменять это синим значило бы прятать смысл.
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) AppSpacing.gapHSm,
            Expanded(
              child: _Segment(
                label: labels[i],
                selected: i == currentIndex,
                selectedColor: selectedColor,
                onTap: () {
                  if (i == currentIndex) return;
                  Haptics.select();
                  onSelected(i);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
    this.selectedColor,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final active = selectedColor ?? colors.accent;

    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: selected
                ? active.withValues(alpha: 0.16)
                : Colors.transparent,
            borderRadius: AppRadius.controlSmallAll,
            border: Border.all(
              color: selected ? active : colors.border,
              width: AppRadius.pixelBorder,
            ),
          ),
          child: Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.mono.copyWith(
              color: selected ? active : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
