import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';

/// Заголовок раздела: номер, название и линейка до правого края.
///
/// Раньше разделы отличались от обычного текста только кеглем заголовка, и
/// длинный экран настроек читался как сплошная лента карточек — где
/// кончается одна тема и начинается следующая, приходилось угадывать.
/// Номер здесь не украшение: по нему при прокрутке видно, сколько глав уже
/// прошло. Тот же приём применён на сайте экосистемы.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.index});

  final String title;

  /// Порядковый номер раздела на экране, с единицы. `null` — раздел
  /// единственный или порядок для него бессмыслен: рисуется без номера.
  final int? index;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final number = index;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
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
          // Линейка добирает строку до края: без неё короткое название
          // раздела висит в пустоте и не читается как разделитель.
          Expanded(child: Container(height: 2, color: colors.divider)),
        ],
      ),
    );
  }
}
