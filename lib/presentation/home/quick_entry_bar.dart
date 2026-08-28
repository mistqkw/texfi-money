import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/quick_entry_parser.dart';
import '../shared/category_providers.dart';
import '../shared/l10n_helpers.dart';
import '../shared/terminal_box.dart';

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

    return TerminalBox(
      label: l10n.quickEntryLabel,
      borderColor: _error ? errorColor.withValues(alpha: 0.7) : null,
      padding: const EdgeInsets.fromLTRB(14, 18, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '❯',
                style: context.text.mono.copyWith(color: context.colors.accent, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: !_submitting,
                  style: context.text.mono.copyWith(color: context.colors.textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: l10n.quickEntryHint,
                    hintStyle: context.text.mono.copyWith(color: context.colors.textTertiary, fontSize: 13),
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
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                  color: context.colors.accent,
                  visualDensity: VisualDensity.compact,
                  onPressed: _submit,
                ),
            ],
          ),
          AnimatedSize(
            duration: AppMotion.fast,
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 2),
              child: Text(
                _error ? l10n.quickEntryParseError : l10n.quickEntryHelp,
                style: context.text.caption.copyWith(color: _error ? errorColor : null),
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
