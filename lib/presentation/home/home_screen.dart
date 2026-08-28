import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../add_transaction/add_transaction_screen.dart';
import '../categories/categories_screen.dart';
import '../settings/currency_picker_screen.dart';
import '../settings/currency_provider.dart';
import '../settings/settings_screen.dart';
import '../shared/animated_amount.dart';
import '../shared/transaction_tile.dart';
import 'home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(totalBalanceProvider);
    final summaryAsync = ref.watch(monthlySummaryProvider);
    final recentAsync = ref.watch(recentTransactionsProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TexFi m0ney'),
        actions: [
          IconButton(
            icon: Text(currency.symbol, style: context.text.title),
            tooltip: 'Валюта: ${currency.displayName}',
            onPressed: () => Navigator.of(context).push(
              fadeSlideRoute(const CurrencyPickerScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Категории',
            onPressed: () => Navigator.of(context).push(
              fadeSlideRoute(const CategoriesScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Настройки',
            onPressed: () => Navigator.of(context).push(
              fadeSlideRoute(const SettingsScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_transaction_fab',
        onPressed: () => Navigator.of(context).push(
          fadeSlideRoute(const AddTransactionScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
          children: [
            _BalanceCard(balance: balanceAsync.valueOrNull ?? 0),
            const SizedBox(height: 16),
            summaryAsync.when(
              data: (summary) => Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: 'Доход за месяц',
                      value: summary.income,
                      icon: Icons.arrow_downward_rounded,
                      color: context.colors.income,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      label: 'Расход за месяц',
                      value: summary.expense,
                      icon: Icons.arrow_upward_rounded,
                      color: context.colors.expense,
                    ),
                  ),
                ],
              ),
              loading: () => const SizedBox(height: 92),
              error: (e, st) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 28),
            Text('Последние транзакции', style: context.text.headline),
            const SizedBox(height: 8),
            recentAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'Пока нет транзакций — добавьте первую кнопкой «+»',
                      style: context.text.body,
                    ),
                  );
                }
                return Column(
                  children: [
                    for (int i = 0; i < transactions.length; i++) ...[
                      TransactionTile(transaction: transactions[i]),
                      if (i != transactions.length - 1)
                        const Divider(height: 1),
                    ],
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) => Text('Не удалось загрузить транзакции', style: context.text.body),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.largeAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Баланс', style: context.text.label),
          const SizedBox(height: 8),
          AnimatedAmount(value: balance, style: context.text.balance),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final double value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.mediumAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: context.text.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedAmount(value: value, style: context.text.amountMedium.copyWith(color: color)),
        ],
      ),
    );
  }
}
