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

    // Коллаж: слова вкладок, под выбранным — синее пятно, которое
    // переезжает и меняет форму. Знаков нет, как и на бумаге: подпись,
    // собранная из разных шрифтов, и есть знак вкладки.
    if (context.style.isCollage) {
      return ColoredBox(
        color: colors.background,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.md,
            ),
            child: CollageTabs(
              labels: [for (final item in items) item.label],
              currentIndex: currentIndex,
              onSelected: _select,
              height: 48,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
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
              // Активная вкладка отмечена короткой насечкой над знаком, а
              // не рамкой вокруг него. Рамка вокруг активной вкладки была
              // ещё одной обведённой плашкой среди десятка таких же — у
              // главного элемента навигации не было своего жеста.
              AnimatedContainer(
                duration: AppMotion.fast,
                curve: AppMotion.standard,
                width: selected ? 18 : 0,
                height: 3,
                color: colors.accent,
              ),
              const SizedBox(height: 6),
              PixelIcon(item.sprite, size: 22, color: color),
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

/// Навигация бета-стиля — строка слов под линейкой, как рубрики на
/// верхнем поле газеты. Знаков нет: на странице, где всё держит
/// типографика, ряд иконок над подписями был бы единственным местом,
/// где интерфейс объясняет себя картинками. Активный раздел — чернилами
/// и подчёркнут, остальные — серым карандашом.
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
        color: colors.background,
        border: Border(top: BorderSide(color: colors.textPrimary)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
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
    final color = selected ? colors.textPrimary : colors.textTertiary;

    return Semantics(
      selected: selected,
      button: true,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: AppMotion.normal,
                style: TextStyle(
                  fontFamily: kSerifFamily,
                  fontSize: 16,
                  height: 1.2,
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
              const SizedBox(height: 5),
              // Подчёркивание — чернилами, во всю ширину слова не
              // растягивается: короткий штрих читается как пометка пером.
              AnimatedContainer(
                duration: AppMotion.normal,
                curve: AppMotion.standard,
                width: selected ? 28 : 0,
                height: 2,
                color: colors.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
