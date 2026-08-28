import 'package:flutter/material.dart';

import '../../domain/entities/category_entity.dart';

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
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      child: Icon(category.icon, color: category.color, size: size * 0.5),
    );
  }
}
