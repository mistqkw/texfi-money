import 'package:flutter/material.dart';

import '../../core/theme/app_motion.dart';
import '../../core/utils/formatters.dart';

/// Плавно анимирует изменение суммы (эффект счётчика).
class AnimatedAmount extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: value, end: value),
      duration: AppMotion.slow,
      curve: AppMotion.standard,
      builder: (context, animatedValue, child) {
        return Text(formatAmount(animatedValue), style: style, textAlign: textAlign);
      },
    );
  }
}
