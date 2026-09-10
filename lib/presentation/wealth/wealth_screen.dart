import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/currencies.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_page_transitions.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/asset_entity.dart';
import '../../domain/entities/cash_flow_type.dart';
import '../../domain/entities/net_worth.dart';
import '../../domain/entities/wealth_rules.dart';
import '../settings/currency_provider.dart';
import '../shared/pixel_fab.dart';
import '../shared/pixel_icon.dart';
import '../shared/staggered_entrance.dart';
import '../shared/terminal_box.dart';
import 'asset_form_screen.dart';
import 'cash_flow_screen.dart';
import 'reports_screen.dart';
import 'subscriptions_screen.dart';
import 'wealth_labels.dart';
import 'wealth_providers.dart';

/// Капитал: сколько всего, куда оно движется и во что вложено.
///
/// Экран надстроечный. Он ничего не знает про транзакции и не влияет на
/// них: трекер расходов работает ровно так же, если сюда не заходить.
class WealthScreen extends ConsumerWidget {
  const WealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currency = ref.watch(currencyProvider);
    final assets = ref.watch(assetsProvider).valueOrNull ?? const [];
    final snapshot = ref.watch(netWorthProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wealthTitle),
        actions: [
          IconButton(
            icon: const PixelIcon(PixelIcons.subscriptions),
            tooltip: l10n.subscriptionsTitle,
            onPressed: () => Navigator.of(context)
                .push(pixelDissolveRoute(const SubscriptionsScreen())),
          ),
          IconButton(
            icon: const PixelIcon(PixelIcons.reports),
            tooltip: l10n.reportsTitle,
            onPressed: () => Navigator.of(context)
                .push(pixelDissolveRoute(const ReportsScreen())),
          ),
        ],
      ),
      floatingActionButton: PixelFab(
        onPressed: () => Navigator.of(context)
            .push(pixelDissolveRoute(const AssetFormScreen())),
        pattern: PixelIcons.add,
        tooltip: l10n.wealthAddAsset,
      ),
      body: ListView(
        padding: AppSpacing.screenWithFab,
        children: [
          _TotalCard(snapshot: snapshot),
          AppSpacing.gapLg,
          const _YearChangeCard(),
          AppSpacing.gapLg,
          const _RiskWarnings(),
          const _AdviceCard(),
          if (assets.isNotEmpty) ...[
            _CategoryShares(currency: currency),
            AppSpacing.gapLg,
            _CashFlowShares(currency: currency),
            AppSpacing.gapLg,
            _RiskShares(currency: currency),
            AppSpacing.gapLg,
            _AssetList(assets: assets),
            AppSpacing.gapLg,
          ],
          _QuickLinks(),
          AppSpacing.gapLg,
          // Честная граница возможностей: приложение офлайновое и ничего
          // не знает о том, сколько что стоит на самом деле.
          Text(
            l10n.wealthOffline,
            style: context.text.caption.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _TotalCard extends ConsumerWidget {
  const _TotalCard({required this.snapshot});

  final NetWorthSnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currency = ref.watch(currencyProvider);
    final assets = ref.watch(assetsProvider).valueOrNull ?? const [];

    if (assets.isEmpty) {
      return TerminalBox(
        label: l10n.wealthTitle.toLowerCase(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.wealthEmptyTitle, style: context.text.title),
            AppSpacing.gapSm,
            Text(
              l10n.wealthEmptyBody,
              style: context.text.body.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      );
    }

    return TerminalBox(
      label: l10n.wealthTotal.toLowerCase(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatAmount(snapshot.total, currency, context),
            // Капитал может быть отрицательным, и цвет это говорит раньше
            // текста — как и на суммах в остальном приложении.
            style: context.text.balance.copyWith(
              color: snapshot.total < 0 ? colors.expense : colors.textPrimary,
            ),
          ),
          AppSpacing.gapMd,
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: l10n.wealthAssets,
                  value: formatAmount(snapshot.assets, currency, context),
                  color: colors.income,
                ),
              ),
              Expanded(
                child: _MiniStat(
                  label: l10n.wealthLiabilities,
                  value: formatAmount(snapshot.liabilities, currency, context),
                  color: colors.expense,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: context.text.label.copyWith(color: context.colors.textTertiary),
        ),
        AppSpacing.gapXs,
        Text(value, style: context.text.amountMedium.copyWith(color: color)),
      ],
    );
  }
}

class _YearChangeCard extends ConsumerWidget {
  const _YearChangeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currency = ref.watch(currencyProvider);
    final change = ref.watch(netWorthYearChangeProvider).valueOrNull;

    if (change == null) return const SizedBox.shrink();

    // Без базы сравнения показываем это словами, а не нулём: ноль читался
    // бы как «капитал не изменился», хотя года назад его просто не с чем
    // сравнить.
    if (change.from <= 0) {
      return TerminalBox(
        label: l10n.wealthYearChange.toLowerCase(),
        child: Text(
          l10n.wealthYearChangeNoBase,
          style: context.text.body.copyWith(color: colors.textSecondary),
        ),
      );
    }

    final grew = change.absolute >= 0;
    final color = grew ? colors.income : colors.expense;
    final percent = change.percent;

    return TerminalBox(
      label: l10n.wealthYearChange.toLowerCase(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PixelIcon(
            grew ? PixelIcons.flowIncome : PixelIcons.flowLiability,
            size: 24,
            color: color,
          ),
          AppSpacing.gapHMd,
          Expanded(
            child: Text(
              '${grew ? '+' : ''}'
              '${formatAmount(change.absolute, currency, context)}',
              style: context.text.amountMedium.copyWith(color: color),
            ),
          ),
          if (percent != null)
            Text(
              '${grew ? '+' : ''}${percent.toStringAsFixed(1)}%',
              style: context.text.title.copyWith(color: color),
            ),
        ],
      ),
    );
  }
}

