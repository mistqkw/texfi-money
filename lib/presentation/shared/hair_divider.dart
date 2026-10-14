import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';

/// Тонкая линия 1px.
class HairDivider extends StatelessWidget {
  const HairDivider({super.key, this.gap = AppSpacing.md});

  final double gap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: gap),
      child: SizedBox(
        height: AppRadius.hairline,
        child: DecoratedBox(
          decoration: BoxDecoration(color: context.colors.divider),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

/// Линия с подписью посередине.
class HairLabelDivider extends StatelessWidget {
  const HairLabelDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rule = SizedBox(
      height: AppRadius.hairline,
      child: DecoratedBox(
        decoration: BoxDecoration(color: colors.divider),
        child: const SizedBox.expand(),
      ),
    );

    return Row(
      children: [
        Expanded(child: rule),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label.toUpperCase(),
            style: context.text.mono.copyWith(color: colors.textTertiary),
          ),
        ),
        Expanded(child: rule),
      ],
    );
  }
}
