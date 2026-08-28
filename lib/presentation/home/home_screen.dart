import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/transaction_entity.dart';
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

  Future<void> _deleteWithUndo(BuildContext context, WidgetRef ref, TransactionEntity tx) async {
    await ref.read(transactionRepositoryProvider).delete(tx.id);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.commonDeleted),
        action: SnackBarAction(
          label: context.l10n.commonUndo,
          onPressed: () => ref.read(transactionRepositoryProvider).add(
                amount: tx.amount,
                type: tx.type,
                categoryId: tx.category.id,
                date: tx.date,
                note: tx.note,
              ),
        ),
      ),
    );
  }

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
                      Dismissible(
                        key: ValueKey(transactions[i].id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.delete_outline, color: context.colors.expense),
                        ),
                        onDismissed: (_) => _deleteWithUndo(context, ref, transactions[i]),
                        child: TransactionTile(transaction: transactions[i]),
                      ),
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
        child: _PulsingBalance(value: balance, style: context.text.balance),
      ),
    );
  }
}

/// Баланс со «списание»-эффектом: при изменении значения (например, после
/// удаления транзакции свайпом) число не просто перематывается — вся цифра
/// слегка подпрыгивает и на миг вспыхивает цветом направления изменения.
class _PulsingBalance extends StatefulWidget {
  const _PulsingBalance({required this.value, required this.style});

  final double value;
  final TextStyle style;

  @override
  State<_PulsingBalance> createState() => _PulsingBalanceState();
}

class _PulsingBalanceState extends State<_PulsingBalance> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _increased = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppMotion.flourish);
  }

  @override
  void didUpdateWidget(covariant _PulsingBalance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _increased = widget.value > oldWidget.value;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flashColor = _increased ? context.colors.income : context.colors.expense;
    final amount = AnimatedAmount(value: widget.value, style: widget.style);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final riseFall = t < 0.3 ? t / 0.3 : (1 - (t - 0.3) / 0.7).clamp(0.0, 1.0);
        final scale = 1.0 + Curves.easeOut.transform(riseFall) * 0.05;
        final glow = (1 - t) * 0.4;

        return Transform.scale(
          scale: scale,
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: glow <= 0
                ? const BoxDecoration()
                : BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: flashColor.withValues(alpha: glow), blurRadius: 28, spreadRadius: 4),
                    ],
                  ),
            child: child,
          ),
        );
      },
      child: amount,
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
