import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_radius.dart';
import '../../domain/entities/category_entity.dart';
import 'hair_icon.dart';

class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({super.key, required this.category, this.size = 44});

  final CategoryEntity category;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // Плитка нейтральная: фон и рамка — общие токены поверхности, а не
        // цвет категории. Раньше здесь была заливка 16% и рамка 55% в цвете
        // категории, и в списке из восьми строк получалось восемь разных
        // цветных плашек подряд. Цвет категории остался ровно в одном
        // месте — в самом спрайте, где его достаточно, чтобы различать
        // строки, и мало, чтобы шуметь.
        color: colors.surfaceVariant,
        // Радиус и толщина рамки — из общей шкалы. Раньше здесь было
        // скругление в пятую часть размера и рамка 1.5px: получался
        // Material-чип, единственный в приложении элемент со своими
        // собственными значениями.
        borderRadius: AppRadius.controlSmallAll,
        border: Border.all(color: colors.border, width: AppRadius.hairline),
      ),
      child: HairIcon(
        HairIcons.forCategoryKey(category.iconKey),
        color: category.color,
        size: size * 0.5,
      ),
    );
  }
}
