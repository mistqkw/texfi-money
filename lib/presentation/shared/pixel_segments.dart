import 'package:flutter/material.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_style_ext.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/haptics.dart';
import 'collage_tabs.dart';
import 'pixel_card.dart';

/// Переключатель разделов внутри одной вкладки.
///
/// Не Material `TabBar`: тот рисует подчёркивание, которое ползёт за
/// пальцем со сглаживанием, и рябь `InkWell` при нажатии — две мягкие
/// анимации там, где весь остальной интерфейс переключается шагами.
/// Здесь сегмент либо залит акцентом, либо нет, промежуточных состояний
/// нет.
class PixelSegments extends StatelessWidget {
  const PixelSegments({
    super.key,
    required this.labels,
    required this.currentIndex,
    required this.onSelected,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.page,
      0,
      AppSpacing.page,
      AppSpacing.sm,
    ),
    this.selectedColor,
  });

  final List<String> labels;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  /// Поля вокруг переключателя. По умолчанию — поля экрана: чаще всего он
  /// стоит под шапкой вкладки. Внутри формы его задаёт сама форма.
  final EdgeInsets padding;

  /// Цвет выбранного сегмента. По умолчанию фирменный синий; переопределяют
  /// там, где выбор сам по себе имеет цвет, — расход красный, доход
  /// зелёный, и подменять это синим значило бы прятать смысл.
  final Color? selectedColor;

  void _select(int i) {
    if (i == currentIndex) return;
    Haptics.select();
    onSelected(i);
  }

  @override
  Widget build(BuildContext context) {
    if (context.style.isCollage) {
      return Padding(
        padding: padding,
        child: CollageTabs(
          labels: labels,
          currentIndex: currentIndex,
          onSelected: _select,
          selectedColor: selectedColor,
        ),
      );
    }
    if (context.style.beta) {
      return Padding(
        padding: padding,
        child: _BetaSegments(
          labels: labels,
          currentIndex: currentIndex,
          onSelected: _select,
          selectedColor: selectedColor,
        ),
      );
    }
    final colors = context.colors;
    // Утопленная дорожка, в которой выбранный раздел — приподнятая
    // клавиша. Раньше каждый сегмент был отдельной рамкой: два-три
    // одинаковых прямоугольника рядом читались как кнопки, а не как один
    // переключатель с положением.
    return Padding(
      padding: padding,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: AppRadius.controlSmallAll,
          border: Border.all(
            color: colors.divider,
            width: AppRadius.pixelBorder,
          ),
        ),
        child: Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: _Segment(
                  label: labels[i],
                  selected: i == currentIndex,
                  selectedColor: selectedColor,
                  onTap: () => _select(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
    this.selectedColor,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final active = selectedColor ?? colors.accent;

    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        // Выбранная клавиша — с освещённой кромкой сверху и тенью снизу:
        // приподнята над дорожкой.
        child: _Raised(
          raised: selected,
          child: AnimatedContainer(
            duration: AppMotion.fast,
            curve: AppMotion.standard,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm - 1),
            decoration: BoxDecoration(
              color: selected ? colors.surfaceVariant : Colors.transparent,
              borderRadius: AppRadius.controlTinyAll,
            ),
            child: Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.mono.copyWith(
                color: selected ? active : colors.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Кромки приподнятой клавиши: свет сверху, тень снизу.
class _Raised extends StatelessWidget {
  const _Raised({required this.raised, required this.child});

  final bool raised;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!raised) return child;
    final colors = context.colors;
    return CustomPaint(
      foregroundPainter: BevelPainter(
        colors.highlight,
        inset: 2,
        bottom: colors.shadow,
      ),
      child: child,
    );
  }
}

/// Переключатель бета-стиля — рубрики на общей линейке: слова в ряд,
/// выбранное набрано полужирным и подчёркнуто жирной чертой, которая
/// переезжает под новый раздел. Ни дорожки, ни бегунка — на странице
/// раздел выбирают так же, как в оглавлении.
class _BetaSegments extends StatelessWidget {
  const _BetaSegments({
    required this.labels,
    required this.currentIndex,
    required this.onSelected,
    this.selectedColor,
  });

  final List<String> labels;
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ink = selectedColor ?? colors.textPrimary;
    final count = labels.length;
    if (count == 0) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth / count;
        return SizedBox(
          height: 40,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(height: 1, color: colors.divider),
              ),
              AnimatedPositioned(
                duration: AppMotion.slow,
                curve: AppMotion.standard,
                left: width * currentIndex.clamp(0, count - 1),
                width: width,
                bottom: 0,
                height: 2,
                child: ColoredBox(color: ink),
              ),
              Row(
                children: [
                  for (var i = 0; i < count; i++)
                    Expanded(
                      child: Semantics(
                        selected: i == currentIndex,
                        button: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onSelected(i),
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: AppMotion.normal,
                              style: TextStyle(
                                fontFamily: kSerifFamily,
                                fontSize: 16,
                                height: 1.1,
                                fontWeight: i == currentIndex
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: i == currentIndex
                                    ? ink
                                    : colors.textTertiary,
                              ),
                              child: Text(
                                labels[i],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
