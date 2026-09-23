import 'package:flutter/material.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import 'pixel_button.dart';
import 'pixel_icon.dart';

/// Пустой раздел: пиксельный знак в рамке, короткая подсказка и — главное —
/// кнопка, которая этот раздел наполняет.
///
/// Раньше здесь были знак и строка текста, и всё. Экран честно сообщал,
/// что пусто, но не говорил, что с этим делать: кнопка добавления жила
/// внизу справа плавающим кружком, и на пустом экране взгляд к ней просто
/// не приходил. Пустой раздел — это момент, когда пользователь впервые
/// сюда зашёл, и единственный полезный ответ здесь — действие, а не
/// констатация.
///
/// Знак стал пиксельным. Material-иконка с тонкой обводкой посреди
/// интерфейса, целиком собранного из квадратов, читалась как вставка из
/// другого приложения.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.sprite,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  /// Спрайт из [PixelIcons] — 12×12, как все остальные знаки приложения.
  final List<String> sprite;

  final String message;

  /// Подпись действия. Вместе с [onAction] — либо оба, либо ни одного:
  /// кнопка без обработчика была бы ровно той пустышкой, которой в этом
  /// приложении быть не должно.
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = actionLabel;
    final action = onAction;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: AppMotion.slow,
          curve: AppMotion.standard,
          builder: (context, t, child) => Opacity(
            opacity: t,
            child: Transform.translate(offset: Offset(0, (1 - t) * 8), child: child),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: AppRadius.cardMediumAll,
                  border: Border.all(color: colors.border, width: 2),
                ),
                child: PixelIcon(sprite, size: 32, color: colors.textTertiary),
              ),
              AppSpacing.gapLg,
              Text(
                message,
                style: context.text.body,
                textAlign: TextAlign.center,
              ),
              if (label != null && action != null) ...[
                AppSpacing.gapXl,
                PixelButton(
                  label: label,
                  onPressed: action,
                  expand: false,
                  sprite: PixelIcons.add,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
