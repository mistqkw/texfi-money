import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_palettes.dart';
import '../../core/theme/beta_options.dart';
import 'collage_blob.dart';

/// Фон беты «коллаж»: лист, три синих пятна разной глубины и сине-серый
/// прямоугольник — композиция картинки автора, разложенная по экрану
/// телефона.
///
/// Пятна уходят за края: целиком видимое пятно посреди экрана читается
/// как иллюстрация, обрезанное краем — как кусок бумаги, лежащий под
/// листом. Прямоугольник стоит слева сверху, за заголовком, как на
/// картинке он стоит за «TexFi».
///
/// Насколько пятна заметны — настройка беты (см. [CollageBlobs]):
/// сплошные, как на картинке, мешают читать мелкий серый текст поверх,
/// поэтому по умолчанию они приглушены.
class CollageBackground extends StatelessWidget {
  const CollageBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final blobs = context.betaOptions.collageBlobs;

    return DecoratedBox(
      decoration: BoxDecoration(color: colors.background),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (blobs != CollageBlobs.none)
            IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _CollagePainter(opacity: blobs.opacity),
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }
}

class _CollagePainter extends CustomPainter {
  const _CollagePainter({required this.opacity});

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    void blob(Rect bounds, int seed, Color color) {
      canvas.drawPath(
        CollageBlob.path(bounds, seed),
        Paint()..color = color.withValues(alpha: opacity),
      );
    }

    // Порядок — как на картинке: светлое пятно сверху справа, глубокое
    // снизу слева, среднее справа по центру; прямоугольник поверх.
    blob(Rect.fromLTWH(w * 0.42, -h * 0.07, w * 0.72, h * 0.2), 3, AppPalettes.collageBlue);
    blob(Rect.fromLTWH(w * 0.6, h * 0.4, w * 0.55, h * 0.24), 7, AppPalettes.collageBlueMid);
    blob(Rect.fromLTWH(-w * 0.14, h * 0.66, w * 0.5, h * 0.2), 11, AppPalettes.collageBlueDeep);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.05, h * 0.05, w * 0.13, h * 0.2),
      Paint()..color = AppPalettes.collageSlate.withValues(alpha: 0.9 * opacity),
    );
  }

  @override
  bool shouldRepaint(_CollagePainter oldDelegate) => oldDelegate.opacity != opacity;
}
