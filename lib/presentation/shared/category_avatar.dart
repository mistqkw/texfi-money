import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../domain/entities/category_entity.dart';
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
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.16),
        // Радиус и толщина рамки — из общей шкалы. Раньше здесь было
        // скругление в пятую часть размера и рамка 1.5px: получался
        // Material-чип, единственный в приложении элемент со своими
        // собственными значениями.
        borderRadius: AppRadius.controlSmallAll,
        border: Border.all(color: category.color.withValues(alpha: 0.55), width: AppRadius.pixelBorder),
      ),
      child: PixelIcon(PixelIcons.forCategoryKey(category.iconKey), color: category.color, size: size * 0.5),
    );
  }
}
