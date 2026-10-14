import 'package:flutter/material.dart';

import '../../core/theme/app_l10n_ext.dart';
import '../history/history_screen.dart';
import '../home/home_screen.dart';
import 'grouped_tab.dart';
import 'hair_icon.dart';
import 'hair_nav_bar.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _pages = [
    HomeScreen(),
    HistoryScreen(),
    PlanTab(),
    SummaryTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: HairNavBar(
        currentIndex: _index,
        onSelected: (value) => setState(() => _index = value),
        items: [
          HairNavItem(icon: HairIcons.home, label: l10n.navHome),
          HairNavItem(icon: HairIcons.history, label: l10n.navHistory),
          // «План» и «Итоги» — не новые разделы, а две пары старых
          // вкладок: бюджеты с целями и статистика с капиталом. Шесть
          // равнозначных пунктов внизу не складывались в структуру и не
          // помещались подписями в Material-панель.
          HairNavItem(icon: HairIcons.budgets, label: l10n.navPlan),
          HairNavItem(icon: HairIcons.statistics, label: l10n.navSummary),
        ],
      ),
    );
  }
}
