import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/haptics.dart';
import 'hair_icon.dart';

class HairNavItem {
  const HairNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Нижняя панель (дизайн «hairline»): линия 1px сверху, линейные иконки,
/// подписи mono. Активная вкладка — основной цвет и тонкая синяя черта
/// сверху, которая плавно переезжает между вкладками.
class HairNavBar extends StatelessWidget {
  const HairNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<HairNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(
          top: BorderSide(color: colors.divider, width: AppRadius.hairline),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: LayoutBuilder(
            builder: (context, box) {
              final slot = box.maxWidth / items.length;
              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: AppMotion.slow,
                    curve: AppMotion.standard,
                    left: slot * currentIndex + slot / 2 - 14,
                    top: 0,
                    width: 28,
                    height: 2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.accent,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < items.length; i++)
                        Expanded(
                          child: _Tab(
                            item: items[i],
                            selected: i == currentIndex,
                            onTap: () {
                              if (i == currentIndex) return;
                              Haptics.select();
                              onSelected(i);
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.item, required this.selected, required this.onTap});

  final HairNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.textPrimary : colors.textTertiary;

    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.xs,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: selected ? 1.08 : 1,
                duration: AppMotion.normal,
                curve: AppMotion.standard,
                child: TweenAnimationBuilder<Color?>(
                  tween: ColorTween(end: color),
                  duration: AppMotion.normal,
                  builder: (context, value, _) =>
                      HairIcon(item.icon, size: 22, color: value),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: AppMotion.normal,
                style: context.text.mono.copyWith(color: color, fontSize: 9.5),
                child: Text(
                  item.label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
