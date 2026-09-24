import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../domain/entities/category_entity.dart';
import 'pixel_card.dart';
import 'pixel_icon.dart';

class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({
    super.key,
    required this.category,
    this.size = 44,
  });

  final CategoryEntity category;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Без рамки, со светлой кромкой сверху. Цветная рамка у каждой плитки
    // в списке операций давала лес обведённых квадратов, и сумма справа
    // терялась среди них; плитка без обводки держится тоном и кромкой,
    // как и карточки.
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.14),
        borderRadius: AppRadius.controlSmallAll,
      ),
      child: CustomPaint(
        foregroundPainter: BevelPainter(
          category.color.withValues(alpha: 0.4),
          inset: 3,
        ),
        child: Center(
          child: PixelIcon(
            PixelIcons.forCategoryKey(category.iconKey),
            color: category.color,
            size: size * 0.56,
          ),
        ),
      ),
    );
  }
}
