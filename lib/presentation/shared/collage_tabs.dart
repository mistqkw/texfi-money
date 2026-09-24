import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/beta_options.dart';
import 'collage_blob.dart';
import 'collage_text.dart';

/// Ряд вкладок беты «коллаж» — и нижняя навигация, и переключатели
/// разделов. Выбранное слово лежит на синем вырезанном пятне, как слова
/// на картинке автора лежат на синем; при переключении пятно переезжает
/// под новое слово и по дороге меняет форму — у каждой вкладки своя
/// вырезка, а не один и тот же овал, который просто скользит.
class CollageTabs extends StatelessWidget {
  const CollageTabs({
    super.key,
    required this.labels,
    required this.currentIndex,
    required this.onSelected,
    this.height = 44,
    this.fontSize = 15,
    this.selectedColor,
  });

  final List<String> labels;
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final double height;
  final double fontSize;

  /// Цвет пятна; по умолчанию — синий акцент.
  final Color? selectedColor;

  /// Зерно формы пятна под вкладкой [i].
  static int _seed(int i) => i * 13 + 5;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final remix = context.betaOptions.collageRemix;
    final count = labels.length;
    if (count == 0) return const SizedBox.shrink();
    final index = currentIndex.clamp(0, count - 1);
    final blob = selectedColor ?? colors.accent;
    // Слово на пятне — контрастным к самому пятну: на синем чёрное, как
    // на картинке, на чёрном пятне (расход) — белое, иначе оно пропадает.
    final onBlob = blob.computeLuminance() < 0.08
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF000000);

    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth / count;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Пятно: переезжает к выбранной вкладке и переминается из
              // формы прежней вкладки в форму новой.
              _MorphingBlob(
                index: index,
                slotWidth: width,
                height: height,
                color: blob,
              ),
              Row(
                children: [
                  for (var i = 0; i < count; i++)
                    Expanded(
                      child: Semantics(
                        selected: i == index,
                        button: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onSelected(i),
                          child: Center(
                            child: CollageText(
                              labels[i],
                              remix: remix,
                              tallLetter: false,
                              style: TextStyle(
                                fontSize: fontSize,
                                color: i == index
                                    ? onBlob
                                    : colors.textTertiary,
                              ),
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
    );
  }
}

class _MorphingBlob extends StatefulWidget {
  const _MorphingBlob({
    required this.index,
    required this.slotWidth,
    required this.height,
    required this.color,
  });

  final int index;
  final double slotWidth;
  final double height;
  final Color color;

  @override
  State<_MorphingBlob> createState() => _MorphingBlobState();
}

class _MorphingBlobState extends State<_MorphingBlob> {
  late int _from = widget.index;

  @override
  void didUpdateWidget(_MorphingBlob oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) _from = oldWidget.index;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(widget.index),
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.slow,
      curve: AppMotion.snap,
      builder: (context, t, _) {
        final from = _from * widget.slotWidth;
        final to = widget.index * widget.slotWidth;
        final left = from + (to - from) * t;
        // Пятно чуть выходит за ячейку по высоте: слово должно лежать на
        // нём целиком, с полями, а не касаться краёв.
        return Positioned(
          left: left - 2,
          top: -2,
          width: widget.slotWidth + 4,
          height: widget.height + 4,
          child: BlobShape(
            calm: true,
            seed: CollageTabs._seed(_from),
            morphTo: CollageTabs._seed(widget.index),
            t: t.clamp(0.0, 1.0),
            color: widget.color,
          ),
        );
      },
    );
  }
}
