import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../domain/entities/category_entity.dart';
import 'category_avatar.dart';

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
          borderRadius: AppRadius.mediumAll,
          border: Border.all(
            color: selected ? category.color : context.colors.divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CategoryAvatar(category: category, size: 28),
            const SizedBox(width: 8),
            Text(category.name, style: context.text.title),
          ],
        ),
      ),
    );
  }
}
