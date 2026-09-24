import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
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
class PixelBarChart extends StatelessWidget {
  const PixelBarChart({
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
          child: CustomPaint(
            painter: _BarPainter(
              groups: groups,
              incomeColor: incomeColor,
              expenseColor: expenseColor,
              baseline: colors.border,
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
  });

  final List<({String label, double income, double expense})> groups;
  final Color incomeColor;
  final Color expenseColor;
  final Color baseline;

  /// Высота одной ячейки столбца и зазор между ячейками.
  static const double _cell = 5;
  static const double _gap = 2;

  @override
  void paint(Canvas canvas, Size size) {
    final maxValue = groups.fold<double>(
      0,
      (max, g) => math.max(max, math.max(g.income, g.expense)),
    );

    final line = Paint()
      ..color = baseline
      ..style = PaintingStyle.fill;
    final axisY = size.height - AppRadius.pixelBorder;
    canvas.drawRect(Rect.fromLTWH(0, axisY, size.width, AppRadius.pixelBorder), line);

    if (maxValue <= 0) return;

    final slot = size.width / groups.length;
    // Ширина столбца — от ширины слота, но не уже читаемого минимума и не
    // шире трети слота: иначе на двух месяцах график превращается в две
    // широкие плиты, а на двенадцати — в нитки.
    final barWidth = (slot * 0.22).clamp(6.0, 18.0);
    final step = _cell + _gap;
    final maxCells = math.max(1, ((axisY - _gap) / step).floor());

    for (var i = 0; i < groups.length; i++) {
      final group = groups[i];
      final centre = slot * i + slot / 2;
      _paintBar(
        canvas,
        left: centre - barWidth - _gap / 2,
        width: barWidth,
        axisY: axisY,
        cells: _cells(group.income, maxValue, maxCells),
        color: incomeColor,
        step: step,
      );
      _paintBar(
        canvas,
        left: centre + _gap / 2,
        width: barWidth,
        axisY: axisY,
        cells: _cells(group.expense, maxValue, maxCells),
        color: expenseColor,
        step: step,
      );
    }
  }

  /// Ненулевое значение всегда даёт хотя бы одну ячейку: столбец в ноль
  /// пикселей сообщал бы «расходов не было», а не «расходы малы».
  int _cells(double value, double maxValue, int maxCells) {
    if (value <= 0) return 0;
    return math.max(1, (value / maxValue * maxCells).round());
  }

  void _paintBar(
    Canvas canvas, {
    required double left,
    required double width,
    required double axisY,
    required int cells,
    required Color color,
    required double step,
  }) {
    final paint = Paint()..color = color;
    for (var c = 0; c < cells; c++) {
      final top = axisY - _gap - (c + 1) * step + _gap;
      canvas.drawRect(Rect.fromLTWH(left, top, width, _cell), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter old) =>
      old.groups != groups ||
      old.incomeColor != incomeColor ||
      old.expenseColor != expenseColor ||
      old.baseline != baseline;
}

/// Доли в общей сумме — одной горизонтальной полосой вместо кольца.
///
/// Кольцо fl_chart занимало 180px высоты ради двух чисел и всё равно
/// требовало легенду под собой, чтобы понять, что есть что. Полоса
/// занимает 26px, читается слева направо и стыкуется с легендой цветом.
class PixelShareBar extends StatelessWidget {
  const PixelShareBar({super.key, required this.shares, this.height = 26});

  /// Доли в порядке отрисовки: значение и цвет.
  final List<({double value, Color color})> shares;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final total = shares.fold<double>(0, (sum, s) => sum + s.value);
    if (total <= 0) return SizedBox(height: height);

    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: colors.border, width: AppRadius.pixelBorder),
        borderRadius: AppRadius.controlSmallAll,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.controlSmallAll,
        child: Row(
          // Без stretch сегменты получают нулевую высоту: ColoredBox без
          // ребёнка сжимается по вертикали, а Row по умолчанию выравнивает
          // детей по центру, а не растягивает.
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < shares.length; i++) ...[
              if (i > 0) Container(width: AppRadius.pixelBorder, color: colors.border),
              Expanded(
                // flex целыми долями: доля меньше сотой всё равно занимает
                // одну единицу, иначе она исчезает из полосы совсем.
                flex: math.max(1, (shares[i].value / total * 1000).round()),
                child: ColoredBox(color: shares[i].color),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Квадратный образец цвета для легенды — тот же язык, что у рамок.
class PixelSwatch extends StatelessWidget {
  const PixelSwatch({super.key, required this.color, this.size = 14});

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
