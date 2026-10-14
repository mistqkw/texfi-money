import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/haptics.dart';

/// Переключатель периода/вида: общая рамка 1px и плавно скользящий
/// «бегунок» под выбранным пунктом.
class HairSegments extends StatelessWidget {
  const HairSegments({
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
  final EdgeInsets padding;

  /// Цвет выбранного пункта; без него — основной цвет текста.
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tint = selectedColor;

    return Padding(
      padding: padding,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: colors.divider, width: AppRadius.hairline),
          borderRadius: AppRadius.controlSmallAll,
        ),
        child: LayoutBuilder(
          builder: (context, box) {
            final slot = box.maxWidth / labels.length;
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: AppMotion.slow,
                  curve: AppMotion.standard,
                  left: slot * currentIndex,
                  top: 0,
                  bottom: 0,
                  width: slot,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: tint == null
                          ? colors.textPrimary
                          : tint.withValues(alpha: 0.14),
                      border: tint == null ? null : Border.all(color: tint),
                      borderRadius: AppRadius.controlSmallAll,
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (var i = 0; i < labels.length; i++)
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (i == currentIndex) return;
                            Haptics.select();
                            onSelected(i);
                          },
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: AppMotion.normal,
                              style: context.text.mono.copyWith(
                                color: i == currentIndex
                                    ? (tint ?? colors.background)
                                    : colors.textSecondary,
                              ),
                              child: Text(
                                labels[i].toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
