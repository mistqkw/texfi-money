import 'package:flutter/material.dart';

import '../../core/theme/app_style_ext.dart';
import '../../core/theme/beta_options.dart';
import 'collage_text.dart';

/// Заголовок экрана в шапке.
///
/// В пиксельном стиле и на бумаге — обычный текст стилем шапки. В бете
/// «коллаж» заголовок собирается из разных шрифтов и при появлении
/// коротко перебирает начертания (см. [CollageText]) — заголовок экрана
/// самое заметное место стиля, и именно его автор набрал вперемешку.
class AppTitle extends StatelessWidget {
  const AppTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    if (!context.style.isCollage) return Text(text);
    final options = context.betaOptions;
    final base = Theme.of(context).appBarTheme.titleTextStyle ??
        Theme.of(context).textTheme.headlineMedium!;
    return CollageText(
      text,
      style: base,
      remix: options.collageRemix,
      shuffle: options.collageShuffle,
    );
  }
}
