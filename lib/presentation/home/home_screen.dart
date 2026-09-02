import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/banks.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/haptics.dart';
import '../../domain/entities/account_entity.dart';
import '../accounts/account_providers.dart';
import '../accounts/accounts_screen.dart';
import '../add_transaction/add_transaction_screen.dart';
import '../categories/categories_screen.dart';
import '../settings/currency_picker_screen.dart';
import '../settings/currency_provider.dart';
import '../settings/settings_screen.dart';
import '../shared/animated_amount.dart';
import '../shared/bank_mark.dart';
import '../shared/empty_state.dart';
import '../shared/l10n_helpers.dart';
import '../shared/pixel_fab.dart';
import '../shared/pixel_icon.dart';
import '../shared/terminal_box.dart';
import '../shared/terminal_divider.dart';
import '../shared/transaction_row.dart';
import 'home_providers.dart';
import 'nudge_card.dart';
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
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Text('TexFi m0ney', overflow: TextOverflow.ellipsis)),
            SizedBox(width: AppSpacing.sm),
            Flexible(child: _AccountMarks()),
          ],
        ),
        actions: [
          IconButton(
            icon: Text(currency.symbol, style: context.text.title),
            tooltip: l10n.homeCurrencyTooltip(currencyDisplayName(context, currency)),
            onPressed: () => Navigator.of(context).push(
              fadeSlideRoute(const CurrencyPickerScreen()),
            ),
          ),
          IconButton(
            icon: const PixelIcon(PixelIcons.category),
            tooltip: l10n.homeCategoriesTooltip,
            onPressed: () => Navigator.of(context).push(
              fadeSlideRoute(const CategoriesScreen()),
            ),
          ),
          IconButton(
            icon: const PixelIcon(PixelIcons.settings),
            tooltip: l10n.homeSettingsTooltip,
            onPressed: () => Navigator.of(context).push(
              fadeSlideRoute(const SettingsScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: PixelFab(
        heroTag: 'add_transaction_fab',
        onPressed: () {
          Haptics.select();
          Navigator.of(context).push(fadeSlideRoute(const AddTransactionScreen()));
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.md, AppSpacing.page, AppSpacing.fabSafeBottom),
          children: [
            _BalanceCard(balance: balanceAsync.valueOrNull ?? 0),
            AppSpacing.gapLg,
            const NudgeCard(),
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
                  const SizedBox(width: AppSpacing.md),
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
            AppSpacing.gapXl,
            TerminalDivider(label: l10n.homeRecentTransactions),
            AppSpacing.gapMd,
            recentAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return EmptyState(
                    icon: Icons.receipt_long_outlined,
                    message: l10n.homeEmptyTransactions,
                  );
                }
                return Column(
                  children: [
                    for (int i = 0; i < transactions.length; i++) ...[
                      TransactionRow(transaction: transactions[i]),
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

/// Знаки банков привязанных счетов — прямо в шапке рядом с названием.
/// Сразу видно, чьи деньги считаешь, без захода в «Счета». Тап ведёт
/// в управление счетами.
class _AccountMarks extends ConsumerWidget {
  const _AccountMarks();

  static const int _maxShown = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(allAccountsProvider).valueOrNull ?? const <AccountEntity>[];
    final banks = [
      for (final account in accounts) ?BankCatalog.byId(account.bankId),
    ];
    if (banks.isEmpty) return const SizedBox.shrink();

    final shown = banks.take(_maxShown).toList();
    final hidden = banks.length - shown.length;

    return GestureDetector(
      onTap: () {
        Haptics.select();
        Navigator.of(context).push(fadeSlideRoute(const AccountsScreen()));
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final bank in shown) ...[
            BankMark(bank: bank, size: 22),
            const SizedBox(width: AppSpacing.xs),
          ],
          if (hidden > 0)
            Text('+$hidden', style: context.text.mono.copyWith(fontSize: 11)),
        ],
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
      padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.xl, AppSpacing.page, AppSpacing.page),
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
  // Первое изменение — это переход из плейсхолдера (0 на время загрузки
  // стрима) в реальный баланс, а не настоящее событие. Вспышку показываем
  // только начиная со второго изменения.
  bool _sawFirstChange = false;

  @override
  void initState() {
    super.initState();
    // value: 1.0 — состояние покоя (свечение и подскок уже угасли). По
    // умолчанию AnimationController стартует с 0.0, что совпадает с началом
    // самой анимации (пик свечения) — из-за этого баланс светился, даже
    // если ни разу не проигрывалась ни одна вспышка.
    _controller = AnimationController(vsync: this, duration: AppMotion.flourish, value: 1.0);
  }

  @override
  void didUpdateWidget(covariant _PulsingBalance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (_sawFirstChange) {
        _increased = widget.value > oldWidget.value;
        _controller.forward(from: 0);
      }
      _sawFirstChange = true;
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
