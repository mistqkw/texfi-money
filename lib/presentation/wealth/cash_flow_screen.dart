import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../settings/analysis_range_provider.dart';
import '../settings/currency_provider.dart';
import '../shared/pixel_icon.dart';
import '../shared/pixel_spinner.dart';
import '../shared/terminal_box.dart';
import 'wealth_providers.dart';

/// Движение денег: сколько пришло, сколько ушло, сколько осталось.
///
/// Период берётся из общей настройки диапазона анализа, а не свой у этого
/// экрана. Иначе движение денег за год рядом с динамикой капитала за пять
/// лет — это два графика, которые нельзя сопоставить, хотя выглядят они
/// одинаково и стоят рядом.
class CashFlowScreen extends ConsumerWidget {
  const CashFlowScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currency = ref.watch(currencyProvider);
    final range = ref.watch(analysisRangeProvider).resolve(DateTime.now());
    final flow = ref.watch(cashFlowProvider((from: range.from, to: range.to)));
    final rates = ref.watch(savingsRateHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cashFlowTitle)),
      body: ListView(
        padding: AppSpacing.screen,
        children: [
          TerminalBox(
            label: l10n.reportsPeriod.toLowerCase(),
            child: Text(
              '${formatDate(range.from, context)} — '
              '${formatDate(range.to, context)}',
              style: context.text.body,
            ),
          ),
          AppSpacing.gapLg,
          flow.when(
            data: (data) => Column(
              children: [
                _FlowRow(
                  icon: PixelIcons.flowIncome,
                  label: l10n.cashFlowReceived,
                  amount: formatAmount(data.income, currency, context),
                  color: colors.income,
                ),
                AppSpacing.gapMd,
                _FlowRow(
                  icon: PixelIcons.flowLiability,
                  label: l10n.cashFlowSpent,
                  amount: formatAmount(data.expense, currency, context),
                  color: colors.expense,
                ),
                AppSpacing.gapMd,
                _FlowRow(
                  icon: PixelIcons.netWorth,
                  label: l10n.cashFlowSaved,
                  amount: formatAmount(data.saved, currency, context),
                  // Отрицательный остаток — это перерасход, и цвет должен
                  // сказать это раньше знака минуса.
                  color: data.saved < 0 ? colors.expense : colors.accent,
                ),
              ],
            ),
            loading: () => const Center(child: PixelSpinner()),
            error: (e, st) => Text(l10n.reportsEmpty, style: context.text.body),
          ),
          AppSpacing.gapXl,
          TerminalBox(
            label: l10n.savingsRateHistory.toLowerCase(),
            child: rates.when(
              data: (months) => _SavingsHistory(months: months),
              loading: () => const Center(child: PixelSpinner()),
              error: (e, st) =>
                  Text(l10n.reportsEmpty, style: context.text.body),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowRow extends StatelessWidget {
  const _FlowRow({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  final List<String> icon;
  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TerminalBox(
      child: Row(
        children: [
          PixelIcon(icon, size: 22, color: color),
          AppSpacing.gapHMd,
          Expanded(child: Text(label, style: context.text.title)),
          Text(amount, style: context.text.amountMedium.copyWith(color: color)),
        ],
      ),
    );
  }
}

/// Процент сбережений помесячно.
///
/// Столбики, а не линия: месяцы дискретны, и линия между ними обещала бы
/// промежуточные значения, которых не существует. Месяц без дохода —
/// пропуск, а не ноль.
class _SavingsHistory extends StatelessWidget {
  const _SavingsHistory({required this.months});

  final List<({DateTime month, double? rate})> months;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    // Хвост, а не всё: на пятилетнем диапазоне это шестьдесят столбиков,
    // из которых на экране телефона различимы последние полтора десятка.
    final shown = months.length > 18
        ? months.sublist(months.length - 18)
        : months;
    if (shown.isEmpty) {
      return Text(l10n.reportsEmpty, style: context.text.body);
    }

    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final entry in shown)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (entry.rate case final rate?)
                      Container(
                        height: (rate.clamp(0, 100) / 100 * 110).toDouble(),
                        color: rate < 0 ? colors.expense : colors.accent,
                      )
                    else
                      // Месяца без дохода не было бы честно рисовать
                      // нулевым столбиком: ноль означал бы «ничего не
                      // сберёг», а здесь нечего было сберегать.
                      Container(height: 2, color: colors.divider),
                    AppSpacing.gapXs,
                    Text(
                      '${entry.month.month}',
                      style: context.text.caption
                          .copyWith(color: colors.textTertiary, fontSize: 9),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
