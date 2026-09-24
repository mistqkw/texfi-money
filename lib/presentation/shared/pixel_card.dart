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
      decoration: BoxDecoration(
        color: background ?? colors.surface,
        borderRadius: AppRadius.cardMediumAll,
        border: Border.all(color: border, width: AppRadius.pixelBorder),
      ),
      child: CustomPaint(
        // Выделенная карточка — с отливом акцента по диагонали, набранным
        // точками, а не размытием: так переход тона делает пиксельная
        // графика. Обычная — ровная: отлив у всех сразу перестал бы
        // выделять главное.
        painter: accent ? DitherGlowPainter(color: colors.accent) : null,
        // Светлая кромка сверху — грань, на которую падает свет. Вместе
        // со сплошной тенью снизу она даёт предмет, а не обведённую
        // плашку.
        foregroundPainter: BevelPainter(colors.highlight),
        child: Padding(
          padding: padding,
          // ListTile и прочие Material-виджеты рисуют фон и отклик на
          // ближайшем Material-предке. Без этой прослойки они оказались бы
          // под заливкой карточки, и Flutter справедливо об этом ругается.
          child: Material(
            type: MaterialType.transparency,
            child: body,
          ),
        ),
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

/// Светлая кромка по верхнему краю — освещённая грань предмета.
///
/// Отступает от углов на радиус скругления: кромка, заходящая на
/// скруглённый угол, выглядела бы приклеенной полоской.
///
/// Рисуется поверх, а не рамкой `Border(top: …)`: Flutter не умеет
/// скруглять рамку, у которой стороны разного цвета, — такая рамка
/// роняет отрисовку. [bottom] — такая же тёмная грань снизу.
class BevelPainter extends CustomPainter {
  const BevelPainter(this.color, {this.inset = 6, this.bottom});

  final Color color;
  final double inset;
  final Color? bottom;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= inset * 2) return;
    canvas.drawRect(
      Rect.fromLTWH(inset, 0, size.width - inset * 2, AppRadius.pixelBorder),
      Paint()..color = color,
    );
    final low = bottom;
    if (low != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          inset,
          size.height - AppRadius.pixelBorder,
          size.width - inset * 2,
          AppRadius.pixelBorder,
        ),
        Paint()..color = low,
      );
    }
  }

  @override
  bool shouldRepaint(BevelPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.inset != inset ||
      oldDelegate.bottom != bottom;
}

/// Отлив цвета из верхнего угла, набранный упорядоченным дизерингом
/// (матрица Байера 4×4): плотность точек падает к противоположному углу.
///
/// Пиксельная графика не знает прозрачных градиентов — тон меняют
/// частотой точек. Здесь это ещё и дешёвый способ сделать главную
/// карточку «дорогой», не выходя из языка: гладкий градиент рядом с
/// пиксельным шрифтом и спрайтами сразу выдал бы чужой приём.
class DitherGlowPainter extends CustomPainter {
  const DitherGlowPainter({required this.color, this.cell = 3, this.strength = 0.16});

  final Color color;
  final double cell;
  final double strength;

  static const List<int> _bayer = [
    0, 8, 2, 10, //
    12, 4, 14, 6,
    3, 11, 1, 9,
    15, 7, 13, 5,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final cols = (size.width / cell).ceil();
    final rows = (size.height / cell).ceil();
    if (cols == 0 || rows == 0) return;
    final path = Path();
    for (var y = 0; y < rows; y++) {
      for (var x = 0; x < cols; x++) {
        // Свет из правого верхнего угла: там почти сплошной тон, к левому
        // нижнему — ни одной точки.
        final t = (1 - x / cols) * 0.55 + (y / rows) * 0.45;
        final density = (1 - t * 1.25).clamp(0.0, 1.0);
        final threshold = (_bayer[(y % 4) * 4 + x % 4] + 0.5) / 16;
        if (density > threshold) {
          path.addRect(Rect.fromLTWH(x * cell, y * cell, cell, cell));
        }
      }
    }
    canvas.drawPath(path, Paint()..color = color.withValues(alpha: strength));
  }

  @override
  bool shouldRepaint(DitherGlowPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.cell != cell ||
      oldDelegate.strength != strength;
}
