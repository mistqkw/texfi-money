import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';

/// Прогресс бюджета или цели — набран отдельными ячейками.
///
/// Был капсулой со скруглением в половину высоты и плавно ползущей
/// заливкой: ровно то, что Material рисует по умолчанию, и единственное
/// место в приложении с таким скруглением. Ячейки заполняются по одной,
/// так что шаг виден: у пиксельной графики нет полутонов, и «чуть больше
/// половины» читается как число ячеек, а не как длина размытого края.
class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.progress,
    required this.color,
    this.height = 10,
    this.cells = 20,
  });

  final double progress;
  final Color color;
  final double height;

  /// Сколько ячеек в шкале. Двадцать — шаг в пять процентов: мельче глаз
  /// уже не считает, крупнее теряется разница между «почти потратил» и
  /// «потратил».
  final int cells;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.clamp(0, 1)),
      duration: AppMotion.slow,
      curve: AppMotion.standard,
      builder: (context, value, child) {
        // Ненулевой прогресс всегда зажигает хотя бы одну ячейку: пустая
        // шкала при потраченных двух процентах сообщала бы «не начато».
        final filled = value <= 0 ? 0 : (value * cells).ceil().clamp(1, cells);
        return SizedBox(
          height: height,
          child: Row(
            // Без stretch ячейки получают нулевую высоту: DecoratedBox без
            // ребёнка не задаёт себе вертикальный размер, а Row по
            // умолчанию выравнивает детей по центру.
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < cells; i++) ...[
                if (i > 0) const SizedBox(width: 2),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: i < filled ? color : colors.surfaceVariant,
                      borderRadius: AppRadius.controlTinyAll,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
