import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/haptics.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/quick_entry_parser.dart';
import '../shared/category_providers.dart';
import '../shared/l10n_helpers.dart';
import '../shared/pixel_card.dart';
import '../shared/pixel_icon.dart';
import '../shared/pixel_spinner.dart';

/// Фирменная фишка приложения: добавление транзакции одной командной
/// строкой — "-350 продукты обед" или "+5000 зарплата". Коммитит сразу.
class QuickEntryBar extends ConsumerStatefulWidget {
  const QuickEntryBar({super.key});

  @override
  ConsumerState<QuickEntryBar> createState() => _QuickEntryBarState();
}

class _QuickEntryBarState extends ConsumerState<QuickEntryBar> {
  final _controller = TextEditingController();
  bool _error = false;
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  CategoryEntity? _fallbackCategory(List<CategoryEntity> categories, TransactionType type) {
    final otherId = type == TransactionType.expense ? 'cat_other_expense' : 'cat_other_income';
    for (final c in categories) {
      if (c.id == otherId) return c;
    }
    return categories.isEmpty ? null : categories.first;
  }

  Future<void> _submit() async {
    final raw = parseQuickEntry(_controller.text);
    if (raw == null) {
      Haptics.error();
      setState(() => _error = true);
      return;
    }

    setState(() => _submitting = true);

    final categories = await ref.read(categoriesByTypeProvider(raw.type).future);
    if (!mounted) return;

    final records = [for (final c in categories) (id: c.id, name: categoryDisplayName(context, c))];
    final result = resolveQuickEntry(raw: raw, categoriesOfType: records);

    CategoryEntity? category;
    if (result.categoryId != null) {
      for (final c in categories) {
        if (c.id == result.categoryId) {
          category = c;
          break;
        }
      }
    }
    category ??= _fallbackCategory(categories, raw.type);

    if (category == null) {
      Haptics.error();
      setState(() {
        _error = true;
        _submitting = false;
      });
      return;
    }

    await ref.read(transactionRepositoryProvider).add(
          amount: result.amount,
          type: result.type,
          categoryId: category.id,
          date: result.date,
          note: result.note,
        );

    if (!mounted) return;
    result.type == TransactionType.income ? Haptics.income() : Haptics.expense();

    _controller.clear();
    setState(() {
      _error = false;
      _submitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final errorColor = context.colors.expense;

    return PixelCard(
      label: l10n.quickEntryLabel.toUpperCase(),
      borderColor: _error ? errorColor.withValues(alpha: 0.7) : null,
      padding: const EdgeInsets.fromLTRB(14, 18, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Здесь стоял терминальный промпт «❯». Приём был только в
              // m0ney — ни в f0kus, ни в files его нет, и на экране рядом
              // с пиксельными знаками он читался как ещё один визуальный
              // язык поверх общего.
              PixelIcon(PixelIcons.edit, size: 16, color: context.colors.accent),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: !_submitting,
                  style: context.text.title,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: l10n.quickEntryHint,
                    hintStyle: context.text.title.copyWith(color: context.colors.textTertiary),
                    contentPadding: EdgeInsets.zero,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  onChanged: (_) {
                    if (_error) setState(() => _error = false);
                  },
                ),
              ),
              if (_submitting)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: PixelSpinner(size: 18),
                )
              else
                IconButton(
                  tooltip: l10n.commonAdd,
                  icon: const PixelIcon(PixelIcons.chevronRight, size: 20),
                  color: context.colors.accent,
                  visualDensity: VisualDensity.compact,
                  onPressed: _submit,
                ),
            ],
          ),
          // Подсказка про формат строки раньше висела здесь всегда — два
          // абзаца инструкции под полем, которое уже показывает пример в
          // плейсхолдере. Инструкция, которую читают один раз, не должна
          // занимать место каждый день; остаётся только сообщение об
          // ошибке разбора.
          AnimatedSize(
            duration: AppMotion.fast,
            alignment: Alignment.topLeft,
            child: _error
                ? Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: 2),
                    child: Text(
                      l10n.quickEntryParseError,
                      style: context.text.caption.copyWith(color: errorColor),
                      maxLines: 2,
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
