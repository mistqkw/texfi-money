import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/asset_entity.dart';
import '../shared/pixel_icon.dart';
import '../shared/terminal_box.dart';
import '../wealth/wealth_providers.dart';

/// Риск-менеджмент: уровни и пороги.
///
/// Оба редактируются, и это не украшение. Трёх градаций может не хватить,
/// а «высокий риск» у человека с депозитами и у человека с опционами —
/// разные вещи. Приложение не знает, что рискованно: оно знает только то,
/// что человек сам объявил, и сравнивает это с тем, что он сам считает
/// пределом.
class RiskSettingsScreen extends ConsumerWidget {
  const RiskSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final levels = ref.watch(riskLevelsProvider).valueOrNull ?? const [];
    final shares = ref.watch(riskSharesProvider);

    double actualFor(String id) {
      for (final share in shares) {
        if (share.key.id == id) return share.percent;
      }
      return 0;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.riskSection)),
      body: ListView(
        padding: AppSpacing.screen,
        children: [
          Text(
            l10n.riskLimitHint,
            style: context.text.body.copyWith(color: colors.textSecondary),
          ),
          AppSpacing.gapLg,
          for (final level in levels) ...[
            _LevelCard(level: level, actualPercent: actualFor(level.id)),
            AppSpacing.gapMd,
          ],
          AppSpacing.gapMd,
          OutlinedButton(
            onPressed: () => _addLevel(context, ref, levels.length),
            child: Text(l10n.riskAddLevel),
          ),
        ],
      ),
    );
  }

  Future<void> _addLevel(
    BuildContext context,
    WidgetRef ref,
    int existingCount,
  ) async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.riskLevelName),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;

    await ref.read(assetRepositoryProvider).createRiskLevel(
          name: name,
          // Новый уровень встаёт в конец шкалы: порядок задаёт смысл, а
          // куда именно его поместить, знает только автор.
          rank: existingCount,
          color: Colors.grey,
        );
  }
}

class _LevelCard extends ConsumerWidget {
  const _LevelCard({required this.level, required this.actualPercent});

  final RiskLevelEntity level;
  final double actualPercent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final limit = level.maxSharePercent;
    final over = limit != null && actualPercent > limit;

    return TerminalBox(
      borderColor: over ? colors.warning : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PixelIcon(PixelIcons.risk, size: 18, color: level.color),
              AppSpacing.gapHMd,
              Expanded(child: Text(level.name, style: context.text.title)),
              Text(
                '${actualPercent.toStringAsFixed(0)}%',
                style: context.text.mono.copyWith(
                  color: over ? colors.warning : colors.textSecondary,
                ),
              ),
              if (level.isCustom) ...[
                AppSpacing.gapHSm,
                InkWell(
                  onTap: () => _delete(context, ref),
                  child: PixelIcon(
                    PixelIcons.close,
                    size: 14,
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
          AppSpacing.gapSm,
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.riskLimitLabel(level.name),
                  style: context.text.caption
                      .copyWith(color: colors.textTertiary),
                ),
              ),
              Text(
                limit == null
                    ? l10n.riskNoLimit
                    : '${limit.toStringAsFixed(0)}%',
                style: context.text.mono,
              ),
            ],
          ),
          // Ползунок от нуля до ста, где ноль — это «порога нет».
          // Отдельного переключателя «включить лимит» нет намеренно: он
          // означал бы то же самое, что и крайнее левое положение.
          Slider(
            value: (limit ?? 0).clamp(0, 100),
            max: 100,
            divisions: 20,
            label: limit == null ? l10n.riskNoLimit : '${limit.round()}%',
            onChanged: (value) {
              ref.read(assetRepositoryProvider).updateRiskLevel(
                    id: level.id,
                    name: level.name,
                    color: level.color,
                    maxSharePercent: value <= 0 ? null : value,
                  );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final removed =
        await ref.read(assetRepositoryProvider).deleteRiskLevel(level.id);
    if (removed || !context.mounted) return;
    // Отказ объясняется, а не проглатывается: человек нажал и должен
    // понять, почему ничего не произошло.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.riskLevelInUse)),
    );
  }
}