/// Предупреждение о превышении собственного порога риска.
///
/// Не блокирующее и не ругательное: приложение замечает, а не воспитывает.
/// Порог поставил сам человек, и единственное, что здесь происходит, —
/// ему об этом напоминают числами, которые он же и ввёл.
class _RiskWarnings extends ConsumerWidget {
  const _RiskWarnings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final breaches = ref.watch(riskBreachesProvider);
    if (breaches.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        for (final breach in breaches) ...[
          TerminalBox(
            label: l10n.riskBreachTitle.toLowerCase(),
            borderColor: colors.warning,
            labelColor: colors.warning,
            child: Row(
              children: [
                PixelIcon(PixelIcons.risk, size: 24, color: colors.warning),
                AppSpacing.gapHMd,
                Expanded(
                  child: Text(
                    l10n.riskBreachBody(
                      breach.level.name,
                      breach.actualPercent.toStringAsFixed(0),
                      breach.limitPercent.toStringAsFixed(0),
                    ),
                    style: context.text.body,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapLg,
        ],
      ],
    );
  }
}

class _AdviceCard extends ConsumerWidget {
  const _AdviceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final advice = ref.watch(adviceProvider).valueOrNull ?? const [];

    // Превышения порога уже показаны отдельной карточкой выше — здесь они
    // были бы повтором одного и того же двумя способами подряд.
    final rest = advice
        .where((item) => item.kind != AdviceKind.riskOverLimit)
        .toList();
    if (rest.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        TerminalBox(
          label: l10n.adviceSection.toLowerCase(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in rest) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PixelIcon(
                      PixelIcons.advice,
                      size: 20,
                      color: colors.accent,
                    ),
                    AppSpacing.gapHMd,
                    Expanded(
                      child: Text(adviceText(l10n, item),
                          style: context.text.body),
                    ),
                  ],
                ),
                AppSpacing.gapMd,
              ],
              Text(
                l10n.adviceDisclaimer,
                style:
                    context.text.caption.copyWith(color: colors.textTertiary),
              ),
            ],
          ),
        ),
        AppSpacing.gapLg,
      ],
    );
  }
}

/// Полоска доли — вместо круговой диаграммы.
///
/// Донат показывает соотношение, но не даёт прочитать величины: чтобы
/// узнать, сколько именно в категории, приходится искать её в легенде.
/// Полоски стоят списком, отсортированы по убыванию, и каждая подписана
/// суммой и процентом — то, ради чего на распределение и смотрят.
class _ShareBar extends StatelessWidget {
  const _ShareBar({
    required this.label,
    required this.amount,
    required this.percent,
    required this.color,
    this.icon,
  });

  final String label;
  final String amount;
  final double percent;
  final Color color;
  final List<String>? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon case final icon?) ...[
                PixelIcon(icon, size: 16, color: color),
                AppSpacing.gapHSm,
              ],
              Expanded(child: Text(label, style: context.text.body)),
              Text(amount, style: context.text.mono),
              AppSpacing.gapHSm,
              SizedBox(
                width: 44,
                child: Text(
                  '${percent.toStringAsFixed(0)}%',
                  textAlign: TextAlign.right,
                  style: context.text.mono.copyWith(color: colors.textTertiary),
                ),
              ),
            ],
          ),
          AppSpacing.gapXs,
          // Дорожка и заливка — прямоугольники без скруглений: полоска
          // здесь того же материала, что и всё остальное на экране.
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(height: 6, color: colors.surfaceVariant),
                  Container(
                    height: 6,
                    width: constraints.maxWidth * (percent / 100).clamp(0, 1),
                    color: color,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryShares extends ConsumerWidget {
  const _CategoryShares({required this.currency});

  final AppCurrency currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final shares = ref.watch(categorySharesProvider);

    return TerminalBox(
      label: l10n.wealthByCategory.toLowerCase(),
      child: Column(
        children: [
          for (final share in shares)
            _ShareBar(
              label: share.key.name,
              amount: formatAmount(share.amount, currency, context),
              percent: share.percent,
              color: share.key.color,
              icon: PixelIcons.forCategoryKey(share.key.iconKey),
            ),
        ],
      ),
    );
  }
}

