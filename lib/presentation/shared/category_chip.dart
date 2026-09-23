import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../domain/entities/category_entity.dart';
import 'category_avatar.dart';
import 'l10n_helpers.dart';

/// Выбираемый чип категории: иконка + название, подсвечивается цветом категории.
class CategorySelectChip extends StatelessWidget {
  const CategorySelectChip({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final CategoryEntity category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? category.color.withValues(alpha: 0.16) : context.colors.surface,
          borderRadius: AppRadius.cardSmallAll,
          // Толщина рамки одна на всё приложение. Раньше выбранный чип
          // обводился в 1.5px, а невыбранный в 1px — на одном экране
          // получалось три разные толщины линии, и выбор читался как
          // «чуть жирнее», а не как другое состояние. Состояние теперь
          // держат цвет и заливка.
          border: Border.all(
            color: selected ? category.color : context.colors.border,
            width: AppRadius.pixelBorder,
          ),
        ),
        child: Row(
          children: [
            CategoryAvatar(category: category, size: 28),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                categoryDisplayName(context, category),
                // На размер меньше, чем в списках: в ячейке сетки шириной
                // в половину экрана «Развлечения» шестнадцатым кеглем
                // разрывалось посреди слова.
                style: context.text.label.copyWith(color: context.colors.textPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
