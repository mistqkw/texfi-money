import 'package:flutter/material.dart';

import '../../core/theme/app_l10n_ext.dart';
import '../budgets/budgets_screen.dart';
import '../goals/goals_screen.dart';
import '../statistics/statistics_screen.dart';
import '../wealth/wealth_screen.dart';
import 'pixel_segments.dart';

/// Вкладка, внутри которой живут два родственных раздела.
///
/// Внизу было шесть вкладок. Material-навбар сжимал их подписи до
/// нечитаемых обрубков, и главное — шесть равнозначных пунктов не
/// складывались в структуру: «Бюджеты» и «Цели» — это одно и то же
/// занятие (сколько я собираюсь потратить и отложить), «Статистика» и
/// «Капитал» — тоже одно (что в итоге вышло). Теперь их четыре, и
/// переключение внутри пары идёт сегментами, а не отдельной вкладкой.
class GroupedTab extends StatefulWidget {
  const GroupedTab({
    super.key,
    required this.title,
    required this.labels,
    required this.pages,
  });

  final String title;
  final List<String> labels;
  final List<Widget> pages;

  @override
  State<GroupedTab> createState() => _GroupedTabState();
}

class _GroupedTabState extends State<GroupedTab> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: PixelSegments(
            labels: widget.labels,
            currentIndex: _index,
            onSelected: (i) => setState(() => _index = i),
          ),
        ),
      ),
      // IndexedStack, а не подмена ребёнка: у сегментов своя прокрутка и
      // своё состояние фильтров, и терять их при каждом переключении
      // означало бы наказывать за любопытство.
      body: IndexedStack(index: _index, children: widget.pages),
    );
  }
}

/// «План» — сколько я собираюсь потратить и сколько отложить.
class PlanTab extends StatelessWidget {
  const PlanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GroupedTab(
      title: l10n.navPlan,
      labels: [l10n.navBudgets, l10n.navGoals],
      pages: const [
        BudgetsScreen(embedded: true),
        GoalsScreen(embedded: true),
      ],
    );
  }
}

/// «Итоги» — что в результате вышло: по месяцам и в сумме накопленного.
class SummaryTab extends StatelessWidget {
  const SummaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GroupedTab(
      title: l10n.navSummary,
      labels: [l10n.navStatistics, l10n.navWealth],
      pages: const [
        StatisticsScreen(embedded: true),
        WealthScreen(embedded: true),
      ],
    );
  }
}
