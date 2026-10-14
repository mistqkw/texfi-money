import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';

/// Графики, нарисованные своими руками вместо fl_chart.
///
/// Причина не в зависимости, а в том, что рисует fl_chart: столбцы со
/// скруглёнными «капсульными» концами и сглаженное кольцо. На экране
/// рядом с пиксельными знаками, рамками в 2px и сплошными тенями это
/// читалось как чужой виджет, вставленный в чужое приложение, — и
/// занимало при этом половину экрана.

/// Парные столбцы доход/расход по месяцам.
///
/// Столбец набран из отдельных ячеек с зазором — как шкала на приборе,
/// а не сплошная заливка: у пиксельной графики нет полутонов, и высота
/// читается по числу ячеек.
class HairBarChart extends StatelessWidget {
  const HairBarChart({
    super.key,
    required this.groups,
    required this.incomeColor,
    required this.expenseColor,
    this.height = 150,
  });

  /// Подпись и пара значений на каждый период.
  final List<({String label, double income, double expense})> groups;
  final Color incomeColor;
  final Color expenseColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (groups.isEmpty) return SizedBox(height: height);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: height,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: AppMotion.flourish + const Duration(milliseconds: 300),
            curve: Curves.linear,
            builder: (context, progress, _) => CustomPaint(
              painter: _BarPainter(
                groups: groups,
                incomeColor: incomeColor,
                expenseColor: expenseColor,
                baseline: colors.divider,
                progress: progress,
              ),
            ),
          ),
        ),
        AppSpacing.gapSm,
        Row(
          children: [
            for (final group in groups)
              Expanded(
                child: Text(
                  group.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: context.text.mono,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter({
    required this.groups,
    required this.incomeColor,
    required this.expenseColor,
    required this.baseline,
    required this.progress,
  });

  final List<({String label, double income, double expense})> groups;
  final Color incomeColor;
  final Color expenseColor;
  final Color baseline;
  final double progress;

  /// Высота одной ячейки столбца и зазор между ячейками.

  @override
  void paint(Canvas canvas, Size size) {
    final maxValue = groups.fold<double>(
      0,
      (max, g) => math.max(max, math.max(g.income, g.expense)),
    );

    final axisY = size.height - AppRadius.hairline;
    canvas.drawRect(
      Rect.fromLTWH(0, axisY, size.width, AppRadius.hairline),
      Paint()..color = baseline,
    );

    if (maxValue <= 0) return;

    final slot = size.width / groups.length;
    final barWidth = (slot * 0.22).clamp(5.0, 16.0);
    final usable = axisY - 6;

    for (var i = 0; i < groups.length; i++) {
      final group = groups[i];
      final centre = slot * i + slot / 2;
      // Столбцы вырастают по очереди: у каждого своя доля общего прогресса.
      final local = ((progress * (groups.length + 2) - i) / 3).clamp(0.0, 1.0);
      final eased = Curves.easeOutCubic.transform(local);
      _bar(
        canvas,
        centre - barWidth - 1.5,
        barWidth,
        axisY,
        usable * group.income / maxValue * eased,
        incomeColor,
      );
      _bar(
        canvas,
        centre + 1.5,
        barWidth,
        axisY,
        usable * group.expense / maxValue * eased,
        expenseColor,
      );
    }
  }

  void _bar(
    Canvas canvas,
    double left,
    double width,
    double axisY,
    double height,
    Color color,
  ) {
    if (height <= 0) return;
    final rect = Rect.fromLTWH(left, axisY - height, width, height);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: const Radius.circular(2),
        topRight: const Radius.circular(2),
      ),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _BarPainter old) =>
      old.groups != groups ||
      old.incomeColor != incomeColor ||
      old.expenseColor != expenseColor ||
      old.baseline != baseline ||
      old.progress != progress;
}

/// Доли в общей сумме — одной горизонтальной полосой вместо кольца.
///
/// Кольцо fl_chart занимало 180px высоты ради двух чисел и всё равно
/// требовало легенду под собой, чтобы понять, что есть что. Полоса
/// занимает 26px, читается слева направо и стыкуется с легендой цветом.
class HairShareBar extends StatelessWidget {
  const HairShareBar({super.key, required this.shares, this.height = 26});

  /// Доли в порядке отрисовки: значение и цвет.
  final List<({double value, Color color})> shares;
  final double height;

  @override
  Widget build(BuildContext context) {
    final total = shares.fold<double>(0, (sum, s) => sum + s.value);
    if (total <= 0) return SizedBox(height: height);

    return SizedBox(
      height: height,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: AppMotion.flourish,
        curve: AppMotion.standard,
        builder: (context, t, _) => ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: t,
            child: ClipRRect(
              borderRadius: AppRadius.controlSmallAll,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < shares.length; i++) ...[
                    if (i > 0) const SizedBox(width: 2),
                    Expanded(
                      flex: math.max(
                        1,
                        (shares[i].value / total * 1000).round(),
                      ),
                      child: ColoredBox(color: shares[i].color),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HairSwatch extends StatelessWidget {
  const HairSwatch({super.key, required this.color, this.size = 14});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.controlTinyAll,
      ),
    );
  }
}
