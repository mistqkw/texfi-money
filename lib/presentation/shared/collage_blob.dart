import 'package:flutter/widgets.dart';

import '../../core/theme/collage_shapes.dart';

export '../../core/theme/collage_shapes.dart';

/// Пятно как виджет: плоская заливка без обводки и теней.
class BlobShape extends StatelessWidget {
  const BlobShape({
    super.key,
    required this.seed,
    required this.color,
    this.morphTo,
    this.t = 0,
    this.calm = false,
    this.child,
  });

  final int seed;
  final Color color;
  final int? morphTo;
  final double t;

  /// Спокойная вырезка — подложка под словом, см. [CollageBlob.path].
  final bool calm;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BlobPainter(
        seed: seed,
        color: color,
        morphTo: morphTo,
        t: t,
        calm: calm,
      ),
      child: child,
    );
  }
}

class BlobPainter extends CustomPainter {
  const BlobPainter({
    required this.seed,
    required this.color,
    this.morphTo,
    this.t = 0,
    this.calm = false,
  });

  final int seed;
  final Color color;
  final int? morphTo;
  final double t;
  final bool calm;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      CollageBlob.path(
        Offset.zero & size,
        seed,
        morphTo: morphTo,
        t: t,
        calm: calm,
      ),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(BlobPainter oldDelegate) =>
      oldDelegate.seed != seed ||
      oldDelegate.color != color ||
      oldDelegate.morphTo != morphTo ||
      oldDelegate.t != t ||
      oldDelegate.calm != calm;
}
