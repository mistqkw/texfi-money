import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_page_transitions.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/entities/subscription_period.dart';
import '../../domain/entities/transaction_type.dart';
import '../settings/currency_provider.dart';
import '../shared/category_providers.dart';
import '../shared/pixel_card.dart';
import '../shared/pixel_fab.dart';
import '../shared/pixel_icon.dart';
import '../shared/staggered_entrance.dart';
import 'wealth_labels.dart';
import 'wealth_providers.dart';

/// Подписки — то, что списывается само.
///
/// Отдельно от транзакций, потому что отвечает на другой вопрос.
/// Транзакция говорит, что деньги ушли; подписка — что они будут уходить
/// и дальше, и вот столько в месяц.
class SubscriptionsScreen extends ConsumerWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currency = ref.watch(currencyProvider);
    final subs = ref.watch(allSubscriptionsProvider).valueOrNull ?? const [];
    final monthly = ref.watch(monthlySubscriptionCostProvider);
    final now = DateTime.now();

    final active = subs.where((s) => s.isActive).toList();
    final cancelled = subs.where((s) => !s.isActive).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.subscriptionsTitle)),
      floatingActionButton: PixelFab(
        onPressed: () => Navigator.of(context)
            .push(pixelDissolveRoute(const SubscriptionFormScreen())),
        pattern: PixelIcons.add,
        tooltip: l10n.subscriptionsAdd,
      ),
      body: ListView(
        padding: AppSpacing.screenWithFab,
        children: [
          PixelCard(
            label: l10n.subscriptionsMonthly.toLowerCase(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatAmount(monthly, currency, context),
                  style: context.text.amountLarge,
                ),
                AppSpacing.gapSm,
                Text(
                  l10n.subscriptionsMonthlyHint,
                  style: context.text.caption
                      .copyWith(color: colors.textTertiary),
                ),
              ],
            ),
          ),
          AppSpacing.gapLg,
          if (subs.isEmpty)
            Text(
              l10n.subscriptionsEmpty,
              style: context.text.body.copyWith(color: colors.textSecondary),
            ),
          for (var i = 0; i < active.length; i++)
            StaggeredEntrance(
              index: i,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _SubscriptionCard(sub: active[i], now: now),
              ),
            ),
          if (cancelled.isNotEmpty) ...[
            AppSpacing.gapLg,
            Text(
              l10n.subscriptionCancelled.toUpperCase(),
              style: context.text.label.copyWith(color: colors.textTertiary),
            ),
            AppSpacing.gapSm,
            for (final sub in cancelled)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _SubscriptionCard(sub: sub, now: now),
              ),
          ],
        ],
      ),
    );
  }
}

class _SubscriptionCard extends ConsumerWidget {
  const _SubscriptionCard({required this.sub, required this.now});

  final SubscriptionEntity sub;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currency = ref.watch(currencyProvider);
    final overdue = sub.daysUntilCharge(now) < 0;