class _CashFlowShares extends ConsumerWidget {
  const _CashFlowShares({required this.currency});

  final AppCurrency currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final shares = ref.watch(cashFlowSharesProvider);

    return TerminalBox(
      label: l10n.wealthByCashFlow.toLowerCase(),
      child: Column(
        children: [
          for (final share in shares)
            _ShareBar(
              label: cashFlowLabel(l10n, share.key),
              amount: formatAmount(share.amount, currency, context),
              percent: share.percent,
              color: switch (share.key) {
                CashFlowType.income => colors.income,
                CashFlowType.liability => colors.expense,
                CashFlowType.neutral => colors.textSecondary,
              },
              icon: cashFlowIcon(share.key),
            ),
        ],
      ),
    );
  }
}

class _RiskShares extends ConsumerWidget {
  const _RiskShares({required this.currency});

  final AppCurrency currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final shares = ref.watch(riskSharesProvider);

    return TerminalBox(
      label: l10n.wealthByRisk.toLowerCase(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final share in shares)
            _ShareBar(
              label: share.key.maxSharePercent == null
                  ? share.key.name
                  : '${share.key.name} · ≤ '
                      '${share.key.maxSharePercent!.toStringAsFixed(0)}%',
              amount: formatAmount(share.amount, currency, context),
              percent: share.percent,
              color: share.key.color,
              icon: PixelIcons.risk,
            ),
          Text(
            l10n.riskLimitHint,
            style: context.text.caption.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _AssetList extends ConsumerWidget {
  const _AssetList({required this.assets});

  final List<AssetEntity> assets;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currency = ref.watch(currencyProvider);

    return TerminalBox(
      label: l10n.wealthAssetsList.toLowerCase(),
      child: Column(
        children: [
          for (var i = 0; i < assets.length; i++)
            StaggeredEntrance(
              index: i,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  pixelDissolveRoute(AssetFormScreen(existing: assets[i])),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      PixelIcon(
                        PixelIcons.forCategoryKey(assets[i].category.iconKey),
                        size: 20,
                        color: assets[i].category.color,
                      ),
                      AppSpacing.gapHMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(assets[i].name, style: context.text.body),
                            Text(
                              cashFlowLabel(l10n, assets[i].cashFlowType),
                              style: context.text.caption
                                  .copyWith(color: colors.textTertiary),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formatAmount(assets[i].currentValue, currency, context),
                        style: context.text.mono,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickLinks extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currency = ref.watch(currencyProvider);
    final monthly = ref.watch(monthlySubscriptionCostProvider);

    return Column(
      children: [
        _LinkTile(
          icon: PixelIcons.subscriptions,
          title: l10n.subscriptionsTitle,
          trailing: monthly > 0
              ? '${formatAmount(monthly, currency, context)} / ${l10n.subscriptionsMonthly.toLowerCase()}'
              : null,
          onTap: () => Navigator.of(context)
              .push(pixelDissolveRoute(const SubscriptionsScreen())),
        ),
        AppSpacing.gapMd,
        _LinkTile(
          icon: PixelIcons.cashFlow,
          title: l10n.cashFlowTitle,
          onTap: () => Navigator.of(context)
              .push(pixelDissolveRoute(const CashFlowScreen())),
        ),
        AppSpacing.gapMd,
        _LinkTile(
          icon: PixelIcons.reports,
          title: l10n.reportsTitle,
          onTap: () => Navigator.of(context)
              .push(pixelDissolveRoute(const ReportsScreen())),
        ),
      ],
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  final List<String> icon;
  final String title;
  final String? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TerminalBox(
      onTap: onTap,
      child: Row(
        children: [
          PixelIcon(icon, size: 20, color: colors.accent),
          AppSpacing.gapHMd,
          Expanded(child: Text(title, style: context.text.title)),
          if (trailing case final trailing?)
            Text(
              trailing,
              style: context.text.caption.copyWith(color: colors.textTertiary),
            ),
          AppSpacing.gapHSm,
          PixelIcon(
            PixelIcons.chevronRight,
            size: 14,
            color: colors.textTertiary,
          ),
        ],
      ),
    );
  }
}
