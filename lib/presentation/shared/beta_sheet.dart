import 'package:flutter/material.dart';

import '../../core/theme/app_style_ext.dart';
import 'beta_glyph.dart';
import 'collage_background.dart';

/// Лист беты под текущий вариант: бумага со знаком или коллаж с пятнами.
/// Им подложено всё приложение и каждая страница при переходе — см.
/// `PixelDissolveTransition.betaSheetBuilder`.
class BetaSheet extends StatelessWidget {
  const BetaSheet({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return context.style.isCollage
        ? CollageBackground(child: child)
        : BetaBackground(child: child);
  }
}
