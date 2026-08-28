import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';

/// Плоский анимированный прогресс-бар для бюджетов и целей накоплений.
class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.progress,
    required this.color,
    this.height = 8,
  });

  final double progress;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Container(
        width: double.infinity,
        height: height,
        color: AppColors.surfaceVariant,
        child: Align(
          alignment: Alignment.centerLeft,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress.clamp(0, 1)),
            duration: AppMotion.slow,
            curve: AppMotion.standard,
            builder: (context, value, child) => FractionallySizedBox(
              widthFactor: value,
              child: Container(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
