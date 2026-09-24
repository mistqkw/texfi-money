import 'package:flutter/material.dart';

import '../../core/theme/app_palettes.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_style_ext.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/entities/category_entity.dart';
import 'beta_icons.dart';
import 'collage_blob.dart';
import 'l10n_helpers.dart';
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
    // Коллаж: знак категории лежит на вырезанном пятне её цвета. Зерно
    // пятна — от ключа знака, поэтому у каждой категории своя форма, и
    // список не превращается в ряд одинаковых клякс.
    if (context.style.isCollage) {
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: BlobShape(
                seed: category.iconKey.codeUnits.fold(0, (a, b) => a * 31 + b) & 0xFFFF,
                color: category.color.withValues(alpha: 0.85),
              ),
            ),
            BetaIcon(
              pattern: PixelIcons.forCategoryKey(category.iconKey),
              size: size * 0.5,
              color: const Color(0xFF000000),
            ),
          ],
        ),
      );
    }
    // На бумаге вместо плитки со значком — буквица: первая буква
    // названия антиквой, цветом категории. Цвет остаётся тем же ключом,
    // по которому категорию узнают в графиках, а плитка с иконкой —
    // самый заезженный элемент списков трат.
    if (context.style.beta) {
      final name = categoryDisplayName(context, category).trim();
      final letter = name.isEmpty ? '·' : name.characters.first.toUpperCase();
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            letter,
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              fontFamily: kSerifFamily,
              fontWeight: FontWeight.w600,
              fontSize: size * 0.72,
              height: 1,
              color: AppPalettes.inkify(
                category.color,
                dark: Theme.of(context).brightness == Brightness.dark,
              ),
            ),
          ),
        ),
      );
    }
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
