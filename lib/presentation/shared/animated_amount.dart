import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_motion.dart';
import '../../core/utils/formatters.dart';
import '../settings/currency_provider.dart';

/// Плавно анимирует изменение суммы (эффект счётчика).
class AnimatedAmount extends ConsumerWidget {
  const AnimatedAmount({
    super.key,
    required this.value,
    required this.style,
    this.textAlign,
  });

  final double value;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: value, end: value),
      duration: AppMotion.slow,
      curve: AppMotion.standard,
      builder: (context, animatedValue, child) {
        return Text(formatAmount(animatedValue, currency), style: style, textAlign: textAlign);
      },
    );
  }
}
