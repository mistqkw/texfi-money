import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
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
                style: labelColor == null
                    ? context.text.caption
                    : context.text.caption.copyWith(color: labelColor),
              ),
              AppSpacing.gapSm,
              child,
            ],
          );

    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? colors.surface,
        borderRadius: AppRadius.cardMediumAll,
        border: Border.all(color: border, width: AppRadius.pixelBorder),
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
            borderRadius: AppRadius.cardMediumAll,
            child: content,
          );

    if (!raised) return tappable;

    // Тень карточки — приглушённый вариант её же рамки: у акцентной
    // карточки синяя, у обычной цвет разделителя. Так «объём» появляется
    // везде, но не превращает список в лес одинаковых плашек.
    return PixelShadowBox(
      shadowColor:
          accent ? colors.accentShadow : (borderColor ?? colors.shadow),
      borderRadius: AppRadius.cardMediumAll,
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
              style: context.text.headline,
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
    return Container(height: 2, color: context.colors.divider);
  }
}
