import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_style_ext.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/haptics.dart';
import 'pixel_icon.dart';

/// Одна вкладка нижней навигации.
class PixelNavItem {
  const PixelNavItem({required this.sprite, required this.label});

  /// Сетка спрайта из [PixelIcons].
  final List<String> sprite;

  final String label;
}

/// Нижняя навигация на собственных спрайтах — та же, что в TexFi f0kus.
///
/// Material `NavigationBar` приносил с собой круглую «пилюлю» под активной
/// иконкой. Она видна на каждом экране приложения и была самой заметной
/// деталью, по которой интерфейс читался как generic Material, несмотря на
/// пиксельные иконки внутри. Здесь всё своё: квадратная подложка активной
/// вкладки, граница сверху в 2px вместо тени.
class PixelNavBar extends StatelessWidget {
  const PixelNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<PixelNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  void _select(int i) {
    if (i == currentIndex) return;
    Haptics.select();
    onSelected(i);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (context.style.beta) {
      return _BetaNavBar(
        items: items,
        currentIndex: currentIndex,
        onSelected: _select,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.border, width: AppRadius.pixelBorder),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _PixelNavTab(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: () => _select(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PixelNavTab extends StatelessWidget {
  const _PixelNavTab({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final PixelNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Активная вкладка — акцент, неактивная — приглушённый цвет темы:
    // серый в тёмной, тёплый бежево-коричневый в светлой.
    final color = selected ? colors.accent : colors.textTertiary;

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
            mainAxisSize: MainAxisSize.min,
            children: [
              // Подложка активной вкладки — квадрат с рамкой, а не
              // material-«пилюля».
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs + 2,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? colors.accent.withValues(alpha: 0.16)
                      : Colors.transparent,
                  border: Border.all(
                    color: selected ? colors.accent : Colors.transparent,
                    width: AppRadius.pixelBorder,
                  ),
                ),
                child: PixelIcon(item.sprite, size: 20, color: color),
              ),
              AppSpacing.gapXs,
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: context.text.mono.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Навигация бета-стиля: плоскость со скруглённым верхом, которая лежит
/// на мягкой тени, а не отрезана рамкой. Активная вкладка отмечена
/// короткой чертой над знаком и антиквой в подписи — как активный пункт
/// оглавления, а не как нажатая клавиша.
class _BetaNavBar extends StatelessWidget {
  const _BetaNavBar({
    required this.items,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<PixelNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.6),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          // Отступ сверху уводит черту активной вкладки с закругления
          // кромки — на самом краю она висела в воздухе.
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _BetaNavTab(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: () => onSelected(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BetaNavTab extends StatelessWidget {
  const _BetaNavTab({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final PixelNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.accent : colors.textTertiary;

    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Черта растёт из точки: переход между вкладками виден, даже
            // если смотреть не на подпись.
            AnimatedContainer(
              duration: AppMotion.normal,
              curve: AppMotion.standard,
              width: selected ? 22 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: colors.accent,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AnimatedScale(
              scale: selected ? 1.08 : 1,
              duration: AppMotion.normal,
              curve: AppMotion.standard,
              child: PixelIcon(item.sprite, size: 23, color: color),
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: AppMotion.normal,
              style: TextStyle(
                fontFamily: kSerifFamily,
                fontSize: 13,
                height: 1.1,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
