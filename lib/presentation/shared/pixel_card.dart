import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_style_ext.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/theme/beta_options.dart';
import 'collage_text.dart';
import 'pixel_shadow.dart';

/// Карточка приложения — та же, что в TexFi f0kus: умеренно скруглённая,
/// с рамкой 2px и сплошной тенью со смещением.
///
/// Пришла на смену `TerminalBox` — карточке с меткой, врезанной прямо в
/// линию рамки («❯ баланс»). Приём сам по себе неплохой, но он был
/// только здесь: ни в f0kus, ни в files его нет. На одном экране с
/// пиксельными знаками и кнопками f0kus он читался как ещё один
/// визуальный язык поверх общего — а их и так было два.
///
/// [raised] отвечает за тень. Выключать её стоит там, где карточка
/// вложена в другую или прижата к краю экрана.
class PixelCard extends StatelessWidget {
  const PixelCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.card,
    this.onTap,
    this.onLongPress,
    this.accent = false,
    this.borderColor,
    this.raised = true,
    this.background,
    this.label,
    this.labelColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  /// Долгое нажатие — для второстепенного действия, которому не место в
  /// постоянно видимой кнопке.
  final VoidCallback? onLongPress;

  /// Выделенная карточка — рамка фирменным синим.
  final bool accent;

  final Color? borderColor;
  final Color? background;

  /// Сплошная тень со смещением.
  final bool raised;

  /// Подпись над содержимым: «лейбл сверху → главное значение». Ровно та
  /// же композиция, что в f0kus, просто собранная в параметр — в m0ney
  /// таких карточек больше сорока, и повторять три строки в каждой значит
  /// рано или поздно их рассинхронить.
  ///
  /// Раньше подпись врезалась прямо в линию рамки и предварялась «❯».
  /// Приём был только здесь — ни в f0kus, ни в files его нет.
  final String? label;

  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = context.style;
    final radius = style.beta ? style.cardRadius : AppRadius.cardMediumAll;
    final border = borderColor ?? (accent ? colors.accent : colors.border);

    final label = this.label;
    final body = label == null || label.isEmpty
        ? child
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                // В бете подпись блока — рубрика капителями.
                style: (style.beta ? context.text.mono : context.text.caption)
                    .copyWith(color: labelColor),
              ),
              AppSpacing.gapSm,
              child,
            ],
          );

    // Коллаж — вырезки на листе: у блока нет ни рамки, ни фона, ни
    // линейки. Блоки отделяет воздух, а подпись над ними набрана
    // моноширинным, как «TexFi» на картинке автора. Выделенный блок
    // отмечен коротким синим штрихом у подписи.
    if (style.isCollage) {
      final marked = accent || borderColor != null;
      final collageBody = label == null || label.isEmpty
          ? child
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (marked) ...[
                      Container(
                        width: 14,
                        height: 6,
                        color: borderColor ?? colors.accent,
                      ),
                      AppSpacing.gapHSm,
                    ],
                    Flexible(
                      child: Text(
                        label.toLowerCase(),
                        style: context.text.mono.copyWith(
                          color: labelColor ?? colors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapSm,
                child,
              ],
            );
      final cut = Padding(
        padding: padding.copyWith(left: 0, right: 0),
        child: Material(type: MaterialType.transparency, child: collageBody),
      );
      if (onTap == null && onLongPress == null) return cut;
      return InkWell(onTap: onTap, onLongPress: onLongPress, child: cut);
    }

    // Бета-стиль — страница, а не набор плашек: блок отделён линейкой
    // сверху, фона, рамки и тени у него нет, текст стоит на бумаге.
    // Выделенный блок получает двойную линейку, как раздел в газете.
    if (style.beta) {
      final rule = BorderSide(
        color: accent || borderColor != null
            ? (borderColor ?? colors.textPrimary)
            : colors.textPrimary.withValues(alpha: 0.85),
        width: accent || borderColor != null ? 2 : 1,
      );
      final page = Container(
        padding: padding.copyWith(left: 0, right: 0),
        decoration: BoxDecoration(
          color: background,
          border: Border(top: rule),
        ),
        child: Material(type: MaterialType.transparency, child: body),
      );
      if (onTap == null && onLongPress == null) return page;
      return InkWell(onTap: onTap, onLongPress: onLongPress, child: page);
    }

    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? colors.surface,
        borderRadius: radius,
        border: Border.all(color: border, width: style.borderWidth),
      ),
      // ListTile и прочие Material-виджеты рисуют фон и отклик на ближайшем
      // Material-предке. Без этой прослойки они оказались бы под заливкой
      // карточки, и Flutter справедливо об этом ругается.
      child: Material(
        type: MaterialType.transparency,
        child: body,
      ),
    );

    final tappable = onTap == null && onLongPress == null
        ? content
        : InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: radius,
            child: content,
          );

    if (!raised) return tappable;

    // Тень карточки — приглушённый вариант её же рамки: у акцентной
    // карточки синяя, у обычной цвет разделителя. Так «объём» появляется
    // везде, но не превращает список в лес одинаковых плашек.
    return PixelShadowBox(
      shadowColor:
          accent ? colors.accentShadow : (borderColor ?? colors.shadow),
      borderRadius: radius,
      child: tappable,
    );
  }
}

