import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/banks.dart';

/// Фирменный знак банка в круге.
///
/// По умолчанию рисуется собственная абстрактная графика TexFi. Если в
/// `assets/banks/<id>.png` положен настоящий логотип — подставляется он
/// (см. assets/banks/README.md). Отсутствующий файл не ломает сборку:
/// [Image.asset] падает в `errorBuilder`, и мы молча возвращаемся к
/// нарисованному знаку.
class BankMark extends StatelessWidget {
  const BankMark({super.key, required this.bank, this.size = 36});

  final BankPreset bank;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bank.color.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        bank.assetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => CustomPaint(
          size: Size.square(size),
          painter: _BankGlyphPainter(glyph: bank.glyph, color: bank.color),
        ),
      ),
    );
  }
}

class _BankGlyphPainter extends CustomPainter {
  _BankGlyphPainter({required this.glyph, required this.color});

  final BankGlyph glyph;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final center = Offset(s / 2, s / 2);
    final stroke = (s * 0.11).clamp(1.5, 5.0);

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    switch (glyph) {
      case BankGlyph.ring:
        canvas.drawCircle(center, s * 0.26, line);

      case BankGlyph.dot:
        canvas.drawCircle(center, s * 0.2, fill);

      case BankGlyph.arc:
        // Разомкнутое кольцо — «движение вверх».
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: s * 0.26),
          -math.pi * 0.85,
          math.pi * 1.5,
          false,
          line,
        );

      case BankGlyph.bars:
        // Три растущих столбика.
        final w = s * 0.11;
        final base = s * 0.72;
        for (var i = 0; i < 3; i++) {
          final h = s * (0.18 + i * 0.12);
          final x = s * 0.3 + i * (w + s * 0.07);
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x, base - h, w, h),
              Radius.circular(w / 2),
            ),
            fill,
          );
        }

      case BankGlyph.shield:
        final path = Path()
          ..moveTo(s * 0.5, s * 0.24)
          ..lineTo(s * 0.74, s * 0.35)
          ..lineTo(s * 0.74, s * 0.55)
          ..quadraticBezierTo(s * 0.74, s * 0.7, s * 0.5, s * 0.78)
          ..quadraticBezierTo(s * 0.26, s * 0.7, s * 0.26, s * 0.55)
          ..lineTo(s * 0.26, s * 0.35)
          ..close();
        canvas.drawPath(path, fill);

      case BankGlyph.wave:
        final path = Path()..moveTo(s * 0.24, s * 0.58);
        path.cubicTo(s * 0.37, s * 0.34, s * 0.63, s * 0.74, s * 0.76, s * 0.44);
        canvas.drawPath(path, line);

      case BankGlyph.diamond:
        final path = Path()
          ..moveTo(s * 0.5, s * 0.24)
          ..lineTo(s * 0.74, s * 0.5)
          ..lineTo(s * 0.5, s * 0.76)
          ..lineTo(s * 0.26, s * 0.5)
          ..close();
        canvas.drawPath(path, fill);

      case BankGlyph.blocks:
        // Два смещённых квадрата — «слоями».
        final side = s * 0.24;
        final r = Radius.circular(s * 0.05);
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(s * 0.24, s * 0.24, side, side), r),
          fill,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(s * 0.5, s * 0.5, side, side), r),
          fill..color = color.withValues(alpha: 0.55),
        );
    }
  }

  @override
  bool shouldRepaint(covariant _BankGlyphPainter oldDelegate) =>
      glyph != oldDelegate.glyph || color != oldDelegate.color;
}
