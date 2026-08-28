import 'package:flutter/material.dart';

/// Растущие столбики из логотипа TexFi m0ney — переиспользуемый брендовый
/// знак (сплэш, онбординг).
class BrandGlyph extends StatelessWidget {
  const BrandGlyph({super.key, this.height = 64, this.color});

  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final base = color ?? const Color(0xFF4A7DFB);
    final barWidth = height * 20 / 64;
    final gap = height * 6 / 64;
    final radius = barWidth * 0.25;

    Widget bar(double h, Color c) => Container(
          width: barWidth,
          height: h,
          margin: EdgeInsets.only(right: gap),
          decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(radius)),
        );

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          bar(height * 20 / 64, base.withValues(alpha: 0.5)),
          bar(height * 36 / 64, base.withValues(alpha: 0.75)),
          Container(
            width: barWidth,
            height: height * 52 / 64,
            decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(radius)),
          ),
        ],
      ),
    );
  }
}
