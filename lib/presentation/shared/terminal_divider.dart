import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_text_styles_ext.dart';

/// Полноширинный разделитель с моноширинной меткой по центру —
/// для группировки списков по дате/месяцу в терминальном стиле.
class TerminalDivider extends StatelessWidget {
  const TerminalDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.divider;

    return Row(
      children: [
        Expanded(child: Divider(color: color, thickness: 1, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            label.toUpperCase(),
            style: context.text.mono.copyWith(
              letterSpacing: 1.1,
              color: context.colors.textTertiary,
            ),
          ),
        ),
        Expanded(child: Divider(color: color, thickness: 1, height: 1)),
      ],
    );
  }
}
