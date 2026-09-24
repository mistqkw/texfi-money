import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_motion.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../settings/currency_provider.dart';

/// Плавно анимирует изменение суммы (эффект счётчика).
class AnimatedAmount extends ConsumerWidget {
  const AnimatedAmount({
    super.key,
    required this.value,
    required this.style,
    this.textAlign,
    this.symbolColor,
  });

  final double value;
  final TextStyle style;
  final TextAlign? textAlign;

  /// Цвет знака валюты, если он отличается от цифр — у баланса он
  /// золотой.
  final Color? symbolColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: value, end: value),
      duration: AppMotion.slow,
      curve: AppMotion.standard,
      builder: (context, animatedValue, child) {
        final text = formatAmount(animatedValue, currency, context);
        if (style.fontFamily != kPixelFamily && symbolColor == null) {
          return Text(text, style: style, textAlign: textAlign);
        }
        return Text.rich(
          TextSpan(
            children: amountSpans(
              text,
              style,
              symbol: currency.symbol,
              symbolColor: symbolColor,
            ),
          ),
          textAlign: textAlign,
        );
      },
    );
  }
}

/// Сумма, разложенная на куски: цифры, узкие разделители разрядов и
/// знак валюты.
///
/// В пиксельном шрифте все знаки одной ширины, и пробел между разрядами
/// занимает целую клетку: «37 770 ₽» разваливалось на три отдельных
/// числа. Здесь разделители набраны тем же шрифтом, но кеглем в 40% —
/// разряды читаются, а число остаётся одним словом.
List<InlineSpan> amountSpans(
  String text,
  TextStyle style, {
  required String symbol,
  Color? symbolColor,
}) {
  final pixel = style.fontFamily == kPixelFamily;
  final narrow = style.copyWith(fontSize: (style.fontSize ?? 14) * 0.4);
  final spans = <InlineSpan>[];
  final buffer = StringBuffer();

  void flush() {
    if (buffer.isEmpty) return;
    spans.add(TextSpan(text: buffer.toString(), style: style));
    buffer.clear();
  }

  for (var i = 0; i < text.length; i++) {
    final ch = text[i];
    final isSpace = ch == ' ' || ch == '\u00A0' || ch == '\u202F';
    if (isSpace && pixel) {
      flush();
      spans.add(TextSpan(text: ' ', style: narrow));
      continue;
    }
    if (symbolColor != null && text.startsWith(symbol, i)) {
      flush();
      spans.add(TextSpan(text: symbol, style: style.copyWith(color: symbolColor)));
      i += symbol.length - 1;
      continue;
    }
    buffer.write(ch);
  }
  flush();
  return spans;
}
