import 'package:flutter/material.dart';

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
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(color: category.color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: PixelIcon(PixelIcons.forCategoryKey(category.iconKey), color: category.color, size: size * 0.5),
    );
  }
}
