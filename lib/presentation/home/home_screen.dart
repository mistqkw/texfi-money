import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../add_transaction/add_transaction_screen.dart';
import '../categories/categories_screen.dart';
import '../settings/currency_picker_screen.dart';
import '../settings/currency_provider.dart';
import '../settings/settings_screen.dart';
import '../shared/animated_amount.dart';
import '../shared/l10n_helpers.dart';
import '../shared/terminal_box.dart';
import '../shared/terminal_divider.dart';
import '../shared/transaction_tile.dart';
import 'home_providers.dart';
import 'quick_entry_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(totalBalanceProvider);
    final summaryAsync = ref.watch(monthlySummaryProvider);
    final recentAsync = ref.watch(recentTransactionsProvider);
    final currency = ref.watch(currencyProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TexFi m0ney'),
        actions: [
          IconButton(
            icon: Text(currency.symbol, style: context.text.title),
            tooltip: l10n.homeCurrencyTooltip(currencyDisplayName(context, currency)),
            onPressed: () => Navigator.of(context).push(
              fadeSlideRoute(const CurrencyPickerScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: l10n.homeCategoriesTooltip,
            onPressed: () => Navigator.of(context).push(
              fadeSlideRoute(const CategoriesScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.homeSettingsTooltip,
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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
          children: [
            _BalanceCard(balance: balanceAsync.valueOrNull ?? 0),
            const SizedBox(height: 16),
            summaryAsync.when(
              data: (summary) => Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: l10n.homeIncomeThisMonth,
                      value: summary.income,
                      color: context.colors.income,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      label: l10n.homeExpenseThisMonth,
                      value: summary.expense,
                      color: context.colors.expense,
                    ),
                  ),
                ],
              ),
              loading: () => const SizedBox(height: 92),
              error: (e, st) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
            const QuickEntryBar(),
            const SizedBox(height: 28),
            TerminalDivider(label: l10n.homeRecentTransactions),
            const SizedBox(height: 12),
            recentAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      l10n.homeEmptyTransactions,
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
              error: (e, st) => Text(l10n.homeLoadTransactionsError, style: context.text.body),
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
    return TerminalBox(
      label: context.l10n.homeBalance.toLowerCase(),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedAmount(value: balance, style: context.text.balance),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TerminalBox(
      label: label.toLowerCase(),
      labelColor: color,
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
      child: AnimatedAmount(value: value, style: context.text.amountMedium.copyWith(color: color)),
    );
  }
}