    return PixelCard(
      onTap: () => Navigator.of(context).push(
        pixelDissolveRoute(SubscriptionFormScreen(existing: sub)),
      ),
      child: Row(
        children: [
          PixelIcon(
            PixelIcons.subscriptions,
            size: 20,
            color: sub.isActive ? colors.accent : colors.textTertiary,
          ),
          AppSpacing.gapHMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sub.name,
                  style: context.text.title.copyWith(
                    color: sub.isActive
                        ? colors.textPrimary
                        : colors.textTertiary,
                  ),
                ),
                Text(
                  '${periodLabel(l10n, sub.period)} · '
                  '${chargeLabel(l10n, sub, now)}',
                  style: context.text.caption.copyWith(
                    color: overdue && sub.isActive
                        ? colors.warning
                        : colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatAmount(sub.amount, currency, context),
                style: context.text.mono,
              ),
              // Месячный эквивалент показан только там, где он отличается
              // от самой суммы: у месячной подписки эти две строки были бы
              // одинаковыми и только шумели.
              if (sub.period != SubscriptionPeriod.monthly)
                Text(
                  '≈ ${formatAmount(sub.monthlyCost, currency, context)}'
                  ' / ${l10n.subscriptionsMonthly.toLowerCase()}',
                  style: context.text.caption
                      .copyWith(color: colors.textTertiary),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class SubscriptionFormScreen extends ConsumerStatefulWidget {
  const SubscriptionFormScreen({super.key, this.existing});

  final SubscriptionEntity? existing;

  @override
  ConsumerState<SubscriptionFormScreen> createState() =>
      _SubscriptionFormScreenState();
}

class _SubscriptionFormScreenState
    extends ConsumerState<SubscriptionFormScreen> {
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late final TextEditingController _amount = TextEditingController(
    text: widget.existing == null
        ? ''
        : widget.existing!.amount.toStringAsFixed(2),
  );
  late final TextEditingController _days = TextEditingController(
    text: widget.existing?.customDays?.toString() ?? '30',
  );

  late SubscriptionPeriod _period =
      widget.existing?.period ?? SubscriptionPeriod.monthly;
  late DateTime _next = widget.existing?.nextChargeAt ??
      DateTime.now().add(const Duration(days: 30));
  late String? _categoryId = widget.existing?.category?.id;
  late bool _active = widget.existing?.isActive ?? true;

  bool get _isNew => widget.existing == null;

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _days.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final amount = double.tryParse(_amount.text.replaceAll(',', '.'));
    if (name.isEmpty || amount == null) return;

    final repository = ref.read(subscriptionRepositoryProvider);
    final customDays = _period == SubscriptionPeriod.custom
        ? int.tryParse(_days.text)
        : null;

    if (_isNew) {
      await repository.create(
        name: name,
        amount: amount,
        period: _period,
        customDays: customDays,
        nextChargeAt: _next,
        categoryId: _categoryId,
      );
    } else {
      await repository.update(
        id: widget.existing!.id,
        name: name,
        amount: amount,
        period: _period,
        customDays: customDays,
        nextChargeAt: _next,
        categoryId: _categoryId,
      );
      await repository.setActive(id: widget.existing!.id, isActive: _active);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final categories =
        ref.watch(categoriesByTypeProvider(TransactionType.expense)).valueOrNull ??
            const [];

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? l10n.subscriptionNew : l10n.subscriptionEdit),
        actions: [
          if (!_isNew)
            IconButton(
              icon: PixelIcon(PixelIcons.danger, color: colors.expense),
              tooltip: l10n.commonDelete,
              onPressed: () async {
                await ref
                    .read(subscriptionRepositoryProvider)
                    .delete(widget.existing!.id);
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screen,
        children: [
          PixelCard(
            label: l10n.subscriptionName.toLowerCase(),
            child: TextField(
              controller: _name,
              decoration: const InputDecoration(border: InputBorder.none),
              style: context.text.body,
            ),
          ),
          AppSpacing.gapLg,
          PixelCard(
            label: l10n.subscriptionAmount.toLowerCase(),
            child: TextField(
              controller: _amount,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(border: InputBorder.none),
              style: context.text.amountMedium,
            ),
          ),
          AppSpacing.gapLg,
          PixelCard(
            label: l10n.subscriptionPeriod.toLowerCase(),
            child: Column(
              children: [
                for (final period in SubscriptionPeriod.values)
                  InkWell(
                    onTap: () => setState(() => _period = period),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              periodLabel(l10n, period),
                              style: context.text.body,
                            ),
                          ),
                          if (_period == period)
                            PixelIcon(
                              PixelIcons.check,
                              size: 16,
                              color: colors.accent,
                            ),
                        ],
                      ),
                    ),
                  ),
                if (_period == SubscriptionPeriod.custom)
                  TextField(
                    controller: _days,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.subscriptionCustomDays,
                    ),
                    style: context.text.body,
                  ),
              ],
            ),
          ),
          AppSpacing.gapLg,
          PixelCard(
            label: l10n.subscriptionNextCharge.toLowerCase(),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _next,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => _next = picked);
            },
            child: Text(formatDate(_next, context), style: context.text.body),
          ),
          AppSpacing.gapLg,
          PixelCard(
            label: l10n.reportsCategory.toLowerCase(),
            child: Column(
              children: [
                for (final category in categories)
                  InkWell(
                    onTap: () => setState(
                      () => _categoryId =
                          _categoryId == category.id ? null : category.id,
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Row(
                        children: [
                          PixelIcon(
                            PixelIcons.forCategoryKey(category.iconKey),
                            size: 18,
                            color: category.color,
                          ),
                          AppSpacing.gapHMd,
                          Expanded(
                            child:
                                Text(category.name, style: context.text.body),
                          ),
                          if (_categoryId == category.id)
                            PixelIcon(
                              PixelIcons.check,
                              size: 16,
                              color: colors.accent,
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (!_isNew) ...[
            AppSpacing.gapLg,
            PixelCard(
              child: Row(
                children: [
                  Expanded(
                    child: Text(l10n.subscriptionActive,
                        style: context.text.title),
                  ),
                  Switch(
                    value: _active,
                    onChanged: (value) => setState(() => _active = value),
                  ),
                ],
              ),
            ),
          ],
          AppSpacing.gapXl,
          FilledButton(onPressed: _save, child: Text(l10n.commonSave)),
        ],
      ),
    );
  }
}