/// Заголовок раздела пиксельным шрифтом с «линейкой» справа.
///
/// Номер раздела ([index]) — добавка m0ney поверх f0kus: экраны здесь
/// длиннее, и по номеру при прокрутке видно, сколько глав уже прошло.
/// Тот же приём применён на сайте экосистемы.
class PixelSectionHeader extends StatelessWidget {
  const PixelSectionHeader({
    super.key,
    required this.title,
    this.index,
    this.trailing,
  });

  final String title;

  /// Порядковый номер раздела на экране, с единицы. `null` — раздел
  /// единственный или порядок для него бессмыслен.
  final int? index;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final number = index;

    // Коллаж: номер — моноширинным синим, название собрано из разных
    // шрифтов, линейки нет — раздел держит сам заголовок.
    if (context.style.isCollage) {
      final options = context.betaOptions;
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (number != null) ...[
              Text(
                number.toString().padLeft(2, '0'),
                style: context.text.mono.copyWith(
                  color: colors.accent,
                  fontSize: 13,
                ),
              ),
              AppSpacing.gapHSm,
            ],
            Flexible(
              child: CollageText(
                title,
                style: context.text.headline.copyWith(fontSize: 22),
                remix: options.collageRemix,
                tallLetter: false,
              ),
            ),
            if (trailing != null) ...[
              AppSpacing.gapHMd,
              trailing!,
            ],
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (number != null) ...[
            Text(
              number.toString().padLeft(2, '0'),
              style: context.text.pixelAccent.copyWith(color: colors.accent),
            ),
            AppSpacing.gapHMd,
          ],
          Flexible(
            child: Text(
              title,
              // В бете заголовок раздела на ступень мельче заголовка
              // экрана: 24 кегля антиквы обрезали «Сборка и устройство»
              // до «Сборка и устройс…».
              style: context.style.beta
                  ? context.text.headline.copyWith(fontSize: 20)
                  : context.text.headline,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppSpacing.gapHMd,
          // Линейка фиксированной длины, а не Expanded. Раньше заголовок и
          // линейка были двумя гибкими детьми одного Row с одинаковым
          // весом — и делили ширину пополам, из-за чего «Открытый код»
          // обрезалось до «Открытый …» на половине пустого экрана.
          const SizedBox(width: 56, child: _HeaderRule()),
          if (trailing != null) ...[
            AppSpacing.gapHMd,
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Короткая линейка справа от заголовка раздела.
class _HeaderRule extends StatelessWidget {
  const _HeaderRule();

  @override
  Widget build(BuildContext context) {
    final style = context.style;
    // В бета-стиле линейка — волосок: двухпиксельный брусок рядом с
    // антиквой смотрится обломком пиксельного интерфейса.
    return Container(height: style.borderWidth, color: context.colors.divider);
  }
}
